#!/usr/bin/env bash

while IFS= read -r line; do
    if [[ "$line" == *"#"* ]]; then
        continue
    fi
    yt-dlp -f bestaudio --extract-audio --audio-format opus --progress -o "/home/vinii/projects/Project-Reconquista/downloaded_songs/%(title)s.%(ext)s" "${line//\,/}"
done < ./song_list.csv

