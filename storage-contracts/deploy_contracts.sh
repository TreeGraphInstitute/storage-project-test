#!/bin/bash

./make_sure_ready.sh
yarn deploy-no-market cfx
npx hardhat run src/dev/transfer.ts --network cfx
