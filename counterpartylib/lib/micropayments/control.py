# coding: utf-8
# Copyright (c) 2016 Fabian Barkhau <fabian.barkhau@gmail.com>
# License: MIT (see LICENSE file)


import copy
import pycoin
from . import util
from . import validate
from . import exceptions
from . import scripts


INITIAL_STATE = {
    "asset": None,

    "deposit_script": None,

    # Quantity not needed as payer may change it. If its heigher its
    # against our self intrest to throw away money. If its lower it
    # gives us a better resolution when reversing the channel.
    "commits_requested": [],  # ["revoke_secret_hash"]

    # must be ordered lowest to heighest at all times!
    "commits_active": [],     # [{
    #                             "rawtx": hex,
    #                             "script": hex,
    #                           }]

    "commits_revoked": [],    # [{
    #                             "script": hex,
    #                             "revoke_secret": hex
    #                           }]
}


def get_published_commits(dispatcher, state, netcode):
    deposit_script = state["deposit_script"]
    deposit_address = util.script2address(deposit_script, netcode)
    deposit_transactions = dispatcher.get("search_raw_transactions")(
        address=deposit_address, unconfirmed=True
    )
    deposit_txids = [tx["txid"] for tx in deposit_transactions]
    commits = state["commits_active"] + state["commits_revoked"]
    for commit_script in [commit["script"] for commit in commits]:
        commit_address = util.script2address(commit_script, netcode)
        commit_transactions = dispatcher.get("search_raw_transactions")(
            address=commit_address, unconfirmed=True
        )
        for commit_transaction in commit_transactions:
            if commit_transaction["txid"] in deposit_txids:
                return commit_transaction["hex"]  # spend: deposit -> commit
    return None


def make_deposit(dispatcher, asset, payer_pubkey, payee_pubkey,
                 spend_secret_hash, expire_time, quantity,
                 netcode, fee, regular_dust_size):

    # validate input
    _validate_deposit(dispatcher, asset, payer_pubkey, payee_pubkey,
                      spend_secret_hash, expire_time, quantity,
                      netcode, fee, regular_dust_size)

    # create deposit
    rawtx, script = _create_deposit(
        dispatcher, asset, payer_pubkey, payee_pubkey, spend_secret_hash,
        expire_time, quantity, netcode, fee, regular_dust_size
    )

    # setup initial state
    state = copy.deepcopy(INITIAL_STATE)
    state["asset"] = asset
    state["deposit_script"] = script

    return {
        "state": state,
        "topublish": rawtx
    }


def set_deposit(asset, deposit_script, expected_payee_pubkey,
                expected_spend_secret_hash):

    # validate input
    # FIXME validate asset
    validate.pubkey(expected_payee_pubkey)
    validate.hash160(expected_spend_secret_hash)
    validate.deposit_script(deposit_script, expected_payee_pubkey,
                            expected_spend_secret_hash)

    # setup initial state
    state = copy.deepcopy(INITIAL_STATE)
    state["asset"] = asset
    state["deposit_script"] = deposit_script

    return state


def request_commit(dispatcher, state, quantity, revoke_secret_hash, netcode):

    # validate input
    validate.state(state)
    validate.is_quantity(quantity)
    validate.hash160(revoke_secret_hash)
    _validate_transfer_quantity(dispatcher, state, quantity, netcode)

    # update state
    state["commits_requested"].append(revoke_secret_hash)

    return {
        "state": state,
        "quantity": quantity,
        "revoke_secret_hash": revoke_secret_hash
    }


def create_commit(dispatcher, state, quantity, revoke_secret_hash,
                  delay_time, netcode, fee, regular_dust_size):

    # validate input
    validate.state(state)
    validate.is_quantity(quantity)
    validate.hash160(revoke_secret_hash)
    validate.is_sequence(delay_time)
    _validate_transfer_quantity(dispatcher, state, quantity, netcode)

    # create deposit script and rawtx
    deposit_script = state["deposit_script"]
    rawtx, commit_script = _create_commit(
        dispatcher, state["asset"], deposit_script, quantity,
        revoke_secret_hash, delay_time, netcode, fee, regular_dust_size
    )

    # update state
    _order_active(dispatcher, state)
    state["commits_active"].append({
        "rawtx": rawtx, "script": commit_script
    })

    return {
        "state": state,
        "commit_script": commit_script,
        "tosign": {
            "commit_rawtx": rawtx,
            "deposit_script": state["deposit_script"]
        }
    }


def add_commit(dispatcher, state, commit_rawtx, commit_script, netcode):

    # validate input
    validate.state(state)
    validate.commit_script(commit_script, state["deposit_script"])
    deposit_address = util.script2address(
        state["deposit_script"], netcode=netcode
    )
    deposit_utxos = dispatcher.get("get_unspent_txouts")(deposit_address)
    validate.commit_rawtx(deposit_utxos, commit_rawtx, state["asset"],
                          state["deposit_script"], commit_script, netcode)

    # update state
    script = commit_script
    script_revoke_secret_hash = scripts.get_commit_revoke_secret_hash(script)
    for revoke_secret_hash in state["commits_requested"][:]:

        # revoke secret hash must match as it would
        # otherwise break the channels reversability
        if script_revoke_secret_hash == revoke_secret_hash:

            # remove from requests
            state["commits_requested"].remove(revoke_secret_hash)

            # add to active
            _order_active(dispatcher, state)
            state["commits_active"].append({
                "rawtx": commit_rawtx,
                "script": commit_script
            })
            return state

    raise ValueError("No revoke secret for given commit script.")


def revoke_hashes_until(dispatcher, state, quantity, surpass):

    # validate input
    validate.state(state)
    validate.is_unsigned(quantity)

    # get revoke secret hashes
    revoke_secret_hashes = []
    _order_active(dispatcher, state)
    exact_match = False
    for commit in reversed(state["commits_active"][:]):
        asset = state["asset"]
        rawtx = commit["rawtx"]
        commit_quantity = _get_quantity(dispatcher, asset, rawtx)
        exact_match = quantity == commit_quantity
        if quantity < commit_quantity:
            script = commit["script"]
            secret_hash = scripts.get_commit_revoke_secret_hash(script)
            revoke_secret_hashes.append(secret_hash)
        else:
            break

    # prevent revoking past quantity unless explicitly requested
    if not exact_match and not surpass and len(revoke_secret_hashes) > 0:
        revoke_secret_hashes.pop()

    return revoke_secret_hashes


def revoke_all(state, secrets):

    # validate input
    validate.state(state)
    validate.is_list(secrets)
    for secret in secrets:
        validate.is_hex(secret)

    # update state
    list(map(lambda s: _revoke(state, s), secrets))

    return state


def highest_commit(dispatcher, state):

    # validate input
    validate.state(state)

    _order_active(dispatcher, state)
    if len(state["commits_active"]) == 0:
        return None
    commit = state["commits_active"][-1]

    return {
        "commit_rawtx": commit["rawtx"],
        "deposit_script": state["deposit_script"],
    }


def transferred_amount(dispatcher, state):

    if len(state["commits_active"]) == 0:
        return 0
    _order_active(dispatcher, state)
    commit = state["commits_active"][-1]
    return _get_quantity(dispatcher, state["asset"], commit["rawtx"])


def payouts(dispatcher, state, netcode, fee, regular_dust_size):

    # validate input
    validate.state(state)

    # find recoverables and make payout transactions
    payouts = []
    recoverable_scripts = _get_payout_recoverable(dispatcher, state, netcode)
    if len(recoverable_scripts) > 0:
        deposit_script = state["deposit_script"]
        payee_pubkey = scripts.get_deposit_payee_pubkey(deposit_script)
        for script in recoverable_scripts:
            rawtx = _create_recover_commit(
                dispatcher, state["asset"], payee_pubkey, script, "payout",
                netcode, fee, regular_dust_size
            )
            payouts.append({
                "payout_rawtx": rawtx, "commit_script": script
            })
    return payouts


def recoverables(dispatcher, state, netcode, fee, regular_dust_size):

    # validate input
    validate.state(state)

    deposit_script = state["deposit_script"]
    payer_pubkey = scripts.get_deposit_payer_pubkey(deposit_script)
    recoverables = {"revoke": [], "change": [], "expire": []}

    # If revoked commit published, recover funds asap!
    revokable = _get_revoke_recoverable(dispatcher, state, netcode)
    if len(revokable) > 0:
        for script, secret in revokable:
            rawtx = _create_recover_commit(
                dispatcher, state["asset"], payer_pubkey, script, "revoke",
                netcode, fee, regular_dust_size
            )
            recoverables["revoke"].append({
                "revoke_rawtx": rawtx,
                "commit_script": script,
                "revoke_secret": secret
            })

    # If deposit expired recover the coins!
    if _can_expire_recover(dispatcher, state, netcode):
        rawtx = _recover_deposit(
            dispatcher, state["asset"], payer_pubkey, deposit_script,
            "expire", netcode, fee, regular_dust_size
        )
        recoverables["expire"].append({
            "expire_rawtx": rawtx,
            "deposit_script": state["deposit_script"]
        })

    else:

        # If not expired and spend secret exposed by payout
        # recover change!
        address = util.script2address(deposit_script, netcode)
        if _can_spend_from_address(dispatcher, state["asset"], address):
            _spend_secret = _find_spend_secret(dispatcher, state, netcode)
            if _spend_secret is not None:
                rawtx = _recover_deposit(
                    dispatcher, state["asset"], payer_pubkey, deposit_script,
                    "change", netcode, fee, regular_dust_size
                )
                recoverables["change"].append({
                    "change_rawtx": rawtx,
                    "deposit_script": state["deposit_script"],
                    "spend_secret": _spend_secret
                })

    return recoverables


def _deposit_status(dispatcher, asset, script, netcode):
    address = util.script2address(script, netcode)
    transactions = dispatcher.get("search_raw_transactions")(address)
    if len(transactions) == 0:
        return 0, 0, 0
    oldest_confirms = transactions[0].get("confirmations", 0)
    asset_balance, btc_balance = _get_address_balance(
        dispatcher, asset, address
    )
    return oldest_confirms, asset_balance, btc_balance


def _validate_channel_unused(dispatcher, channel_address):
    transactions = dispatcher.get("search_raw_transactions")(channel_address)
    if len(transactions) > 0:
        raise exceptions.ChannelAlreadyUsed(channel_address, transactions)


def _recover_tx(dispatcher, asset, dest_address, script, netcode, fee,
                regular_dust_size, sequence):

    # get channel info
    src_address = util.script2address(script, netcode)
    asset_balance, btc_balance = _get_address_balance(
        dispatcher, asset, src_address
    )

    # create expire tx
    rawtx = _create_tx(
        dispatcher, asset, src_address, dest_address, asset_balance,
        btc_balance - fee, fee, regular_dust_size
    )

    # prep for script compliance and signing
    tx = pycoin.tx.Tx.from_hex(rawtx)
    if sequence:
        tx.version = 2  # enable relative lock-time, see bip68 & bip112
    for txin in tx.txs_in:
        if sequence:
            txin.sequence = sequence  # relative lock-time
        utxo_rawtx = dispatcher.get("getrawtransaction")(
            tx_hash=util.b2h_rev(txin.previous_hash)
        )
        utxo_tx = pycoin.tx.Tx.from_hex(utxo_rawtx)
        tx.unspents.append(utxo_tx.txs_out[txin.previous_index])
    rawtx = tx.as_hex()
    return rawtx


def _create_recover_commit(dispatcher, asset, pubkey, script, spend_type,
                           netcode, fee, regular_dust_size):
    dest_address = util.pubkey2address(pubkey, netcode=netcode)
    delay_time = scripts.get_commit_delay_time(script)
    return _recover_tx(dispatcher, asset, dest_address, script, netcode, fee,
                       regular_dust_size, delay_time)


def _recover_deposit(dispatcher, asset, pubkey, script, spend_type,
                     netcode, fee, regular_dust_size):
    dest_address = util.pubkey2address(pubkey, netcode=netcode)
    expire_time = scripts.get_deposit_expire_time(script)
    rawtx = _recover_tx(
        dispatcher, asset, dest_address, script,
        netcode, fee, regular_dust_size,
        expire_time if spend_type == "expire" else None
    )
    return rawtx


def _create_commit(dispatcher, asset, deposit_script, quantity,
                   revoke_secret_hash, delay_time, netcode,
                   fee, regular_dust_size):

    # create script
    payer_pubkey = scripts.get_deposit_payer_pubkey(deposit_script)
    payee_pubkey = scripts.get_deposit_payee_pubkey(deposit_script)
    spend_secret_hash = scripts.get_deposit_spend_secret_hash(deposit_script)
    commit_script = scripts.compile_commit_script(
        payer_pubkey, payee_pubkey, spend_secret_hash,
        revoke_secret_hash, delay_time
    )

    # create tx
    src_address = util.script2address(deposit_script, netcode)
    dest_address = util.script2address(commit_script, netcode)
    asset_balance, btc_balance = _get_address_balance(
        dispatcher, asset, src_address
    )
    if quantity == asset_balance:  # spend all btc as change tx not needed
        extra_btc = btc_balance - fee
    else:  # provide extra btc for future payout/revoke tx fees
        extra_btc = (fee + regular_dust_size)
    rawtx = _create_tx(dispatcher, asset, src_address, dest_address, quantity,
                       extra_btc, fee, regular_dust_size)

    return rawtx, commit_script


def _create_deposit(dispatcher, asset, payer_pubkey, payee_pubkey,
                    spend_secret_hash, expire_time, quantity, netcode, fee,
                    regular_dust_size):

    script = scripts.compile_deposit_script(payer_pubkey, payee_pubkey,
                                            spend_secret_hash, expire_time)
    dest_address = util.script2address(script, netcode)
    _validate_channel_unused(dispatcher, dest_address)
    payer_address = util.pubkey2address(payer_pubkey, netcode)
    extra_btc = util.get_fee_multaple(3)  # for change + commit + recover tx
    rawtx = _create_tx(dispatcher, asset, payer_address, dest_address,
                       quantity, extra_btc, fee, regular_dust_size)
    return rawtx, script


def _create_tx(dispatcher, asset, source_address, dest_address, quantity,
               extra_btc, fee, regular_dust_size):
    assert(extra_btc >= 0)
    rawtx = dispatcher.get("create_send")(
        source=source_address,
        destination=dest_address,
        quantity=quantity,
        asset=asset,
        regular_dust_size=(extra_btc or regular_dust_size),
        fee=fee,
        disable_utxo_locks=True
    )
    assert(_get_quantity(dispatcher, asset, rawtx) == quantity)
    return rawtx


def _can_spend_from_address(dispatcher, asset, address):

    # has assets, btc
    if _get_address_balance(dispatcher, asset, address) == (0, 0):
        return False

    # TODO check if btc > fee

    # can only spend if all txs confirmed
    transactions = dispatcher.get("search_raw_transactions")(address)
    latest_confirms = transactions[-1].get("confirmations", 0)
    return latest_confirms > 0


def _get_address_balance(dispatcher, asset, address):
    # FIXME test ignores unconfirmed
    result = dispatcher.get("get_balances")(filters=[
        {'field': 'address', 'op': '==', 'value': address},
        {'field': 'asset', 'op': '==', 'value': asset},
    ])
    if not result:  # TODO what causes this?
        return 0, 0
    asset_balance = result[0]["quantity"]
    utxos = dispatcher.get("get_unspent_txouts")(address)
    btc_balance = sum(map(lambda utxo: util.tosatoshis(utxo["amount"]), utxos))
    return asset_balance, btc_balance


def _get_quantity(dispatcher, expected_asset, rawtx):
    result = dispatcher.get("get_tx_info")(tx_hex=rawtx)
    src, dest, btc, fee, data = result
    result = dispatcher.get("unpack")(data_hex=data)
    message_type_id, unpacked = result
    if message_type_id != 0:
        msg = "Incorrect message type id: {0} != {1}"
        raise ValueError(msg.format(message_type_id, 0))
    if expected_asset != unpacked["asset"]:
        msg = "Incorrect asset: expected {0} != {1} found!"
        raise ValueError(msg.format(expected_asset, unpacked["asset"]))
    return unpacked["quantity"]


def _validate_transfer_quantity(dispatcher, state, quantity, netcode):
    script = state["deposit_script"]
    confirms, asset_balance, btc_balance = _deposit_status(
        dispatcher, state["asset"], script, netcode
    )
    if quantity > asset_balance:
        msg = "Amount greater total: {0} > {1}"
        raise ValueError(msg.format(quantity, asset_balance))


def _order_active(dispatcher, state):

    def sort_func(entry):
        return _get_quantity(dispatcher, state["asset"], entry["rawtx"])
    state["commits_active"].sort(key=sort_func)


def _revoke(state, secret):
    secret_hash = util.hash160hex(secret)
    for commit in state["commits_active"][:]:
        script = commit["script"]
        if secret_hash == scripts.get_commit_revoke_secret_hash(script):
            state["commits_active"].remove(commit)
            commit["revoke_secret"] = secret  # save secret
            del commit["rawtx"]  # forget rawtx so we can never publish
            state["commits_revoked"].append(commit)


def _get_payout_recoverable(dispatcher, state, netcode):
    _scripts = []
    for commit in (state["commits_active"] + state["commits_revoked"]):
        script = commit["script"]
        delay_time = scripts.get_commit_delay_time(script)
        address = util.script2address(script, netcode=netcode)
        if _can_spend_from_address(dispatcher, state["asset"], address):
            for utxo in dispatcher.get("get_unspent_txouts")(address):
                if utxo["confirmations"] >= delay_time:
                    _scripts.append(script)
    return _scripts


def _can_expire_recover(dispatcher, state, netcode):
    return (
        # deposit was made
        state["deposit_script"] is not None and

        # deposit expired
        deposit_expired(dispatcher, state, 0, netcode) and

        # funds to recover
        _can_deposit_spend(dispatcher, state, netcode)
    )


def _can_deposit_spend(dispatcher, state, netcode):
    script = state["deposit_script"]
    address = util.script2address(script, netcode)
    return _can_spend_from_address(dispatcher, state["asset"], address)


def deposit_expired(dispatcher, state, clearance, netcode):
    validate.is_unsigned(clearance)
    validate.state(state)
    script = state["deposit_script"]
    t = scripts.get_deposit_expire_time(script)
    confirms, asset_balance, btc_balance = _deposit_status(
        dispatcher, state["asset"], script, netcode
    )
    return (confirms + clearance) >= t


def _validate_deposit(dispatcher, asset, payer_pubkey, payee_pubkey,
                      spend_secret_hash, expire_time, quantity,
                      netcode, fee, regular_dust_size):

    # validate untrusted input data
    validate.pubkey(payer_pubkey)
    validate.pubkey(payee_pubkey)
    validate.hash160(spend_secret_hash)
    validate.is_sequence(expire_time)
    validate.is_quantity(quantity)
    # FIXME validate asset

    # get balances
    address = util.pubkey2address(payer_pubkey, netcode)
    asset_balance, btc_balance = _get_address_balance(
        dispatcher, asset, address
    )

    # check asset balance
    if asset_balance < quantity:
        raise exceptions.InsufficientFunds(quantity, asset_balance,
                                           address, asset)

    # check btc balance
    extra_btc = (fee + regular_dust_size) * 3
    if btc_balance < extra_btc:
        raise exceptions.InsufficientFunds(extra_btc, btc_balance,
                                           address, "BTC")


def _find_spend_secret(dispatcher, state, netcode):
    for commit in state["commits_active"] + state["commits_revoked"]:
        script = commit["script"]
        address = util.script2address(
            script, netcode=netcode
        )

        transactions = dispatcher.get("search_raw_transactions")(address)
        if len(transactions) == 1:
            continue  # only the commit, no payout
        for transaction in transactions:
            _spend_secret = scripts.get_spend_secret(transaction["hex"], script)
            if _spend_secret is not None:
                return _spend_secret
    return None


def _get_revoke_recoverable(dispatcher, state, netcode):
    revokable = []  # (script, secret)
    for commit in state["commits_revoked"]:
        script = commit["script"]
        address = util.script2address(script, netcode=netcode)
        if _can_spend_from_address(dispatcher, state["asset"], address):
            revokable.append((script, commit["revoke_secret"]))
    return revokable
