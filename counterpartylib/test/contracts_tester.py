import json
import time
from counterpartylib.lib import (util, config, database, log)
from counterpartylib.lib.messages import execute
from counterpartylib.lib import blocks, script
from counterpartylib.lib.messages.ethereum import (blocks as ethblocks, processblock, utils, abi, opcodes, transactions)
from counterpartylib.lib.messages.ethereum.address import Address
import subprocess
import binascii
import serpent
import rlp
from rlp.utils import decode_hex, encode_hex, ascii_chr
from counterpartylib.test.fixtures.params import ADDR, MULTISIGADDR, DEFAULT_PARAMS as DP

from counterpartylib.test import util_test

# setup aliases so we don't have to change the original tests
a0 = ADDR[0]
a1 = ADDR[1]
a2 = ADDR[3]  # IMPORTANT!! we skipped ADDR[2] because it has no balance
a3 = ADDR[4]
a4 = ADDR[5]
a5 = ADDR[6]

# we never use the privkey, so kN == aN
k0, k1, k2, k3, k4, k5 = a0, a1, a2, a3, a4, a5

startgas = 3141592
gas_price = 1

DEFAULT_SENDER = ADDR[0]

languages = {}
languages['serpent'] = serpent

# hack cuz eth/serpent tries to json.loads(bytes[])
languages['serpent'].mk_full_signature = lambda code, **kwargs: \
    json.loads(serpent.bytestostr(serpent.pyext.mk_full_signature(serpent.strtobytes(serpent.pre_transform(code, kwargs)))))

def encode_datalist(vals):
    def enc(n):
        if type(n) == int:
            return n.to_bytes(32, byteorder='big')
        elif type(n) == str and len(n) == 40:
            return b'\x00' * 12 + binascii.unhexlify(n)
        elif type(n) == str:
            return b'\x00' * (32 - len(n)) + n.encode('utf-8')  # TODO: ugly (and multi‐byte characters)
        elif n is True:
            return 1
        elif n is False or n is None:
            return 0

    def henc(n):
        return util.hexlify(enc(n))

    if isinstance(vals, (tuple, list)):
        return ''.join(map(henc, vals))
    elif vals == '':
        return b''
    else:
        assert False
        # Assume you're getting in numbers or 0x...
        # return ''.join(map(enc, list(map(numberize, vals.split(' ')))))


def compile_serpent_lll(lll_code):
    return serpent.compile_lll(lll_code)


def compile_serpent(code):
    return serpent.compile(code)


def dict_without(d, *args):
    o = {}
    for k, v in list(d.items()):
        if k not in args:
            o[k] = v
    return o


def dict_with(d, **kwargs):
    o = {}
    for k, v in list(d.items()):
        o[k] = v
    for k, v in list(kwargs.items()):
        o[k] = v
    return o


# Pseudo-RNG (deterministic for now for testing purposes)
def rand():
    global seed
    seed = pow(seed, 2, 2 ** 512)
    return seed % 2 ** 256


class TransactionFailed(Exception):
    pass


class ContractCreationFailed(Exception):
    pass


class ABIContract(object):
    def __init__(self, _state, _abi, address):
        self.address = address
        self._translator = abi.ContractTranslator(_abi)
        self.abi = _abi

        def kall_factory(f):

            def kall(*args, **kwargs):
                o = _state._send(kwargs.get('sender', DEFAULT_SENDER),
                                 self.address,
                                 kwargs.get('value', 0),
                                 self._translator.encode(f, args),
                                 **dict_without(kwargs, 'sender', 'value', 'output'))
                # Compute output data
                if kwargs.get('output', '') == 'raw':
                    outdata = o['output']
                elif not o['output']:
                    outdata = None
                else:
                    outdata = self._translator.decode(f, o['output'])
                    outdata = outdata[0] if len(outdata) == 1 else outdata
                # Format output
                if kwargs.get('profiling', ''):
                    return dict_with(o, output=outdata)
                else:
                    return outdata
            return kall

        for f in self._translator.function_data:
            vars(self)[f] = kall_factory(f)


class state(object):
    def __init__(self, db, latest_block_hash):
        self.db = db
        self.block = ethblocks.Block(db, latest_block_hash)
        self.tx_index = blocks.get_next_tx_index(self.db)
        self.TIMESTAMP = int(time.time())
        self.log_listeners = []

    def contract(self, code, sender=DEFAULT_SENDER, endowment=0, language='serpent', lll=False, gas=None):
        if language not in languages:
            raise NotImplemented
            # languages[language] = __import__(language)
        language = languages[language]

        evm = language.compile(code) if not lll else language.compile_lll(code)

        o = self.evm(evm, sender, endowment)
        assert len(self.block.get_code(o)), "Contract code empty"

        return o

    def abi_contract(self, code, sender=DEFAULT_SENDER, endowment=0, language='serpent', contract_name='', lll=False, gas=None, **kwargs):
        if contract_name:
            assert language == 'solidity'
            cn_args = dict(contract_name=contract_name)
        else:
            cn_args = kwargs

        if language not in languages:
            raise NotImplemented
            # languages[language] = __import__(language)
        language = languages[language]

        evm = language.compile(code, **cn_args) if not lll else language.compile_lll(code)

        address = self.evm(evm, sender, endowment, gas)

        assert len(self.block.get_code(address)), "Contract code empty"

        _abi = language.mk_full_signature(code, **cn_args)
        return ABIContract(self, _abi, address)

    def evm(self, evm, sender=DEFAULT_SENDER, endowment=0, gas=None):
        tx, success, output = self.do_send(sender, '', endowment, evm)
        if not success:
            raise ContractCreationFailed()

        return output

    def call(*args, **kwargs):
        raise Exception("Call deprecated. Please use the abi_contract mechanism "
                        "or send(sender, to, value, data) directly, "
                        "using the abi module to generate data if needed")

    def mock_tx(self, sender, to, value, data):
        # create new block
        block_obj = self.mine()

        sender = Address.normalize(sender)
        to = Address.normalize(to)

        # create mock TX
        tx = {
            'source': sender.base58(),
            'block_hash': block_obj.block_hash,
            'block_index': block_obj.block_index,
            'block_time': block_obj.block_time,
            'tx_hash': 'txhash[{}::{}]'.format(to.base58() if to else '', self.tx_index),
            'tx_index': self.tx_index
        }
        self.tx_index += 1  # increment tx_index

        # insert mock TX into DB
        cursor = self.db.cursor()
        cursor.execute('''INSERT INTO transactions ({}) VALUES ({})'''.format(", ".join(tx.keys()), ", ".join("?" * len(tx.keys()))), tx.values())
        cursor.close()

        tx_obj = transactions.Transaction(tx, nonce=0, to=Address.normalize(to), gasprice=1, startgas=startgas, value=value, data=data)

        # @TODO
        tx_obj.nonce = block_obj.get_nonce(Address.normalize(sender))

        return tx, tx_obj, block_obj


    def do_send(self, sender, to, value, data):
        print('DOSEND', sender, to, value, data)

        if not sender:
            raise NotImplemented
            sender = util.contract_sha3('foo'.encode('utf-8'))

        sender = Address.normalize(sender)
        to = Address.normalize(to)

        tx, tx_obj, block_obj = self.mock_tx(sender, to, value, data)

        # Run.
        processblock.MULTIPLIER_CONSTANT_FACTOR = 1
        success, output, gas_remained = processblock.apply_transaction(self.db, block_obj, tx_obj)

        print('DOSEND-', success, output, gas_remained)

        # Decode, return result.
        return tx_obj, success, output

    def _send(self, sender, to, value, evmdata=b'', output=None, funid=None, abi=None):
        if funid is not None or abi is not None:
            raise Exception("Send with funid+abi is deprecated. Please use the abi_contract mechanism")

        tx, s, o = self.do_send(sender, to, value, evmdata)

        if not s:
            raise TransactionFailed()

        return {"output": o}

    def send(self, *args, **kwargs):
        return self._send(*args, **kwargs)['output']

    def trace(self, sender, to, value, data=[]):
        # collect log events (independent of loglevel filters)
        # recorder = LogRecorder()
        self.send(sender, to, value, data)
        # return recorder.pop_records()

    def mine(self, n=1, coinbase=None):
        assert n > 0

        for x in range(0, n):
            block_index, block_hash, block_time = util_test.create_next_block(self.db)

            block_obj = ethblocks.Block(self.db, block_hash)
            block_obj.log_listeners += self.log_listeners

            self.block = block_obj

        return block_obj

    def snapshot(self):
        raise UserWarning
        cursor = self.db.cursor()
        name = 'xyz'
        cursor.execute('''SAVEPOINT {}'''.format(name))
        return name

    def revert(self, name):
        raise UserWarning
        cursor = self.db.cursor()
        cursor.execute('''ROLLBACK TO SAVEPOINT {}'''.format(name))
