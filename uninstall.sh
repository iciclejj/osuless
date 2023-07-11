#!/bin/bash

# TODO: source separate bash script for variables such as DIR, BIN_PATH etc?

DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Ask to delete osu! directory (TODO)

# Uninstall mime-type and default application
xdg-mime uninstall "$DIR/data/osuless.xml"

# Delete osuless binary and desktop application entry
sudo rm "/usr/local/bin/osuless"
sudo rm "/usr/share/applications/osuless.desktop"

# Delete osuless directories. TODO: ask, especially about the configs :)
rm -r "$HOME/.config/osuless/"

