#!/bin/bash

# 모노레포 환경 검증 스크립트

echo "🔍 모노레포 환경 완전성 검증을 시작합니다..."

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 성공/실패 카운터
SUCCESS_COUNT=0
TOTAL_COUNT=0

# 테스트 함수
run_test() {
    local test_name="$1"
    local command="$2"
    
    TOTAL_COUNT=$((TOTAL_COUNT + 1))
    echo -e "${BLUE}[TEST $TOTAL_COUNT]${NC} $test_name"
    
    if eval "$command" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}: $test_name"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        echo -e "${RED}❌ FAIL${NC}: $test_name"
        echo -e "${YELLOW}   명령어: $command${NC}"
    fi
    echo ""
}

echo "🔧 시스템 요구사항 검증..."

# 시스템 요구사항 확인
run_test "Node.js 설치 확인" "command -v node"
run_test "Java 설치 확인" "command -v java"
run_test "Python3 설치 확인" "command -v python3"
run_test "pnpm 설치 확인" "command -v pnpm"
run_test "Docker Compose 설치 확인" "command -v docker-compose"

echo "📦 의존성 설치 검증..."

# 의존성 설치 확인
run_test "Node.js 의존성 설치" "test -d node_modules"
run_test "FastAPI 가상환경 존재 확인" "test -d apps/backend-fastapi/venv"

echo "🏗️ 빌드 시스템 검증..."

# 빌드 테스트 (간단한 검증)
run_test "Gradle Wrapper 실행 권한" "test -x apps/backend-spring/gradlew"
run_test "Next.js 설정 파일 존재" "test -f apps/frontend-nextjs/next.config.js"

echo "📁 프로젝트 구조 검증..."

# 프로젝트 구조 확인
run_test "Spring Boot 메인 클래스 존재" "test -f apps/backend-spring/src/main/java/com/example/authservice/AuthServiceApplication.java"
run_test "Spring Boot 컨트롤러 존재" "test -f apps/backend-spring/src/main/java/com/example/authservice/controller/AuthController.java"
run_test "Spring Boot 설정 파일 존재" "test -f apps/backend-spring/src/main/resources/application.yml"
run_test "FastAPI 메인 파일 존재" "test -f apps/backend-fastapi/app/main.py"
run_test "FastAPI 설정 파일 존재" "test -f apps/backend-fastapi/app/config.py"
run_test "Next.js 메인 페이지 존재" "test -f apps/frontend-nextjs/src/app/page.tsx"

echo "🐳 Docker 환경 검증..."

# Docker 설정 확인
run_test "Docker Compose 파일 존재" "test -f docker-compose.yml"
run_test "Next.js Dockerfile 존재" "test -f apps/frontend-nextjs/Dockerfile"
run_test "Spring Boot Dockerfile 존재" "test -f apps/backend-spring/Dockerfile"
run_test "FastAPI Dockerfile 존재" "test -f apps/backend-fastapi/Dockerfile"

echo "📋 설정 파일 검증..."

# 설정 파일 확인
run_test "Nx 워크스페이스 설정" "test -f nx.json"
run_test "루트 package.json 존재" "test -f package.json"
run_test "개발 스크립트 존재" "test -f scripts/dev.sh"
run_test "빌드 스크립트 존재" "test -f scripts/build.sh"

echo ""
echo "📊 검증 결과 요약"
echo "===================="
echo -e "총 테스트: ${BLUE}$TOTAL_COUNT${NC}"
echo -e "성공: ${GREEN}$SUCCESS_COUNT${NC}"
echo -e "실패: ${RED}$((TOTAL_COUNT - SUCCESS_COUNT))${NC}"

if [ $SUCCESS_COUNT -eq $TOTAL_COUNT ]; then
    echo ""
    echo -e "${GREEN}🎉 모든 검증이 성공했습니다!${NC}"
    echo -e "${GREEN}✨ 완벽한 모노레포 환경이 구축되었습니다.${NC}"
    echo ""
    echo "🚀 다음 단계:"
    echo "  • 개발 환경 시작: ./scripts/dev.sh"
    echo "  • 프로덕션 빌드: ./scripts/build.sh"
    echo "  • Docker 환경: docker-compose up -d"
    exit 0
else
    echo ""
    echo -e "${RED}❌ 일부 검증이 실패했습니다.${NC}"
    echo -e "${YELLOW}⚠️  실패한 항목들을 확인하고 수정해주세요.${NC}"
    echo ""
    echo "💡 도움말:"
    echo "  • 의존성 설치: pnpm install"
    echo "  • FastAPI 환경 설정: cd apps/backend-fastapi && python3 -m venv venv"
    echo "  • 권한 설정: chmod +x scripts/*.sh apps/backend-spring/gradlew"
    exit 1
fi 