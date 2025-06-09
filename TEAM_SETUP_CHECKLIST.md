# 👥 팀원 설정 체크리스트

> **팀 리더/시니어 개발자용** - 팀원들의 개발 환경 설정을 도와주기 위한 체크리스트

## 📋 사전 준비사항

### 팀 리더가 확인해야 할 사항

- [ ] GitHub 저장소가 public으로 설정되어 있거나, 팀원들에게 접근 권한이 부여되었는가?
- [ ] README.md와 QUICK_START.md가 최신 상태인가?
- [ ] 모든 환경에서 `pnpm verify` 명령어가 정상 작동하는가?

### 팀원에게 미리 안내할 사항

1. **필요한 권한**: 관리자 권한 (도구 설치 시)
2. **예상 소요 시간**: 15-30분 (인터넷 속도에 따라)
3. **필요한 디스크 공간**: 최소 5GB 이상
4. **지원 운영체제**: macOS, Windows, Linux (Ubuntu/Debian)

## 🛠️ 운영체제별 설정 가이드

### 🍎 macOS 팀원 지원

#### 사전 확인사항
```bash
# macOS 버전 확인 (10.15 이상 권장)
sw_vers

# Xcode Command Line Tools 설치 확인
xcode-select --install
```

#### 일반적인 문제들
- **Homebrew 설치 실패**: 네트워크 방화벽 확인
- **Java 환경변수 미설정**: `echo $JAVA_HOME` 확인
- **Docker Desktop 로그인 필요**: Apple ID로 로그인 안내

### 🐧 Linux 팀원 지원

#### 사전 확인사항
```bash
# Ubuntu/Debian 버전 확인 (18.04 이상 권장)
lsb_release -a

# 패키지 관리자 업데이트
sudo apt update
```

#### 일반적인 문제들
- **권한 문제**: `sudo` 권한 확인
- **Docker 권한**: 사용자를 docker 그룹에 추가 필요
- **Python 버전**: `python3` vs `python` 명령어 차이

### 🪟 Windows 팀원 지원

#### 사전 확인사항
```powershell
# Windows 버전 확인 (Windows 10 이상 권장)
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion

# PowerShell 실행 정책 확인
Get-ExecutionPolicy
```

#### 권장 설정
- **WSL2 설치 권장**: 더 나은 개발 경험
- **PowerShell 관리자 권한**: 도구 설치 시 필요
- **Windows Terminal 설치**: 더 나은 터미널 경험

## 🔍 단계별 검증 체크리스트

### 1단계: 저장소 클론 ✅
```bash
git clone https://github.com/your-username/MonoRepo-Guide.git
cd MonoRepo-Guide
```

**확인사항:**
- [ ] 저장소가 정상적으로 클론되었는가?
- [ ] 모든 파일과 폴더가 존재하는가?

### 2단계: 도구 설치 ✅
**macOS:**
```bash
brew install node@20 openjdk@21 python@3.12 pnpm docker docker-compose
```

**Linux:**
```bash
# Node.js, Java, Python, Docker 설치
```

**Windows:**
```powershell
choco install nodejs-lts openjdk21 python312 docker-desktop -y
```

**확인사항:**
- [ ] 모든 도구가 설치되었는가?
- [ ] 버전이 요구사항을 만족하는가?

### 3단계: 환경 검증 ✅
```bash
pnpm verify
```

**확인사항:**
- [ ] 모든 검증 항목이 통과했는가?
- [ ] 실패한 항목이 있다면 해결되었는가?

### 4단계: 개발 환경 시작 ✅
```bash
pnpm dev
```

**확인사항:**
- [ ] 모든 서비스가 정상적으로 시작되었는가?
- [ ] 포트 충돌이 없는가?
- [ ] 로그에 오류가 없는가?

### 5단계: 브라우저 접속 ✅
- [ ] http://localhost:3000 (Next.js)
- [ ] http://localhost:8080/api/auth/health (Spring Boot)
- [ ] http://localhost:8000/docs (FastAPI)

## 🚨 일반적인 문제 해결

### 포트 충돌 문제
```bash
# 포트 사용 중인 프로세스 확인
lsof -i :3000  # macOS/Linux
netstat -ano | findstr :3000  # Windows

# 프로세스 종료
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows
```

### Docker 관련 문제
```bash
# Docker 서비스 상태 확인
docker --version
docker-compose --version

# Docker Desktop 재시작 (Windows/macOS)
# Linux에서 Docker 서비스 재시작
sudo systemctl restart docker
```

### 권한 문제 (Linux/macOS)
```bash
# 스크립트 실행 권한 부여
chmod +x scripts/*.sh
chmod +x apps/backend-spring/gradlew

# Docker 권한 설정 (Linux)
sudo usermod -aG docker $USER
newgrp docker
```

### Python 가상환경 문제
```bash
# FastAPI 가상환경 재생성
cd apps/backend-fastapi
rm -rf venv
python3 -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows
pip install -r requirements.txt
```

## 📞 팀원 지원 프로세스

### 1차 지원: 자가 해결
1. **QUICK_START.md** 가이드 따라하기
2. **문제 해결 섹션** 확인하기
3. **pnpm verify** 명령어로 재검증

### 2차 지원: 팀 내 도움
1. **Slack/Teams**에 오류 메시지와 함께 문의
2. **화면 공유**를 통한 실시간 지원
3. **페어 프로그래밍** 세션으로 함께 해결

### 3차 지원: 이슈 등록
1. **GitHub Issues**에 상세한 정보와 함께 등록
2. 포함할 정보:
   - 운영체제 및 버전
   - 실행한 명령어
   - 전체 오류 메시지
   - 스크린샷 (필요시)

## 📊 팀 설정 현황 추적

### 팀원별 진행 상황 체크리스트

| 팀원 이름 | OS | 클론 | 도구 설치 | 검증 | 개발 환경 | 상태 |
|-----------|----|----|----------|------|----------|------|
| 홍길동 | macOS | ✅ | ✅ | ✅ | ✅ | 완료 |
| 김철수 | Windows | ✅ | ⏳ | ❌ | ❌ | 진행중 |
| 이영희 | Linux | ✅ | ✅ | ✅ | ✅ | 완료 |

### 공통 이슈 추적

| 이슈 | 빈도 | 해결 방법 | 상태 |
|------|------|----------|------|
| Docker 권한 문제 | 높음 | usermod -aG docker | 해결됨 |
| 포트 3000 충돌 | 중간 | 프로세스 종료 | 해결됨 |
| Java 환경변수 | 낮음 | JAVA_HOME 설정 | 해결됨 |

## 🎯 성공 기준

모든 팀원이 다음을 달성했을 때 설정 완료:

- [ ] `pnpm verify` 명령어 100% 통과
- [ ] `pnpm dev` 명령어로 모든 서비스 정상 시작
- [ ] 3개 URL 모두 브라우저에서 정상 접속
- [ ] 첫 번째 커밋 및 푸시 성공

## 📚 추가 리소스

- **메인 문서**: [README.md](README.md)
- **빠른 시작**: [QUICK_START.md](QUICK_START.md)
- **이슈 트래킹**: [GitHub Issues](https://github.com/your-username/MonoRepo-Guide/issues)
- **팀 채널**: #dev-setup (Slack/Teams)

---

**💡 팁: 팀원들이 막힐 때는 화면 공유를 통한 실시간 지원이 가장 효과적입니다!** 