#!/bin/bash

OSZ_PATH="$1"
OSU_DIR="$(cat "$HOME"/.config/osuless/osu_dir.conf)"
SONGS_DIR="$OSU_DIR/Songs/"

DEST="$SONGS_DIR/$(basename -s .osz "$OSZ_PATH")"

unzip "$OSZ_PATH" -d "$DEST"
rm "$OSZ_PATH"
