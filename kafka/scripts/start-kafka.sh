#!/bin/sh

# Optional ENV variables:
# * ADVERTISED_LISTENERS: your local machine IP address (or docker machine IP)
# * INTER_BROKER_LISTENER_NAME: mame of a listener used for communication between brokers
# * LISTENER_SECURITY_PROTOCOL_MAP: map between listener names and security protocols
# * LOG_RETENTION_HOURS: the minimum age of a log file in hours to be eligible for deletion (default is 168, for 1 week)
# * LOG_RETENTION_BYTES: configure the size at which segments are pruned from the log, (default is 1073741824, for 1GB)
# * NUM_PARTITIONS: configure the default number of log partitions per topic
# * AUTO_CREATE_TOPICS: creates topics on first message to it

# add carriage return so appended properties don't end up appended to the end of the last line
echo "" >> $KAFKA_HOME/config/kraft/server.properties

if [[ ! -z "$ADVERTISED_LISTENERS" ]]; then
  echo "advertised listeners: ${ADVERTISED_LISTENERS}"
  sed -r -i "s@^#?advertised.listeners=.*@advertised.listeners=$ADVERTISED_LISTENERS@g" $KAFKA_HOME/config/kraft/server.properties
fi

if [[ ! -z "$INTER_BROKER_LISTENER_NAME" ]]; then
  echo "inter broker listener name: ${INTER_BROKER_LISTENER_NAME}"
  sed -r -i "s@^#?inter.broker.listener.name=.*@inter.broker.listener.name=$INTER_BROKER_LISTENER_NAME@g" $KAFKA_HOME/config/kraft/server.properties
fi

if [[ ! -z "$LISTENER_SECURITY_PROTOCOL_MAP" ]]; then
  echo "listener security protocol map: ${LISTENER_SECURITY_PROTOCOL_MAP}"
  sed -r -i "s@^#?listener.security.protocol.map=.*@listener.security.protocol.map=$LISTENER_SECURITY_PROTOCOL_MAP@g" $KAFKA_HOME/config/kraft/server.properties
fi

# Allow specification of log retention policies
if [ ! -z "$LOG_RETENTION_HOURS" ]; then
    echo "log retention hours: $LOG_RETENTION_HOURS"
    sed -r -i "s/(log.retention.hours)=(.*)/\1=$LOG_RETENTION_HOURS/g" $KAFKA_HOME/config/kraft/server.properties
fi
if [ ! -z "$LOG_RETENTION_BYTES" ]; then
    echo "log retention bytes: $LOG_RETENTION_BYTES"
    sed -r -i "s/#(log.retention.bytes)=(.*)/\1=$LOG_RETENTION_BYTES/g" $KAFKA_HOME/config/kraft/server.properties
fi

# Configure the default number of log partitions per topic
if [ ! -z "$NUM_PARTITIONS" ]; then
    echo "default number of partition: $NUM_PARTITIONS"
    sed -r -i "s/(num.partitions)=(.*)/\1=$NUM_PARTITIONS/g" $KAFKA_HOME/config/kraft/server.properties
fi

# Enable/disable auto creation of topics
if [ ! -z "$AUTO_CREATE_TOPICS" ]; then
    echo "auto.create.topics.enable: $AUTO_CREATE_TOPICS"
    echo "auto.create.topics.enable=$AUTO_CREATE_TOPICS" >> $KAFKA_HOME/config/kraft/server.properties
fi

uuid=$($KAFKA_HOME/bin/kafka-storage.sh random-uuid)
$KAFKA_HOME/bin/kafka-storage.sh format -t $uuid -c $KAFKA_HOME/config/kraft/server.properties

# Run Kafka
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/kraft/server.properties
