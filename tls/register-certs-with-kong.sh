#!/bin/bash

curl -i -X 'POST' http://localhost:8001/certificates \
  -H 'Content-Type: application/json' \
  -d "{\"cert\": \"$(cat certs/pager.localhost.crt)\", \"key\": \"$(cat certs/pager.localhost.key)\", \"snis\": [ \"*.pager.localhost\" ] }"
