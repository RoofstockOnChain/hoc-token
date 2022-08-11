const { deployProxy } = require("@openzeppelin/truffle-upgrades");

const KycOnChainToken = artifacts.require("KycOnChainToken");
const HomeOnChainToken = artifacts.require("HomeOnChainToken");

module.exports = async function (deployer) {
  await deployer.deploy(KycOnChainToken);
  const kycOnChainTokenInstance = await KycOnChainToken.deployed();
  await deployProxy(HomeOnChainToken, [ kycOnChainTokenInstance.address ], { deployer });
};
