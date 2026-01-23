FROM docker.io/library/golang:1.25.6-alpine AS builder
ENV CGO_ENABLED=0 \
    GOARCH=amd64
RUN apk add --no-cache git tini-static
WORKDIR /build
COPY . .
RUN go build -o goapplicationframework -ldflags "-X github.com/robstradling/goapplicationframework/config.BuildTimestamp=`date --utc +%Y-%m-%dT%H:%M:%SZ`" /build/.

FROM gcr.io/distroless/static:nonroot
USER nonroot:nonroot
COPY --from=builder --chown=nonroot:nonroot /build/goapplicationframework /app/goapplicationframework
COPY --from=builder --chown=nonroot:nonroot /sbin/tini-static /sbin/tini
VOLUME ["/config"]
ENTRYPOINT [ "/sbin/tini", "--", "/app/goapplicationframework" ]

LABEL \
    org.opencontainers.image.base.name="gcr.io/distroless/static:nonroot" \
    org.opencontainers.image.title="goapplicationframework" \
    org.opencontainers.image.source="https://github.com/robstradling/goapplicationframework"
