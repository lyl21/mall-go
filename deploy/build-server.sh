#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SERVER_DIR="$PROJECT_DIR/server"

echo "=== 编译 Go 二进制 ==="
cd "$SERVER_DIR"
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server .

echo "=== 构建 Docker 镜像 ==="
cd "$PROJECT_DIR"
docker-compose -f deploy/docker-compose/docker-compose.yaml build server

echo "=== 重启容器 ==="
docker-compose -f deploy/docker-compose/docker-compose.yaml up -d server

echo "=== 完成 ==="
