FROM alpine:edge
RUN apk --no-cache add dnsmasq
COPY ./dnsmasq.conf /etc/dnsmasq.conf
ENTRYPOINT ["dnsmasq", "-k"]
