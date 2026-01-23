// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

// Core
import "../src/core/UniswapV2Factory.sol";
import "../src/core/UniswapV2ERC20.sol";
import "../src/core/UniswapV2Pair.sol";

// Periphery
import "../src/periphery/UniswapV2Router02.sol";

// Interfaces / Helpers
import "../src/interfaces/IWETH.sol";

// Test tokens
import "../src/test/ERC20Mock.sol";
import "../src/test/WETH9.sol";

contract DeployV2 is Script {
    function run() external {
        vm.startBroadcast();

        // 1️⃣ Deploy WETH
        WETH9 weth = new WETH9();
        console.log("WETH deployed at:", address(weth));

        // 2️⃣ Deploy Factory
        UniswapV2Factory factory = new UniswapV2Factory(msg.sender);
        console.log("Factory deployed at:", address(factory));

        // 3️⃣ Deploy Router
        UniswapV2Router02 router = new UniswapV2Router02(
            address(factory),
            address(weth)
        );
        console.log("Router deployed at:", address(router));

        // 4️⃣ Deploy two test ERC20 tokens
        ERC20Mock tokenA = new ERC20Mock("Token A", "TKA", 1_000_000 ether);
        ERC20Mock tokenB = new ERC20Mock("Token B", "TKB", 1_000_000 ether);
        console.log("TokenA deployed at:", address(tokenA));
        console.log("TokenB deployed at:", address(tokenB));

        vm.stopBroadcast();
    }
}
