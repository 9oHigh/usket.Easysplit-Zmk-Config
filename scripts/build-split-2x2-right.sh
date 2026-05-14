#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/personal/zmk-workspace}"
CONFIG_DIR="${CONFIG_DIR:-$HOME/personal/easysplit-zmk-config/config}"

cd "$WORKSPACE_DIR"
source .venv/bin/activate

rm -rf build-right

west build \
  -s zmk.git/app \
  -b xiao_ble \
  -d build-right \
  -- \
  -DSHIELD=easysplit_split_2x2_right \
  -DZMK_CONFIG="$CONFIG_DIR"

ls -la build-right/zephyr | grep zmk

echo "easysplit_split_2x2_right 빌드 완료: $WORKSPACE_DIR/build-right/zephyr/zmk.uf2"
