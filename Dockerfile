FROM python:2.7-slim

LABEL maintainer "sven@so36.net"

ENV GOSU_VERSION=1.10

RUN useradd plone -d /usr/local/plone -s /bin/bash \
	&& mkdir -p /usr/local/plone \
	&& chown -R plone:plone /usr/local/plone \
	&& mkdir -p /data/filestorage /data/blobstorage \
	&& chown -R plone:plone /data


WORKDIR /usr/local/plone
COPY plone-build.sh /usr/local/plone/
RUN ./plone-build.sh && rm plone-build.sh

COPY plone-entrypoint.sh docker-entrypoint.sh /usr/local/plone/
VOLUME ["/data", "/data/log"]


EXPOSE 8080
#ENTRYPOINT ["bash"]
ENTRYPOINT ["/usr/local/plone/docker-entrypoint.sh"]
CMD ["start"]
