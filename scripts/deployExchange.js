const { ethers, run, network } = require("hardhat");

async function main() {
  const ExchangeFactory = await ethers.getContractFactory("Exchange");
  console.log("Deploying Exchange...");
  const exchange = await ExchangeFactory.deploy();
  await exchange.deployed();
  console.log(`Deployed contract to ${exchange.address}`);
  if (network.config.chainId === 5 && process.env.ETHERSCAN_API_KEY) {
    await exchange.deployTransaction.wait(6);
    await verify(exchange.address, []);
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
