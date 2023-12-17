#!/bin/bash -e

cleanUp()
{
  echo "Cleaning up..."
    rm -rf "$temp_dir"
  exit 1
}

trap cleanUp EXIT INT TERM

if [ $# -ne 1 ]; then
  echo "For script to work follow this example: $0 <source_file>"
  exit 1
fi

source_file="$1"

if [ ! -f "$source_file" ]
then
  echo "Source file not found: $source_file"
  exit 1
fi

temp_dir=$(mktemp -d)
if [ ! -d "$temp_dir" ]; then
  echo "Failed to create a temp directory."
  cleanUp
fi

output_name=$(grep '&Output:' "$source_file" | cut -d ':' -f 2)

if [ -z "$output_name" ]
then
  echo "No '&Output:' comment found in the source file."
  cleanUp
fi

g++ -o "$temp_dir/$output_name" "$source_file"

mv "$temp_dir/$output_name" "./$output_name"

rm -rf "$temp_dir"

echo "Build successful! Output: $output_name"
