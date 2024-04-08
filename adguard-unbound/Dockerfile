FROM adguard/adguardhome:latest

RUN apk --no-cache add wget unbound

COPY unbound-local.conf /etc/unbound/unbound.conf.d/unbound-local.conf

COPY entrypoint.sh /usr/local/bin/

RUN chmod u+x,g+x /usr/local/bin/entrypoint.sh\
  && ln -s /usr/local/bin/entrypoint.sh /

RUN wget -S https://www.internic.net/domain/named.cache -O /etc/unbound/root.hints

ENTRYPOINT ["entrypoint.sh"]

WORKDIR /opt/adguardhome/work

CMD ["/opt/adguardhome/AdGuardHome", \
	"--no-check-update", \
	"-c", "/opt/adguardhome/conf/AdGuardHome.yaml", \
	"-w", "/opt/adguardhome/work" \
]
