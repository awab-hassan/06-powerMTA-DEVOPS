FROM ubuntu:22.04

RUN apt update -y && \
  apt install telnet -y && \
  apt install -y unzip && \
  apt install openssl -y && \
  apt install alien -y

WORKDIR /root
COPY pmta.zip /root
WORKDIR /root
RUN unzip pmta.zip

RUN apt install -y perl
RUN groupadd -r pmta
RUN useradd -r -g pmta pmta
RUN chmod 755 PowerMTA-4.5r8.rpm
RUN alien -i PowerMTA-4.5r8.rpm
RUN mv license /etc/pmta/
RUN rm -rf /usr/sbin/pmtad
RUN mv pmtad /usr/sbin/
RUN chmod 750 /usr/sbin/pmtad
RUN chown pmta:pmta /etc/pmta/config
RUN chmod 640 /etc/pmta/config
RUN mkdir -p /var/spool/pmtaPickup/
RUN mkdir -p /etc/pmta/domainKeys/
RUN mkdir -p /var/spool/pmtaPickup/Pickup
RUN mkdir -p /var/spool/pmtaPickup/BadMail
RUN mkdir -p /var/spool/pmtaIncoming
RUN chown pmta:pmta /var/spool/pmtaIncoming
RUN chmod 755 /var/spool/pmtaIncoming
RUN chown pmta:pmta /var/spool/pmtaPickup/*
RUN mkdir -p /var/log/pmta
RUN mkdir -p /var/log/pmtaAccRep
RUN mkdir -p /var/log/pmtaErr
RUN mkdir -p /var/log/pmtaErrRep
RUN chown pmta:pmta /var/log/pmta
RUN chown pmta:pmta /var/log/pmtaAccRep
RUN chown pmta:pmta /var/log/pmtaErr
RUN chown pmta:pmta /var/log/pmtaErrRep

USER root

RUN echo "#!/bin/bash" > ./entrypoint.sh
RUN echo "service pmta start" >> ./entrypoint.sh
RUN echo "service pmtahttp start" >> ./entrypoint.sh
RUN echo "tail -f /dev/null" >> ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
