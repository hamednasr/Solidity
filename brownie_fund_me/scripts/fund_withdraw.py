from traceback import print_tb
from brownie import FundMe
from scripts.helpful_scripts import get_account

account = get_account()

def fund():
    fund_me = FundMe[-1]
    entrance_fee = fund_me.getEntranceFee()
    print(f'the current entrace fee is: {entrance_fee}')
    print('Funding...')
    fund_me.fund({'from':account, 'value':entrance_fee})

def withdraw():
    fund_me = FundMe[-1]
    fund_me.withdraw({'from':account})

def main():
    fund()
    withdraw()