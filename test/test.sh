#/bin/bash

printf "#!/bin/bash \
\nREPOS_GIT_PUBLIC=\"savapage/savapage-client \
\nsavapage/savapage-common \
\nsavapage/savapage-core \
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
\nsavapage/xmlrpcpp\" \
\nfor repo in \$_REPOS_GIT_PUBLIC \
\ndo \
\ngit clone https://gitlab.com/\${repo}.git \
\ndone" > init.sh

