FROM ubuntu:focal
LABEL Developer "Andreas Till <andreas.till@netzint.de>"
LABEL Maintainer "Lukas Spitznagel <lukas.spitznagel@netzint.de>"

ENTRYPOINT [ "/entrypoint.sh" ]

ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y -o Dpkg::Options::="--force-confold" \
    openjdk-8-jdk \
    maven \
    g++ \
    make \
    pkg-config \
    zip \
    pgpgpg \
    libpcsclite-dev \
    libcups2-dev \
    libpam0g-dev \
    git \
    sudo \
    cups \
    cups-bsd \
    binutils \
    cpio \
    poppler-utils \
    qpdf \
    imagemagick \
    avahi-daemon \
    avahi-discover \
    libnss-mdns \
    postgresql-client \
    python3-psycopg2 \ 
    foomatic-db-compressed-ppds \
    printer-driver-all \
    openprinting-ppds \
    hpijs-ppds \
    hp-ppd \
    hplip \
    printer-driver-cups-pdf

RUN mkdir -p /root/savapage/repos
COPY init.sh /root/savapage/repos/init.sh
RUN cd /root/savapage/repos && sh ./init.sh
COPY savapage_core_pom.xml /root/savapage/repos/savapage-core/pom.xml
RUN rm /root/savapage/repos/init.sh
RUN cd /root/savapage/repos/savapage-make && ./dev-git-all.sh "checkout develop"
RUN cd /root/savapage/repos/savapage-make && ./build.sh all-x64

RUN mkdir -p /opt/savapage
RUN useradd  -r savapage -d /opt/savapage -s /bin/bash
RUN usermod -a -G lpadmin savapage
RUN chown -R savapage /opt/savapage
RUN mv $(ls /root/savapage/repos/savapage-make/target/*.bin) /opt/savapage/savapage-setup.bin
RUN cd /opt/savapage && sudo -u savapage sh savapage-setup.bin -i -n -v
RUN /opt/savapage/MUST-RUN-AS-ROOT

RUN rm -Rf /root/savapage
RUN apt-get purge -y -o Dpkg::Options::="--force-confold" \ 
    maven \
    g++ \
    make \
    pkg-config \
    zip \
    pgpgpg \
    libpcsclite-dev \
    libcups2-dev \
    libpam0g-dev \
    git

COPY bin/ /usr/local/bin/
COPY template/ /template/
COPY etc/ /etc/

RUN cp -rp /etc/cups /etc/cups-skel
RUN cp -rp /usr/lib/cups /usr/lib/cups-skel

RUN rm /opt/savapage/server/admin.properties
RUN cp /template/admin.properties /opt/savapage/server/admin.properties

RUN rm /opt/savapage/server/server.properties
RUN cp /template/server.properties /opt/savapage/server/server.properties

RUN mv /opt/savapage/server /opt/savapage/serverBuiltin
RUN mkdir /opt/savapage/server

COPY entrypoint.sh /entrypoint.sh
