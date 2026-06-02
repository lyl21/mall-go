#!/bin/bash
# 构建并部署 server + web 容器
# 用法:
#   ./build.sh          # 构建全部
#   ./build.sh server   # 仅构建 server
#   ./build.sh web      # 仅构建 web

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yaml"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TARGET="${1:-all}"

# ============================================================
# 清理Docker悬空资源(旧镜像/构建缓存),避免每次构建磁盘递减
# ============================================================
cleanup_docker() {
  echo -e "${YELLOW}=== 清理Docker悬空资源 ===${NC}"
  docker image prune -f 2>/dev/null || true
  docker builder prune -f --filter "until=24h" 2>/dev/null || true
  echo -e "${GREEN}清理完成${NC}"
  echo ""
}

# ============================================================
# 构建 server: 宿主机编译 Go 二进制 → 复制到镜像 → 启动容器
# ============================================================
build_server() {
  echo -e "${YELLOW}=== [Server] 1/3 停旧容器 ===${NC}"
  docker-compose -f "$COMPOSE_FILE" stop server 2>/dev/null || true
  docker-compose -f "$COMPOSE_FILE" rm -f server 2>/dev/null || true

  echo ""
  echo -e "${YELLOW}=== [Server] 2/3 编译 Go 二进制（宿主机，增量秒级）===${NC}"
  cd "$PROJECT_DIR/server"
  CGO_ENABLED=0 go build -ldflags="-s -w" -o server .
  echo -e "${GREEN}编译完成: $(ls -lh server | awk '{print $5}')${NC}"

  echo ""
  echo -e "${YELLOW}=== [Server] 3/3 构建镜像并启动 ===${NC}"
  DOCKER_BUILDKIT=1 docker build -t xm-server "$PROJECT_DIR/server/"
  docker-compose -f "$COMPOSE_FILE" up -d server
  echo -e "${GREEN}[Server] 完成！${NC}"
}

# ============================================================
# 构建 web: Docker 多阶段构建（依赖缓存 + esbuild 压缩）
# ============================================================
build_web() {
  echo -e "${YELLOW}=== [Web] 1/3 停旧容器 ===${NC}"
  docker-compose -f "$COMPOSE_FILE" stop web 2>/dev/null || true
  docker-compose -f "$COMPOSE_FILE" rm -f web 2>/dev/null || true

  echo ""
  echo -e "${YELLOW}=== [Web] 2/3 Docker 多阶段构建（pnpm install + vite build）===${NC}"
  # --no-cache: 确保vite.config.js等配置变更后完全重建,避免缓存导致白屏
  DOCKER_BUILDKIT=1 docker-compose -f "$COMPOSE_FILE" build --no-cache web

  echo ""
  echo -e "${YELLOW}=== [Web] 3/3 启动容器 ===${NC}"
  docker-compose -f "$COMPOSE_FILE" up -d web
  echo -e "${GREEN}[Web] 完成！${NC}"
}

# ============================================================
# 主流程
# ============================================================
case "$TARGET" in
  server)
    build_server
    ;;
  web)
    build_web
    ;;
  all)
    build_server
    echo ""
    build_web
    ;;
  clean)
    cleanup_docker
    ;;
  *)
    echo "用法: $0 [server|web|all|clean]"
    echo "  不带参数默认构建全部"
    echo "  clean  清理Docker悬空资源"
    exit 1
    ;;
esac

echo ""
echo -e "${GREEN}=== 全部完成！===${NC}"
echo "容器状态:"
docker-compose -f "$COMPOSE_FILE" ps
