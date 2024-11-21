import { ethers } from "ethers";
import hre from "hardhat";

async function main() {
  // 使用 Hardhat 的 ethers
  const provider = hre.ethers.provider;

  // 获取签名者
  const [sender] = await hre.ethers.getSigners();

  // 生成私钥和对应的钱包
  const wallets = Array.from({ length: 16 }, (_, i) => {
    const privateKey = `0x${'fa'.repeat(31)}${i.toString(16).padStart(2, '0')}`;
    return new ethers.Wallet(privateKey, provider);
  });

  // 转账金额（例如 0.1 ETH）
  const amount = ethers.parseEther("100");

  console.log("Sender address:", sender.address);
  console.log("Sender initial balance:", ethers.formatEther(await provider.getBalance(sender.address)), "ETH");

  // 用于存储所有交易的数组
  const transactions = [];

  for (let i = 0; i < wallets.length; i++) {
    const receiver = wallets[i];
    console.log(`\nSending transaction to wallet ${i + 1}:`);
    console.log("Receiver address:", receiver.address);

    // 发送交易
    const tx = await sender.sendTransaction({
      to: receiver.address,
      value: amount
    });

    console.log("Transaction sent:", tx.hash);
    
    // 将交易添加到数组中
    transactions.push(tx);
  }

  console.log("\nAll transactions sent. Waiting for confirmations...");

  // 等待所有交易被确认
  const receipts = await Promise.all(transactions.map(tx => tx.wait()));

  // 打印确认信息和接收方余额
  for (let i = 0; i < receipts.length; i++) {
    const receipt = receipts[i];
    const receiver = wallets[i];
    console.log(`\nTransaction ${i} confirmed in block:`, receipt.blockNumber);
    console.log("Receiver address:", receiver.address);
    console.log("Receiver balance:", ethers.formatEther(await provider.getBalance(receiver.address)), "ETH");
  }

  console.log("\nAll transfers completed.");
}

// 运行脚本
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});