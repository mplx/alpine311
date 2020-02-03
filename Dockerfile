ARG VERSION=3.11
FROM alpine:${VERSION}
LABEL maintainer="gmi-edv@i-med.ac.at"

ARG VERSION
ARG ALPINE_MIRROR_BASE="http://dl-cdn.alpinelinux.org"
ARG TZ="Europe/Vienna"

ENV TZ=${TZ}

RUN set -xe &&\
  echo $TZ > /etc/TZ &&\
  ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
  echo "${ALPINE_MIRROR_BASE}/alpine/v${VERSION}/main" > /etc/apk/repositories && \
  echo "${ALPINE_MIRROR_BASE}/alpine/v${VERSION}/community" >> /etc/apk/repositories && \
  apk update && \
  apk --no-cache --update upgrade && \
  apk add --no-cache --update bash ca-certificates curl git jq nano openssl tzdata && \
  rm -rf /var/cache/apk/* && \
  apk update

# The apk update command is run to ensure that the local package index is working.
# Otherwise, apk commands emit warnings and the apk policy command fails.

# Install certificates bundle
ADD TLS_CA_FILE /usr/local/share/ca-certificates/ca_bundle.crt
RUN set -xe &&\
  update-ca-certificates

# Add build info
ADD ALPINE_BUILD /
