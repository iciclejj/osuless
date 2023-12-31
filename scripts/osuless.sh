#!/bin/bash

# Get osuless directories
OSULESS_CONFIG_DIR="$HOME/.config/osuless"
OSULESS_OSU_DIR=""
if [ -f "$OSULESS_CONFIG_DIR/osu_dir.conf" ]; then
	OSULESS_OSU_DIR="$(cat "$HOME"/.config/osuless/osu_dir.conf)"
fi

DEFAULT_OSU_DIR="$HOME/osu!"

STEAM_DIR="$HOME/.steam/steam"
MCOSU_DIR="$STEAM_DIR/steamapps/common/McOsu"
MCOSU_CONFIG_PATH="$MCOSU_DIR/cfg/osu.cfg"

function osuless_install() {
	local osz_path="$1"

	case $osz_path in
		*.osz)
			local dest="$OSULESS_OSU_DIR/Songs/$(basename -s .osz "$osz_path")" ;;
		*.osk)
			local dest="$OSULESS_OSU_DIR/Skins/$(basename -s .osk "$osz_path")" ;;
		*)
			echo "Can't determine osu filetype. Did you remove the file extension?" ;;
	esac

	unzip "$osz_path" -d "$dest"
	rm "$osz_path"
}

function _osuless_reconfigure_create_dir_strucure() {
	local osu_path="$1"

	# create directories
	mkdir -p "$osu_path"
	mkdir -p "$osu_path/Songs"
	mkdir -p "$osu_path/Skins"
}

function _osuless_reconfigure_update_configs() {
	local osu_dir="$1"

	# set config files
	echo "$osu_dir" | tee "$OSULESS_CONFIG_DIR/osu_dir.conf" >> /dev/null
	echo "$OSULESS_CONFIG_DIR/osu_dir.conf updated..."

	if [ -f "$MCOSU_CONFIG_PATH" ]; then
		awk -v key="osu_folder" -v value="$osu_dir" 'BEGIN{OFS=" "} $1==key {$2=value} 1' "$MCOSU_CONFIG_PATH" > temp && mv temp "$MCOSU_CONFIG_PATH"
		echo "$MCOSU_CONFIG_PATH updated..."
	else
		echo "$MCOSU_CONFIG_PATH not found; skipping..."
	fi
}

function osuless_reconfigure() {
	local mcosu_osu_dir=""
	local osu_dir=""

	# Get mcosu's selected osu directory
	if [ -f "$MCOSU_CONFIG_PATH" ]; then
		local mcosu_config_file="$MCOSU_CONFIG_PATH"
		mcosu_osu_dir="$(awk -F ' ' '/^osu_folder/ {print $2}' "$mcosu_config_file")"
	fi

	if [ -d "$OSULESS_OSU_DIR" ] && [ -d "$mcosu_osu_dir" ] && [ "$OSULESS_OSU_DIR" != "$mcosu_osu_dir" ]; then
		echo "Found separate existing osu directories pointed to by both osuless and mcosu."
		echo "mcosu: $mcosu_osu_dir"
		echo "osuless: $OSULESS_OSU_DIR"
		echo "osuless default dir: $DEFAULT_OSU_DIR"
		read -p "1) use mcosu dir   2) use osuless dir   3) use/create default dir: " dir_choice

		# TODO: Add option to merge the directories

		case $dir_choice in
			1) osu_dir="$mcosu_osu_dir" ;;
			2) osu_dir="$OSULESS_OSU_DIR" ;;
			3) osu_dir="$DEFAULT_OSU_DIR" ;;
		esac
	elif [ -d "$OSULESS_OSU_DIR" ]; then
		echo "Using existing osu directory pointed to by osuless: $OSULESS_OSU_DIR"
		osu_dir="$OSULESS_OSU_DIR"
	elif [ -d "$mcosu_osu_dir" ]; then
		echo "Using existing osu directory pointed to by mcosu: $mcosu_osu_dir"
		osu_dir="$mcosu_osu_dir"
	else
		echo "Found no existing osu directories pointed to by osuless or mcosu."
		echo "Creating new directory at $DEFAULT_OSU_DIR"
		osu_dir="$DEFAULT_OSU_DIR"
	fi
	_osuless_reconfigure_create_dir_strucure "$osu_dir"

	echo "Updating config files..."
	_osuless_reconfigure_update_configs "$osu_dir"

	echo "Osuless configuration finished."
}

case $1 in
	install|reconfigure)
		osuless_"$1" "${@:2}"
		;;
	*.osz|*.osk)
		# This is for xdg default application support. AFAIK you can't add a command/arg to it.
		#	TODO: Create custom osuless_default script or something as a wrapper for this.
		osuless_install "$1"
		;;
	*)
		# TODO: osuless_help
		exit 0
		;;
esac
