// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

// Core
import "../src/core/UniswapV2Factory.sol";
import "../src/core/UniswapV2Pair.sol";

// Periphery
import "../src/periphery/UniswapV2Router02.sol";

// Test tokens
import "../src/test/ERC20Mock.sol";
import "../src/test/WETH9.sol";

contract UniswapV2Test is Test {
    UniswapV2Factory factory;
    UniswapV2Router02 router;
    WETH9 weth;
    address constant UNISWAP_V2_ROUTER_02 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    ERC20Mock tokenA;
    ERC20Mock tokenB;

    address deployer;

    function setUp() public {
        deployer = address(this);

        // Deploy WETH
        weth = new WETH9();
        console.log("WETH deployed at:", address(weth));

        // Deploy Factory
        factory = new UniswapV2Factory(deployer);
        console.log("Factory deployed at:", address(factory));

        //  Deploy Router
        router = new UniswapV2Router02(address(factory), address(weth));
        console.log("Router deployed at:", address(router));

        // Deploy test ERC20 tokens
        tokenA = new ERC20Mock("Token A", "TKA", 1_000_000 ether);
        tokenB = new ERC20Mock("Token B", "TKB", 1_000_000 ether);
        console.log("TokenA deployed at:", address(tokenA));
        console.log("TokenB deployed at:", address(tokenB));

        //  Approve router to spend tokens
        tokenA.approve(address(router), type(uint256).max);
        tokenB.approve(address(router), type(uint256).max);

        console.log("Deployer TokenA balance:", tokenA.balanceOf(deployer));
        console.log("Deployer TokenB balance:", tokenB.balanceOf(deployer));
    }

    function testAddLiquidity() public {
        // Add liquidity
        router.addLiquidity(
            address(tokenA),
            address(tokenB),
            1000 ether,
            1000 ether,
            990 ether,
            990 ether,
            deployer,
            block.timestamp + 3600
        );

        // Get the pair
        address pairAddress = factory.getPair(address(tokenA), address(tokenB));
        assertTrue(pairAddress != address(0), "PAIR_NOT_CREATED");
        UniswapV2Pair pair = UniswapV2Pair(pairAddress);

        // Check reserves
        (uint reserveA, uint reserveB,) = pair.getReserves();
        console.log("ReserveA:", reserveA);
        console.log("ReserveB:", reserveB);

        assertEq(reserveA, 1000 ether);
        assertEq(reserveB, 1000 ether);
    }

    function testSwapExactTokensForTokens() public {
        
        // Add liquidity first
        router.addLiquidity(
            address(tokenA),
            address(tokenB),
            1000 ether,
            1000 ether,
            990 ether,
            990 ether,
            deployer,
            block.timestamp + 3600
        );
        address pairAddress = factory.getPair(address(tokenA), address(tokenB));
        assertTrue(pairAddress != address(0), "PAIR_NOT_CREATED");
        uint lpBalance = UniswapV2Pair(pairAddress).balanceOf(deployer);
        uint totalSupply = UniswapV2Pair(pairAddress).totalSupply();
        
        console.log("LP balance:", lpBalance);
        console.log("LP totalSupply:", totalSupply);
        
        assertGt(lpBalance, 0);
        uint MINIMUM_LIQUIDITY = 1000;
        assertEq(totalSupply - lpBalance, MINIMUM_LIQUIDITY);

        // Swap 100 tokenA for tokenB
        uint amountIn = 100 ether;
        uint amountOutMin = 90 ether;

        // ✅ Create dynamic memory array for path
        address[] memory path = new address[](2);
        path[0] = address(tokenA);
        path[1] = address(tokenB);

        uint balanceBefore = tokenB.balanceOf(deployer);

        router.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            deployer,
            block.timestamp + 3600
        );

        uint balanceAfter = tokenB.balanceOf(deployer);
        console.log("TokenB received:", balanceAfter - balanceBefore);

        assert(balanceAfter > balanceBefore); // sanity check
    }
    function testGetAmountsOut_MatchesMainnetFork() public {
        uint amountIn = 1 ether;

        address[] memory path = new address[](2);
        path[0] = WETH;
        path[1] = DAI;
    
        uint[] memory quote = IUniswapV2Router02(UNISWAP_V2_ROUTER_02).getAmountsOut(amountIn, path);
        console.log("Quote on forked mainnet:", quote[1]);
    
        assertGt(quote[1], 0);
    }

}
