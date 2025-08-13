ffmpeg -i song.opus -an -c:v copy cover.jpeg

# or magick cover.png cover.jpeg
# # must be jpeg

ffmpeg -i song.opus -i cover.jpeg -map 0:a -map 1 -c:a libmp3lame -q:a 2 -id3v2_version 3 song.mp3
