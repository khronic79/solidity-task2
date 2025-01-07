import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const MyERC721TokenModule = buildModule("MyERC721TokenModule", (m) => {

  const mytoken = m.contract("MyERC721Token");

  return { mytoken };
});

export default MyERC721TokenModule;
