#! /usr/bin/python3
import json

import logging

import datetime

logger = logging.getLogger(__name__)

from counterpartylib.lib import exceptions
from counterpartylib.lib import util

INITVOTE = "INITVOTE"
OPTIONS_PREFIX = "OPTS"

MAX_DEADLINE_BLOCKS = 52560  # 1 YEAR in blocks
MAX_DEADLINE_TIMESTAMP = 86400 * 365  # 1 YEAR in seconds

DEADLINE_TIMESTAMP_THRESHOLD = 500000000

from . import STATUS_CLOSED, STATUS_OPEN

def validate(db, votename, s, block_index):
    problems = []

    try:
        assert len(s) >= 6, "initvote has at least 6 parts"
        asset_id = s[2]
        deadline = s[3]

        if s[4] == OPTIONS_PREFIX:
            stake_block_index = block_index
        else:
            assert s[5] == OPTIONS_PREFIX, "5th part of initvote is OPTS"
            stake_block_index = s[4]

        assert str(int(deadline)) == str(deadline), "deadline is int"
        assert str(int(stake_block_index)) == str(stake_block_index), "stake_block_index is int"
        deadline = int(deadline)
    except:
        return ["invalid format"]

    cursor = db.cursor()
    polls = list(cursor.execute('''SELECT * FROM polls WHERE (votename = ?)''', (votename, )))

    if len(polls) > 0:
        problems.append('poll with votename %s already exists' % votename)

    # deadline is timestamp
    if deadline >= DEADLINE_TIMESTAMP_THRESHOLD:
        # fetch block for it's timestamp
        block = list(cursor.execute('''SELECT block_time FROM blocks WHERE block_index = ?''', (block_index, )))[0]

        if deadline <= block['block_time']:
            problems.append("deadline before current block time")

        if deadline - block['block_time'] > MAX_DEADLINE_TIMESTAMP:
            problems.append("deadline (timestamp @ %s) is longer than MAX_DEADLINE_TIMESTAMP" % datetime.datetime.fromtimestamp(deadline).isoformat())

    # deadline is block height
    else:
        if deadline <= block_index:
            problems.append("deadline before current block index")

        if deadline - block_index > MAX_DEADLINE_BLOCKS:
            problems.append("deadline (block_index #%d) is longer than MAX_DEADLINE_BLOCKS" % deadline)

    cursor.close()

    return problems


def compose(db, source, votename, asset_id, deadline, options, stake_block_index=None):
    s = [INITVOTE, votename, asset_id, deadline]
    if stake_block_index is not None:
        s += [stake_block_index]
    s += [OPTIONS_PREFIX] + options

    problems = validate(db, votename, s, util.CURRENT_BLOCK_INDEX)
    if problems:
        raise exceptions.ComposeError(problems)

    data = " ".join(str(v) for v in s)

    return (source, [], data)


def parse(db, tx, votename, s):
    cursor = db.cursor()

    problems = validate(db, votename, s, util.CURRENT_BLOCK_INDEX)
    asset_id = s[2]
    deadline = int(s[3])

    if s[4] == OPTIONS_PREFIX:
        stake_block_index = tx['block_index']
        options = s[5:]
    else:
        stake_block_index = int(s[4])
        options = s[6:]

    if len(problems) > 0:
        return problems

    bindings = {
        'tx_index': tx['tx_index'],
        'tx_hash': tx['tx_hash'],
        'block_index': tx['block_index'],
        'stake_block_index': stake_block_index,
        'source': tx['source'],
        'votename': votename,
        'asset': asset_id,
        'options': json.dumps(options),
        'status': STATUS_OPEN,
        'deadline_ts': None,
        'deadline_block_index': None,
    }

    if deadline < DEADLINE_TIMESTAMP_THRESHOLD:
        bindings['deadline_block_index'] = deadline
    else:
        bindings['deadline_ts'] = deadline

    sql = 'insert into polls values(:tx_index, :tx_hash, :block_index, :source, :votename, ' \
          ':stake_block_index, :asset, :deadline_ts, :deadline_block_index, :status, :options)'
    cursor.execute(sql, bindings)

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
