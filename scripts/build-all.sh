#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/build-settings-reset.sh"
bash "$SCRIPT_DIR/build-1key.sh"
bash "$SCRIPT_DIR/build-4key.sh"
bash "$SCRIPT_DIR/build-split-2x2-left.sh"
bash "$SCRIPT_DIR/build-split-2x2-right.sh"

echo "모든 EasySplit 테스트 펌웨어 빌드 완료"
