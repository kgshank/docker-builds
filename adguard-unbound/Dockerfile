FROM busybox as builder
ARG TARGETARCH
ARG BUILDONLY_TOOLS='tar xz-utils'
#RUN apt update && apt upgrade -y && apt install -y unbound ${BUILDONLY_TOOLS}

ARG S6_OVERLAY_VERSION=3.1.6.2
# syntax=docker/dockerfile-upstream:master
WORKDIR /s6
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C /s6 -Jxpf /tmp/s6-overlay-noarch.tar.xz
ENV S6_ARCH=${TARGETARCH//amd64/x86_64}
ENV S6_ARCH=${S6_ARCH//arm64/aarch64}
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz /tmp
RUN tar -C /s6 -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz

FROM adguard/adguardhome:latest as source 
# application image

FROM debian:bullseye-slim
RUN apt update && apt upgrade -y && apt install -y unbound ca-certificates

COPY certs/myCA.pem /usr/local/share/ca-certificates/myCA.crt

RUN update-ca-certificates

COPY --from=builder /s6  /

COPY unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf

COPY 99-edns.conf /etc/dnsmasq.d/99-edns.conf

RUN mkdir -p /etc/services.d/unbound

COPY unbound-run /etc/services.d/unbound/run

RUN mkdir -p /opt/adguardhome/work

COPY --from=source --chown=root:root /opt/adguardhome/AdGuardHome /opt/adguardhome/AdGuardHome

RUN mkdir -p /etc/services.d/adguard

COPY adguard-run /etc/services.d/adguard/run

EXPOSE 53/tcp 53/udp 67/udp 68/udp 80/tcp 443/tcp 443/udp 853/tcp\
	853/udp 3000/tcp 3000/udp 5443/tcp 5443/udp 6060/tcp 5335/tcp 5335/udp

ENV ADGUARD_ARGS="--no-check-update -c /opt/adguardhome/conf/AdGuardHome.yaml -w /opt/adguardhome/work"

ENTRYPOINT ["/init"]


