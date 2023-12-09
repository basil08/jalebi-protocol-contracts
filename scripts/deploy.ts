import { ethers } from "hardhat";
import { initialOwner } from "./data";

async function main() {
  const ERC20ContractFactory = await ethers.getContractFactory("Jalebi");

  const jalebiToken = await ERC20ContractFactory.deploy(initialOwner);
  await jalebiToken.waitForDeployment();

  const jalebiTokenAddr = await jalebiToken.getAddress();
  console.log(`Contract deployed to ${jalebiTokenAddr}`);

  const ProtocolContractFactory = await ethers.getContractFactory("JalebiProtocol");

  const jalebiProtocolContract = await ProtocolContractFactory.deploy(jalebiTokenAddr);
  await jalebiProtocolContract.waitForDeployment();

  console.log(`Protocol contract deployed to ${await jalebiProtocolContract.getAddress()}`);
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
