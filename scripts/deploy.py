from brownie import ERC721Soulbound, UpgradeableProxy, Contract, accounts

TOKEN_URI = "ipfs://bafkreifaslo26a6kjmvq33wz3lurutgrm4oy2adczctccy22ykpvrcb5b4"

def deploy(admin, publish=False):
    return token(admin, admin, admin, publish)

def token(admin, minter, proxy_admin, publish=False):
    # Deploy logic contract
    print("Deploying ERC721Soulbound contract...")
    logic = ERC721Soulbound.deploy({"from": accounts[0]}, publish_source=publish)
    # Deploy and initialize proxy contract
    initialize_call = logic.initialize.encode_input("Test Token", "TST", TOKEN_URI, admin, minter)
    print("Deploying UpgradeableProxy contract...")
    proxy = UpgradeableProxy.deploy(
        proxy_admin,
        logic,
        initialize_call,
        {"from": accounts[0]},
        publish_source=publish
    )
    token = Contract.from_abi("ERC721Soulbound", proxy.address, ERC721Soulbound.abi + UpgradeableProxy.abi)
    return token
