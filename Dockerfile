# Install dependencies and build the TypeScript application
FROM oven/bun:1 AS builder

WORKDIR /app

COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

COPY tsconfig.json ./
COPY src ./src
RUN bun run build

# Run the compiled application with Node.js
FROM node:22-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

COPY package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY drizzle.config.ts ./
COPY drizzle ./drizzle

EXPOSE 3000

CMD ["node", "dist/server.js"]