import tempfile
import pytest

# this is require near the top to do setup of the test suite
# from counterpartylib.test import conftest

from counterpartylib.test import util_test
from counterpartylib.test.util_test import CURR_DIR
from counterpartylib.test.fixtures.params import DP

from counterpartylib.lib import util

from micropayment_core.keys import address_from_wif
from micropayment_core.keys import pubkey_from_wif
from micropayment_core.util import script_address
from micropayment_core.util import hash160hex
from micropayment_core.scripts import compile_deposit_script


FIXTURE_SQL_FILE = CURR_DIR + '/fixtures/scenarios/unittest_fixture.sql'
FIXTURE_DB = tempfile.gettempdir() + '/fixtures.unittest_fixture.db'


ALICE_WIF = DP["addresses"][0][2]
ALICE_ADDRESS = address_from_wif(ALICE_WIF)
ALICE_PUBKEY = pubkey_from_wif(ALICE_WIF)
BOB_WIF = DP["addresses"][1][2]
BOB_PUBKEY = pubkey_from_wif(BOB_WIF)
SPEND_SECRET_HASH = "a7ec62542b0d393d43442aadf8d55f7da1e303cb"
EXPIRE_TIME = 42
DEPOSIT_SCRIPT = compile_deposit_script(
    ALICE_PUBKEY, BOB_PUBKEY, SPEND_SECRET_HASH, EXPIRE_TIME
)
DEPOSIT_ADDRESS = script_address(DEPOSIT_SCRIPT, "XTN")
REVOKE_SECRET = (
    "7090c90a55489d3272c6edf46b1d391c971aeea5a8cc6755e6174608752c55a9"
)
REVOKE_SECRET_HASH = hash160hex(REVOKE_SECRET)


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_invalid_quantity(server_db):

    # send funds to deposit address
    quantity = int(100 * 1e8)
    send1hex = util.api('create_send', {
        'source': ALICE_ADDRESS,
        'destination': DEPOSIT_ADDRESS,
        'asset': 'XCP',
        'quantity': quantity,
        'regular_dust_size': 300000
    })

    # insert send, this automatically also creates a block
    util_test.insert_raw_transaction(send1hex, server_db)

    # check balances after send to deposit
    alice_balance = util.get_balance(server_db, ALICE_ADDRESS, 'XCP')
    deposit_balance = util.get_balance(server_db, DEPOSIT_ADDRESS, 'XCP')
    assert alice_balance == 91950000000 - quantity
    assert deposit_balance == quantity
    assert DEPOSIT_ADDRESS == "2Mxa7u2xGFMEZPU44zYowZ11oapdkjXX45f"

    try:
        util.api("mpc_request_commit", {
            "state": {
                "asset": "XCP",
                "deposit_script": DEPOSIT_SCRIPT,
                "commits_requested": [],
                "commits_active": [],
                "commits_revoked": []
            },
            "quantity": quantity + 1,
            "revoke_secret_hash": REVOKE_SECRET_HASH
        })
        assert False
    except util.RPCError as e:
        assert "InvalidTransferQuantity" in str(e)
