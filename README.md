Kafka in Docker
===

This repository provides everything you need to run Kafka (without a Zookeeper, with KRaft support) in Docker environment. 
Image is based on the latest stable OpenJDK.

Run
---

```bash
docker run -d -p 9092:9092 --name kafka wlsc/kafka
```

Kafka Producer
---

```bash
export KAFKA=$(docker-machine ip $(docker-machine active)):9092
kafka-console-producer.sh --broker-list $KAFKA --topic test
```

Kafka Consumer
---

```bash
kafka-console-consumer.sh --topic test --from-beginning --bootstrap-server localhost:9092
```

In the box
---
* **wlsc/kafka**

  The docker image with both Kafka with KRaft. Built from the `kafka`directory.

Public Builds
---

https://registry.hub.docker.com/u/wlsc/kafka/

Build from Source (from folder /kafka)
---
```bash
docker buildx build --platform linux/arm64,linux/amd64 -t wlsc/kafka:latest .
```

Import single platform into Docker Desktop

```bash
docker buildx build --platform linux/arm64 -t wlsc/kafka:kraft --load .
```
