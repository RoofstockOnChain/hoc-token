const { deployProxy } = require("@openzeppelin/truffle-upgrades");

const HomeOnChainToken = artifacts.require("HomeOnChainToken");

module.exports = async function (deployer) {
  await deployProxy(HomeOnChainToken, [], { deployer });
};
