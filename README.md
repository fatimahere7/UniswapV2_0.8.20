# Uniswap V2 — Solidity 0.8.20

A Solidity implementation of **Uniswap V2**, with the core V2 contracts updated to **Solidity ^0.8.20**. The project includes deployment scripts and tests for the Uniswap V2 protocol.

## 🚀 Features

- 🦄 Uniswap V2 core contracts
- 🔄 Token swapping and liquidity management
- 💧 Liquidity pools
- 🏦 ERC20 token support
- 🧪 Smart contract testing with Foundry
- 🚀 Deployment scripts
- ⛓️ Mainnet testing and contract interaction

## 🛠️ Tech Stack

- **Solidity ^0.8.20**
- **Foundry**
- **Forge**
- **Ethereum**
- **ERC20**
- **Git Submodules**

## 📁 Project Structure

```text
src/        → Uniswap V2 smart contracts
test/       → Smart contract tests
script/     → Deployment scripts
lib/        → External dependencies
broadcast/  → Deployment data
🎯 Project Goal

The goal of this project is to understand and implement the core concepts behind Uniswap V2, including automated market makers (AMMs), liquidity pools, token swaps, and decentralized exchange infrastructure using Solidity and Foundry.

⚙️ Setup
1. Clone the Repository
git clone <your-repository-url>
cd UniswapV2_0.8.20
2. Install Dependencies

Install the required Foundry dependencies:

forge install
3. Build the Contracts

Compile the Solidity smart contracts:

forge build
🧪 Testing

Run the complete test suite:

forge test
Run Tests with Detailed Output
forge test -vv
Run Tests with Maximum Debugging Information
forge test -vvvv
Run a Specific Test

Replace testFunctionName with the name of the test you want to run:

forge test --match-test testFunctionName
Run Tests from a Specific Contract

Replace ContractName with the name of the contract:

forge test --match-contract ContractName
🚀 Deployment

The deployment scripts can be executed using Foundry's forge script command.

forge script script/Deploy.s.sol --rpc-url <RPC_URL> --broadcast

Replace <RPC_URL> with your Ethereum RPC endpoint.

📚 Key Concepts

This project covers several important concepts in decentralized exchange development:

Automated Market Makers (AMMs)
Liquidity Pools
Constant Product Formula
Token Swapping
Liquidity Provision
ERC20 Tokens
Smart Contract Deployment
Foundry Testing
