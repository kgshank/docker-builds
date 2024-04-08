FROM alpine:latest as builder

RUN apk --no-cache add ca-certificates \
  && update-ca-certificates

COPY certs/myCA.pem /usr/local/share/ca-certificates/myCA.crt

RUN update-ca-certificates
FROM ghcr.io/bakito/adguardhome-sync as source
# application image
FROM scratch
WORKDIR  /opt/go/
COPY --from=source /opt/go/adguardhome-sync  /opt/go/adguardhome-sync

EXPOSE 8080

ENTRYPOINT ["/opt/go/adguardhome-sync"]

CMD ["run", "--config", "/config/adguardhome-sync.yaml"]

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=source /usr/share/zoneinfo/ /usr/share/zoneinfo/

USER 1001
