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
        
        # WSL 호스트 IP 추가
        wsl_host_ip = get_wsl_host_ip()
        if wsl_host_ip:
            origins.extend([
                f"http://{wsl_host_ip}:3000",
                f"http://{wsl_host_ip}:4200",
                f"http://{wsl_host_ip}:8080",
            ])
        
        # 환경 변수에서 추가 origins 가져오기
        extra_origins = os.getenv("EXTRA_CORS_ORIGINS", "")
        if extra_origins:
            origins.extend(extra_origins.split(","))
        
        return origins

    # API 설정
    API_V1_STR: str = "/api"

    # 로깅 설정
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")


settings = Settings()
