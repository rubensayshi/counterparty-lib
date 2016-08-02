import tempfile
import pytest

# this is require near the top to do setup of the test suite
# from counterpartylib.test import conftest

from counterpartylib.test import util_test
from counterpartylib.test.util_test import CURR_DIR
from counterpartylib.test.fixtures.params import DP

from counterpartylib.lib import util

from counterpartylib.lib.micropayments.util import wif2address
from counterpartylib.lib.micropayments.util import b2h, h2b
from counterpartylib.lib.micropayments.util import wif2pubkey
from counterpartylib.lib.micropayments.util import random_wif
from counterpartylib.lib.micropayments.scripts import compile_deposit_script
from counterpartylib.lib.micropayments.util import script2address
from counterpartylib.lib.micropayments.util import hash160hex


FIXTURE_SQL_FILE = CURR_DIR + '/fixtures/scenarios/unittest_fixture.sql'
FIXTURE_DB = tempfile.gettempdir() + '/fixtures.unittest_fixture.db'


ALICE_WIF = DP["addresses"][0][2]
ALICE_ADDRESS = wif2address(ALICE_WIF)
ALICE_PUBKEY = wif2pubkey(ALICE_WIF)
BOB_WIF = random_wif(netcode="XTN")
BOB_ADDRESS = wif2address(BOB_WIF)
BOB_PUBKEY = wif2pubkey(BOB_WIF)
DEPOSIT_SCRIPT = b2h(compile_deposit_script(
    ALICE_PUBKEY, BOB_PUBKEY, "a7ec62542b0d393d43442aadf8d55f7da1e303cb", 42
))
DEPOSIT_ADDRESS = script2address(h2b(DEPOSIT_SCRIPT), "XTN")

REVOKE_SECRET = (
    "7090c90a55489d3272c6edf46b1d391c971aeea5a8cc6755e6174608752c55a9"
)
REVOKE_SECRET_HASH = hash160hex(REVOKE_SECRET)


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_standard_usage_xcp(server_db):

    # send funds to deposit address
    deposit_rawtx = util.api('create_send', {
        'source': ALICE_ADDRESS,
        'destination': DEPOSIT_ADDRESS,
        'asset': "XCP",
        'quantity': 42,
        'regular_dust_size': 300000
    })
    util_test.insert_raw_transaction(deposit_rawtx, server_db)

    # TODO test request commit
    # result = util.api("mpc_request_commit", {
    #     "state": {
    #         "asset": "XCP",
    #         "deposit_script": DEPOSIT_SCRIPT,
    #         "commits_requested": [],
    #         "commits_active": [],
    #         "commits_revoked": []
    #     },
    #     "quantity": 21,
    #     "revoke_secret_hash": REVOKE_SECRET_HASH
    # })
    # assert result is not None


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_standard_usage_btc(server_db):
    pass  # FIXME test


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_invalid_quantity(server_db):
    pass  # FIXME test
