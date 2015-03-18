FROM java:7-jre
MAINTAINER Cameron Smith <cameronraysmith@gmail.com>

RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

ENV ELASTICSEARCH_VERSION 1.4.2
ENV ELASTICSEARCH_MAPPER_VERSION 2.4.3
ENV ELASTICSEARCH_RIVER_MONGODB_VERSION 2.0.5

RUN echo "deb http://packages.elasticsearch.org/elasticsearch/${ELASTICSEARCH_VERSION%.*}/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list

RUN apt-get update \
  && apt-get install elasticsearch=$ELASTICSEARCH_VERSION \
  && rm -rf /var/lib/apt/lists/*

ENV PATH /usr/share/elasticsearch/bin:$PATH
COPY config /usr/share/elasticsearch/config

RUN cd /usr/share/elasticsearch/ && \
    ./bin/plugin --install elasticsearch/elasticsearch-mapper-attachments/${ELASTICSEARCH_MAPPER_VERSION} && \
    ./bin/plugin --install com.github.richardwilly98.elasticsearch/elasticsearch-river-mongodb/${ELASTICSEARCH_RIVER_MONGODB_VERSION} && \
    ./bin/plugin --install mobz/elasticsearch-head

VOLUME /usr/share/elasticsearch/data

EXPOSE 9200 9300

CMD ["elasticsearch"]
