FROM logstash
MAINTAINER Helain Schoonjans
ADD config.sh /
RUN chmod a+x config.sh
ENTRYPOINT ["./config.sh", "&&"]