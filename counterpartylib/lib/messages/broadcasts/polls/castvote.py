#! /usr/bin/python3
import json
import logging

logger = logging.getLogger(__name__)

from counterpartylib.lib import exceptions
from counterpartylib.lib import util

CASTVOTE = "CASTVOTE"

from . import STATUS_CLOSED, STATUS_OPEN

def validate(db, source, votename, s, block_index):
    problems = []
    try:
        assert len(s) >= 3 and len(s) <= 4
        option = s[2]
        vote = s[3]
        vote = int(vote)

        assert str(int(vote)) == str(vote), "vote is int"

    except:
        return ["invalid format"]

    cursor = db.cursor()

    # check that a poll with votename exists
    poll = list(cursor.execute('''SELECT * FROM polls WHERE (votename = ?)''', (votename, )))
    if len(poll) == 0:
        problems.append("no poll with votename %s exists" % votename)
    else:
        poll = poll[0]
        options = json.loads(poll['options'])

        if poll['status'] == STATUS_CLOSED:
            problems.append("poll has reached it's deadline")

        # check option matches options of the poll
        if option not in options:
            problems.append("option '%s' not in list of possible options; %s" % (option, poll['options']))

        # check that vote is sane
        if vote < 1 or vote > 100:
            problems.append("vote needs to be between 1% and 100%")
        else:
            # check that total vote <= 100%
            votes = list(cursor.execute('''SELECT * FROM poll_votes WHERE (votename = ? AND source = ?)''', (votename, source)))
            sumvotes = sum(vote['vote'] for vote in votes)

            if sumvotes + vote > 100:
                problems.append('source %s already voted with %d%% of his stake, can\'t do a vote with %d%% stake' % (source, sumvotes, vote))

    cursor.close()

    return problems


def compose(db, source, votename, option, vote):
    s = [CASTVOTE, votename, option, vote]

    problems = validate(db, source, votename, s, util.CURRENT_BLOCK_INDEX)
    if problems:
        raise exceptions.ComposeError(problems)

    vote = int(vote)
    s = [CASTVOTE, votename, option, vote]
    data = " ".join(str(v) for v in s)

    return (source, [], data)


def parse(db, tx, votename, s):
    cursor = db.cursor()

    problems = validate(db, tx['source'], votename, s, util.CURRENT_BLOCK_INDEX)
    option = s[2]
    vote = s[3]
    vote = int(vote)

    logger.warn('parse::problems: ' + ", ".join(problems))

    if len(problems) > 0:
        return problems

    bindings = {
        'tx_index': tx['tx_index'],
        'tx_hash': tx['tx_hash'],
        'block_index': tx['block_index'],
        'source': tx['source'],
        'votename': votename,
        'option': option,
        'vote': vote
    }
    sql = 'insert into poll_votes values(:tx_index, :tx_hash, :block_index, :source, :votename, :option, :vote)'
    cursor.execute(sql, bindings)


# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
