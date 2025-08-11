FROM debian:stable-slim

# Cài các gói cần thiết để build pacebin
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone source code
WORKDIR /app
RUN git clone https://git.swurl.xyz/swirl/pacebin.git .

# Build & cài pacebin (chỉ binary, không systemd/nginx)
RUN make install-bin prefix=/usr

# Tạo thư mục lưu paste
RUN mkdir -p /data
VOLUME ["/data"]

# Mở port mặc định
EXPOSE 8081

# Chạy pacebin server
CMD ["pacebin", "-d", "/data", "-p", "8081"]
