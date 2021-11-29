FROM node:14.8.0-stretch

RUN mkdir -p /usr/src/app && \
    chown node:node /usr/src/app

USER node:node

WORKDIR /usr/src/app

COPY --chown=node:node . .

RUN npm install && \
    npm install pg@4.1.1

ENV STORAGE_TYPE=postgres \
    STORAGE_HOST=127.0.0.1 \
    STORAGE_PORT=11211\
    STORAGE_EXPIRE_SECONDS=2592000\
    STORAGE_DB=2 \
    STORAGE_USENAME=postgres \
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

ADD CreateDB.sql /docker-entrypoint-initdb.d/

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s \
    --retries=3 CMD [ "curl" , "-f" "localhost:${PORT}", "||", "exit", "1"]
CMD ["npm", "start"]
