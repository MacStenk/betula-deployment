# Betula Dockerfile für Railway
# Multi-stage build: Go builder + Alpine runtime
# CGO_ENABLED=1 ist kritisch für SQLite!

# ============================================
# Stage 1: Builder
# ============================================
FROM golang:1.23-alpine AS builder

# SQLite benötigt CGO und diese Build-Dependencies
RUN apk add --no-cache \
    git \
    gcc \
    musl-dev \
    sqlite-dev

WORKDIR /build

# Betula aus dem offiziellen Codeberg-Repository klonen
RUN git clone --depth 1 https://codeberg.org/bouncepaw/betula.git .

# CGO aktivieren (essentiell für SQLite!)
ENV CGO_ENABLED=1

# Go Dependencies laden
RUN go mod download

# Binary bauen - WICHTIG: Betula main ist in ./cmd/betula!
RUN go build -o betula \
    -ldflags="-w -s" \
    -trimpath \
    ./cmd/betula

# ============================================
# Stage 2: Runtime
# ============================================
FROM alpine:3.19

# Runtime-Dependencies für SQLite
RUN apk add --no-cache \
    sqlite-libs \
    ca-certificates \
    tzdata \
    wget \
    bash

# Binary vom Builder kopieren
COPY --from=builder /build/betula /usr/local/bin/betula

# Data-Directory für SQLite-Datei
# WICHTIG: Volume wird über Railway UI gemountet!
RUN mkdir -p /data && \
    chmod 777 /data

# Betula Port
EXPOSE 1738

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:1738/ || exit 1

# Startup script um sicherzustellen dass /data beschreibbar ist
# und die SQLite-Datei erstellt werden kann
CMD ["sh", "-c", "mkdir -p /data && chmod 777 /data && exec betula /data/bookmarks.betula"]
