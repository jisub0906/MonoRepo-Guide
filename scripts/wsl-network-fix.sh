#!/bin/bash

# WSL 네트워크 문제 해결 스크립트
# WSL 환경에서 CORS 및 네트워크 연결 문제를 해결합니다.

set -e

echo "🔧 WSL 네트워크 환경 설정을 시작합니다..."

# WSL 환경 확인
if ! grep -qi microsoft /proc/version 2>/dev/null; then
    echo "❌ WSL 환경이 아닙니다. 이 스크립트는 WSL에서만 실행하세요."
    exit 1
fi

echo "✅ WSL 환경이 확인되었습니다."

# 현재 네트워크 정보 출력
echo ""
echo "📊 현재 네트워크 정보:"
echo "  호스트명: $(hostname)"
echo "  WSL IP: $(hostname -I | awk '{print $1}')"

# Windows 호스트 IP 찾기
WINDOWS_HOST_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
echo "  Windows 호스트 IP: $WINDOWS_HOST_IP"

# 환경 변수 설정
echo ""
echo "🔧 환경 변수 설정..."

# .bashrc에 WSL 관련 환경 변수 추가
if ! grep -q "WSL_HOST_IP" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# WSL 네트워크 설정" >> ~/.bashrc
    echo "export WSL_HOST_IP=\$(cat /etc/resolv.conf | grep nameserver | awk '{print \$2}')" >> ~/.bashrc
    echo "export WSL_LOCAL_IP=\$(hostname -I | awk '{print \$1}')" >> ~/.bashrc
    echo "✅ ~/.bashrc에 WSL 환경 변수가 추가되었습니다."
else
    echo "✅ WSL 환경 변수가 이미 설정되어 있습니다."
fi

# 현재 세션에서 환경 변수 설정
export WSL_HOST_IP=$WINDOWS_HOST_IP
export WSL_LOCAL_IP=$(hostname -I | awk '{print $1}')

# 포트 포워딩 확인 및 설정 안내
echo ""
echo "🌐 포트 포워딩 확인..."

# 필요한 포트들
PORTS=(3000 4200 8000 8080 5432)

echo "다음 포트들이 올바르게 바인딩되어야 합니다:"
for port in "${PORTS[@]}"; do
    if netstat -tuln | grep -q ":$port "; then
        echo "  ✅ 포트 $port: 사용 중"
    else
        echo "  ⚠️  포트 $port: 사용되지 않음"
    fi
done

# Windows 방화벽 설정 안내
echo ""
echo "🔥 Windows 방화벽 설정 안내:"
echo "  Windows PowerShell을 관리자 권한으로 실행하고 다음 명령어를 실행하세요:"
echo ""
echo "  # WSL 포트 허용"
for port in "${PORTS[@]}"; do
    echo "  New-NetFirewallRule -DisplayName \"WSL Port $port\" -Direction Inbound -LocalPort $port -Protocol TCP -Action Allow"
done

# WSL 설정 파일 생성/업데이트
echo ""
echo "📝 WSL 설정 파일 업데이트..."

WSL_CONFIG_FILE="/etc/wsl.conf"
if [ ! -f "$WSL_CONFIG_FILE" ]; then
    sudo tee "$WSL_CONFIG_FILE" > /dev/null << EOF
[network]
generateHosts = false
generateResolvConf = false

[interop]
enabled = true
appendWindowsPath = true
EOF
    echo "✅ /etc/wsl.conf 파일이 생성되었습니다."
else
    echo "✅ /etc/wsl.conf 파일이 이미 존재합니다."
fi

# 추가 CORS origins 환경 변수 설정
echo ""
echo "🔗 추가 CORS origins 설정..."

EXTRA_ORIGINS="http://$WSL_HOST_IP:3000,http://$WSL_HOST_IP:4200,http://$WSL_LOCAL_IP:3000,http://$WSL_LOCAL_IP:4200"

# .env 파일에 추가
if [ -f ".env" ]; then
    if ! grep -q "EXTRA_CORS_ORIGINS" .env; then
        echo "EXTRA_CORS_ORIGINS=$EXTRA_ORIGINS" >> .env
        echo "✅ .env 파일에 EXTRA_CORS_ORIGINS가 추가되었습니다."
    else
        sed -i "s|EXTRA_CORS_ORIGINS=.*|EXTRA_CORS_ORIGINS=$EXTRA_ORIGINS|" .env
        echo "✅ .env 파일의 EXTRA_CORS_ORIGINS가 업데이트되었습니다."
    fi
else
    echo "EXTRA_CORS_ORIGINS=$EXTRA_ORIGINS" > .env
    echo "✅ .env 파일이 생성되고 EXTRA_CORS_ORIGINS가 추가되었습니다."
fi

# 네트워크 테스트
echo ""
echo "🧪 네트워크 연결 테스트..."

test_connection() {
    local host=$1
    local port=$2
    local service=$3
    
    if timeout 3 bash -c "</dev/tcp/$host/$port" 2>/dev/null; then
        echo "  ✅ $service ($host:$port): 연결 성공"
        return 0
    else
        echo "  ❌ $service ($host:$port): 연결 실패"
        return 1
    fi
}

# 로컬 서비스 테스트
echo "로컬 서비스 연결 테스트:"
test_connection "localhost" "8080" "Spring Boot" || true
test_connection "localhost" "8000" "FastAPI" || true
test_connection "localhost" "5432" "PostgreSQL" || true

# WSL IP로 테스트
echo ""
echo "WSL IP로 연결 테스트:"
test_connection "$WSL_LOCAL_IP" "8080" "Spring Boot" || true
test_connection "$WSL_LOCAL_IP" "8000" "FastAPI" || true

echo ""
echo "🎉 WSL 네트워크 설정이 완료되었습니다!"
echo ""
echo "📋 다음 단계:"
echo "  1. WSL을 재시작하세요: wsl --shutdown && wsl"
echo "  2. Windows PowerShell에서 방화벽 규칙을 추가하세요 (위의 명령어 참조)"
echo "  3. 개발 서버를 다시 시작하세요: pnpm dev"
echo ""
echo "🔍 문제가 지속되면 다음을 확인하세요:"
echo "  - Windows Defender 방화벽 설정"
echo "  - WSL2 네트워크 모드 설정"
echo "  - 바이러스 백신 소프트웨어 설정"
echo ""
echo "💡 추가 도움이 필요하면 GitHub Issues에 문의하세요." 