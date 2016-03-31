#! /usr/bin/python3

import logging

logger = logging.getLogger(__name__)

STATUS_OPEN = 'open'
STATUS_CLOSED = 'closed'

from counterpartylib.lib.messages.broadcasts.polls import initvote, castvote

# import constants so they can be used externally as counterpartylib.lib.messages.polls.INITVOTE/CASTVOTE, etc
from counterpartylib.lib.messages.broadcasts.polls.initvote import MAX_DEADLINE_BLOCKS, MAX_DEADLINE_TIMESTAMP, DEADLINE_TIMESTAMP_THRESHOLD, INITVOTE
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
                      deadline_ts INTEGER,
                      deadline_block_index INTEGER,
                      status TEXT,
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


def update_status(db, block_index, block_time):
    cursor = db.cursor()

    polls = list(cursor.execute('''SELECT * FROM polls WHERE status = ?''', (STATUS_OPEN, )))

    for poll in polls:
        if (poll['deadline_ts'] and block_time >= poll['deadline_ts']) or (poll['deadline_block_index'] and block_index >= poll['deadline_block_index']):
            cursor.execute('''UPDATE polls SET status = ? WHERE votename = ?''', (STATUS_CLOSED, poll['votename']))

    cursor.close()

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
