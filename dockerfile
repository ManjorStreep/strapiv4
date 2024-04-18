FROM node:20.12.2-alpine3.19

RUN apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash

EXPOSE 1337

RUN yarn global add @strapi/strapi@4.17.1

RUN mkdir /srv/app && chown 1000:1000 -R /srv/app

WORKDIR /srv/app

VOLUME /srv/app

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh /
    
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["yarn", "develop"]