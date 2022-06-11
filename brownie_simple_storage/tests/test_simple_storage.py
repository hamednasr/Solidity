from brownie import SimpleStorage, accounts

def test_deploy():
    #arrange
    account = accounts[0]
    #Act
    simple_storage = SimpleStorage.deploy({'from':account})
    starting_value = simple_storage.retrieve()
    expected = 0
    #Assert
    assert starting_value == expected

def test_update():
    #arrange
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({'from':account})
    #act
    simple_storage.store(22 , {'from':account})
    value = simple_storage.retrieve()
    expected = 22
    #assert
    assert value == expected
