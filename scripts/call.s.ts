import { getRemoteProvider } from "./_utils";

const call = async () => {
  const provider = getRemoteProvider();

  const res = await provider.getBalance("0x00");
  console.log(res);
};

call().catch(console.error);
