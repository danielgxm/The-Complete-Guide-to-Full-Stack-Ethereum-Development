# 以太坊全栈开发技术指南

## 使用React,Ether.js,Solidity和Hardhat创建DApps

在本教程中，你将学习如何使用全栈技术在多条区块链上进行DApp的开发，这些区块链包括：Ethereum,Polygon,Avanlanche,Celo等兼容EVM的区块链。

我最近比较了很多的技术栈，以下是我认为和Solidty配合的最好的开发DApp的全栈技术。

- Client Framework - React
- Ethereum development environment - Hardhat
- Ethereum Web Client Libray - Ethers.js
- API layer - The Graph Protocol

我在学习时遇到的问题是，每个技术栈的帮助文档都很好，但是没有一个完整的案例可以让我了解他们彼此如何配合才可以进行更好地开发。有一些非常好的脚手架程序，比如scaffold-eth（它也包括ethers，Hardhat和The Graph），但是对于刚开始入门的新手来说又似乎太复杂了。

我需要一个工程级别的指导，来向我展示如何使用最好的技术栈进行Ethereum的全栈开发。

我最感兴趣的事情是：

- 如何在本地、测试网、主网上开发、部署和测试Ethereum智能合约。
- 如何在本地、测试网和主网（生产环境）之间进行切换。
- 如何使用多种前端环境连接并与智能合约进行交互，比如React, Vue, Svelte和Angular。

在花了一些时间弄清楚所有这些，并开始使用我非常满意的技术栈之后，写一篇关于如何使用这个技术栈构建和测试一个完整的以太坊应用程序的文章是必要的，不仅对其他可能对这个技术栈感兴趣的人有用，而且对我自己也有用，以供将来参考。

## 技术栈速览

### 1. Ethereum 开发环境

在构建智能合约时，你需要一种在测试环境下部署合约、运行测试和调试代码的方法可靠方法。

您还需要一种方法来将Solidity代码编译成可以在客户端应用程序中运行的代码——在我们的例子中是React。稍后我们将进一步了解它的工作原理。

Hardhat是一个以太坊开发环境和框架，专为全栈开发而设计，也是我将在本教程中使用的框架。

生态系统中的其他类似工具还有Ganache、Truffle和Foundry。

### 2. Ethereum Web客户端库

在我们的React应用程序中，我们需要一种与已部署的智能合约交互的方式。我们需要一种读取数据以及发送事务的方法。

Ethers.js旨在成为一个完整而紧凑的库，用于从客户端JavaScript应用程序（如React、Vue、Angular或Svelte）与以太坊区块链及其生态系统进行交互。这就是我们将要使用的library。

生态系统中另一个流行的选项是web3.js。

### 3. Metarmask

Metamask用来进行帐户管理，并将当前用户连接到区块链。MetaMask允许用户以几种不同的方式管理他们的帐户和密钥，同时将它们与站点上下文进行隔离。

一旦用户连接了MetaMask钱包，作为开发人员，您可以与全球所有可用的以太坊API（window.Ethereum）进行交互，该API可识别兼容web3的浏览器的用户（如MetaMask用户），并且每当您请求事务签名时，MetaMask将以尽可能容易理解的方式提示用户。

### 4. React

React是用于构建Web应用程序，用户界面和UI组件的前端JavaScript库。它由Facebook和许多个人开发人员和公司维护。

React及其庞大的元框架生态系统，如 Next.js、 Gatsby、Redwood、 Blitz.js 等，支持所有类型的部署目标，包括传统的 spa、静态站点生成器、服务器端呈现，以及三者的结合。
React似乎将继续主导前端领域，至少在不久的将来，依然会是这样。

### 5. The Graph

对于以太坊（Ethereum）等区块链上构建的大多数应用来说，直接从区块链读取数据既困难又耗时，因此你过去常常看到个人开发者和公司自己构建的中心化索引服务器，并为这些服务器提供API请求服务。这需要大量的工程和硬件资源，并破坏了去中心化所需的安全属性。

The Graph解决了这个问题，它是一个用于查询区块链数据的索引协议，它支持创建完全去中心化的应用程序，提供了一个应用程序可以使用的丰富的 GraphQL 查询层。在本指南中，我们不会为我们的应用程序构建子图，但在以后的教程中会这样做。

[教程：如何使用The Graph创建区块链API]()

## 我们将要做什么？

**在这个教程里，我们将创建，部署和连接到多个简单地智能合约。**

1. 在Ethereum上创建和更新消息的合约。

2. 一个铸造代币的合同，然后允许合同的所有者向其他人发送代币并读取代币余额，并允许新代币的所有者也向其他人发送它们。

同时，我们将用React创建一个前端界面，允许用户进行以下操作：

1. 从部署到区块链上的合约里读取问候

2. 更新问候语

3. 将新铸造的代币从他们的地址发送到另一个地址

4. 收到代币的地址可以将代币发送给别的地址

5. 从部署在区块链上的合约里读取代币余额

## 准备工作

1. 安装Node.js

2. 为浏览器安装Metamask插件

我们整个项目将会在测试网上进行，所以你不需要真的ETH，使用测试网的测试币就可以了。

## 开始

### 创建一个新的React应用程序。

```bash
npx create-react-app react-dapp
```

导航到新创建的文件夹中，使用`npm`或者`yarn`安装`ethers.js`和`hardhat`。

```bash
npm install ethers hardhat @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers`
```

### 安装、配置Ethereum开发环境

使用`hardhat`初始化一个Ethereum开发环境。

```bash
npx hardhat

? What do you want to do? Create a sample project
? Hardhat project root: <Choose default path>`
```

现在你应该在文件夹的根目录看到以下工件：

**hardhat.config.js** - 整个Hardhat的设置(配置、插件和自定义任务)都包含在这个文件中

**scripts** - 包含名为sample-script.js文件的文件夹，它将在执行时部署你的智能合约

**test** - 包含一个测试脚本示例的文件夹

**contracts** - 包含一个Solidity智能合约示例的文件夹

**由于MetaMask的配置问题，我们需要将HardHat配置中的chain ID更新为1337。我们还需要更新已编译合约的工件的位置，使其位于React应用的src目录中。**

打开`hardhat.config.js`文件，更新`module.exports`，如下：

```js
module.exports = {
  solidity: "0.8.4",
  paths: {
    artifacts: './src/artifacts',
 },
  networks: {
    hardhat: {
      chainId: 1337
    }
  }
};
```

### 智能合约

让我们看一下自动生成的示例智能合约**contracts/Greeter.sol**的代码。

```solidity
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";


contract Greeter {
  string greeting;

  constructor(string memory _greeting) {
    console.log("Deploying a Greeter with greeting:", _greeting);
    greeting = _greeting;
  }

  function greet() public view returns (string memory) {
    return greeting;
  }

  function setGreeting(string memory _greeting) public {
    console.log("Changing greeting from '%s' to '%s'", greeting, _greeting);
    greeting = _greeting;
  }
}
```

这是一个非常基本的智能合约。它有一个Greeting变量，并公开一个函数greet，可以调用该函数来返回Greeting的值。

它还公开了一个函数setGreeting，允许用户更新greeting。当部署到以太坊区块链时，用户可以使用这些方法进行交互。

### 读写以太坊区块链

有两种与智能合约交互的方式：读或写/交易。在我们的合约中，greet可以被视为读，而setGreeting可以被视为写/事务性。

在写入或初始化事务时，必须为写入区块链的事务付费。为了实现这一点，你需要支付gas，这是在以太坊区块链上成功进行交易和执行合约所需的费用或价格。

如果你只是从区块链读取信息，而不是更改或添加任何东西，你就不需要执行交易，也无需支付gas或其他成本，你调用的函数只由你连接的节点执行，所以你不需要支付任何gas，读取是免费的。

在我们的React应用中，我们与智能合约的交互方式是使用ether .js库。合约地址和ABI，将由hardhat从合约中创建。

**什么是ABI?**

ABI代表应用程序二进制接口。您可以将其视为客户端应用程序和以太坊区块链之间的接口。

ABI通常由像HardHat这样的开发框架从Solidity智能合约中编译而来。你也可以经常在Etherscan上找到智能合约的ABI。

### 编译智能合约生成ABI

```bash
npx hardhat compile
```

现在，您应该在src目录中看到一个名为artifacts的新文件夹。artifacts/contracts/Greeter.json。json文件包含ABI作为属性之一。当我们需要使用ABI时，我们可以从JavaScript文件中导入它:

```js
import Greeter from './artifacts/contracts/Greeter.sol/Greeter.json'
```

可以这样引用ABI：

```js
console.log("Greeter ABI: ", Greeter.abi)
```

### 在本地区块链上部署智能合约

接下来，为了能够测试我们的智能合约，我们要把它布置到本地区块链上。

需要首先启动一个本地节点：

```bash
npx hardhat node
```

运行该命令后将会看到以下输出：

![](https://gitee.com/DanielGao/picture/raw/master/picture/e176nc82ik77hei3a48s.jpg)