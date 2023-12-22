#!/bin/bash -e

directory="/data"
max_files=999
lock_file="$directory/synchronization_lock"

# Function to generate a random container identifier
generate_random_identifier() {
    seed=$(date +%s)
    random_string=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
    container_identifier="${seed}_${random_string}"
    echo "$container_identifier"
}

# Function to find the next available file name in the directory
find_next_available_name() {  
    for i in $(seq -w 1 "$max_files"); do
        filename="$(printf "%03d" "$i")" # Format as "001," "002," etc.
        # Check if the file does not exist in the directory
        if [ ! -e "$directory/$filename" ]; then
            echo "$filename"
            return # Return the first available file name
        fi
    done
    # If all file names are occupied
    echo "No available file names"
}

while true; do
    (
        flock -x 200

        next_filename=$(find_next_available_name)

        if [ ! -e "$directory/$next_filename" ]; then
            # Generate a random container identifier
            container_identifier=$(generate_random_identifier)
            content="$next_filename : $container_identifier"

            echo "$content" >"$directory/$next_filename"
        fi
    ) 200>"$flock_file"

    sleep 1
    # Add an additional sleep to delay before next step
    sleep 1

    (
        flock -x 200

        if [ -n "$next_filename"] && [ -e "$directory/$next_filename" ]; then
            rm "$directory/$next_filename"
        fi
    ) 200<"$lock_file"
done
