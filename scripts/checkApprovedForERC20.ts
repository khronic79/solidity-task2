import { ethers, network, artifacts } from "hardhat";
import { Contract } from "ethers";

async function main() {
    const providerUrl = `https://polygon-amoy.infura.io/v3/` + process.env.INFURA_API_KEY;
    const tokenContractAddress: string = "0x6f05a50BA60A419F0E3AAFefaA2DE296a0911EcE";
    const ownerAddress: string = "0x5c8630069c6663e7Fa3eAAAB562e2fF4419e12f7";
    const spenderAddress: string = "0x2317D87e46691ECc6203514A4c43fd806db281ff";
    const provider = new ethers.JsonRpcProvider(providerUrl);

    const contractArtifacts = await artifacts.readArtifact("MyERC20Token");
    const abi = contractArtifacts.abi;

    const tokenContract = new ethers.Contract(
        tokenContractAddress,
        abi,
        provider
    ) as unknown as Contract;

    try {
        const allowance = await tokenContract.allowance(ownerAddress, spenderAddress);
        console.log(`Allowance of ${spenderAddress} for ${ownerAddress}: ${allowance}`);
    } catch (error: any) {
         console.error("Error during allowance call:", error);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });