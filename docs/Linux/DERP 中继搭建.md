# DERP 中继搭建

## 有域名

> 环境准备: 
> 1. Go 1.20+ 
> 2. 域名和 https 证书

搭建步骤：

```bash
# 1. 安装，路径在 $GOROOT/bin $GOBIN $GOPATH/bin 中的一个，一般在 $GOPATH/bin
go install tailscale.com/cmd/derper@main

# 

# 2. 执行命令
derper --hostname=example.com --a=:12345 --certdir=/root/certs 
```

Dockerfile:

```dockerfile
FROM golang:latest AS builder
WORKDIR /app

# https://tailscale.com/kb/1118/custom-derp-servers/
RUN go install tailscale.com/cmd/derper@main

FROM ubuntu
WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y ca-certificates && \
    mkdir /app/certs

ENV DERP_DOMAIN your-hostname.com
ENV DERP_CERT_MODE letsencrypt
ENV DERP_CERT_DIR /app/certs
ENV DERP_ADDR :443
ENV DERP_STUN true
ENV DERP_HTTP_PORT 80
ENV DERP_VERIFY_CLIENTS false

COPY --from=builder /go/bin/derper .

# docker run -d --name derp --restart=always -p 3478:3478/udp -p 9443:9443 -v /root/certs:/app/certs -e DERP_DOMAIN=example.com -e DERP_ADDR=:9443 -e DERP_CERT_MODE=manual derper
CMD /app/derper --hostname=$DERP_DOMAIN \
    --certmode=$DERP_CERT_MODE \
    --certdir=$DERP_CERT_DIR \
    --a=$DERP_ADDR \
    --stun=$DERP_STUN  \
    --http-port=$DERP_HTTP_PORT \
    --verify-clients=$DERP_VERIFY_CLIENTS
```

```
docker run -d --name derp --restart=always -p 3478:3478/udp -p 9443:9443 -v /root/certs:/app/certs -e DERP_DOMAIN=example.com -e DERP_ADDR=:9443 -e DERP_CERT_MODE=manual derper
```

