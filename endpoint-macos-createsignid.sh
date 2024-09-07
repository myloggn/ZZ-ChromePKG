#!/bin/bash

##### Variables #####
# Organization Identifier
ID="MyLoginHub"
# Create Private Key
KEY="InstallerCertificate_${ID}_PrivateKey.pem"
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -sha256 \
-addext basicConstraints=critical,CA:false \
-addext keyUsage=critical,digitalSignature \
-set_serial "0x$(openssl rand -hex 4)" \
-subj "/CN=Installer Certificate ($ID)" \
-out InstallerCertificate_"$ID".pem \
-keyout "$KEY"

##### Main Body #####
# Import Public Certificate to Keychain
security import "InstallerCertificate_$ID.pem"

# Import Private Key to Keychain
security import "$KEY" \
-T /usr/bin/productbuild -T /usr/bin/pkgbuild
security add-trusted-cert -d InstallerCertificate_"$ID".pem
