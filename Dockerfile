# Stage 1: Build pacebin
FROM alpine:latest AS builder

RUN apk add --no-cache \
    build-base \
    git \
    libc-dev \
    && git clone https://git.swurl.xyz/swirl/pacebin.git /pacebin \
    && cd /pacebin \
    && make

# Stage 2: Minimal runtime image
FROM alpine:latest

# Copy file chạy từ stage build
COPY --from=builder /pacebin/pacebin /usr/local/bin/pacebin

EXPOSE 8081

CMD ["pacebin"]
