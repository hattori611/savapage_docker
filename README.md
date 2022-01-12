# Netzint Savapage Docker

## Introduction
This is a Docker Container based on <https://www.savapage.org/>. For any informations about this product read the official manuel <https://www.savapage.org/docs/manual/>.

## Environment Variables
The following environment variables yout can change and edit for your requirements:

* `DEFAULT_LOCALE` - default laguage of user interface, default: de-DE
* `DEFAULT_PAPERSIZE` - default papersize, default: iso-a4
* `GLOBAL_CURRENCYCODE` - default currency, default: EUR
* `AUTH_METHOD` - auth method, default: ldap
* `AUTH_LDAP_SCHEMA_TYPE` - ldap schema, default: ACTIVE_DIRECTORY
* `AUTH_LDAP_ADMIN` - ldap binduser dn
* `AUTH_LDAP_PASSWORD` - ldap binduser password
* `AUTH_LDAP_SERVER` - ldap host
* `AUTH_LDAP_BASEDN` - ldap base dn
* `AUTH_LDAP_PORT` - ldap port, 389 or 636
* `AUTH_LDAP_USESSL` - use ssl for ldap? 389 = n, 636 = y
* `AUTH_LDAP_SSL_HOSTNAME_VERIFICATION_DISABLE` - verify ldap hostname
* `AUTH_LDAP_TRUST_SELFSIGNED_CERT` - verify ldap certificate
* `MAIL_SMTP_HOST` - mailserver host, not required
* `MAIL_SMTP_PORT` - mailserver port, not required
* `MAIL_SMTP_USERNAME` - mailserver username, not required
* `MAIL_SMTP_PASSWORD` - mailserver password, not required
* `MAIL_SMTP_MAILFROM_ADRESS` - mailserver from address, not required
* `MAIL_SMTP_SECURITY` - mailserver security, not required
* `SAVAPAGE_USER_PW` - savapage admin user
* `SAVAPAGE_HOSTNAME` - savapage ip address, required for airprint!

## Install

1. Clone repository to your docker host
```
mkdir -p /srv/docker/
cd /srv/docker
git clone https://github.com/netzint/savapage_docker.git
```
2. Plan the ips for your system. **This docker container _has an own ip_ in the network of your docker host!**
3. Go to the new directory and copy and edit the `savapage.env` file
```
cd savapage_docker

cp savapage.env.example savapage.env
nano savapage.env
```
4. Copy and edit the `docker-compose.override.yml` and set the ip, hostname, domainname and interface settings
```
cp docker-compose.override.yml.example docker-compose.override.yml
nano docker-compose.override.yml
```
5. Start the savapage docker and check for errors
```
docker-compose up
```
6. If no errors occours, you can stop and remove the docker
```
docker-compose down
docker-compose rm
```
7. Copy `savapage.service` to systemd and enable and start the docker
```
cp templates/savapage.service /etc/systemd/system/savapage.service
systemctl enable savapage
systemctl start savapage
```
