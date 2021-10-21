import { ethers } from "hardhat";
import { Signer, BigNumber } from "ethers";
import { Contract, ContractFactory } from 'ethers';
import { expect } from "chai";
import {
  UniswapTest,
  UniswapTest__factory,
} from "../typechain";

describe("UniswapTest", () => {
  let signers: Signer[],
    admin: Signer,
    adminAddress: string,
    uniswapTestFactory: UniswapTest__factory,
    uniswapTest: UniswapTest;

  beforeEach(async () => {
    // get signers array
    signers = await ethers.getSigners();
    // pull out 1 signer as our admin
    admin = signers[0];
    // get admin's address
    adminAddress = await admin.getAddress();
    // get contact factorties
    [uniswapTestFactory] = await Promise.all([
      ethers.getContractFactory(
        "UniswapTest",
        admin
      ) as Promise<UniswapTest__factory>
    ]);
    // get contacts
    [uniswapTest] = await Promise.all([
      uniswapTestFactory.deploy()
    ]);

    // const minterRole = await uniswapTest.MINTER_ROLE();
    // await uniswapTest.grantRole(minterRole, signer[1].address);

  });

  it("Pundix To Eth Swap", async () => {
    (await uniswapTest.swapCocosToPundix(5, { from: "0x3f5CE5FBFe3E9af3971dD833D26bA9b5C936f0bE" })).wait(6);

    (await uniswapTest.swapPundixToWeth(5, { from: "0x3f5CE5FBFe3E9af3971dD833D26bA9b5C936f0bE" })).wait(6);
  });

  // it("computes UniswapV2 pair addresses", async () => {
  //   // compute weth-token pairs
  //   const pairsComputed = await Promise.all(
  //     tokens.map(
  //       async (token) => await challenge.getUniswapV2PairAddress(weth, token)
  //     )
  //   );
  //   // add 1 non-weth pair
  //   pairsComputed.push(
  //     await challenge.getUniswapV2PairAddress(tokens[3], tokens[4])
  //   );
  //   expect(pairsComputed[0]).to.eq(pairsCorrect[0]);
  //   expect(pairsComputed[1]).to.eq(pairsCorrect[1]);
  //   expect(pairsComputed[2]).to.eq(pairsCorrect[2]);
  //   expect(pairsComputed[3]).to.eq(pairsCorrect[3]);
  //   expect(pairsComputed[4]).to.eq(pairsCorrect[4]);
  //   expect(pairsComputed[5]).to.eq(pairsCorrect[5]);
  // });
});
