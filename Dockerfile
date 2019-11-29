FROM node:10.15.0-alpine

ARG WORKDIR=/home/node/app/

ARG NPM_REGISTRY
ARG NPM_TOKEN
ARG GIT_BRANCH
ARG GIT_SHA1
ARG PACKAGE_VERSION

ENV PORT 3000
ENV APPLICATION_NAME fit-finder-v3-app
ENV PACKAGE_VERSION ${PACKAGE_VERSION}
ENV ENVIRONMENT ''

LABEL git.branch=${GIT_BRANCH}
LABEL git.sha1=${GIT_SHA1}
LABEL com.thirdlove.app.name=${APPLICATION_NAME}
LABEL com.thirdlove.app.version=${PACKAGE_VERSION}

WORKDIR ${WORKDIR}

COPY package*.json ${WORKDIR}
COPY .npmrc ${WORKDIR}

RUN echo "//${NPM_REGISTRY}/:_authToken=\"${NPM_TOKEN}\"" >> .npmrc \
    && npm ci --loglevel=error

COPY . ${WORKDIR}

RUN npm run build

EXPOSE $PORT

CMD ["npm", "start"]
