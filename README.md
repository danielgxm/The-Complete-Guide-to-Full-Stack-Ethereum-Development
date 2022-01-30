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

### 创建一个新的React应用程序

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

可以看到，生成了一批用来测试用的帐号和地址，每个地址里预先存入了10000个测试用Eth（这些Eth都是用来测试的测试币，没有实际的价值），将这些帐号信息保存到单独的文件中，稍后我们将把这些帐号导入Metamask，就可以用进行测试了。

### 打开metamask的测试网络

![](https://gitee.com/DanielGao/picture/raw/master/picture/20220130122442.png)

把网络切换到`Localhost：8545`。

![](https://gitee.com/DanielGao/picture/raw/master/picture/xo46g1vi1183hsixq1op.jpeg)

### 把合约部署到本地测试网上

在此之前，先把**scripts/sample-script.js** 名称修改为 **scripts/deploy.js**。

通过以下操作将合约部署到本地测试网，localhost参数表明是要部署到本地测试网。

```js
npx hardhat run scripts/deploy.js --network localhost
```

执行成功后，智能合约就被部署到了本地测试网上，cli会输出合约在区块链上的地址

```js
Greeter deployed to: 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
```

保存好该地址，我们的前端程序将要使用该地址与智能合约进行交互。

> 当合约被成功部署后，它使用了我们启动本地网络时创建的第一个帐户。

要和本地测试网上的合约进行交互，我们需要将前边自动生成的账户（该地址里有测试用的Eth）导入Metamask中，然后通过Metamask与合约进行交互。

![](https://gitee.com/DanielGao/picture/raw/master/picture/96qsky18d9pb964u2udc.jpeg)

现在我们有了一个部署在链上的智能合约，以及一个测试账户。

接下来，我们将使用react的前端与智能合约进行交互。

### 与前端一起工作

在该教程中，我们不会关注UI的美观程度，我们始终关注的是功能的完整性。

将要实现的两个功能：

1. 获取greeting的当前值

2. 授权一个用户可以修改greeting的值

可以分解为以下三个子功能：

1. 创建一个输入域和一些`local state`管理输入值

2. 允许程序连接到当前账户并签署事物

3. 创建可以读写智能合约的函数

打开`src/app.js`，输入以下代码，并将greeterAddress的值设置为已经部署好的智能合约的地址。

```js
import './App.css';
import { useState } from 'react';
import { ethers } from 'ethers'
import Greeter from './artifacts/contracts/Greeter.sol/Greeter.json'

// Update with the contract address logged out to the CLI when it was deployed 
const greeterAddress = "your-contract-address"

function App() {
  // store greeting in local state
  const [greeting, setGreetingValue] = useState()

  // request access to the user's MetaMask account
  async function requestAccount() {
    await window.ethereum.request({ method: 'eth_requestAccounts' });
  }

  // call the smart contract, read the current greeting value
  async function fetchGreeting() {
    if (typeof window.ethereum !== 'undefined') {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      const contract = new ethers.Contract(greeterAddress, Greeter.abi, provider)
      try {
        const data = await contract.greet()
        console.log('data: ', data)
      } catch (err) {
        console.log("Error: ", err)
      }
    }    
  }

  // call the smart contract, send an update
  async function setGreeting() {
    if (!greeting) return
    if (typeof window.ethereum !== 'undefined') {
      await requestAccount()
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner()
      const contract = new ethers.Contract(greeterAddress, Greeter.abi, signer)
      const transaction = await contract.setGreeting(greeting)
      await transaction.wait()
      fetchGreeting()
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <button onClick={fetchGreeting}>Fetch Greeting</button>
        <button onClick={setGreeting}>Set Greeting</button>
        <input onChange={e => setGreetingValue(e.target.value)} placeholder="Set greeting" />
      </header>
    </div>
  );
}

export default App;
```

### 测试前端功能

```js
npm start
```

当应用程序加载时，你应该能够获取到greeing的当前值，并将其输出到控制台。您还应该能够使用MetaMask钱包签署合约事物并使用测试Eth来更新greeting的值。

![](https://gitee.com/DanielGao/picture/raw/master/picture/9a57jbzrwylr2l0rujxm.jpeg)

### 将智能合约部署到以太坊的测试网上

以太坊有好几个测试网：Ropsten, Rinkeby, or Kovan。我们可以将合约部署到这些测试网上，以便可以在不部署到主网的情况下获取到一个公开可访问的版本。

在本教程中，我们将部署到Ropsten测试网络。

首先将网络切换到Ropsten。

![](https://gitee.com/DanielGao/picture/raw/master/picture/086v4ko9t6vkq64pdfzd.jpeg)

接下来，访问这个[测试水龙头](https://faucet.ropsten.be)，给自己发送一些Ropsten上的测试以太币，以便在本教程的其余部分使用。

我们可以通过注册像[Infura](https://infura.io)或[Alchemy](https://www.alchemy.com/)这样的服务来访问Ropsten(或其他任何测试网络)(本教程中使用Infura)

一旦你在Infura或Alchemy中创建了应用，你会得到一个链接，看起来像这样:

```js
https://ropsten.infura.io/v3/your-project-id
```

确保将你用来部署智能合约的钱包地址添加到infura/Alchemy的App设置中的`ALLOWLIST ETHEREUM ADDRESSES`变量中。

为了将合约部署到测试网中，我们需要将一些额外的网络信息添加到hardhat的配置中来，其中一个就是我们将要用来部署合约的钱包的私钥。

### 导出私钥

![](https://gitee.com/DanielGao/picture/raw/master/picture/6z0jfvs81xfjqostzca6.png)

> 最好不要把私钥直接硬编码到程序中，而是将其保存在其他地方，比如环境变量，然后从程序中读取。

然后使用以下代码添加一个网络配置项。

```js
module.exports = {
  defaultNetwork: "hardhat",
  paths: {
    artifacts: './src/artifacts',
  },
  networks: {
    hardhat: {},
    ropsten: {
      url: "https://ropsten.infura.io/v3/your-project-id",
      accounts: [`0x${your-private-key}`]
    }
  },
  solidity: "0.8.4",
};
```

### 将智能合约部署到公开测试网

```js
npx hardhat run scripts/deploy.js --network ropsten
```

一旦合约部署成功，你就可以和它进行交互了。你现在应该可以在[Etherscan Ropsten Testnet Explorer](https://ropsten.etherscan.io/)上查看部署后的合约了。

### 发行Token

智能合约最常见的用例之一是发行Token，让我们看看如何做到这一点。我们对原理了解的越多，我们就会走得更快、更远。

在`contracts`目录下创建一个名为`Token.sol`的文件。然后在文件中写入以下代码：

```solidity
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Token {
  string public name = "Daniel Gao Token";
  string public symbol = "DGT";
  uint public totalSupply = 1000000;
  mapping(address => uint) balances;

  constructor() {
    balances[msg.sender] = totalSupply;
  }

  function transfer(address to, uint amount) external {
    require(balances[msg.sender] >= amount, "Not enough tokens");
    balances[msg.sender] -= amount;
    balances[to] += amount;
  }

  function balanceOf(address account) external view returns (uint) {
    return balances[account];
  }
}
```

以上代码仅作为演示的作用，并不符合ERC20标准。我们将在下文讲解ERC20标准。

这个合约将发行一个名为`DGT`的Token，总量为1_000_000枚。

编译合约。

```
npx hardhat compile
```

在**scripts/deploy.js**中更新部署脚本，将新合约包含进去。

```js
const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log(
    "Deploying contracts with the account:",
    deployer.address
  );

  const Greeter = await hre.ethers.getContractFactory("Greeter");
  const greeter = await Greeter.deploy("Hello, World!");

  const Token = await hre.ethers.getContractFactory("Token");
  const token = await Token.deploy();

  await greeter.deployed();
  await token.deployed();

  console.log("Greeter deployed to:", greeter.address);
  console.log("Token deployed to:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

```

现在，可以将新的合约部署到本地测试网或Ropsten测试网上。

```js
npx hardhat run scripts/deploy.js --network localhost
```

合约部署成功后，你就可以将该Token发送给其他地址了。

现在，让我们为前端程序添加相应的功能，用来完成对应的业务。

```js
import './App.css';
import { useState } from 'react';
import { ethers } from 'ethers'
import Greeter from './artifacts/contracts/Greeter.sol/Greeter.json'
import Token from './artifacts/contracts/Token.sol/Token.json'

const greeterAddress = "your-contract-address"
const tokenAddress = "your-contract-address"

function App() {
  const [greeting, setGreetingValue] = useState()
  const [userAccount, setUserAccount] = useState()
  const [amount, setAmount] = useState()

  async function requestAccount() {
    await window.ethereum.request({ method: 'eth_requestAccounts' });
  }

  async function fetchGreeting() {
    if (typeof window.ethereum !== 'undefined') {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      console.log({ provider })
      const contract = new ethers.Contract(greeterAddress, Greeter.abi, provider)
      try {
        const data = await contract.greet()
        console.log('data: ', data)
      } catch (err) {
        console.log("Error: ", err)
      }
    }    
  }

  async function getBalance() {
    if (typeof window.ethereum !== 'undefined') {
      const [account] = await window.ethereum.request({ method: 'eth_requestAccounts' })
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const contract = new ethers.Contract(tokenAddress, Token.abi, provider)
      const balance = await contract.balanceOf(account);
      console.log("Balance: ", balance.toString());
    }
  }

  async function setGreeting() {
    if (!greeting) return
    if (typeof window.ethereum !== 'undefined') {
      await requestAccount()
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      console.log({ provider })
      const signer = provider.getSigner()
      const contract = new ethers.Contract(greeterAddress, Greeter.abi, signer)
      const transaction = await contract.setGreeting(greeting)
      await transaction.wait()
      fetchGreeting()
    }
  }

  async function sendCoins() {
    if (typeof window.ethereum !== 'undefined') {
      await requestAccount()
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(tokenAddress, Token.abi, signer);
      const transation = await contract.transfer(userAccount, amount);
      await transation.wait();
      console.log(`${amount} Coins successfully sent to ${userAccount}`);
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <button onClick={fetchGreeting}>Fetch Greeting</button>
        <button onClick={setGreeting}>Set Greeting</button>
        <input onChange={e => setGreetingValue(e.target.value)} placeholder="Set greeting" />

        <br />
        <button onClick={getBalance}>Get Balance</button>
        <button onClick={sendCoins}>Send Coins</button>
        <input onChange={e => setUserAccount(e.target.value)} placeholder="Account ID" />
        <input onChange={e => setAmount(e.target.value)} placeholder="Amount" />
      </header>
    </div>
  );
}

export default App;

```

运行程序

```
npm start
```

我们应该可以点击`Get Balance`，然后在console中看到我们的1_000_000枚Token。

将Token导入Metamask中后，应该也能看到Token的数量。

![](https://gitee.com/DanielGao/picture/raw/master/picture/m3ccxkvae2i7iewalbrk.jpg)

### 发送Token

复制另一个帐户的地址，并使用更新后的React UI将Token发送到该地址。当您检查Token余额时，它应该等于原始数量减去您发送到该地址的数量。

### ERC20 Token

[ERC20令牌标准](https://ethereum.org/en/developers/docs/standards/tokens/erc-20/)定义了一组适用于所有ERC20令牌的规则，使它们能够轻松地相互交互。ERC20让人们可以很容易地铸造自己的代币，这些代币将与以太坊区块链上的其他人发行的Token具有互操作性。

接下来我们将要探索如何发行我们自己的ERC20 Token。

### 安装智能合约库文件

安装OpenZepplin智能合约库。

```js
npm install @openzeppelin/contracts
```

将该库中的基础ERC20 token合约库导入我们的文件中。

我们将继承该标准，发行我们自己的Erc20 Token。

```solidty
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NDToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 100000 * (10 ** 18));
    }
}

```



构造函数constructor允许您在部署智能合约时初始化Token名称和Token标识，_mint函数允许您发行Token并设置数量。

默认情况下，ERC20将小数位数设置为18(1 Eth=10的18次方wei)，因此在_mint函数中，我们将100,000乘以10的18次方，总共铸造100,000个代币，每个代币有18个小数点位。

为了能够部署合约，我们需要为构造函数传递参数：name和symbol，将在部署脚本中添加以下代码：

```js
const NDToken = await hre.ethers.getContractFactory("NDToken");
const ndToken = await NDToken.deploy("Nader Dabit Token", "NDT");
```

我们的ERC20标准智能合约需要继承和实现接口文件中所有方法：

```solidty
function name() public view returns (string)
function symbol() public view returns (string)
function decimals() public view returns (uint8)
function totalSupply() public view returns (uint256)
function balanceOf(address _owner) public view returns (uint256 balance)
function transfer(address _to, uint256 _value) public returns (bool success)
function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
function approve(address _spender, uint256 _value) public returns (bool success)
function allowance(address _owner, address _spender) public view returns (uint256 remaining)
```

部署成功后，就可以和新合约进行交互了。

[ERC20标准的其他示例]([ERC20 | Solidity by Example | 0.8.10](https://solidity-by-example.org/app/erc20/)[ERC20 | Solidity by Example | 0.8.10](https://solidity-by-example.org/app/erc20/))

### 总结

以上就是本教程所有的内容，很简单，但是很重要，它告诉你该使用什么工具、如何开发、部署、使用一个solidity智能合约程序（Dapp）。希望对你有所帮助。

如果你想使用MetaMask之外的钱包管理软件，请查看[Web3Modal]([GitHub - Web3Modal/web3modal: A single Web3 / Ethereum provider solution for all Wallets](https://github.com/Web3Modal/web3modal))，它通过一个相当简单和可定制的配置，很容易地在你的应用程序中实现对多个钱包管理软件的支持。

在我未来的教程和指南中，我将深入研究更复杂的智能合约开发，以及如何将它们部署为子图，并在其上公开一个GraphQL API，实现分页和全文搜索等功能。

我还将介绍如何使用IPFS和Web3数据库等技术以分布式的方式存储数据。

如果您对未来的教程有任何问题或建议，请留下一些评论并让我知道。谢谢！
