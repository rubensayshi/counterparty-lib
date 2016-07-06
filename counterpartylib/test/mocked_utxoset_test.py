import pprint
import tempfile
import pytest
from counterpartylib.test import conftest  # this is require near the top to do setup of the test suite
from counterpartylib.test import util_test
from counterpartylib.test.util_test import CURR_DIR
from counterpartylib.test.fixtures.params import DP, ADDR

from counterpartylib.lib import util, backend

FIXTURE_SQL_FILE = CURR_DIR + '/fixtures/scenarios/unittest_fixture.sql'
FIXTURE_DB = tempfile.gettempdir() + '/fixtures.unittest_fixture.db'


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_searchtransactions(server_db):
    assert len(backend.searchrawtransactions(ADDR[0], unconfirmed=True)) == 27
    assert len(backend.searchrawtransactions(ADDR[0], unconfirmed=False)) == 27

    # create send
    v = int(100 * 1e8)
    send1hex = util.api('create_send', {'source': ADDR[0], 'destination': ADDR[1], 'asset': 'XCP', 'quantity': v})

    # insert send, this automatically also creates a block
    tx1 = util_test.insert_raw_transaction(send1hex, server_db)

    assert len(backend.searchrawtransactions(ADDR[0], unconfirmed=True)) == 28
    assert len(backend.searchrawtransactions(ADDR[0], unconfirmed=False)) == 28

    # create send
    v = int(100 * 1e8)
    send2hex = util.api('create_send', {'source': ADDR[0], 'destination': ADDR[1], 'asset': 'XCP', 'quantity': v})

    # insert send, this automatically also creates a block
    tx2 = util_test.insert_unconfirmed_raw_transaction(send2hex, server_db)

    assert len(backend.searchrawtransactions(ADDR[0], unconfirmed=True)) == 29
    assert len(backend.searchrawtransactions(ADDR[0], unconfirmed=False)) == 28
