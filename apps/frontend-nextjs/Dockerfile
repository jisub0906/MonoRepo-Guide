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
RUN pnpm install --frozen-lockfile

# 빌드 단계
FROM base AS builder
WORKDIR /app

# pnpm 설치
RUN npm install -g pnpm

# 의존성 복사
COPY --from=deps /app/node_modules ./node_modules

# 소스 코드 복사
COPY . .

# Next.js 빌드
RUN pnpm nx build frontend-nextjs

# 실행 단계
FROM base AS runner
WORKDIR /app

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# pnpm 설치
RUN npm install -g pnpm

# 필요한 파일들만 복사
COPY --from=builder --chown=nextjs:nodejs /app/package.json ./
COPY --from=builder --chown=nextjs:nodejs /app/pnpm-lock.yaml ./
COPY --from=builder --chown=nextjs:nodejs /app/nx.json ./
COPY --from=builder --chown=nextjs:nodejs /app/tsconfig.base.json ./
COPY --from=builder --chown=nextjs:nodejs /app/eslint.config.mjs ./
COPY --from=builder --chown=nextjs:nodejs /app/jest.config.ts ./
COPY --from=builder --chown=nextjs:nodejs /app/jest.preset.js ./
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nextjs:nodejs /app/apps/frontend-nextjs ./apps/frontend-nextjs

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

WORKDIR /app

CMD ["sh", "-c", "cd /app/apps/frontend-nextjs && ../../node_modules/.bin/next start"] 