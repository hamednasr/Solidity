from brownie import accounts, Lottery, config, network
from scripts.helpful_functions import get_account

account = get_account()
def deploy_lottery():
    lottery = Lottery.deploy({'from': account})
    print(lottery.getLatestPrice())

def main():
    deploy_lottery()