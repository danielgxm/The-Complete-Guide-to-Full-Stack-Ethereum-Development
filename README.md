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

## 1. Ethereum 开发环境

在构建智能合约时，你需要一种在测试环境下部署合约、运行测试和调试代码的方法可靠方法。

您还需要一种方法来将Solidity代码编译成可以在客户端应用程序中运行的代码——在我们的例子中是React。稍后我们将进一步了解它的工作原理。

Hardhat是一个以太坊开发环境和框架，专为全栈开发而设计，也是我将在本教程中使用的框架。

生态系统中的其他类似工具还有Ganache、Truffle和Foundry。

## 2. Ethereum Web客户端库

在我们的React应用程序中，我们需要一种与已部署的智能合约交互的方式。我们需要一种读取数据以及发送事务的方法。

Ethers.js旨在成为一个完整而紧凑的库，用于从客户端JavaScript应用程序（如React、Vue、Angular或Svelte）与以太坊区块链及其生态系统进行交互。这就是我们将要使用的library。

生态系统中另一个流行的选项是web3.js。

## 3. Metarmask

Metamask用来进行帐户管理，并将当前用户连接到区块链。MetaMask允许用户以几种不同的方式管理他们的帐户和密钥，同时将它们与站点上下文进行隔离。

一旦用户连接了MetaMask钱包，作为开发人员，您可以与全球所有可用的以太坊API（window.Ethereum）进行交互，该API可识别兼容web3的浏览器的用户（如MetaMask用户），并且每当您请求事务签名时，MetaMask将以尽可能容易理解的方式提示用户。

## 4. React

React是用于构建Web应用程序，用户界面和UI组件的前端JavaScript库。它由Facebook和许多个人开发人员和公司维护。

React及其庞大的元框架生态系统，如 Next.js、 Gatsby、Redwood、 Blitz.js 等，支持所有类型的部署目标，包括传统的 spa、静态站点生成器、服务器端呈现，以及三者的结合。
React似乎将继续主导前端领域，至少在不久的将来，依然会是这样。

## 5. The Graph

对于以太坊（Ethereum）等区块链上构建的大多数应用来说，直接从区块链读取数据既困难又耗时，因此你过去常常看到个人开发者和公司自己构建的中心化索引服务器，并为这些服务器提供API请求服务。这需要大量的工程和硬件资源，并破坏了去中心化所需的安全属性。

The Graph解决了这个问题，它是一个用于查询区块链数据的索引协议，它支持创建完全去中心化的应用程序，提供了一个应用程序可以使用的丰富的 GraphQL 查询层。在本指南中，我们不会为我们的应用程序构建子图，但在以后的教程中会这样做。

教程：如何使用The Graph创建区块链API