
ffmpeg -re -i lol-ob-1080p-60fps-aac-5m.flv -c copy -f flv rtmp:192.168.5.5/live/lol
ffmpeg -re -i lol-ob-1080p-60fps-aac-220213-blg-vs-lng.flv -c copy -f flv rtmp:192.168.5.5/live/lol
ffmpeg -stream_loop 3 -ss 400 -re -i lol-ob-1080p-60fps-aac-220213-blg-vs-lng.flv -c copy -f flv rtmp:192.168.5.5/live/lol


