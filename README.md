## Crowd Funding IDO

## Traits

- The contract assumes token and IDO contract owner are same
- Token owner must approve at least the hardcap amount to Ido contract
- The contract deducts and holds tokens from erc20 owner's account when the user invests in IDO
- Funds are locked in contract until claim time
- If hardcap is not met, excess tokens can be burned by any user after sale ends

## Setup

**Recommended**

1. Create .env from example file
2. Install [pnpm](https://pnpm.io/installation)
   and [foundry](https://book.getfoundry.sh/getting-started/installation).
3. Run the following command in project root:

```shell
 pnpm deps
```

## Deploy

```shell
 pnpm deploy:<mumbai | fuji>
```

See `npx hardhat deploy --help` for more options

## Test Contract

```shell
 pnpm test
```

## Compile

```shell
 npx hardhat compile | forge compile
```

P.S: This code is un-audited and not to be used in production
