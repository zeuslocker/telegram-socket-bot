# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.155.1/containers/javascript-node/.devcontainer/base.Dockerfile

# [Choice] Node.js version: 14, 12, 10
# ARG VARIANT="14-buster"
# FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-${VARIANT}
FROM node:15.8.0-alpine3.10

# Add v3.9 package repositories to get mongodb
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/main' >> /etc/apk/repositories && \
    echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories

ENV NODE_ENV production

# [Optional] Uncomment this section to install additional OS packages.
RUN apk update \
    && apk add git \
    && apk add dumb-init

# Use system binaries for Mongo Memory Server
RUN apk add mongodb=4.0.5-r0 || true
ENV MONGOMS_SYSTEM_BINARY="/usr/bin/mongod"



CMD ["node", "build/index.js"]


FROM node:16.17.0-bullseye-slim
RUN apt-get update && apt-get install -y --no-install-recommends dumb-init
ENV NODE_ENV production
WORKDIR /app
COPY --chown=node:node . .
RUN npm ci --only=production
USER node
CMD ["dumb-init", "node", "/app/build/index.js"]