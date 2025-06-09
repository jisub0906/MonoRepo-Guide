#!/bin/bash

# 포트 킬러 유틸리티 스크립트
# 사용법: 
#   ./scripts/kill-ports.sh                    # 기본 포트들 (5432, 8080, 8000, 4200) 종료
#   ./scripts/kill-ports.sh 3000 5432 8080    # 특정 포트들 종료

set -e

# 기본 포트 목록
DEFAULT_PORTS=(5432 8080 8000 4200)

# 명령행 인수가 있으면 사용, 없으면 기본 포트 사용
if [ $# -eq 0 ]; then
    PORTS=("${DEFAULT_PORTS[@]}")
    echo "🎯 기본 포트들을 확인합니다: ${DEFAULT_PORTS[*]}"
else
    PORTS=("$@")
    echo "🎯 지정된 포트들을 확인합니다: $*"
fi

# 포트 종료 함수
kill_port() {
    local port=$1
    echo "🔍 포트 $port 확인 중..."
    
    local pids=$(sudo lsof -ti :$port 2>/dev/null || true)
    
    if [ ! -z "$pids" ]; then
        echo "⚠️  포트 $port가 사용 중입니다."
        echo "📋 프로세스 정보:"
        sudo lsof -i :$port
        
        echo "🛑 포트 $port를 사용하는 프로세스를 종료합니다..."
        for pid in $pids; do
            # 프로세스 이름 확인
            local process_name=$(ps -p $pid -o comm= 2>/dev/null || echo "unknown")
            echo "  - PID $pid ($process_name) 종료 중..."
            
            # SIGTERM으로 정상 종료 시도
            sudo kill -TERM $pid 2>/dev/null || true
            sleep 2
            
            # 여전히 실행 중이면 SIGKILL 사용
            if kill -0 $pid 2>/dev/null; then
                echo "  - 강제 종료 중..."
                sudo kill -KILL $pid 2>/dev/null || true
            fi
        done
        echo "✅ 포트 $port 해제 완료"
    else
        echo "✅ 포트 $port는 사용 가능합니다."
    fi
    echo ""
}

echo "🚀 포트 킬러를 시작합니다..."
echo ""

# 각 포트에 대해 종료 작업 수행
for port in "${PORTS[@]}"; do
    kill_port $port
done

echo "🎉 모든 포트 정리가 완료되었습니다!"
echo ""
echo "💡 팁: 개발 환경을 시작하려면 다음 명령어를 사용하세요:"
echo "  pnpm dev        # 대화형 모드"
echo "  pnpm dev:auto   # 자동 종료 모드" 