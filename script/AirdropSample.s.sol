// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {AirdropSample} from "../src/AirdropSample.sol";
import {AirdropToken} from "../src/AirdropToken.sol";

contract AirdropScript is Script {
    AirdropSample public airdrop;
    AirdropToken public token;
    string private constant TOKEN_NAME = "DEMO";
    string public constant TOKEN_SYMBOL = "DEMO";
    uint256 private constant LIMIT = 1000;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        token = new AirdropToken(TOKEN_NAME, TOKEN_SYMBOL, LIMIT);
        airdrop = new AirdropSample(LIMIT, token);

        vm.stopBroadcast();
    }
}
