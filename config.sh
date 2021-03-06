#!/bin/bash
# @author heschoon
# this script generates the configuration files for either the
# log4j-RabbitMQ forwarding or the RabbitMQ-Elasticsearch forwarding
# using the environment variables to set the sensible information.

if [ "$TYPE" == "log4j-rabbitmq" ]
then
	echo "Generating the log4j-rabbitMQ Logstash configuration file:"
	
	if [ $LOG4J_TAGS ]
	then
	  LOG4J_TEMP_TAGS="tags => ${LOG4J_TAGS} # array (optional)"
	fi

	if [ $LOG4J_TYPE ]
	then
	  LOG4J_TEMP_TYPE="type => \"${LOG4J_TYPE}\" # string (optional)"
	fi
	
	echo "input {
		   log4j {
			add_field => ${LOG4J_ADD_FIELD:-{}} # hash (optional), default: {}
			codec => \"${LOG4J_CODEC:-plain}\" # codec (optional), default: \"plain\"
			data_timeout => ${LOG4J_DATA_TIMEOUT:-5} # number (optional), default: 5
			host => \"${LOG4J_HOST:-0.0.0.0}\" # string (optional), default: \"0.0.0.0\"
			mode => \"${LOG4J_MODE:-server}\" # string, one of [\"server\", \"client\"] (optional), default: \"server\"
			port => ${LOG4J_PORT:-4560} # number (optional), default: 4560
			${LOG4J_TEMP_TAGS:-# no tags}
			${LOG4J_TEMP_TYPE:-# no type}
		}
	}
	output {
		rabbitmq {
			codec => \"${RABBITMQ_CODEC:-plain}\" # codec (optional), default: \"plain\"
			durable => ${RABBITMQ_DURABLE:-true} # boolean (optional), default: true
			exchange => \"${RABBITMQ_EXCHANGE:-test_exchange}\" # string (required)
			exchange_type => \"${RABBITMQ_EXCHANGE_TYPE:-direct}\" # string, one of [\"fanout\", \"direct\", \"topic\"] (required)
			host => \"${RABBITMQ_HOST:-localhost}\" # string (required)
			key => \"${RABBITMQ_KEY:-logstash}\" # string (optional), default: \"logstash\"
			password => \"${RABBITMQ_PASSWORD:-guest}\" # password (optional), default: \"guest\"
			persistent => ${RABBITMQ_PERSISTENT:-true} # boolean (optional), default: true
			port => ${RABBITMQ_PORT:-5672} # number (optional), default: 5672
			ssl => ${RABBITMQ_SSL:-false} # boolean (optional), default: false
			user => \"${RABBITMQ_USER:-guest}\" # string (optional), default: \"guest\"
			verify_ssl => ${RABBITMQ_VERIFY_SSL:-false} # boolean (optional), default: false
			vhost => \"${RABBITMQ_VHOST:-/}\" # string (optional), default: \"/\"
			workers => ${RABBITMQ_WORKERS:-1} # number (optional), default: 1
		}
	}" > config.conf
	echo "Success!"
elif [ "$TYPE" == "rabbitmq-elastic" ]
then
	echo "Generating the rabbitMQ-Elastic Logstash configuration file:"
	
	if [ $RABBITMQ_EXCHANGE ]
	then
	  RABBITMQ_TEMP_EXCHANGE="exchange => \"${RABBITMQ_EXCHANGE}\" # string (optional)"
	fi

	if [ $RABBITMQ_TYPE ]
	then
	  RABBITMQ_TEMP_TYPE="type => \"${RABBITMQ_TYPE}\" # string (optional)"
	fi
	
	echo "input {
	  rabbitmq {
		ack => ${RABBITMQ_ACK:-true} # boolean (optional), default: true
		add_field => ${RABBITMQ_ADD_FIELD:-{}} # hash (optional), default: {}
		arguments => ${RABBITMQ_ARGUMENTS:-{}} # array (optional), default: {}
		auto_delete => ${RABBITMQ_DELETE:-false} # boolean (optional), default: false
		codec => \"${RABBITMQ_CODEC:-plain}\" # codec (optional), default: \"plain\"
		durable => ${RABBITMQ_DURABLE:-false} # boolean (optional), default: false
		${RABBITMQ_TEMP_EXCHANGE:-# no exchange}
		exclusive => ${RABBITMQ_EXCLUSIVE:-false} # boolean (optional), default: false
		host => 		\"${RABBITMQ_HOST:-localhost}\" # string (required)
		key => 			\"${RABBITMQ_KEY:-logstash}\" # string (optional), default: \"logstash\"
		passive => 		${RABBITMQ_PASSIVE:-false} # boolean (optional), default: false
		password => 	\"${RABBITMQ_PASSWORD:-guest}\" # password (optional), default: \"guest\"
		port => 		${RABBITMQ_PORT:-5672} # number (optional), default: 5672
		prefetch_count => 	${RABBITMQ_PREFETCH_COUNT:-256} # number (optional), default: 256
		queue => 		\"${RABBITMQ_QUEUE:-test_queue}\" # string (optional), default: \"\"
		ssl => 			${RABBITMQ_SSL:-false} # boolean (optional), default: false
		tags => 		${RABBITMQ_TAGS:-[]} # array (optional)
		threads => 		${RABBITMQ_THREADS:-1} # number (optional), default: 1
		${RABBITMQ_TEMP_TYPE:-# no type}
		user => 		\"${RABBITMQ_USER:-guest}\" # string (optional), default: \"guest\"
		verify_ssl => 	${RABBITMQ_VERIFY_SSL:-false} # boolean (optional), default: false
		vhost => 		\"${RABBITMQ_VHOST:-/}\" # string (optional), default: \"/\"
	  }
	}
	output {
	  elasticsearch {
		action => \"${ELASTICSEARCH_ACTION:-index}\" # string (optional), default: index
		codec => \"${ELASTICSEARCH_CODEC:-plain}\" # codec (optional), default: \"plain\"
		document_id => \"${ELASTICSEARCH_DOCUMENT_ID:-nil}\" # string (optional), default: nil
		flush_size => ${ELASTICSEARCH_FLUSH_SIZE:-100} # number (optional), default: 100
		host => \"${ELASTICSEARCH_HOST:-localhost}\" # string (required)
		idle_flush_time => ${ELASTICSEARCH_IDLE_FLUSH_TIME:-1} # number (optional), default: 1
		index => \"${ELASTICSEARCH_INDEX:-logstash-%{+YYYY.MM.dd}}\" # string (optional), default: \"logstash-%{+YYYY.MM.dd}\"
		index_type => \"${ELASTICSEARCH_DOCUMENT_TYPE:-log}\" # string (optional)
		manage_template => ${ELASTICSEARCH_MANAGE_TEMPLATE:-true} # boolean (optional), default: true
		password => \"${ELASTICSEARCH_PASSWORD:-nil}\" # password (optional), default: nil
		port => ${ELASTICSEARCH_PORT:-9200} # number (optional), default: 9200
		protocol => \"${ELASTICSEARCH_PROTOCOL:-node}\" # string, one of [\"node\", \"transport\", \"http\"] (optional)
		#template => ${ELASTICSEARCH_TEMPLATE:-plain} # a valid filesystem path (optional)
		template_name => \"${ELASTICSEARCH_TEMPLATE_NAME:-logstash}\" # string (optional), default: \"logstash\"
		template_overwrite => ${ELASTICSEARCH_OVERWRITE:-false} # boolean (optional), default: false
		user => \"${ELASTICSEARCH_USER:-nil}\" # string (optional), default: nil
		workers => ${ELASTICSEARCH_WORKERS:-1} # number (optional), default: 1
	  }
	}" > config.conf
	echo "Success!"
else echo "Failure: TYPE environment variable is empty."
fi
