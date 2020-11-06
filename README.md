Introduction
============

Savapage

Changelog

  # 2020.11.04
    - Initial

Environment Variables
=====================

- `DEFAULT_PAPERSIZE` - LDAP server hostname(s) (default: "ldap1.example.com ldap2.example.com")
- `AUTH_LDAP_SERVER` - LDAP ip address eg. 10.0.0.1
- `AUTH_LDAP_PORT` - LDAP server port (default: "389")
- `AUTH_LDAP_ADMIN` - LDAP server user (default: "cn=admin,dc=example,dc=com")
- `AUTH_LDAP_PASSWORD` - LDAP server password (default: "password")
- `AUTH_LDAP_BASEDN` - LDAP server Base DN (default: "dc=example,dc=com")
- `AUTH_METHOD` - none, unix, ldap
- `AUTH_LDAP_SCHEMA_TYPE` - ACTIVE_DIRECTORY or NOVELL_EDIRECTORY

- 




Example Docker Compose Configuration
====================================

    services:

      db:
        image: postgres
        restart: always
        environment:
          - "POSTGRES_USER=savapage"
          - "POSTGRES_PASSWORD=MusterSavapage"
          - "POSTGRES_DB=savapage"
        volumes:
          - './db-data:/var/lib/postgresql/data/'

      savapage:
        build: ./savapage
        container_name: savapage
        ports:
          - "8632:8632/tcp"
        environment:
          - "DEFAULT_PAPERSIZE=a4"
          - "DB_NAME=db"
          - "DB_USER=savapage"
          - "DB_PASSWORD=MusterSavapage"
          - "DEFAULT_LOCALE=de-DE"
          - "DEFAULT_PAPERSIZE=iso-a4"
          - "GLOBAL_CURRENCYCODE=EUR"
          - "AUTH_LDAP_ADMIN=cn=savapage-binduser,OU=Management,OU=GLOBAL,DC=schule,DC=lan"
          - "AUTH_LDAP_PASSWORD=Muster!"
          - "AUTH_LDAP_SERVER=server"
          - "AUTH_LDAP_BASEDN=DC=schule,DC=lan"
          - "AUTH_LDAP_PORT=389"
          - "AUTH_LDAP_USESSL=N"
          - "AUTH_LDAP_SSL_HOSTNAME_VERIFICATION_DISABLE=Y"
          - "AUTH_LDAP_TRUST_SELFSIGNED_CERT=Y"
          - "AUTH_LDAP_USE_NESTED_GROUPS=Y"
          - "MAIL_SMTP_HOST=server"
          - "MAIL_SMTP_PORT=465"
          - "MAIL_SMTP_USERNAME=savapage"
          - "MAIL_SMTP_PASSWORD=savapageMail"
          - "MAIL_SMTP_MAILFROM_ADRESS=savapage@schule.lan"
          - "MAIL_SMTP_SECURITY=ssl"
        volumes:
          - './server:/opt/savapage/server/'
        mem_limit: "1g"
        restart: "always"
        depends_on:
          - db

    volumes:
      server:
      db-data:

