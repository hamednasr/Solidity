from traceback import print_tb
from brownie import FundMe
from scripts.helpful_scripts import get_account


def fund():
    fund_me = FundMe[-1]
    print(fund_me.address)
    account = get_account()
    entrance_fee = fund_me.getEntranceFee()
    print(f'the current entrace fee is: {entrance_fee}')
    print('Funding...')
    fund_me.fund({'from':account, 'value':entrance_fee})


def main():
    fund()