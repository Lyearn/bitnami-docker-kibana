FROM docker.io/amd64/centos:centos7


LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
  OS_ARCH="amd64" \
  OS_FLAVOUR="debian-10" \
  OS_NAME="linux" \
  PATH="/opt/bitnami/common/bin:/opt/bitnami/kibana/bin:$PATH"

RUN yum update -y
COPY prebuildfs /
# Install required system packages and dependencies
# RUN install_packages acl ca-certificates curl gzip libc6 libexpat1 libgcc1 libnss3 libstdc++6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.16.2-2" --checksum 1c135708aaa8cb69936471de63563de08e97b7d0bfb4126d41b54a149557c5c0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-1" --checksum 16f1a317859b06ae82e816b30f98f28b4707d18fe6cc3881bff535192a7715dc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kibana" "7.14.2-0" --checksum 9adcb2f7b24321388f63d248a68016ff3241298257d25b00708a567ce13d0dbf

# RUN apt-get update && apt-get upgrade -y && \
#   rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/kibana/postunpack.sh
ENV BITNAMI_APP_NAME="kibana" \
  BITNAMI_IMAGE_VERSION="7.14.2-debian-10-r24"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kibana/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kibana/run.sh" ]
