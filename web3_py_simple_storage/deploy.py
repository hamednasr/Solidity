from solcx import compile_standard, install_solc
import os
import json
from web3 import Web3
# from dotenv import load_dotenv

# load_dotenv()


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
w3 = Web3(Web3.HTTPProvider('HTTP://127.0.0.1:7545'))
chainID = 5777
MyAddress = '0x0AF09a6e56FAAC1bBd2Aeb7DCe7a7DdAE77Ee6f6'
PrivateKey = '0x78e3c71899a9c178a5f08857f95439ee2dbedc878969f2dcd085d0f95cafbe57'

