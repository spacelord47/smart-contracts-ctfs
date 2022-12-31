import { getRemoteProvider } from "./_utils";

/**
 * Lists "main" storage slots for a contracts.
 */
const getStorage = async () => {
  const provider = getRemoteProvider();
  const address = process.argv[2];
  const slotsCount = Number(process.argv[3]);

  for (let i = 0; i < slotsCount; i += 1) {
    const data = await provider.getStorageAt(address, i);
    console.log(`[${i}]`, data);
  }
};

getStorage().catch(console.error);
