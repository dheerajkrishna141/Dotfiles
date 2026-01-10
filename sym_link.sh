#!/bin/bash

SOURCE_DIR="$HOME/Dotfiles"
TARGET_DIR="$HOME/.config"

echo "Starting Dotfiles setup..."

mkdir -p "$TARGET_DIR"

for source_path in "$SOURCE_DIR"/*; do
	config_name=$(basename "$source_path")

	target_path="$TARGET_DIR/$config_name"

	if [[ "$config_name" == "sym_link.sh" || "$config_name" == ".git" || "$config_name" == "README.md" ]]; then
		continue
	fi
	
	if [ -L "$target_path" ]; then
		echo "$config_name is already linked."
	elif [ -e "$target_path" ]; then
		echo "$config_name already exists at $target_path and is not a link."
	
	else
		ln -s "$source_path" "$target_path"
		echo "Linked $config_name -> $target_path"
	fi
done

echo "Done!"
