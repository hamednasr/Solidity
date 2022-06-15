from brownie import network, accounts, config

def get_account():
    if network.show_active() == 'development':
        account = accounts[0]
    else:
        account = accounts.add(config['wallets']['from_key'])
    return account