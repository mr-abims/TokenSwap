import "@typechain/hardhat";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-waffle";
import { ethers } from "hardhat";
import "./deploy.ts";
import { Signer } from "ethers";

async function main() {
  // Deployed contract address
  const TokenSwapAddress: string = "0xf2F7Ee6206c10dD1f0e57038FD6C21ACAB9E09E9";
  // PriceFeed Address
  const DAIvsUSD: string = "0x4746DeC9e833A82EC7C2C1356372CcF2cfcD2F3D";
  // Contracts Account
  const DAIAddress: string = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063";
  const USDCAddress = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";

  // Accounts to be impersonated
  const USDCowner: string = "0x25FCa2F41E4d086eEcCd4A9FBC6334cd8a70963C";
  const DaiOwner: string = "0x4A35582a710E1F4b2030A3F826DA20BfB6703C09";

  // create signers for each token holder
  const UsdcSigner: Signer = await ethers.getSigner(USDCowner);
  const DaiSigner = await ethers.getSigner(DaiOwner);
  // ///////////////////////

  // PriceFeed For USDC/DAi
  const contract = await ethers.getContractAt("TokenSwap", TokenSwapAddress);

  await contract.getLatestPrice(); // latest price of DAIvsUSDC

  /*  impersonating account */

  async function prank(address: string) {
    // @ts-ignore
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [address],
    });
  }

  prank(USDCowner);
  // @ts-ignore
  await hre.network.provider.send("hardhat_setBalance", [
    USDCowner,
    "0x10000000000000000000000",
  ]);
  prank(DaiOwner);
  // @ts-ignore
  await hre.network.provider.send("hardhat_setBalance", [
    DaiOwner,
    "0x10000000000000000000000",
  ]);
  /* Interacting with DAI */
  const getDAI = await ethers.getContractAt("IERC20", DAIAddress);
  await getDAI
    .connect(DaiSigner)
    .transfer(TokenSwapAddress, "10000000000000000000");
  console.log("Dai Transferred to contract");
  const DAIContractBal = await getDAI.balanceOf(TokenSwapAddress);
  console.log(
    "contract Balance of DAi token",
    Math.floor(Number(DAIContractBal) / Math.pow(10, 18))
  );

  // * Interacting with USDC */
  const getUSDC = await ethers.getContractAt("IERC20", USDCAddress);
  await getUSDC.connect(UsdcSigner).transfer(TokenSwapAddress, "100");
  console.log("USDC Transferred to contract");
  const USDContractBal = await getDAI.balanceOf(TokenSwapAddress);
  console.log(
    "contract Balance of DAi token",
    Math.floor(Number(USDContractBal) / Math.pow(10, 18))
  );
  // Swaapping Dai to Usdc

  const daiBal = await getDAI.balanceOf(DaiOwner);
  const UsdcBal = await getUSDC.balanceOf(USDCowner);
  console.log("old dai bal", Math.floor(Number(daiBal) / Math.pow(10, 18)));
  console.log("old usdc bal", Math.floor(Number(UsdcBal) / Math.pow(10, 18)));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
