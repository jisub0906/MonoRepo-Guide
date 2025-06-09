# 보안 정책

## 지원되는 버전

현재 보안 업데이트를 받는 버전:

| 버전 | 지원 여부 |
| --- | --- |
| 1.x.x | ✅ |

## 보안 취약점 신고

보안 취약점을 발견하셨다면 다음 방법으로 신고해주세요:

### 🔒 비공개 신고 (권장)

심각한 보안 취약점의 경우:

1. **이메일**: security@example.com
2. **제목**: `[SECURITY] 취약점 신고 - [간단한 설명]`
3. **내용**:
   - 취약점 설명
   - 재현 단계
   - 영향 범위
   - 제안하는 해결책 (있다면)

### 📋 신고 시 포함할 정보

- **취약점 유형**: (예: SQL Injection, XSS, CSRF 등)
- **영향받는 컴포넌트**: (예: frontend-nextjs, backend-spring 등)
- **심각도**: Critical / High / Medium / Low
- **재현 환경**: OS, 브라우저, 버전 등
- **재현 단계**: 상세한 단계별 설명
- **증명 자료**: 스크린샷, 로그 등

## 🛡️ 보안 모범 사례

### 개발 환경

1. **환경 변수 관리**
   ```bash
   # .env 파일을 절대 커밋하지 마세요
   echo ".env" >> .gitignore
   
   # 강력한 비밀번호 사용
   JWT_SECRET=your-super-strong-secret-key-here
   ```

2. **의존성 보안 검사**
   ```bash
   # npm audit 실행
   pnpm audit
   
   # 취약점 자동 수정
   pnpm audit --fix
   ```

3. **Docker 보안**
   ```dockerfile
   # 루트 사용자 사용 금지
   RUN addgroup --system --gid 1001 nodejs
   RUN adduser --system --uid 1001 nextjs
   USER nextjs
   ```

### 프로덕션 환경

1. **HTTPS 사용 필수**
2. **강력한 JWT 시크릿 키 사용**
3. **데이터베이스 접근 제한**
4. **정기적인 보안 업데이트**

## 🔄 보안 업데이트 프로세스

1. **취약점 접수** (24시간 내 응답)
2. **영향 평가** (48시간 내)
3. **수정 개발** (심각도에 따라 1-7일)
4. **테스트 및 검증**
5. **보안 패치 배포**
6. **공개 공지** (수정 후 30일)

## 📞 연락처

- **보안 이메일**: security@example.com
- **일반 문의**: [GitHub Issues](https://github.com/your-username/MonoRepo-Guide/issues)

---

**참고**: 이 프로젝트는 교육 목적의 데모 애플리케이션입니다. 프로덕션 환경에서 사용하기 전에 추가적인 보안 검토가 필요합니다. 