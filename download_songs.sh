#!/usr/bin/env bash

songs_filepath="/home/vinii/projects/Project-Reconquista/downloaded_songs/%(title)s.%(ext)s"
playlists_filepath="/home/vinii/projects/Project-Reconquista/downloaded_songs/playlists/%(playlist_title)/%(title)s.%(ext)s"

case "$1" in
    "--songs")
        while IFS= read -r line; do
            if [[ "$line" == *"#"* ]]; then
                continue
            fi
            yt-dlp -f bestaudio --extract-audio --audio-format opus --progress -o "$songs_filepath" "${line//\,/}" 2>> songs_err.log
        done < ./list.csv.txt
    ;;
    "--playlists")
        next_is_helldivers=false
        while IFS= read -r line; do
            if [[ "$line" == *"#"* ]]; then
                next_is_helldivers=false
                if [[ "$line" == *"Helldivers"* ]]; then
                    next_is_helldivers=true
                fi
                continue
            fi
            if [[ "$next_is_helldivers" == true ]]; then
                yt-dlp --match-filter "title~=.*Original Game Soundtrack.*" -f bestaudio --extract-audio --audio-format opus --progress -o "$playlists_filepath" "${line//\,/}" 2>> playlists_err.log
                next_is_helldivers=false
                continue
            fi
            yt-dlp -f bestaudio --extract-audio --audio-format opus --progress -o "$playlists_filepath" "${line//\,/}" 2>> playlists_err.log
        done < ./playlists_list.csv
    ;;
    # "--titles-only")
    #     while IFS= read -r line; do
    #         if [[ "$line" == *"#"* ]]; then
    #             continue
    #         fi
    #         yt-dlp --print title "${line//\,/}" >> ./songs_titles.txt 2>> titles_err.log
    #     done < ./song_list.csv
    # ;;
    *) 
        echo "No option specified"
        exit 0
    ;;
esac


