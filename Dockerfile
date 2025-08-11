# Stage 1: Build với glibc trên Alpine
FROM alpine:latest AS builder

# Cài gói build và glibc compatibility
RUN apk add --no-cache build-base git gcompat

# Clone source code
WORKDIR /app
RUN git clone https://git.swurl.xyz/swirl/pacebin.git .

# Build binary
RUN make

# Stage 2: Runtime (Alpine + glibc)
FROM alpine:latest

# Cài glibc compatibility
RUN apk add --no-cache gcompat

# Copy binary từ builder
COPY --from=builder /app/pacebin /usr/bin/pacebin

# Thư mục lưu paste
RUN mkdir -p /data
VOLUME ["/data"]

# Mở port mặc định
EXPOSE 8081

# Chạy pacebin
CMD ["pacebin", "-d", "/data", "-p", "8081"]
