#!/bin/sh

# Function to generate a random container identifier
generate_random_identifier() {
    seed=$(date +%s)
    random_string=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
    container_identifier="${seed}_${random_string}"
    echo "$container_identifier"
}

# Function to find the next available file name in the directory
find_next_available_name() {
    directory="/data" # Adjust this to your specific directory

    # Iterate from 1 to a maximum number (e.g., 999)
    for i in $(seq -w 1 999); do
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

        if [ ! -e "/data/$next_filename" ]; then
            # Generate a random container identifier
            container_identifier=$(generate_random_identifier)

            # Format the content as "001 : <identifier>"
            content="$next_filename : $(generate_random_identifier)"

            echo "$content" >"/data/$next_filename"
        fi
    ) 200>/data/synchronization_lock

    sleep 1

    # Add an additional sleep to delay before next step
    sleep 1

    (
        flock -x 200

        if [ -e "/data/$next_filename" ]; then
            rm "/data/$next_filename"
        fi
    ) 200>/data/synchronization_lock
done
