const { deployProxy } = require("@openzeppelin/truffle-upgrades");

const RoofstockOnChainKyc = artifacts.require("RoofstockOnChainKyc");
const HomeOnChainToken = artifacts.require("HomeOnChainToken");

module.exports = async function (deployer) {
  const goerliQuadrataPassportContractAddress = "0x185cc335175B1E7E29e04A321E1873932379a4a0";
  const mainnetQuadrataPassportContractAddress = "0x2e779749c40CC4Ba1cAB4c57eF84d90755CC017d";

  // Deploy the RoofstockOnChainKyc contract without the proxy
  // const roofstockOnChainKycContract = await deployer.deploy(RoofstockOnChainKyc, [ goerliQuadrataPassportContractAddress ]);

  // Deploy the Roofstock onChain Home onChain Token contract without the proxy
  // await deployer.deploy(HomeOnChainToken);

  // Deploy the Roofstock onChain Home onChain Token contract with the proxy
  // await deployProxy(HomeOnChainToken, [ roofstockOnChainKycContract.address ], { deployer });
};
