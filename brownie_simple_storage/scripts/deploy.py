from brownie import accounts, config
import os
def deploy_simple_storage():
    # account = accounts[0]
    # account = accounts.load('david')
    # account = accounts.add(os.getenv('PRIVATE_KEY'))
    # print(account)
    account = accounts.add(config["wallets"]["from_key"])
    print(account)

def main():
    deploy_simple_storage()