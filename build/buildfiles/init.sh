#!/bin/bash
_REPOS_GIT_PUBLIC="savapage/savapage-client
     savapage/savapage-common
     savapage/savapage-core
     savapage/savapage-cups-notifier
     savapage/savapage-ext
     savapage-ext/savapage-ext-blockchain-info
     savapage-ext/savapage-ext-mollie
     savapage-ext/savapage-ext-notification
     savapage-ext/savapage-ext-oauth
     savapage-i18n/savapage-i18n-de
     savapage-i18n/savapage-i18n-en
     savapage-i18n/savapage-i18n-es
     savapage-i18n/savapage-i18n-fr
     savapage-i18n/savapage-i18n-nl
     savapage-i18n/savapage-i18n-pl
     savapage-i18n/savapage-i18n-ru
     savapage/savapage-server
     savapage/savapage-make
     savapage/savapage-nfc-reader
     savapage/savapage-nss
     savapage/savapage-pam
     savapage/savapage-ppd
     savapage/savapage-util
     savapage/xmlrpcpp"
for repo in $_REPOS_GIT_PUBLIC
do
     git clone https://gitlab.com/${repo}.git
done

sed -i 's/VISITOR_PERIOD_DAYS = 40/VISITOR_PERIOD_DAYS = 40000/g' /opt/build/savapage/repos/savapage-core/src/main/java/org/savapage/core/community/MemberCard.java
sed -i 's/return 5;/return 50000;/g' /opt/build/savapage/repos/savapage-core/src/main/java/org/savapage/core/community/MemberCard.java
