#!/bin/bash

# 2.5G
size=$((2560 * 1024 * 1024))

sudo modprobe zram

for device in /sys/block/zram*; do
  if [[ "$(cat "$device/disksize")" == '0' ]]; then
    unused_device="/dev/${device##*/}"
    break
  fi
done

if [[ -z "$unused_device" ]]; then
  echo "Could not find an unused zram device."
  exit 1
fi

echo $size | sudo tee "$device/disksize"

sudo mkswap $unused_device

sudo swapon $unused_device

swapon --show

echo 200 > /proc/sys/vm/swappiness

echo 0 > /proc/sys/vm/page-cluster
