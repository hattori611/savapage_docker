FROM ubuntu:focal as build
LABEL Developer "Andreas Till <andreas.till@netzint.de>"
LABEL Maintainer "Lukas Spitznagel <lukas.spitznagel@netzint.de>"

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

RUN mkdir -p /opt/build/savapage/repos

COPY buildfiles/init.sh /opt/build/savapage/repos/init.sh
RUN cd /opt/build/savapage/repos && ./init.sh
RUN rm /opt/build/savapage/repos/init.sh

RUN cd /opt/build/savapage/repos/savapage-make && \
    git checkout master && \
    ./dev-git-all.sh "checkout develop"

RUN cd /opt/build/savapage && \
    ./repos/savapage-make/dev-init.sh

#COPY buildfiles/savapage_core_pom.xml /opt/build/savapage/repos/savapage-core/pom.xml

RUN cd /opt/build/savapage/repos/savapage-make && \
    ./build.sh all-x64

RUN mkdir -p /opt/savapage
RUN mv $(ls /opt/build/savapage/repos/savapage-make/target/*.bin) /opt/savapage/savapage-setup.bin

############################################
#
# Running stage
#
############################################

FROM ubuntu:focal

ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y -o Dpkg::Options::="--force-confold" \
    default-jdk \
    cups \
    cups-bsd \
    poppler-utils \
    qpdf \
    wkhtmltopdf \
    librsvg2-bin \
    imagemagick \
    avahi-daemon \
    avahi-discover \
    libnss-mdns \
    binutils \
    sudo \
    postgresql-client \
    cpio


RUN useradd  -r savapage -d /opt/savapage -s /bin/bash
RUN usermod -a -G lpadmin savapage

RUN mkdir -p /opt/savapage
RUN chown -R savapage /opt/savapage

COPY --from=build /opt/savapage/savapage-setup.bin /opt/savapage/savapage-setup.bin

RUN cd /opt/savapage && sudo -u savapage sh savapage-setup.bin -i -n -v
RUN /opt/savapage/MUST-RUN-AS-ROOT

RUN rm -Rf /opt/build

COPY buildfiles/bin/ /usr/local/bin/
COPY buildfiles/template/ /template/
COPY buildfiles/etc/ /etc/

RUN cp -rp /etc/cups /etc/cups-skel
RUN cp -rp /usr/lib/cups /usr/lib/cups-skel

RUN rm /opt/savapage/server/admin.properties
RUN cp /template/admin.properties /opt/savapage/server/admin.properties

RUN rm /opt/savapage/server/server.properties
RUN cp /template/server.properties /opt/savapage/server/server.properties

RUN mv /opt/savapage/server /opt/savapage/serverBuiltin
RUN mkdir /opt/savapage/server

COPY buildfiles/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]