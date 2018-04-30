FROM python:slim-stretch

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
	&& apt-get update \
	&& apt-get install -y --no-install-recommends build-essential git \
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
	&& chown -R www-data:www-data $DJANGO_STATICS \
	&& deactivate \
	&& apt-get remove --purge -y build-essential git \
	&& apt-get autoremove --purge -y \
	&& rm -rf /var/lib/apt/lists/*

VOLUME /data
VOLUME /var/www/static

COPY ./confs/uwsgi.ini etesync.ini
COPY ./confs/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
