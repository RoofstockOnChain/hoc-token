const { deployProxy } = require("@openzeppelin/truffle-upgrades");

const KycOnChainToken = artifacts.require("KycOnChainToken");

module.exports = async function (deployer) {
  await deployProxy(KycOnChainToken, [ ], { deployer });
};
