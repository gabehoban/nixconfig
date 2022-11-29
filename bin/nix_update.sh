#!/bin/bash

cd ~/.config/nixconfig

nix-env --delete-generations +3 \
&& sudo nix-collect-garbage \
&& darwin-rebuild switch --flake . \
&& osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"~/.config/nixconfig/pictures/rocket-space-minimal.jpeg\" as POSIX file"
