FROM node:22.16.0-alpine AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
RUN npm prune --production

FROM gcr.io/distroless/nodejs22-debian12
COPY --chown=nonroot:nonroot --from=builder /usr/src/app/node_modules ./node_modules
COPY --chown=nonroot:nonroot --from=builder /usr/src/app/dist ./dist
USER nonroot:nonroot
EXPOSE 3000
CMD ["dist/main"]
