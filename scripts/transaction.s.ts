import { getRemoteWallet } from "./_utils";

const sendTransaction = async () => {
  const wallet = await getRemoteWallet();
  console.log(`> Transaction from: ${wallet.address}`);

  const tx = await wallet.sendTransaction({
    to: "0x0000000000000000000000000000000000000000",
    value: 0,
  });

  await tx.wait();
  console.log(`> Transaction hash: ${tx.hash}`);
};

sendTransaction().catch(console.error);
