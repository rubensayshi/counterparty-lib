"""
This module tests for compability with Ethereum's Smart Contracts.
"""

import pytest
import server
from counterpartylib.lib import (util, config, database, log)
from counterpartylib.lib.messages import execute
from counterpartylib.lib.messages.ethereum import (blocks, processblock, ethutils, abi, address)
import rlp
import subprocess  # Serpent is Python 3‐incompatible.
import binascii
import os
import sys
import logging
import tempfile
import serpent

from counterpartylib.test import contracts_tester as tester
from counterpartylib.test import util_test


CURR_DIR = os.path.dirname(os.path.realpath(os.path.join(os.getcwd(), os.path.expanduser(__file__))))
sys.path.append(os.path.normpath(os.path.join(CURR_DIR, '..')))

# globals initialized by setup_function
db, cursor, logger = None, None, None
CLEANUP_FILES = []


def setup_module():
    """Initialise the database with unittest fixtures"""
    # global the DB/cursor for other functions to access
    global db, cursor, logger

    db = util_test.init_database(CURR_DIR + '/fixtures/scenarios/unittest_fixture.sql', 'fixtures.countracts_test.db')
    logger = logging.getLogger(__name__)
    db.setrollbackhook(lambda: logger.debug('ROLLBACK'))
    database.update_version(db)


def teardown_module():
    """Delete the temporary database."""
    util_test.remove_database_files(config.DATABASE)


def setup_function(function):
    global db, cursor

    # start transaction so we can rollback on teardown
    cursor = db.cursor()
    cursor.execute('''BEGIN''')


def teardown_function(function):
    global db, cursor
    cursor.execute('''ROLLBACK''')


def test_abi_translator():
    addrbase58 = 'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'
    addrhexbytes = b'6f4838d8b3588c4c7ba7c1d06f866e9b3739c63037'
    addrhexstr = '6f4838d8b3588c4c7ba7c1d06f866e9b3739c63037'
    addrbytes = binascii.unhexlify(addrhexbytes)
    addrbytespadded = (addrbytes + (b'\x00' * 32))[:32]

    assert abi.encode_single(('address', '', []), addrbase58) == addrbytes
    assert abi.encode_single(('address', '', []), addrhexstr) == addrbytes
    assert abi.encode_single(('address', '', []), addrhexbytes) == addrbytes
    assert abi.encode_single(('address', '', []), addrbytes) == addrbytes

    assert abi.decode_single(('address', '', []), addrbytes) == addrbase58
    assert abi.decode_single(('address', '', []), addrbytespadded) == addrbase58
