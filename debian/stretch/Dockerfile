FROM python:stretch

EXPOSE 8000

ENV DATA_PATH=/data \
	ETESYNC_PATH=/etesync

ENV DJANGO_DB_PATH=$DATA_PATH/db.sqlite3 \
	DJANGO_SECRET=$DATA_PATH/secret.txt \
	DJANGO_STATICS=/var/www/static \
	DJANGO_PORT=8000 \
	SERVER="standalone"

WORKDIR $ETESYNC_PATH

RUN set -e \
	&& groupadd -r -g 1000 etesync \
	&& useradd -d /etesync -r -M -s /bin/sh -g 1000 -u 1000 etesync \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends build-essential git \
	&& git clone https://github.com/etesync/server-skeleton.git $ETESYNC_PATH \
	&& rm -rf $ETESYNC_PATH/.git \
	&& pip install -r $ETESYNC_PATH/requirements.txt uwsgi \
	&& apt-get remove --purge -y build-essential git \
	&& apt-get autoremove --purge -y \
	&& rm -rf /var/lib/apt/lists/*

COPY settings.py $ETESYNC_PATH/etesync_server/settings.py

RUN set -e \	
	&& mkdir -p $DATA_PATH \
	&& chown etesync:etesync $DATA_PATH \
	&& mkdir -p $DJANGO_STATICS \
	&& $ETESYNC_PATH/manage.py collectstatic --no-input \
	&& chown -R www-data:www-data $DJANGO_STATICS
	
VOLUME /data
VOLUME /var/www/static

COPY uwsgi.ini etesync.ini
COPY entrypoint.sh /

RUN set -e && chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
