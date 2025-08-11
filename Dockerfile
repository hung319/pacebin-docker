FROM alpine:latest

# Cài gói cần thiết để build
RUN apk add --no-cache \
    build-base \
    git \
    libc-dev \
    && git clone https://git.swurl.xyz/swirl/pacebin.git /pacebin \
    && cd /pacebin \
    && make install-bin prefix=/usr DESTDIR=/tmp/install \
    && mv /tmp/install/usr/bin/pacebin /usr/local/bin/pacebin \
    && rm -rf /tmp/install \
    && apk del build-base git libc-dev

# Mặc định port 8081
EXPOSE 8081

# Chạy pacebin
CMD ["pacebin"]
