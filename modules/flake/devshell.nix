{ inputs, ... }:
{
  # flake.devshells
  imports = [ inputs.omniflake.flakes.devshell.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      devshells.default = {
        packages = with pkgs; [
          git
          just
          nixfmt
          home-manager
        ];
        commands = [
          {
            name = "nix-tree-with-gcroots";
            category = "nix tools";
            command = ''
              nix-store --gc --print-roots | rg -v '/proc/' | rg -Po '(?<= -> ).*' | xargs -o nix-tree
            '';
          }
          {
            name = "non-nixos-setup";
            category = "nix tools";
            command = ''
              sudo tee -a /etc/nix/nix.conf <<EOF
              experimental-features = nix-command flakes
              trusted-users = root @wheel {{ user }}
              substituters = https://mirror.sjtu.edu.cn/nix-channels/store
              EOF
            '';
          }
          {
            name = "nix-index-database-update";
            category = "nix tools";
            command = ''
              filename="index-x86_64-$(uname | tr '[:upper:]' '[:lower:]')"
              mkdir -p ~/.cache/nix-index
              pushd ~/.cache/nix-index > /dev/null
              wget -q -N https://github.com/nix-community/nix-index-database/releases/latest/download/"$filename"
              ln -f "$filename" files
              popd > /dev/null
              ls -l ~/.cache/nix-index
              echo -e "\033[32m \n nix-index database update successfully. \033[0m"
            '';
          }
        ];
      };

      # ╭──────────────────────────────────────╮
      # │ GCC                                  │
      # ╰──────────────────────────────────────╯
      devShells.gcc = pkgs.mkShell {
        buildInputs = with pkgs; [
          gcc
          gnumake
          cmake
          meson
          ninja
          pkg-config
        ];
        name = "gcc";
        shellHook = ''
          zsh && exit
        '';
      };

      # ╭──────────────────────────────────────╮
      # │ QT6                                  │
      # ╰──────────────────────────────────────╯
      devShells.qt6 = pkgs.mkShell {
        buildInputs = with pkgs; [
          qt6.qmake
          qt6.qtbase
          qt6.qttools
          qt6.qtsvg
          qt6.qtwayland
          qt6.wrapQtAppsHook
          pkg-config
        ];
      };

      # ╭──────────────────────────────────────╮
      # │ NODEJS                               │
      # ╰──────────────────────────────────────╯
      devShells.nodejs = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs
          yarn
          electron
          python3
        ];
        # ELECTRON_OVERRIDE_DIST_PATH = "${pkgs.electron_20}/bin";
      };

      # ╭──────────────────────────────────────╮
      # │ GO                                   │
      # ╰──────────────────────────────────────╯
      devShells.go = pkgs.mkShell {
        buildInputs = with pkgs; [
          go
          gotools
          delve
          pkg-config
        ];
      };

      # ╭──────────────────────────────────────╮
      # │ RUST                                 │
      # ╰──────────────────────────────────────╯
      # https://github.com/BKSalman/ytdlp-gui/blob/main/flake.nix
      devShells.rust = pkgs.mkShell {
        doCheck = false;
        buildType = "debug";
        # OPENSSL_NO_VENDOR = 1;
        buildInputs = with pkgs; [
          cargo
          rustc
          clang
          cmake
          meson
          ninja
          pkg-config
          openssl
        ];
      };

      # ╭──────────────────────────────────────╮
      # │ PYTHON                               │
      # ╰──────────────────────────────────────╯
      devShells.py-pkgs = pkgs.mkShell {
        buildInputs = with pkgs; [
          (python3.withPackages (
            p: with p; [
              requests
              pyaml
            ]
          ))
        ];
      };

      # python setup.py install --root=/home/iab/devs/
      devShells.py-dev = pkgs.mkShell {
        buildInputs = with pkgs; [
          python3
          virtualenv
          uv
          python3Packages.pip
          meson
          ninja
        ];
        env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc.lib
          pkgs.libz
        ];
      };

      # ╭──────────────────────────────────────╮
      # │ RUBY                                 │
      # ╰──────────────────────────────────────╯
      # bundix -l   # generates gemset.nix & Gemfile.lock
      # cp Gemfile Gemfile.lock gemset.nix
      devShells.ruby = pkgs.mkShell {
        buildInputs = with pkgs; [
          ruby
          bundix
          gnumake
          pkg-config
          git
        ];
      };

      # ╭──────────────────────────────────────╮
      # │ JAVA                                 │
      # ╰──────────────────────────────────────╯
      devShells.java = pkgs.mkShell {
        buildInputs = with pkgs; [
          jdk
          gradle
        ];
      };

      # ╭──────────────────────────────────────╮
      # │ ANDROID                              │
      # ╰──────────────────────────────────────╯
      # Android APK build shell (Flutter).
      devShells.apk =
        let
          pinnedJDK = pkgs.jdk17;
          buildToolsVersion = "34.0.0";
          androidComposition = pkgs.androidenv.composeAndroidPackages {
            buildToolsVersions = [ buildToolsVersion ];
            platformVersions = [ "34" ];
            # Uncomment these only if the project has native C/C++ modules.
            # includeNDK = true;
            # ndkVersions = [ "25.1.8937393" ];
            # cmakeVersions = [ "3.22.1" ];
          };
          androidSdkRoot = "${androidComposition.androidsdk}/libexec/android-sdk";
        in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            pinnedJDK
            androidComposition.androidsdk
            flutter
          ];

          JAVA_HOME = "${pinnedJDK}";
          ANDROID_HOME = androidSdkRoot;
          ANDROID_SDK_ROOT = androidSdkRoot;
          # ANDROID_NDK_ROOT = "${androidSdkRoot}/ndk-bundle";
          GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdkRoot}/build-tools/${buildToolsVersion}/aapt2";
        };

      /*
        # Flutter
        keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
        cp key.jks android/app

        micro android/key.properties
        storePassword=123456
        keyPassword=123456
        keyAlias=key
        storeFile=./key.jks
      */

      # ╭──────────────────────────────────────╮
      # │ HASKELL                              │
      # ╰──────────────────────────────────────╯
      devShells.haskell = pkgs.mkShell {
        buildInputs = with pkgs; [
          ghc
          stack
          cabal-install
          haskell-language-server
        ];
      };

    };
}
