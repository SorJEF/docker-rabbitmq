DOCKER_SOCK = /var/run/docker.sock
DOCKER_HOST := $(shell [ -S $(DOCKER_SOCK) ] && [ -w $(DOCKER_SOCK) ] && echo unix://$(DOCKER_SOCK) || ss -t state listening 'sport = :5555' | awk '$$3 ~ /:5555/ { print $$3 }')
DOCKER = docker -H $(DOCKER_HOST)

all : container

.PHONY: container cookie

clean:
	rm -f erlang.cookie
	rm -f passwords

passwords:
	which pwgen || grep -q Ubuntu /etc/lsb-release && sudo apt-get install pwgen
	echo "PRODPASSWORD=$$(pwgen -s 12 1)" > passwords
	echo "WOTPASSWORD=$$(pwgen -s 12 1)" >> passwords
	echo "ADMINPASSWORD=$$(pwgen -s 12 1)" >> passwords

cookie: 
	./cookie

container: cookie passwords
	$(DOCKER) build -t wotio/rabbitmq .

run :
	$(DOCKER) run -p 5672:5672 -p 15672:15672 -p 4369:4369 -p 9100:9100 -p 9101:9101 -p 9102:9102 -p 9103:9103 -p 9104:9104 -p 9105:9105 --dns 172.17.42.1  -e DNSSERVER=$${DNS_SERVER:-'172.17.42.1'} -e RABBITMQ_PASSWORD=$${RABBITMQ_PASSWORD} -e LDAP_SERVER=$${LDAP_SERVER:-'ldap.wot.io'} -h $$(hostname -s) -d -t wotio/rabbitmq

test:
	[ -e ./Dockerfile ] && echo "Dockerfile found" || exit 1

