const { deployProxy } = require("@openzeppelin/truffle-upgrades");

const Allowlist = artifacts.require("Allowlist");
const HomeOnChainToken = artifacts.require("HomeOnChainToken");

module.exports = async function (deployer) {
  await deployer.deploy(Allowlist);
  const allowlistInstance = await Allowlist.deployed();
  await deployProxy(HomeOnChainToken, [ allowlistInstance.address ], { deployer });
};
