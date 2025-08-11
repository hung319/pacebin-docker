# Stage 1: Builder - Dùng Debian làm "xưởng sản xuất"
FROM debian:bookworm-slim AS builder

# Cài đặt các công cụ cần thiết để build C/C++
RUN apt-get update && \
    apt-get install -y build-essential git && \
    rm -rf /var/lib/apt/lists/*

# Tạo thư mục làm việc và clone source code
WORKDIR /app
RUN git clone https://git.swurl.xyz/swirl/pacebin.git .

# Build ứng dụng với tùy chọn biên dịch tĩnh (static linking)
# LDFLAGS="-static" yêu cầu GCC đóng gói tất cả thư viện (bao gồm glibc)
# vào bên trong file thực thi duy nhất.
RUN make LDFLAGS="-static"

# ----------------------------------------------------------------

# Stage 2: Runtime - Dùng Scratch làm "phòng sạch"
FROM scratch

# Sao chép file thực thi duy nhất đã được biên dịch tĩnh từ stage builder
COPY --from=builder /app/pacebin /pacebin

# (Tùy chọn) Nếu ứng dụng cần file config hoặc data khác
# COPY --from=builder /app/config.json /config.json

# Cung cấp port
EXPOSE 8081

# Lệnh chạy ứng dụng
# Phải dùng định dạng mảng JSON vì không có shell (/bin/sh)
CMD ["/pacebin", "-d", "/data", "-p", "8081"]
