all : container

.PHONY: container cookie

clean:
	rm -f erlang.cookie
	rm -f passwords

passwords:
	echo "PRODPASSWORD=$$(pwgen -s 12 1)" > passwords
	echo "WOTPASSWORD=$$(pwgen -s 12 1)" >> passwords
	echo "ADMINPASSWORD=$$(pwgen -s 12 1)" >> passwords

cookie: 
	./cookie

container: cookie passwords
	docker -H $$(ifconfig eth1 | gawk 'match($$0,/addr:([0-9]+.[0-9]+.[0-9]+.[0-9]+)/,m) { print m[1] }'):5555 build -t wotio/rabbitmq .

run :
	docker -H $$(ifconfig eth1 | gawk 'match($$0,/addr:([0-9]+.[0-9]+.[0-9]+.[0-9]+)/,m) { print m[1] }'):5555  run -p 5672:5672 -p 15672:15672 -p 4369:4369 -p 9100:9100 -p 9101:9101 -p 9102:9102 -p 9103:9103 -p 9104:9104 -p 9105:9105 --dns 172.17.42.1  -e DNSSERVER=172.17.42.1 -h $$(hostname -s) -d -t wotio/rabbitmq 

test:
	[ -e ./Dockerfile ] && echo "Dockerfile found" || exit 1

