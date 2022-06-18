from dataclassy import values
from brownie import accounts, Lottery, config, network
from scripts.helpful_functions import get_account


def deploy_lottery():
    account = get_account()
    lottery = Lottery.deploy({'from': account})

def start_lottery():
    account = get_account()
    lottery = Lottery[-1]
    starting_tx = lottery.startLottery({'from': account})
    starting_tx.wait(1)
    print('Lottery started successfully!!')



def main():
    deploy_lottery()
    start_lottery()
    enter_lottery()