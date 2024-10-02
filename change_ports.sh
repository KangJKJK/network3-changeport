#!/bin/bash

echo "포트 변경 스크립트가 실행되었습니다."

WG_CONFIG="/root/ubuntu-node/wg0.conf"

# 환경 변수로 전달된 시작 포트, 기본값은 1433
START_PORT=${START_PORT:-1433}
CURRENT_PORT=$START_PORT

# 포트가 사용 중인지 확인하고 사용 가능한 포트 찾기
while ss -tuln | grep -q ":$CURRENT_PORT "; do
  echo -e "\033[0;33m포트 $CURRENT_PORT 이(가) 사용 중입니다. 다음 포트로 시도합니다.\033[0m"
  CURRENT_PORT=$((CURRENT_PORT + 1))
done

echo -e "\033[0;32m사용 가능한 포트는 $CURRENT_PORT 입니다.\033[0m"

# wg0.conf 파일의 ListenPort 값을 변경
if [ -f "$WG_CONFIG" ]; then
  sed -i "s/^ListenPort = .*/ListenPort = $CURRENT_PORT/" "$WG_CONFIG"
  echo -e "\033[0;32mListenPort를 $CURRENT_PORT 로 변경했습니다.\033[0m"
else
  echo -e "\033[0;31m$WG_CONFIG 파일을 찾을 수 없습니다.\033[0m"
  exit 1
fi

# 포트 열기
ufw allow $CURRENT_PORT
echo -e "\033[0;32m포트 $CURRENT_PORT 을(를) 방화벽에서 열었습니다.\033[0m"
