FROM alpine:latest

# Install dependencies
RUN apk add --no-cache ca-certificates wget unzip

# Download latest Xray-core
ARG XRAY_VERSION=latest
RUN ARCH=$(uname -m) && \
    case "$ARCH" in \
      x86_64)  XRAY_ARCH="Xray-linux-64" ;; \
      aarch64) XRAY_ARCH="Xray-linux-arm64-v8a" ;; \
      *)       echo "Unsupported arch: $ARCH" && exit 1 ;; \
    esac && \
    if [ "$XRAY_VERSION" = "latest" ]; then \
      DOWNLOAD_URL="https://github.com/XTLS/Xray-core/releases/latest/download/${XRAY_ARCH}.zip"; \
    else \
      DOWNLOAD_URL="https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/${XRAY_ARCH}.zip"; \
    fi && \
    wget -O /tmp/xray.zip "$DOWNLOAD_URL" && \
    unzip /tmp/xray.zip -d /tmp/xray && \
    mv /tmp/xray/xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm -rf /tmp/xray /tmp/xray.zip

# Create config directory
RUN mkdir -p /etc/xray

# Copy config and entrypoint
COPY config.json /etc/xray/config.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Zeabur uses PORT env var (default 443)
ENV PORT=443
EXPOSE ${PORT}

ENTRYPOINT ["/entrypoint.sh"]
