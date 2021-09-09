#ffmpeg -hide_banner -loglevel error -i $1 -f s16le -acodec raw -
#ffmpeg -hide_banner -loglevel error -i $1 -f s16le -acodec pcm_s16le -

ffmpeg -hide_banner -loglevel error -y  -i $1  -acodec pcm_s16le -f s16le -ac 1 -ar 8000 -


