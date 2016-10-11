import os
import tempfile
import pytest

# this is require near the top to do setup of the test suite
# from counterpartylib.test import conftest

from counterpartylib.test import util_test
from counterpartylib.test.util_test import CURR_DIR
from counterpartylib.test.fixtures.params import DP

from counterpartylib.lib import util

from counterpartylib.lib.micropayments.util import b2h
from counterpartylib.lib.micropayments.util import wif2address
from counterpartylib.lib.micropayments.util import wif2pubkey
from counterpartylib.lib.micropayments.util import script2address
from counterpartylib.lib.micropayments.util import hash160hex
from counterpartylib.lib.micropayments import scripts


FIXTURE_SQL_FILE = CURR_DIR + '/fixtures/scenarios/unittest_fixture.sql'
FIXTURE_DB = tempfile.gettempdir() + '/fixtures.unittest_fixture.db'


# actors
ALICE_WIF = DP["addresses"][0][2]  # payer
ALICE_ADDRESS = wif2address(ALICE_WIF)
ALICE_PUBKEY = wif2pubkey(ALICE_WIF)
BOB_WIF = DP["addresses"][1][2]  # payee
BOB_ADDRESS = wif2address(BOB_WIF)
BOB_PUBKEY = wif2pubkey(BOB_WIF)


# secrets
SPEND_SECRET = b2h(os.urandom(32))
SPEND_SECRET_HASH = hash160hex(SPEND_SECRET)


# deposit
DEPOSIT_EXPIRE_TIME = 42
DEPOSIT_SCRIPT = scripts.compile_deposit_script(
    ALICE_PUBKEY, BOB_PUBKEY, SPEND_SECRET_HASH, DEPOSIT_EXPIRE_TIME
)
DEPOSIT_ADDRESS = script2address(DEPOSIT_SCRIPT, "XTN")


def get_tx(txid):
    return util.api(method="getrawtransaction", params={"tx_hash": txid})


def assert_transferred(payer, payee, quantity):
    assert util.api("mpc_transferred_amount", {"state": payer}) == quantity
    assert util.api("mpc_transferred_amount", {"state": payee}) == quantity


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_usage_xcp(server_db):

    # check initial balances
    alice_balance = util.get_balance(server_db, ALICE_ADDRESS, 'XCP')
    deposit_balance = util.get_balance(server_db, DEPOSIT_ADDRESS, 'XCP')
    bob_balance = util.get_balance(server_db, BOB_ADDRESS, 'XCP')
    assert alice_balance == 91950000000
    assert deposit_balance == 0
    assert bob_balance == 99999990

    # ===== PAYER PUBLISHES DEPOSIT =====

    quantity = 41
    result = util.api(
        method="mpc_make_deposit",
        params={
            "asset": "XCP",
            "payer_pubkey": ALICE_PUBKEY,
            "payee_pubkey": BOB_PUBKEY,
            "spend_secret_hash": SPEND_SECRET_HASH,
            "expire_time": DEPOSIT_EXPIRE_TIME,  # in blocks
            "quantity": quantity  # in satoshis
        }
    )
    alice_state = result["state"]
    # FIXME sign deposit tx

    # insert send, this automatically also creates a block
    util_test.insert_raw_transaction(result["topublish"], server_db)

    # check balances after send to deposit
    alice_balance = util.get_balance(server_db, ALICE_ADDRESS, 'XCP')
    deposit_balance = util.get_balance(server_db, DEPOSIT_ADDRESS, 'XCP')
    bob_balance = util.get_balance(server_db, BOB_ADDRESS, 'XCP')
    assert alice_balance == 91950000000 - quantity
    assert deposit_balance == quantity
    assert bob_balance == 99999990

    # ===== PAYEE SETS DEPOSIT =====

    bob_state = util.api("mpc_set_deposit", {
        "asset": "XCP",
        "deposit_script": DEPOSIT_SCRIPT,
        "expected_payee_pubkey": BOB_PUBKEY,
        "expected_spend_secret_hash": SPEND_SECRET_HASH
    })

    bob_state = util.api("mpc_set_deposit", {
        "asset": "XCP",
        "deposit_script": DEPOSIT_SCRIPT,
        "expected_payee_pubkey": BOB_PUBKEY,
        "expected_spend_secret_hash": SPEND_SECRET_HASH
    })

    assert_transferred(alice_state, bob_state, 0)

    # ===== TRANSFER MICRO PAYMENTS =====

    revoke_secrets = {}
    for transfer_quantity in [1, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41]:

        # ===== PAYEE REQUESTS COMMIT =====

        revoke_secret = b2h(os.urandom(32))
        revoke_secret_hash = hash160hex(revoke_secret)
        revoke_secrets[revoke_secret_hash] = revoke_secret
        bob_state = util.api("mpc_request_commit", {
            "state": bob_state,
            "quantity": transfer_quantity,
            "revoke_secret_hash": revoke_secret_hash
        })

        # ===== PAYER CREATES COMMIT =====

        result = util.api("mpc_create_commit", {
            "state": alice_state,
            "quantity": transfer_quantity,
            "revoke_secret_hash": revoke_secret_hash,
            "delay_time": 2
        })
        alice_state = result["state"]
        commit_script = result["commit_script"]
        commit_rawtx = result["tosign"]["commit_rawtx"]
        deposit_script = result["tosign"]["deposit_script"]
        signed_commit_rawtx = scripts.sign_created_commit(
            get_tx, ALICE_WIF, commit_rawtx, deposit_script
        )

        # ===== PAYEE UPDATES STATE =====

        bob_state = util.api("mpc_add_commit", {
            "state": bob_state,
            "commit_rawtx": signed_commit_rawtx,
            "commit_script": commit_script,
        })
        assert_transferred(alice_state, bob_state, transfer_quantity)

    # ===== PAYEE RETURNS FUNDS =====

    # get secrets to revoke
    revoke_hashes = util.api("mpc_revoke_hashes_until", {
        "state": bob_state, "quantity": 15, "surpass": False,
    })
    secrets = [v for k, v in revoke_secrets.items() if k in revoke_hashes]
    assert len(secrets) == 6

    # payee revokes commits
    bob_state = util.api("mpc_revoke_all", {
        "state": bob_state, "secrets": secrets,
    })

    # payer revokes commits
    alice_state = util.api("mpc_revoke_all", {
        "state": alice_state, "secrets": secrets,
    })
    assert_transferred(alice_state, bob_state, 17)

    # ===== PAYEE CLOSES CHANNEL =====

    result = util.api("mpc_highest_commit", {"state": bob_state})
    signed_commit = scripts.sign_finalize_commit(
        get_tx, BOB_WIF, result["commit_rawtx"], result["deposit_script"]
    )
    # insert commit, this automatically also creates a block
    util_test.insert_raw_transaction(signed_commit, server_db)

    # ===== PAYEE RECOVERS PAYOUT =====

    for payout in util.api("mpc_payouts", {"state": bob_state}):
        signed_payout_rawtx = scripts.sign_payout_recover(
            get_tx, BOB_WIF, payout["payout_rawtx"],
            payout["commit_script"], SPEND_SECRET
        )
        # insert commit, this automatically also creates a block
        util_test.insert_raw_transaction(signed_payout_rawtx, server_db)

    # ===== PAYER RECOVERS CHANGE =====

    # let delay time pass
    util_test.create_next_block(server_db)

    recoverables = util.api("mpc_recoverables", {"state": alice_state})
    for change in recoverables["change"]:
        signed_change_rawtx = scripts.sign_change_recover(
            get_tx, ALICE_WIF, change["change_rawtx"],
            change["deposit_script"], change["spend_secret"]
        )
        # insert commit, this automatically also creates a block
        util_test.insert_raw_transaction(signed_change_rawtx, server_db)

    # FIXME check payer and payee balances match expected
    # alice_balance = util.get_balance(server_db, ALICE_ADDRESS, 'XCP')
    # bob_balance = util.get_balance(server_db, BOB_ADDRESS, 'XCP')
    # assert alice_balance == 91950000000 - 17
    # assert bob_balance == 99999990 + 17


@pytest.mark.usefixtures("server_db")
@pytest.mark.usefixtures("api_server")
def test_usage_btc(server_db):
    pass  # FIXME test
