#!/bin/bash

OSU_DIR="$(cat "$HOME"/.config/osuless/osu_dir.conf)"
SONGS_DIR="$OSU_DIR/Songs/"

function osuless_install() {
	osz_path="$1"
	dest="$SONGS_DIR/$(basename -s .osz "$osz_path")"
	unzip "$osz_path" -d "$dest"
	rm "$osz_path"
}

case $1 in
	install)
		osuless_"$1" "${@:2}"
		;;
	*.osz)
		# This is for xdg default application support. AFAIK you can't add a command/arg to it.
	        #     TODO: Create custom osuless_default script or something as a wrapper for this.
		osuless_install "$1"
		;;
	*)
		# TODO: osuless_help
		exit 0
		;;
esac
