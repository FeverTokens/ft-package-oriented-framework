import { HardhatUserConfig } from "hardhat/config";
// Break out toolbox to avoid auto-running typechain
import "@nomicfoundation/hardhat-ethers";
import "@nomicfoundation/hardhat-chai-matchers";
import "@nomicfoundation/hardhat-network-helpers";
import "@nomicfoundation/hardhat-verify";

// import "@typechain/hardhat"; // Intentionally disabled to avoid typechain ABI parsing issue during compile

const ftganacheConfig = {
  url: "http://a431184bd3f754da4b95e067b1e81ad4-113731396.eu-west-3.elb.amazonaws.com:8545",
  chainId: 1337,
  // You might need to add more configuration options here based on your requirements
};
const config: HardhatUserConfig = {
  solidity: "0.8.26",
  networks: {},
};

export default config;
