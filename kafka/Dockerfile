# OpenJDK base image
FROM openjdk:17-slim

# Environment options
ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.13
ENV KAFKA_VERSION 3.3.1
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"
ENV PATH="${KAFKA_HOME}/bin:${PATH}"

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget supervisor dnsutils vim nano && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Install Kafka
RUN wget -q https://archive.apache.org/dist/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
    rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

# Start Kafka
COPY scripts/start-kafka.sh /usr/bin/start-kafka.sh

# Kafka config
RUN \
    sed -i "s|#delete.topic.enable|delete.topic.enable|g" "$KAFKA_HOME"/config/kraft/server.properties

# Supervisor config
COPY supervisor/kafka.conf /etc/supervisor/conf.d/

# 9092 is Kafka
EXPOSE 9092

# Start Supervisor
CMD ["supervisord", "-n"]

# Default directory for shell
WORKDIR $KAFKA_HOME
