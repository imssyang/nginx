# nginx

```
https://www.howtoforge.com/tutorial/how-to-build-nginx-from-source-on-ubuntu-1804-lts/
https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#sources
http://nginx.org/en/docs/

nginx -t -c nginx.conf  检查配置文件语法
chrome://media-internals
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


## 更新日志

```
vi /etc/crontab
   0 0     * * *   root    /opt/nginx/setup/setup.sh log   #每天00:00:00时更新日志
```

# RTMP推拉流

```
ffmpeg -re -i bbb_sunflower_1080p_60fps_normal.mp4 -vcodec copy -loop -1 -c:a aac -b:a 160k -ar 44100 -strict -2 -f flv rtmp:192.168.5.5/live/bbb
vlc rtmp://192.168.5.5/live/bbb                播放实时流
vlc rtmp://192.168.5.5/record/bbb              播放实时流并自动录制flv文件
vlc rtmp://192.168.5.5/replay/60s.flv          回放flv录像文件
vlc rtmp://192.168.5.5/sample/h264-mp3.flv     回放flv示例文件
chrome http://rtmp.imssyang.com/flv/demo.html  回放flv示例文件（flv.js）
chrome http://rtmp.imssyang.com/flv/index.html 回放flv示例文件（flv.js）
```

# RTMP控制模块

https://github.com/arut/nginx-rtmp-module/wiki/Control-module

```
curl 'http://rtmp.imssyang.com/control/record/start?app=live&name=bbb&rec=flv'  开启录像
     /opt/nginx/record/bbb-1637631889-20211123-094449.flv  (succ:返回录像文件, fail:空)
curl 'http://rtmp.imssyang.com/control/record/stop?app=live&name=bbb&rec=flv'   停止录像
     /opt/nginx/record/bbb-1637631889-20211123-094449.flv  (succ:返回录像文件, fail:空)
curl 'http://rtmp.imssyang.com/control/drop/publisher?app=live&name=bbb'        停止推流方
     1 (1:succ，0:fail)
curl 'http://rtmp.imssyang.com/control/drop/subscriber?app=live&name=bbb'       停止拉流方（订阅）
     1 (1:succ，0:fail)
curl 'http://rtmp.imssyang.com/control/drop/client?app=live&name=bbb&addr=192.168.5.2'  停止拉流方
     1 (1:succ，0:fail)
curl 'http://rtmp.imssyang.com/control/drop/client?app=live&name=bbb&clientid=1'        停止拉流方
     1 (1:succ，0:fail)
curl 'http://rtmp.imssyang.com/control/redirect/publisher?app=live&name=bbb&newname=ccc' 重定向bbb的流到ccc
     1 (1:succ，0:fail)
curl 'http://rtmp.imssyang.com/control/redirect/subscriber?app=live&name=bbb&addr=192.168.5.2&newname=ccc' 重定向bbb的流到ccc
     1 (1:succ，0:fail)
curl 'http://rtmp.imssyang.com/control/redirect/client?app=live&name=bbb&newname=ccc' 重定向bbb的流到ccc
     1 (1:succ，0:fail)
```

# Compile

## Mac

```bash
brew install libxslt libgd libgeoip
tar xvf nginx-1.26.1.tar.gz
tar xvf nginx-rtmp-module-1.2.2.tar.gz
tar xvf njs-0.8.5.tar.gz

./configure --prefix=/opt/nginx \
  --sbin-path=/opt/nginx/bin/nginx \
  --modules-path=/opt/nginx/modules \
  --conf-path=/opt/nginx/conf/nginx.conf \
  --pid-path=/opt/nginx/logs/nginx.pid \
  --lock-path=/opt/nginx/logs/nginx.lock \
  --error-log-path=/opt/nginx/logs/error.log \
  --http-log-path=/opt/nginx/logs/access.log \
  --http-client-body-temp-path=/opt/nginx/logs/client \
  --http-proxy-temp-path=/opt/nginx/logs/proxy \
  --http-fastcgi-temp-path=/opt/nginx/logs/fastcgi \
  --http-uwsgi-temp-path=/opt/nginx/logs/uwsgi \
  --http-scgi-temp-path=/opt/nginx/logs/scgi \
  --with-select_module \
  --with-poll_module \
  --with-threads \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_v3_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_xslt_module \
  --with-http_image_filter_module \
  --with-http_geoip_module \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_auth_request_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_degradation_module \
  --with-http_slice_module \
  --with-http_stub_status_module \
  --with-http_perl_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-stream \
  --with-stream_ssl_module \
  --with-stream_realip_module \
  --with-stream_geoip_module \
  --with-stream_ssl_preread_module \
  --with-compat \
  --with-cc-opt="-Wno-error=unused-but-set-variable -Wno-error=compound-token-split-by-macro" \
  --add-module=/opt/nginx/archive/nginx-rtmp-module-1.2.2 \
  --add-module=/opt/nginx/archive/njs-0.8.5/nginx

// Compile
make -j8

// Create Perl directory with write permission
sudo mkdir /Library/Perl/5.34/darwin-thread-multi-2level
sudo chmod g+w /Library/Perl/5.34/darwin-thread-multi-2level
sudo mkdir /usr/local/share/man/man3
sudo chmod g+w /usr/local/share/man/man3
sudo mkdir -p /Library/Perl/Updates/5.34.1/darwin-thread-multi-2level
sudo chmod g+w /Library/Perl/Updates/5.34.1/darwin-thread-multi-2level

// Install
make install
```

## Linux

```bash
apt-get install libxml2 libxslt1-dev libgd-dev libgeoip-dev libperl-dev

https://github.com/nginx/nginx/releases/download/release-1.28.0/nginx-1.28.0.tar.gz
https://github.com/arut/nginx-rtmp-module/archive/refs/tags/v1.2.2.zip
https://github.com/nginx/njs/archive/refs/tags/0.9.1.zip

./configure --prefix=/opt/nginx \
  --sbin-path=/opt/nginx/bin/nginx \
  --modules-path=/opt/nginx/modules \
  --conf-path=/opt/nginx/conf/nginx.conf \
  --pid-path=/opt/nginx/logs/nginx.pid \
  --lock-path=/opt/nginx/logs/nginx.lock \
  --error-log-path=/opt/nginx/logs/error.log \
  --http-log-path=/opt/nginx/logs/access.log \
  --http-client-body-temp-path=/opt/nginx/logs/client \
  --http-proxy-temp-path=/opt/nginx/logs/proxy \
  --http-fastcgi-temp-path=/opt/nginx/logs/fastcgi \
  --http-uwsgi-temp-path=/opt/nginx/logs/uwsgi \
  --http-scgi-temp-path=/opt/nginx/logs/scgi \
  --with-select_module \
  --with-poll_module \
  --with-threads \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_v3_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_xslt_module \
  --with-http_image_filter_module \
  --with-http_geoip_module \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_auth_request_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_degradation_module \
  --with-http_slice_module \
  --with-http_stub_status_module \
  --with-http_perl_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-stream \
  --with-stream_ssl_module \
  --with-stream_realip_module \
  --with-stream_geoip_module \
  --with-stream_ssl_preread_module \
  --with-compat \
  --with-cc-opt="-Wimplicit-fallthrough=0" \
  --with-ld-opt="-L/usr/lib/x86_64-linux-gnu" \
  --add-module=/opt/nginx/archive/nginx-rtmp-module-1.2.2 \
  --add-module=/opt/nginx/archive/njs-0.9.1/nginx
```

