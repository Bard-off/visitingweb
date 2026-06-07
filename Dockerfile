FROM mirror.gcr.io/library/node:20-alpine AS builder
WORKDIR /app

COPY ./html ./dist

FROM mirror.gcr.io/library/caddy:2.7-alpine

COPY /gateway/Caddyfile /etc/caddy/Caddyfile


RUN caddy fmt --overwrite /etc/caddy/Caddyfile
COPY --from=builder /app/dist /usr/share/caddy

USER caddy

EXPOSE 80 443
