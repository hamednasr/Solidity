from brownie import accounts, config, SimpleStorage, network

def deploy_simple_storage():
    account = get_account()
    # account = accounts.load('david')
    # account = accounts.add(os.getenv('PRIVATE_KEY'))
    # print(account)
    # account = accounts.add(config["wallets"]["from_key"])
    # print(account)
     
    simple_storage = SimpleStorage.deploy({'from':account})
    stored_value = simple_storage.retrieve()
    print(f'first value: {stored_value}')
    transaction = simple_storage.store(16, {'from':account})
    transaction.wait(1)
    updated_value = simple_storage.retrieve()    
    print(f'updated value: {updated_value}')

def get_account():
    if network.show_active() == 'development':
        account = accounts[0]
    else:
        account = accounts.add(config['wallets']['from_key'])
    return account

def main():
    deploy_simple_storage()