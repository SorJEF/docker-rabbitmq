# docker-rabbitmq
#
# VERSION 0.1

FROM docker.wot.io:5000/wotio/nodejs:0.0.1
MAINTAINER wot.io devs <dev@wot.io>

RUN yum -y install gawk bind-utils

# install rabbitmq-server 3.3.1
RUN yum -y install http://www.rabbitmq.com/releases/rabbitmq-server/v3.3.1/rabbitmq-server-3.3.1-1.noarch.rpm

# activate plugins
RUN /usr/sbin/rabbitmq-plugins enable rabbitmq_mqtt rabbitmq_stomp rabbitmq_management  rabbitmq_management_agent rabbitmq_management_visualiser rabbitmq_federation rabbitmq_federation_management sockjs rabbitmq_auth_backend_ldap

# install our passwords
ADD passwords /.passwords

# install the rabbitmq config file
ADD rabbitmq.config /etc/rabbitmq/rabbitmq.config

# install our erlang.cookie
ADD erlang.cookie /.erlang.cookie
RUN chmod 400 /.erlang.cookie
RUN chown root:root /.erlang.cookie

# install a script to setup the cluster based on DNS
ADD ./rabbitmq-cluster /usr/sbin/rabbitmq-cluster

# create a shell so we can configure clustering and stuff
CMD /usr/sbin/rabbitmq-cluster
