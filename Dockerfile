FROM debian:stable-slim

# Cài gói cần thiết để build
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone source
WORKDIR /app
RUN git clone https://git.swurl.xyz/swirl/pacebin.git . 

# Build pacebin
RUN make install-bin prefix=/usr

# Tạo thư mục data để lưu paste
RUN mkdir -p /data
VOLUME ["/data"]

# Cổng mặc định của pacebin
EXPOSE 8081

# Chạy pacebin với thư mục lưu trữ /data
CMD ["pacebin", "-d", "/data", "-p", "8081"]
