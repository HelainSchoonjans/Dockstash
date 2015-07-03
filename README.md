# Dockstash

A logstash in a docker, that generates the config files using the value of the environment variables you give with the -e flag of docker.

# Building / pulling

```docker@boot2docker:~$ docker build -t dockstash github.com/HelainSchoonjans/Dockstash```
or
```docker@boot2docker:~$ docker pull heschoon/dockstash```

# Launching
Log4j to RabbitMQ:

```docker run -e "TYPE=log4-rabbitmq" -d --name log4jtorabbit dockstash sh -c "./config.sh && logstash -f config.conf"```

RabbitMQ to Elastic:

```docker run -e "TYPE=rabbitmq-elastic" -d --name rabbittoelastic dockstash sh -c "./config.sh && logstash -f config.conf"```

You can add the --configtest flag to the logstash command to check if the config is right.

Since there is a default command, you can just use:

```docker run -e "TYPE=$TYPE" -d --name my_dockstash dockstash"```

The environment variables can be passed as in the example:
With the environment variables you should have something like:

```docker@boot2docker:~$ docker run -e "TYPE=$TYPE" -e "LOG4J_HOST=$LOG4J_HOST" -e "RABBITMQ_EXCHANGE=$RABBITMQ_EXCHANGE" -e "RABBITMQ_EXCHANGE_TYPE=$RABBITMQ_EXCHANGE_TYPE" -e "RABBITMQ_HOST=$RABBITMQ_HOST" -e "RABBITMQ_PASSWORD=$RABBITMQ_PASSWORD" -e "RABBITMQ_USER=$RABBITMQ_USER" -e "RABBITMQ_VHOST=$RABBITMQ_VHOST" -e "ELASTICSEARCH_INDEX=$ELASTICSEARCH_INDEX" -e "ELASTICSEARCH_HOST=$ELASTICSEARCH_HOST" -e "ELASTICSEARCH_PORT=$ELASTICSEARCH_PORT" -e "ELASTICSEARCH_USER=$ELASTICSEARCH_USER" -e "ELASTICSEARCH_PASSWORD=$ELASTICSEARCH_PASSWORD" --rm -it dockstash-test sh -c "./config.sh && logstash --configtest -f config.conf"```
