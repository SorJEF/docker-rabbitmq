MESSAGE_TTL ?= 120000
ENVS = --dns 8.8.8.8  -e DNSSERVER=$${DNS_SERVER:-'8.8.8.8'} -e RABBITMQ_PASSWORD=$${RABBITMQ_PASSWORD} -e LDAP_SERVER=$${LDAP_SERVER:-'ldap.wot.io'} -e VHOSTS=$${VHOSTS:-'wot'} -e MESSAGE_TTL=$(MESSAGE_TTL) -e PRODPASSWORD=$${PRODPASSWORD} -e WOTPASSWORD=$${WOTPASSWORD} -e ADMINPASSWORD=$${ADMINPASSWORD} -h $$(hostname -s)
PORTS = -p 5672:5672 -p 15672:15672 -p 4369:4369 -p 9100:9100 -p 9101:9101 -p 9102:9102 -p 9103:9103 -p 9104:9104 -p 9105:9105 -p 25672:25672
CONTAINER = rabbitmq
CLUSTER ?=
VOLUMES = -v `pwd`/data:/var/lib/rabbitmq

override define clean_
	rm -f erlang.cookie
	rm -f passwords
endef

override define prep_
	./cookie
	which pwgen || sudo apt-get install pwgen
	echo "PRODPASSWORD=$$(pwgen -s 12 1)" > passwords
	echo "WOTPASSWORD=$$(pwgen -s 12 1)" >> passwords
	echo "ADMINPASSWORD=$$(pwgen -s 12 1)" >> passwords
endef

override define test_
	[ -e ./Dockerfile ] && echo "Dockerfile found" || exit 1
endef

include ../wot-make/docker.mk
include ../wot-make/npm.mk
