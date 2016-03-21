#! /usr/bin/python3

import logging

logger = logging.getLogger(__name__)

from counterpartylib.lib.messages.broadcasts.polls import initvote, castvote

# import constants so they can be used externally as counterpartylib.lib.messages.polls.INITVOTE/CASTVOTE
from counterpartylib.lib.messages.broadcasts.polls.initvote import MAX_DURATION, INITVOTE
from counterpartylib.lib.messages.broadcasts.polls.castvote import CASTVOTE


def initialise(db):
    cursor = db.cursor()
    cursor.execute('''CREATE TABLE IF NOT EXISTS polls(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      votename TEXT,
                      stake_block_index INTEGER,
                      asset TEXT,
                      duration INTEGER,
                      options TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index))
                   ''')
    cursor.execute('''CREATE TABLE IF NOT EXISTS poll_votes(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      votename TEXT,
                      option TEXT,
                      vote INTEGER UNSIGNED,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index))
                   ''')


def validate(db, message, block_index):
    problems = []

    try:
        s = message.split(" ")
        assert len(s) >= 2
        cmd = s[0]
        votename = s[1]

        assert cmd in [INITVOTE, CASTVOTE]

    except:
        return ["not a poll"]

    return problems


def parse(db, tx, message, block_index):
    problems = validate(db, message, block_index)

    if len(problems) > 0:
        return

    s = message.split(" ")
    cmd = s[0]
    votename = s[1]

    if cmd == INITVOTE:
        return initvote.parse(db, tx, votename, s)
    elif cmd == CASTVOTE:
        return castvote.parse(db, tx, votename, s)

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
