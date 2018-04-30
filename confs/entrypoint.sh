#!/bin/sh

set -e

. $ETESYNC_PATH/.venv/bin/activate

if [ -z "$PUID" ]; then
	export PUID=33
fi

if [ -z "$PGID" ]; then
	export PGID=33
fi

if [ ! -z "$@" ]; then
    exec "$@"
fi

#if [ ! -e "${ETESYNC_SECRET}" ]; then
#    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 > ${ETESYNC_SECRET}
#fi

if [ ! -e "${ETESYNC_DB_PATH}" ]; then
    # first run
    $ETESYNC_PATH/manage.py migrate
fi

if [ "$SUPER_USER" -a "$SUPER_PASS" ]; then
	echo "from django.contrib.auth.models import User; User.objects.create_superuser('$SUPER_USER' , '$SUPER_EMAIL', '$SUPER_PASS')" | python manage.py shell
fi

if [ $SERVER = 'uwsgi' ]; then
	/usr/local/bin/uwsgi --ini etesync.ini
elif [ $SERVER = 'uwsgi-http' ]; then
	/usr/local/bin/uwsgi --ini etesync.ini:http
else
	$ETESYNC_PATH/manage.py runserver 0.0.0.0:$ETESYNC_PORT
fi
