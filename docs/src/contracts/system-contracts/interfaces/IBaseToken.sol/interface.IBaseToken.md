# IBaseToken
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IBaseToken.sol)


## Functions
### balanceOf


```solidity
function balanceOf(uint256) external view returns (uint256);
```

### transferFromTo


```solidity
function transferFromTo(address _from, address _to, uint256 _amount) external;
```

### totalSupply


```solidity
function totalSupply() external view returns (uint256);
```

### name


```solidity
function name() external pure returns (string memory);
```

### symbol


```solidity
function symbol() external pure returns (string memory);
```

### decimals


```solidity
function decimals() external pure returns (uint8);
```

### mint


```solidity
function mint(address _account, uint256 _amount) external;
```

### withdraw


```solidity
function withdraw(address _l1Receiver) external payable;
```

### withdrawWithMessage


```solidity
function withdrawWithMessage(
  address _l1Receiver,
  bytes calldata _additionalData
) external payable;
```

## Events
### Mint

```solidity
event Mint(address indexed account, uint256 amount);
```

### Transfer

```solidity
event Transfer(address indexed from, address indexed to, uint256 value);
```

### Withdrawal

```solidity
event Withdrawal(
  address indexed _l2Sender, address indexed _l1Receiver, uint256 _amount
);
```

### WithdrawalWithMessage

```solidity
event WithdrawalWithMessage(
  address indexed _l2Sender,
  address indexed _l1Receiver,
  uint256 _amount,
  bytes _additionalData
);
```

