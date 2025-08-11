FROM alpine:latest AS builder

# Cài công cụ build
RUN apk add --no-cache build-base git wget

# Cài glibc từ sgerrand
ENV GLIBC_VERSION=2.35-r1
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-dev-${GLIBC_VERSION}.apk && \
    apk add glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk glibc-dev-${GLIBC_VERSION}.apk && \
    rm -f glibc-*.apk

# Clone source
WORKDIR /app
RUN git clone https://git.swurl.xyz/swirl/pacebin.git .

# Build binary
RUN make

# Stage 2: Runtime
FROM alpine:latest

# Cài glibc runtime
ENV GLIBC_VERSION=2.35-r1
RUN apk add --no-cache wget && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk && \
    apk add glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    rm -f glibc-*.apk

# Copy binary
COPY --from=builder /app/pacebin /usr/bin/pacebin

# Data dir
RUN mkdir -p /data
VOLUME ["/data"]

# Port
EXPOSE 8081

CMD ["pacebin", "-d", "/data", "-p", "8081"]
