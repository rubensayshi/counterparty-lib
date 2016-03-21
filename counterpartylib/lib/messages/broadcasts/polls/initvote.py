#! /usr/bin/python3
import json

import logging

logger = logging.getLogger(__name__)

from counterpartylib.lib import exceptions
from counterpartylib.lib import util

INITVOTE = "INITVOTE"
MAX_DURATION = 52560  # 1 YEAR
OPTIONS_PREFIX = "OPTS"


def validate(db, votename, s, block_index):
    problems = []

    try:
        assert len(s) >= 6, "initvote has at least 6 parts"
        asset_id = s[2]
        duration = s[3]

        if s[4] == OPTIONS_PREFIX:
            stake_block_index = block_index
        else:
            assert s[5] == OPTIONS_PREFIX, "5th part of initvote is OPTS"
            stake_block_index = s[4]

        assert str(int(duration)) == str(duration), "duration is int"
        assert str(int(stake_block_index)) == str(stake_block_index), "stake_block_index is int"
        duration = int(duration)
    except:
        return ["invalid format"]

    cursor = db.cursor()
    polls = list(cursor.execute('''SELECT * FROM polls WHERE (votename = ?)''', (votename, )))
    cursor.close()

    if len(polls) > 0:
        problems.append('poll with votename %s already exists' % votename)

    if duration > MAX_DURATION:
        problems.append("duration is longer than MAX_DURATION")

    return problems


def compose(db, source, votename, asset_id, duration, options, stake_block_index=None):
    s = [INITVOTE, votename, asset_id, duration]
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
    duration = int(s[3])

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
        'duration': duration,
        'options': json.dumps(options)
    }
    sql = 'insert into polls values(:tx_index, :tx_hash, :block_index, :source, :votename, :stake_block_index, :asset, :duration, :options)'
    cursor.execute(sql, bindings)

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
