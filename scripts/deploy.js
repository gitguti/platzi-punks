const { ethers } = require('hardhat');

const deploy = async () => {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contract with the account: ", deployer.address);

  const PlatziPunkis = await ethers.getContractFactory("PlatziPunkis");

  const deployed = await PlatziPunkis.deploy(1);

  console.log("Platzi punkis is deployed at: ", deployed.address);
}

deploy().then(() => process.exit(0)).catch(error => {
  console.error(error);
  process.exit(1)
});