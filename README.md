Alpine Nginx With rtmp-module

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