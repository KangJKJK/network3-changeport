#!/bin/bash

WG_CONFIG="/root/ubuntu-node/x86_64/wg0.conf"
DEFAULT_PORT1=1433
DEFAULT_PORT2=51820
CURRENT_PORT1=$DEFAULT_PORT1
CURRENT_PORT2=$DEFAULT_PORT2

# 포트가 사용 중인지 확인
while netstat -tuln | grep -q ":$CURRENT_PORT1 "; do
  echo -e "${YELLOW}포트 $CURRENT_PORT1 가 사용 중입니다. 다음 포트로 시도합니다.${NC}"
  CURRENT_PORT1=$((CURRENT_PORT1 + 1))
done

while netstat -tuln | grep -q ":$CURRENT_PORT2 "; do
  echo -e "${YELLOW}포트 $CURRENT_PORT2 가 사용 중입니다. 다음 포트로 시도합니다.${NC}"
  CURRENT_PORT2=$((CURRENT_PORT2 + 1))
done

echo -e "${GREEN}사용 가능한 포트는 $CURRENT_PORT1 와 $CURRENT_PORT2 입니다.${NC}"

# wg0.conf 파일의 ListenPort 값을 변경
if [ -f "$WG_CONFIG" ];then
  sed -i "s/^ListenPort *=.*/ListenPort = $CURRENT_PORT1/" "$WG_CONFIG"
  sed -i "s/^ListenPort *=.*/ListenPort = $CURRENT_PORT2/" "$WG_CONFIG"
  echo -e "${GREEN}ListenPort1를 $CURRENT_PORT1 로, ListenPort2를 $CURRENT_PORT2 로 변경했습니다.${NC}"
else
  echo -e "${RED}$WG_CONFIG 파일을 찾을 수 없습니다.${NC}"
  exit 1
fi

# 포트 열기
ufw allow $CURRENT_PORT1
ufw allow $CURRENT_PORT2
echo -e "${GREEN}포트 $CURRENT_PORT1 와 $CURRENT_PORT2 을(를) 방화벽에서 열었습니다.${NC}"
