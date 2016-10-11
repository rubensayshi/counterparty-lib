import tempfile
import pytest
# this is require near the top to do setup of the test suite
# from counterpartylib.test import conftest

from counterpartylib.test import util_test
from counterpartylib.lib import util
from counterpartylib.test.util_test import CURR_DIR
from counterpartylib.test.fixtures.params import DP
from counterpartylib.lib.micropayments.util import hash160hex
from counterpartylib.lib.micropayments.util import wif2address
from counterpartylib.lib.micropayments.util import wif2pubkey
from counterpartylib.lib.micropayments.util import script2address
from counterpartylib.lib.micropayments.scripts import compile_deposit_script


FIXTURE_SQL_FILE = CURR_DIR + '/fixtures/scenarios/unittest_fixture.sql'
FIXTURE_DB = tempfile.gettempdir() + '/fixtures.unittest_fixture.db'


ALICE_WIF = DP["addresses"][0][2]
ALICE_ADDRESS = wif2address(ALICE_WIF)
ALICE_PUBKEY = wif2pubkey(ALICE_WIF)
BOB_WIF = "cPs6DTGm4fLYdXB1888Q92VWwty6AJmzkKuvpgcZw96vE8npxFKK"
BOB_ADDRESS = wif2address(BOB_WIF)
BOB_PUBKEY = wif2pubkey(BOB_WIF)
SPEND_SECRET = (
    "7090c90a55489d3272c6edf46b1d391c971aeea5a8cc6755e6174608752c55a9"
)
SPEND_SECRET_HASH = hash160hex(SPEND_SECRET)
EXPIRE_TIME = 42
DEPOSIT_SCRIPT = compile_deposit_script(
    ALICE_PUBKEY, BOB_PUBKEY, SPEND_SECRET_HASH, EXPIRE_TIME
)
DEPOSIT_ADDRESS = script2address(DEPOSIT_SCRIPT, "XTN")

EXPECTED_STANDARD_USAGE_XCP = {
    "state": {
        "asset": "XCP",
        "deposit_script": DEPOSIT_SCRIPT,
        "commits_revoked": [],
        "commits_active": [],
        "commits_requested": []
    },
    "topublish": (
        "0100000001c1d8c075936c3495f6d653c50f73d987f75448d97a750249b1eb8"
        "3bee71b24ae000000001976a9144838d8b3588c4c7ba7c1d06f866e9b3739c6"
        "303788acffffffff031ed200000000000017a9144da69f37db3afa724bda4be"
        "c19fd7cd7b16747308700000000000000001e6a1c8a5dda15fb6f05628a061e"
        "67576e926dc71a7fa2f0cceb97452b4d18e665e90b000000001976a9144838d"
        "8b3588c4c7ba7c1d06f866e9b3739c6303788ac00000000"
    )
}


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_standard_usage_xcp(server_db):
    quantity = 42
    result = util.api(
        method="mpc_make_deposit",
        params={
            "asset": "XCP",
            "payer_pubkey": ALICE_PUBKEY,
            "payee_pubkey": BOB_PUBKEY,
            "spend_secret_hash": SPEND_SECRET_HASH,
            "expire_time": EXPIRE_TIME,  # in blocks
            "quantity": quantity  # in satoshis
        }
    )
    assert result == EXPECTED_STANDARD_USAGE_XCP

    # insert send, this automatically also creates a block
    util_test.insert_raw_transaction(result["topublish"], server_db)

    # check balances after send to deposit
    alice_balance = util.get_balance(server_db, ALICE_ADDRESS, 'XCP')
    deposit_balance = util.get_balance(server_db, DEPOSIT_ADDRESS, 'XCP')
    assert alice_balance == 91950000000 - quantity
    assert deposit_balance == quantity


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_standard_usage_btc(server_db):
    pass
