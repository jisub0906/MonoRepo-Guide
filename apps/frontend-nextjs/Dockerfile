# Next.js 프론트엔드 Dockerfile
FROM node:20-alpine AS base

# 의존성 설치 단계
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# pnpm 설치
RUN npm install -g pnpm

# 의존성 파일 복사 및 설치
COPY package.json pnpm-lock.yaml* ./
COPY apps/frontend-nextjs/package.json ./apps/frontend-nextjs/
RUN pnpm install --frozen-lockfile

# 빌드 단계
FROM base AS builder
WORKDIR /app

# pnpm 설치
RUN npm install -g pnpm

# 의존성 복사
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/apps/frontend-nextjs/node_modules ./apps/frontend-nextjs/node_modules

# 소스 코드 복사
COPY . .

# Next.js 빌드
WORKDIR /app/apps/frontend-nextjs
RUN pnpm build

# 실행 단계
FROM base AS runner
WORKDIR /app

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# 빌드 결과물 복사
COPY --from=builder /app/apps/frontend-nextjs/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/apps/frontend-nextjs/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/frontend-nextjs/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"] 