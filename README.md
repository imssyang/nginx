# nginx

```
https://www.howtoforge.com/tutorial/how-to-build-nginx-from-source-on-ubuntu-1804-lts/
https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#sources
http://nginx.org/en/docs/

nginx -t -c nginx.conf  检查配置文件语法
```

### 本地DNS

```
C:\Windows\System32\drivers\etc\hosts
192.168.5.220    imssyang.com
192.168.5.220    www.imssyang.com
192.168.5.220    gitea.imssyang.com
192.168.5.220    httpd.imssyang.com
192.168.5.220    nginx.imssyang.com
192.168.5.220    pgadmin.imssyang.com
192.168.5.220    freeswitch.imssyang.com
ipconfig /flushdns
```

## 自适应比特率视频（adaptive bitrate video）

[HLS vs DASH](https://www.vidbeo.com/blog/hls-vs-dash)

### HTTP Live Streaming (HLS)

[Apple HTTP Live Streaming](https://developer.apple.com/streaming)

- HTTP 
- H264 
- MPEG-2 
- 10s.ts | 10s.mp4
- manifest.m3u8`

ffmpeg -re -I bbb_sunflower_1080p_60fps_normal.mp4 -vcodec copy -loop -1 -c:a aac -b:a 160k -ar 44100 -strict -2 -f flv rtmp:192.168.5.5/live/bbb

### Smooth Streaming

[Microsoft Smooth Streaming](#)

### HDS 

[Adobe](#)

### Dynamic Adaptive Streaming over HTTP (DASH)

- HTTP
- H264|H265|VP9
- 3s.mp4
- manifest.mpd (media presentation description)

## CDN (content delivery network)


