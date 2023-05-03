async function main() {
  const options = {
    gasLimit: 5000000, // set the gas limit to a higher value
  };
  const MedicalHealthRecord = await hre.ethers.getContractFactory("MedicalHealthRecord");
  const medicalhealthrecord = await MedicalHealthRecord.deploy(options);

  await medicalhealthrecord.deployed();

  console.log(`Contract deployed to ${medicalhealthrecord.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
