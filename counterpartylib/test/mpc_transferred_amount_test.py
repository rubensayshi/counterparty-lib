import tempfile
import pytest

# this is require near the top to do setup of the test suite
# from counterpartylib.test import conftest

# from counterpartylib.test import util_test
from counterpartylib.test.util_test import CURR_DIR
from counterpartylib.test.fixtures.params import DP
# from counterpartylib.lib import util
from counterpartylib.lib.micropayments.util import wif2address
from counterpartylib.lib.micropayments.util import wif2pubkey
from counterpartylib.lib.micropayments.util import random_wif


FIXTURE_SQL_FILE = CURR_DIR + '/fixtures/scenarios/unittest_fixture.sql'
FIXTURE_DB = tempfile.gettempdir() + '/fixtures.unittest_fixture.db'


ASSET = 'XCP'
ALICE_WIF = DP["addresses"][0][2]
ALICE_ADDRESS = wif2address(ALICE_WIF)
ALICE_PUBKEY = wif2pubkey(ALICE_WIF)
BOB_WIF = random_wif(netcode="XTN")
BOB_ADDRESS = wif2address(BOB_WIF)
BOB_PUBKEY = wif2pubkey(BOB_WIF)


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_standard_usage_xcp(server_db):
    pass  # TODO test


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_standard_usage_btc(server_db):
    pass  # TODO test