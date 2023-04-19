import hre, { ethers } from "hardhat";

async function main() {
  try {
    const contract = await ethers.getContractFactory("IDO");
    const ido = await contract.deploy();

    await ido.deployTransaction.wait(6);

    console.log(
      `Deployed Contract
      Address: ${ido.address}\n`
    );

    await hre.run("verify:verify", {
      address: ido.address,
    });
  } catch (error) {
    throw error;
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
