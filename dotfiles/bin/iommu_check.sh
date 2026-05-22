#!/usr/bin/env bash
shopt -s nullglob
for g in $(printf '%s\n' /sys/kernel/iommu_groups/* | sort -V); do
    [[ -d "$g" ]] || continue

    echo "IOMMU Group ${g##*/}:"
    for d in "$g"/devices/*; do
        echo -e "\t$(lspci -nn -s "${d##*/}")"
    done
done
