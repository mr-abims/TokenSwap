import { ethers } from "hardhat";

async function main() {
  const address = "0x4746DeC9e833A82EC7C2C1356372CcF2cfcD2F3D";
  const USDCowner = "0x25FCa2F41E4d086eEcCd4A9FBC6334cd8a70963C";
  const DaiOwner = "0x4A35582a710E1F4b2030A3F826DA20BfB6703C09";
  const TokenSwap = await ethers.getContractFactory("TokenSwap");
  const tokenswap = await TokenSwap.deploy(address);

  await tokenswap.deployed();
  console.log(await tokenswap.getLatestPrice(), "Price");
  console.log(await tokenswap.getRate());
  console.log(await tokenswap.swapDaiToUSDC(DaiOwner, USDCowner, 15678));
  // console.log(tokenswap.retrieveOrder);
  // console.log("Greeter deployed to:", tokenswap.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
