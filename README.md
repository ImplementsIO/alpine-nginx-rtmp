Alpine nginx with rtmp-module & ffmpeg tools

## Information

- nginx=1.11.5
- nginx-rtmp-module=1.1.10
	
## Usage

- Onbuild 

```
FROM thonatos:alpine-nginx-rtmp

# copy file for your server

RUN mkdir -p /app
VOLUME /app
COPY src/ /app

```

- Run

```
docker run --name ann -p 80:80 -p 443:443 -p 8080:8080 -p 1935:1935
```

## PUSH/PLAY

### PUSH

```
# HLS
ffmpeg -re -i nju_campus.mp4 -vcodec libx264 -acodec copy -b:v 1M -s 960x480 -f flv rtmp://127.0.0.1/hls/test

# DASH
ffmpeg -re -i nju_campus.mp4 -vcodec libx264 -acodec copy -b:v 1M -s 960x480 -f flv rtmp://127.0.0.1/dash/test
```

## PLAY

```
ffmplay http://127.0.0.1/hls/test.m3u8
```