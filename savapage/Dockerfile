FROM ubuntu:focal
LABEL Maintainer "Andreas Till <andreas.till@netzint.de>"

ENTRYPOINT [ "/init" ]

ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


#Install Requirements
RUN apt-get update


# Install requirements
RUN apt-get install -y -o Dpkg::Options::="--force-confold" \ 
        curl \
        sudo \
        openjdk-8-jdk \
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
        vim \
        python3-psycopg2 \ 
        foomatic-db-compressed-ppds \
        printer-driver-all \
        openprinting-ppds \
        hpijs-ppds \
        hp-ppd \
        hplip \
        printer-driver-cups-pdf


# install savapage
RUN mkdir -p /opt/savapage
RUN useradd  -r savapage -d /opt/savapage -s /bin/bash
RUN usermod -a -G lpadmin savapage
RUN curl https://www.savapage.org/download/snapshots/savapage-setup-1.3.0-rc-linux-x64.bin -o /opt/savapage/savapage-setup-1.3.0-rc-linux-x64.bin
RUN chown -R savapage /opt/savapage
RUN cd /opt/savapage && sudo -u savapage sh savapage-setup-1.3.0-rc-linux-x64.bin -i -n -v
RUN /opt/savapage/MUST-RUN-AS-ROOT


# copy config files after installation
#COPY raddb/ /etc/raddb/
COPY bin/ /usr/local/bin/
COPY template/ /template/
#COPY etc/ /etc/
#COPY krb5.conf /etc/krb5.conf
#COPY nsswitch.conf /etc/nsswitch.conf

# copy /etc/cups for skeleton usage
RUN cp -rp /etc/cups /etc/cups-skel

# go trough static templates
RUN rm /opt/savapage/server/admin.properties
RUN cp /template/admin.properties /opt/savapage/server/admin.properties

RUN rm /opt/savapage/server/server.properties
RUN cp /template/server.properties /opt/savapage/server/server.properties


# prepare splitting config and binarys
RUN mv /opt/savapage/server /opt/savapage/serverBuiltin
RUN mkdir /opt/savapage/server 


# Install tiniT init
#ENV TINI_VERSION v0.10.0
#RUN curl -L https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini > /usr/bin/tini \
#        && chmod +x /usr/bin/tini
#
COPY init /
