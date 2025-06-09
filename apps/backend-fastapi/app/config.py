import os


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

    # CORS 설정
    ALLOWED_ORIGINS: list = [
        "http://localhost:4200",  # Next.js 개발 서버
        "http://localhost:8080",
        "http://127.0.0.1:4200",  # Next.js 개발 서버
        "http://127.0.0.1:8080",
    ]

    # API 설정
    API_V1_STR: str = "/api"

    # 로깅 설정
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")


settings = Settings()
