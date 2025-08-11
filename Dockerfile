# Stage 1: Build
FROM alpine:3.20 AS builder

# Cài gói cần thiết để build
RUN apk add --no-cache build-base git

# Clone source code
WORKDIR /app
RUN git clone https://github.com/hung319/pacebin.git .

# Build binary
RUN make

# Stage 2: Runtime
FROM alpine:3.20

# Copy binary từ builder
COPY --from=builder /app/pacebin /usr/local/bin/pacebin

# Tạo thư mục lưu paste
RUN mkdir -p /data
VOLUME ["/data"]

# Biến môi trường tương tự như file systemd dùng
ENV DIR=/data \
    PORT=8081 \
    SEED=secret

# Mở port
EXPOSE 8081

# Chạy pacebin với tham số giống systemd
CMD ["/bin/sh", "-c", "pacebin -d \"$DIR\" -p \"$PORT\" -s \"$SEED\" -k"]
