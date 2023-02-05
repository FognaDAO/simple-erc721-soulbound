from pytest import fixture
from brownie import accounts
from scripts import deploy

@fixture(scope="module", autouse=True)
def token():
    token = deploy.token(accounts[0], accounts[0], accounts[0])
    token.mintBatch(accounts[0], 10, {"from": accounts[0]})
    return token

@fixture(autouse=True)
def isolation(fn_isolation):
    pass

def test_token_uri_update(token):
    new_uri = "ipfs://qwerty"
    assert token.tokenURI(1) == token.tokenURI(2) != new_uri
    token.setTokenURI(new_uri, {"from": accounts[0]})
    assert token.tokenURI(1) == token.tokenURI(2) == new_uri

def test_owner_of_batch(token):
    token.transferFrom(accounts[0], accounts[1], 2, {"from": accounts[0]})
    assert token.ownerOfBatch([1, 2, 3]) == [accounts[0], accounts[1], accounts[0]]

def test_supports_interface(token):
    assert not token.supportsInterface("0x00000000")
    assert token.supportsInterface("0x80ac58cd") # ERC-721
    assert token.supportsInterface("0x5b5e139f") # ERC-721 Metadata
