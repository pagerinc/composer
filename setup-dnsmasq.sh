#!/bin/bash

brew install dnsmasq
echo 'address=/.localhost/127.0.0.1' >> $(brew --prefix)/etc/dnsmasq.conf
echo 'port=53' >> $(brew --prefix)/etc/dnsmasq.conf
sudo brew services start dnsmasq
sudo mkdir -v /etc/resolver
sudo echo 'nameserver 127.0.0.1' >> /etc/resolver/localhost
sudo touch /etc/resolver/localhost
