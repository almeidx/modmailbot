FROM node:24-alpine

WORKDIR /usr/app

RUN apk add --no-cache \
  python3 \
  py3-setuptools \
  make \
  g++ \
  git \
  && ln -sf python3 /usr/bin/python

COPY package.json package-lock.json ./

RUN npm ci --omit=dev

RUN mkdir ./db \
  && mkdir ./attachments

COPY src ./src
COPY knexfile.js ./knexfile.js

CMD ["node", "src/index.js"]
