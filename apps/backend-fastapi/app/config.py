import os
import socket


def get_wsl_host_ip():
    """WSL 환경에서 호스트 IP 주소를 가져옵니다."""
    try:
        # WSL2에서 호스트 IP 가져오기
        with open('/proc/version', 'r') as f:
            if 'microsoft' in f.read().lower():
                # WSL 환경인 경우
                hostname = socket.gethostname()
                host_ip = socket.gethostbyname(hostname)
                return host_ip
    except:
        pass
    return None

def get_all_network_ips():
    """모든 네트워크 인터페이스의 IP 주소를 가져옵니다."""
    ips = []
    try:
        # hostname -I 명령어 사용 (Linux/WSL에서 사용 가능)
        import subprocess
        result = subprocess.run(['hostname', '-I'], capture_output=True, text=True)
        if result.returncode == 0:
            ips = [ip.strip() for ip in result.stdout.split() if ip.strip() and ip.strip() != '127.0.0.1']
    except:
        try:
            # socket을 사용한 대체 방법
            import socket
            hostname = socket.gethostname()
            ip = socket.gethostbyname(hostname)
            if ip != '127.0.0.1':
                ips.append(ip)
        except:
            pass
    
    return ips


class Settings:
    # 애플리케이션 설정
    APP_NAME: str = "Backend FastAPI Service"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = os.getenv("DEBUG", "False").lower() == "true"

    # 데이터베이스 설정
    DATABASE_URL: str = os.getenv(
        "DATABASE_URL",
        "postgresql://postgres:postgres@localhost:5432/authdb"
    )

    # CORS 설정 - WSL 환경 지원 강화
    @property
    def ALLOWED_ORIGINS(self):
        origins = [
            "http://localhost:3000",
            "http://localhost:4200",  # Next.js 개발 서버 (업데이트된 포트)
            "http://localhost:8080",
            "http://127.0.0.1:3000",
            "http://127.0.0.1:4200",  # Next.js 개발 서버 (업데이트된 포트)
            "http://127.0.0.1:8080",
            # WSL 환경 지원
            "http://0.0.0.0:3000",
            "http://0.0.0.0:4200",
            "http://0.0.0.0:8080",
        ]
        
        # 모든 네트워크 인터페이스 IP 추가
        all_ips = get_all_network_ips()
        for ip in all_ips:
            origins.extend([
                f"http://{ip}:3000",
                f"http://{ip}:4200",
                f"http://{ip}:8080",
            ])
        
        # WSL 호스트 IP 추가 (기존 방식도 유지)
        wsl_host_ip = get_wsl_host_ip()
        if wsl_host_ip and wsl_host_ip not in all_ips:
            origins.extend([
                f"http://{wsl_host_ip}:3000",
                f"http://{wsl_host_ip}:4200",
                f"http://{wsl_host_ip}:8080",
            ])
        
        # 환경 변수에서 추가 origins 가져오기
        extra_origins = os.getenv("EXTRA_CORS_ORIGINS", "")
        if extra_origins:
            origins.extend(extra_origins.split(","))
        
        # 중복 제거
        origins = list(set(origins))
        
        # 디버깅용 로그
        print(f"🔧 FastAPI CORS 허용된 Origins: {origins}")
        
        return origins

    # API 설정
    API_V1_STR: str = "/api"

    # 로깅 설정
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")


settings = Settings()
