import pytest
import pprint
import rlp
from rlp.utils import decode_hex, encode_hex, ascii_chr, str_to_bytes
import copy
import json
import os
import time

from counterpartylib.lib import config
from counterpartylib.lib.evm import ethutils, opcodes, vm, processblock, transactions, blocks
from counterpartylib.lib.evm.address import Address

env = {
    "currentCoinbase": b"2adc25665018aa1fe0e6bc666dac8fc2697ff9ba",
    "currentDifficulty": "256",
    "currentGasLimit": "1000000000",
    "currentNumber": "257",
    "currentTimestamp": "1",
    "previousHash": b"5e20a0453cecd065ea59c37ac63e079ee08998b6045136a8ce6635c7912ec0b6"
}

FILL = 1
VERIFY = 2
TIME = 3
VM = 4
STATE = 5
fill_vm_test = lambda params: run_vm_test(params, FILL)
check_vm_test = lambda params: run_vm_test(params, VERIFY)
time_vm_test = lambda params: run_vm_test(params, TIME)

fixture_path = os.path.join(os.path.dirname(__file__), 'pyethfixtures')


def encode_hex_with_prefix(s):
    return b'0x' + ethutils.encode_hex(s)


def encode_int_to_hex_with_prefix(s):
    return b'0x' + ethutils.encode_int_to_hex(s)


def decode_hex_with_prefix(s):
    if s[0:2] == b'0x':
        s = s[2:]
    return ethutils.decode_hex(s)


def decode_int_to_hex_with_prefix(s):
    if s[0:2] == b'0x':
        s = s[2:]
    return ethutils.parse_int_or_hex(s)


def normalize_hex(s):
    return s if len(s) > 2 else b'0x00'


def acct_standard_form(a):
    return {
        "balance": ethutils.parse_int_or_hex(a["balance"]),
        "nonce": ethutils.parse_int_or_hex(a["nonce"]),
        "code": ethutils.to_string(a["code"]),
        "storage": {normalize_hex(k): normalize_hex(v) for
                    k, v in a["storage"].items() if normalize_hex(v).rstrip(b'0') != '0x'}
    }


def compare_post_states(shouldbe, reallyis):
    if shouldbe is None and reallyis is None:
        return True
    if shouldbe is None or reallyis is None:
        raise Exception("Shouldbe: %r \n\nreallyis: %r" % (shouldbe, reallyis))
    for k in shouldbe:
        if k not in reallyis:
            raise Exception
            r = {"nonce": 0, "balance": 0, "code": b"0x", "storage": {}}
        else:
            r = acct_standard_form(reallyis[k])
        s = acct_standard_form(shouldbe[k])
        if s != r:
            if pytest.config.getoption('verbose') >= 2:
                r = pprint.pformat(r)
                s = pprint.pformat(s)
                raise Exception("Key %r \n"
                                "====================================== \n"
                                "shouldbe: \n"
                                "%s\n\n"
                                "====================================== \n"
                                "reallyis: \n"
                                "%s" % (k, s, r))

            else:
                raise Exception("Key %r\n\nshouldbe: %r \n\nreallyis: %r" %
                                (k, s, r))
    return True


def callcreate_standard_form(c):
    return {
        "gasLimit": ethutils.parse_int_or_hex(c["gasLimit"]),
        "value": ethutils.parse_int_or_hex(c["value"]),
        "data": ethutils.to_string(c["data"])
    }


def normalize_address(address, is_contract=False):
    return Address(data=Address.normalizedata(address), version=config.ADDRESSVERSION if not is_contract else config.CONTRACT_ADDRESSVERSION)


BALANCE_MOD = 10000000000000000000

# Fills up a vm test without post data, or runs the test
def run_vm_test(state, params, mode, profiler=None):
    """

    :param state: StateCls
    :param params:
    :param mode:
    :param profiler:
    :return:
    """

    pre = params['pre']
    exek = params['exec']
    env = params['env']
    # if 'previousHash' not in env:
    #     env['previousHash'] = encode_hex(db_env.config['GENESIS_PREVHASH'])

    # assert set(env.keys()) == set(['currentGasLimit', 'currentTimestamp',
    #                                'previousHash', 'currentCoinbase',
    #                                'currentDifficulty', 'currentNumber'])
    # setup env

    blk = state.mine()

    # header = blocks.BlockHeader(
    #     prevhash=decode_hex(env['previousHash']),
    #     number=ethutils.parse_int_or_hex(env['currentNumber']),
    #     coinbase=decode_hex(env['currentCoinbase']),
    #     difficulty=ethutils.parse_int_or_hex(env['currentDifficulty']),
    #     gas_limit=ethutils.parse_int_or_hex(env['currentGasLimit']),
    #     timestamp=ethutils.parse_int_or_hex(env['currentTimestamp']))
    # blk = blocks.Block(header, env=db_env)

    # setup state
    address_is_contract = {}
    for address, h in list(pre.items()):
        assert len(address) == 40
        address = decode_hex(address)
        assert set(h.keys()) == set(['code', 'nonce', 'balance', 'storage'])
        address_is_contract[address] = h['code'] is not None or h['storage'] is not None
        address = normalize_address(address, is_contract=address_is_contract[address])

        blk.set_nonce(address, ethutils.parse_int_or_hex(h['nonce']))
        state.set_balance(address, ethutils.parse_int_or_hex(h['balance']) % BALANCE_MOD)

        if h['code']:
            _, tx, blk = state.mock_tx(sender=address, to=address, value=0, data=b'')
            blk.set_code(tx, address, decode_hex(h['code'][2:]))

        for k, v in h['storage'].items():
            blk.set_storage_data(address,
                                 ethutils.big_endian_to_int(decode_hex(k[2:])),
                                 ethutils.big_endian_to_int(decode_hex(v[2:])))

    blk = state.mine()

    # execute transactions
    sender = decode_hex(exek['caller'])  # a party that originates a call
    sender = normalize_address(sender, is_contract=address_is_contract.get(sender, False))

    recvaddr = decode_hex(exek['address'])
    recvaddr = normalize_address(recvaddr, is_contract=address_is_contract.get(recvaddr, False))

    nonce = blk.get_nonce(sender)
    gasprice = ethutils.parse_int_or_hex(exek['gasPrice'])
    startgas = ethutils.parse_int_or_hex(exek['gas'])
    value = ethutils.parse_int_or_hex(exek['value'])
    data = decode_hex(exek['data'][2:])

    # bypass gas check in tx initialization by temporarily increasing startgas
    num_zero_bytes = str_to_bytes(data).count(ascii_chr(0))
    num_non_zero_bytes = len(data) - num_zero_bytes
    intrinsic_gas = (opcodes.GTXCOST + opcodes.GTXDATAZERO * num_zero_bytes +
                     opcodes.GTXDATANONZERO * num_non_zero_bytes)
    startgas += intrinsic_gas
    _, tx, _ = state.mock_tx(sender=sender, nonce=nonce, gasprice=gasprice, startgas=startgas, to=recvaddr, value=value, data=data)
    tx.startgas -= intrinsic_gas
    tx.sender = sender

    # capture apply_message calls
    apply_message_calls = []
    orig_apply_msg = processblock.apply_msg

    ext = processblock.VMExt(state.db, blk, tx)

    def msg_wrapper(msg):
        hexdata = encode_hex(msg.data.extract_all())
        apply_message_calls.append(dict(gasLimit=ethutils.to_string(msg.gas),
                                        value=ethutils.to_string(msg.value),
                                        destination=encode_hex(msg.to),
                                        data=b'0x' + hexdata))
        return 1, msg.gas, b''

    def create_wrapper(msg):
        sender = decode_hex(msg.sender) if \
            len(msg.sender) == 40 else msg.sender
        nonce = ethutils.encode_int(ext._block.get_nonce(msg.sender))
        addr = ethutils.sha3(rlp.encode([sender, nonce]))[12:]
        hexdata = encode_hex(msg.data.extract_all())
        apply_message_calls.append(dict(gasLimit=ethutils.to_string(msg.gas),
                                        value=ethutils.to_string(msg.value),
                                        destination=b'', data=b'0x' + hexdata))
        return 1, msg.gas, addr

    ext.msg = msg_wrapper
    ext.create = create_wrapper

    def blkhash(n):
        if n >= ext.block_number or n < ext.block_number - 256:
            return b''
        else:
            return ethutils.sha3(ethutils.to_string(n))

    ext.block_hash = blkhash

    msg = vm.Message(tx.sender, tx.to, tx.value, tx.startgas,
                     vm.CallData([ethutils.safe_ord(x) for x in tx.data]))
    code = decode_hex(exek['code'][2:])
    time_pre = time.time()
    if profiler:
        profiler.enable()
    success, gas_remained, output = vm.vm_execute(ext, msg, code)
    if profiler:
        profiler.disable()
    processblock.apply_msg = orig_apply_msg

    for s in blk.suicides:
        blk.del_account(s)
    time_post = time.time()

    """
     generally expected that the test implementer will read env, exec and pre
     then check their results against gas, logs, out, post and callcreates.
     If an exception is expected, then latter sections are absent in the test.
     Since the reverting of the state is not part of the VM tests.
     """

    params2 = copy.deepcopy(params)

    if success:
        params2['callcreates'] = apply_message_calls
        params2['out'] = b'0x' + encode_hex(b''.join(map(ascii_chr, output)))
        params2['gas'] = ethutils.to_string(gas_remained)
        params2['logs'] = [log.to_dict() for log in blk.logs]
        params2['post'] = {}

        # construct post state
        for address, h in list(params['post'].items()):
            assert len(address) == 40
            address = decode_hex(address)
            address = normalize_address(address, is_contract=address_is_contract[address])

            # check the difference after the % BALANCE_MOD
            bpre = ethutils.parse_int_or_hex(params['pre'][address.datahexbytes()]['balance'])
            b = blk.get_balance(address)
            bdiff = (bpre % BALANCE_MOD) - b
            bpost = bpre + bdiff  # add the difference to the pre state

            params2['post'][address.datahexbytes()] = {
                "balance": encode_int_to_hex_with_prefix(bpost),
                "code": encode_hex_with_prefix(blk.get_code(address)),
                "nonce": encode_int_to_hex_with_prefix(blk.get_nonce(address)),
                "storage": {}
            }

            for storage in blk.get_storage_data(address):
                k = encode_hex_with_prefix(storage['key'])
                v = encode_hex_with_prefix(storage['value'])

                params2['post'][address.datahexbytes()]['storage'][k] = v

    if mode == FILL:
        return params2
    elif mode == VERIFY:
        if not success:
            assert 'post' not in params, 'failed, but expected to succeed'

        params1 = copy.deepcopy(params)
        shouldbe, reallyis = params1.get('post', None), params2.get('post', None)

        # zpad the storage keys to match CP always zpadding them
        if shouldbe:
            shouldbe2 = copy.deepcopy(shouldbe)
            for address in shouldbe:
                shouldbe2[address]['storage'] = {}
                for k in shouldbe[address]['storage']:
                    paddedk = encode_hex_with_prefix(ethutils.zpad(decode_hex_with_prefix(k), 32))
                    paddedv = encode_hex_with_prefix(ethutils.zpad(decode_hex_with_prefix(shouldbe[address]['storage'][k]), 32))
                    shouldbe2[address]['storage'][paddedk] = paddedv
            shouldbe = shouldbe2

        compare_post_states(shouldbe, reallyis)

        def normalize_value(k, p):
            if k in p:
                if k == 'gas':
                    return ethutils.parse_int_or_hex(p[k])
                elif k == 'callcreates':
                    return list(map(callcreate_standard_form, p[k]))
                else:
                    return ethutils.to_string(k)
            return None

        for k in ['pre', 'exec', 'env', 'callcreates',
                  'out', 'gas', 'logs']:
            shouldbe = normalize_value(k, params1)
            reallyis = normalize_value(k, params2)
            if shouldbe != reallyis:
                raise Exception("Mismatch: " + k + ':\n shouldbe %r\n reallyis %r' %
                                (shouldbe, reallyis))
    elif mode == TIME:
        return time_post - time_pre


def get_tests_from_file_or_dir(dname, json_only=False):
    if os.path.isfile(dname):
        if dname[-5:] == '.json' or not json_only:
            with open(dname) as f:
                return {dname: json.load(f)}
        else:
            return {}
    else:
        o = {}
        for f in os.listdir(dname):
            fullpath = os.path.join(dname, f)
            for k, v in list(get_tests_from_file_or_dir(fullpath, True).items()):
                o[k] = v
        return o


def fixture_to_bytes(value):
    if isinstance(value, str):
        return str_to_bytes(value)
    elif isinstance(value, list):
        return [fixture_to_bytes(v) for v in value]
    elif isinstance(value, dict):
        ret = {}
        for k, v in list(value.items()):
            if isinstance(k, str) and (len(k) == 40 or k[:2] == '0x'):
                key = str_to_bytes(k)
            else:
                key = k
            ret[key] = fixture_to_bytes(v)
        return ret
    else:
        return value


def generate_test_params(testsource, metafunc, skip_func=None, exclude_func=None):
    for f in ['filename', 'testname', 'testdata']:
        if f not in metafunc.fixturenames:
            raise Exception("generate_test_params for %s with missing fixture %f" % (metafunc.function.__name__, f))

    fixtures = get_tests_from_file_or_dir(os.path.join(fixture_path, testsource))

    base_dir = os.path.dirname(os.path.dirname(__file__))
    params = []
    for filename, tests in fixtures.items():
        if isinstance(tests, dict):
            filename = os.path.relpath(filename, base_dir)
            for testname, testdata in tests.items():
                if exclude_func and exclude_func(filename, testname, testdata):
                    continue
                if skip_func:
                    skipif = pytest.mark.skipif(
                        skip_func(filename, testname, testdata),
                        reason="Excluded"
                    )
                    params.append(skipif((filename, testname, testdata)))
                else:
                    params.append((filename, testname, testdata))

    metafunc.parametrize(
        ('filename', 'testname', 'testdata'),
        params
    )
    return params
