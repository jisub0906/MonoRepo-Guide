# 🚀 Modern MonoRepo Guide

**완벽한 풀스택 모노레포 개발 환경** - Next.js, Spring Boot, FastAPI를 하나의 저장소에서 관리하는 실무 중심 가이드

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-20+-green.svg)](https://nodejs.org/)
[![Java](https://img.shields.io/badge/Java-21+-orange.svg)](https://openjdk.org/)
[![Python](https://img.shields.io/badge/Python-3.11+-blue.svg)](https://python.org/)
[![Nx](https://img.shields.io/badge/Nx-21.1.3-blue.svg)](https://nx.dev/)

## 📋 목차

- [🎯 프로젝트 개요](#-프로젝트-개요)
- [⚡ 빠른 시작](#-빠른-시작)
- [🛠️ 환경 설정](#️-환경-설정)
- [🏗️ 프로젝트 구조](#️-프로젝트-구조)
- [🚀 개발 가이드](#-개발-가이드)
- [🐳 Docker 사용법](#-docker-사용법)
- [🔧 트러블슈팅](#-트러블슈팅)
- [🤝 기여하기](#-기여하기)

## 🎯 프로젝트 개요

이 모노레포는 현대적인 풀스택 웹 애플리케이션 개발을 위한 완벽한 템플릿입니다. Nx를 사용하여 여러 기술 스택을 효율적으로 관리하며, 실제 프로덕션 환경에서 사용할 수 있는 구조로 설계되었습니다.

### 🏛️ 아키텍처

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Backend       │
│   (Next.js)     │◄──►│   (Spring Boot) │◄──►│   (FastAPI)     │
│   Port: 3000    │    │   Port: 8080    │    │   Port: 8000    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 ▼
                    ┌─────────────────┐
                    │   PostgreSQL    │
                    │   Port: 5432    │
                    └─────────────────┘
```

### 🛠️ 기술 스택

| 영역 | 기술 | 버전 | 설명 |
|------|------|------|------|
| **Frontend** | Next.js | 15.2.4 | React 기반 풀스택 프레임워크 |
| **Backend** | Spring Boot | 3.2.0 | Java 기반 엔터프라이즈 백엔드 |
| **Backend** | FastAPI | 0.104.1 | Python 기반 고성능 API |
| **Database** | PostgreSQL | 15-alpine | 관계형 데이터베이스 |
| **Build Tool** | Nx | 21.1.3 | 모노레포 관리 도구 |
| **Package Manager** | pnpm | 8.x+ | 빠르고 효율적인 패키지 매니저 |
| **Container** | Docker | 20.x+ | 컨테이너화 및 배포 |

### ✨ 주요 특징

- 🔧 **Nx 모노레포**: 효율적인 코드 공유 및 의존성 관리
- 🚀 **마이크로서비스 아키텍처**: 독립적인 서비스 개발 및 배포
- 🐳 **Docker 지원**: 일관된 개발 및 배포 환경
- 🔄 **자동화된 스크립트**: 개발 환경 설정 및 빌드 자동화
- 📊 **통합 대시보드**: 모든 서비스 상태를 한눈에 확인
- 🔐 **인증 시스템**: Spring Security 기반 JWT 인증
- 📦 **API 문서화**: FastAPI 자동 문서 생성

## ⚡ 빠른 시작

### 1️⃣ 저장소 클론

```bash
git clone https://github.com/jisub0906/MonoRepo-Guide.git
cd MonoRepo-Guide
```

### 2️⃣ 환경 검증

```bash
# 모든 필수 도구가 설치되어 있는지 확인
chmod +x scripts/*.sh
./scripts/verify.sh
```

### 3️⃣ 의존성 설치

```bash
# Node.js 의존성 설치
pnpm install

# Python 가상환경 설정
cd apps/backend-fastapi
python3 -m venv venv
source venv/bin/activate  # Linux/macOS
# 또는
venv\Scripts\activate     # Windows
pip install -r requirements.txt
cd ../..

# Gradle 권한 설정 (Linux/macOS)
chmod +x apps/backend-spring/gradlew
```

### 4️⃣ 개발 환경 시작

```bash
# 모든 서비스를 한 번에 시작
./scripts/dev.sh
```

### 5️⃣ 브라우저에서 확인

- 🌐 **Frontend Dashboard**: http://localhost:3000
- 🌱 **Spring Boot API**: http://localhost:8080/api/auth/health
- 🐍 **FastAPI Docs**: http://localhost:8000/docs
- 📊 **FastAPI Health**: http://localhost:8000/health

---

## 🛠️ 환경 설정

### 📋 필수 요구사항

| 도구 | 최소 버전 | 권장 버전 | 확인 명령어 |
|------|-----------|-----------|-------------|
| Node.js | 20.0.0 | 22.x | `node --version` |
| Java | 21 | 21 | `java -version` |
| Python | 3.11 | 3.12 | `python3 --version` |
| pnpm | 8.0.0 | 9.x | `pnpm --version` |
| Docker | 20.0.0 | 24.x | `docker --version` |
| Docker Compose | 2.0.0 | 2.x | `docker-compose --version` |

### 🍎 macOS 설치 가이드

#### Homebrew 사용 (권장)

```bash
# Homebrew 설치 (이미 설치된 경우 생략)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 필수 도구 설치
brew install node@20 openjdk@21 python@3.12 pnpm docker docker-compose

# Java 환경 변수 설정
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 21)' >> ~/.zshrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zshrc
source ~/.zshrc

# Docker Desktop 설치 및 실행
brew install --cask docker
# Docker Desktop 앱을 실행하고 로그인
```

#### 수동 설치

1. **Node.js**: [nodejs.org](https://nodejs.org/)에서 LTS 버전 다운로드
2. **Java**: [Adoptium](https://adoptium.net/)에서 OpenJDK 21 다운로드
3. **Python**: [python.org](https://python.org/)에서 3.12 버전 다운로드
4. **pnpm**: `npm install -g pnpm`
5. **Docker**: [Docker Desktop for Mac](https://docs.docker.com/desktop/mac/install/) 다운로드

### 🐧 Linux (Ubuntu/Debian) 설치 가이드

```bash
# 시스템 업데이트
sudo apt update && sudo apt upgrade -y

# Node.js 20 설치
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Java 21 설치
sudo apt install -y openjdk-21-jdk

# Python 3.12 설치
sudo apt install -y python3.12 python3.12-venv python3.12-pip

# pnpm 설치
npm install -g pnpm

# Docker 설치
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Docker 권한 설정
sudo usermod -aG docker $USER
newgrp docker

# Docker Compose 설치
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 🪟 Windows 설치 가이드

#### Chocolatey 사용 (권장)

```powershell
# PowerShell을 관리자 권한으로 실행

# Chocolatey 설치
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 필수 도구 설치
choco install nodejs-lts -y; choco install openjdk --version=21.0.2 -y; choco install python --version=3.12 -y; choco install docker-desktop -y

# pnpm 설치
npm install -g pnpm

# 환경 변수 새로고침
refreshenv
```

#### 수동 설치

1. **Node.js**: [nodejs.org](https://nodejs.org/)에서 LTS 버전 다운로드
2. **Java**: [Adoptium](https://adoptium.net/)에서 OpenJDK 21 다운로드
3. **Python**: [python.org](https://python.org/)에서 3.12 버전 다운로드
4. **Docker**: [Docker Desktop for Windows](https://docs.docker.com/desktop/windows/install/) 다운로드
5. **pnpm**: `npm install -g pnpm`

#### WSL2 사용 (개발자 권장)

```bash
# WSL2 설치
wsl --install

# Ubuntu 22.04 설치
wsl --install -d Ubuntu-22.04

# WSL2에서 Linux 설치 가이드 따라하기
```

### ✅ 설치 검증

모든 도구가 올바르게 설치되었는지 확인:

```bash
# 저장소 클론 후 실행
cd MonoRepo-Guide
chmod +x scripts/*.sh
./scripts/verify.sh
```

성공 시 다음과 같은 메시지가 표시됩니다:
```
🎉 모든 검증이 성공했습니다!
✨ 완벽한 모노레포 환경이 구축되었습니다.
```

---

## 🏗️ 프로젝트 구조

```
MonoRepo-Guide/
├── 📁 apps/                          # 애플리케이션들
│   ├── 📁 frontend-nextjs/           # Next.js 프론트엔드
│   │   ├── 📁 src/
│   │   │   ├── 📁 app/              # App Router 페이지
│   │   │   │   ├── 📄 page.tsx      # 메인 대시보드
│   │   │   │   ├── 📄 layout.tsx    # 레이아웃
│   │   │   │   └── 📁 api/          # API 라우트
│   │   │   ├── 📁 components/       # React 컴포넌트
│   │   │   └── 📁 lib/              # 유틸리티 함수
│   │   ├── 📄 next.config.js        # Next.js 설정
│   │   ├── 📄 package.json          # 의존성 관리
│   │   ├── 📄 project.json          # Nx 프로젝트 설정
│   │   └── 📄 Dockerfile            # Docker 이미지 빌드
│   │
│   ├── 📁 backend-spring/            # Spring Boot 백엔드
│   │   ├── 📁 src/main/java/        # Java 소스 코드
│   │   │   └── 📁 com/example/authservice/
│   │   │       ├── 📄 AuthServiceApplication.java
│   │   │       └── 📁 controller/   # REST 컨트롤러
│   │   │           └── 📄 AuthController.java
│   │   ├── 📁 src/main/resources/   # 설정 파일
│   │   │   └── 📄 application.yml   # Spring Boot 설정
│   │   ├── 📄 build.gradle          # Gradle 빌드 설정
│   │   ├── 📄 project.json          # Nx 프로젝트 설정
│   │   └── 📄 Dockerfile            # Docker 이미지 빌드
│   │
│   └── 📁 backend-fastapi/           # FastAPI 백엔드
│       ├── 📁 app/                  # Python 애플리케이션
│       │   ├── 📄 main.py           # FastAPI 메인 앱
│       │   └── 📄 config.py         # 설정 관리
│       ├── 📁 venv/                 # Python 가상환경
│       ├── 📄 requirements.txt      # Python 의존성
│       ├── 📄 project.json          # Nx 프로젝트 설정
│       └── 📄 Dockerfile            # Docker 이미지 빌드
│
├── 📁 scripts/                       # 자동화 스크립트
│   ├── 📄 dev.sh                    # 개발 환경 시작
│   ├── 📄 build.sh                  # 프로덕션 빌드
│   └── 📄 verify.sh                 # 환경 검증
│
├── 📄 docker-compose.yml             # Docker 서비스 오케스트레이션
├── 📄 nx.json                       # Nx 워크스페이스 설정
├── 📄 package.json                  # 루트 의존성 및 스크립트
├── 📄 init-db.sql                   # 데이터베이스 초기화 스크립트
├── 📄 tsconfig.base.json            # TypeScript 기본 설정
├── 📄 eslint.config.mjs             # ESLint 설정
├── 📄 jest.config.ts                # Jest 테스트 설정
├── 📄 .prettierrc                   # Prettier 설정
└── 📄 README.md                     # 이 파일
```

### 🔍 주요 파일 설명

#### 루트 레벨
- **nx.json**: Nx 워크스페이스 설정, 플러그인 및 타겟 정의
- **package.json**: 루트 의존성 및 스크립트 정의
- **docker-compose.yml**: 모든 서비스의 Docker 컨테이너 설정

#### Frontend (Next.js)
- **src/app/page.tsx**: 통합 대시보드 페이지
- **next.config.js**: Next.js 설정 (빌드, 환경변수 등)
- **project.json**: Nx 프로젝트 설정 (빌드, 서브, 테스트 타겟)

#### Backend (Spring Boot)
- **AuthServiceApplication.java**: Spring Boot 메인 애플리케이션
- **build.gradle**: Gradle 빌드 설정 및 의존성
- **application.yml**: Spring Boot 설정 (데이터베이스, 보안 등)

#### Backend (FastAPI)
- **app/main.py**: FastAPI 메인 애플리케이션
- **requirements.txt**: Python 의존성 목록
- **app/config.py**: 환경 설정 관리

---

## 🚀 개발 가이드

### 🎬 개발 환경 시작

#### 방법 1: 통합 개발 환경 (권장)

```bash
# 모든 서비스를 한 번에 시작
./scripts/dev.sh
```

이 명령어는 다음을 순차적으로 실행합니다:
1. PostgreSQL 데이터베이스 시작
2. Spring Boot 백엔드 시작 (포트 8080)
3. FastAPI 백엔드 시작 (포트 8000)
4. Next.js 프론트엔드 시작 (포트 3000)

#### 방법 2: 개별 서비스 시작

```bash
# 데이터베이스만 시작
pnpm db:up

# 개별 서비스 시작
pnpm serve:frontend    # Next.js (포트 3000)
pnpm serve:spring      # Spring Boot (포트 8080)
pnpm serve:fastapi     # FastAPI (포트 8000)
```

#### 방법 3: Nx 명령어 직접 사용

```bash
# Nx를 사용한 개별 서비스 실행
pnpm nx serve frontend-nextjs
pnpm nx serve backend-spring
pnpm nx serve backend-fastapi
```

### 🏗️ 빌드 및 테스트

```bash
# 전체 프로젝트 빌드
./scripts/build.sh
# 또는
pnpm build:all

# 개별 프로젝트 빌드
pnpm nx build frontend-nextjs
pnpm nx build backend-spring

# 코드 품질 검사
pnpm lint:all

# 테스트 실행
pnpm test:all
```

### 📝 개발 워크플로우

1. **새 기능 개발**
   ```bash
   git checkout -b feature/새로운-기능
   # 개발 작업
   ./scripts/verify.sh  # 검증
   git commit -m "feat: 새로운 기능 추가"
   ```

2. **코드 품질 확인**
   ```bash
   pnpm lint:all    # 린트 검사
   pnpm test:all    # 테스트 실행
   pnpm build:all   # 빌드 확인
   ```

3. **Pull Request 생성**
   ```bash
   git push origin feature/새로운-기능
   # GitHub에서 PR 생성
   ```

### 🔧 유용한 명령어

```bash
# 환경 검증
./scripts/verify.sh

# 모든 서비스 중지
pnpm stop

# 로그 확인
pnpm logs

# 캐시 정리
pnpm clean

# 의존성 업데이트
pnpm update

# Nx 그래프 시각화
pnpm nx graph
```

### 🎯 개발 팁

#### Next.js 개발
```bash
# 개발 서버 시작
cd apps/frontend-nextjs
pnpm dev

# 빌드 및 시작
pnpm build
pnpm start
```

#### Spring Boot 개발
```bash
# 개발 서버 시작
cd apps/backend-spring
./gradlew bootRun

# 테스트 실행
./gradlew test

# JAR 빌드
./gradlew build
```

#### FastAPI 개발
```bash
# 가상환경 활성화
cd apps/backend-fastapi
source venv/bin/activate  # Linux/macOS
# 또는
venv\Scripts\activate     # Windows

# 개발 서버 시작
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# 테스트 실행
pytest

# 의존성 업데이트
pip freeze > requirements.txt
```

---

## 🐳 Docker 사용법

### 🚀 Docker Compose로 전체 환경 실행

```bash
# 전체 서비스 시작 (백그라운드)
docker-compose up -d

# 로그 확인
docker-compose logs -f

# 특정 서비스 로그 확인
docker-compose logs -f frontend-nextjs
docker-compose logs -f backend-spring
docker-compose logs -f backend-fastapi
docker-compose logs -f postgres-db

# 서비스 중지
docker-compose down

# 볼륨까지 삭제 (데이터베이스 초기화)
docker-compose down -v
```

### 🔨 개별 Docker 이미지 빌드

```bash
# 모든 이미지 빌드
docker-compose build

# 개별 이미지 빌드
docker-compose build frontend-nextjs
docker-compose build backend-spring
docker-compose build backend-fastapi

# 캐시 없이 빌드
docker-compose build --no-cache
```

### 📊 Docker 서비스 상태 확인

```bash
# 실행 중인 컨테이너 확인
docker-compose ps

# 리소스 사용량 확인
docker stats

# 네트워크 확인
docker network ls

# 볼륨 확인
docker volume ls
```

### 🔧 Docker 개발 환경

```bash
# 개발용 Docker Compose 오버라이드
# docker-compose.override.yml 파일 생성하여 개발 설정 추가

# 특정 서비스만 재시작
docker-compose restart backend-spring

# 컨테이너 내부 접속
docker-compose exec backend-spring bash
docker-compose exec postgres-db psql -U postgres -d authdb
```

---

## 🔧 트러블슈팅

### 🚨 일반적인 문제들

#### 1. 포트 충돌 오류

```bash
# 포트 사용 중인 프로세스 확인
# macOS/Linux
lsof -i :3000  # Next.js
lsof -i :8080  # Spring Boot
lsof -i :8000  # FastAPI
lsof -i :5432  # PostgreSQL

# Windows
netstat -ano | findstr :3000

# 프로세스 종료
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows
```

#### 2. Docker 관련 문제

```bash
# Docker 서비스 상태 확인
docker-compose ps

# 컨테이너 로그 확인
docker-compose logs <service-name>

# 컨테이너 재시작
docker-compose restart <service-name>

# 전체 환경 재구축
docker-compose down -v
docker-compose up --build -d

# Docker 시스템 정리
docker system prune -f
docker volume prune -f
```

#### 3. 의존성 설치 문제

```bash
# Node.js 의존성 재설치
rm -rf node_modules pnpm-lock.yaml
pnpm install

# Python 가상환경 재생성
cd apps/backend-fastapi
rm -rf venv
python3 -m venv venv
source venv/bin/activate  # Linux/macOS
# 또는
venv\Scripts\activate     # Windows
pip install -r requirements.txt

# Gradle 캐시 정리
cd apps/backend-spring
./gradlew clean build
```

#### 4. 권한 문제 (Linux/macOS)

```bash
# 스크립트 실행 권한 부여
chmod +x scripts/*.sh
chmod +x apps/backend-spring/gradlew

# Docker 권한 문제 (Linux)
sudo usermod -aG docker $USER
newgrp docker
```

#### 5. Java 버전 문제

```bash
# Java 버전 확인
java -version
javac -version

# JAVA_HOME 설정 확인
echo $JAVA_HOME

# macOS에서 Java 버전 변경
export JAVA_HOME=$(/usr/libexec/java_home -v 21)

# Linux에서 Java 버전 변경
sudo update-alternatives --config java
```

#### 6. Python 가상환경 문제

```bash
# Python 버전 확인
python3 --version

# 가상환경 재생성
cd apps/backend-fastapi
rm -rf venv
python3 -m venv venv

# 가상환경 활성화 확인
which python  # 가상환경 경로가 표시되어야 함
```

### 🔍 디버깅 도구

#### 로그 확인

```bash
# 개발 환경 로그
./scripts/dev.sh  # 모든 서비스 로그가 터미널에 표시

# Docker 환경 로그
docker-compose logs -f --tail=100

# 특정 서비스 로그
docker-compose logs -f frontend-nextjs
```

#### 데이터베이스 접속

```bash
# PostgreSQL 컨테이너 접속
docker-compose exec postgres-db psql -U postgres -d authdb

# 또는 로컬에서 접속
psql -h localhost -p 5432 -U postgres -d authdb

# 테이블 확인
\dt
\d users
```

#### API 테스트

```bash
# Spring Boot API 테스트
curl http://localhost:8080/api/auth/health

# FastAPI API 테스트
curl http://localhost:8000/health

# FastAPI 문서 확인
open http://localhost:8000/docs  # macOS
xdg-open http://localhost:8000/docs  # Linux
start http://localhost:8000/docs  # Windows
```

### 🔧 성능 최적화

#### Node.js 최적화
```bash
# 메모리 사용량 증가
export NODE_OPTIONS="--max-old-space-size=4096"

# 빌드 캐시 정리
rm -rf .next node_modules/.cache
```

#### Docker 최적화
```bash
# 이미지 크기 최적화
docker-compose build --compress

# 멀티스테이지 빌드 사용 (Dockerfile에서)
# 불필요한 이미지 정리
docker image prune -f
```

### 🆘 도움 요청

문제가 해결되지 않는 경우:

1. **환경 검증 실행**: `./scripts/verify.sh`
2. **로그 확인**: 오류 메시지 캡처
3. **Issue 생성**: [GitHub Issues](https://github.com/jisub0906/MonoRepo-Guide/issues)에 다음 정보와 함께 문의
   - 운영체제 및 버전
   - 설치된 도구 버전들 (`./scripts/verify.sh` 결과)
   - 오류 메시지 전문
   - 재현 단계

---

## 🤝 기여하기

### 🔄 개발 워크플로우

1. **Fork** 저장소
2. **Feature 브랜치** 생성
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **변경사항 커밋**
   ```bash
   git commit -m 'feat: Add amazing feature'
   ```
4. **브랜치 푸시**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Pull Request** 생성

### 📝 커밋 메시지 규칙

```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 수정
style: 코드 포맷팅
refactor: 코드 리팩토링
test: 테스트 추가/수정
chore: 빌드 설정 등 기타 변경
perf: 성능 개선
ci: CI/CD 설정 변경
```

### 🧪 코드 품질

Pull Request 전에 다음을 확인해주세요:

```bash
# 코드 품질 검사
pnpm lint:all

# 테스트 실행
pnpm test:all

# 빌드 확인
pnpm build:all

# 전체 환경 검증
./scripts/verify.sh
```

### 📋 PR 체크리스트

- [ ] 코드가 프로젝트 스타일 가이드를 따름
- [ ] 모든 테스트가 통과함
- [ ] 새로운 기능에 대한 테스트가 추가됨
- [ ] 문서가 업데이트됨 (필요한 경우)
- [ ] 변경사항이 기존 기능을 깨뜨리지 않음

---

## 📚 추가 리소스

### 🔗 공식 문서

- [Nx Documentation](https://nx.dev/getting-started/intro)
- [Next.js Documentation](https://nextjs.org/docs)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Docker Documentation](https://docs.docker.com/)

### 🎓 학습 자료

- [Nx Workspace Tutorial](https://nx.dev/getting-started/tutorials)
- [Next.js Learn](https://nextjs.org/learn)
- [Spring Boot Guides](https://spring.io/guides)
- [FastAPI Tutorial](https://fastapi.tiangolo.com/tutorial/)

### 🛠️ 개발 도구

- [VS Code Extensions](https://marketplace.visualstudio.com/items?itemName=nrwl.angular-console)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/)
- [PyCharm](https://www.jetbrains.com/pycharm/)

---

## 📄 라이선스

이 프로젝트는 [MIT 라이선스](LICENSE) 하에 배포됩니다.

---

## 🙏 감사의 말

- [Nx](https://nx.dev/) - 모노레포 관리 도구
- [Next.js](https://nextjs.org/) - React 프레임워크
- [Spring Boot](https://spring.io/projects/spring-boot) - Java 백엔드 프레임워크
- [FastAPI](https://fastapi.tiangolo.com/) - Python 웹 프레임워크
- [PostgreSQL](https://www.postgresql.org/) - 관계형 데이터베이스
- [Docker](https://www.docker.com/) - 컨테이너화 플랫폼

---

## 📞 문의사항

문의사항이나 제안사항이 있으시면 [Issues](https://github.com/jisub0906/MonoRepo-Guide/issues)를 통해 연락해주세요!

**🎉 Happy Coding! 🎉**
