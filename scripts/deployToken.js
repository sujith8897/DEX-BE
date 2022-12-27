const { ethers, run, network } = require("hardhat");

async function main() {
  const ERC20TokenFactory = await ethers.getContractFactory("ERC20");
  console.log("Deploying ERC20 Token...");
  const token = await ERC20TokenFactory.deploy();
  await token.deployed();
  console.log(`Deployed contract to ${token.address}`);
  if (network.config.chainId === 5 && process.env.ETHERSCAN_API_KEY) {
    await token.deployTransaction.wait(6);
    await verify(token.address, []);
  }
}

async function verify(contractAddress, args) {
  console.log("Verifying contract...");
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    });
  } catch (e) {
    console.log(e);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
