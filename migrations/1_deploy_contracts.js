const { deployProxy } = require("@openzeppelin/truffle-upgrades");

const RoofstockOnChainMembershipToken = artifacts.require("RoofstockOnChainMembershipToken");
const HomeOnChainToken = artifacts.require("HomeOnChainToken");

module.exports = async function (deployer) {
  // Deploy the Roofstock onChain Membership Token contract without the proxy
  //await deployer.deploy(RoofstockOnChainMembershipToken);

  // Deploy the Roofstock onChain Membership Token contract with the proxy
  // const roofstockOnChainMembershipTokenContract = await deployProxy(RoofstockOnChainMembershipToken, [ ], { deployer });

  // Deploy the Roofstock onChain Home onChain Token contract without the proxy
  // await deployer.deploy(HomeOnChainToken);

  // Deploy the Roofstock onChain Home onChain Token contract with the proxy
  // await deployProxy(HomeOnChainToken, [ roofstockOnChainMembershipTokenContract.address ], { deployer });
};
