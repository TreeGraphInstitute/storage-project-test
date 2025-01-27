import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import "hardhat-abi-exporter";
import "hardhat-deploy";
import "hardhat-deploy-ethers";
import "hardhat-gas-reporter";
import "hardhat-interface-generator";
import { HardhatUserConfig, HttpNetworkUserConfig } from "hardhat/types";
import "solidity-coverage";

// environment configs
import dotenv from "dotenv";
dotenv.config();
const { NODE_URL, DEPLOYER_KEY, ETHERSCAN_API_KEY } = process.env;

// 0x12cAef034a8D1548a81fd7d677640d1070a1Ec17
const DEFAULT_DEPLOYER = "36b9e861b63d3509c88b7817275a30d22d62c8cd8fa6486ddee35ef0d8e0495f";

const userConfig: HttpNetworkUserConfig = {
    accounts: [DEPLOYER_KEY ? DEPLOYER_KEY : DEFAULT_DEPLOYER],
};

import "./src/tasks/codesize";

const config: HardhatUserConfig = {
    paths: {
        artifacts: "artifacts",
        cache: "build/cache",
        sources: "contracts",
        deploy: "src/deploy",
    },
    solidity: {
        compilers: [
            {
                version: "0.8.16",
                settings: {
                    outputSelection: {
                        "*": {
                            "*": [
                                "evm.bytecode.object",
                                "evm.deployedBytecode.object",
                                "abi",
                                "evm.bytecode.sourceMap",
                                "evm.deployedBytecode.sourceMap",
                                "metadata",
                            ],
                            "": ["ast"],
                        },
                    },
                    evmVersion: "istanbul",
                    // viaIR: true,
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                },
            },
        ],
    },
    networks: {
        cfx: {
            ...userConfig,
            accounts: ["46b9e861b63d3509c88b7817275a30d22d62c8cd8fa6486ddee35ef0d8e0495f"],
            url: "http://chain0:8545",
        },
    },
    namedAccounts: {
        deployer: 0,
    },
    mocha: {
        timeout: 2000000,
    },
    verify: {
        etherscan: {
            apiKey: ETHERSCAN_API_KEY,
        },
    },
    gasReporter: {
        currency: "Gwei",
        gasPrice: 20,
        enabled: process.env.REPORT_GAS ? true : false,
    },
    abiExporter: {
        path: "./abis",
        runOnCompile: true,
        clear: true,
        flat: true,
        format: "json",
    },
};
if (NODE_URL && config.networks) {
    config.networks.custom = {
        ...userConfig,
        url: NODE_URL,
    };
}
export default config;
