#!/bin/bash

openssl genrsa -passout pass:dummy -aes256 -out private.pem 2048
openssl rsa -in private.pem -passin pass:dummy -outform PEM -pubout -out public.pem
openssl rsa -in private.pem -passin pass:dummy -out private_unencrypted.pem -outform PEM




