FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder --chown=node:node /app ./

RUN npm prune --omit=dev

EXPOSE 5000

USER node

CMD ["npm", "start"]