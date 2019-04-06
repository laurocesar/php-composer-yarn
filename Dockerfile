FROM php:7.3-cli-alpine3.9

MAINTAINER Lauro César <laurocesar@gmail.com>

# Configure and install php dependentes

RUN apk --no-cache add --virtual .composer-rundeps git openssh tini bash patch make zip unzip nodejs nodejs-npm

RUN apk add --no-cache --virtual .build-deps zlib-dev libzip-dev \
 && docker-php-ext-configure zip --with-libzip \
 && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip \
 && runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
    | tr ',' '\n' \
    | sort -u \
    | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
 && apk add --virtual .composer-phpext-rundeps $runDeps \
 && apk del .build-deps

# Install composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.8.4

RUN curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer \
 && php -r " \
    \$signature = '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5'; \
    \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
 && composer --ansi --version --no-interaction \
 && rm -f /tmp/installer.php

# Install node npm yarn
RUN apk --no-cache add --update nodejs nodejs-npm
RUN npm install -g yarn
RUN apk del .build-dependencies  
  
WORKDIR /app

VOLUME [ "/app" ]