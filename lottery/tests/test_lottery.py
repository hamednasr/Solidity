# how many USD is 0.01 Ether?
from brownie import Lottery
from scripts.helpful_functions import get_account


account = get_account()
def test_dollars():
    lot_deploy = Lottery.deploy({'from': account})
    amount = lot_deploy.getConversionRate(1e16)

    assert amount > 1064*1e16
    assert amount < 1065*1e16