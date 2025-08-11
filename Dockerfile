FROM debian:12-slim

# Cài toolchain để build C project + git
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone source code
WORKDIR /app
RUN git clone https://git.swurl.xyz/swirl/pacebin.git .
 
# Build binary
RUN make

# Cấu hình cổng (theo docs pacebin mặc định là 8081)
EXPOSE 8081

# Chạy trực tiếp binary đã build
CMD ["./pacebin"]
