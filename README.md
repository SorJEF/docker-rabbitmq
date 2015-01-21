docker-rabbitmq
===============

A docker.io recipe for running rabbitmq 3.1.5 


Getting Started
---------------

To get up and running fast with a new cluster:

	make clean
	make
	RABBITMQ_PASSWORD=ldap-rabbitmq-password make run

If you need to use a different LDAP server:

	LDAP_SERVER=new.ldap.server RABBITMQ_PASSWORD=ldap-rabbitmq-password make run

A new DNS server can be similarly specified:

	DNS_SERVER=new.dns.server RABBITMQ_PASSWORD=ldap-rabbitmq-password make run

To override or add more vhosts:

	VHOSTS=eggs

or

	VHOSTS_0=waffles
	VHOSTS_1=pancakes

This assumes that you are running the PowerDNS server with the applicable clustering and hostname information at PDNSSERVER and are supplying a fully qualified domain name (FQDN) as the HOSTNAME parameter.  Should a text record (TXT) exist for HOSTNAME on DNSSERVER with the words rabbitmq_cluster=${RABBITMASTER} the new rabbitmq node will attempt to cluster to RABBITMQMASTER.