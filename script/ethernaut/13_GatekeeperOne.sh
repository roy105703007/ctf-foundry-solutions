#!/bin/bash

source .env

forge script script/ethernaut/13_GatekeeperOne.s.sol:ExploitScript \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --rpc-url $RPC_URL