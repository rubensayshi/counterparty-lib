import tempfile
import pytest

# this is require near the top to do setup of the test suite
# from counterpartylib.test import conftest

from counterpartylib.test import util_test
from counterpartylib.test.util_test import CURR_DIR
from counterpartylib.test.fixtures.params import DP
from counterpartylib.lib import util
from counterpartylib.lib.micropayments.util import wif2address
from counterpartylib.lib.micropayments.util import random_wif


FIXTURE_SQL_FILE = CURR_DIR + '/fixtures/scenarios/unittest_fixture.sql'
FIXTURE_DB = tempfile.gettempdir() + '/fixtures.unittest_fixture.db'


# actors
ALICE_WIF = DP["addresses"][0][2]
ALICE_ADDRESS = DP["addresses"][0][0]
BOB_WIF = random_wif(netcode="XTN")
BOB_ADDRESS = wif2address(BOB_WIF)


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_search_tx(server_db):

    rawtx = util.api('create_send', {
        'source': ALICE_ADDRESS,
        'destination': BOB_ADDRESS,
        'asset': 'XCP',
        'quantity': 42
    })

    transactions = util.api(
        method="search_raw_transactions",
        params={
            "address": BOB_ADDRESS,
            "unconfirmed": False
        }
    )
    assert len(transactions) == 0

    # insert send, this automatically also creates a block
    util_test.insert_raw_transaction(rawtx, server_db)

    transactions = util.api(
        method="search_raw_transactions",
        params={"address": BOB_ADDRESS, "unconfirmed": False}
    )
    assert len(transactions) == 1
