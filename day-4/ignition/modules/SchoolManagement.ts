import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SchoolManagementModule = buildModule("SchoolManagementModule", (m) => {
  // this is the ERC20 token address you want to use for payments
  const tokenAddress = m.getParameter(
    "tokenAddress",
    " " // replace with your ERC20 token address on Lisk Sepolia
  );

  const schoolManagement = m.contract("SchoolManagement", [tokenAddress]);

  return { schoolManagement };
});

export default SchoolManagementModule;