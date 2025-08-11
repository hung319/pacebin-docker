# Stage 1: Build pacebin & pacectl
FROM alpine:latest AS builder
RUN apk add --no-cache build-base git libc-dev \
    && git clone https://git.swurl.xyz/swirl/pacebin.git /pacebin \
    && cd /pacebin \
    && make

# Stage 2: Minimal runtime
FROM alpine:latest

# Tạo thư mục paste (Render chỉ cho ghi ở /tmp)
RUN mkdir -p /tmp/pacebin

# Copy file chạy từ stage build
COPY --from=builder /pacebin/pacebin /usr/local/bin/pacebin
COPY --from=builder /pacebin/pacectl /usr/local/bin/pacectl

# Render cung cấp biến PORT, mặc định 8081
ENV PORT=8081

EXPOSE $PORT

# Chạy pacebin ở /tmp/pacebin (mặc định pacebin lưu tại cwd)
WORKDIR /tmp/pacebin
CMD ["pacebin"]
