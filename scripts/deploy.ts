import { ethers } from "hardhat";

async function main() {
  // DAI/USD address from chainlink
  const address = "0x4746DeC9e833A82EC7C2C1356372CcF2cfcD2F3D";
  const TokenSwap = await ethers.getContractFactory("TokenSwap");
  const tokenswap = await TokenSwap.deploy(address);
  console.log("Token swap deployed to:", tokenswap.address);

  await tokenswap.deployed();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
