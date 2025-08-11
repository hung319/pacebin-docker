FROM debian:stable-slim

# Cài các gói cần thiết để build pacebin
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libc6-dev \
    libxcrypt-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone source code
WORKDIR /app
RUN git clone https://git.swurl.xyz/swirl/pacebin.git .

# Build & cài pacebin (chỉ binary, không systemd/nginx)
RUN make install-bin prefix=/usr

# Thư mục lưu paste
RUN mkdir -p /data
VOLUME ["/data"]

# Port mặc định
EXPOSE 8081

# Chạy pacebin server
CMD ["pacebin", "-d", "/data", "-p", "8081"]
