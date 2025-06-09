#!/bin/bash

# 개발 환경 실행 스크립트

set -e  # 오류 발생 시 스크립트 중단

echo "🚀 모노레포 개발 환경을 시작합니다..."

# 필수 도구 확인
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ $1이 설치되지 않았습니다. 설치 후 다시 시도해주세요."
        exit 1
    fi
}

echo "🔍 필수 도구 확인 중..."
check_command docker-compose
check_command java
check_command python3
check_command pnpm

# Docker Compose로 데이터베이스 시작
echo "📦 PostgreSQL 데이터베이스를 시작합니다..."
docker-compose up -d postgres-db

# 데이터베이스가 준비될 때까지 대기
echo "⏳ 데이터베이스 준비 중..."
sleep 15

# FastAPI 가상환경 확인 및 설정
echo "🐍 FastAPI 가상환경을 확인합니다..."
cd apps/backend-fastapi
if [ ! -d "venv" ]; then
    echo "📦 FastAPI 가상환경을 생성합니다..."
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
else
    source venv/bin/activate
fi
cd ../../

# 각 서비스를 백그라운드에서 실행
echo "🌱 Spring Boot 백엔드 서비스를 시작합니다..."
cd apps/backend-spring && ./gradlew bootRun &
SPRING_PID=$!

echo "🐍 FastAPI 백엔드 서비스를 시작합니다..."
cd ../../apps/backend-fastapi && source venv/bin/activate && uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload &
FASTAPI_PID=$!

echo "⚛️ Next.js 프론트엔드를 시작합니다..."
cd ../../ && pnpm nx serve frontend-nextjs &
NEXTJS_PID=$!

echo "✅ 모든 서비스가 시작되었습니다!"
echo ""
echo "🌐 서비스 접속 URL:"
echo "  📱 Next.js 프론트엔드: http://localhost:3000"
echo "  🌱 Spring Boot 백엔드: http://localhost:8080"
echo "  🐍 FastAPI 백엔드: http://localhost:8000"
echo "  📚 FastAPI 문서: http://localhost:8000/docs"
echo "  📊 PostgreSQL 데이터베이스: localhost:5432"
echo ""
echo "종료하려면 Ctrl+C를 누르세요..."

# Ctrl+C로 종료할 때 모든 프로세스 정리
trap "echo '🛑 서비스를 종료합니다...'; kill $SPRING_PID $FASTAPI_PID $NEXTJS_PID 2>/dev/null; docker-compose down; exit" INT

# 프로세스들이 실행 중인 동안 대기
wait 