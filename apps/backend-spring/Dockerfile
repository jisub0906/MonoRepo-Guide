# Spring Boot 백엔드 Dockerfile
FROM openjdk:17-jdk-slim AS builder

WORKDIR /app

# Gradle Wrapper와 빌드 파일 복사
COPY apps/backend-spring/gradlew ./
COPY apps/backend-spring/gradle ./gradle
COPY apps/backend-spring/build.gradle ./
COPY apps/backend-spring/settings.gradle ./

# 소스 코드 복사
COPY apps/backend-spring/src ./src

# 실행 권한 부여 및 빌드
RUN chmod +x ./gradlew
RUN ./gradlew bootJar --no-daemon

# 실행 단계
FROM openjdk:17-jre-slim

WORKDIR /app

# 빌드된 JAR 파일 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# 포트 노출
EXPOSE 8080

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "app.jar"] 