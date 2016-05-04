Differences between EVM on Ethereum and on CP
=============================================
We'll reference the EVM on Ethereum as ETHEVM and the EVM on CP as CPEVM

`block.prevhash`
----------------
ETHEVM `block.prevhash(0)` will return `0` because the contract is executed before the block is mined (afaik).
CPEVM `block.prevhash(0)` will return the current block, because the contract is not executed until the block is mined.