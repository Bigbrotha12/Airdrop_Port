// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {AirdropSample} from "../src/AirdropSample.sol";
import {AirdropToken} from "../src/AirdropToken.sol";

contract AirdropTest is Test {
    AirdropSample public airdrop;
    AirdropToken public token;
    string private constant TOKEN_NAME = "DEMO";
    string public constant TOKEN_SYMBOL = "DEMO";
    uint256 private constant LIMIT = 1000;

    function setUp() public {
        token = new AirdropToken(TOKEN_NAME, TOKEN_SYMBOL, LIMIT);
        airdrop = new AirdropSample(LIMIT, token);
    }

    // function test_Increment() public {
    //     counter.increment();
    //     assertEq(counter.number(), 1);
    // }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
