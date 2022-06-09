from solcx import compile_standard, install_solc
import os
import json
from web3 import Web3
from dotenv import load_dotenv

load_dotenv()


with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

# We add these two lines that we forgot from the video!
print("Installing...")
install_solc("0.6.0")

# Solidity source code
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
            }
        },
    },
    solc_version="0.6.0",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)


bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

abi = json.loads(
    compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["metadata"]
)["output"]["abi"]

# connect to ganache
w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:7545'))
chainID = 1337
MyAddress = '0xD6063271A197c4979D6697B831aa694041eBCc11'
PrivateKey = os.getenv('PRIVATE_KEY')

# creat the contract in python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# get the latest tranaction
nonce = w3.eth.getTransactionCount(MyAddress)

# build the transaction
transaction = SimpleStorage.constructor().buildTransaction(
    {
    "gasPrice": w3.eth.gas_price, 
    "chainId": chainID, 
    "from": MyAddress, 
    "nonce": nonce, 
    }
)

#sign the transaction
signed_tx = w3.eth.account.sign_transaction(transaction,private_key = os.getenv('PRIVATE_KEY'))

#send the signed transaction
tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

# working with contract
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi = abi)

store_transaction = simple_storage.functions.store(16).buildTransaction({
    "gasPrice": w3.eth.gas_price, 
    "chainId": chainID, 
    "from": MyAddress, 
    "nonce": nonce+1, 
})

signed_store_TX = w3.eth.account.sign_transaction(store_transaction, PrivateKey)
store_TX_hash = w3.eth.send_raw_transaction(signed_store_TX.rawTransaction)
store_TX_recipt = w3.eth.wait_for_transaction_receipt(store_TX_hash)

print(simple_storage.functions.retrieve().call())
