# 1. The Caddy Builder Stage (Combines your plugins)
FROM caddy:2.7-builder AS caddy-builder
RUN xcaddy build --with github.com/caddyserver/ntlm-transport # (Example plugin)

# 2. Your Node Assets Stage
FROM mirror.gcr.io/library/node:20-alpine AS builder
WORKDIR /app
COPY ./html ./dist

# 3. Final Production Stage
FROM mirror.gcr.io/library/caddy:2.7-alpine
COPY /gateway/Caddyfile /etc/caddy/Caddyfile

# Now this line works, because 'caddy-builder' is defined above!
COPY --from=caddy-builder /usr/bin/caddy /usr/bin/caddy

RUN caddy fmt --overwrite /etc/caddy/Caddyfile
COPY --from=builder /app/dist /usr/share/caddy

USER appuser
EXPOSE 80 443
