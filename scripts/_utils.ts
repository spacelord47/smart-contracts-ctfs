import * as childProcess from "child_process";
import * as dotenv from "dotenv";
import { ethers } from "ethers";
import { promisify } from "util";

dotenv.config();

const exec = promisify(childProcess.exec);
const { INFURA_SEPOLIA_RPC_URL, ANVIL_PRIVATE_KEY, REMOTE_PRIVATE_KEY_PATH } = process.env;

export const getAccPrivateKey = async (): Promise<string> => {
  return exec(`pass ${REMOTE_PRIVATE_KEY_PATH}`).then((res) => res.stdout.replace(/\n/, ""));
};

export const getRemoteProvider = (): ethers.providers.Provider => {
  return new ethers.providers.JsonRpcProvider(INFURA_SEPOLIA_RPC_URL);
};

export const getRemoteWallet = async (): Promise<ethers.Wallet> => {
  const provider = getRemoteProvider();
  const privateKey = await getAccPrivateKey();

  return new ethers.Wallet(privateKey, provider);
};

/**
 * Use Anvil for local deploy.
 */
export const getLocalProvider = (): ethers.providers.Provider => {
  return new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545");
};

export const getLocalWallet = (): ethers.Wallet => {
  const provider = getLocalProvider();
  return new ethers.Wallet(ANVIL_PRIVATE_KEY!, provider);
};
