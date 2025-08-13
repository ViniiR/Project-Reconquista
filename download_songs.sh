#!/usr/bin/env bash

songs_filepath="/home/vinii/projects/Project-Reconquista/downloaded_songs/%(title)s[%(autonumber)d].%(ext)s"
songs_custom_filepath="/home/vinii/projects/Project-Reconquista/temp/%(title)s[%(autonumber)d].%(ext)s"
playlists_filepath="/home/vinii/projects/Project-Reconquista/downloaded_songs/playlists/%(playlist_title)s/%(title)s[%(autonumber)d].%(ext)s"

yt_dlp_args=(-f "bestaudio" --extract-audio --audio-format "mp3" --progress --embed-metadata --embed-thumbnail)

case "$1" in
    "--songs")
        while IFS= read -r line; do
            if [[ "$line" == *"#"* ]]; then
                continue
            fi
            yt-dlp "${yt_dlp_args[@]}" -o "$songs_filepath" "${line//\,/}" 2>> ./logs/songs_err.log
        done < ./list.csv.txt
    ;;
    "--custom-list")
        while IFS= read -r line; do
            if [[ "$line" == *"#"* ]]; then
                continue
            fi
            yt-dlp "${yt_dlp_args[@]}" -o "$songs_custom_filepath" "${line//\,/}" 2>> ./logs/custom_songs_err.log
        done < "./$2"
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
                # WARNING: does not download the The Illuminate Cult song (do manually idgaf)
                yt-dlp --match-filter "title~=.*Original Game Soundtrack.*" "${yt_dlp_args[@]}" -o "$playlists_filepath" "${line//\,/}" 2>> ./logs/playlists_err.log
                next_is_helldivers=false
                continue
            fi
            yt-dlp "${yt_dlp_args[@]}" -o "$playlists_filepath" "${line//\,/}" 2>> ./logs/playlists_err.log
        done < ./playlists_list.csv
    ;;
    # "--titles-only")
    #     while IFS= read -r line; do
    #         if [[ "$line" == *"#"* ]]; then
    #             continue
    #         fi
    #         yt-dlp --print title "${line//\,/}" >> ./songs_titles.txt 2>> ./logs/titles_err.log
    #     done < ./song_list.csv
    # ;;
    *) 
        echo "No option specified"
        exit 0
    ;;
esac


