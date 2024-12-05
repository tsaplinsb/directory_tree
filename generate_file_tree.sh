#!/bin/bash

# Script to generate a file tree with markdown links for README.md

OUTPUT_FILE="FILE_TREE.md"  # Name of the output file
BASE_DIR=${1:-.}            # Directory to scan (default: current directory)

# Create or clear the output file
echo "# File Tree" > "$OUTPUT_FILE"
echo "Generated from the directory: \`$BASE_DIR\`" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

generate_tree() {
  local dir=$1
  local prefix=$2
  local children=($(ls -A "$dir"))

  for i in "${!children[@]}"; do
    local item="$dir/${children[i]}"
    local name="${children[i]}"
    local is_last=$((i == ${#children[@]} - 1))

    # Replace spaces with %20 for URLs
    local url_name=${item// /%20}

    # If it's a directory, list it with a "📁" icon
    if [ -d "$item" ]; then
      echo "$prefix* 📁 **[$name]($url_name)**" >> "$OUTPUT_FILE"
      generate_tree "$item" "$prefix    " # Recurse into subdirectories with more spaces for indentation
    else
      # If it's a file, list it with a "📄" icon
      echo "$prefix* 📄 [$name]($url_name)" >> "$OUTPUT_FILE"
    fi
  done
}

generate_tree "$BASE_DIR" ""

echo "File tree has been written to $OUTPUT_FILE"
