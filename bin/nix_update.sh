#!/bin/bash

cd ~/.config/nixconfig

darwin-rebuild switch --flake .
&& sudo nix-store --verify --check-contents --repair      \
&& osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"~/.config/nixconfig/pictures/rocket-space-minimal.jpeg\" as POSIX file"
