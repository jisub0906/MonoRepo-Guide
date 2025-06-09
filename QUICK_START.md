# 🚀 팀원용 빠른 시작 가이드

> **5분 안에 개발 환경 구축하기** - 처음 설정하는 개발자를 위한 단계별 가이드

## 📋 체크리스트

시작하기 전에 다음 항목들을 확인해주세요:

- [ ] Git이 설치되어 있나요?
- [ ] 터미널(Command Line)을 사용할 수 있나요?
- [ ] 관리자 권한이 있나요? (일부 도구 설치 시 필요)

## 🎯 1단계: 저장소 클론

```bash
# 저장소 클론
git clone https://github.com/jisub0906/MonoRepo-Guide.git
cd MonoRepo-Guide
```

## 🛠️ 2단계: 필수 도구 설치

### 🍎 macOS 사용자

```bash
# Homebrew가 없다면 설치
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 모든 필수 도구 한 번에 설치
brew install node@20 openjdk@21 python@3.12 pnpm docker docker-compose

# Java 환경 변수 설정
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 21)' >> ~/.zshrc
source ~/.zshrc

# Docker Desktop 설치 및 실행
brew install --cask docker
# Docker Desktop 앱을 실행하고 로그인하세요
```

### 🐧 Linux (Ubuntu/Debian) 사용자

```bash
# 시스템 업데이트
sudo apt update && sudo apt upgrade -y

# Node.js 20 설치
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# 나머지 도구들 설치
sudo apt install -y openjdk-21-jdk python3.12 python3.12-venv python3.12-pip
npm install -g pnpm

# Docker 설치
sudo apt install -y docker.io docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker
```

### 🪟 Windows 사용자

#### 방법 1: Chocolatey 사용 (권장)

```powershell
# PowerShell을 관리자 권한으로 실행

# Chocolatey 설치
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 필수 도구 설치
choco install nodejs-lts openjdk21 python312 docker-desktop -y
npm install -g pnpm
```

#### 방법 2: 수동 설치

1. [Node.js LTS](https://nodejs.org/) 다운로드 및 설치
2. [OpenJDK 21](https://adoptium.net/) 다운로드 및 설치
3. [Python 3.12](https://python.org/) 다운로드 및 설치
4. [Docker Desktop](https://docs.docker.com/desktop/windows/install/) 다운로드 및 설치
5. 터미널에서 `npm install -g pnpm` 실행

## ✅ 3단계: 설치 검증

```bash
# 모든 도구가 올바르게 설치되었는지 확인
pnpm verify
```

**성공 메시지가 나타나면 다음 단계로 진행하세요!**

## 🚀 4단계: 개발 환경 시작

```bash
# 모든 서비스를 한 번에 시작
pnpm dev
```

이 명령어는 다음을 자동으로 실행합니다:
1. ✅ PostgreSQL 데이터베이스 시작
2. ✅ Spring Boot 백엔드 시작 (포트 8080)
3. ✅ FastAPI 백엔드 시작 (포트 8000)
4. ✅ Next.js 프론트엔드 시작 (포트 3000)

## 🌐 5단계: 브라우저에서 확인

다음 URL들을 브라우저에서 열어보세요:

- **🎨 프론트엔드**: http://localhost:3000
- **🌱 Spring Boot API**: http://localhost:8080/api/auth/health
- **🐍 FastAPI 문서**: http://localhost:8000/docs

모든 페이지가 정상적으로 로드되면 성공입니다! 🎉

## 🔧 문제 해결

### ❌ 설치 검증 실패 시

```bash
# 각 도구 버전 확인
node --version    # v20.x.x 이상이어야 함
java -version     # 21.x.x 이상이어야 함
python3 --version # 3.11.x 이상이어야 함
pnpm --version    # 8.x.x 이상이어야 함
docker --version  # 20.x.x 이상이어야 함
```

### ❌ 포트 충돌 오류 시

```bash
# 사용 중인 포트 확인 및 종료
# macOS/Linux
lsof -i :3000 && kill -9 $(lsof -t -i:3000)
lsof -i :8080 && kill -9 $(lsof -t -i:8080)
lsof -i :8000 && kill -9 $(lsof -t -i:8000)

# Windows
netstat -ano | findstr :3000
# 해당 PID를 찾아서: taskkill /PID <PID> /F
```

### ❌ Docker 관련 오류 시

```bash
# Docker 서비스 상태 확인
docker --version
docker-compose --version

# Docker Desktop이 실행 중인지 확인 (Windows/macOS)
# Linux에서는 Docker 서비스 시작
sudo systemctl start docker
```

## 🆘 도움 요청

문제가 해결되지 않으면:

1. **오류 메시지 전체**를 복사해주세요
2. **운영체제와 버전**을 알려주세요
3. **실행한 명령어**를 알려주세요
4. [GitHub Issues](https://github.com/your-username/MonoRepo-Guide/issues)에 문의해주세요

## 🎯 다음 단계

개발 환경이 성공적으로 구축되었다면:

1. **📖 메인 README.md** 읽어보기
2. **🏗️ 프로젝트 구조** 파악하기
3. **🚀 개발 가이드** 따라하기
4. **🤝 기여 방법** 확인하기

---

**🎉 환영합니다! 이제 모든 준비가 완료되었습니다! 🎉** 