FROM node:24-trixie-slim AS builder

WORKDIR /usr/app

RUN apt-get update && apt-get install -y --no-install-recommends \
  python3 \
  python3-setuptools \
  make \
  g++ \
  git \
  && ln -sf python3 /usr/bin/python \
  && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./
COPY patches ./patches

RUN npm ci && npm prune --omit=dev

FROM node:24-trixie-slim

WORKDIR /usr/app

COPY --from=builder /usr/app/node_modules ./node_modules
COPY package.json ./

RUN mkdir ./db \
  && mkdir ./attachments

COPY src ./src
COPY knexfile.js ./knexfile.js

CMD ["node", "src/index.js"]
