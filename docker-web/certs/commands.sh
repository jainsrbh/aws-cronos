openssl genrsa -out ca.key 4096
openssl req -new -x509 -days 365 -key ca.key \
    -out ca.crt \
    -subj "/CN=Cronos API CA/O=cronos-test.org/C=US"
openssl genrsa -out server.key 4096
openssl req -new -key server.key \
    -out server.csr \
    -subj "/CN=cronos-proxy/O=cronos-test.org/C=US"
openssl x509 -req -days 365 -in server.csr \
    -CA ca.crt -CAkey ca.key \
    -set_serial 01 -out server.crt

#client certs
openssl genrsa -out client.key 4096
openssl req -new -key client.key \
-out client.csr \
-subj "/CN=client-001/O=cronos-test.org/C=US"
openssl x509 -req -days 365 -in client.csr \
    -CA ca.crt -CAkey ca.key \
    -set_serial 02 -out client.crt
openssl pkcs12 -export -password pass: -in client.crt \
-inkey client.key -out client.p12
