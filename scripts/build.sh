#!/bin/bash

# 프로덕션 빌드 스크립트

set -e  # 오류 발생 시 스크립트 중단

echo "🏗️ 모노레포 프로덕션 빌드를 시작합니다..."

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

# 의존성 설치
echo "📦 Node.js 의존성을 설치합니다..."
pnpm install

# FastAPI 가상환경 설정
echo "🐍 FastAPI 가상환경을 설정합니다..."
cd apps/backend-fastapi
if [ ! -d "venv" ]; then
    echo "📦 FastAPI 가상환경을 생성합니다..."
    python3 -m venv venv
fi
source venv/bin/activate
pip install -r requirements.txt
cd ../../

# 각 애플리케이션 빌드
echo "⚛️ Next.js 프론트엔드를 빌드합니다..."
pnpm nx build frontend-nextjs

echo "🌱 Spring Boot 백엔드 서비스를 빌드합니다..."
cd apps/backend-spring && ./gradlew clean bootJar --no-daemon
cd ../../

echo "🐍 FastAPI 백엔드 서비스 린트를 확인합니다..."
cd apps/backend-fastapi && source venv/bin/activate && flake8 app/ --max-line-length=88
cd ../../

# Docker 이미지 빌드
echo "🐳 Docker 이미지를 빌드합니다..."
docker-compose build

echo "✅ 모든 빌드가 완료되었습니다!"
echo ""
echo "🚀 배포 옵션:"
echo "  • 전체 서비스 시작: docker-compose up -d"
echo "  • 개별 서비스 시작: docker-compose up -d [service-name]"
echo "  • 로그 확인: docker-compose logs -f"
echo "  • 서비스 중지: docker-compose down" 