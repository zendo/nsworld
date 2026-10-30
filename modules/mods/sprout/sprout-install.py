#! @python3@/bin/python3 -B

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import tomllib
from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from typing import Any, Sequence


EFI_SYS_MOUNT_POINT = Path("@efiSysMountPoint@")
SPROUT_BINARY_SOURCE = Path("@sproutBinary@")

NIX = "@nix@/bin/nix-env"
EFIBOOTMGR = "@efibootmgr@/bin/efibootmgr"
FINDMNT = "@util-linux@/bin/findmnt"
LSBLK = "@util-linux@/bin/lsblk"

TIMEOUT = int("@timeout@")
CONFIGURATION_LIMIT = int("@configurationLimit@")

CAN_TOUCH_EFI_VARIABLES = "@canTouchEfiVariables@" == "1"
EFI_INSTALL_AS_REMOVABLE = "@efiInstallAsRemovable@" == "1"

FIRMWARE_ENTRY_LABEL = @firmwareEntryLabel@

DRIVERS: dict[str, str] = json.loads(r'''@drivers@''')

EXTRA_FILES: dict[str, str] = json.loads(r'''@extraFiles@''')

SETTINGS_FILE = Path("@settingsFile@")


def load_custom_settings() -> dict[str, Any]:
    if not SETTINGS_FILE.is_file():
        raise RuntimeError(
            f"custom settings file does not exist or is not a regular file: {SETTINGS_FILE}"
        )
    try:
        content = SETTINGS_FILE.read_text(encoding="utf-8")
        data = json.loads(content)
    except Exception as exc:
        raise RuntimeError(
            f"failed to read custom settings from {SETTINGS_FILE}: {exc}"
        ) from exc
    if not isinstance(data, dict):
        raise RuntimeError(
            f"settings file {SETTINGS_FILE} did not contain a JSON object"
        )
    return data


SPROUT_DIR = Path("EFI/Sprout")
NIXOS_DIR = SPROUT_DIR / "nixos"
DRIVERS_DIR = SPROUT_DIR / "drivers"
EXTRA_FILES_DIR = SPROUT_DIR / "extra-files"
SPROUT_BINARY = SPROUT_DIR / "sprout.efi"
SPROUT_CONFIG = Path("sprout.toml")

EXTRA_FILE_NAME_RE: re.Pattern[str] = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
VALUE_IDENTIFIER_RE: re.Pattern[str] = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
RESERVED_VALUE_PREFIX: str = "sprout_extra_file_"


def esp_path(relative: Path | str) -> Path:
    path = Path(relative)
    if path.is_absolute() or ".." in path.parts:
        raise RuntimeError(
            f"path {relative!r} is not a valid ESP-relative path"
        )
    return EFI_SYS_MOUNT_POINT / path

FIRMWARE_LOADER_PATH = r"\EFI\Sprout\sprout.efi"

_MACHINE_BOOT_FALLBACKS = {
    "x86_64": "BOOTX64.EFI",
    "amd64": "BOOTX64.EFI",
    "aarch64": "BOOTAA64.EFI",
    "arm64": "BOOTAA64.EFI",
}


libc = ctypes.CDLL(None, use_errno=True)


@dataclass(frozen=True)
class SystemIdentifier:
    profile: str | None
    generation: int


@dataclass(frozen=True)
class BootSpec:
    init: Path
    toplevel: Path
    label: str
    kernel: Path | None
    initrd: Path | None
    initrd_secrets: Path | None
    extra_initrds: tuple[Path, ...]
    kernel_params: tuple[str, ...]
    specialisations: dict[str, "BootSpec"]
    devicetree: Path | None = None


@dataclass(frozen=True)
class BootArtifact:
    destination: Path
    source: Path
    initrd_secrets: Path | None
    generation: int
    critical: bool


@dataclass(frozen=True)
class BootEntry:
    identifier: str
    title: str
    sort_key: str
    kernel: Path
    initrds: tuple[Path, ...]
    options: tuple[str, ...]
    artifacts: tuple[BootArtifact, ...]
    critical: bool


def run(
    command: Sequence[str | Path],
    *,
    stdout: Any = None,
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [str(part) for part in command],
        check=True,
        text=True,
        stdout=stdout,
        stderr=sys.stderr,
    )


def capture(command: Sequence[str | Path]) -> str:
    return run(command, stdout=subprocess.PIPE).stdout.strip()


def quote_toml(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def array_toml(values: Sequence[str]) -> str:
    return "[" + ", ".join(quote_toml(value) for value in values) + "]"


def uefi_path(relative: Path) -> str:
    return "\\" + "\\".join(relative.parts)


def fsync_path(path: Path) -> None:
    try:
        fd = os.open(path, os.O_RDONLY | os.O_DIRECTORY)
    except OSError:
        return

    try:
        os.fsync(fd)
    except OSError:
        pass
    finally:
        try:
            os.close(fd)
        except OSError:
            pass


def sync_filesystem(path: Path) -> None:
    fd = os.open(path, os.O_RDONLY | os.O_DIRECTORY)
    try:
        result = libc.syncfs(fd)
        if result != 0:
            error = ctypes.get_errno()
            if error != 0:
                raise OSError(error, os.strerror(error), str(path))
            raise OSError(f"could not sync {path}: syncfs failed")
    finally:
        try:
            os.close(fd)
        except OSError:
            pass


class SourceArtifactError(RuntimeError):
    """Raised when opening or reading a boot artifact source fails."""


def atomic_copy(
    source: Path,
    destination: Path,
    *,
    replace: bool,
) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)

    if not replace and destination.exists():
        return

    temporary_path: Path | None = None

    try:
        try:
            source_file = source.open("rb")
        except OSError as exc:
            raise SourceArtifactError(
                f"failed to open source artifact {source}: {exc}"
            ) from exc

        try:
            with tempfile.NamedTemporaryFile(
                mode="wb",
                dir=destination.parent,
                prefix=f".{destination.name}.",
                suffix=".tmp",
                delete=False,
            ) as temporary:
                temporary_path = Path(temporary.name)

            with temporary_path.open("wb") as target:
                while True:
                    try:
                        chunk = source_file.read(65536)
                    except OSError as exc:
                        raise SourceArtifactError(
                            f"failed to read source artifact {source}: {exc}"
                        ) from exc

                    if not chunk:
                        break

                    target.write(chunk)

                target.flush()
                os.fsync(target.fileno())
        finally:
            source_file.close()

        os.replace(temporary_path, destination)
        temporary_path = None
    finally:
        if temporary_path is not None:
            temporary_path.unlink(missing_ok=True)

    try:
        fsync_path(destination.parent)
    except OSError:
        pass


def atomic_write_text(
    destination: Path,
    contents: str,
) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)

    temporary_path: Path | None = None

    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            dir=destination.parent,
            prefix=f".{destination.name}.",
            suffix=".tmp",
            delete=False,
        ) as temporary:
            temporary_path = Path(temporary.name)
            temporary.write(contents)
            temporary.flush()
            os.fsync(temporary.fileno())

        os.replace(temporary_path, destination)
        temporary_path = None
    finally:
        if temporary_path is not None:
            temporary_path.unlink(missing_ok=True)

    try:
        fsync_path(destination.parent)
    except OSError:
        pass


def generation_directory(
    profile: str | None,
    generation: int,
) -> Path:
    if profile is None:
        return Path(f"/nix/var/nix/profiles/system-{generation}-link")

    return Path(
        f"/nix/var/nix/profiles/system-profiles/{profile}-{generation}-link"
    )


def system_directory(
    profile: str | None,
    generation: int,
    specialisation: str | None,
) -> Path:
    directory = generation_directory(profile, generation)

    if specialisation is None:
        return directory

    return directory / "specialisation" / specialisation


def get_generations(
    profile: str | None = None,
) -> list[SystemIdentifier]:
    profile_path = Path("/nix/var/nix/profiles/system")

    if profile is not None:
        profile_path = Path(
            f"/nix/var/nix/profiles/system-profiles/{profile}"
        )

    output = capture(
        [
            NIX,
            "--list-generations",
            "-p",
            profile_path,
        ]
    )

    generations: list[SystemIdentifier] = []

    for line in output.splitlines():
        fields = line.split()
        if not fields:
            continue

        try:
            generation = int(fields[0])
        except ValueError:
            continue

        generations.append(
            SystemIdentifier(
                profile=profile,
                generation=generation,
            )
        )

    if CONFIGURATION_LIMIT == 0:
        return generations

    return generations[-CONFIGURATION_LIMIT:]


def get_profiles() -> list[str]:
    directory = Path("/nix/var/nix/profiles/system-profiles")

    if not directory.is_dir():
        return []

    profiles: list[str] = []

    for entry in directory.iterdir():
        if entry.name.endswith("-link"):
            continue

        if entry.is_symlink():
            profiles.append(entry.name)

    return sorted(profiles)


def load_bootspec(
    profile: str | None,
    generation: int,
) -> BootSpec | None:
    system_path = system_directory(profile, generation, None)
    bootspec_path = (system_path / "boot.json").resolve()

    if not bootspec_path.is_file():
        print(
            "warning: skipping generation "
            f"{generation}"
            + (f" of profile {profile}" if profile else "")
            + f": {bootspec_path} does not exist",
            file=sys.stderr,
        )
        return None

    try:
        with bootspec_path.open("r", encoding="utf-8") as file:
            document = json.load(file)
    except ValueError as exc:
        print(
            f"error: malformed JSON in {bootspec_path}: {exc}",
            file=sys.stderr,
        )
        raise SystemExit(1) from exc

    return bootspec_from_json(document)


def bootspec_from_json(
    document: dict[str, Any],
) -> BootSpec:
    main = document.get("org.nixos.bootspec.v1")

    if not isinstance(main, dict):
        raise RuntimeError(
            'boot.json does not contain "org.nixos.bootspec.v1"'
        )

    if "init" not in main:
        raise RuntimeError(
            'boot.json does not contain "org.nixos.bootspec.v1.init"'
        )

    if "toplevel" not in main:
        raise RuntimeError(
            'boot.json does not contain "org.nixos.bootspec.v1.toplevel"'
        )

    kernel_value = main.get("kernel")
    initrd_value = main.get("initrd")
    initrd_secrets_value = main.get("initrdSecrets")

    kernel = Path(str(kernel_value)) if kernel_value is not None else None
    initrd = Path(str(initrd_value)) if initrd_value is not None else None
    initrd_secrets = (
        Path(str(initrd_secrets_value))
        if initrd_secrets_value is not None
        else None
    )

    extra_initrd_extension = document.get(
        "org.nixos.extra-initrd.v1",
        {},
    )

    if not isinstance(extra_initrd_extension, dict):
        raise RuntimeError(
            'boot.json contains an invalid "org.nixos.extra-initrd.v1" extension'
        )

    extra_initrd_values = extra_initrd_extension.get("paths", [])

    if not isinstance(extra_initrd_values, list):
        raise RuntimeError(
            'boot.json "org.nixos.extra-initrd.v1.paths" is not an array'
        )

    specialisation_document = document.get(
        "org.nixos.specialisation.v1",
        {},
    )

    if not isinstance(specialisation_document, dict):
        raise RuntimeError(
            'boot.json contains an invalid "org.nixos.specialisation.v1" extension'
        )

    specialisations = {
        name: bootspec_from_json(value)
        for name, value in specialisation_document.items()
    }

    kernel_params_value = main.get("kernelParams", [])

    if not isinstance(kernel_params_value, list):
        raise RuntimeError(
            'boot.json "kernelParams" is not an array'
        )

    devicetree_value = None

    if "org.nixos.systemd-boot" in document:
        systemd_boot_extension = document["org.nixos.systemd-boot"]

        if not isinstance(systemd_boot_extension, dict):
            raise RuntimeError(
                'boot.json contains an invalid "org.nixos.systemd-boot" extension'
            )

        devicetree_value = systemd_boot_extension.get("devicetree")

    if devicetree_value is not None and not isinstance(devicetree_value, str):
        raise RuntimeError(
            'boot.json "org.nixos.systemd-boot.devicetree" is not a string'
        )

    devicetree = (
        Path(devicetree_value)
        if devicetree_value is not None
        else None
    )

    return BootSpec(
        init=Path(str(main["init"])),
        toplevel=Path(str(main["toplevel"])),
        label=str(main.get("label", "")),
        kernel=kernel,
        initrd=initrd,
        initrd_secrets=initrd_secrets,
        extra_initrds=tuple(
            Path(str(path))
            for path in extra_initrd_values
        ),
        kernel_params=tuple(
            str(parameter)
            for parameter in kernel_params_value
        ),
        specialisations=specialisations,
        devicetree=devicetree,
    )


def artifact_path(
    kind: str,
    source: Path,
    extra: str = "",
) -> Path:
    identity = "\n".join(
        [
            kind,
            str(source.resolve()),
            extra,
        ]
    )

    digest = hashlib.sha256(
        identity.encode("utf-8")
    ).hexdigest()

    suffix = {
        "kernel": ".efi",
        "initrd": ".img",
        "extra-initrd": ".img",
    }[kind]

    return NIXOS_DIR / f"{kind}-{digest}{suffix}"


def specialisation_suffix(name: str) -> str:
    digest = hashlib.sha256(
        name.encode("utf-8")
    ).hexdigest()

    return digest[:12]


def profile_suffix(name: str) -> str:
    digest = hashlib.sha256(
        name.encode("utf-8")
    ).hexdigest()

    return digest[:12]


def entry_identifier(
    profile: str | None,
    generation: int,
    specialisation: str | None,
) -> str:
    if profile is None:
        identifier = f"nixos-g{generation}"
    else:
        profile_slug = re.sub(
            r"[^A-Za-z0-9._-]+",
            "-",
            profile,
        ).strip("-")
        suffix = profile_suffix(profile)

        if profile_slug:
            identifier = f"nixos-p-{profile_slug}-{suffix}-g{generation}"
        else:
            identifier = f"nixos-p-{suffix}-g{generation}"

    if specialisation is not None:
        identifier += f"-s-{specialisation_suffix(specialisation)}"

    return identifier


def entry_title(
    profile: str | None,
    generation: int,
    specialisation: str | None,
    bootspec: BootSpec,
) -> str:
    title = f"NixOS Generation {generation}"

    if profile is not None:
        title = f"NixOS {profile} Generation {generation}"

    if specialisation is not None:
        title += f" ({specialisation})"

    if bootspec.label:
        title += f": {bootspec.label}"

    return title


def prepare_entry(
    profile: str | None,
    generation: int,
    specialisation: str | None,
    bootspec: BootSpec,
    *,
    current_toplevel: Path,
) -> BootEntry | None:
    if specialisation is None:
        selected_bootspec = bootspec
    else:
        selected_bootspec = bootspec.specialisations[specialisation]

    critical = selected_bootspec.toplevel.resolve() == current_toplevel

    if selected_bootspec.devicetree is not None:
        message = (
            f"generation {generation}"
            + (
                f" of profile {profile}"
                if profile is not None
                else ""
            )
            + (
                f" specialisation {specialisation}"
                if specialisation is not None
                else ""
            )
            + f" requests devicetree {selected_bootspec.devicetree}; "
            + "devicetree is not supported by Sprout"
        )

        if critical:
            raise RuntimeError(message)

        print(f"warning: {message}; skipping", file=sys.stderr)
        return None

    if selected_bootspec.kernel is None:
        message = (
            f"generation {generation}"
            + (
                f" of profile {profile}"
                if profile is not None
                else ""
            )
            + (
                f" specialisation {specialisation}"
                if specialisation is not None
                else ""
            )
            + " has no kernel in its BootSpec"
        )

        if critical:
            raise RuntimeError(message)

        print(f"warning: {message}; skipping", file=sys.stderr)
        return None

    required_sources = [selected_bootspec.kernel]

    if selected_bootspec.initrd is not None:
        required_sources.append(selected_bootspec.initrd)

    if selected_bootspec.initrd_secrets is not None:
        required_sources.append(selected_bootspec.initrd_secrets)

    missing_sources = [
        source
        for source in required_sources
        if not source.exists()
    ]

    if missing_sources:
        message = (
            f"generation {generation}"
            + (
                f" of profile {profile}"
                if profile is not None
                else ""
            )
            + (
                f" specialisation {specialisation}"
                if specialisation is not None
                else ""
            )
            + " references missing boot files: "
            + ", ".join(str(source) for source in missing_sources)
        )

        if critical:
            raise RuntimeError(message)

        print(f"warning: {message}; skipping", file=sys.stderr)
        return None

    for extra_initrd in selected_bootspec.extra_initrds:
        try:
            extra_path = esp_path(extra_initrd)
        except RuntimeError as exc:
            message = (
                f"generation {generation}"
                + (
                    f" of profile {profile}"
                    if profile is not None
                    else ""
                )
                + (
                    f" specialisation {specialisation}"
                    if specialisation is not None
                    else ""
                )
                + f" references invalid extra initrd path {extra_initrd}: {exc}"
            )
            if critical:
                raise RuntimeError(message) from exc

            print(f"warning: {message}; skipping", file=sys.stderr)
            return None

        if not extra_path.is_file():
            message = (
                f"generation {generation}"
                + (
                    f" of profile {profile}"
                    if profile is not None
                    else ""
                )
                + (
                    f" specialisation {specialisation}"
                    if specialisation is not None
                    else ""
                )
                + f" references missing extra initrd on ESP: {extra_initrd}"
            )
            if critical:
                raise RuntimeError(message)

            print(f"warning: {message}; skipping", file=sys.stderr)
            return None

    kernel_destination = artifact_path(
        "kernel",
        selected_bootspec.kernel,
    )

    artifacts = [
        BootArtifact(
            destination=kernel_destination,
            source=selected_bootspec.kernel,
            initrd_secrets=None,
            generation=generation,
            critical=critical,
        )
    ]

    initrd_destinations: list[Path] = []

    if selected_bootspec.initrd is not None:
        initrd_destination = artifact_path(
            "initrd",
            selected_bootspec.initrd,
            (
                str(selected_bootspec.initrd_secrets)
                if selected_bootspec.initrd_secrets is not None
                else ""
            ),
        )

        initrd_destinations.append(initrd_destination)

        artifacts.append(
            BootArtifact(
                destination=initrd_destination,
                source=selected_bootspec.initrd,
                initrd_secrets=selected_bootspec.initrd_secrets,
                generation=generation,
                critical=critical,
            )
        )

    initrds = tuple(
        initrd_destinations + list(selected_bootspec.extra_initrds)
    )

    identifier = entry_identifier(
        profile,
        generation,
        specialisation,
    )

    sort_key = f"{generation:020d}"

    options = (
        f"init={selected_bootspec.init}",
        *selected_bootspec.kernel_params,
    )

    return BootEntry(
        identifier=identifier,
        title=entry_title(
            profile,
            generation,
            specialisation,
            selected_bootspec,
        ),
        sort_key=sort_key,
        kernel=kernel_destination,
        initrds=initrds,
        options=tuple(options),
        artifacts=tuple(artifacts),
        critical=critical,
    )


def check_unique_identifiers(
    entries: Sequence[BootEntry],
) -> None:
    seen: set[str] = set()

    for entry in entries:
        if entry.identifier in seen:
            raise RuntimeError(
                f"duplicate boot entry identifier '{entry.identifier}'; "
                "refusing to publish configuration"
            )
        seen.add(entry.identifier)


def collect_entries(
    *,
    current_toplevel: Path,
) -> list[BootEntry]:
    generations = get_generations()

    for profile in get_profiles():
        generations.extend(
            get_generations(profile)
        )

    if not generations:
        raise RuntimeError(
            "no NixOS generations found in /nix/var/nix/profiles; "
            "refusing to remove all Sprout boot files"
        )

    entries: list[BootEntry] = []

    for identifier in generations:
        bootspec = load_bootspec(
            identifier.profile,
            identifier.generation,
        )

        if bootspec is None:
            continue

        main_entry = prepare_entry(
            identifier.profile,
            identifier.generation,
            None,
            bootspec,
            current_toplevel=current_toplevel,
        )

        if main_entry is not None:
            entries.append(main_entry)

        for specialisation in sorted(
            bootspec.specialisations
        ):
            specialisation_entry = prepare_entry(
                identifier.profile,
                identifier.generation,
                specialisation,
                bootspec,
                current_toplevel=current_toplevel,
            )

            if specialisation_entry is not None:
                entries.append(specialisation_entry)

    if not entries:
        raise RuntimeError(
            "no valid NixOS BootSpec entries found; "
            "refusing to remove all Sprout boot files"
        )

    if not any(entry.critical for entry in entries):
        raise RuntimeError(
            "the requested NixOS toplevel is not present in the "
            "selected generations; refusing to install a boot menu "
            "that cannot boot the target system"
        )

    check_unique_identifiers(entries)

    return entries


def write_initrd_with_secrets(
    artifact: BootArtifact,
) -> bool:
    assert artifact.initrd_secrets is not None

    destination = esp_path(artifact.destination)

    destination.parent.mkdir(
        parents=True,
        exist_ok=True,
    )

    temporary_path: Path | None = None

    try:
        with tempfile.NamedTemporaryFile(
            mode="wb",
            dir=destination.parent,
            prefix=f".{destination.name}.",
            suffix=".tmp",
            delete=False,
        ) as temporary:
            temporary_path = Path(temporary.name)

        with artifact.source.open("rb") as source_file, temporary_path.open(
            "wb"
        ) as target:
            shutil.copyfileobj(source_file, target)
            target.flush()
            os.fsync(target.fileno())

        try:
            run(
                [
                    artifact.initrd_secrets,
                    temporary_path,
                ]
            )
        except (subprocess.CalledProcessError, OSError):
            if artifact.critical:
                raise RuntimeError(
                    "failed to append initrd secrets to "
                    f"{artifact.source}"
                ) from None

            if destination.exists():
                print(
                    "warning: failed to update initrd secrets for older "
                    f"generation {artifact.generation}; keeping the previous "
                    "initrd",
                    file=sys.stderr,
                )
                return True

            print(
                "warning: failed to append initrd secrets to older "
                f"generation {artifact.generation}; omitting affected boot entries",
                file=sys.stderr,
            )
            return False

        with temporary_path.open("rb") as result:
            os.fsync(result.fileno())

        os.replace(
            temporary_path,
            destination,
        )
        temporary_path = None
    finally:
        if temporary_path is not None:
            temporary_path.unlink(missing_ok=True)

    try:
        fsync_path(destination.parent)
    except OSError:
        pass

    return True


def write_artifact(
    artifact: BootArtifact,
) -> bool:
    destination = esp_path(artifact.destination)
    already_existed = destination.exists()

    if artifact.initrd_secrets is not None:
        if (
            already_existed
            and not artifact.critical
        ):
            # Older generations can retain an existing valid initrd when
            # secret material is no longer available.
            return True

        success = write_initrd_with_secrets(artifact)
        if success and not already_existed:
            tx = StagedArtifactTransaction.current()
            if tx is not None and destination.exists():
                tx.record_created(destination)
        return success

    try:
        atomic_copy(
            artifact.source,
            destination,
            replace=False,
        )
    except SourceArtifactError as exc:
        if artifact.critical:
            raise RuntimeError(
                f"failed to read boot artifact source {artifact.source}"
            ) from exc

        print(
            "warning: failed to read boot artifact source "
            f"{artifact.source} for older generation {artifact.generation}; "
            "omitting affected boot entries",
            file=sys.stderr,
        )
        return False

    if not already_existed:
        tx = StagedArtifactTransaction.current()
        if tx is not None and destination.exists():
            tx.record_created(destination)

    return True


def write_boot_files(
    entries: Sequence[BootEntry],
) -> list[BootEntry]:
    artifacts: dict[Path, BootArtifact] = {}

    for entry in entries:
        for artifact in entry.artifacts:
            existing = artifacts.get(artifact.destination)

            if existing is None or (
                artifact.critical and not existing.critical
            ):
                artifacts[artifact.destination] = artifact

    available_artifacts: set[Path] = set()

    for destination, artifact in artifacts.items():
        if write_artifact(artifact):
            available_artifacts.add(destination)

    valid_entries: list[BootEntry] = []

    for entry in entries:
        if not all(
            artifact.destination in available_artifacts
            for artifact in entry.artifacts
        ):
            print(
                f"warning: boot entry {entry.identifier!r} references "
                "unavailable boot files; omitting from boot menu",
                file=sys.stderr,
            )
            continue

        missing_initrd = False
        for initrd in entry.initrds:
            try:
                target = esp_path(initrd)
                if not target.is_file():
                    missing_initrd = True
                    break
            except RuntimeError:
                missing_initrd = True
                break

        if missing_initrd:
            if entry.critical:
                raise RuntimeError(
                    f"boot entry {entry.identifier!r} references missing initrd on ESP"
                )
            print(
                f"warning: boot entry {entry.identifier!r} references "
                "unavailable boot files; omitting from boot menu",
                file=sys.stderr,
            )
            continue

        valid_entries.append(entry)

    return valid_entries


def driver_path(
    name: str,
    source: Path,
) -> Path:
    identity = "\n".join(
        [
            name,
            str(source.resolve()),
        ]
    )

    digest = hashlib.sha256(
        identity.encode("utf-8")
    ).hexdigest()

    return DRIVERS_DIR / f"{name}-{digest}.efi"


def install_drivers() -> dict[str, Path]:
    prepared: list[tuple[str, Path, Path]] = []

    for name, source_string in sorted(DRIVERS.items()):
        if not re.fullmatch(
            r"[A-Za-z0-9._-]+",
            name,
        ):
            raise RuntimeError(
                f"invalid Sprout driver name: {name!r}"
            )

        source = Path(source_string)

        if not source.is_file():
            raise RuntimeError(
                f"Sprout driver {name!r} does not exist: {source}"
            )

        destination = driver_path(name, source)
        prepared.append((name, source, destination))

    installed: dict[str, Path] = {}

    for name, source, destination in prepared:
        target = esp_path(destination)
        already_existed = target.exists()

        atomic_copy(
            source,
            target,
            replace=False,
        )

        if not already_existed:
            tx = StagedArtifactTransaction.current()
            if tx is not None and target.exists():
                tx.record_created(target)

        installed[name] = destination

    return installed


def install_extra_files(
    extra_files: dict[str, str | Path] | None = None,
) -> dict[str, Path]:
    if extra_files is None:
        raw_files = EXTRA_FILES
    else:
        raw_files = {k: str(v) for k, v in extra_files.items()}

    # Phase 1: Validate all names and source files, and prepare destination paths,
    # before copying any custom files.
    prepared: list[tuple[str, Path, Path, Path, str]] = []
    for name, source_str in sorted(raw_files.items()):
        if not isinstance(name, str) or not EXTRA_FILE_NAME_RE.fullmatch(name):
            raise RuntimeError(
                f"invalid extra file name {name!r}: must match [A-Za-z_][A-Za-z0-9_]*"
            )

        source_path = Path(source_str)
        if not source_path.exists():
            raise RuntimeError(
                f"extra file {name!r} source does not exist: {source_path}"
            )
        if not source_path.is_file():
            raise RuntimeError(
                f"extra file {name!r} source is not a regular file: {source_path}"
            )

        hasher = hashlib.sha256()
        try:
            with source_path.open("rb") as file:
                while chunk := file.read(65536):
                    hasher.update(chunk)
        except OSError as exc:
            raise RuntimeError(
                f"failed to read extra file {name!r} source {source_path}: {exc}"
            ) from exc

        digest = hasher.hexdigest()

        # Preserve source filename suffixes where practical
        source_suffixes = "".join(source_path.suffixes)
        if "/" in source_suffixes or "\\" in source_suffixes or ".." in source_suffixes:
            source_suffixes = ""

        dest_filename = f"{name}-{digest}{source_suffixes}"
        dest_rel = EXTRA_FILES_DIR / dest_filename
        if dest_rel.parent != EXTRA_FILES_DIR or ".." in dest_rel.parts:
            raise RuntimeError(
                f"extra file {name!r} destination {dest_rel} escapes dedicated directory {EXTRA_FILES_DIR}"
            )

        target = esp_path(dest_rel)
        prepared.append((name, source_path, dest_rel, target, digest))

    # Phase 2: Copy or verify existing content-addressed files
    installed: dict[str, Path] = {}
    for name, source_path, dest_rel, target, digest in prepared:
        already_existed = target.exists()
        if already_existed:
            if not target.is_file():
                raise RuntimeError(
                    f"destination for extra file {name!r} exists and is not a regular file: {target}"
                )
            target_hasher = hashlib.sha256()
            try:
                with target.open("rb") as file:
                    while chunk := file.read(65536):
                        target_hasher.update(chunk)
            except OSError as exc:
                raise RuntimeError(
                    f"failed to read existing extra file at {target}: {exc}"
                ) from exc
            if target_hasher.hexdigest() != digest:
                raise RuntimeError(
                    f"existing file at destination {target} does not match expected SHA-256 digest {digest}"
                )
        else:
            atomic_copy(
                source_path,
                target,
                replace=False,
            )
            tx = StagedArtifactTransaction.current()
            if tx is not None and target.exists():
                tx.record_created(target)

        installed[name] = dest_rel

    return installed


def generate_sprout_config(
    entries: Sequence[BootEntry],
    default_entry: str,
    drivers: dict[str, Path],
    settings: dict[str, Any] | None = None,
    extra_files: dict[str, Path] | None = None,
) -> str:
    if settings is None:
        settings = load_custom_settings()

    for key in settings:
        if key not in ("options", "entries", "actions", "phases", "values"):
            raise RuntimeError(f"unsupported custom settings section: {key!r}")

    options_cfg = settings.get("options", {})
    if not isinstance(options_cfg, dict):
        raise RuntimeError("custom settings 'options' must be a table")
    for opt_key in options_cfg:
        if opt_key != "menu-style":
            raise RuntimeError(
                f"unsupported or module-owned option in custom settings: {opt_key!r}"
            )
    menu_style = options_cfg.get("menu-style")
    if menu_style is not None and menu_style not in ("simple", "basic"):
        raise RuntimeError(f"invalid custom settings menu-style: {menu_style!r}")

    custom_entries = settings.get("entries", {})
    if not isinstance(custom_entries, dict):
        raise RuntimeError("custom settings 'entries' must be a table")

    custom_actions = settings.get("actions", {})
    if not isinstance(custom_actions, dict):
        raise RuntimeError("custom settings 'actions' must be a table")

    generated_entry_ids = {entry.identifier for entry in entries}
    generated_action_ids = set(generated_entry_ids)

    for entry_id, entry_dict in custom_entries.items():
        if not entry_id:
            raise RuntimeError("custom entry identifier cannot be empty")
        if entry_id.startswith("nixos-"):
            raise RuntimeError(
                f"custom entry identifier {entry_id!r} uses reserved 'nixos-' prefix"
            )
        if entry_id in generated_entry_ids:
            raise RuntimeError(
                f"custom entry identifier {entry_id!r} collides with generated NixOS entry"
            )
        if not isinstance(entry_dict, dict):
            raise RuntimeError(f"custom entry {entry_id!r} must be a table")
        if "title" not in entry_dict or not isinstance(entry_dict["title"], str):
            raise RuntimeError(f"custom entry {entry_id!r} requires 'title' string")
        acts = entry_dict.get("actions")
        if not isinstance(acts, list) or not acts:
            raise RuntimeError(
                f"custom entry {entry_id!r} must have a non-empty 'actions' list"
            )
        for act in acts:
            if not isinstance(act, str) or not act:
                raise RuntimeError(
                    f"custom entry {entry_id!r} contains invalid action reference {act!r}"
                )
            if act not in custom_actions:
                raise RuntimeError(
                    f"custom entry {entry_id!r} references unknown custom action {act!r}"
                )
        if entry_dict.get("values"):
            if not isinstance(entry_dict["values"], dict):
                raise RuntimeError(f"custom entry {entry_id!r} 'values' must be a table")
            for vk in entry_dict["values"]:
                if vk.startswith(RESERVED_VALUE_PREFIX):
                    raise RuntimeError(
                        f"custom entry {entry_id!r} value {vk!r} uses reserved {RESERVED_VALUE_PREFIX!r} prefix"
                    )

    for action_id, action_dict in custom_actions.items():
        if not action_id:
            raise RuntimeError("custom action identifier cannot be empty")
        if action_id.startswith("nixos-"):
            raise RuntimeError(
                f"custom action identifier {action_id!r} uses reserved 'nixos-' prefix"
            )
        if action_id in generated_action_ids:
            raise RuntimeError(
                f"custom action identifier {action_id!r} collides with generated NixOS action"
            )
        if not isinstance(action_dict, dict):
            raise RuntimeError(f"custom action {action_id!r} must be a table")

        variants = [k for k in ("chainload", "print", "edera") if k in action_dict]
        if len(variants) != 1:
            raise RuntimeError(
                f"custom action {action_id!r} must define exactly one variant (chainload, print, or edera); found {variants}"
            )
        for k in action_dict:
            if k not in ("chainload", "print", "edera"):
                raise RuntimeError(f"custom action {action_id!r} has unknown field: {k!r}")

        variant = variants[0]
        vdata = action_dict[variant]
        if not isinstance(vdata, dict):
            raise RuntimeError(f"custom action {action_id!r} variant {variant!r} must be a table")

        if variant == "chainload":
            if "path" not in vdata or not isinstance(vdata["path"], str):
                raise RuntimeError(f"custom action {action_id!r} chainload requires 'path' string")
            if vdata.get("linux-initrd") is not None and vdata.get("linux-initrd-chain"):
                raise RuntimeError(
                    f"custom action {action_id!r} specifies both 'linux-initrd' and 'linux-initrd-chain'"
                )
        elif variant == "print":
            text = vdata.get("text", "")
            if not isinstance(text, str):
                raise RuntimeError(f"custom action {action_id!r} print 'text' must be a string")
        elif variant == "edera":
            if "xen" not in vdata or not isinstance(vdata["xen"], str):
                raise RuntimeError(f"custom action {action_id!r} edera requires 'xen' string")
            if "kernel" not in vdata or not isinstance(vdata["kernel"], str):
                raise RuntimeError(f"custom action {action_id!r} edera requires 'kernel' string")
            if vdata.get("initrd") is not None and vdata.get("initrd-chain"):
                raise RuntimeError(
                    f"custom action {action_id!r} specifies both 'initrd' and 'initrd-chain'"
                )

    custom_phases = settings.get("phases")
    if custom_phases is not None:
        if not isinstance(custom_phases, dict):
            raise RuntimeError("custom settings 'phases' must be a table")
        valid_phase_names = {"early", "startup", "late"}
        for phase_name in custom_phases:
            if phase_name not in valid_phase_names:
                raise RuntimeError(
                    f"unsupported custom settings phase: {phase_name!r}"
                )
        for phase_name, phase_items in custom_phases.items():
            if not isinstance(phase_items, list):
                raise RuntimeError(
                    f"custom phase {phase_name!r} must be a list of phase configurations"
                )
            for item_idx, item in enumerate(phase_items):
                if not isinstance(item, dict):
                    raise RuntimeError(
                        f"custom phase {phase_name!r} item {item_idx} must be a table"
                    )
                for item_key in item:
                    if item_key not in ("actions", "values"):
                        raise RuntimeError(
                            f"custom phase {phase_name!r} item {item_idx} has unknown field: {item_key!r}"
                        )
                acts = item.get("actions")
                if not isinstance(acts, list) or not acts:
                    raise RuntimeError(
                        f"custom phase {phase_name!r} item {item_idx} must have a non-empty 'actions' list"
                    )
                for act in acts:
                    if not isinstance(act, str) or not act:
                        raise RuntimeError(
                            f"custom phase {phase_name!r} item {item_idx} contains invalid action reference {act!r}"
                        )
                    if act not in custom_actions:
                        raise RuntimeError(
                            f"custom phase {phase_name!r} item {item_idx} references unknown custom action {act!r}"
                        )
                vals = item.get("values")
                if vals is not None:
                    if not isinstance(vals, dict):
                        raise RuntimeError(
                            f"custom phase {phase_name!r} item {item_idx} 'values' must be a table"
                        )
                    for vk, vv in vals.items():
                        if not isinstance(vk, str) or not isinstance(vv, str):
                            raise RuntimeError(
                                f"custom phase {phase_name!r} item {item_idx} contains invalid 'values' table entry {vk!r}"
                            )
                        if vk.startswith(RESERVED_VALUE_PREFIX):
                            raise RuntimeError(
                                f"custom phase {phase_name!r} item {item_idx} value {vk!r} uses reserved {RESERVED_VALUE_PREFIX!r} prefix"
                            )

    custom_values = settings.get("values")
    if custom_values is not None:
        if not isinstance(custom_values, dict):
            raise RuntimeError("custom settings 'values' must be a table")
        for vk, vv in custom_values.items():
            if not isinstance(vk, str) or not VALUE_IDENTIFIER_RE.fullmatch(vk):
                raise RuntimeError(
                    f"custom settings value identifier {vk!r} must match [A-Za-z_][A-Za-z0-9_]*"
                )
            if vk.startswith(RESERVED_VALUE_PREFIX):
                raise RuntimeError(
                    f"custom settings value {vk!r} uses reserved {RESERVED_VALUE_PREFIX!r} prefix"
                )
            if not isinstance(vv, str):
                raise RuntimeError(
                    f"custom settings value {vk!r} must be a string, got {type(vv).__name__}"
                )

    lines: list[str] = [
        "version = 1",
        "",
        "[options]",
        f"default-entry = {quote_toml(default_entry)}",
        f"menu-timeout = {TIMEOUT}",
    ]

    if menu_style is not None:
        lines.append(f"menu-style = {quote_toml(menu_style)}")

    all_root_values: dict[str, str] = {}
    if custom_values:
        for vk, vv in custom_values.items():
            all_root_values[vk] = vv
    if extra_files:
        for name, dest in extra_files.items():
            val_name = f"{RESERVED_VALUE_PREFIX}{name}"
            all_root_values[val_name] = uefi_path(dest)

    if all_root_values:
        lines.extend(
            [
                "",
                "[values]",
            ]
        )
        for vk, vv in sorted(all_root_values.items()):
            lines.append(f"{quote_toml(vk)} = {quote_toml(vv)}")

    if custom_phases:
        for phase_name in ("early", "startup", "late"):
            for item in custom_phases.get(phase_name, []):
                lines.extend(
                    [
                        "",
                        f"[[phases.{phase_name}]]",
                        f"actions = {array_toml(item['actions'])}",
                    ]
                )
                if item.get("values"):
                    lines.append(f"[phases.{phase_name}.values]")
                    for vk, vv in sorted(item["values"].items()):
                        lines.append(f"{quote_toml(vk)} = {quote_toml(vv)}")

    for name, path in sorted(drivers.items()):
        lines.extend(
            [
                "",
                f"[drivers.{quote_toml(name)}]",
                f"path = {quote_toml(uefi_path(path))}",
            ]
        )

    for entry in entries:
        lines.extend(
            [
                "",
                f"[entries.{quote_toml(entry.identifier)}]",
                f"title = {quote_toml(entry.title)}",
                f"actions = {array_toml([entry.identifier])}",
                f"sort-key = {quote_toml(entry.sort_key)}",
            ]
        )

    for entry_id, entry_data in sorted(custom_entries.items()):
        lines.extend(
            [
                "",
                f"[entries.{quote_toml(entry_id)}]",
                f"title = {quote_toml(entry_data['title'])}",
                f"actions = {array_toml(entry_data['actions'])}",
            ]
        )
        if entry_data.get("sort-key") is not None:
            lines.append(f"sort-key = {quote_toml(entry_data['sort-key'])}")
        if entry_data.get("values"):
            lines.append(f"[entries.{quote_toml(entry_id)}.values]")
            for vk, vv in sorted(entry_data["values"].items()):
                lines.append(f"{quote_toml(vk)} = {quote_toml(vv)}")

    for entry in entries:
        lines.extend(
            [
                "",
                f"[actions.{quote_toml(entry.identifier)}]",
                (
                    "chainload.path = "
                    + quote_toml(uefi_path(entry.kernel))
                ),
                (
                    "chainload.options = "
                    + array_toml(entry.options)
                ),
            ]
        )

        if len(entry.initrds) == 1:
            lines.append(
                "chainload.linux-initrd = "
                + quote_toml(uefi_path(entry.initrds[0]))
            )
        elif len(entry.initrds) > 1:
            lines.append(
                "chainload.linux-initrd-chain = "
                + array_toml(
                    [uefi_path(path) for path in entry.initrds]
                )
            )

    for action_id, action_data in sorted(custom_actions.items()):
        lines.extend(
            [
                "",
                f"[actions.{quote_toml(action_id)}]",
            ]
        )
        if "chainload" in action_data:
            cl = action_data["chainload"]
            lines.append(f"chainload.path = {quote_toml(cl['path'])}")
            if cl.get("options"):
                lines.append(f"chainload.options = {array_toml(cl['options'])}")
            if cl.get("linux-initrd") is not None:
                lines.append(f"chainload.linux-initrd = {quote_toml(cl['linux-initrd'])}")
            elif cl.get("linux-initrd-chain"):
                lines.append(
                    f"chainload.linux-initrd-chain = {array_toml(cl['linux-initrd-chain'])}"
                )
        elif "print" in action_data:
            pr = action_data["print"]
            lines.append(f"print.text = {quote_toml(pr.get('text', ''))}")
        elif "edera" in action_data:
            ed = action_data["edera"]
            lines.append(f"edera.xen = {quote_toml(ed['xen'])}")
            lines.append(f"edera.kernel = {quote_toml(ed['kernel'])}")
            if ed.get("initrd") is not None:
                lines.append(f"edera.initrd = {quote_toml(ed['initrd'])}")
            elif ed.get("initrd-chain"):
                lines.append(f"edera.initrd-chain = {array_toml(ed['initrd-chain'])}")
            if ed.get("kernel-options"):
                lines.append(f"edera.kernel-options = {array_toml(ed['kernel-options'])}")
            if ed.get("xen-options"):
                lines.append(f"edera.xen-options = {array_toml(ed['xen-options'])}")

    lines.append("")

    return "\n".join(lines)


def install_sprout_binary() -> None:
    destination = esp_path(SPROUT_BINARY)

    if not SPROUT_BINARY_SOURCE.is_file():
        raise RuntimeError(
            f"Sprout EFI binary does not exist: {SPROUT_BINARY_SOURCE}"
        )

    atomic_copy(
        SPROUT_BINARY_SOURCE,
        destination,
        replace=True,
    )


def removable_loader_name() -> str:
    machine = os.uname().machine.lower()

    try:
        return _MACHINE_BOOT_FALLBACKS[machine]
    except KeyError as exc:
        raise RuntimeError(
            f"unsupported architecture for removable EFI fallback: {machine}"
        ) from exc


def install_removable_loader() -> None:
    destination = esp_path(Path("EFI/BOOT") / removable_loader_name())
    source = esp_path(SPROUT_BINARY)

    atomic_copy(
        source,
        destination,
        replace=True,
    )


def fixed_loader_paths() -> list[Path]:
    paths = [esp_path(SPROUT_BINARY)]
    if EFI_INSTALL_AS_REMOVABLE:
        paths.append(esp_path(Path("EFI/BOOT") / removable_loader_name()))
    return paths


class FixedLoaderTransaction:
    """Manages backup and atomic restoration of fixed-path bootloaders."""

    def __init__(self, paths: Sequence[Path]) -> None:
        self.paths = list(paths)
        self.backups: list[tuple[Path, Path | None]] = []
        self._temp_dir: tempfile.TemporaryDirectory[str] | None = None
        self._committed: bool = False
        self._rolled_back: bool = False

    def __enter__(self) -> FixedLoaderTransaction:
        self._temp_dir = tempfile.TemporaryDirectory()
        try:
            temp_path = Path(self._temp_dir.name)
            for index, path in enumerate(self.paths):
                if path.is_file():
                    backup_file = temp_path / f"loader_{index}.efi"
                    atomic_copy(path, backup_file, replace=True)
                    self.backups.append((path, backup_file))
                else:
                    self.backups.append((path, None))
            return self
        except BaseException:
            if self._temp_dir is not None:
                self._temp_dir.cleanup()
                self._temp_dir = None
            raise

    def commit(self) -> None:
        self._committed = True
        if self._temp_dir is not None:
            try:
                self._temp_dir.cleanup()
            except OSError:
                pass
            self._temp_dir = None

    def rollback(self) -> None:
        if self._rolled_back:
            return
        self._rolled_back = True

        errors: list[Exception] = []
        for path, backup_file in reversed(self.backups):
            try:
                if backup_file is not None:
                    atomic_copy(backup_file, path, replace=True)
                else:
                    path.unlink(missing_ok=True)
                    fsync_path(path.parent)
            except Exception as exc:
                errors.append(exc)

        if errors:
            if len(errors) == 1:
                raise errors[0]
            messages = "; ".join(str(e) for e in errors)
            raise RuntimeError(f"multiple restoration errors: {messages}")

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_val: BaseException | None,
        exc_tb: Any,
    ) -> None:
        try:
            if exc_type is not None and not self._committed:
                try:
                    self.rollback()
                except Exception as restore_exc:
                    print(
                        f"error: failed to restore bootloader files: {restore_exc}",
                        file=sys.stderr,
                    )
                    raise RuntimeError(
                        f"failed to restore bootloader files after installation error ({exc_val}): {restore_exc}"
                    ) from exc_val
        finally:
            if self._temp_dir is not None:
                try:
                    self._temp_dir.cleanup()
                except OSError:
                    pass
                self._temp_dir = None


def uefi_to_relative_path(uefi: str) -> Path:
    clean = uefi.replace("\\", "/").strip().lstrip("/")
    if not clean or clean == ".":
        raise RuntimeError(f"path {uefi!r} is not a valid relative path")
    return Path(clean)


def stamp_values(text: str, values: dict[str, str]) -> str:
    sorted_keys = sorted(values.keys(), key=len, reverse=True)
    stamped = text
    for k in sorted_keys:
        if k:
            stamped = stamped.replace(f"${k}", values[k])
    return stamped


CONTEXT_FINALIZE_ITERATION_LIMIT = 100
CONTEXT_FINALIZE_VALUE_LENGTH_LIMIT = 64 * 1024


def finalize_values(values: dict[str, str], context_desc: str) -> dict[str, str]:
    current_values = dict(values)
    iterations = 0
    while True:
        iterations += 1
        if iterations > CONTEXT_FINALIZE_ITERATION_LIMIT:
            raise RuntimeError(
                f"maximum number of replacement iterations reached while finalizing {context_desc}"
            )
        did_change = False
        new_values: dict[str, str] = {}
        for key, value in current_values.items():
            result = stamp_values(value, current_values)
            if result != value:
                did_change = True
            if len(result) > CONTEXT_FINALIZE_VALUE_LENGTH_LIMIT:
                raise RuntimeError(
                    f"value {key!r} is too long while finalizing {context_desc}"
                )
            new_values[key] = result
        current_values = new_values
        if not did_change:
            break
    return current_values


def resolve_stamped_path(
    raw_path: str,
    context_values: dict[str, str],
    config_path: Path,
    context: str,
    path_kind: str = "path",
) -> Path:
    stamped = stamp_values(raw_path, context_values)
    var_match = re.search(r"\$[A-Za-z0-9_]+", stamped)
    if var_match is not None:
        raise RuntimeError(
            f"published Sprout configuration {config_path} {context} contains unresolved dynamic variable {var_match.group(0)!r} in {raw_path!r}"
        )
    try:
        return esp_path(uefi_to_relative_path(stamped))
    except RuntimeError as exc:
        raise RuntimeError(
            f"published Sprout configuration {config_path} {context} references invalid {path_kind} {raw_path!r}: {exc}"
        ) from exc


def published_config_referenced_files() -> set[Path]:
    config_path = esp_path(SPROUT_CONFIG)

    try:
        content = config_path.read_text(encoding="utf-8")
    except FileNotFoundError as exc:
        if config_path.is_symlink():
            raise RuntimeError(
                f"published Sprout configuration {config_path} is a broken symlink"
            ) from exc
        return set()
    except OSError as exc:
        raise RuntimeError(
            f"failed to read published Sprout configuration {config_path}: {exc}"
        ) from exc
    except UnicodeDecodeError as exc:
        raise RuntimeError(
            f"published Sprout configuration {config_path} is not valid UTF-8: {exc}"
        ) from exc

    return parse_and_validate_sprout_config(
        content,
        config_path,
        check_files_exist=False,
    )


def parse_and_validate_sprout_config(
    content: str,
    config_path: Path,
    check_files_exist: bool = False,
) -> set[Path]:
    try:
        data = tomllib.loads(content)
    except tomllib.TOMLDecodeError as exc:
        raise RuntimeError(
            f"failed to parse published Sprout configuration {config_path}: {exc}"
        ) from exc

    if not isinstance(data, dict):
        raise RuntimeError(
            f"published Sprout configuration {config_path} root is not a table"
        )

    if "version" not in data:
        raise RuntimeError(
            f"published Sprout configuration {config_path} is missing 'version' field"
        )
    version = data["version"]
    if type(version) is not int or version != 1:
        raise RuntimeError(
            f"published Sprout configuration {config_path} has unsupported or invalid version {version!r}; expected 1"
        )

    options_table = data.get("options")
    if options_table is not None:
        if not isinstance(options_table, dict):
            raise RuntimeError(
                f"published Sprout configuration {config_path} contains invalid 'options' table"
            )
        autoconfigure_val = options_table.get("autoconfigure")
        if autoconfigure_val is not None:
            if not isinstance(autoconfigure_val, bool):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} 'options.autoconfigure' is not a boolean"
                )
            if autoconfigure_val:
                raise RuntimeError(
                    f"published Sprout configuration {config_path} enables 'options.autoconfigure', which introduces dynamic runtime references that cannot be statically protected"
                )

    if data.get("autoconfigure") is True:
        raise RuntimeError(
            f"published Sprout configuration {config_path} enables 'autoconfigure', which introduces dynamic runtime references that cannot be statically protected"
        )

    generators = data.get("generators")
    if generators is not None:
        if not isinstance(generators, dict):
            raise RuntimeError(
                f"published Sprout configuration {config_path} contains invalid 'generators' table"
            )
        if generators:
            raise RuntimeError(
                f"published Sprout configuration {config_path} contains unsupported dynamic 'generators'"
            )

    extractors = data.get("extractors")
    if extractors is not None:
        if not isinstance(extractors, dict):
            raise RuntimeError(
                f"published Sprout configuration {config_path} contains invalid 'extractors' table"
            )
        if extractors:
            raise RuntimeError(
                f"published Sprout configuration {config_path} contains unsupported dynamic 'extractors'"
            )

    values_table = data.get("values")
    raw_root_values: dict[str, str] = {}
    if values_table is not None:
        if not isinstance(values_table, dict):
            raise RuntimeError(
                f"published Sprout configuration {config_path} contains invalid 'values' table"
            )
        for val_key, val_val in values_table.items():
            if not isinstance(val_key, str) or not isinstance(val_val, str):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} contains invalid 'values' table entry {val_key!r}"
                )
            if not VALUE_IDENTIFIER_RE.fullmatch(val_key):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} root 'values' entry {val_key!r} must match [A-Za-z_][A-Za-z0-9_]*"
                )
            raw_root_values[val_key] = val_val

    root_values = finalize_values(raw_root_values, "root 'values'")
    for rk, rv in root_values.items():
        var_match = re.search(r"\$[A-Za-z0-9_]+", rv)
        if var_match is not None:
            raise RuntimeError(
                f"published Sprout configuration {config_path} root 'values' entry {rk!r} contains unresolved variable {var_match.group(0)!r}; resolution cannot be completed"
            )

    referenced: set[Path] = set()

    drivers_table = data.get("drivers")
    if drivers_table is not None:
        if not isinstance(drivers_table, dict):
            raise RuntimeError(
                f"published Sprout configuration {config_path} contains invalid 'drivers' table"
            )
        for driver_name, driver_entry in drivers_table.items():
            if not isinstance(driver_entry, dict):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} contains invalid driver entry {driver_name!r}"
                )
            driver_path_str = driver_entry.get("path")
            if not isinstance(driver_path_str, str):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} driver {driver_name!r} has missing or non-string path"
                )
            referenced.add(
                resolve_stamped_path(
                    driver_path_str,
                    root_values,
                    config_path,
                    context=f"driver {driver_name!r}",
                    path_kind="path",
                )
            )

    actions_table = data.get("actions")
    if actions_table is not None:
        if not isinstance(actions_table, dict):
            raise RuntimeError(
                f"published Sprout configuration {config_path} contains invalid 'actions' table"
            )
        for action_name, action_entry in actions_table.items():
            if not isinstance(action_entry, dict):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} contains invalid action entry {action_name!r}"
                )

    action_invocations: list[tuple[str, dict[str, str], str]] = []
    referenced_action_names: set[str] = set()

    phases_table = data.get("phases")
    if phases_table is not None:
        if not isinstance(phases_table, dict):
            raise RuntimeError(
                f"published Sprout configuration {config_path} contains invalid 'phases' table"
            )
        valid_phase_names = {"early", "startup", "late"}
        for phase_name, phase_items in phases_table.items():
            if phase_name not in valid_phase_names:
                raise RuntimeError(
                    f"published Sprout configuration {config_path} contains unknown phase {phase_name!r}"
                )
            if not isinstance(phase_items, list):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} phase {phase_name!r} must be a list of phase configurations"
                )
            for item_idx, phase_item in enumerate(phase_items):
                if not isinstance(phase_item, dict):
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} phase {phase_name!r} item {item_idx} is not a table"
                    )
                for k in phase_item:
                    if k not in ("actions", "values"):
                        raise RuntimeError(
                            f"published Sprout configuration {config_path} phase {phase_name!r} item {item_idx} contains unknown field {k!r}"
                        )
                phase_values_raw = phase_item.get("values")
                phase_item_values: dict[str, str] = {}
                if phase_values_raw is not None:
                    if not isinstance(phase_values_raw, dict):
                        raise RuntimeError(
                            f"published Sprout configuration {config_path} phase {phase_name!r} item {item_idx} contains invalid 'values' table"
                        )
                    for vk, vv in phase_values_raw.items():
                        if not isinstance(vk, str) or not isinstance(vv, str):
                            raise RuntimeError(
                                f"published Sprout configuration {config_path} phase {phase_name!r} item {item_idx} contains invalid 'values' table entry {vk!r}"
                            )
                        if vk.startswith(RESERVED_VALUE_PREFIX):
                            raise RuntimeError(
                                f"published Sprout configuration {config_path} phase {phase_name!r} item {item_idx} value {vk!r} uses reserved {RESERVED_VALUE_PREFIX!r} prefix"
                            )
                        phase_item_values[vk] = vv
                merged_phase_values = finalize_values(
                    {**raw_root_values, **phase_item_values},
                    f"phase {phase_name!r} item {item_idx} 'values'",
                )
                phase_actions = phase_item.get("actions")
                if not isinstance(phase_actions, list) or not phase_actions:
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} phase {phase_name!r} item {item_idx} 'actions' must be a non-empty list"
                    )
                for act_idx, act_raw in enumerate(phase_actions):
                    if not isinstance(act_raw, str):
                        raise RuntimeError(
                            f"published Sprout configuration {config_path} phase {phase_name!r} item {item_idx} action item {act_idx} is not a string"
                        )
                    stamped_act = stamp_values(act_raw, merged_phase_values)
                    var_match = re.search(r"\$[A-Za-z0-9_]+", stamped_act)
                    if var_match is not None:
                        raise RuntimeError(
                            f"published Sprout configuration {config_path} phase {phase_name!r} item {item_idx} action {act_raw!r} contains unresolved dynamic variable {var_match.group(0)!r}"
                        )
                    if actions_table is None or stamped_act not in actions_table:
                        raise RuntimeError(
                            f"published Sprout configuration {config_path} phase {phase_name!r} item {item_idx} references unknown action {stamped_act!r}"
                        )
                    action_invocations.append(
                        (
                            stamped_act,
                            merged_phase_values,
                            f"phase {phase_name!r} item {item_idx} action {stamped_act!r}",
                        )
                    )
                    referenced_action_names.add(stamped_act)

    entries_table = data.get("entries")
    if entries_table is not None:
        if not isinstance(entries_table, dict):
            raise RuntimeError(
                f"published Sprout configuration {config_path} contains invalid 'entries' table"
            )
        for entry_name, entry_data in entries_table.items():
            if not isinstance(entry_data, dict):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} contains invalid entry {entry_name!r}"
                )
            entry_values_raw = entry_data.get("values")
            entry_values: dict[str, str] = {}
            if entry_values_raw is not None:
                if not isinstance(entry_values_raw, dict):
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} entry {entry_name!r} contains invalid 'values' table"
                    )
                for vk, vv in entry_values_raw.items():
                    if not isinstance(vk, str) or not isinstance(vv, str):
                        raise RuntimeError(
                            f"published Sprout configuration {config_path} entry {entry_name!r} contains invalid 'values' table entry {vk!r}"
                        )
                    if vk.startswith(RESERVED_VALUE_PREFIX):
                        raise RuntimeError(
                            f"published Sprout configuration {config_path} entry {entry_name!r} value {vk!r} uses reserved {RESERVED_VALUE_PREFIX!r} prefix"
                        )
                    entry_values[vk] = vv
            merged_entry_values = finalize_values(
                {**raw_root_values, **entry_values},
                f"entry {entry_name!r} 'values'",
            )
            entry_actions = entry_data.get("actions", [])
            if not isinstance(entry_actions, list):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} entry {entry_name!r} 'actions' is not a list"
                )
            for act_idx, act_raw in enumerate(entry_actions):
                if not isinstance(act_raw, str):
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} entry {entry_name!r} action item {act_idx} is not a string"
                    )
                stamped_act = stamp_values(act_raw, merged_entry_values)
                var_match = re.search(r"\$[A-Za-z0-9_]+", stamped_act)
                if var_match is not None:
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} entry {entry_name!r} action {act_raw!r} contains unresolved dynamic variable {var_match.group(0)!r}"
                    )
                if actions_table is None or stamped_act not in actions_table:
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} entry {entry_name!r} references unknown action {stamped_act!r}"
                    )
                action_invocations.append(
                    (
                        stamped_act,
                        merged_entry_values,
                        f"entry {entry_name!r} action {stamped_act!r}",
                    )
                )
                referenced_action_names.add(stamped_act)

    if actions_table is not None:
        for action_name in actions_table:
            if action_name not in referenced_action_names:
                action_invocations.append(
                    (action_name, root_values, f"action {action_name!r}")
                )

    actions_table_dict = actions_table or {}
    for action_name, context_values, context_desc in action_invocations:
        action_entry = actions_table_dict[action_name]

        recognized_variants = [
            k for k in ("chainload", "print", "edera") if k in action_entry
        ]
        if len(recognized_variants) == 0:
            raise RuntimeError(
                f"published Sprout configuration {config_path} {context_desc} must define exactly one action variant (chainload, print, or edera); found none"
            )
        if len(recognized_variants) > 1:
            raise RuntimeError(
                f"published Sprout configuration {config_path} {context_desc} must define exactly one action variant (chainload, print, or edera); specifies multiple action variants: {recognized_variants}"
            )

        print_entry = action_entry.get("print")
        if print_entry is not None:
            if not isinstance(print_entry, dict):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} {context_desc} contains invalid 'print' table"
                )
            print_text = print_entry.get("text", "")
            if not isinstance(print_text, str):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} {context_desc} print 'text' is not a string"
                )

        chainload = action_entry.get("chainload")
        if chainload is not None:
            if not isinstance(chainload, dict):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} {context_desc} contains invalid 'chainload' table"
                )
            if "linux-initrd" in chainload and "linux-initrd-chain" in chainload:
                raise RuntimeError(
                    f"published Sprout configuration {config_path} {context_desc} cannot specify both 'linux-initrd' and 'linux-initrd-chain'"
                )

            kernel_path_str = chainload.get("path")
            if kernel_path_str is not None:
                if not isinstance(kernel_path_str, str):
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} {context_desc} kernel path is not a string"
                    )
                referenced.add(
                    resolve_stamped_path(
                        kernel_path_str,
                        context_values,
                        config_path,
                        context=context_desc,
                        path_kind="kernel path",
                    )
                )

            initrd_str = chainload.get("linux-initrd")
            if initrd_str is not None:
                if not isinstance(initrd_str, str):
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} {context_desc} initrd path is not a string"
                    )
                referenced.add(
                    resolve_stamped_path(
                        initrd_str,
                        context_values,
                        config_path,
                        context=context_desc,
                        path_kind="initrd path",
                    )
                )

            chain = chainload.get("linux-initrd-chain")
            if chain is not None:
                if not isinstance(chain, list):
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} {context_desc} initrd chain is not a list"
                    )
                for idx, initrd_item in enumerate(chain):
                    if not isinstance(initrd_item, str):
                        raise RuntimeError(
                            f"published Sprout configuration {config_path} {context_desc} initrd chain item {idx} is not a string"
                        )
                    referenced.add(
                        resolve_stamped_path(
                            initrd_item,
                            context_values,
                            config_path,
                            context=context_desc,
                            path_kind="initrd chain path",
                        )
                    )

            devicetree_str = chainload.get("devicetree")
            if devicetree_str is not None:
                if not isinstance(devicetree_str, str):
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} {context_desc} devicetree path is not a string"
                    )
                referenced.add(
                    resolve_stamped_path(
                        devicetree_str,
                        context_values,
                        config_path,
                        context=context_desc,
                        path_kind="devicetree path",
                    )
                )

        edera = action_entry.get("edera")
        if edera is not None:
            if not isinstance(edera, dict):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} {context_desc} contains invalid 'edera' table"
                )
            if "initrd" in edera and "initrd-chain" in edera:
                raise RuntimeError(
                    f"published Sprout configuration {config_path} {context_desc} cannot specify both 'initrd' and 'initrd-chain' in edera"
                )

            xen_path_str = edera.get("xen")
            if xen_path_str is None or not isinstance(xen_path_str, str):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} {context_desc} edera xen path is missing or not a string"
                )
            referenced.add(
                resolve_stamped_path(
                    xen_path_str,
                    context_values,
                    config_path,
                    context=context_desc,
                    path_kind="edera xen path",
                )
            )

            kernel_path_str = edera.get("kernel")
            if kernel_path_str is None or not isinstance(kernel_path_str, str):
                raise RuntimeError(
                    f"published Sprout configuration {config_path} {context_desc} edera kernel path is missing or not a string"
                )
            referenced.add(
                resolve_stamped_path(
                    kernel_path_str,
                    context_values,
                    config_path,
                    context=context_desc,
                    path_kind="edera kernel path",
                )
            )

            initrd_str = edera.get("initrd")
            if initrd_str is not None:
                if not isinstance(initrd_str, str):
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} {context_desc} edera initrd path is not a string"
                    )
                referenced.add(
                    resolve_stamped_path(
                        initrd_str,
                        context_values,
                        config_path,
                        context=context_desc,
                        path_kind="edera initrd path",
                    )
                )

            chain = edera.get("initrd-chain")
            if chain is not None:
                if not isinstance(chain, list):
                    raise RuntimeError(
                        f"published Sprout configuration {config_path} {context_desc} edera initrd chain is not a list"
                    )
                for idx, initrd_item in enumerate(chain):
                    if not isinstance(initrd_item, str):
                        raise RuntimeError(
                            f"published Sprout configuration {config_path} {context_desc} edera initrd chain item {idx} is not a string"
                        )
                    referenced.add(
                        resolve_stamped_path(
                            initrd_item,
                            context_values,
                            config_path,
                            context=context_desc,
                            path_kind="edera initrd chain path",
                        )
                    )

    if check_files_exist:
        for ref_path in sorted(referenced):
            if not ref_path.is_file():
                raise RuntimeError(
                    f"published Sprout configuration {config_path} references missing file {ref_path}"
                )

    return referenced


class StagedArtifactTransaction:
    """Tracks and rolls back newly created staging artifacts on pre-publication failure."""

    _active: StagedArtifactTransaction | None = None

    def __init__(self) -> None:
        self.created_files: list[Path] = []
        self.pre_existing_files: set[Path] = set()
        self.protected_files: set[Path] = set()
        self._committed: bool = False
        self._rolled_back: bool = False

    @classmethod
    def current(cls) -> StagedArtifactTransaction | None:
        return cls._active

    def record_created(self, path: Path) -> None:
        if not self._committed and not self._rolled_back:
            if (
                path not in self.pre_existing_files
                and path not in self.protected_files
            ):
                if path not in self.created_files:
                    self.created_files.append(path)

    def __enter__(self) -> StagedArtifactTransaction:
        if StagedArtifactTransaction._active is not None:
            raise RuntimeError("a StagedArtifactTransaction is already active")
        try:
            self._scan_existing_and_protected()
        except BaseException:
            if StagedArtifactTransaction._active is self:
                StagedArtifactTransaction._active = None
            raise
        StagedArtifactTransaction._active = self
        return self

    def _scan_existing_and_protected(self) -> None:
        self.protected_files = published_config_referenced_files()
        try:
            self.protected_files.update(fixed_loader_paths())
        except (RuntimeError, OSError):
            pass

        for directory in (
            esp_path(NIXOS_DIR),
            esp_path(DRIVERS_DIR),
            esp_path(EXTRA_FILES_DIR),
        ):
            if directory.exists():
                for path in directory.rglob("*"):
                    if path.is_file():
                        self.pre_existing_files.add(path)

    def commit(self) -> None:
        self._committed = True
        self.created_files.clear()

    def rollback(self) -> None:
        if self._rolled_back or self._committed:
            return
        self._rolled_back = True

        for path in reversed(self.created_files):
            if (
                path in self.pre_existing_files
                or path in self.protected_files
            ):
                continue

            try:
                path.unlink(missing_ok=True)
                fsync_path(path.parent)
            except OSError as exc:
                print(
                    f"warning: failed to clean up uncommitted artifact {path}: {exc}",
                    file=sys.stderr,
                )

            try:
                parent = path.parent
                if parent not in (
                    esp_path(NIXOS_DIR),
                    esp_path(DRIVERS_DIR),
                    esp_path(EXTRA_FILES_DIR),
                    esp_path(SPROUT_DIR),
                    EFI_SYS_MOUNT_POINT,
                ):
                    parent.rmdir()
            except OSError:
                pass

        self.created_files.clear()

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_val: BaseException | None,
        exc_tb: Any,
    ) -> None:
        try:
            if exc_type is not None and not self._committed:
                self.rollback()
        finally:
            if StagedArtifactTransaction._active is self:
                StagedArtifactTransaction._active = None


def check_mountpoint() -> None:
    try:
        source = capture(
            [
                FINDMNT,
                "--noheadings",
                "--output",
                "SOURCE",
                "--mountpoint",
                EFI_SYS_MOUNT_POINT,
            ]
        )
    except subprocess.CalledProcessError:
        raise RuntimeError(
            f"{EFI_SYS_MOUNT_POINT} is not a mounted filesystem"
        ) from None

    if not source:
        raise RuntimeError(
            f"{EFI_SYS_MOUNT_POINT} is not a mounted filesystem"
        )

    try:
        filesystem_type = capture(
            [
                FINDMNT,
                "--noheadings",
                "--output",
                "FSTYPE",
                "--mountpoint",
                EFI_SYS_MOUNT_POINT,
            ]
        )
    except subprocess.CalledProcessError:
        raise RuntimeError(
            f"{EFI_SYS_MOUNT_POINT} is not a mounted filesystem"
        ) from None

    if filesystem_type.lower() != "vfat":
        raise RuntimeError(
            f"{EFI_SYS_MOUNT_POINT} is mounted as {filesystem_type!r}; "
            "Sprout currently requires a vfat ESP"
        )


def check_efivars() -> None:
    efivars = Path("/sys/firmware/efi/efivars")

    if not efivars.is_dir():
        raise RuntimeError(
            "EFI variables are unavailable at /sys/firmware/efi/efivars"
        )

    try:
        filesystem_type = capture(
            [
                FINDMNT,
                "--noheadings",
                "--output",
                "FSTYPE",
                "--target",
                efivars,
            ]
        )
    except subprocess.CalledProcessError:
        raise RuntimeError(
            "efivarfs is not mounted at /sys/firmware/efi/efivars"
        ) from None

    if filesystem_type != "efivarfs":
        raise RuntimeError(
            "EFI variables are not backed by efivarfs"
        )


def get_esp_device() -> tuple[str, str]:
    try:
        source = capture(
            [
                FINDMNT,
                "--noheadings",
                "--output",
                "SOURCE",
                "--mountpoint",
                EFI_SYS_MOUNT_POINT,
            ]
        )
    except subprocess.CalledProcessError:
        raise RuntimeError(
            f"{EFI_SYS_MOUNT_POINT} is not a mounted filesystem"
        ) from None

    if not source:
        raise RuntimeError(
            f"{EFI_SYS_MOUNT_POINT} is not a mounted filesystem"
        )

    try:
        parent = capture(
            [
                LSBLK,
                "--noheadings",
                "--output",
                "PKNAME",
                source,
            ]
        )
    except subprocess.CalledProcessError:
        raise RuntimeError(
            f"could not determine the parent disk of ESP device {source}"
        ) from None

    try:
        partition = capture(
            [
                LSBLK,
                "--noheadings",
                "--output",
                "PARTN",
                source,
            ]
        )
    except subprocess.CalledProcessError:
        raise RuntimeError(
            f"could not determine the partition number of ESP device {source}"
        ) from None

    if not parent:
        raise RuntimeError(
            f"could not determine the parent disk of ESP device {source}"
        )

    try:
        partition_num = int(partition)
    except (ValueError, TypeError):
        partition_num = 0

    if partition_num <= 0:
        raise RuntimeError(
            f"could not determine the partition number of ESP device {source}"
        )

    return f"/dev/{parent}", str(partition_num)


def normalize_label(label: str) -> str:
    return label.strip().lower()


def normalize_efi_path(path: str) -> str:
    cleaned = path.strip().replace("/", "\\")
    if not cleaned.startswith("\\"):
        cleaned = "\\" + cleaned
    return cleaned.lower()


@dataclass(frozen=True)
class NvramEntry:
    label: str
    loader_path: str | None


def parse_nvram_entry(line: str) -> NvramEntry | None:
    match = re.match(r"^Boot[0-9A-Fa-f]{4}\*?\s+", line)
    if not match:
        return None

    remainder = line[match.end():]
    if "\t" in remainder:
        parts = remainder.split("\t", 1)
        raw_label = parts[0]
        raw_device = parts[1]
    else:
        device_match = re.search(
            r"\s+((?:/?File|HD|Pci|PciRoot|VenHw|ACPI|BBS|NVMe|Fv|MemoryMapped)\(.*)$",
            remainder,
            re.IGNORECASE,
        )
        if device_match:
            raw_label = remainder[:device_match.start()]
            raw_device = device_match.group(1)
        else:
            raw_label = remainder
            raw_device = ""

    label = raw_label.strip()

    loader_path: str | None = None
    file_match = re.search(r"File\((.*?)\)", raw_device, re.IGNORECASE)
    if file_match:
        loader_path = file_match.group(1).strip()
    elif raw_device.strip().startswith(("\\", "/")):
        loader_path = raw_device.strip()
    else:
        hd_match = re.search(r"HD\([^)]*\)[/](.*)$", raw_device, re.IGNORECASE)
        if hd_match:
            candidate = hd_match.group(1).strip()
            stripped = candidate.lstrip("\\/")
            if stripped and not re.match(r"^[A-Za-z0-9_]+\(", stripped):
                if candidate.startswith(("/\\", "//")):
                    candidate = candidate[1:]
                loader_path = candidate if candidate else None
        else:
            hd_match_bs = re.search(r"HD\([^)]*\)(\\.*)$", raw_device, re.IGNORECASE)
            if hd_match_bs:
                candidate = hd_match_bs.group(1).strip()
                stripped = candidate.lstrip("\\/")
                if stripped and not re.match(r"^[A-Za-z0-9_]+\(", stripped):
                    loader_path = candidate if candidate else None

    return NvramEntry(label=label, loader_path=loader_path)


class NvramStatus(Enum):
    ABSENT = "absent"
    MATCHING = "matching"
    CONFLICT = "conflict"


def inspect_nvram_entry(raise_on_conflict: bool = True) -> NvramStatus:
    check_efivars()

    existing = capture(
        [
            EFIBOOTMGR,
            "-v",
        ]
    )

    normalized_target_label = normalize_label(FIRMWARE_ENTRY_LABEL)
    normalized_target_loader = normalize_efi_path(FIRMWARE_LOADER_PATH)

    matching_seen = False
    conflict_seen = False

    for line in existing.splitlines():
        entry = parse_nvram_entry(line)
        if entry is None:
            continue

        if normalize_label(entry.label) == normalized_target_label:
            if (
                entry.loader_path is not None
                and normalize_efi_path(entry.loader_path) == normalized_target_loader
            ):
                matching_seen = True
            else:
                conflict_seen = True

    if conflict_seen:
        if raise_on_conflict:
            raise RuntimeError(
                f"an existing UEFI entry named {FIRMWARE_ENTRY_LABEL!r} "
                f"does not point to {FIRMWARE_LOADER_PATH}"
            )
        return NvramStatus.CONFLICT

    if matching_seen:
        return NvramStatus.MATCHING

    return NvramStatus.ABSENT


def preflight_nvram() -> None:
    inspect_nvram_entry(raise_on_conflict=True)


def install_nvram_entry() -> None:
    status = inspect_nvram_entry(raise_on_conflict=True)
    if status == NvramStatus.MATCHING:
        return

    disk, partition = get_esp_device()

    run(
        [
            EFIBOOTMGR,
            "-c",
            "-d",
            disk,
            "-p",
            partition,
            "-L",
            FIRMWARE_ENTRY_LABEL,
            "-l",
            FIRMWARE_LOADER_PATH,
        ]
    )


def garbage_collect(
    entries: Sequence[BootEntry],
    drivers: dict[str, Path],
    referenced_paths: set[Path],
    extra_files: dict[str, Path] | None = None,
) -> None:
    keep = {
        esp_path(artifact.destination)
        for entry in entries
        for artifact in entry.artifacts
    }

    keep.update(
        esp_path(path)
        for path in drivers.values()
    )

    if extra_files is not None:
        keep.update(
            esp_path(path)
            for path in extra_files.values()
        )

    for entry in entries:
        for initrd in entry.initrds:
            try:
                keep.add(esp_path(initrd))
            except RuntimeError:
                pass

    keep.update(referenced_paths)

    for directory in (
        esp_path(NIXOS_DIR),
        esp_path(DRIVERS_DIR),
        esp_path(EXTRA_FILES_DIR),
    ):
        if not directory.exists():
            continue

        for path in sorted(
            directory.rglob("*"),
            key=lambda value: len(value.parts),
            reverse=True,
        ):
            if path.is_file() or path.is_symlink():
                if path not in keep:
                    path.unlink(missing_ok=True)

            elif path.is_dir():
                try:
                    path.rmdir()
                except OSError:
                    pass


def find_default_entry(
    entries: Sequence[BootEntry],
) -> BootEntry:
    for entry in entries:
        if entry.critical:
            return entry

    raise RuntimeError(
        "could not determine the current NixOS boot entry"
    )


def install_bootloader(
    default_toplevel: Path,
) -> None:
    current_toplevel = default_toplevel.resolve()

    check_mountpoint()

    entries = collect_entries(
        current_toplevel=current_toplevel,
    )

    check_unique_identifiers(entries)

    if CAN_TOUCH_EFI_VARIABLES:
        preflight_nvram()

    esp_path(SPROUT_DIR).mkdir(
        parents=True,
        exist_ok=True,
    )
    esp_path(NIXOS_DIR).mkdir(
        parents=True,
        exist_ok=True,
    )
    esp_path(DRIVERS_DIR).mkdir(
        parents=True,
        exist_ok=True,
    )
    esp_path(EXTRA_FILES_DIR).mkdir(
        parents=True,
        exist_ok=True,
    )

    with StagedArtifactTransaction() as artifact_tx:
        extra_files = install_extra_files()

        entries = write_boot_files(entries)

        if not entries:
            raise RuntimeError(
                "no valid boot entries remain; refusing to publish configuration"
            )

        default_entry = find_default_entry(entries)

        drivers = install_drivers()

        # Install the loader before publishing the new configuration. At this
        # point all boot artifacts needed by the new configuration already exist.
        with FixedLoaderTransaction(fixed_loader_paths()) as transaction:
            install_sprout_binary()

            if EFI_INSTALL_AS_REMOVABLE:
                install_removable_loader()

            configuration = generate_sprout_config(
                entries,
                default_entry.identifier,
                drivers,
                extra_files=extra_files,
            )

            referenced_paths = parse_and_validate_sprout_config(
                configuration,
                esp_path(SPROUT_CONFIG),
                check_files_exist=True,
            )

            declared_extra_file_paths = {
                esp_path(dest) for dest in extra_files.values()
            }
            combined_keep_set = referenced_paths | declared_extra_file_paths

            # Atomically replace sprout.toml only after all referenced files are present.
            atomic_write_text(
                esp_path(SPROUT_CONFIG),
                configuration,
            )

            transaction.commit()
            artifact_tx.commit()

    sync_filesystem(EFI_SYS_MOUNT_POINT)

    if CAN_TOUCH_EFI_VARIABLES:
        install_nvram_entry()

    garbage_collect(
        entries,
        drivers,
        combined_keep_set,
        extra_files,
    )


def main(argv: Sequence[str] | None = None) -> None:
    parser = argparse.ArgumentParser(
        description="Install and update the Sprout bootloader for NixOS."
    )
    parser.add_argument(
        "default_config",
        metavar="DEFAULT-CONFIG",
        help="The NixOS toplevel that should be the default boot entry.",
    )

    args = parser.parse_args(argv)

    install_succeeded = False
    install_error: BaseException | None = None
    exit_code: int | None = None

    try:
        try:
            install_bootloader(
                Path(args.default_config),
            )
            install_succeeded = True
        except subprocess.CalledProcessError as exc:
            command = " ".join(str(part) for part in exc.cmd)
            print(
                f"error: command failed: {command}",
                file=sys.stderr,
            )
            install_error = exc
            exit_code = exc.returncode if exc.returncode else 1
        except (OSError, RuntimeError) as exc:
            print(
                f"error: {exc}",
                file=sys.stderr,
            )
            install_error = exc
            exit_code = 1
    finally:
        try:
            sync_filesystem(EFI_SYS_MOUNT_POINT)
        except OSError as sync_exc:
            print(
                f"error: {sync_exc}",
                file=sys.stderr,
            )
            if install_succeeded:
                raise SystemExit(1) from sync_exc

    if install_error is not None:
        assert exit_code is not None
        raise SystemExit(exit_code) from install_error


if __name__ == "__main__":
    main()
