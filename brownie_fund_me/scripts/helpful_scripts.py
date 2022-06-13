from brownie import accounts, network, config
LOCAL_ENVIRONMENTS = ['development', 'ganache-local']

def get_account():
    if network.show_active() in LOCAL_ENVIRONMENTS:
        account = accounts[0]
    else:
        account = accounts.add(config['wallets']['from_key'])
    return account