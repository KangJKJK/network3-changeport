#!/bin/bash

echo "포트 변경 스크립트가 실행되었습니다."

WG_CONFIG="/root/ubuntu-node/wg0.conf"

# 환경 변수로 전달된 시작 포트
START_PORT1=${START_PORT1:-1433}
START_PORT2=${START_PORT2:-51820}
CURRENT_PORT1=$START_PORT1
CURRENT_PORT2=$START_PORT2

# 포트가 사용 중인지 확인하고 사용 가능한 포트 찾기
while ss -tuln | grep -q ":$CURRENT_PORT1 " ; do
  echo -e "\033[0;33m포트 $CURRENT_PORT1 이(가) 사용 중입니다. 다음 포트로 시도합니다.\033[0m"
  CURRENT_PORT1=$((CURRENT_PORT1 + 1))
done

while ss -tuln | grep -q ":$CURRENT_PORT2 " ; do
  echo -e "\033[0;33m포트 $CURRENT_PORT2 이(가) 사용 중입니다. 다음 포트로 시도합니다.\033[0m"
  CURRENT_PORT2=$((CURRENT_PORT2 + 1))
done

echo -e "\033[0;32m사용 가능한 포트는 $CURRENT_PORT1 와 $CURRENT_PORT2 입니다.\033[0m"

# wg0.conf 파일의 ListenPort 값을 변경
if [ -f "$WG_CONFIG" ]; then
  sed -i "s/^ListenPort = .*/ListenPort = $CURRENT_PORT1/" "$WG_CONFIG"
  sed -i "s/^ListenPort2 = .*/ListenPort2 = $CURRENT_PORT2/" "$WG_CONFIG"
  echo -e "\033[0;32mListenPort1를 $CURRENT_PORT1 로, ListenPort2를 $CURRENT_PORT2 로 변경했습니다.\033[0m"
else
  echo -e "\033[0;31m$WG_CONFIG 파일을 찾을 수 없습니다.\033[0m"
  exit 1
fi

# 포트 열기
ufw allow $CURRENT_PORT1
ufw allow $CURRENT_PORT2
echo -e "\033[0;32m포트 $CURRENT_PORT1 와 $CURRENT_PORT2 을(를) 방화벽에서 열었습니다.\033[0m"
