// import { ethers } from "hardhat";
import { task } from "hardhat/config";
import { saleArgs, decimals } from "../constants/CArgs";
import { HardhatRuntimeEnvironment } from "hardhat/types";

task("deploy", "Deploy Token, IDO or both and verify if requested")
  .addFlag("p", "Deploy Only IDO")
  .addFlag("t", "Deploy Only Token")
  .addFlag("v", "Verify deployments if not on localhost")
  .addOptionalPositionalParam(
    "address",
    "Supply Ido token address if only deploying presale"
  )
  .setAction(async (args, hre) => {
    const { parseUnits, getAddress } = hre.ethers.utils;
    let token;
    let tokenAddr;

    if (!args.p) {
      token = await deploy(hre, "ERC20", [decimals]);
      tokenAddr = token.address;
      console.log(
        `Deployed Mock Token
            Address: ${tokenAddr}\n`
      );
    }
    if (args.v) {
      //@ts-ignore
      await token.deployTransaction.wait(6);

      await hre.run("verify:verify", {
        address: tokenAddr,
        constructorArguments: [decimals],
      });
    }
    if (args.t) return;

    if (args.p) {
      if (!args.address) throw Error("Please provide ido token address");
      tokenAddr = getAddress(args.address);
    }

    //@ts-ignore
    saleArgs.idoToken.addr = tokenAddr;
    const dParams = [
      saleArgs.deposit,
      saleArgs.idoToken,
      parseUnits(saleArgs.price),
      parseUnits(saleArgs.hardcap),
      parseUnits(saleArgs.investMax),
      parseUnits(saleArgs.investMin),
    ];

    const ido = await deploy(hre, "IDO", dParams);

    console.log(
      `Deployed Ido contract
      Address: ${ido.address}\n`
    );

    if (args.v) {
      await ido.deployTransaction.wait(6);
      await hre.run("verify:verify", {
        address: ido.address,
        constructorArguments: dParams,
      });
    }
  });

async function deploy(
  hre: HardhatRuntimeEnvironment,
  factory: string,
  dParams: any[]
) {
  try {
    const contract = await hre.ethers.getContractFactory(factory);
    const d = await contract.deploy(...dParams);
    return d;
  } catch (error) {
    throw error;
  }
}
