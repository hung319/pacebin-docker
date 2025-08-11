# Stage 1: Builder - Dùng frolvlad/alpine-glibc
FROM frolvlad/alpine-glibc:latest AS builder

# Cài đặt các công cụ cần thiết trên Alpine
RUN apk add --no-cache build-base git

# Tạo thư mục làm việc và clone source code
WORKDIR /app
RUN git clone https://git.swurl.xyz/swirl/pacebin.git .

# Build ứng dụng với tùy chọn biên dịch tĩnh
# Quá trình make vẫn không thay đổi
RUN make LDFLAGS="-static"

# ----------------------------------------------------------------

# Stage 2: Runtime - Vẫn dùng Scratch, không có gì thay đổi
FROM scratch

# Sao chép file thực thi duy nhất từ stage builder
COPY --from=builder /app/pacebin /pacebin

# Cung cấp port
EXPOSE 8081

# Lệnh chạy ứng dụng
CMD ["/pacebin", "-d", "/data", "-p", "8081"]
