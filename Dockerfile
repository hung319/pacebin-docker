# Stage 1: Build
FROM debian:stable-slim AS builder

# Cài gói cần thiết để build
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone source code
WORKDIR /app
RUN git clone https://git.swurl.xyz/swirl/pacebin.git .

# Build binary
RUN make

# Stage 2: Runtime
FROM debian:stable-slim

# Copy binary từ builder
COPY --from=builder /app/pacebin /usr/bin/pacebin

# Tạo thư mục lưu paste
RUN mkdir -p /data
VOLUME ["/data"]

# Mở port mặc định
EXPOSE 8081

# Chạy pacebin
CMD ["pacebin", "-d", "/data", "-p", "8081"]
