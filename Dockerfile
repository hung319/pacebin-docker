# Stage 1: Builder
FROM frolvlad/alpine-glibc:latest AS builder

# Image này đã có glibc, chỉ cần cài công cụ build
RUN apk add --no-cache build-base git wget

# Clone source
WORKDIR /app
RUN git clone https://git.swurl.xyz/swirl/pacebin.git .

# Build binary
RUN make

# ----------------------------------------------------------------

# Stage 2: Runtime
FROM frolvlad/alpine-glibc:latest

# Image này đã có glibc runtime, không cần làm gì thêm.

# Copy binary
COPY --from=builder /app/pacebin /usr/bin/pacebin

# Data dir
RUN mkdir -p /data
VOLUME ["/data"]

# Port
EXPOSE 8081

CMD ["pacebin", "-d", "/data", "-p", "8081"]
