#!/bin/bash

# 개발 환경 실행 스크립트
# 사용법: 
#   ./scripts/dev.sh           # 대화형 모드 (기본)
#   ./scripts/dev.sh --auto    # 자동 종료 모드

set -e  # 오류 발생 시 스크립트 중단

# 명령행 인수 처리
AUTO_KILL=false
if [[ "$1" == "--auto" ]]; then
    AUTO_KILL=true
    echo "🤖 자동 종료 모드가 활성화되었습니다."
fi

echo "🚀 모노레포 개발 환경을 시작합니다..."

# 필수 도구 확인
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ $1이 설치되지 않았습니다. 설치 후 다시 시도해주세요."
        exit 1
    fi
}

# 포트 충돌 해결 함수
resolve_port_conflict() {
    local port=$1
    local service_name=$2
    
    echo "🔍 포트 $port 사용 중인 프로세스를 확인합니다..."
    
    # 포트를 사용하는 프로세스 ID 찾기
    local pids=$(sudo lsof -ti :$port 2>/dev/null || true)
    
    if [ ! -z "$pids" ]; then
        echo "⚠️  포트 $port가 이미 사용 중입니다."
        echo "📋 사용 중인 프로세스:"
        sudo lsof -i :$port
        
        if [ "$AUTO_KILL" = true ]; then
            echo "🤖 자동 모드: $service_name 프로세스를 자동으로 종료합니다..."
            REPLY="y"
        else
            read -p "🤔 기존 $service_name 프로세스를 종료하고 계속하시겠습니까? (y/N): " -n 1 -r
            echo
        fi
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🛑 포트 $port를 사용하는 프로세스를 종료합니다..."
            for pid in $pids; do
                sudo kill -TERM $pid 2>/dev/null || true
                sleep 2
                # SIGTERM으로 종료되지 않으면 SIGKILL 사용
                if kill -0 $pid 2>/dev/null; then
                    sudo kill -KILL $pid 2>/dev/null || true
                fi
            done
            echo "✅ 프로세스가 종료되었습니다."
            sleep 3  # 포트가 완전히 해제될 때까지 대기
        else
            echo "❌ 사용자가 취소했습니다. 스크립트를 종료합니다."
            exit 1
        fi
    else
        echo "✅ 포트 $port는 사용 가능합니다."
    fi
}

echo "🔍 필수 도구 확인 중..."
check_command docker-compose
check_command java
check_command python3
check_command pnpm

# 현재 디렉토리 저장
ROOT_DIR=$(pwd)

# 포트 충돌 해결
resolve_port_conflict 5432 "PostgreSQL"
resolve_port_conflict 8080 "Spring Boot"
resolve_port_conflict 8000 "FastAPI"
resolve_port_conflict 4200 "Next.js"

# Docker Compose로 데이터베이스 시작
echo "📦 PostgreSQL 데이터베이스를 시작합니다..."
docker-compose up -d postgres-db

# 데이터베이스가 준비될 때까지 대기
echo "⏳ 데이터베이스 준비 중..."
sleep 15

# FastAPI 가상환경 확인 및 설정
echo "🐍 FastAPI 가상환경을 확인합니다..."
cd "$ROOT_DIR/apps/backend-fastapi"
if [ ! -d "venv" ]; then
    echo "📦 FastAPI 가상환경을 생성합니다..."
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
else
    source venv/bin/activate
fi

# 루트 디렉토리로 돌아가기
cd "$ROOT_DIR"

# 각 서비스를 백그라운드에서 실행
echo "🌱 Spring Boot 백엔드 서비스를 시작합니다..."
cd "$ROOT_DIR/apps/backend-spring"
./gradlew bootRun &
SPRING_PID=$!

echo "🐍 FastAPI 백엔드 서비스를 시작합니다..."
cd "$ROOT_DIR/apps/backend-fastapi"
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload &
FASTAPI_PID=$!

echo "⚛️ Next.js 프론트엔드를 시작합니다..."
cd "$ROOT_DIR"
pnpm nx serve frontend-nextjs &
NEXTJS_PID=$!

echo "✅ 모든 서비스가 시작되었습니다!"
echo ""

# WSL 환경 감지 및 IP 표시
if grep -qi microsoft /proc/version 2>/dev/null; then
    WSL_IP=$(hostname -I | awk '{print $1}')
    echo "🔍 WSL 환경이 감지되었습니다!"
    echo ""
    echo "🌐 서비스 접속 URL (WSL 사용자용):"
    echo "  📱 Next.js 프론트엔드: http://$WSL_IP:4200 ⭐ (WSL에서는 이 URL 사용)"
    echo "  🌱 Spring Boot 백엔드: http://$WSL_IP:8080"
    echo "  🐍 FastAPI 백엔드: http://$WSL_IP:8000"
    echo "  📚 FastAPI 문서: http://$WSL_IP:8000/docs"
    echo ""
    echo "💡 WSL 환경에서는 localhost 대신 WSL IP($WSL_IP)를 사용하세요!"
    echo ""
    echo "🌐 일반 접속 URL (참고용):"
    echo "  📱 Next.js 프론트엔드: http://localhost:4200"
    echo "  🌱 Spring Boot 백엔드: http://localhost:8080"
    echo "  🐍 FastAPI 백엔드: http://localhost:8000"
    echo "  📚 FastAPI 문서: http://localhost:8000/docs"
    echo "  📊 PostgreSQL 데이터베이스: localhost:5432"
else
    echo "🌐 서비스 접속 URL:"
    echo "  📱 Next.js 프론트엔드: http://localhost:4200"
    echo "  🌱 Spring Boot 백엔드: http://localhost:8080"
    echo "  🐍 FastAPI 백엔드: http://localhost:8000"
    echo "  📚 FastAPI 문서: http://localhost:8000/docs"
    echo "  📊 PostgreSQL 데이터베이스: localhost:5432"
fi
echo ""
echo "종료하려면 Ctrl+C를 누르세요..."

# Ctrl+C로 종료할 때 모든 프로세스 정리
trap "echo '🛑 서비스를 종료합니다...'; kill $SPRING_PID $FASTAPI_PID $NEXTJS_PID 2>/dev/null; docker-compose down; exit" INT

# 프로세스들이 실행 중인 동안 대기
wait 