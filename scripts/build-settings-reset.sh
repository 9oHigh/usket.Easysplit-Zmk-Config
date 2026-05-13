#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/personal/zmk-workspace}"

cd "$WORKSPACE_DIR"
source .venv/bin/activate

rm -rf build

west build \
  -s zmk.git/app \
  -b xiao_ble \
  -- \
  -DSHIELD=settings_reset

ls -la build/zephyr | grep zmk

echo "settings_reset 빌드 완료: $WORKSPACE_DIR/build/zephyr/zmk.uf2"
