import * as dotenv from "dotenv";
import { ContractFactory } from "ethers";
import * as fs from "fs";
import * as path from "path";
import { getLocalWallet } from "../../../../scripts/_utils";

dotenv.config();

/**
 * Example usage:
 * $ yarn deploy "CoinFlipAttack.sol/CoinFlipAttack" '["0x97A9dFb9C4e6FE2F7105F8E2aa11A95DC8272bAd"]'
 */
const deploy = async () => {
  const wallet = getLocalWallet();

  const jsonPath1 = path.join(process.cwd(), `out/GatekeeperOne.sol/GatekeeperOne.json`);
  const jsonPath2 = path.join(process.cwd(), `out/GatekeeperAttack.sol/GatekeeperAttack.json`);
  const metadata1 = JSON.parse(fs.readFileSync(jsonPath1).toString());
  const metadata2 = JSON.parse(fs.readFileSync(jsonPath2).toString());

  const factory1 = new ContractFactory(metadata1.abi, metadata1.bytecode.object, wallet);
  const factory2 = new ContractFactory(metadata2.abi, metadata2.bytecode.object, wallet);

  const contract1 = await factory1.deploy();
  await contract1.deployed();

  const contract2 = await factory2.deploy();
  await contract2.deployed();
};

deploy().catch(console.error);
