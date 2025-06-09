# 기여 가이드

MonoRepo Guide 프로젝트에 기여해주셔서 감사합니다! 🎉

## 🚀 시작하기

### 1. 저장소 포크 및 클론

```bash
# 1. GitHub에서 저장소를 포크합니다
# 2. 포크한 저장소를 클론합니다
git clone https://github.com/jisub0906/MonoRepo-Guide.git
cd MonoRepo-Guide

# 3. 원본 저장소를 upstream으로 추가합니다
git remote add upstream https://github.com/original-owner/MonoRepo-Guide.git
```

### 2. 개발 환경 설정

```bash
# 의존성 설치
pnpm install

# 개발 환경 실행
pnpm dev
```

## 📝 개발 워크플로우

### 1. 브랜치 생성

```bash
# 최신 main 브랜치로 업데이트
git checkout main
git pull upstream main

# 새 기능 브랜치 생성
git checkout -b feature/your-feature-name
```

### 2. 개발 및 테스트

```bash
# 코드 작성 후 테스트 실행
pnpm test:all

# 린트 검사
pnpm lint:all

# 빌드 테스트
pnpm build:all
```

### 3. 커밋 및 푸시

```bash
# 변경사항 커밋
git add .
git commit -m "feat: add amazing feature"

# 브랜치 푸시
git push origin feature/your-feature-name
```

### 4. Pull Request 생성

1. GitHub에서 Pull Request를 생성합니다
2. 템플릿에 따라 설명을 작성합니다
3. 리뷰어를 지정합니다

## 📋 커밋 메시지 규칙

다음 형식을 따라주세요:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Type
- `feat`: 새로운 기능 추가
- `fix`: 버그 수정
- `docs`: 문서 수정
- `style`: 코드 포맷팅 (기능 변경 없음)
- `refactor`: 코드 리팩토링
- `test`: 테스트 추가/수정
- `chore`: 빌드 설정 등 기타 변경

### Scope (선택사항)
- `frontend`: Next.js 프론트엔드
- `backend-spring`: Spring Boot 백엔드
- `backend-fastapi`: FastAPI 백엔드
- `docker`: Docker 관련
- `docs`: 문서 관련

### 예시
```
feat(frontend): add user authentication UI
fix(backend-spring): resolve JWT token validation issue
docs: update installation guide
```

## 🧪 테스트 가이드

### 단위 테스트
```bash
# 전체 테스트
pnpm test:all

# 개별 서비스 테스트
pnpm test:frontend
pnpm test:spring
pnpm test:fastapi
```

### 통합 테스트
```bash
# 서비스 시작 후 API 테스트
pnpm dev

# 다른 터미널에서
curl http://localhost:3000/api/health
curl http://localhost:8080/api/auth/health
curl http://localhost:8000/health
```

## 📚 코딩 스타일

### TypeScript/JavaScript
- ESLint 설정을 따릅니다
- Prettier로 포맷팅합니다
- 함수와 변수에 명확한 이름을 사용합니다

### Java
- Google Java Style Guide를 따릅니다
- Checkstyle 규칙을 준수합니다

### Python
- PEP 8 스타일 가이드를 따릅니다
- Black으로 포맷팅합니다
- Type hints를 사용합니다

## 🐛 버그 리포트

버그를 발견하셨나요? 다음 정보를 포함해서 이슈를 생성해주세요:

1. **환경 정보**
   - OS: (예: Ubuntu 22.04, macOS 13.0, Windows 11)
   - Node.js 버전
   - Java 버전
   - Python 버전

2. **재현 단계**
   - 버그를 재현하는 구체적인 단계

3. **예상 결과**
   - 어떤 결과를 예상했는지

4. **실제 결과**
   - 실제로 어떤 일이 발생했는지

5. **추가 정보**
   - 스크린샷, 로그, 에러 메시지 등

## 💡 기능 제안

새로운 기능을 제안하고 싶으시다면:

1. **기능 설명**
   - 어떤 기능인지 명확히 설명

2. **사용 사례**
   - 언제, 왜 이 기능이 필요한지

3. **구현 아이디어**
   - 어떻게 구현할 수 있을지 (선택사항)

## 📞 도움이 필요하신가요?

- 💬 [Discussions](https://github.com/your-username/MonoRepo-Guide/discussions)에서 질문하세요
- 🐛 [Issues](https://github.com/your-username/MonoRepo-Guide/issues)에서 버그를 신고하세요
- 📧 이메일: your-email@example.com

## 🙏 감사합니다!

여러분의 기여가 이 프로젝트를 더욱 훌륭하게 만듭니다. 모든 기여자분들께 진심으로 감사드립니다! ❤️ 