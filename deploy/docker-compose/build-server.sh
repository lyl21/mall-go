#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "=== 1/3 停旧容器 ==="
docker-compose -f "$SCRIPT_DIR/docker-compose.yaml" stop server
docker-compose -f "$SCRIPT_DIR/docker-compose.yaml" rm -f server

echo ""
echo "=== 2/3 编译 Go 二进制（宿主机，利用本地缓存，增量秒级）==="
cd "$PROJECT_DIR/server"
CGO_ENABLED=0 go build -ldflags="-s -w" -o server .
echo "编译完成: $(ls -lh server | awk '{print $5}')"

echo ""
echo "=== 3/3 构建镜像并启动 ==="
DOCKER_BUILDKIT=1 docker build -t xm-server "$PROJECT_DIR/server/"
docker-compose -f "$SCRIPT_DIR/docker-compose.yaml" up -d server
echo ""
echo "完成！"
