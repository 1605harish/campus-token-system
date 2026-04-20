async function main() {
  const [deployer] = await ethers.getSigners();

  const Coin = await ethers.getContractFactory("CampusCoin");
  const coin = await Coin.deploy();
  await coin.waitForDeployment();

  const Rewards = await ethers.getContractFactory("CampusRewards");
  const rewards = await Rewards.deploy(await coin.getAddress());
  await rewards.waitForDeployment();

  const Market = await ethers.getContractFactory("CampusMarketplace");
  const market = await Market.deploy(await coin.getAddress());
  await market.waitForDeployment();

  // Give mint permission to rewards contract
  await coin.setMinter(await rewards.getAddress(), true);

  console.log("Coin:", await coin.getAddress());
  console.log("Rewards:", await rewards.getAddress());
  console.log("Marketplace:", await market.getAddress());
}

main();