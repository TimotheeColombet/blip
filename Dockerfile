FROM node:6.10.3-alpine

WORKDIR /app

COPY package.json package.json

RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk add --no-cache fontconfig && \
    apk add --no-cache --virtual .build-dependencies curl git && \
    curl -Ls "https://github.com/tidepool-org/tools/raw/master/alpine_phantomjs_dependencies/dockerized-phantomjs.tar.xz" | tar xJ -C / && \
    mkdir -p dist node_modules /@tidepool/viz/node_modules /tideline/node_modules /tidepool-platform-client/node_modules && \
    chown -R node:node . /@tidepool /tideline /tidepool-platform-client && \
    apk del .build-dependencies && \
    rm -rf /usr/share/man /tmp/* /var/tmp/* /root/.npm /root/.node-gyp

USER node

RUN yarn install && \
    yarn cache clean

COPY . .

VOLUME /app

CMD ["npm", "start"]
