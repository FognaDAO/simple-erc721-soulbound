# Simple ERC721 soulbound tokens
ERC721 upgradeable soulbound smart contract, written in [Solidity](https://docs.soliditylang.org/).

## Overview
Tokens on this contract are not transferrable. In case a token owner address is compromised, the token can be moved to an other address by an admin.

This contract implements access control with the following roles:

- **MINTER**: is allowed to:
    - Mint new tokens

- **ADMIN**: is allowed to:
    - Update tokens metadata
    - Assign the *MINTER* role to a new address
    - Transfer tokens on behalf of users (used for social recovery)

## Testing and Development
Clone this repo and `cd` into the directory to get started.

### Docker development environment
You can use [Docker](https://www.docker.com/) to test and interact with smart contracts in a local development environment without the burden of installing anything else.

```bash
# build development Docker image based on current source code
docker build -t soulbound-token .

# run tests with 'brownie test'
docker run soulbound-token test

# run interactive 'brownie console'
docker run -it soulbound-token
```

### Dependencies
If you don't like *Docker*, you can install development dependencies manually.

* [python3](https://www.python.org/downloads/release/python-368/) - tested with version 3.8.10
* [brownie](https://github.com/iamdefinitelyahuman/brownie) - tested with version 1.18.1
* [ganache-cli](https://github.com/trufflesuite/ganache-cli) - tested with version 6.12.2

We describe how to install development dependencies on Ubuntu 20.04, the same steps might apply to other operating systems.

We use [pipx](https://github.com/pypa/pipx) to install *Brownie* into a virtual environment and make it available directly from the commandline. You can also install *Brownie* via *pip*, in this case it is recommended to use a [virtual environment](https://docs.python.org/3/tutorial/venv.html). For more information about installing *Brownie* read the official [documentation](https://eth-brownie.readthedocs.io/en/stable/install.html#installing-brownie).

We use [node.js](https://nodejs.org/en/) and [npm](https://www.npmjs.com/) to install *ganache-cli* globally. We recommend installing the latest LTS versions of *node* and *npm* from [nvm](https://github.com/nvm-sh/nvm#installing-and-updating) as we find versions in Ubuntu and Debian repositories to have [this](https://askubuntu.com/questions/1161494/npm-version-is-not-compatible-with-node-js-version) problem frequently.

```bash
sudo apt install curl gcc python3 python3-dev python3-venv pipx
pipx ensurepath

#install nvm
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.profile

# install node and npm using nvm
nvm install --lts=Gallium

# install ganache-cli
npm install ganache-cli@6.12.2 --global

# install brownie
pipx install eth-brownie==1.18.1
```

### Running tests
Test scripts are stored in the `tests/` directory of this project.

Use `brownie test` to run the complete test suite.

```bash
brownie test
```
