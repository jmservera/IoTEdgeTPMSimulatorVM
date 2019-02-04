#!/bin/sh
echo "Geting all needed files and libraries"
apt-get update && sudo apt-get install -y make gcc libssl-dev tss2

echo "Downloading IBM Software TPM2"
mkdir tpm_sim
cd tpm_sim
curl -O https://netcologne.dl.sourceforge.net/project/ibmswtpm2/ibmtpm1332.tar.gz
tar -xvzf ibmtpm1332.tar.gz
cd src
echo "Compiling TPM2"
make
echo "Copy to /sbin"
cp tpm_server /sbin
cd ../..
echo "Create tpm_server Service"
cp tpm_server.service /etc/systemd/system/
chmod 777 /etc/systemd/system/tpm_server.service
systemctl daemon-reload
systemctl enable tpm_server.service
systemctl start tpm_server

echo "Check service"
tsspowerup
tssstartup
TPM_INTERFACE_TYPE=socsim time tsscreateprimary -hi o -st -rsa


