import { getLocalWallet } from "../../../../scripts/_utils";

const sendTransaction = async () => {
  const wallet = getLocalWallet();

  const tx = await wallet.sendTransaction({
    to: "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512",
    data: "0xb9b561a40000000000000000000000005fbdb2315678afecb367f032d93f642f64180aa3",
    gasLimit: 50_000,
  });

  const txr = await tx.wait();
  console.log(txr);
};

sendTransaction().catch(console.error);
