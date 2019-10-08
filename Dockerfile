FROM lukas1818/aur-builder AS builder

ENV PACKAGE_NAME rconc 

RUN /home/build/build.sh





FROM debian:stable-slim

COPY --from=builder /home/build/build/rconc/pkg/rconc/usr/bin/rconc /opt/rconc/rconc
RUN ln -s /opt/rconc/rconc /usr/bin/rconc \
 && chmod a+x /opt/rconc/rconc

COPY backup.sh /opt/backup/backup.sh
RUN chmod a+x /opt/backup/backup.sh

CMD ["/opt/backup/backup.sh"]
