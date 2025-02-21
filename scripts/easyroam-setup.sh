#!/usr/bin/env bash

set -e

if [[ $# -lt 1 ]]; then
  cat <<EOF
Setup instructions:
  1. Go to https://www.easyroam.de/User/Generate
  2. Select 'Manual options' > 'PKCS12', enter your device name and generate the profile
  3. After downloading the profile, run this script again:
      easyroam-setup <path-to-profile> [<output-path>]
EOF
  exit
fi

profile=$(realpath "$1")

if [[ -n $2 ]]; then
  mkdir -p "$2"
  cd "$2"
fi

pkpass=$(pwgen -s 32 1)
openssl pkcs12 -in "$profile" -legacy -nokeys -password pass: | openssl x509 >easyroam_client_cert.pem
openssl pkcs12 -legacy -in "$profile" -nodes -nocerts -password pass: | openssl rsa -aes256 -out easyroam_client_key.pem -passout "pass:$pkpass"
openssl pkcs12 -in "$profile" -legacy -cacerts -nokeys -password pass: >easyroam_root_ca.pem
cn=$(openssl x509 -noout -subject -in easyroam_client_cert.pem -legacy | sed 's/.*CN = \(.*\), C.*/\1/')

cat <<EOF
[connection]
id=easyroam
uuid=$(uuidgen)
type=wifi

[wifi]
mode=infrastructure
ssid=eduroam

[wifi-security]
key-mgmt=wpa-eap

[802-1x]
ca-cert=$(realpath easyroam_root_ca.pem)
client-cert=$(realpath easyroam_client_cert.pem)
eap=tls;
identity=$cn
private-key=$(realpath easyroam_client_key.pem)
private-key-password=$pkpass

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto

[proxy]
EOF
