FROM nginx:alpine

# Install dependencies
RUN apk add --no-cache ca-certificates wget unzip

# Download core binary
ARG CORE_VERSION=latest
RUN ARCH=$(uname -m) && \
    case "$ARCH" in \
      x86_64)  BIN_ARCH="Xray-linux-64" ;; \
      aarch64) BIN_ARCH="Xray-linux-arm64-v8a" ;; \
      *)       echo "Unsupported arch: $ARCH" && exit 1 ;; \
    esac && \
    if [ "$CORE_VERSION" = "latest" ]; then \
      DOWNLOAD_URL="https://github.com/XTLS/Xray-core/releases/latest/download/${BIN_ARCH}.zip"; \
    else \
      DOWNLOAD_URL="https://github.com/XTLS/Xray-core/releases/download/v${CORE_VERSION}/${BIN_ARCH}.zip"; \
    fi && \
    wget -O /tmp/core.zip "$DOWNLOAD_URL" && \
    unzip /tmp/core.zip -d /tmp/core && \
    mv /tmp/core/xray /usr/local/bin/web-core && \
    chmod +x /usr/local/bin/web-core && \
    rm -rf /tmp/core /tmp/core.zip

# Create config directory
RUN mkdir -p /etc/web-core

# Copy project files
COPY app/ /etc/web-core/
COPY web/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Zeabur uses PORT env var
ENV PORT=8080
EXPOSE ${PORT}

CMD ["/start.sh"]
