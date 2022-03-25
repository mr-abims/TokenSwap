import "@typechain/hardhat";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-waffle";
import { ethers } from "hardhat";

async function main() {
  // Deployed contract address
  const TokenSwapAddress: string = "0xA2B66209A3872257F4FC2532bF35138f466f13ea";
  /*
  //    //////////  
  // Accounts to be impersonated//
  */
  const USDCowner: string = "0x25FCa2F41E4d086eEcCd4A9FBC6334cd8a70963C";
  const DaiOwner: string = "0x4A35582a710E1F4b2030A3F826DA20BfB6703C09";

  // Contracts Account
  const DAI: string = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063";
  const USDC = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
  // PriceFeed Address
  const DAIvsUSD: string = "0x4746DeC9e833A82EC7C2C1356372CcF2cfcD2F3D";
  const contract = await ethers.getContractAt("TokenSwap", TokenSwapAddress);

  console.log(await contract.getLatestPrice());

  /*  impersonating account */

  async function prank(address: string) {
    // @ts-ignore
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [address],
    });
  }

  prank(USDCowner);
  const UsdcSigner = await ethers.getSigner(USDCowner);
  prank(DaiOwner);
  const DaiSigner = await ethers.getSigner(DaiOwner);

  /* Interacting with USDC */
  const getUSDC = await ethers.getContractAt("IERC20", DAI);
  await getUSDC
    .connect(DaiSigner)
    .transfer(TokenSwapAddress, "10000000000000000000");
  console.log("Usdc sucessfully transfered to contract");
  const UsdcBalance = await getUSDC.balanceOf(TokenSwapAddress);
  console.log(
    "USDC balance:",
    Math.floor(Number(UsdcBalance) / Math.pow(10, 18))
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
