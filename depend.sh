#!/bin/bash

echo "installing dependencies to build instantos packages"
sudo pacman -S --needed wmctrl xdotool go ninja meson check
