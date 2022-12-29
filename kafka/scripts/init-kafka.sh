#!/bin/bash

if [[ -z "$TOPICS" ]]; then
    echo "No TOPICS environment variable defined. No topics will be created"
    exit 0
fi

while ! nc -z localhost 9092; do
  echo "Pinging Kafka to be ready..."
  sleep 1
done

# FORMAT: "name:partitions:replicas:cleanup.policy"
# Example of ENV variable: TOPICS=test-topic:3:1,test-topic2:3:1
IFS="${TOPICS_SEPARATOR-,}"; for topicToCreate in $TOPICS; do
    echo "Creating topics: $topicToCreate"
    IFS=':' read -r -a topicConfig <<< "$topicToCreate"
    config=
    if [ -n "${topicConfig[3]}" ]; then
        config="--config=cleanup.policy=${topicConfig[3]}"
    fi

    COMMAND="${KAFKA_HOME}/bin/kafka-topics.sh \\
		--create \\
		--bootstrap-server localhost:9092 \\
		--topic ${topicConfig[0]} \\
		--partitions ${topicConfig[1]} \\
		--replication-factor ${topicConfig[2]} \\
		${config} &"

    eval "${COMMAND}"
done

wait
