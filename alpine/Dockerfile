FROM python:alpine3.7

EXPOSE 8000

ENV DATA_PATH=/data \
	ETESYNC_PATH=/server-skeleton

ENV DJANGO_DB_PATH=$DATA_PATH/db.sqlite3 \
	DJANGO_SECRET=$DATA_PATH/secret.txt \
	DJANGO_STATICS=/var/www/static \
	DJANGO_PORT=8000 \
	SERVER="standalone"
	
RUN set -e \
	&& mkdir -p $DATA_PATH \
	&& apk add --no-cache --virtual .build-deps coreutils gcc make linux-headers libc-dev git \
	&& pip install virtualenv uwsgi \
	&& git clone https://github.com/etesync/server-skeleton.git

WORKDIR /server-skeleton
COPY ./confs/settings.py ./etesync_server/settings.py	

RUN set -e \
	&& virtualenv $ETESYNC_PATH/.venv \
	&& . $ETESYNC_PATH/.venv/bin/activate \
	&& pip install -r requirements.txt \
	&& mkdir -p $DJANGO_STATICS \
	&& cd $DJANGO_STATICS \
	&& $ETESYNC_PATH/manage.py collectstatic --no-input \
	&& chown -R 33:33 $DJANGO_STATICS \
	&& deactivate \
	&& apk del .build-deps

VOLUME /data
VOLUME /var/www/static
	
COPY ./confs/uwsgi.ini etesync.ini
COPY ./confs/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
