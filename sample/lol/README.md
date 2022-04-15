
ffmpeg -re -i lol-ob-1080p-60fps-aac-5m.flv -c copy -f flv rtmp:192.168.5.5/live/lol
ffmpeg -re -i lol-ob-1080p-60fps-aac-220213-blg-vs-lng.flv -c copy -f flv rtmp:192.168.5.5/live/lol
ffmpeg -stream_loop 3 -ss 400 -re -i lol-ob-1080p-60fps-aac-220213-blg-vs-lng.flv -c copy -f flv rtmp:192.168.5.5/live/lol

ffmpeg -re -i lol-zb-1080p-30fps-aac-40m.flv -c copy -f flv "rtmp://live-push.bilivideo.com/live-bvc/?streamname=live_1528640333_27984654&key=fa5e70a547ea79ca457f85a0079f2487&schedule=rtmp&pflag=1"

