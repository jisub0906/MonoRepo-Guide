#!/bin/bash

# WSL CORS 문제 진단 및 해결 스크립트
# Spring Boot 8080 포트 CORS 문제 전용

set -e

echo "🔍 WSL CORS 문제 진단을 시작합니다..."

# WSL 환경 확인
if ! grep -qi microsoft /proc/version 2>/dev/null; then
    echo "❌ WSL 환경이 아닙니다. 이 스크립트는 WSL에서만 실행하세요."
    exit 1
fi

echo "✅ WSL 환경이 확인되었습니다."

# 네트워크 정보 수집
echo ""
echo "📊 네트워크 정보 수집 중..."

WSL_IP=$(hostname -I | awk '{print $1}')
WINDOWS_HOST_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
HOSTNAME=$(hostname)

echo "  WSL IP: $WSL_IP"
echo "  Windows 호스트 IP: $WINDOWS_HOST_IP"
echo "  호스트명: $HOSTNAME"

# 포트 상태 확인
echo ""
echo "🔌 포트 상태 확인..."

check_port() {
    local port=$1
    local service=$2
    
    if netstat -tuln | grep -q ":$port "; then
        local bind_address=$(netstat -tuln | grep ":$port " | awk '{print $4}' | head -1)
        echo "  ✅ $service (포트 $port): 활성 - $bind_address"
        
        # 바인딩 주소 확인
        if [[ $bind_address == "127.0.0.1:$port" ]]; then
            echo "    ⚠️  localhost에만 바인딩됨 - WSL에서 접근 불가능할 수 있음"
            return 1
        elif [[ $bind_address == "0.0.0.0:$port" ]]; then
            echo "    ✅ 모든 인터페이스에 바인딩됨 - WSL에서 접근 가능"
            return 0
        fi
    else
        echo "  ❌ $service (포트 $port): 비활성"
        return 1
    fi
}

SPRING_PORT_OK=false
FASTAPI_PORT_OK=false
FRONTEND_PORT_OK=false

if check_port 8080 "Spring Boot"; then
    SPRING_PORT_OK=true
fi

if check_port 8000 "FastAPI"; then
    FASTAPI_PORT_OK=true
fi

if check_port 4200 "Next.js" || check_port 3000 "Next.js"; then
    FRONTEND_PORT_OK=true
fi

# CORS 테스트
echo ""
echo "🧪 CORS 연결 테스트..."

test_cors() {
    local url=$1
    local service=$2
    
    echo "  테스트 중: $service ($url)"
    
    # OPTIONS 요청으로 CORS preflight 테스트
    local response=$(curl -s -o /dev/null -w "%{http_code}" \
        -X OPTIONS \
        -H "Origin: http://localhost:4200" \
        -H "Access-Control-Request-Method: GET" \
        -H "Access-Control-Request-Headers: Content-Type" \
        --connect-timeout 5 \
        "$url" 2>/dev/null || echo "000")
    
    if [[ $response == "200" ]]; then
        echo "    ✅ CORS preflight 성공 (HTTP $response)"
        
        # 실제 GET 요청 테스트
        local get_response=$(curl -s -o /dev/null -w "%{http_code}" \
            -H "Origin: http://localhost:4200" \
            --connect-timeout 5 \
            "$url" 2>/dev/null || echo "000")
        
        if [[ $get_response == "200" ]]; then
            echo "    ✅ GET 요청 성공 (HTTP $get_response)"
            return 0
        else
            echo "    ❌ GET 요청 실패 (HTTP $get_response)"
            return 1
        fi
    else
        echo "    ❌ CORS preflight 실패 (HTTP $response)"
        return 1
    fi
}

# 다양한 주소로 테스트
SPRING_CORS_OK=false

echo "Spring Boot CORS 테스트:"
if test_cors "http://localhost:8080/api/auth/health" "localhost"; then
    SPRING_CORS_OK=true
elif test_cors "http://127.0.0.1:8080/api/auth/health" "127.0.0.1"; then
    SPRING_CORS_OK=true
elif test_cors "http://$WSL_IP:8080/api/auth/health" "WSL IP"; then
    SPRING_CORS_OK=true
fi

echo ""
echo "FastAPI CORS 테스트:"
test_cors "http://localhost:8000/health" "localhost" || \
test_cors "http://127.0.0.1:8000/health" "127.0.0.1" || \
test_cors "http://$WSL_IP:8000/health" "WSL IP"

# 문제 진단 및 해결책 제시
echo ""
echo "🔧 문제 진단 및 해결책:"

if [[ $SPRING_CORS_OK == false ]]; then
    echo ""
    echo "❌ Spring Boot CORS 문제 발견!"
    echo ""
    echo "📋 해결 방법:"
    echo "1. Spring Boot 서버 재시작:"
    echo "   cd apps/backend-spring"
    echo "   ./gradlew bootRun"
    echo ""
    echo "2. Windows 방화벽 설정 (PowerShell 관리자 권한):"
    echo "   New-NetFirewallRule -DisplayName \"WSL Spring Boot\" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow"
    echo ""
    echo "3. WSL 네트워크 재설정:"
    echo "   wsl --shutdown"
    echo "   wsl"
    echo ""
    echo "4. 브라우저에서 직접 테스트:"
    echo "   http://localhost:8080/api/auth/health"
    echo "   http://$WSL_IP:8080/api/auth/health"
fi

# Windows PowerShell 명령어 생성
echo ""
echo "🔥 Windows PowerShell 방화벽 설정 (관리자 권한으로 실행):"
echo ""
cat << EOF
# WSL 포트 허용 규칙 추가
New-NetFirewallRule -DisplayName "WSL Spring Boot 8080" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "WSL FastAPI 8000" -Direction Inbound -LocalPort 8000 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "WSL Next.js 4200" -Direction Inbound -LocalPort 4200 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "WSL Next.js 3000" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "WSL PostgreSQL 5432" -Direction Inbound -LocalPort 5432 -Protocol TCP -Action Allow

# 기존 규칙 확인
Get-NetFirewallRule -DisplayName "*WSL*" | Select-Object DisplayName, Enabled, Direction

# WSL IP 포트포워딩 (필요시)
netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectport=8080 connectaddress=$WSL_IP
EOF

echo ""
echo "💡 추가 팁:"
echo "1. 바이러스 백신 소프트웨어가 포트를 차단하고 있는지 확인하세요"
echo "2. Windows Defender 실시간 보호 설정을 확인하세요"
echo "3. 프록시나 VPN이 활성화되어 있다면 비활성화해보세요"
echo "4. 브라우저 개발자 도구(F12)에서 네트워크 탭을 확인하세요"

echo ""
echo "🎯 즉시 테스트할 수 있는 URL:"
echo "  Spring Boot: http://localhost:8080/api/auth/health"
echo "  Spring Boot (WSL IP): http://$WSL_IP:8080/api/auth/health"
echo "  FastAPI: http://localhost:8000/health"
echo "  FastAPI (WSL IP): http://$WSL_IP:8000/health"

echo ""
echo "🔍 문제가 지속되면 다음 로그를 확인하세요:"
echo "  Spring Boot 로그: apps/backend-spring/logs/"
echo "  브라우저 개발자 도구 콘솔"
echo "  Windows 이벤트 뷰어" 