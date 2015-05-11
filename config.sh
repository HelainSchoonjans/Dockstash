#!/bin/bash
# @author heschoon
# this script genrates the configuration files for both the
# log4j-RabbitMQ forwarding or the RabbitMQ-Elasticsearch forwarding
# using the environment variables to set the sensible information.


echo "Generating the log4j-rabbitMQ Logstash configuration file:"
echo "input {
	log4j {
		
	}
}
output {
    rabbitmq {
        exchange => \" \"
        exchange_type => \" \"
        host => \" \"
        password => \" \"
        user => \" \"
        vhost => \" \"
  }
  stdout {}
}" > log4j-rabbitmq.conf
echo "Success!"

echo "Generating the rabbitMQ Logstash configuration file:"
echo "input {
	rabbitmq {
		exchange => \" \"
		host => \" \"
        password => \" \"
		user => \" \"
		vhost => \" \"
	}
}
output {
	elasticsearch_http {
		index => \" \"
		host => \" \"
		port =>  
		user => \" \"
		password => \" \"
	}
	stdout{}
}" > rabbitmq-elastic.conf
echo "Success!"