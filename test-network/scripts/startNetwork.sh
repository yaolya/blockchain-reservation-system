#!/bin/bash

main() {
    rm ../reservation_system/server/wallet/*.id
    export PATH=${PWD}/../bin:$PATH
    ./network.sh up createChannel -c channel1 -ca -s couchdb

    export FABRIC_CFG_PATH=$PWD/../config/
    export PATH=${PWD}/../bin:$PATH

    peer lifecycle chaincode package basic.tar.gz --path ../chaincode/ --lang node --label basic_1.0

    ./scripts/envVar.sh
    . ./scripts/envVar.sh

    setGlobals 1
    peer lifecycle chaincode install basic.tar.gz

    setGlobals 2
    peer lifecycle chaincode install basic.tar.gz

    setGlobals 1
    PKGID=$(peer lifecycle chaincode queryinstalled --peerAddresses localhost:7051 --tlsRootCertFiles organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt | grep -o -E 'basic_1.0:[a-z0-9]+')

    peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $PWD/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID channel1 --name basic --version 1 --package-id $PKGID --sequence 1

    setGlobals 2
    peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $PWD/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID channel1 --name basic --version 1 --package-id $PKGID --sequence 1

    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $PWD/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID channel1 --name basic --peerAddresses localhost:7051 --tlsRootCertFiles $PWD/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt --version 1 --sequence 1

    peer lifecycle chaincode querycommitted --channelID channel1 --name basic --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

    ./scripts/enrollAdmin.sh
}

main