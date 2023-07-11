#!/bin/bash

DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# create osu directory structure
OSU_DIR="$HOME/osu!"
if ! [ -d "$OSU_DIR" ] ; then
	mkdir "$OSU_DIR"
fi
if ! [ -d "$OSU_DIR/Songs" ] ; then
	mkdir "$OSU_DIR/Songs"
fi
if ! [ -d "$OSU_DIR/Skins" ] ; then
	mkdir "$OSU_DIR/Skins"
fi

# INSTALL OSULESS (local config)
# Mostly system-wide for now. Basically why: https://github.com/JuliaLang/juliaup/issues/247
# sudo cp "$DIR"/build/osuless /usr/local/bin # remember symlinks to other directories?
BIN_PATH="/usr/local/bin/osuless"
DESKTOP_PATH="/usr/share/applications/osuless.desktop"

if ! [ -d "$HOME/.config/osuless" ] ; then
	mkdir "$HOME/.config/osuless"
fi
echo "$OSU_DIR" | tee "$HOME/.config/osuless/osu_dir.conf"

sudo cp "$DIR/scripts/osuless.sh" "$BIN_PATH" && sudo chmod +x "$BIN_PATH"

# TODO: store this in a file in 'data' dir in this project
cat <<EOF | sudo tee "$DESKTOP_PATH"
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=false
Exec=$BIN_PATH
Name=osuless
#Icon=/path/to/icon
EOF

# install custom osz mime-type
xdg-mime install --novendor "$DIR/data/osuless.xml"
xdg-mime default "$(basename "$DESKTOP_PATH")" "application/osz"
#sudo cp "$DIR/data/mime_package.xml" "/usr/share/mime/packages/osuless.xml"

