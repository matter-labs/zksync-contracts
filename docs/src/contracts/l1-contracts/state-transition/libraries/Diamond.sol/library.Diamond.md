# Diamond
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/libraries/Diamond.sol)

**Author:**
Matter Labs

The helper library for managing the EIP-2535 diamond proxy.

**Note:**
security-contact: security@matterlabs.dev


## State Variables
### DIAMOND_INIT_SUCCESS_RETURN_VALUE
*Magic value that should be returned by diamond cut initialize contracts.*

*Used to distinguish calls to contracts that were supposed to be used as diamond initializer from other contracts.*


```solidity
bytes32 internal constant DIAMOND_INIT_SUCCESS_RETURN_VALUE =
  0x33774e659306e47509050e97cb651e731180a42d458212294d30751925c551a2;
```


### DIAMOND_STORAGE_POSITION
*Storage position of `DiamondStorage` structure.*


```solidity
bytes32 private constant DIAMOND_STORAGE_POSITION =
  0xc8fcad8db84d3cc18b4c41d551ea0ee66dd599cde068d998e57d5e09332c131b;
```


## Functions
### getDiamondStorage


```solidity
function getDiamondStorage()
  internal
  pure
  returns (DiamondStorage storage diamondStorage);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`diamondStorage`|`DiamondStorage`|The pointer to the storage where all specific diamond proxy parameters stored|


### diamondCut

*Add/replace/remove any number of selectors and optionally execute a function with delegatecall*


```solidity
function diamondCut(DiamondCutData memory _diamondCut) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_diamondCut`|`DiamondCutData`|Diamond's facet changes and the parameters to optional initialization delegatecall|


### _addFunctions

*Add new functions to the diamond proxy
NOTE: expect but NOT enforce that `_selectors` is NON-EMPTY array*


```solidity
function _addFunctions(
  address _facet,
  bytes4[] memory _selectors,
  bool _isFacetFreezable
) private;
```

### _replaceFunctions

*Change associated facets to already known function selectors
NOTE: expect but NOT enforce that `_selectors` is NON-EMPTY array*


```solidity
function _replaceFunctions(
  address _facet,
  bytes4[] memory _selectors,
  bool _isFacetFreezable
) private;
```

### _removeFunctions

*Remove association with function and facet
NOTE: expect but NOT enforce that `_selectors` is NON-EMPTY array*


```solidity
function _removeFunctions(address _facet, bytes4[] memory _selectors) private;
```

### _saveFacetIfNew

*Add address to the list of known facets if it is not on the list yet
NOTE: should be called ONLY before adding a new selector associated with the address*


```solidity
function _saveFacetIfNew(address _facet) private;
```

### _addOneFunction

*Add one function to the already known facet
NOTE: It is expected but NOT enforced that:
- `_facet` is NON-ZERO address
- `_facet` is already stored address in `DiamondStorage.facets`
- `_selector` is NOT associated by another facet*


```solidity
function _addOneFunction(
  address _facet,
  bytes4 _selector,
  bool _isSelectorFreezable
) private;
```

### _removeOneFunction

*Remove one associated function with facet
NOTE: It is expected but NOT enforced that `_facet` is NON-ZERO address*


```solidity
function _removeOneFunction(address _facet, bytes4 _selector) private;
```

### _removeFacet

*remove facet from the list of known facets
NOTE: It is expected but NOT enforced that there are no selectors associated with `_facet`*


```solidity
function _removeFacet(address _facet) private;
```

### _initializeDiamondCut

*Delegates call to the initialization address with provided calldata*

*Used as a final step of diamond cut to execute the logic of the initialization for changed facets*


```solidity
function _initializeDiamondCut(address _init, bytes memory _calldata) private;
```

## Events
### DiamondCut

```solidity
event DiamondCut(FacetCut[] facetCuts, address initAddress, bytes initCalldata);
```

## Structs
### SelectorToFacet
*Utility struct that contains associated facet & meta information of selector*


```solidity
struct SelectorToFacet {
  address facetAddress;
  uint16 selectorPosition;
  bool isFreezable;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`facetAddress`|`address`|address of the facet which is connected with selector|
|`selectorPosition`|`uint16`|index in `FacetToSelectors.selectors` array, where is selector stored|
|`isFreezable`|`bool`|denotes whether the selector can be frozen.|

### FacetToSelectors
*Utility struct that contains associated selectors & meta information of facet*


```solidity
struct FacetToSelectors {
  bytes4[] selectors;
  uint16 facetPosition;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`selectors`|`bytes4[]`|list of all selectors that belong to the facet|
|`facetPosition`|`uint16`|index in `DiamondStorage.facets` array, where is facet stored|

### DiamondStorage
The structure that holds all diamond proxy associated parameters

*According to the EIP-2535 should be stored on a special storage key - `DIAMOND_STORAGE_POSITION`*


```solidity
struct DiamondStorage {
  mapping(bytes4 selector => SelectorToFacet selectorInfo) selectorToFacet;
  mapping(address facetAddress => FacetToSelectors facetInfo) facetToSelectors;
  address[] facets;
  bool isFrozen;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`selectorToFacet`|`mapping(bytes4 selector => SelectorToFacet selectorInfo)`|A mapping from the selector to the facet address and its meta information|
|`facetToSelectors`|`mapping(address facetAddress => FacetToSelectors facetInfo)`|A mapping from facet address to its selectors with meta information|
|`facets`|`address[]`|The array of all unique facet addresses that belong to the diamond proxy|
|`isFrozen`|`bool`|Denotes whether the diamond proxy is frozen and all freezable facets are not accessible|

### FacetCut
*Parameters for diamond changes that touch one of the facets*


```solidity
struct FacetCut {
  address facet;
  Action action;
  bool isFreezable;
  bytes4[] selectors;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`facet`|`address`|The address of facet that's affected by the cut|
|`action`|`Action`|The action that is made on the facet|
|`isFreezable`|`bool`|Denotes whether the facet & all their selectors can be frozen|
|`selectors`|`bytes4[]`|An array of unique selectors that belongs to the facet address|

### DiamondCutData
*Structure of the diamond proxy changes*


```solidity
struct DiamondCutData {
  FacetCut[] facetCuts;
  address initAddress;
  bytes initCalldata;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`facetCuts`|`FacetCut[]`|The set of changes (adding/removing/replacement) of implementation contracts|
|`initAddress`|`address`|The address that's delegate called after setting up new facet changes|
|`initCalldata`|`bytes`|Calldata for the delegate call to `initAddress`|

## Enums
### Action
*Type of change over diamond: add/replace/remove facets*


```solidity
enum Action {
  Add,
  Replace,
  Remove
}
```

