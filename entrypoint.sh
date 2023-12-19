#!/bin/bash





wait_for_database() {
    timeout 60s /bin/sh -c "$(cat << EOF
        until echo 'Waiting for database ...' \
            && nc -z mariadb 3306 < /dev/null > /dev/null 2>&1 ; \
        do sleep 1 ; done
EOF
)"
}
wait_for_database



sed -i "s/^password = your-database-password-here/password = $MYSQL_USER_PASSWORD/" /etc/powergslb/powergslb.conf
sed -i "s/^host = 127.0.0.1/host = $MYSQL_HOSTNAME/" /etc/powergslb/powergslb.conf
sed -i "s/^port = 443/port = 80/" /etc/powergslb/powergslb.conf
sed -i "s/^ssl = True/ssl = False/"  /etc/powergslb/powergslb.conf
sed -i "s/^database = powergslb/database = $MYSQL_DATABASE/"  /etc/powergslb/powergslb.conf
sed -i "s/^user = powergslb/user = $MYSQL_USERNAME/" /etc/powergslb/powergslb.conf
#sed -i 's/^password = your-database-password-here/password = $MYSQL_USER_PASSWORD/' /etc/powergslb/powergslb.conf
#sed -i 's/\(\[database\]\s*host = \)host/\1$MYSQL_HOSTNAME/' /etc/powergslb/powergslb.conf

DATABASE_EXISTS="$(mysql -h "$MYSQL_HOSTNAME" -uroot -p"$MYSQL_ROOT_PASSWORD" \
            -sse "SELECT EXISTS(SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '$MYSQL_DATABASE')")"
if [ "$DATABASE_EXISTS" != "1" ]; then
    echo "Configuring the database and preparing database"

    # Use a dedicated user with the necessary privileges
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h "$MYSQL_HOSTNAME" -e "
CREATE DATABASE $MYSQL_DATABASE;
GRANT ALL ON $MYSQL_DATABASE.* TO '${MYSQL_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
USE $MYSQL_DATABASE;
source /usr/share/doc/powergslb-$VERSION/database/scheme.sql;
source /usr/share/doc/powergslb-$VERSION/database/data.sql;
"



else
            echo "MySQL database is already configured"
fi
cp /usr/share/doc/powergslb-pdns-$VERSION/pdns/pdns.conf /etc/pdns/pdns.conf

echo "Starting supervisord"
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
