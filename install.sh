#!/bin/bash

# TODO: go over user-only vs system-wide install, root install etc

DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

### INSTALL OSULESS (local config)

BIN_PATH="/usr/local/bin/osuless"
DESKTOP_PATH="/usr/share/applications/osuless.desktop"

if ! [ -d "$HOME/.config/osuless" ] ; then
	mkdir "$HOME/.config/osuless"
fi

sudo cp "$DIR/scripts/osuless.sh" "$BIN_PATH" && sudo chmod +x "$BIN_PATH"

# Create desktop entry
desktop_template=$(cat "$DIR/data/osuless.desktop.template")
desktop_entry="${desktop_template/__BIN_PATH__/$BIN_PATH}"
echo "$desktop_entry" | sudo tee "$DESKTOP_PATH" >> /dev/null

# Install custom osz mime-type
xdg-mime install --novendor "$DIR/data/osuless.xml"
xdg-mime default "$(basename "$DESKTOP_PATH")" "application/osz"
xdg-mime default "$(basename "$DESKTOP_PATH")" "application/osk"

### CONFIGURE OSULESS
$BIN_PATH reconfigure
