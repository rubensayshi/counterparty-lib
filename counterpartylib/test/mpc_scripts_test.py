import json
from counterpartylib.lib.micropayments import scripts


FIXTURES = json.load(open("test/scripts_fixtures.json"))


def _get_tx_func(txid):
    return FIXTURES["transactions"][txid]


def test_validate_deposit_script():
    scripts.validate_deposit_script(FIXTURES["deposit"]["script_hex"])


def test_validate_commit_script():
    scripts.validate_commit_script(FIXTURES["commit"]["script_hex"])


def test_validate_incorrect_script():

    try:
        deposit_script_hex = FIXTURES["deposit"]["script_hex"]
        reference_script_hex = scripts.compile_deposit_script(
            "deadbeef", "deadbeef", "deadbeef", "f483"
        )
        scripts.validate(reference_script_hex, deposit_script_hex)
        assert False
    except scripts.InvalidScript:
        assert True


def test_validate_incorrect_length():

    try:
        deposit_script_hex = FIXTURES["deposit"]["script_hex"] + "f483"
        reference_script_hex = scripts.compile_deposit_script(
            "deadbeef", "deadbeef", "deadbeef", "deadbeef"
        )
        scripts.validate(reference_script_hex, deposit_script_hex)
        assert False
    except scripts.InvalidScript:
        assert True


def test_get_spend_secret_bad_rawtx():
    bad_rawtx = FIXTURES["payout"]["bad_rawtx"]
    commit_script_hex = FIXTURES["payout"]["commit_script_hex"]
    result = scripts.get_spend_secret(bad_rawtx, commit_script_hex)
    assert result is None


def test_get_spend_secret():
    expected = FIXTURES["payout"]["spend_secret"]
    payout_rawtx = FIXTURES["payout"]["rawtx"]
    commit_script_hex = FIXTURES["payout"]["commit_script_hex"]
    spend_secret = scripts.get_spend_secret(payout_rawtx,
                                            commit_script_hex)
    assert spend_secret == expected


def test_get_commit_payer_pubkey():
    commit_script_hex = FIXTURES["commit"]["script_hex"]
    expected = FIXTURES["commit"]["payer_pubkey"]
    payer_pubkey = scripts.get_commit_payer_pubkey(commit_script_hex)
    assert payer_pubkey == expected


def test_get_commit_payee_pubkey():
    commit_script_hex = FIXTURES["commit"]["script_hex"]
    expected = FIXTURES["commit"]["payee_pubkey"]
    payee_pubkey = scripts.get_commit_payee_pubkey(commit_script_hex)
    assert payee_pubkey == expected


def test_get_commit_spend_secret_hash():
    commit_script_hex = FIXTURES["commit"]["script_hex"]
    expected = FIXTURES["commit"]["spend_secret_hash"]
    spend_secret_hash = scripts.get_commit_spend_secret_hash(
        commit_script_hex
    )
    assert spend_secret_hash == expected


def test_get_commit_revoke_secret_hash():
    commit_script_hex = FIXTURES["commit"]["script_hex"]
    expected = FIXTURES["commit"]["revoke_secret_hash"]
    revoke_secret_hash = scripts.get_commit_revoke_secret_hash(
        commit_script_hex
    )
    assert revoke_secret_hash == expected


def test_get_deposit_expire_time():
    deposit_script_hex = FIXTURES["deposit"]["script_hex"]
    expected = FIXTURES["deposit"]["expire_time"]
    expire_time = scripts.get_deposit_expire_time(deposit_script_hex)
    assert expire_time == expected


def test_get_deposit_spend_secret_hash():
    deposit_script_hex = FIXTURES["deposit"]["script_hex"]
    expected = FIXTURES["deposit"]["spend_secret_hash"]
    spend_secret_hash = scripts.get_deposit_spend_secret_hash(
        deposit_script_hex
    )
    assert spend_secret_hash == expected


def test_get_deposit_payer_pubkey():
    deposit_script_hex = FIXTURES["deposit"]["script_hex"]
    expected = FIXTURES["deposit"]["payer_pubkey"]
    payer_pubkey = scripts.get_deposit_payer_pubkey(deposit_script_hex)
    assert payer_pubkey == expected


def test_get_deposit_payee_pubkey():
    deposit_script_hex = FIXTURES["deposit"]["script_hex"]
    expected = FIXTURES["deposit"]["payee_pubkey"]
    payee_pubkey = scripts.get_deposit_payee_pubkey(deposit_script_hex)
    assert payee_pubkey == expected


def test_compile_deposit_script():
    payer_pubkey = FIXTURES["deposit"]["payer_pubkey"]
    payee_pubkey = FIXTURES["deposit"]["payee_pubkey"]
    spend_secret_hash = FIXTURES["deposit"]["spend_secret_hash"]
    expire_time = FIXTURES["deposit"]["expire_time"]
    expected = FIXTURES["deposit"]["script_hex"]
    deposit_script = scripts.compile_deposit_script(
        payer_pubkey, payee_pubkey, spend_secret_hash, expire_time
    )
    assert deposit_script == expected


def test_get_commit_delay_time_gt_max_sequence():

    try:
        script_hex = FIXTURES["commit"]["script_hex_gt_max_sequence"]
        scripts.get_commit_delay_time(script_hex)
        assert False
    except scripts.InvalidSequenceValue:
        assert True


def test_get_commit_delay_time_lt_min_sequence():

    try:
        script_hex = FIXTURES["commit"]["script_hex_lt_min_sequence"]
        scripts.get_commit_delay_time(script_hex)
        assert False
    except scripts.InvalidSequenceValue:
        assert True


def test_get_commit_delay_time_zero():
    payer_pubkey = FIXTURES["commit"]["payer_pubkey"]
    payee_pubkey = FIXTURES["commit"]["payee_pubkey"]
    spend_secret_hash = FIXTURES["commit"]["spend_secret_hash"]
    revoke_secret_hash = FIXTURES["commit"]["revoke_secret_hash"]
    commit_script_hex = scripts.compile_commit_script(
        payer_pubkey, payee_pubkey, spend_secret_hash,
        revoke_secret_hash, 0
    )
    delay_time = scripts.get_commit_delay_time(commit_script_hex)
    assert delay_time == 0


def test_get_commit_delay_time():
    commit_script_hex = FIXTURES["commit"]["script_hex"]
    expected = FIXTURES["commit"]["delay_time"]
    delay_time = scripts.get_commit_delay_time(commit_script_hex)
    assert delay_time == expected


def test_compile_commit_script():
    payer_pubkey = FIXTURES["commit"]["payer_pubkey"]
    payee_pubkey = FIXTURES["commit"]["payee_pubkey"]
    spend_secret_hash = FIXTURES["commit"]["spend_secret_hash"]
    revoke_secret_hash = FIXTURES["commit"]["revoke_secret_hash"]
    delay_time = FIXTURES["commit"]["delay_time"]
    expected = FIXTURES["commit"]["script_hex"]
    commit_script = scripts.compile_commit_script(
        payer_pubkey, payee_pubkey, spend_secret_hash,
        revoke_secret_hash, delay_time
    )
    assert commit_script == expected


def test_compile_commit_scriptsig():
    pass  # TODO implement


def test_sign_deposit():
    rawtx = scripts.sign_deposit(
        _get_tx_func, **FIXTURES["sign"]["deposit"]["input"]
    )
    assert rawtx == FIXTURES["sign"]["deposit"]["expected"]


def test_sign_created_commit():
    rawtx = scripts.sign_created_commit(
        _get_tx_func, **FIXTURES["sign"]["created_commit"]["input"]
    )
    assert rawtx == FIXTURES["sign"]["created_commit"]["expected"]


def test_sign_finalize_commit():
    rawtx = scripts.sign_finalize_commit(
        _get_tx_func, **FIXTURES["sign"]["finalize_commit"]["input"]
    )
    assert rawtx == FIXTURES["sign"]["finalize_commit"]["expected"]


def test_sign_finalize_commit_unsigned():

    try:
        kwargs = FIXTURES["sign"]["finalize_commit_unsigned"]["input"]
        scripts.sign_finalize_commit(_get_tx_func, **kwargs)
        assert False
    except scripts.InvalidPayerSignature:
        assert True


def test_sign_finalize_commit_bad_script():

    try:
        kwargs = FIXTURES["sign"]["finalize_commit_bad_script"]["input"]
        scripts.sign_finalize_commit(_get_tx_func, **kwargs)
        assert False
    except ValueError:
        assert True


def test_sign_revoke_recover():
    rawtx = scripts.sign_revoke_recover(
        _get_tx_func, **FIXTURES["sign"]["revoke_recover"]["input"]
    )
    assert rawtx == FIXTURES["sign"]["revoke_recover"]["expected"]


def test_sign_payout_recover():
    rawtx = scripts.sign_payout_recover(
        _get_tx_func, **FIXTURES["sign"]["payout_recover"]["input"]
    )
    assert rawtx == FIXTURES["sign"]["payout_recover"]["expected"]


def test_sign_change_recover():
    rawtx = scripts.sign_change_recover(
        _get_tx_func, **FIXTURES["sign"]["change_recover"]["input"]
    )
    assert rawtx == FIXTURES["sign"]["change_recover"]["expected"]


def test_sign_expire_recover():
    rawtx = scripts.sign_expire_recover(
        _get_tx_func, **FIXTURES["sign"]["expire_recover"]["input"]
    )
    assert rawtx == FIXTURES["sign"]["expire_recover"]["expected"]
