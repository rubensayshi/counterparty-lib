import tempfile
import pytest
# this is require near the top to do setup of the test suite
# from counterpartylib.test import conftest

# from counterpartylib.test import util_test
from counterpartylib.test.util_test import CURR_DIR
from counterpartylib.test.fixtures.params import DP
from counterpartylib.lib import util
from counterpartylib.lib.micropayments.util import hash160hex
from counterpartylib.lib.micropayments.util import wif2address
from counterpartylib.lib.micropayments.util import wif2pubkey


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


EXPECTED_STANDARD_USAGE_XCP = {
    "state": {
        "asset": "XCP",
        "commits_requested": [],
        "deposit_script": (
            "6352210282b886c087eb37dc8182f14ba6cc3e9485ed618b95804d44aecc17c"
            "300b585b0210279768d0eb8daf6db6557a677517fdde3293f2de663c54c3c82"
            "8575315d8eb9cf52ae6763a91449664925db2446845475631b33cb5c6e614c8"
            "45988210282b886c087eb37dc8182f14ba6cc3e9485ed618b95804d44aecc17"
            "c300b585b0ac67023905b275210282b886c087eb37dc8182f14ba6cc3e9485e"
            "d618b95804d44aecc17c300b585b0ac6868"
        ),
        "commits_revoked": [],
        "commits_active": []
    },
    "topublish": (
        "0100000001c1d8c075936c3495f6d653c50f73d987f75448d97a750249b1eb83bee"
        "71b24ae000000001976a9144838d8b3588c4c7ba7c1d06f866e9b3739c6303788ac"
        "ffffffff03d2b400000000000017a91459ba717d7d8b1d7a76fb375b0eeac132422"
        "5f0b88700000000000000001e6a1c8a5dda15fb6f05628a061e67576e926dc71a7f"
        "a2f0cceb97452b4d183283e90b000000001976a9144838d8b3588c4c7ba7c1d06f8"
        "66e9b3739c6303788ac00000000"
    )
}


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_standard_usage_xcp(server_db):
    result = util.api(
        method="mpc_make_deposit",
        params={
            "asset": "XCP",
            "payer_pubkey": ALICE_PUBKEY,
            "payee_pubkey": BOB_PUBKEY,
            "spend_secret_hash": SPEND_SECRET_HASH,
            "expire_time": 1337,  # in blocks
            "quantity": 42  # in satoshis
        }
    )
    assert result == EXPECTED_STANDARD_USAGE_XCP


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_standard_usage_btc(server_db):
    pass  # TODO test
