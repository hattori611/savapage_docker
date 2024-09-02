#!/bin/bash
# vim: set ts=4 sts=4 sw=4 et:

DB_NAME="${DB_NAME:-empty}"
DB_USER="${DB_USER:-empty}"
DB_PASSWORD="${DB_PASSWORD:-empty}"

DEFAULT_LOCALE="${DEFAULT_LOCALE:-}"
DEFAULT_PAPERSIZE="${DEFAULT_PAPERSIZE:-}"
GLOBAL_CURRENCYCODE="${GLOBAL_CURRENCYCODE:-}"
AUTH_METHOD="${AUTH_METHOD:-}"
AUTH_LDAP_SCHEMA_TYPE="${AUTH_LDAP_SCHEMA_TYPE:-}"
AUTH_LDAP_ADMIN="${AUTH_LDAP_ADMIN:-}"
AUTH_LDAP_PASSWORD="${AUTH_LDAP_PASSWORD:-}"
AUTH_LDAP_SERVER="${AUTH_LDAP_SERVER:-}"
AUTH_LDAP_BASEDN="${AUTH_LDAP_BASEDN:-}"
AUTH_LDAP_PORT="${AUTH_LDAP_PORT:-}"
AUTH_LDAP_USESSL="${AUTH_LDAP_USESSL:-}"
AUTH_LDAP_SSL_HOSTNAME_VERIFICATION_DISABLE="${AUTH_LDAP_SSL_HOSTNAME_VERIFICATION_DISABLE:-}"
AUTH_LDAP_TRUST_SELFSIGNED_CERT="${AUTH_LDAP_TRUST_SELFSIGNED_CERT:-}"
MAIL_SMTP_HOST="${MAIL_SMTP_HOST:-}"
MAIL_SMTP_PORT="${MAIL_SMTP_PORT:-}"
MAIL_SMTP_USERNAME="${MAIL_SMTP_USERNAME:-}"
MAIL_SMTP_PASSWORD="${MAIL_SMTP_PASSWORD:-}"
MAIL_SMTP_MAILFROM_ADRESS="${MAIL_SMTP_MAILFROM_ADRESS:-}"
MAIL_SMTP_SECURITY="${MAIL_SMTP_SECURITY:-}"
SAVAPAGE_USER_PW="${SAVAPAGE_USER_PW:-}"
SAVAPAGE_URL="${SAVAPAGE_URL:-}"
SAVAPAGE_UUID="${SAVAPAGE_UUID:-}"

LDAP_RADIUS_ACCESS_GROUP="${LDAP_RADIUS_ACCESS_GROUP:-}"
RADIUS_CLIENT_CREDENTIALS="${RADIUS_CLIENT_CREDENTIALS:-}"

## to turn on debugging, use "-x -f -l stdout"
#RADIUSD_ARGS="${RADIUSD_ARGS:--f -l stdout}"
#
server.properties_subst() {
    sed -i -e "s/${1}/${2}/g" /opt/savapage/serverBuiltin/server.properties
}
#
#mschap_subst() {
#    sed -i -e "s/${1}/${2}/g" /etc/raddb/mods-available/mschap
#}
#
#krb5_subst() {
#    sed -i -e "s/${1}/${2}/g" /etc/krb5.conf
#}
#
#samba_subst() {
#    sed -i -e "s/${1}/${2}/g" /etc/samba/smb.conf
#}

#cups_subst() {
#echo "cups subst"
#}

## substitute variables into LDAP configuration file

persistantFiles="admin.properties jmxremote.access jmxremote.ks jmxremote.password jmxremote.properties"
persistantFolders="custom data examples ext lib logs tmp"
staticFolders="bin"
staticFiles="server.properties"

for file in $persistantFiles
do
    if [ ! -f /opt/savapage/server/$file ]; then
    cp /opt/savapage/serverBuiltin/$file /opt/savapage/server/$file
    fi
done

for folder in $persistantFolders
do
    if [ ! -f /opt/savapage/server/$folder ]; then
    cp -R /opt/savapage/serverBuiltin/$folder /opt/savapage/server/$folder
    fi
done

for file in $staticFiles
do
    if [ ! -e /opt/savapage/server/$file ]; then
    ln -s /opt/savapage/serverBuiltin/$file /opt/savapage/server/$file
    fi
done

for folder in $staticFolders
do
    if [ ! -e /opt/savapage/server/$folder ]; then
    ln -s /opt/savapage/serverBuiltin/$folder /opt/savapage/server/$folder
    fi
done


if [ ! -f /etc/cups/cupsd.conf ]; then
	  cp -rpn /etc/cups-skel/* /etc/cups/
fi

if [ ! -d /usr/lib/cups/filter ]; then
	  cp -rpn /usr/lib/cups-skel/* /usr/lib/cups/
fi

# Save encryption file
echo "save encryption file to server directory"
if [ ! -f /opt/savapage/server/$file ]; then
    echo "encryption file does not exist! copy to directory"
    mv /opt/savapage/serverBuiltin/data/encryption.properties /opt/savapage/server/data/encryption.properties
fi

rm /opt/savapage/serverBuiltin/data/encryption.properties
ln -s /opt/savapage/server/data/encryption.properties /opt/savapage/serverBuiltin/data/encryption.properties

# set savapage posix password
echo -e "$SAVAPAGE_USER_PW\n$SAVAPAGE_USER_PW" | passwd savapage

server.properties_subst "@DB_NAME@" "${DB_NAME}"
server.properties_subst "@DB_USER@" "${DB_USER}"
server.properties_subst "@DB_PASSWORD@" "${DB_PASSWORD}"

mv /opt/savapage/server/bin/linux-x64/app-server /opt/savapage/server/bin/linux-x64/app-server-daemon
cp /template/app-server_interactive /opt/savapage/server/bin/linux-x64/app-server

chown -R savapage /opt/savapage
chmod +x /opt/savapage/server/bin/linux-x64/app-server


echo "check database"
sudo -u savapage /opt/savapage/server/bin/linux-x64/savapage-db --db-check

if [ $? == 9 ]; then
    # initiate database
    echo "Initiate database"
    sudo -u savapage /opt/savapage/server/bin/linux-x64/savapage-db --db-init
fi


echo "start daemon for setting changes"
/opt/savapage/server/bin/linux-x64/app-server-daemon start &


until /opt/savapage/server/bin/linux-x64/savapage-cmd --get-config-property --name system.default-locale
do
  echo "savapage service not ready yet"
  sleep 1
done

echo "savapage service is ready now"

# overwrite settings defined in docker-compose
# local settings
echo "set system.default-locale"
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name system.default-locale --value $DEFAULT_LOCALE

# ldap settings
echo "set auth.method"
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name auth.method --value $AUTH_METHOD
echo "set ldap.schema.type"
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name ldap.schema.type --value $AUTH_LDAP_SCHEMA_TYPE
echo "set auth.ldap.host"
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name auth.ldap.host --value $AUTH_LDAP_SERVER
echo "set auth.ldap.admin-dn"
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name auth.ldap.admin-dn --value $AUTH_LDAP_ADMIN
echo "set auth.ldap.admin-password"
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name auth.ldap.admin-password --value $AUTH_LDAP_PASSWORD
echo "set auth.ldap.basedn"
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name auth.ldap.basedn --value $AUTH_LDAP_BASEDN
echo "set auth.ldap.port"
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name auth.ldap.port --value $AUTH_LDAP_PORT
echo "set auth.ldap.use-ssl "
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name auth.ldap.use-ssl --value $AUTH_LDAP_USESSL
echo "set auth.ldap.ssl.hostname-verification-disable"
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name auth.ldap.ssl.hostname-verification-disable --value $AUTH_LDAP_SSL_HOSTNAME_VERIFICATION_DISABLE
echo "set auth.ldap.use-ssl.trust-self-signed "
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name auth.ldap.use-ssl.trust-self-signed  --value $AUTH_LDAP_TRUST_SELFSIGNED_CERT
#echo "set ldap.schema.nested-group-search"
#/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name ldap.schema.nested-group-search  --value '(&(memberOf={0})(objectCategory=group))'

# mail settings
echo "set mail.smtp.host"
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name mail.smtp.host --value $MAIL_SMTP_HOST
#/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name mail.smtp.port --value $MAIL_SMTP_PORT
echo "set mail.smtp.username "
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name mail.smtp.username --value $MAIL_SMTP_USERNAME
echo "set mail.smtp.password "
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name mail.smtp.password --value $MAIL_SMTP_PASSWORD
echo "set mail.from.address"
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name mail.from.address --value $MAIL_SMTP_MAILFROM_ADRESS
#/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name mail.smtp.security --value $MAIL_SMTP_SECURITY

echo "sync users and groups"
/opt/savapage/server/bin/linux-x64/savapage-cmd --sync-users-and-groups

# using database tool directly because of permission problems
echo "set web-print.enable"
export PGPASSWORD=$DB_PASSWORD
#/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name web-print.enable --value Y
psql -h db -U savapage  -c "UPDATE tbl_config SET property_value = 'Y'  WHERE property_name = 'web-print.enable';"
echo "set system.default-papersize"
psql -h db -U savapage  -c "UPDATE tbl_config SET property_value = '$DEFAULT_PAPERSIZE'  WHERE property_name = 'system.default-papersize';"
echo "set financial.global.currency-code"
#/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name financial.global.currency-code --value $GLOBAL_CURRENCYCODE
psql -h db -U savapage  -c "UPDATE tbl_config SET property_value = '$GLOBAL_CURRENCYCODE'  WHERE property_name = 'financial.global.currency-code';"


#/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name system.default-papersize --value $DEFAULT_PAPERSIZE
#system.default-papersize

echo "stop daemon after setting changes"
until /opt/savapage/server/bin/linux-x64/savapage-cmd --get-config-property --name system.default-locale
do
  echo "savapage service not ready yet"
  sleep 1
done
/opt/savapage/server/bin/linux-x64/app-server-daemon stop

# # Save encryption file
# echo "save encryption file to server directory"
# if [ ! -f /opt/savapage/server/$file ]; then
#     echo "encryption file does not exist! copy to directory"
#     mv /opt/savapage/serverBuiltin/data/encryption.properties /opt/savapage/server/data/encryption.properties
# fi

# rm /opt/savapage/serverBuiltin/data/encryption.properties
# ln -s /opt/savapage/server/data/encryption.properties /opt/savapage/serverBuiltin/data/encryption.properties

sed -i "s/#SAVAPAGE_UUID#/$SAVAPAGE_UUID/g" /etc/avahi/services/savapage.service
sed -i "s/#SAVAPAGE_HOSTNAME#/$SAVAPAGE_HOSTNAME/g" /etc/avahi/services/savapage.service

#run cups in nondemand mode
/usr/sbin/cupsd -f &
#exec /usr/local/bin/tini -- /usr/sbin/cupsd -f

# start dbus and avahi
service dbus start
service avahi-daemon start

cat <<EOF > /tmp/syncAfterStart.sh
#!/bin/bash
sleep 10
/opt/savapage/server/bin/linux-x64/savapage-cmd --set-config-property --name auth.ldap.admin-password --value $AUTH_LDAP_PASSWORD
EOF

bash /tmp/syncAfterStart.sh &

echo "preparing container finished, starting savapage app-server"
exec /usr/local/bin/tini -- /opt/savapage/server/bin/linux-x64/app-server-daemon start