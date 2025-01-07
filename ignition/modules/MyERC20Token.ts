import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const MyTokenModule = buildModule("MyTokenModule", (m) => {

  const mytoken = m.contract("MyERC20Token");

  return { mytoken };
});

export default MyTokenModule;
