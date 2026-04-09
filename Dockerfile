FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    asterisk \
    ca-certificates \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

RUN rm -rf /etc/asterisk/*

RUN printf '[options]\nrunuser = asterisk\nrungroup = asterisk\n' \
    > /etc/asterisk/asterisk.conf

RUN printf '[general]\nrtpstart=10000\nrtpend=10100\n' \
    > /etc/asterisk/rtp.conf

RUN printf '[general]\n[logfiles]\nconsole => notice,warning,error\n' \
    > /etc/asterisk/logger.conf

COPY config/ /opt/config/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5060/udp 5060/tcp 10000-10100/udp

ENTRYPOINT ["/entrypoint.sh"]
