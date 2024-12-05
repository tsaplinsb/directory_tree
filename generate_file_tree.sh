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

    # Choose branch character ├── or └──
    if [ "$is_last" -eq 1 ]; then
      local branch="└──"
      local new_prefix="$prefix    "
    else
      local branch="├──"
      local new_prefix="$prefix│   "
    fi

    # Adding Markdown list item with proper formatting
    if [ -d "$item" ]; then
      echo "$prefix* 📁 **[$name]($url_name)**" >> "$OUTPUT_FILE"
      generate_tree "$item" "$new_prefix" # Recurse into subdirectories
    else
      echo "$prefix* 📄 [$name]($url_name)" >> "$OUTPUT_FILE"
    fi
  done
}

generate_tree "$BASE_DIR" ""

echo "File tree has been written to $OUTPUT_FILE"
