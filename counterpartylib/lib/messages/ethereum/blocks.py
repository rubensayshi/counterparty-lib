import pickle
import logging

import binascii

import rlp
from ..ethereum import ethutils

from counterpartylib.lib import util
from counterpartylib.lib import config
from counterpartylib.lib import log
from counterpartylib.lib.messages.ethereum.address import Address

logger = logging.getLogger(__name__)

GAS_LIMIT = 10 ** 9

class Block(object):
    def __init__(self, db, block_hash):
        self.db = db

        cursor = db.cursor()
        block = list(cursor.execute('''SELECT * FROM blocks WHERE block_hash = ?''', (block_hash,)))[0]

        self.block_index = block['block_index']
        self.block_hash = block['block_hash']
        self.block_time = block['block_time']
        self.timestamp = block['block_time']
        self.number = block['block_index']
        self.prevhash = block['previous_block_hash']
        self.gas_used = 0
        self.gas_limit = GAS_LIMIT
        self.refunds = 0  # @TODO
        self.suicides = []
        self.logs = []
        self.log_listeners = []

        self.log_listeners.append(lambda log: logger.getChild('log').debug(str(log)))

        cursor.close()

    def revert(self):
        # @TODO
        logger.debug('### REVERTING ###')

    def add_log(self, log):
        self.logs.append(log)
        for loglistener in self.log_listeners:
            loglistener(log)

    def get_storage_data(self, contract_id, key=None):
        contract_id = Address.normalize(contract_id)
        cursor = self.db.cursor()
        originalkey = key

        if key == None:
            cursor.execute('''SELECT * FROM storage WHERE contract_id = ? ''', (contract_id.base58(),))
            storages = list(cursor)
            return storages

        # print('prekey', key)
        key = key.to_bytes(32, byteorder='big')
        cursor.execute('''SELECT * FROM storage WHERE contract_id = ? AND key = ?''', (contract_id.base58(), key))
        storages = list(cursor)
        # print('key', key)
        if not storages:
            return 0
        value = storages[0]['value']

        value = rlp.utils.big_endian_to_int(value)

        cursor.close()

        logger.getChild('get_storage_data').debug('[%s] %s: %s' % (contract_id.base58(), originalkey, value))

        return value

    def set_storage_data(self, contract_id, key, value):
        contract_id = Address.normalize(contract_id)

        logger.getChild('set_storage_data').debug('[%s] %s: %s' % (contract_id.base58(), key, value))

        key = key.to_bytes(32, byteorder='big')
        value = value.to_bytes(32, byteorder='big')

        cursor = self.db.cursor()

        bindings = {
            'contract_id': contract_id.base58(),
            'key': key,
            'value': value
        }

        cursor.execute('''SELECT * FROM storage WHERE contract_id = ? AND key = ?''', (bindings['contract_id'], key))
        storages = list(cursor)
        if storages:  # Update value.
            logger.getChild('set_storage_data').debug('UPDATE %s' % bindings['contract_id'])
            log.message(self.db, self.number, 'update', 'storage', bindings)
            sql = '''UPDATE storage SET value = :value WHERE contract_id = :contract_id AND key = :key'''
            cursor.execute(sql, bindings)
        else:  # Insert value.
            logger.getChild('set_storage_data').debug('INSERT %s' % bindings['contract_id'])
            log.message(self.db, self.number, 'insert', 'storage', bindings)
            sql = '''INSERT INTO storage VALUES (:contract_id, :key, :value)'''
            cursor.execute(sql, bindings)

        cursor.close()

        return value

    def reset_storage(self, address):
        pass  # @TODO

    def account_exists(self, address):
        return len(self.get_code(address)) > 0

    def account_to_dict(self, address):
        return {'nonce': Block.get_nonce(self, address), 'balance': Block.get_balance(self, address), 'storage': Block.get_storage_data(self, address), 'code': ethutils.hexprint(Block.get_code(self, address))}

    def get_code(self, contract_id):
        contract_id = Address.normalize(contract_id)

        cursor = self.db.cursor()
        cursor.execute('''SELECT * FROM contracts WHERE contract_id = ?''', (contract_id.base58(),))
        contracts = list(cursor)

        if not contracts:
            return b''
        else:
            code = contracts[0]['code']

        return code

    def set_code(self, tx, contract_id, dat):
        contract_id = Address.normalize(contract_id)

        logger.getChild('set_code').debug('[%s] %s' % (contract_id.base58(), dat))
        nonce = 0
        cursor = self.db.cursor()

        bindings = {
            'contract_id': contract_id.base58(),
            'tx_index': tx.tx_index,
            'tx_hash': tx.tx_hash,
            'block_index': self.block_index,
            'source': tx.sender.base58(),
            'code': bytes(dat),
            'nonce': nonce
        }

        logger.getChild('set_code').debug('have: %d' % len(list(cursor.execute('''SELECT contract_id FROM contracts WHERE contract_id = ?''', (contract_id.base58(), )))))

        if len(list(cursor.execute('''SELECT contract_id FROM contracts WHERE contract_id = ?''', (bindings['contract_id'], )))) > 0:
            sql = '''UPDATE contracts SET code = :code, nonce = :nonce WHERE contract_id = :contract_id'''
            cursor.execute(sql, {'contract_id': bindings['contract_id'], 'code': bindings['code'], 'nonce': bindings['nonce']})
        else:
            sql = '''INSERT INTO contracts VALUES (:contract_id, :tx_index, :tx_hash, :block_index, :source, :code, :nonce)'''
            cursor.execute(sql, bindings)

    def get_nonce(self, address):
        address = Address.normalize(address)

        cursor = self.db.cursor()
        nonces = list(cursor.execute('''SELECT * FROM nonces WHERE (address = ?)''', (address.base58(),)))
        if not nonces:
            return 0
        else:
            return nonces[0]['nonce']

    def set_nonce(self, address, nonce):
        address = Address.normalize(address)

        cursor = self.db.cursor()
        cursor.execute('''SELECT * FROM nonces WHERE (address = :address)''', {'address': address.base58()})
        nonces = list(cursor)
        bindings = {'address': address.base58(), 'nonce': nonce}
        if not nonces:
            log.message(self.db, self.number, 'insert', 'nonces', bindings)
            cursor.execute('''INSERT INTO nonces VALUES(:address, :nonce)''', bindings)
        else:
            log.message(self.db, self.number, 'update', 'nonces', bindings)
            cursor.execute('''UPDATE nonces SET nonce = :nonce WHERE (address = :address)''', bindings)

        cursor.close()

    def increment_nonce(self, address):
        address = Address.normalize(address)

        nonce = self.get_nonce(address)
        self.set_nonce(address, nonce + 1)

    def decrement_nonce(self, address):
        address = Address.normalize(address)

        nonce = self.get_nonce(address)
        self.set_nonce(address, nonce - 1)

    def get_balance(self, address, asset=config.XCP):
        address = Address.normalize(address)

        return util.get_balance(self.db, address.base58(), asset)

    def set_balance(self, address, value, asset=config.XCP):
        raise NotImplemented

    def delta_balance(self, address, value, asset=config.XCP, tx=None):
        address = Address.normalize(address)

        assert tx is not None
        if value > 0:
            util.credit(self.db, address.base58(), asset, value, action='delta balance', event=tx.tx_hash)
        elif value < 0:
            util.debit(self.db, address.base58(), asset, -value, action='delta balance', event=tx.tx_hash)
        pass  # @TODO

    def transfer_value(self, tx, source, destination, quantity, asset=config.XCP):
        source = Address.normalize(source)
        destination = Address.normalize(destination)

        if source:
            util.debit(self.db, source.base58(), asset, quantity, action='transfer value', event=tx.tx_hash)
        if destination:
            util.credit(self.db, destination.base58(), asset, quantity, action='transfer value', event=tx.tx_hash)
        return True

    def del_account(self, contract_id):
        contract_id = Address.normalize(contract_id)

        cursor = self.db.cursor()
        logger.debug('SUICIDING {}'.format(contract_id))
        bindings = {'contract_id': contract_id}
        log.message(self.db, self.number, 'delete', 'contracts', bindings)
        cursor.execute('''DELETE FROM contracts WHERE contract_id = :contract_id''', bindings)
        log.message(self.db, self.number, 'delete', 'storage', bindings)
        cursor.execute('''DELETE FROM storage WHERE contract_id = :contract_id''', bindings)

        cursor.close()


class Log(object):
    def __init__(self, address, topics, data):
        address = Address.normalize(address)

        self.address = address
        self.topics = topics
        self.data = data

    def bloomables(self):
        raise NotImplemented

    def to_dict(self):
        return {
            "address": self.address.base58(),
            "data": b'0x' + ethutils.encode_hex(self.data),
            "topics": [ethutils.encode_hex(ethutils.int32.serialize(t)) for t in self.topics]
        }

    def __repr__(self):
        return '<Log(address=%r, topics=%r, data=%r)>' %  \
            (self.address, self.topics, self.data)


# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4

# Gas limit adjustment algo
def calc_gaslimit(parent):
    config = parent.config
    decay = parent.gas_limit // config['GASLIMIT_EMA_FACTOR']
    new_contribution = ((parent.gas_used * config['BLKLIM_FACTOR_NOM']) //
                        config['BLKLIM_FACTOR_DEN'] // config['GASLIMIT_EMA_FACTOR'])
    gl = max(parent.gas_limit - decay + new_contribution, config['MIN_GAS_LIMIT'])
    if gl < config['GENESIS_GAS_LIMIT']:
        gl2 = parent.gas_limit + decay
        gl = min(config['GENESIS_GAS_LIMIT'], gl2)
    assert check_gaslimit(parent, gl)
    return gl


def check_gaslimit(parent, gas_limit):
    config = parent.config
    #  block.gasLimit - parent.gasLimit <= parent.gasLimit / GasLimitBoundDivisor
    gl = parent.gas_limit // config['GASLIMIT_ADJMAX_FACTOR']
    a = bool(abs(gas_limit - parent.gas_limit) <= gl)
    b = bool(gas_limit >= config['MIN_GAS_LIMIT'])
    return a and b
