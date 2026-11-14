#!/bin/sh
# Double-click installer for macOS: runs install.sh from this folder
cd "$(dirname "$0")"
sh ./install.sh
echo
printf "Press Enter to close / 엔터로 닫기 "
read -r _
