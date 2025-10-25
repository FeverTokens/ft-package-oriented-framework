import { HardhatUserConfig } from "hardhat/config";
// Break out toolbox to avoid auto-running typechain
import "@nomicfoundation/hardhat-ethers";
import "@nomicfoundation/hardhat-chai-matchers";
import "@nomicfoundation/hardhat-network-helpers";
import "@nomicfoundation/hardhat-verify";

const config: HardhatUserConfig = {
  solidity: "0.8.26",
  networks: {},
};

export default config;
