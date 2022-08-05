const { deployProxy } = require("@openzeppelin/truffle-upgrades");

const HomeOnChainToken = artifacts.require("HomeOnChainToken");

module.exports = async function (deployer) {
   // TODO: Add the allowlist smart contract address
  const allowlistSmartContractAddress = '';
  await deployProxy(HomeOnChainToken, [ allowlistSmartContractAddress ], { deployer });
};
