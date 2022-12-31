import { getRemoteWallet } from "../../../scripts/_utils";

const sendTransaction = async () => {
  const wallet = await getRemoteWallet();

  const tx = await wallet.sendTransaction({
    data: "0x600a600c600039600a6000f3602a60005260206000f3",
    gasLimit: 1_000_000,
  });

  const txr = await tx.wait();

  console.log("Deployed at: ", txr.contractAddress);
};

sendTransaction().catch(console.error);
