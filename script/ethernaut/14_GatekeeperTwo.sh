#!/bin/bash

source .env

forge script script/ethernaut/14_GatekeeperTwo.s.sol:ExploitScript \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --rpc-url $RPC_URL