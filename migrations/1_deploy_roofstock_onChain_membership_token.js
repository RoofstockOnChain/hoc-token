const { deployProxy } = require("@openzeppelin/truffle-upgrades");

const RoofstockOnChainMembershipToken = artifacts.require("RoofstockOnChainMembershipToken");

module.exports = async function (deployer) {
  await deployProxy(RoofstockOnChainMembershipToken, [ ], { deployer });
};
