#!/bin/bash -e

directory="/data"
max_files=999
lock_file="$directory/synchronization_lock"

# Генерация случайного идентификатора контейнера
generate_random_identifier() {
    seed=$(date +%s)
    random_string=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
    container_identifier="${seed}_${random_string}"
    echo "$container_identifier"
}

# Определение незанятого имени
find_next_available_name() {  
    for i in $(seq -w 1 "$max_files"); do
        filename="$(printf "%03d" "$i")" # Format as "001," "002," etc.
        if [ ! -e "$directory/$filename" ]; then
            echo "$filename"
            return
        fi
    done
    # Если нет свободных
    echo "No available file names"
}

while true; do
    (
        flock -x 200

        next_filename=$(find_next_available_name)

        if [ ! -e "$directory/$next_filename" ]; then
            container_identifier=$(generate_random_identifier)
            content="$next_filename : $container_identifier"
            echo "$content" >"$directory/$next_filename"
        fi
    ) 200>"$flock_file"

    sleep 1

    (
        flock -x 200

        if [ -n "$next_filename"] && [ -e "$directory/$next_filename" ]; then
            rm "$directory/$next_filename"
        fi
    ) 200<"$lock_file"
done
