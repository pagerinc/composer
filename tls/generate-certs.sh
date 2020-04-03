#!/bin/bash

DOMAIN=pager.localhost

mkdir -p certs

# Create CA if it hasn't already been created
if [ ! -f certs/ca.crt ];
then
echo "Generating a CA to trust locally..."
openssl genrsa -passout pass:x -out certs/ca.key 2048
openssl req \
    -new \
    -x509 \
    -days 365 \
    -sha256 \
    -key certs/ca.key \
    -out certs/ca.crt \
    -config ca.conf
echo "Reqesting your password to add the generated CA as trusted"
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" certs/ca.crt
fi

echo "Cleaning any previously generated certificates..."
rm -rf certs/${DOMAIN}*

echo "Creating CSR..."
# Create CSR
openssl genrsa -passout pass:x -out certs/${DOMAIN}.key 2048
openssl req \
    -new \
    -nodes \
    -sha256 \
    -passin pass:x \
    -key certs/${DOMAIN}.key \
    -out certs/${DOMAIN}.csr \
    -config cert.conf

echo "Generating cert using CA and CSR..."
openssl x509 \
    -req \
    -days 365 \
    -sha256 \
    -in certs/${DOMAIN}.csr \
    -CA certs/ca.crt \
    -CAkey certs/ca.key \
    -CAcreateserial \
    -out certs/${DOMAIN}.raw.crt \
    -extfile cert.conf \
    -extensions my_extensions

cat certs/${DOMAIN}.raw.crt certs/ca.crt > certs/${DOMAIN}.crt
