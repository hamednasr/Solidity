from os import access
from typing import NewType
from brownie import FundMe, MockV3Aggregator,network, config
from scripts.helpful_scripts import get_account, LOCAL_ENVIRONMENTS


def deploy_fund_me():
    account = get_account()
    if network.show_active() in LOCAL_ENVIRONMENTS:
        print('the active network is development')
        print('Deploying Mocks...')
        mock_aggregator = MockV3Aggregator.deploy(8,2*1e11,{'from':account})
        price_feed_address = mock_aggregator.address
        print('Mocks Deployed!')
    else:
        price_feed_address = config['brownie networks'][network.show_active()]['eth_usd_pricefeed']

 
    fund_me = FundMe.deploy(price_feed_address, {'from':account})
    print(f'contract deployed to {fund_me.address}')

def main():
    deploy_fund_me()