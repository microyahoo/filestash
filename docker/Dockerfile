FROM reg.deeproute.ai/deeproute-public/filestash-base:latest
MAINTAINER deeprouter

ENV DEBIAN_FRONTEND noninteractive

ARG binary=./dist/filestash
COPY ${binary} /app/filestash

RUN useradd filestash && \
   chown -R filestash:filestash /app/ && \
   rm -rf /var/lib/apt/lists/* && \
   rm -rf /tmp/*

USER filestash
RUN timeout 1 /app/filestash | grep -q start && \
    rm /app/data/state/config/config.json

EXPOSE 8334
VOLUME ["/app/data/state/"]
WORKDIR "/app"
CMD ["/app/filestash"]
