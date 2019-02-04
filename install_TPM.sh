#!/bin/sh

mkdir tpm_sim
cd tpm_sim
curl -O https://netcologne.dl.sourceforge.net/project/ibmswtpm2/ibmtpm1332.tar.gz
tar -xvzf ibmtmp1332.tar.gz
cd src
apt-get update && sudo apt-get install --force-yes make gcc libssl-dev tss2
make
cp tpm_server /sbin
cd ..
cp tpm_server.service /etc/systemd/system/
chmod 777 /etc/systemd/system/tpm_server.service
systemctl daemon-reload
systemctl enable tpm_server.service
systemctl start tpm_servers
tsspowerup
tssstartup
TPM_INTERFACE_TYPE=socsim time tsscreateprimary -hi o -st -rsa


