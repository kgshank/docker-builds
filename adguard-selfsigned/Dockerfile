FROM alpine:latest as builder

RUN apk --no-cache add ca-certificates \
  && update-ca-certificates

COPY certs/myCA.pem /usr/local/share/ca-certificates/myCA.crt

RUN update-ca-certificates

FROM adguard/adguardhome:latest as source 
# application image

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=source /opt/adguardhome/AdGuardHome /opt/adguardhome/AdGuardHome

EXPOSE 53/tcp 53/udp 67/udp 68/udp 80/tcp 443/tcp 443/udp 853/tcp\
	853/udp 3000/tcp 3000/udp 5443/tcp 5443/udp 6060/tcp 5335/tcp 5335/udp

WORKDIR /opt/adguardhome/work

ENTRYPOINT ["/opt/adguardhome/AdGuardHome"]

CMD ["--no-check-update", \
	"-c", "/opt/adguardhome/conf/AdGuardHome.yaml", \
	"-w", "/opt/adguardhome/work" \
]
