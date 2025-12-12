#!/bin/bash

# Get the current workspace ID
ws=$(hyprctl activeworkspace -j | jq -r '.id')

# Get all window addresses on that workspace
hyprctl clients -j \
  | jq -r ".[] | select(.workspace.id == $ws) | .address" \
  | while read -r addr; do
        hyprctl dispatch closewindow address:$addr
    done
