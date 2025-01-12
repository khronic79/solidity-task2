import { artifacts, ethers } from "hardhat";
import { Contract } from "ethers";

async function main() {

    const providerUrl = `https://polygon-amoy.infura.io/v3/` + process.env.INFURA_API_KEY;
    const provider = new ethers.JsonRpcProvider(providerUrl);
    const privateKey = process.env.PRIVATE_KEY as string;
    const tokenContractAddress: string = "0x6f05a50BA60A419F0E3AAFefaA2DE296a0911EcE";
    const spenderAddress: string = "0x2317D87e46691ECc6203514A4c43fd806db281ff";
    const amountToApprove: string = "262.89";

    const ownerWallet = new ethers.Wallet(privateKey, provider);

    const contractArtifacts = await artifacts.readArtifact("MyERC20Token");
    const contractABI = contractArtifacts.abi;
   
    const tokenContract = new ethers.Contract(
        tokenContractAddress,
        contractABI,
        ownerWallet
    ) as unknown as Contract;

    const decimals: number = await tokenContract.decimals();

    const amountToApproveWei = ethers.parseUnits(amountToApprove, decimals);

    try {
        const tx = await tokenContract.approve(spenderAddress, amountToApproveWei);
        await tx.wait();
        console.log(`Approved ${amountToApprove} tokens to ${spenderAddress} in transaction: ${tx.hash}`);
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