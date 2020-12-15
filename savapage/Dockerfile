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
        #vim \
        postgresql-client \
        python3-psycopg2 \ 
        foomatic-db-compressed-ppds \
        printer-driver-all \
        openprinting-ppds \
        hpijs-ppds \
        hp-ppd \
        hplip \
        printer-driver-cups-pdf



# build savapage
RUN apt-get update
RUN apt-get install -y -o Dpkg::Options::="--force-confold" \ 
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



RUN mkdir -p ~/savapage/repos

RUN printf "#!/bin/bash \
\n_REPOS_GIT_PUBLIC=\"savapage/savapage-client \
\nsavapage/savapage-common \
\nsavapage/savapage-cups-notifier \
\nsavapage/savapage-ext \
\nsavapage-ext/savapage-ext-blockchain-info \
\nsavapage-ext/savapage-ext-mollie \
\nsavapage-ext/savapage-ext-notification \
\nsavapage-ext/savapage-ext-oauth \
\nsavapage-i18n/savapage-i18n-de \
\nsavapage-i18n/savapage-i18n-en \
\nsavapage-i18n/savapage-i18n-es \
\nsavapage-i18n/savapage-i18n-fr \
\nsavapage-i18n/savapage-i18n-nl \
\nsavapage-i18n/savapage-i18n-pl \
\nsavapage-i18n/savapage-i18n-ru \
\nsavapage/savapage-make \
\nsavapage/savapage-nfc-reader \
\nsavapage/savapage-nss \
\nsavapage/savapage-pam \
\nsavapage/savapage-ppd \
\nsavapage/savapage-util \
\nsavapage/xmlrpcpp \
\nsavapage/savapage-server\" \
\nfor repo in \$_REPOS_GIT_PUBLIC \
\ndo \
\ngit clone https://gitlab.com/\${repo}.git \
\ndone" > ~/savapage/repos/init.sh

#\nsavapage/savapage-core \

#RUN git clone https://github.com/PLanB2008/savapage-server.git ~/savapage/repos/savapage-server
RUN git clone https://github.com/PLanB2008/savapage-core.git ~/savapage/repos/savapage-core


RUN chmod +x ~/savapage/repos/init.sh
RUN cd ~/savapage/repos/ && ~/savapage/repos/init.sh
RUN cd ~/savapage/repos/savapage-make && git checkout master && ./dev-git-all.sh "checkout master"
RUN cd ~/savapage && ./repos/savapage-make/dev-init.sh
RUN cd ~/savapage/repos/savapage-make && ./build.sh all-x64


# install savapage
RUN mkdir -p /opt/savapage
RUN useradd  -r savapage -d /opt/savapage -s /bin/bash
RUN usermod -a -G lpadmin savapage
#RUN curl https://www.savapage.org/download/snapshots/savapage-setup-1.3.0-rc-linux-x64.bin -o /opt/savapage/savapage-setup-1.3.0-rc-linux-x64.bin
RUN chown -R savapage /opt/savapage
RUN mv /root/savapage/repos/savapage-make/target/savapage-setup-1.3.0-rc-linux-x64.bin /opt/savapage/
RUN cd /opt/savapage && sudo -u savapage sh savapage-setup-1.3.0-rc-linux-x64.bin -i -n -v
RUN /opt/savapage/MUST-RUN-AS-ROOT


# clean Up

RUN rm -Rf ~/savapage
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

# copy config files after installation
COPY bin/ /usr/local/bin/
COPY template/ /template/
COPY etc/ /etc/

# copy /etc/cups for skeleton usage
RUN cp -rp /etc/cups /etc/cups-skel

RUN cp -rp /usr/lib/cups /usr/lib/cups-skel


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
