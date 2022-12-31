import { getLocalProvider, getLocalWallet, getRemoteWallet } from "../../../scripts/_utils";

const sendTransaction = async () => {
  const provider = getLocalProvider();
  const wallet = getLocalWallet();

  const tx = await wallet.sendTransaction({
    data: "0x600a600c600039600a6000f3602a60005260206000f3",
    gasLimit: 1_000_000,
  });

  const txr = await tx.wait();

  const r = await provider.call({
    to: txr.contractAddress,
  });

  console.assert(parseInt(r, 16) === 42, "failed");
};

sendTransaction().catch(console.error);
