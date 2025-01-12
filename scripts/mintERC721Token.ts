import { artifacts, ethers } from "hardhat";
import { Contract, Log, TransactionReceipt } from "ethers";

async function main() {

    const providerUrl = `https://polygon-amoy.infura.io/v3/` + process.env.INFURA_API_KEY;
    const provider = new ethers.JsonRpcProvider(providerUrl);
    const privateKey = process.env.PRIVATE_KEY as string;
    const tokenContractAddress: string = "0x38E8a2a03BF9BF54aBF3Add1DEFCd31E4b822df3";
    const spenderAddress: string = "0x2317D87e46691ECc6203514A4c43fd806db281ff";

    const ownerWallet = new ethers.Wallet(privateKey, provider);

    const contractArtifacts = await artifacts.readArtifact("MyERC721Token");
    const contractABI = contractArtifacts.abi;
   
    const tokenContract = new ethers.Contract(
        tokenContractAddress,
        contractABI,
        ownerWallet
    ) as unknown as Contract;

    try {
        console.log("Token creating --------------");
        const safeMintTxResponse = await tokenContract.saveMint(ownerWallet.address, 'https://nft-erc721-example.com');
        const safeMintTxReceipt: TransactionReceipt = await safeMintTxResponse.wait();
        const createTokenEvent = (safeMintTxReceipt.logs.find(log => {
            return tokenContract.interface.parseLog(log)?.name === "CreateToken"
        })) as Log;
        console.log("Owner address:", tokenContract.interface.parseLog(createTokenEvent)?.args[0]);
        const createdToken = tokenContract.interface.parseLog(createTokenEvent)?.args[1];
        console.log("Created token:", createdToken);
        console.log("Token created --------------");
        console.log("Approving starting --------------");
        const approveTxResponse = await tokenContract.approve(spenderAddress, createdToken);
        const approveTxReceipt: TransactionReceipt = await approveTxResponse.wait();
        const approveEvent = (approveTxReceipt.logs.find(log => {
          return tokenContract.interface.parseLog(log)?.name === "Approval"
        })) as Log;
        console.log();
        console.log("Owner address:", tokenContract.interface.parseLog(approveEvent)?.args[0]);
        console.log("Approved address:", tokenContract.interface.parseLog(approveEvent)?.args[1]);
        console.log("Token:", tokenContract.interface.parseLog(approveEvent)?.args[2]);
        console.log("Approving finished --------------");
    } catch (error: any) {
        console.error("Error during approve:", error);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });