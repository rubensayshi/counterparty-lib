import pprint

import pytest
import binascii
import os
import sys
import logging
import serpent
from counterpartylib.test import conftest  # this is require near the top to do setup of the test suite
from counterpartylib.test.util_test import CURR_DIR

from counterpartylib.lib import (config, database)
from counterpartylib.lib.evm import (blocks, processblock, ethutils, abi, address, vm)

from counterpartylib.test.evm import contracts_tester as tester
from counterpartylib.test import util_test
from counterpartylib.lib.evm.solidity import get_solidity

solidity = get_solidity()

# globals initialized by setup_function
db, cursor, logger = None, None, None
CLEANUP_FILES = []


def state():
    """"create a tester.state with latest block"""
    global db

    cursor = db.cursor()
    cursor.execute('''SELECT * FROM blocks ORDER BY block_index DESC LIMIT 1''')
    latest_block = list(cursor.fetchall())[0]
    cursor.close()

    return tester.state(db, latest_block['block_hash'])


def setup_module():
    """Initialise the database with unittest fixtures"""
    # global the DB/cursor for other functions to access
    global db, cursor, logger

    db = util_test.init_database(CURR_DIR + '/fixtures/scenarios/unittest_fixture.sql', 'fixtures.countracts_test.db')
    logger = logging.getLogger(__name__)
    db.setrollbackhook(lambda: logger.debug('ROLLBACK'))
    database.update_version(db)


def teardown_module():
    """Delete the temporary database."""
    util_test.remove_database_files(config.DATABASE)


def setup_function(function):
    global db, cursor

    # start transaction so we can rollback on teardown
    cursor = db.cursor()
    cursor.execute('''BEGIN''')


def teardown_function(function):
    global db, cursor
    cursor.execute('''ROLLBACK''')

    # cleanup files marked for cleanup
    for file in CLEANUP_FILES:
        if os.path.isfile(file):
            os.remove(file)


def open_cleanonteardown(filename, *args, **kwargs):
    CLEANUP_FILES.append(filename)

    return open(filename, *args, **kwargs)


def test_evm1():
    code = '''
contract testme {
    function main(uint a, uint b) returns (uint) {
        return a ** b;
    }
}
'''

    evm_code = solidity.compile(code)

    translator = abi.ContractTranslator(solidity.mk_full_signature(code))
    data = translator.encode('main', [2, 5])
    s = state()
    c = s.evm(evm_code)
    o = translator.decode('main', s.send(tester.k0, c, 0, data))
    assert o == [32]
    assert c.main(2, 5) == 32



# Test Serpent's import mechanism


def test_returnten():
    mul2_code = '''
contract mul2 {
    function double(uint v) returns (uint) {
        return v * 2;
    }
}
'''
    filename = "mul2_qwertyuioplkjhgfdsa.sol"

    returnten_code = '''
import "%s";

contract testme {
    function main() returns (uint) {
        mul2 x = new mul2();
        return x.double(5);
    }
}''' % filename
    s = state()
    open_cleanonteardown(filename, 'w').write(mul2_code)
    c = s.abi_contract(returnten_code, language='solidity')
    assert c.main() == 10


# Test inset

inset_inner_code = \
    '''
def g(n):
    return(n + 10)

def f(n):
    return n*2
'''

filename2 = "inner_qwertyuioplkjhgfdsa.se"

inset_outer_code = \
    '''
inset("%s")

def foo():
    res = self.g(12)
    return res
''' % filename2


def test_inset():
    s = state()
    open_cleanonteardown(filename2, 'w').write(inset_inner_code)
    c = s.abi_contract(inset_outer_code)
    assert c.foo() == 22
    os.remove(filename2)


# Inset at the end instead

inset_inner_code2 = \
    '''
def g(n):
    return(n + 10)

def f(n):
    return n*2
'''

filename25 = "inner_qwertyuioplkjhgfdsa.se"

inset_outer_code2 = \
    '''

def foo():
    res = self.g(12)
    return res

inset("%s")
''' % filename25


def test_inset2():
    s = state()
    open_cleanonteardown(filename25, 'w').write(inset_inner_code2)
    c = s.abi_contract(inset_outer_code2)
    assert c.foo() == 22
    os.remove(filename25)


# Test a simple namecoin implementation

namecoin_code = \
    '''
def main(k, v):
    if !self.storage[k]:
        self.storage[k] = v
        return(1)
    else:
        return(0)
'''


def test_namecoin():
    s = state()
    c = s.abi_contract(namecoin_code)
    o1 = c.main("george", 45)
    assert o1 == 1
    o2 = c.main("george", 20)
    assert o2 == 0
    o3 = c.main("harry", 60)
    assert o3 == 1


# Test a simple text return (test not originally in pyeth)
simple_text_return_code = '''
def returntext(v):
    return(text("testing123"):str)
'''


def test_simple_text_return():
    s = state()
    c = s.abi_contract(simple_text_return_code)

    assert c.returntext() == bytes("testing123", "utf8")


# Test a simple send (test not originally in pyeth)
send_code = '''
def send(v):
    send(msg.sender, v)
'''


def test_send():
    s = state()
    c = s.abi_contract(send_code)

    startbalance = s.block.get_balance(tester.a2)
    value = 1000000  # amount send into the contract
    v = 30000  # v= for the contract, amount we get back
    gcost = 53356  # gascost
    c.send(v, value=value, sender=tester.a2)
    assert s.block.get_balance(tester.a2) == startbalance - gcost - value + v


# Test a simple send to hardcoded address (test not originally in pyeth)
send_arg_code = '''
def send(s:address, v):
    send(s, v)
'''


def test_send_arg():
    a2 = address.Address.normalize(tester.a2)

    s = state()
    c = s.abi_contract(send_arg_code)

    logger.warn(a2.int())

    startbalance = s.block.get_balance(tester.a2)
    v = 30000  # v = for the contract, amount we get back
    c.send(tester.a2, v, value=10000000, sender=tester.a1)
    assert s.block.get_balance(tester.a2) == startbalance + v


# Test a simple send to hardcoded address (test not originally in pyeth)
send_hardcoded_code = '''
def send(v):
    send(%s, v)
'''


def test_send_hardcoded():
    a2 = address.Address.normalize(tester.a2)

    s = state()
    c = s.abi_contract(send_hardcoded_code % (a2.int(), ))

    startbalance = s.block.get_balance(tester.a2)
    v = 30000  # v = for the contract, amount we get back
    c.send(v, value=10000000, sender=tester.a1)
    assert s.block.get_balance(tester.a2) == startbalance + v


# Test a simple currency implementation

currency_code = '''
data balances[2^160]

def init():
    self.balances[msg.sender] = 1000

def query(addr:address):
    return(self.balances[addr])

def send(to:address, value):
    from = msg.sender
    fromvalue = self.balances[from]
    if fromvalue >= value:
        self.balances[from] = fromvalue - value
        self.balances[to] = self.balances[to] + value
        log(from, to, value)
        return(1)
    else:
        return(0)
'''


def test_currency():
    s = state()
    c = s.abi_contract(currency_code, sender=tester.k0)

    o1 = c.query(tester.k0)
    assert o1 == 1000
    o1 = c.send(tester.a2, 200, sender=tester.a0)
    assert o1 == 1
    o2 = c.send(tester.a2, 900, sender=tester.a0)
    assert o2 == 0
    o3 = c.query(tester.a0)
    assert o3 == 800
    o4 = c.query(tester.a2)
    assert o4 == 200


# Test a data feed

data_feed_code = '''
data creator
data values[]


def init():
    self.creator = msg.sender

def set(k, v):
    if msg.sender == self.creator:
        self.values[k] = v
        return(1)
    else:
        return(0)

def get(k):
    return(self.values[k])
'''


def test_data_feeds():
    s = state()
    c = s.abi_contract(data_feed_code, sender=tester.k0)
    o2 = c.get(500)
    assert o2 == 0
    o3 = c.set(500, 19)
    assert o3 == 1
    o4 = c.get(500)
    assert o4 == 19
    o5 = c.set(500, 726, sender=tester.k1)
    assert o5 == 0
    o6 = c.set(500, 726)
    assert o6 == 1
    return s, c


# Test an example hedging contract, using the data feed. This tests
# contracts calling other contracts

hedge_code = '''
extern datafeed: [set:ii, get:i]

data partyone
data partytwo
data hedgeValue
data datafeed
data index
data fiatValue
data maturity

def main(datafeed, index):
    if !self.partyone:
        self.partyone = msg.sender
        self.hedgeValue = msg.value
        self.datafeed = datafeed
        self.index = index
        return(1)
    elif !self.partytwo:
        ethvalue = self.hedgeValue
        if msg.value >= ethvalue:
            self.partytwo = msg.sender
        c = self.datafeed.get(self.index)
        othervalue = ethvalue * c
        self.fiatValue = othervalue
        self.maturity = block.timestamp + 20000
        return(othervalue)
    else:
        othervalue = self.fiatValue
        ethvalue = othervalue / self.datafeed.get(self.index)
        if ethvalue >= self.balance:
            send(self.partyone, self.balance)
            return(3)
        elif block.timestamp > self.maturity:
            send(self.partytwo, self.balance - ethvalue)
            send(self.partyone, ethvalue)
            return(4)
        else:
            return(5)
'''


def test_hedge():
    # run previous test to setup data feeds
    s, c = test_data_feeds()

    # create contract
    c2 = s.abi_contract(hedge_code, sender=tester.k0)

    # Have the first party register, sending 10000000 XCPtoshi and asking for a hedge using currency code 500
    o1 = c2.main(c.address.int(), 500, value=10000000, sender=tester.k0)
    assert o1 == 1

    # Have the second party register.
    # It should receive the amount of units of the second currency that it is entitled to.
    # Note that from the previous test this is set to 726
    o2 = c2.main(0, 0, value=10000000, sender=tester.k2)
    assert o2 == 7260000000

    # SNAPSHOT
    snapshot = s.snapshot()

    # Set the price of the asset down to 300 wei, through the data feed contract
    o3 = c.set(500, 300)
    assert o3 == 1

    # Finalize the contract. Expect code 3, meaning a margin call
    o4 = c2.main(0, 0)
    assert o4 == 3

    # REVERT TO SNAPSHOT
    s.revert(snapshot)

    # Don't change the price. Finalize, and expect code 5, meaning the time has not expired yet
    o5 = c2.main(0, 0)
    assert o5 == 5

    # Mine 100 blocks
    s.mine(100, tester.a3)

    # Expect code 4, meaning a normal execution where both get their share
    o6 = c2.main(0, 0)
    assert o6 == 4


# Test the LIFO nature of call
arither_code = '''
def init():
    self.storage[0] = 10

def f1():
    self.storage[0] += 1

def f2():
    self.storage[0] *= 10
    self.f1()
    self.storage[0] *= 10

def f3():
    return(self.storage[0])
'''


def test_lifo():
    s = state()
    c = s.abi_contract(arither_code)
    c.f2()
    assert c.f3() == 1010


# Test suicides and suicide reverts
suicider_code = '''
data creator

def init():
    self.creator = msg.sender

def mainloop(rounds):
    self.storage[15] = 40
    self.suicide()
    i = 0
    while i < rounds:
        i += 1
        self.storage[i] = i
    return(i)

def entry(rounds):
    self.storage[15] = 20
    return self.mainloop(rounds, gas=msg.gas - 600)

def ping_ten():
    return(10)

def suicide():
    suicide(self.creator)

def ping_storage15():
    return(self.storage[15])
'''


def test_suicider():
    s = state()

    c = s.abi_contract(suicider_code)
    # Run normally: suicide processes, so the attempt to ping the contract fails
    assert c.entry(5) == 5
    o2 = c.ping_ten()
    assert o2 is None

    c = s.abi_contract(suicider_code)
    # Run the suicider in such a way that it suicides in a sub-call,
    # then runs out of gas, leading to a revert of the suicide and the storage mutation
    o1 = c.entry(8000)
    assert o1 == 0

    # Check that the suicide got reverted and the contract still works
    o2 = c.ping_ten()
    assert o2 == 10
    # Check that the storage op got reverted and the contract still works
    o3 = c.ping_storage15()
    assert o3 == 20


# Test reverts

reverter_code = '''
def entry():
    self.non_recurse(gas=100000)
    self.recurse(gas=100000)

def non_recurse():
    send(%s, 9)
    self.storage[8080] = 4040
    self.storage[160160] = 2020

def recurse():
    send(%s, 9)
    self.storage[8081] = 4039
    self.storage[160161] = 2019
    self.recurse()
    while msg.gas > 0:
        self.storage["waste_some_gas"] = 0
'''


def test_reverter():
    a1 = address.Address.normalize(tester.a1)
    a2 = address.Address.normalize(tester.a2)

    s = state()

    # get balances before contracts
    a1b = s.block.get_balance(a1.base58())
    a2b = s.block.get_balance(a2.base58())

    c = s.abi_contract(reverter_code % (a1.int(), a2.int()), endowment=100000)
    c.entry()
    assert s.block.get_storage_data(c.address, 8080) == 4040
    assert s.block.get_balance(tester.a1) == a1b + 9
    assert s.block.get_storage_data(c.address, 8081) == 0
    assert s.block.get_balance(tester.a2) == a2b + 0


# Test stateless contracts

add1_code = \
    '''
def main(x):
    self.storage[1] += x
'''

filename3 = "stateless_qwertyuioplkjhgfdsa.se"

callcode_test_code = \
    '''
extern add1: [main:i]

x = create("%s")
x.main(6)
x.main(4, call=code)
x.main(60, call=code)
x.main(40)
return(self.storage[1])
''' % filename3


def test_callcode():
    s = state()
    open_cleanonteardown(filename3, 'w').write(add1_code)
    c = s.contract(callcode_test_code)
    o1 = s.send(tester.k0, c, 0)

    assert ethutils.big_endian_to_int(o1) == 64


# https://github.com/ethereum/serpent/issues/8
array_code = '''
def main():
    a = array(1)
    a[0] = 1
    return(a, items=1)
'''


def test_array():
    s = state()
    c = s.abi_contract(array_code)
    assert c.main() == [1]


array_code2 = '''
def main():
    a = array(1)
    something = 2
    a[0] = 1
    return(a, items=1)
'''


def test_array2():
    s = state()
    c = s.abi_contract(array_code2)
    assert c.main() == [1]


array_code3 = """
def main():
    a = array(3)
    return(a, items=3)
"""


def test_array3():
    s = state()
    c = s.abi_contract(array_code3)
    assert c.main() == [0, 0, 0]


calltest_code = """
def main():
    self.first(1, 2, 3, 4, 5)
    self.second(2, 3, 4, 5, 6)
    self.third(3, 4, 5, 6, 7)

def first(a, b, c, d, e):
    self.storage[1] = a * 10000 + b * 1000 + c * 100 + d * 10 + e

def second(a, b, c, d, e):
    self.storage[2] = a * 10000 + b * 1000 + c * 100 + d * 10 + e

def third(a, b, c, d, e):
    self.storage[3] = a * 10000 + b * 1000 + c * 100 + d * 10 + e

def get(k):
    return(self.storage[k])
"""


def test_calls():
    s = state()
    c = s.abi_contract(calltest_code)
    c.main()
    assert 12345 == c.get(1)
    assert 23456 == c.get(2)
    assert 34567 == c.get(3)
    c.first(4, 5, 6, 7, 8)
    assert 45678 == c.get(1)
    c.second(5, 6, 7, 8, 9)
    assert 56789 == c.get(2)


storage_object_test_code = """
extern moo: [ping, query_chessboard:ii, query_items:ii, query_person, query_stats:i, testping:ii, testping2:i]

data chessboard[8][8]
data users[100](health, x, y, items[5])
data person(head, arms[2](elbow, fingers[5]), legs[2])

def ping():
    self.chessboard[0][0] = 1
    self.chessboard[0][1] = 2
    self.chessboard[3][0] = 3
    self.users[0].health = 100
    self.users[1].x = 15
    self.users[1].y = 12
    self.users[1].items[2] = 9
    self.users[80].health = self
    self.users[80].items[3] = self
    self.person.head = 555
    self.person.arms[0].elbow = 556
    self.person.arms[0].fingers[0] = 557
    self.person.arms[0].fingers[4] = 558
    self.person.legs[0] = 559
    self.person.arms[1].elbow = 656
    self.person.arms[1].fingers[0] = 657
    self.person.arms[1].fingers[4] = 658
    self.person.legs[1] = 659
    self.person.legs[1] += 1000

def query_chessboard(x, y):
    return(self.chessboard[x][y])

def query_stats(u):
    return([self.users[u].health, self.users[u].x, self.users[u].y]:arr)

def query_items(u, i):
    return(self.users[u].items[i])

def query_person():
    a = array(15)
    a[0] = self.person.head
    a[1] = self.person.arms[0].elbow
    a[2] = self.person.arms[1].elbow
    a[3] = self.person.legs[0]
    a[4] = self.person.legs[1]
    i = 0
    while i < 5:
        a[5 + i] = self.person.arms[0].fingers[i]
        a[10 + i] = self.person.arms[1].fingers[i]
        i += 1
    return(a:arr)

def testping(x, y):
    return([self.users[80].health.testping2(x), self.users[80].items[3].testping2(y)]:arr)

def testping2(x):
    return(x*x)

"""


def test_storage_objects():
    s = state()
    c = s.abi_contract(storage_object_test_code)
    c.ping()
    assert 1 == c.query_chessboard(0, 0)
    assert 2 == c.query_chessboard(0, 1)
    assert 3 == c.query_chessboard(3, 0)
    assert [100, 0, 0] == c.query_stats(0)
    assert [0, 15, 12] == c.query_stats(1)
    assert 0 == c.query_items(1, 3)
    assert 0 == c.query_items(0, 2)
    assert 9 == c.query_items(1, 2)
    assert [555, 556, 656, 559, 1659,
            557, 0, 0, 0, 558,
            657, 0, 0, 0, 658] == c.query_person()
    assert [361, 441] == c.testping(19, 21)


infinite_storage_object_test_code = """
data chessboard[][8]
data users[100](health, x, y, items[])
data person(head, arms[](elbow, fingers[5]), legs[2])

def ping():
    self.chessboard[0][0] = 1
    self.chessboard[0][1] = 2
    self.chessboard[3][0] = 3
    self.users[0].health = 100
    self.users[1].x = 15
    self.users[1].y = 12
    self.users[1].items[2] = 9
    self.person.head = 555
    self.person.arms[0].elbow = 556
    self.person.arms[0].fingers[0] = 557
    self.person.arms[0].fingers[4] = 558
    self.person.legs[0] = 559
    self.person.arms[1].elbow = 656
    self.person.arms[1].fingers[0] = 657
    self.person.arms[1].fingers[4] = 658
    self.person.legs[1] = 659
    self.person.legs[1] += 1000

def query_chessboard(x, y):
    return(self.chessboard[x][y])

def query_stats(u):
    return([self.users[u].health, self.users[u].x, self.users[u].y]:arr)

def query_items(u, i):
    return(self.users[u].items[i])

def query_person():
    a = array(15)
    a[0] = self.person.head
    a[1] = self.person.arms[0].elbow
    a[2] = self.person.arms[1].elbow
    a[3] = self.person.legs[0]
    a[4] = self.person.legs[1]
    i = 0
    while i < 5:
        a[5 + i] = self.person.arms[0].fingers[i]
        a[10 + i] = self.person.arms[1].fingers[i]
        i += 1
    return(a:arr)
"""


def test_infinite_storage_objects():
    s = state()
    c = s.abi_contract(infinite_storage_object_test_code)
    c.ping()
    assert 1 == c.query_chessboard(0, 0)
    assert 2 == c.query_chessboard(0, 1)
    assert 3 == c.query_chessboard(3, 0)
    assert [100, 0, 0] == c.query_stats(0)
    assert [0, 15, 12] == c.query_stats(1)
    assert 0 == c.query_items(1, 3)
    assert 0 == c.query_items(0, 2)
    assert 9 == c.query_items(1, 2)
    assert [555, 556, 656, 559, 1659,
            557, 0, 0, 0, 558,
            657, 0, 0, 0, 658] == c.query_person()


fail1 = """
data person(head, arms[2](elbow, fingers[5]), legs[2])

x = self.person.arms[0]
"""

fail2 = """
data person(head, arms[2](elbow, fingers[5]), legs[2])

x = self.person.arms[0].fingers
"""

fail3 = """
data person(head, arms[2](elbow, fingers[5]), legs[2])

x = self.person.arms[0].fingers[4][3]
"""

fail4 = """
data person(head, arms[2](elbow, fingers[5]), legs[2])

x = self.person.arms.elbow[0].fingers[4]
"""

fail5 = """
data person(head, arms[2](elbow, fingers[5]), legs[2])

x = self.person.arms[0].fingers[4].nail
"""

fail6 = """
data person(head, arms[2](elbow, fingers[5]), legs[2])

x = self.person.arms[0].elbow.skin
"""

fail7 = """
def return_array():
    return([1,2,3], items=3)

def main():
    return(self.return_array())
"""


def test_storagevar_fails():
    s = state()
    success1, success2, success3, success4, success5, success6 = \
        0, 0, 0, 0, 0, 0
    try:
        s.contract(fail1)
    except Exception as e:
        success1 = "Storage variable access not deep enough" in str(e)
    assert success1, e

    try:
        s.contract(fail2)
    except Exception as e:
        success2 = "Too few array index lookups" in str(e)
    assert success2, e

    try:
        s.contract(fail3)
    except Exception as e:
        success3 = "Too many array index lookups" in str(e)
    assert success3, e

    try:
        s.contract(fail4)
    except Exception as e:
        success4 = "Too few array index lookups" in str(e)
    assert success4, e

    try:
        s.contract(fail5)
    except Exception as e:
        success5 = "Invalid object member" in str(e)
    assert success5, e

    try:
        s.contract(fail6)
    except Exception as e:
        success6 = "Invalid object member" in str(e)
    assert success6, e


def test_type_system_fails():
    s = state()
    success7 = False

    try:
        s.contract(fail7)
    except Exception as e:
        success7 = "Please specify maximum" in str(e)
    assert success7, e


working_returnarray_code = """
def return_array():
    return([1,2,3], items=3)

def main():
    return(self.return_array(outitems=3):arr)
"""


def test_returnarray_code():
    s = state()
    c = s.abi_contract(working_returnarray_code)
    assert c.main() == [1, 2, 3]


crowdfund_code = """
data campaigns[2^80](recipient, goal, deadline, contrib_total, contrib_count, contribs[2^50](sender, value))

def create_campaign(id, recipient, goal, timelimit):
    if self.campaigns[id].recipient:
        return(0)
    self.campaigns[id].recipient = recipient
    self.campaigns[id].goal = goal
    self.campaigns[id].deadline = block.timestamp + timelimit

def contribute(id):
    # Update contribution total
    total_contributed = self.campaigns[id].contrib_total + msg.value
    self.campaigns[id].contrib_total = total_contributed

    # Record new contribution
    sub_index = self.campaigns[id].contrib_count
    self.campaigns[id].contribs[sub_index].sender = msg.sender
    self.campaigns[id].contribs[sub_index].value = msg.value
    self.campaigns[id].contrib_count = sub_index + 1

    # Enough funding?
    if total_contributed >= self.campaigns[id].goal:
        send(self.campaigns[id].recipient, total_contributed)
        self.clear(id)
        return(1)

    # Expired?
    if block.timestamp > self.campaigns[id].deadline:
        i = 0
        c = self.campaigns[id].contrib_count
        while i < c:
            send(self.campaigns[id].contribs[i].sender, self.campaigns[id].contribs[i].value)
            i += 1
        self.clear(id)
        return(2)

# Progress report [2, id]
def progress_report(id):
    return(self.campaigns[id].contrib_total)

# Clearing function for internal use
def clear(self, id):
    if self == msg.sender:
        self.campaigns[id].recipient = 0
        self.campaigns[id].goal = 0
        self.campaigns[id].deadline = 0
        c = self.campaigns[id].contrib_count
        self.campaigns[id].contrib_count = 0
        self.campaigns[id].contrib_total = 0
        i = 0
        while i < c:
            self.campaigns[id].contribs[i].sender = 0
            self.campaigns[id].contribs[i].value = 0
            i += 1
"""


def test_crowdfund():
    """
    test crowdfund smart contract, keep in mind that we create a new block for every contract call
     so we need a generous TTL
    """

    s = state()
    c = s.abi_contract(crowdfund_code)  # tXsNynQTeMkCQVBKMVnHwov1rTjpUYdVSt

    ttlblocks = 20
    ttl = ttlblocks * 1000  # block_index * 1000 for mock timestamps

    # Create a campaign with id 100, recipient '45', target 100000 and ttl 20 blocks
    recipient100 = address.Address(data=address.Address.normalizedata(45), version=config.ADDRESSVERSION)  # mfWxJ45yp2SFn7UciZyNpvDKrzbnzaxGAt
    c.create_campaign(100, recipient100.int(), 100000, ttl)
    # Create a campaign with id 200, recipient '48', target 100000 and ttl 20 blocks
    recipient200 = address.Address(data=address.Address.normalizedata(48), version=config.ADDRESSVERSION)  # mfWxJ45yp2SFn7UciZyNpvDKrzboRgnPSZ
    c.create_campaign(200, recipient200.int(), 100000, ttl)

    # Make some contributions to campaign 100
    c.contribute(100, value=1, sender=tester.k1)  # mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns
    assert 1 == c.progress_report(100)
    c.contribute(100, value=59049, sender=tester.k2)  # mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj
    assert 59050 == c.progress_report(100)

    # Make some contributions to campaign 200
    c.contribute(200, value=30000, sender=tester.k3)  # myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM
    assert 30000 == c.progress_report(200)

    # This contribution should trigger the delivery
    c.contribute(200, value=70001, sender=tester.k4)  # munimLLHjPhGeSU5rYB2HN79LJa8bRZr5b

    # Expect the 100001 units to be delivered to the destination account for campaign 2
    assert 100001 == s.block.get_balance(recipient200)

    # Mine some blocks to test expire the campaign, not sure how many are needed so just do 20
    mida1 = s.block.get_balance(tester.a1)
    mida3 = s.block.get_balance(tester.a2)
    s.mine(ttlblocks)

    # Ping the campaign after expiry to trigger the refund
    c.contribute(100, value=1, sender=tester.a0)

    # Expect refunds
    assert mida1 + 1 == s.block.get_balance(tester.a1)
    assert mida3 + 59049 == s.block.get_balance(tester.a2)


saveload_code = """

data store[1000]

def kall():
    a = text("sir bobalot to the rescue !!1!1!!1!1")
    save(self.store[0], a, chars=60)
    b = load(self.store[0], chars=60)
    c = load(self.store[0], chars=33)
    return([a[0], a[1], b[0], b[1], c[0], c[1]]:arr)

"""

import bitcoin


def test_saveload():
    s = state()
    c = s.abi_contract(saveload_code)
    o = c.kall()
    assert o[0] == 0x73697220626f62616c6f7420746f207468652072657363756520212131213121, bitcoin.encode(o[0], 16)
    assert o[1] == 0x2131213100000000000000000000000000000000000000000000000000000000, bitcoin.encode(o[1], 16)
    assert o[2] == 0x73697220626f62616c6f7420746f207468652072657363756520212131213121, bitcoin.encode(o[2], 16)
    assert o[3] == 0x2131213100000000000000000000000000000000000000000000000000000000, bitcoin.encode(o[3], 16)
    assert o[4] == 0x73697220626f62616c6f7420746f207468652072657363756520212131213121, bitcoin.encode(o[4], 16)
    assert o[5] == 0x2100000000000000000000000000000000000000000000000000000000000000, bitcoin.encode(o[5], 16)


saveload_code2 = """
data buf
data buf2

mystr = text("01ab")
save(self.buf, mystr:str)
save(self.buf2, mystr, chars=4)
"""


def test_saveload2():
    s = state()
    c = s.contract(saveload_code2)
    s.send(tester.k0, c, 0)

    assert ethutils.int_to_big_endian(s.block.get_storage_data(c, 0)) == b'01ab' + b'\x00' * 28
    assert ethutils.int_to_big_endian(s.block.get_storage_data(c, 1)) == b'01ab' + b'\x00' * 28


sdiv_code = """
def kall():
    return([2^255 / 2^253, 2^255 % 3]:arr)
"""


def test_sdiv():
    s = state()
    c = s.abi_contract(sdiv_code)
    assert [-4, -2] == c.kall()


basic_argcall_code = """
def argcall(args:arr):
    log(1)
    o = (args[0] + args[1] * 10 + args[2] * 100)
    log(4)
    return o

def argkall(args:arr):
    log(2)
    o = self.argcall(args)
    log(3)
    return o
"""


def test_argcall():
    s = state()
    c = s.abi_contract(basic_argcall_code)
    assert 375 == c.argcall([5, 7, 3])
    assert 376 == c.argkall([6, 7, 3])


more_complex_argcall_code = """
def argcall(args:arr):
    args[0] *= 2
    args[1] *= 2
    return(args:arr)

def argkall(args:arr):
    return(self.argcall(args, outsz=2):arr)
"""


def test_argcall2():
    s = state()
    c = s.abi_contract(more_complex_argcall_code)
    assert [4, 8] == c.argcall([2, 4])
    assert [6, 10] == c.argkall([3, 5])


sort_code = """
def sort(args:arr):
    if len(args) < 2:
        return(args:arr)
    h = array(len(args))
    hpos = 0
    l = array(len(args))
    lpos = 0
    i = 1
    while i < len(args):
        if args[i] < args[0]:
            l[lpos] = args[i]
            lpos += 1
        else:
            h[hpos] = args[i]
            hpos += 1
        i += 1
    x = slice(h, items=0, items=hpos)
    h = self.sort(x, outsz=hpos)
    l = self.sort(slice(l, items=0, items=lpos), outsz=lpos)
    o = array(len(args))
    i = 0
    while i < lpos:
        o[i] = l[i]
        i += 1
    o[lpos] = args[0]
    i = 0
    while i < hpos:
        o[lpos + 1 + i] = h[i]
        i += 1
    return(o:arr)
"""


@pytest.mark.timeout(100)
def test_sort():
    s = state()
    c = s.abi_contract(sort_code)
    assert c.sort([9]) == [9]
    assert c.sort([9, 5]) == [5, 9]
    assert c.sort([9, 3, 5]) == [3, 5, 9]
    assert c.sort([80, 234, 112, 112, 29]) == [29, 80, 112, 112, 234]


filename9 = "mul2_qwertyuioplkjhgfdsabarbar.se"

sort_tester_code = \
    '''
extern sorter: [sort:a]
data sorter

def init():
    self.sorter = create("%s")

def test(args:arr):
    return(self.sorter.sort(args, outsz=len(args)):arr)
''' % filename9


@pytest.mark.timeout(100)
def test_indirect_sort():
    s = state()
    open_cleanonteardown(filename9, 'w').write(sort_code)
    c = s.abi_contract(sort_tester_code)
    assert c.test([80, 234, 112, 112, 29]) == [29, 80, 112, 112, 234]
    os.remove(filename9)


multiarg_code = """
def kall(a:arr, b, c:arr, d:str, e):
    x = a[0] + 10 * b + 100 * c[0] + 1000 * a[1] + 10000 * c[1] + 100000 * e
    return([x, getch(d, 0) + getch(d, 1) + getch(d, 2), len(d)]:arr)
"""


def test_multiarg_code():
    s = state()
    c = s.abi_contract(multiarg_code)
    o = c.kall([1, 2, 3], 4, [5, 6, 7], "doge", 8)
    assert o == [862541, ethutils.safe_ord('d') + ethutils.safe_ord('o') + ethutils.safe_ord('g'), 4]


peano_code = """
macro padd($x, psuc($y)):
    psuc(padd($x, $y))

macro padd($x, z()):
    $x

macro dec(psuc($x)):
    dec($x) + 1

macro dec(z()):
    0

macro pmul($x, z()):
    z()

macro pmul($x, psuc($y)):
    padd(pmul($x, $y), $x)

macro pexp($x, z()):
    one()

macro pexp($x, psuc($y)):
    pmul($x, pexp($x, $y))

macro fac(z()):
    one()

macro fac(psuc($x)):
    pmul(psuc($x), fac($x))

macro one():
    psuc(z())

macro two():
    psuc(psuc(z()))

macro three():
    psuc(psuc(psuc(z())))

macro five():
    padd(three(), two())

def main():
    return([dec(pmul(three(), pmul(three(), three()))), dec(fac(five()))]:arr)

"""


def test_macros():
    s = state()
    c = s.abi_contract(peano_code)
    assert c.main() == [27, 120]


type_code = """
type f: [a, b, c, d, e]

macro f($a) + f($b):
    f(add($a, $b))

macro f($a) - f($b):
    f(sub($a, $b))

macro f($a) * f($b):
    f(mul($a, $b) / 10000)

macro f($a) / f($b):
    f(sdiv($a * 10000, $b))

macro f($a) % f($b):
    f(smod($a, $b))

macro f($v) = f($w):
    $v = $w

macro(10) f($a):
    $a / 10000

macro fify($a):
    f($a * 10000)

a = fify(5)
b = fify(2)
c = a / b
e = c + (a / b)
return(e)
"""


def test_types():
    s = state()
    c = s.contract(type_code)
    assert ethutils.big_endian_to_int(s.send(tester.k0, c, 0)) == 5


ecrecover_code = """
def test_ecrecover(h, v, r, s):
    return(ecrecover(h, v, r, s))
"""


def test_ecrecover():
    """
    this is the original test_ecrecover from pyethereum but instead of generating the H,V,R,S we just hardcoded them
    """
    s = state()
    c = s.abi_contract(ecrecover_code)

    H = 60772363713814795336605161565488663769306106990467902980560042300358765319404
    V = 27
    R = 90287243237479221899775907091281500587081321452634188922390320940254754609975
    S = 24052755845221258772445669055700842241658207900505567178705869501444775369481
    pubkey = 794520059615976424790363096434176409370405942122

    result = c.test_ecrecover(H, V, R, S)
    assert result == pubkey


sha256_code = """
def main():
    return([sha256(0, chars=0), sha256(3), sha256(text("doge"), chars=3), sha256(text("dog"):str), sha256([0,0,0,0,0]:arr), sha256([0,0,0,0,0,0], items=5)]:arr)
"""


def test_sha256():
    s = state()
    c = s.abi_contract(sha256_code)
    assert c.main() == [
        0xe3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 - 2 ** 256,
        0xd9147961436944f43cd99d28b2bbddbf452ef872b30c8279e255e7daafc7f946 - 2 ** 256,
        0xcd6357efdd966de8c0cb2f876cc89ec74ce35f0968e11743987084bd42fb8944 - 2 ** 256,
        0xcd6357efdd966de8c0cb2f876cc89ec74ce35f0968e11743987084bd42fb8944 - 2 ** 256,
        0xb393978842a0fa3d3e1470196f098f473f9678e72463cb65ec4ab5581856c2e4 - 2 ** 256,
        0xb393978842a0fa3d3e1470196f098f473f9678e72463cb65ec4ab5581856c2e4 - 2 ** 256
    ]


ripemd160_code = """
def main():
    return([ripemd160(0, chars=0), ripemd160(3), ripemd160(text("doge"), chars=3), ripemd160(text("dog"):str), ripemd160([0,0,0,0,0]:arr), ripemd160([0,0,0,0,0,0], items=5)]:arr)
"""


def test_ripemd160():
    s = state()
    c = s.abi_contract(ripemd160_code)
    assert c.main() == [
        0x9c1185a5c5e9fc54612808977ee8f548b2258d31,
        0x44d90e2d3714c8663b632fcf0f9d5f22192cc4c8,
        0x2a5756a3da3bc6e4c66a65028f43d31a1290bb75,
        0x2a5756a3da3bc6e4c66a65028f43d31a1290bb75,
        0x9164cab7f680fd7a790080f2e76e049811074349,
        0x9164cab7f680fd7a790080f2e76e049811074349]


sha3_code = """
def main():
    return([sha3(0, chars=0), sha3(3), sha3(text("doge"), chars=3), sha3(text("dog"):str), sha3([0,0,0,0,0]:arr), sha3([0,0,0,0,0,0], items=5)]:arr)
"""


def test_sha3():
    s = state()
    c = s.abi_contract(sha3_code)
    assert c.main() == [
        0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 - 2 ** 256,
        0xc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b - 2 ** 256,
        0x41791102999c339c844880b23950704cc43aa840f3739e365323cda4dfa89e7a,
        0x41791102999c339c844880b23950704cc43aa840f3739e365323cda4dfa89e7a,
        0xdfded4ed5ac76ba7379cfe7b3b0f53e768dca8d45a34854e649cfc3c18cbd9cd - 2 ** 256,
        0xdfded4ed5ac76ba7379cfe7b3b0f53e768dca8d45a34854e649cfc3c18cbd9cd - 2 ** 256
    ]


types_in_functions_code = """
type fixedp: [a, b]

macro fixedp($x) * fixedp($y):
    fixedp($x * $y / 2^64)

macro fixedp($x) / fixedp($y):
    fixedp($x * 2^64 / $y)

macro raw_unfixedp(fixedp($x)):
    $x / 2^64

macro set(fixedp($x), $y):
    $x = 2^64 * $y

macro fixedp($x) = fixedp($y):
    $x = $y

def sqrdiv(a, b):
    return(raw_unfixedp((a / b) * (a / b)))
"""


def test_types_in_functions():
    s = state()
    c = s.abi_contract(types_in_functions_code)
    assert c.sqrdiv(25, 2) == 156


more_infinites_code = """
data a[](b, c)

def testVerifyTx():

    self.a[0].b = 33

    self.a[0].c = 55

    return(self.a[0].b)
"""


def test_more_infinites():
    s = state()
    c = s.abi_contract(more_infinites_code)
    assert c.testVerifyTx() == 33


prevhashes_code = """
def get_prevhashes(k):
    o = array(k)
    i = 0
    while i < k:
        o[i] = block.prevhash(i)
        i += 1
    return(o:arr)
"""


def test_prevhashes():
    global db

    s = state()
    c = s.abi_contract(prevhashes_code)

    # Hashes of last 14 blocks including existing one
    o1 = [x % 2 ** 256 for x in c.get_prevhashes(14)]

    cursor = db.cursor()
    blocks = list(cursor.execute('''SELECT * FROM blocks ORDER BY block_index DESC LIMIT %d''' % (14, )))
    cursor.close()
    t1 = [ethutils.big_endian_to_int(binascii.unhexlify(b['block_hash'])) for b in blocks]

    assert o1 == t1

    # Test 256 limit: only 1 <= g <= 256 generation ancestors get hashes shown
    o2 = [x % 2 ** 256 for x in c.get_prevhashes(270)]

    cursor = db.cursor()
    blocks = list(cursor.execute('''SELECT * FROM blocks ORDER BY block_index DESC LIMIT %d''' % (256, )))
    cursor.close()
    t2 = [ethutils.big_endian_to_int(binascii.unhexlify(b['block_hash'])) for b in blocks] + [0] * (270 - 256)

    assert o2 == t2


abi_contract_code = """
def mul2(a):
    return(a * 2)

def returnten():
    return(10)
"""


def test_abi_contract():
    s = state()
    c = s.abi_contract(abi_contract_code)
    assert c.mul2(3) == 6
    assert c.returnten() == 10


mcopy_code = """
def mcopy_test(foo:str, a, b, c):
    info = string(32*3 + len(foo))
    info[0] = a
    info[1] = b
    info[2] = c
    mcopy(info+(items=3), foo, len(foo))
    return(info:str)
"""


def test_mcopy():
    s = state()
    c = s.abi_contract(mcopy_code)
    assert c.mcopy_test("123", 5, 6, 259) == \
           b'\x00' * 31 + b'\x05' + b'\x00' * 31 + b'\x06' + b'\x00' * 30 + b'\x01\x03' + b'123'


mcopy_code_2 = """
def mcopy_test():
    myarr = array(3)
    myarr[0] = 99
    myarr[1] = 111
    myarr[2] = 119

    mystr = string(96)
    mcopy(mystr, myarr, items=3)
    return(mystr:str)
"""


def test_mcopy2():
    s = state()
    c = s.abi_contract(mcopy_code_2)
    assert c.mcopy_test() == \
           b''.join([ethutils.zpad(ethutils.int_to_big_endian(x), 32) for x in [99, 111, 119]])


array_saveload_code = """
data a[5]

def array_saveload():
    a = [1,2,3,4,5]
    save(self.a[0], a, items=5)
    a = load(self.a[0], items=4)
    log(len(a))
    return(load(self.a[0], items=4):arr)
"""


def test_saveload3():
    s = state()
    c = s.abi_contract(array_saveload_code)
    assert c.array_saveload() == [1, 2, 3, 4]


string_manipulation_code = """
def f1(istring:str):
    setch(istring, 0, "a")
    setch(istring, 1, "b")
    return(istring:str)

def t1():
    istring = text("cd")
    res = self.f1(istring, outchars=2)
    return([getch(res,0), getch(res,1)]:arr)  # should return [97,98]
"""


def test_string_manipulation():
    s = state()
    c = s.abi_contract(string_manipulation_code)
    assert c.t1() == [97, 98]


more_infinite_storage_object_code = """
data block[2^256](_blockHeader(_prevBlock))

data numAncestorDepths

data logs[2]

def initAncestorDepths():
    self.numAncestorDepths = 2

def testStoreB(number, blockHash, hashPrevBlock, i):
    self.block[blockHash]._blockHeader._prevBlock = hashPrevBlock

    self.logs[i] = self.numAncestorDepths


def test2():
    self.initAncestorDepths()
    self.testStoreB(45, 45, 44, 0)
    self.testStoreB(46, 46, 45, 1)
    return ([self.logs[0], self.logs[1]]:arr)
"""


def test_more_infinite_storage():
    s = state()
    c = s.abi_contract(more_infinite_storage_object_code)
    assert c.test2() == [2, 2]


double_array_code = """
def foo(a:arr, b:arr):
    i = 0
    tot = 0
    while i < len(a):
        tot = tot * 10 + a[i]
        i += 1
    j = 0
    tot2 = 0
    while j < len(b):
        tot2 = tot2 * 10 + b[j]
        j += 1
    return ([tot, tot2]:arr)

def bar(a:arr, m:str, b:arr):
    return(self.foo(a, b, outitems=2):arr)
"""


def test_double_array():
    s = state()
    c = s.abi_contract(double_array_code)
    assert c.foo([1, 2, 3], [4, 5, 6, 7]) == [123, 4567]
    assert c.bar([1, 2, 3], "moo", [4, 5, 6, 7]) == [123, 4567]


abi_logging_code = """
event rabbit(x)
event frog(y:indexed)
event moose(a, b:str, c:indexed, d:arr)
event chicken(m:address:indexed)

def test_rabbit(eks):
    log(type=rabbit, eks)

def test_frog(why):
    log(type=frog, why)

def test_moose(eh, bee:str, see, dee:arr):
    log(type=moose, eh, bee, see, dee)

def test_chicken(em:address):
    log(type=chicken, em)
"""


def test_abi_logging():
    s = state()

    o = []
    s.log_listeners.append(lambda log: o.append(c._translator.listen(log)))

    c = s.abi_contract(abi_logging_code)

    c.test_rabbit(3)
    assert o == [{"_event_type": b"rabbit", "x": 3}]
    o.pop()

    c.test_frog(5)
    assert o == [{"_event_type": b"frog", "y": 5}]
    o.pop()

    c.test_moose(7, "nine", 11, [13, 15, 17])
    assert o == [{"_event_type": b"moose", "a": 7, "b": b"nine",
                  "c": 11, "d": [13, 15, 17]}]
    o.pop()

    c.test_chicken(tester.a0)
    assert o == [{"_event_type": b"chicken",
                  "m": tester.a0}]
    o.pop()


new_format_inner_test_code = """
def foo(a, b:arr, c:str):
    return a * 10 + b[1]
"""

filename4 = "nfitc2635987162498621846198246.se"

new_format_outer_test_code = """
extern blah: [foo:[int256,int256[],bytes]:int256]

def bar():
    x = create("%s")
    return x.foo(17, [3, 5, 7], text("dog"))
""" % filename4


def test_new_format():
    s = state()
    open_cleanonteardown(filename4, 'w').write(new_format_inner_test_code)
    c = s.abi_contract(new_format_outer_test_code)
    assert c.bar() == 175


abi_address_output_test_code = """
data addrs[]

def get_address(key):
    return(self.addrs[key]:address)

def register(key, addr:address):
    if not self.addrs[key]:
        self.addrs[key] = addr
"""


def test_abi_address_output():
    s = state()
    c = s.abi_contract(abi_address_output_test_code)
    c.register(123, tester.a0)
    c.register(123, tester.a1)
    c.register(125, tester.a2)
    assert c.get_address(123) == tester.a0
    assert c.get_address(125) == tester.a2


filename5 = 'abi_output_tester_1264876521746198724124'

abi_address_caller_code = """
extern foo: [get_address:[int256]:address, register:[int256,address]:_]
data sub

def init():
    self.sub = create("%s")

def get_address(key):
    return(self.sub.get_address(key):address)

def register(key, addr:address):
    self.sub.register(key, addr)
""" % filename5


def test_inner_abi_address_output():
    s = state()
    open_cleanonteardown(filename5, 'w').write(abi_address_output_test_code)
    c = s.abi_contract(abi_address_caller_code)
    c.register(123, tester.a0)
    c.register(123, tester.a1)
    c.register(125, tester.a2)
    assert c.get_address(123) == tester.a0
    assert c.get_address(125) == tester.a2


string_logging_code = """
event foo(x:string:indexed, y:bytes:indexed, z:str:indexed)

def moo():
    log(type=foo, text("bob"), text("cow"), text("dog"))
"""


def test_string_logging():
    s = state()
    c = s.abi_contract(string_logging_code)
    o = []

    s.log_listeners.append(lambda x: o.append(c._translator.listen(x)))
    c.moo()

    assert o == [{
        "_event_type": b"foo",
        "x": b"bob",
        "__hash_x": ethutils.sha3("bob"),
        "y": b"cow",
        "__hash_y": ethutils.sha3("cow"),
        "z": b"dog",
        "__hash_z": ethutils.sha3("dog")
    }]


params_code = """
data blah


def init():
    self.blah = $FOO


def garble():
    return(self.blah)

def marble():
    return(text($BAR):str)
"""


def test_params_contract():
    s = state()
    c = s.abi_contract(params_code, FOO=4, BAR='horse')
    assert c.garble() == 4
    assert c.marble() == bytes('horse', 'utf8')


prefix_types_in_functions_code = """
type fixedp: fp_

macro fixedp($x) * fixedp($y):
    fixedp($x * $y / 2^64)

macro fixedp($x) / fixedp($y):
    fixedp($x * 2^64 / $y)

macro raw_unfixedp(fixedp($x)):
    $x / 2^64

macro set(fixedp($x), $y):
    $x = 2^64 * $y

macro fixedp($x) = fixedp($y):
    $x = $y

def sqrdiv(fp_a, fp_b):
    return(raw_unfixedp((fp_a / fp_b) * (fp_a / fp_b)))
"""


def test_prefix_types_in_functions():
    s = state()
    c = s.abi_contract(prefix_types_in_functions_code)
    assert c.sqrdiv(25, 2) == 156
