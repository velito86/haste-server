FROM node:14.8.0-stretch

RUN mkdir -p /usr/src/app && \
    chown node:node /usr/src/app

USER node:node

WORKDIR /usr/src/app

COPY --chown=node:node . .

RUN npm install && \
    npm install pg@latest

ENV STORAGE_TYPE=postgres \
    STORAGE_HOST=localhost \
    STORAGE_PORT=5432 \
    STORAGE_EXPIRE_SECONDS=2592000\
    STORAGE_DB=hastedb \
    STORAGE_USERNAME=postgres \
    STORAGE_PASSWORD=postgres 

ENV LOGGING_LEVEL=verbose \
    LOGGING_TYPE=Console \
    LOGGING_COLORIZE=true

ENV HOST=0.0.0.0\
    PORT=7777\
    KEY_LENGTH=10\
    MAX_LENGTH=400000\
    STATIC_MAX_AGE=86400\
    RECOMPRESS_STATIC_ASSETS=true

ENV DOCUMENTS=about=./about.md

EXPOSE ${PORT}
STOPSIGNAL SIGINT
ENTRYPOINT [ "bash", "docker-entrypoint.sh" ]

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s \
    --retries=3 CMD [ "curl" , "-f" "localhost:${PORT}", "||", "exit", "1"]
CMD ["npm", "start"]
