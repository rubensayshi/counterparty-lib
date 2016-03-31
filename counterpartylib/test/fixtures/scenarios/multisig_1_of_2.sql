-- PRAGMA page_size=1024;
-- PRAGMA encoding='UTF-8';
-- PRAGMA auto_vacuum=NONE;
-- PRAGMA max_page_count=1073741823;

BEGIN TRANSACTION;

-- Table  assets
DROP TABLE IF EXISTS assets;
CREATE TABLE assets(
                      asset_id TEXT UNIQUE,
                      asset_name TEXT UNIQUE,
                      block_index INTEGER);
INSERT INTO assets VALUES('0','BTC',NULL);
INSERT INTO assets VALUES('1','XCP',NULL);
INSERT INTO assets VALUES('18279','BBBB',310005);
INSERT INTO assets VALUES('18280','BBBC',310006);
-- Triggers and indices on  assets
CREATE TRIGGER _assets_delete BEFORE DELETE ON assets BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO assets(rowid,asset_id,asset_name,block_index) VALUES('||old.rowid||','||quote(old.asset_id)||','||quote(old.asset_name)||','||quote(old.block_index)||')');
                            END;
CREATE TRIGGER _assets_insert AFTER INSERT ON assets BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM assets WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _assets_update AFTER UPDATE ON assets BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE assets SET asset_id='||quote(old.asset_id)||',asset_name='||quote(old.asset_name)||',block_index='||quote(old.block_index)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX id_idx ON assets (asset_id);
CREATE INDEX name_idx ON assets (asset_name);

-- Table  balances
DROP TABLE IF EXISTS balances;
CREATE TABLE balances(
                      address TEXT,
                      asset TEXT,
                      quantity INTEGER);
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',149849426438);
INSERT INTO balances VALUES('1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',50420824);
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBB',996000000);
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBC',89474);
INSERT INTO balances VALUES('1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBB',4000000);
INSERT INTO balances VALUES('1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBC',10526);
-- Triggers and indices on  balances
CREATE TRIGGER _balances_delete BEFORE DELETE ON balances BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO balances(rowid,address,asset,quantity) VALUES('||old.rowid||','||quote(old.address)||','||quote(old.asset)||','||quote(old.quantity)||')');
                            END;
CREATE TRIGGER _balances_insert AFTER INSERT ON balances BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM balances WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _balances_update AFTER UPDATE ON balances BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE balances SET address='||quote(old.address)||',asset='||quote(old.asset)||',quantity='||quote(old.quantity)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX address_asset_idx ON balances (address, asset);

-- Table  bet_expirations
DROP TABLE IF EXISTS bet_expirations;
CREATE TABLE bet_expirations(
                      bet_index INTEGER PRIMARY KEY,
                      bet_hash TEXT UNIQUE,
                      source TEXT,
                      block_index INTEGER,
                      FOREIGN KEY (block_index) REFERENCES blocks(block_index),
                      FOREIGN KEY (bet_index, bet_hash) REFERENCES bets(tx_index, tx_hash));
INSERT INTO bet_expirations VALUES(13,'4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',310023);
-- Triggers and indices on  bet_expirations
CREATE TRIGGER _bet_expirations_delete BEFORE DELETE ON bet_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO bet_expirations(rowid,bet_index,bet_hash,source,block_index) VALUES('||old.rowid||','||quote(old.bet_index)||','||quote(old.bet_hash)||','||quote(old.source)||','||quote(old.block_index)||')');
                            END;
CREATE TRIGGER _bet_expirations_insert AFTER INSERT ON bet_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM bet_expirations WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _bet_expirations_update AFTER UPDATE ON bet_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE bet_expirations SET bet_index='||quote(old.bet_index)||',bet_hash='||quote(old.bet_hash)||',source='||quote(old.source)||',block_index='||quote(old.block_index)||' WHERE rowid='||old.rowid);
                            END;

-- Table  bet_match_expirations
DROP TABLE IF EXISTS bet_match_expirations;
CREATE TABLE bet_match_expirations(
                      bet_match_id TEXT PRIMARY KEY,
                      tx0_address TEXT,
                      tx1_address TEXT,
                      block_index INTEGER,
                      FOREIGN KEY (bet_match_id) REFERENCES bet_matches(id),
                      FOREIGN KEY (block_index) REFERENCES blocks(block_index));
INSERT INTO bet_match_expirations VALUES('4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea_f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',310014);
INSERT INTO bet_match_expirations VALUES('fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e_37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',310016);
INSERT INTO bet_match_expirations VALUES('766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70_484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',310018);
-- Triggers and indices on  bet_match_expirations
CREATE TRIGGER _bet_match_expirations_delete BEFORE DELETE ON bet_match_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO bet_match_expirations(rowid,bet_match_id,tx0_address,tx1_address,block_index) VALUES('||old.rowid||','||quote(old.bet_match_id)||','||quote(old.tx0_address)||','||quote(old.tx1_address)||','||quote(old.block_index)||')');
                            END;
CREATE TRIGGER _bet_match_expirations_insert AFTER INSERT ON bet_match_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM bet_match_expirations WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _bet_match_expirations_update AFTER UPDATE ON bet_match_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE bet_match_expirations SET bet_match_id='||quote(old.bet_match_id)||',tx0_address='||quote(old.tx0_address)||',tx1_address='||quote(old.tx1_address)||',block_index='||quote(old.block_index)||' WHERE rowid='||old.rowid);
                            END;

-- Table  bet_match_resolutions
DROP TABLE IF EXISTS bet_match_resolutions;
CREATE TABLE bet_match_resolutions(
                      bet_match_id TEXT PRIMARY KEY,
                      bet_match_type_id INTEGER,
                      block_index INTEGER,
                      winner TEXT,
                      settled BOOL,
                      bull_credit INTEGER,
                      bear_credit INTEGER,
                      escrow_less_fee INTEGER,
                      fee INTEGER,
                      FOREIGN KEY (bet_match_id) REFERENCES bet_matches(id),
                      FOREIGN KEY (block_index) REFERENCES blocks(block_index));
-- Triggers and indices on  bet_match_resolutions
CREATE TRIGGER _bet_match_resolutions_delete BEFORE DELETE ON bet_match_resolutions BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO bet_match_resolutions(rowid,bet_match_id,bet_match_type_id,block_index,winner,settled,bull_credit,bear_credit,escrow_less_fee,fee) VALUES('||old.rowid||','||quote(old.bet_match_id)||','||quote(old.bet_match_type_id)||','||quote(old.block_index)||','||quote(old.winner)||','||quote(old.settled)||','||quote(old.bull_credit)||','||quote(old.bear_credit)||','||quote(old.escrow_less_fee)||','||quote(old.fee)||')');
                            END;
CREATE TRIGGER _bet_match_resolutions_insert AFTER INSERT ON bet_match_resolutions BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM bet_match_resolutions WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _bet_match_resolutions_update AFTER UPDATE ON bet_match_resolutions BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE bet_match_resolutions SET bet_match_id='||quote(old.bet_match_id)||',bet_match_type_id='||quote(old.bet_match_type_id)||',block_index='||quote(old.block_index)||',winner='||quote(old.winner)||',settled='||quote(old.settled)||',bull_credit='||quote(old.bull_credit)||',bear_credit='||quote(old.bear_credit)||',escrow_less_fee='||quote(old.escrow_less_fee)||',fee='||quote(old.fee)||' WHERE rowid='||old.rowid);
                            END;

-- Table  bet_matches
DROP TABLE IF EXISTS bet_matches;
CREATE TABLE bet_matches(
                      id TEXT PRIMARY KEY,
                      tx0_index INTEGER,
                      tx0_hash TEXT,
                      tx0_address TEXT,
                      tx1_index INTEGER,
                      tx1_hash TEXT,
                      tx1_address TEXT,
                      tx0_bet_type INTEGER,
                      tx1_bet_type INTEGER,
                      feed_address TEXT,
                      initial_value INTEGER,
                      deadline INTEGER,
                      target_value REAL,
                      leverage INTEGER,
                      forward_quantity INTEGER,
                      backward_quantity INTEGER,
                      tx0_block_index INTEGER,
                      tx1_block_index INTEGER,
                      block_index INTEGER,
                      tx0_expiration INTEGER,
                      tx1_expiration INTEGER,
                      match_expire_index INTEGER,
                      fee_fraction_int INTEGER,
                      status TEXT,
                      FOREIGN KEY (tx0_index, tx0_hash, tx0_block_index) REFERENCES transactions(tx_index, tx_hash, block_index),
                      FOREIGN KEY (tx1_index, tx1_hash, tx1_block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
INSERT INTO bet_matches VALUES('4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea_f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a',13,'4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',14,'f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',0,1,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',100,1388000100,0.0,15120,41500000,20750000,310012,310013,310013,10,10,310022,5000000,'expired');
INSERT INTO bet_matches VALUES('fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e_37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9',15,'fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',16,'37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',0,1,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',100,1388000100,0.0,5040,150000000,350000000,310014,310015,310015,10,10,310024,5000000,'expired');
INSERT INTO bet_matches VALUES('766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70_484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473',17,'766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',18,'484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',2,3,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',100,1388000200,1.0,5040,750000000,650000000,310016,310017,310017,10,10,310026,5000000,'expired');
-- Triggers and indices on  bet_matches
CREATE TRIGGER _bet_matches_delete BEFORE DELETE ON bet_matches BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO bet_matches(rowid,id,tx0_index,tx0_hash,tx0_address,tx1_index,tx1_hash,tx1_address,tx0_bet_type,tx1_bet_type,feed_address,initial_value,deadline,target_value,leverage,forward_quantity,backward_quantity,tx0_block_index,tx1_block_index,block_index,tx0_expiration,tx1_expiration,match_expire_index,fee_fraction_int,status) VALUES('||old.rowid||','||quote(old.id)||','||quote(old.tx0_index)||','||quote(old.tx0_hash)||','||quote(old.tx0_address)||','||quote(old.tx1_index)||','||quote(old.tx1_hash)||','||quote(old.tx1_address)||','||quote(old.tx0_bet_type)||','||quote(old.tx1_bet_type)||','||quote(old.feed_address)||','||quote(old.initial_value)||','||quote(old.deadline)||','||quote(old.target_value)||','||quote(old.leverage)||','||quote(old.forward_quantity)||','||quote(old.backward_quantity)||','||quote(old.tx0_block_index)||','||quote(old.tx1_block_index)||','||quote(old.block_index)||','||quote(old.tx0_expiration)||','||quote(old.tx1_expiration)||','||quote(old.match_expire_index)||','||quote(old.fee_fraction_int)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _bet_matches_insert AFTER INSERT ON bet_matches BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM bet_matches WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _bet_matches_update AFTER UPDATE ON bet_matches BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE bet_matches SET id='||quote(old.id)||',tx0_index='||quote(old.tx0_index)||',tx0_hash='||quote(old.tx0_hash)||',tx0_address='||quote(old.tx0_address)||',tx1_index='||quote(old.tx1_index)||',tx1_hash='||quote(old.tx1_hash)||',tx1_address='||quote(old.tx1_address)||',tx0_bet_type='||quote(old.tx0_bet_type)||',tx1_bet_type='||quote(old.tx1_bet_type)||',feed_address='||quote(old.feed_address)||',initial_value='||quote(old.initial_value)||',deadline='||quote(old.deadline)||',target_value='||quote(old.target_value)||',leverage='||quote(old.leverage)||',forward_quantity='||quote(old.forward_quantity)||',backward_quantity='||quote(old.backward_quantity)||',tx0_block_index='||quote(old.tx0_block_index)||',tx1_block_index='||quote(old.tx1_block_index)||',block_index='||quote(old.block_index)||',tx0_expiration='||quote(old.tx0_expiration)||',tx1_expiration='||quote(old.tx1_expiration)||',match_expire_index='||quote(old.match_expire_index)||',fee_fraction_int='||quote(old.fee_fraction_int)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX valid_feed_idx ON bet_matches (feed_address, status);

-- Table  bets
DROP TABLE IF EXISTS bets;
CREATE TABLE bets(
                      tx_index INTEGER UNIQUE,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      feed_address TEXT,
                      bet_type INTEGER,
                      deadline INTEGER,
                      wager_quantity INTEGER,
                      wager_remaining INTEGER,
                      counterwager_quantity INTEGER,
                      counterwager_remaining INTEGER,
                      target_value REAL,
                      leverage INTEGER,
                      expiration INTEGER,
                      expire_index INTEGER,
                      fee_fraction_int INTEGER,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index),
                      PRIMARY KEY (tx_index, tx_hash));
INSERT INTO bets VALUES(13,'4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea',310012,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',0,1388000100,50000000,8500000,25000000,4250000,0.0,15120,10,310022,5000000,'expired');
INSERT INTO bets VALUES(14,'f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a',310013,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',1,1388000100,25000000,4250000,41500000,0,0.0,15120,10,310023,5000000,'filled');
INSERT INTO bets VALUES(15,'fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e',310014,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',0,1388000100,150000000,0,350000000,0,0.0,5040,10,310024,5000000,'filled');
INSERT INTO bets VALUES(16,'37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9',310015,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',1,1388000100,350000000,0,150000000,0,0.0,5040,10,310025,5000000,'filled');
INSERT INTO bets VALUES(17,'766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70',310016,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',2,1388000200,750000000,0,650000000,0,1.0,5040,10,310026,5000000,'filled');
INSERT INTO bets VALUES(18,'484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473',310017,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',3,1388000200,650000000,0,750000000,0,1.0,5040,10,310027,5000000,'filled');
-- Triggers and indices on  bets
CREATE TRIGGER _bets_delete BEFORE DELETE ON bets BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO bets(rowid,tx_index,tx_hash,block_index,source,feed_address,bet_type,deadline,wager_quantity,wager_remaining,counterwager_quantity,counterwager_remaining,target_value,leverage,expiration,expire_index,fee_fraction_int,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.feed_address)||','||quote(old.bet_type)||','||quote(old.deadline)||','||quote(old.wager_quantity)||','||quote(old.wager_remaining)||','||quote(old.counterwager_quantity)||','||quote(old.counterwager_remaining)||','||quote(old.target_value)||','||quote(old.leverage)||','||quote(old.expiration)||','||quote(old.expire_index)||','||quote(old.fee_fraction_int)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _bets_insert AFTER INSERT ON bets BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM bets WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _bets_update AFTER UPDATE ON bets BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE bets SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',feed_address='||quote(old.feed_address)||',bet_type='||quote(old.bet_type)||',deadline='||quote(old.deadline)||',wager_quantity='||quote(old.wager_quantity)||',wager_remaining='||quote(old.wager_remaining)||',counterwager_quantity='||quote(old.counterwager_quantity)||',counterwager_remaining='||quote(old.counterwager_remaining)||',target_value='||quote(old.target_value)||',leverage='||quote(old.leverage)||',expiration='||quote(old.expiration)||',expire_index='||quote(old.expire_index)||',fee_fraction_int='||quote(old.fee_fraction_int)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX feed_valid_bettype_idx ON bets (feed_address, status, bet_type);

-- Table  blocks
DROP TABLE IF EXISTS blocks;
CREATE TABLE blocks(
                      block_index INTEGER UNIQUE,
                      block_hash TEXT UNIQUE,
                      block_time INTEGER,
                      previous_block_hash TEXT UNIQUE,
                      difficulty INTEGER, ledger_hash TEXT, txlist_hash TEXT, messages_hash TEXT,
                      PRIMARY KEY (block_index, block_hash));
INSERT INTO blocks VALUES(309999,'8b3bef249cb3b0fa23a4936c1249b6bd41daeadc848c8d2e409ea1cbc10adfe7',1419699900,NULL,NULL,'3e2cd73017159fdc874453f227e9d0dc4dabba6d10e03458f3399f1d340c4ad1','3e2cd73017159fdc874453f227e9d0dc4dabba6d10e03458f3399f1d340c4ad1','3e2cd73017159fdc874453f227e9d0dc4dabba6d10e03458f3399f1d340c4ad1');
INSERT INTO blocks VALUES(310000,'505d8d82c4ced7daddef7ed0b05ba12ecc664176887b938ef56c6af276f3b30c',1419700000,NULL,NULL,'b23da6db232740dc43d48ad6ddc80f25f1c1545a29b8bf9c71f0bcbe6614514d','0187c17941a1fe7d9da6c091fb8ecfeb057a5b975c4ae8142b381c2eac1f9697','2af3b14f90d51684e8f343f4a8d5b608ae7acaea199c0e4b59fd2451ffdac380');
INSERT INTO blocks VALUES(310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',1419700100,NULL,NULL,'9e44b05c99b7e92f5444cb47fecc46c18adca8e074f2872a5e2803937a5738cd','c6443b0558388719c51802991d9519bdba74565c4adc86f6cb55e02839a659d5','3aa549f7849158dc10729521d76f31d9ecc542df0b82c8ec2ce322d21f01d475');
INSERT INTO blocks VALUES(310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',1419700200,NULL,NULL,'fbbd28940f335e0eec5e9955c74b00c5afb97f995d80d9ccead086bda0e80bde','3a651cafb34cf8051e414db0a766f7e2a0a4f6a5de79303002f04b04b23996b8','141d05bdd84fdc16cf665807eee9b624f5e1a55634f1841669e5c6e016e233ef');
INSERT INTO blocks VALUES(310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',1419700300,NULL,NULL,'a0165cbb85b2329f15afdac8fdf8f801c38279c01cb1e5c9c8d715d445993f80','8e1f322cbdac2a12681970066db31a43dbfe26d6435b8744c40f9f2e66e9ce99','e73c89b9ff69f029a3e8030495ad145e8820ee1631ecf0686734725011c037b7');
INSERT INTO blocks VALUES(310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',1419700400,NULL,NULL,'8de6f5829c655a3f219d1bf3506ed604d5a56a682c7a5d3ea015ab44875d16f5','c67e7bb373c020e1b2bfa0ae6bc3d3c2b4f542eaf442496308fdadd83401b372','1b514cbbebbc5ad4065d2c49f7c68dad6f552a44551b58705cb8f76a820a473e');
INSERT INTO blocks VALUES(310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',1419700500,NULL,NULL,'aeb24e348cb4217728dbfb267587eb940d1ed96c34cf5d7290ca8b45abc65ea6','0629cf6bdf44c15940fd3313dbd5a2d10f630387b4cc0a18503388af43b86577','385e05abebf4b34cab9e7f7fff2a019acfb506ac78731e617a471c2b865aa31a');
INSERT INTO blocks VALUES(310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',1419700600,NULL,NULL,'6cdc104cc7d567d18feaf0d636fef5308d469fad041af255977d752fa7484d9b','2c34a2aca283ab6fc330344eb6e0c8771f222e93b592ff9a82def01fc710edbf','5aa887ea994873caabcc0941b81dfec59c62d0abe989de90ce595847566a96d0');
INSERT INTO blocks VALUES(310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',1419700700,NULL,NULL,'46ba7102f011eb7f45c661b1bba9ff44722dbc1a432bcbdf4f2595f346e21fa6','db0bd474dabee7e2cd10f176abe13a99337b407be1c0caf8fa34ba2463dc7203','b3605745b01f8288e184472431c5785061c7d14a77a85b981f3bb3844cf3406a');
INSERT INTO blocks VALUES(310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',1419700800,NULL,NULL,'22ec62646def6c1814626294ce4960ac87d298512b24425c316fad69c72200fa','25ba570e3c31eee3469b1930eb91814e57c8485c9d505a51642c5c8ff466eeb2','6a23d253778359f0a8f3dce5b708d5cd72d3dd234bfb08c0e1791f65aefcbd6e');
INSERT INTO blocks VALUES(310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',1419700900,NULL,NULL,'3b6580ca893a177b895d469900d546dec238f39240311e1a02e9311a86132583','0f662e52670b60d63eb9c99b4fb7ae05ac6516f662cf1b8f43d608fee7c8115d','440b5ad094cf51b209093ce968a51b503e00b4f83684195a3c2e36bea7380c8c');
INSERT INTO blocks VALUES(310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',1419701000,NULL,NULL,'65848d3395b5db9b1828e66bd906d1cab37544608569ddf5658314a4dec00e7b','95aa446e852b93ba4b9e0d3d915958a7dba8869047c438088ae0d7a7e989e834','78dab51ae638de72b3df9c3f1f9dcc32da447dc36127476a60d2d5c1ea4bd974');
INSERT INTO blocks VALUES(310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',1419701100,NULL,NULL,'a0d3c68eceaff329a2ce54cf4a9d8d976a1376cbd130e2aa694a0f75e5731314','e14d0c81dd82d2a0724a5927c18e8765c9b632aa2db3ba2a2ac3d0f66cbb5c11','627ac7802e0b6b0dbbb79f97ce347cca54dbfd5ef3eca5548b375ebbae1420f9');
INSERT INTO blocks VALUES(310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',1419701200,NULL,NULL,'91940e5dac7a01065760d8974cf8f5c2ed420de4349929a6bde80f313db4fc0d','84f54189f574ae50a086567ca0d92a86d6272c20033fa1062ccd1c352f3c699d','10552c6417527a11511244946aa829e72bd18eb9f8a1c4b7fd3cd2cdca94d49c');
INSERT INTO blocks VALUES(310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',1419701300,NULL,NULL,'5323b872edf43fab44a9f4a603f3b1819f16855a426129b19e9ed6d6e469f679','93ef38d3a71c3e3f52af0f255bd950cb97ae813e32c867551c819e81699795cd','e3a0e115eb9da44f83a31f94d60c4347aa4291af5682abf233a61f10161a3217');
INSERT INTO blocks VALUES(310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',1419701400,NULL,NULL,'1eaf7e4208254e51d2c6ff79df69a0794f0452ea8cad566f71279a1235125b07','9c52c62ecb62ad241a60a6dcc9e4b851de9457811b1b84481f76e8c86319eb75','986df7b816977154ba0990de1b2f5d2292ed4f1fd17f38e99a45b2ad7908c5de');
INSERT INTO blocks VALUES(310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',1419701500,NULL,NULL,'924df0170cdec6e58b3da0928de546cf891b5462d8dd78910f87d3f30b7c0b59','a7b7fdb78a90468761f01244bd99203c302c86673e3056bf2e5d3be69dc8b09a','8e58b8e63db45b32bef2f6d25993002cd5ca08a4092a9169947120718c15b5cf');
INSERT INTO blocks VALUES(310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',1419701600,NULL,NULL,'152a9d4a17e4d4189454ce757d6cc57bcd3037f73b6f11c4f6506cbc69c1fba5','a45e41e5b1bb6827cd3e06d7dc3e6e80f7b21d9978cdbb452978b77ff53106a4','04ed27e121373273e2f080cbaf8af3b5e469b2450c3db294ced74f61b47b86a0');
INSERT INTO blocks VALUES(310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',1419701700,NULL,NULL,'1d7013af6a1ef20b2a93bb75a637efb278f207e66e24da71cf2237beff085bdc','91af43e5866f9b18852aea9db5aa9a316c522bf5b606fe44e716d8dd7b06b56f','766bff16a1d36e419b518d869f05b4871d0d1fd9f88e6da611c3e23ee7ee5256');
INSERT INTO blocks VALUES(310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',1419701800,NULL,NULL,'4056ecadef1fc18685af51dcd91fbc59b20ca2c877a03646f3b9580a4e5cfc39','b155b10c0101478e8031c44d99573c334e912f68fb1b715c28baac5b2f049cc4','04e1f794dc493fb7eeb5302c219551831c6877c9f34afee57f8886851a2c0e71');
INSERT INTO blocks VALUES(310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',1419701900,NULL,NULL,'66cb8aa5f1cb81c3fc531c54ccff8f24917628dd8aa1dd51278cd96fb963b4e2','c92560494ce3b1f2fe46b68b1cf33c5db3828d149cd8cfafa9517869790bb1af','a617a649a88a7debe04a08059d022ebba18a44489ba42de6855e2d29afd6e9d8');
INSERT INTO blocks VALUES(310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',1419702000,NULL,NULL,'ce26c909348e0d3e9e5c603a27baa686a96573eb2797d24de936275a575c8f36','9cdea634df5c8218e749721735108ad11dc10002fbaa24b369a399767147454b','8f73270f91942e64fb1d3fbd319357f6a2e8098864c3f564b1bffbe95007a672');
INSERT INTO blocks VALUES(310021,'7c2460bb32c5749c856486393239bf7a0ac789587ac71f32e7237910da8097f2',1419702100,NULL,NULL,'ed9fde809e24737c268dc80ec8610af1aa45c3352557c91d908a7f7b6876c816','852fed1a208dddb09f860a936fc3b214a9841d3c06074d764cff9bca3987964d','99e04d6c77fce56afebcc32d2b640f226ea12ebb88e5470cfaefcf2171af5274');
INSERT INTO blocks VALUES(310022,'44435f9a99a0aa12a9bfabdc4cb8119f6ea6a6e1350d2d65445fb66a456db5fc',1419702200,NULL,NULL,'547c88d3003a31d780e4840e093c48f8ed85521f136d207d806fc83ad72a56c9','9f98afa44611d969fbe0c9d5b6137626de18dfd19b97e6aa130205126769ce1c','92f50451be011f107a7113d8a84ddcb4c61ec440ee6369919398a1cd8e898693');
INSERT INTO blocks VALUES(310023,'d8cf5bec1bbcab8ca4f495352afde3b6572b7e1d61b3976872ebb8e9d30ccb08',1419702300,NULL,NULL,'81ac8539f87f2d45c4878fd7735482c15b14dbfb334a125a90454ed2c127a992','ff06df2b2deb8659d07e8b57ee38039e3758389e555022439cecad66fc86b46f','e6daaf6dc0c1de38573596f52621775bd7b54acc91f45dd3f5dea11904cb5dec');
INSERT INTO blocks VALUES(310024,'b03042b4e18a222b4c8d1e9e1970d93e6e2a2d41686d227ff8ecf0a839223dc5',1419702400,NULL,NULL,'4adec533b4e2ae2119c5d034f311900c3c73eb0281f1432db0604fec3560f52f','94da6fc963353dc9260c529418efcdfec793a915dd8cd87762d5014850bbae03','1016c2679843aaf59f7065f9ae8d11c821052ed012994a07d1a6699dd7cc19ce');
INSERT INTO blocks VALUES(310025,'a872e560766832cc3b4f7f222228cb6db882ce3c54f6459f62c71d5cd6e90666',1419702500,NULL,NULL,'a50649ba5c8d321cc3b2e713229fbcdba0b4968d44d75e693b6d2764c9828e68','5628662d835b057ba40743f9a2bd856df88a86a2fbb127b7c68d6c8ce402af84','c779e772b29357418ba77bda0b2d24f6e3783d501bc2341cc84b64de362f23dd');
INSERT INTO blocks VALUES(310026,'6c96350f6f2f05810f19a689de235eff975338587194a36a70dfd0fcd490941a',1419702600,NULL,NULL,'a932b103c85c700328f6e91dcc36c220f4a24dd264dfcca262ecdffd2efe3fb0','12ab6aac08fd17d7a08f77c8fafc85472562e04ffe3f08bec1751aea8383abcf','09736f69b21c52e3cbf743cad99411bd13b4e9d87c291cb5726b4c81af211a5e');
INSERT INTO blocks VALUES(310027,'d7acfac66df393c4482a14c189742c0571b89442eb7f817b34415a560445699e',1419702700,NULL,NULL,'cd6ef7175cc33d3d5d55557b819b0efd4330afaba1402029fed5465e1416f210','abfad6ba3f7b702ffbd6ac10d9691fb93ab257ee3e4973500870fcd7d668f468','22abc5885b10bb390e5c038b65f91ef3bd741fac17a766522a229d2276c2dcce');
INSERT INTO blocks VALUES(310028,'02409fcf8fa06dafcb7f11e38593181d9c42cc9d5e2ddc304d098f990bd9530b',1419702800,NULL,NULL,'57b74ec600133925b941a85f0dc283a5e51cf95bd8f262270a78e1bf4899d1ea','7b8292d1a66d7967460f2cee16cd5e907bca19d7a59ed43eabe111ea0fbbda4e','7ccff1122c3428d2b07ca9762299380b843cebd35ab7f6ea17db9940beb7059a');
INSERT INTO blocks VALUES(310029,'3c739fa8b40c118d5547ea356ee8d10ee2898871907643ec02e5db9d00f03cc6',1419702900,NULL,NULL,'fdf3387cd8c52702a52c65720db4ab45992bba3cdc6e8451a382c9ab451c15fb','ed945b8510b8bf68193175862d03e9da0a9da6dec62bb2ee3ef853bf13e47585','56db39826a182fd3ff607ac8e217c92825280242245985f1e82627d9261223c5');
INSERT INTO blocks VALUES(310030,'d5071cddedf89765ee0fd58f209c1c7d669ba8ea66200a57587da8b189b9e4f5',1419703000,NULL,NULL,'8b3ecfdf6105bf3f8eed7f9953acf6a9f81a6f63572946e196c18368a84f5d4f','8cecee00fea9ff5127ed4e131807f3c201e802c760ed381a6b6715524823a0a2','77c1c9cc6c039f2a97f0a9de4106bd7469029965729b353daff209787924ecaa');
INSERT INTO blocks VALUES(310031,'0b02b10f41380fff27c543ea8891ecb845bf7a003ac5c87e15932aff3bfcf689',1419703100,NULL,NULL,'9cd659ffd7a90f47e071869edcb7708072c5dfef432de623868e34a94a5493e4','4ac0c43fd89d76405a96cdb5e7accf4e72fe767b811108dcc153ada9e3b3dddb','9fe43aa96f30f92787dc989e1f064096777a7e18481afcad01708b11f11d74a9');
INSERT INTO blocks VALUES(310032,'66346be81e6ba04544f2ae643b76c2b7b1383f038fc2636e02e49dc7ec144074',1419703200,NULL,NULL,'2c61c6a50bd27a0af21a196fd0c60c3ebbc10de764c61a7aef7e87fedcf4479a','ac7e9c853622d369dfbe176dc47b972e0ad98dae7db34c8ea456fbf824de1782','7f9a0d1ed3b918d09510a8103e057b494e2fd58862e481fd2ea53764fbdf0d47');
INSERT INTO blocks VALUES(310033,'999c65df9661f73e8c01f1da1afda09ac16788b72834f0ff5ea3d1464afb4707',1419703300,NULL,NULL,'001364fede8bd40df33c1d021582947145372893e6e4ea5fd82dfa59327fe042','798ec1647234cc42738be107f882617475c7806237c79d41e87075dc723f49da','64a4381d30a823d92811713b1584b93d3a25925e2105f218d2468863a5306447');
INSERT INTO blocks VALUES(310034,'f552edd2e0a648230f3668e72ddf0ddfb1e8ac0f4c190f91b89c1a8c2e357208',1419703400,NULL,NULL,'f6620f2af2717fdd231946ad06553318ac2fd605a8b228ef13534fb73ce395ce','d3701903cde55eb25274b6e055e552c006fe2a09223d26e32cee3fec4640ab9d','018c021ecb0858256d7bd6d9471d0ee26eb38a51784c612d57c7c2edd3609e95');
INSERT INTO blocks VALUES(310035,'a13cbb016f3044207a46967a4ba1c87dab411f78c55c1179f2336653c2726ae2',1419703500,NULL,NULL,'f13d988f6434020fe275eabbd2016996e828addf1d201a6231b6294e4afc0d9e','f5de8d784be1bcdb5271be193108d2cecf51d6812d8cb73bebd6177c36880260','11a8fec00d209f7d3045ecb341afda31933461a600c1dd3ce9b2eba6a385565e');
INSERT INTO blocks VALUES(310036,'158648a98f1e1bd1875584ce8449eb15a4e91a99a923bbb24c4210135cef0c76',1419703600,NULL,NULL,'ccff6542bfa6022fd0a1cf5ab00fd8ac19cab4e13bcca3d1a5d67e1bb76b027d','c104985d5120a01130d89759af8481f25fae177254c69970f8bee2e18b81611e','7c051fd57a1c37b97733a2786eda34dfe4cafb1e9ce29e76cb2c01029e2a9536');
INSERT INTO blocks VALUES(310037,'563acfd6d991ce256d5655de2e9429975c8dceeb221e76d5ec6e9e24a2c27c07',1419703700,NULL,NULL,'7c08533b3c1f69944f8509c368877c716e9f6d6cce685d7e06767426d1c959c2','2e2c9892813076eb01938f07406d4457433a8aa791ebb93273c4625200f7129a','70b96e2f237759723dae913cb2a7d6493a29f86fd27b0bc2276704c9088eea56');
INSERT INTO blocks VALUES(310038,'b44b4cad12431c32df27940e18d51f63897c7472b70950d18454edfd640490b2',1419703800,NULL,NULL,'d209af26dce13e2a1e81ad956e5a806dada7bed93fbac17dcb48301cb0d03747','d163bcf3adc967f6977a4c07dacf1b4b9560b96a201cb9ceaf10b5467e91883a','c7ca5b1a7fa27d65a54738867ce4e7f6901d5007fd978161c9b799d43a1521a4');
INSERT INTO blocks VALUES(310039,'5fa1ae9c5e8a599247458987b006ad3a57f686df1f7cc240bf119e911b56c347',1419703900,NULL,NULL,'c06ffbc97aced804a1a69501c193764b802e9612d1c809a080a9d0ee4ff31404','d2f3de97a454739b1f62ddce96e469da068dffcba689daa03a82413a97d7d20c','8985f3dc3fa2b7127ccb7020dcf721260d0f767308688bfd3b85060a31f92644');
INSERT INTO blocks VALUES(310040,'7200ded406675453eadddfbb2d14c2a4526c7dc2b5de14bd48b29243df5e1aa3',1419704000,NULL,NULL,'6b93dc7de0688e3d3c1cf8647e01ff7ee509bd8b914091a86a458c9083141ef7','705e62ab29e426fcdcd1c8c606eb7099b291138ccfdc6be180e3f6c3e0c1bae7','84a6621dde9191caa398c9d4681559fe49c3747bb1c460254e28a0e41e1504b4');
INSERT INTO blocks VALUES(310041,'5db592ff9ba5fac1e030cf22d6c13b70d330ba397f415340086ee7357143b359',1419704100,NULL,NULL,'b96478c216d2468ce795ad7a6a5a94ed1a9696f396d37d4c6e46f0c6a1cbc79c','7115a38d73302db6203fbb36b218c82b1bcc3c0dbc1bdf333f4a9bd3ec22972e','a736caae55796915460be41924f035984b236bae679e66f3e2d82cfc3e44ea82');
INSERT INTO blocks VALUES(310042,'826fd4701ef2824e9559b069517cd3cb990aff6a4690830f78fc845ab77fa3e4',1419704200,NULL,NULL,'79c024052b4e80858e3a440e120b8445a0ea014aa30fa379b8ce58b7852f8e51','d9d5ab5a5c2d39a6a9246840ca12512462bceb34d309b35248e34e7616d2017f','efe340015723f99fc967ee9aea899abd6323d055b339b1c1e2deefec8b4bd6a3');
INSERT INTO blocks VALUES(310043,'2254a12ada208f1dd57bc17547ecaf3c44720323c47bc7d4b1262477cb7f3c51',1419704300,NULL,NULL,'c8b2d825d3433dc578b143329cd8310ca3f70cc9ffa5eee4b9f1df6a31471f59','0301583b01eb9e0e6a161d9649444baa2b639aff524798ab47987f8e0b7b9b33','d9e365e134151544e7c20d0b7d9c80acb8725346d6c95dc273c0ce3f22c4dc5f');
INSERT INTO blocks VALUES(310044,'3346d24118d8af0b3c6bcc42f8b85792e7a2e7036ebf6e4c25f4f6723c78e46b',1419704400,NULL,NULL,'4e4367b2e4fabfb7a86c2bfbd1413794c4060bab9b0882f444652f69b24fb5c4','f8c7e2b260bbc93031bef8bc8fe8c4e0a63baf98f74adbbc6d8773480823ed59','7b0391ae234d36e8e63b782580a175171542ee5a91cd0c0f85dd4cd03366d031');
INSERT INTO blocks VALUES(310045,'7bba0ab243839e91ad1a45a762bf074011f8a9883074d68203c6d1b46fffde98',1419704500,NULL,NULL,'fc86c431c46ebf5249999d0b3312ddedfa70e983a0a799310b99ec93469de9b5','f12a68d101368a4c4df565f8ed975968d957db30970baa42b6f991d2a958095b','3414716ad2f27fc7ac01f1a325157555d77d11df300713ced1568b4515345dd0');
INSERT INTO blocks VALUES(310046,'47db6788c38f2d6d712764979e41346b55e78cbb4969e0ef5c4336faf18993a6',1419704600,NULL,NULL,'348b8c56bb08fb71664bb23d88289252348ced75cca45005109481df31d6d9fb','19837d6af146fda819cc0fce59a96c37e13f6db1a11093fe4ab4586c35645c78','2c0db177273631ddd260df116adfc598c02f1548d82dfeb32b15f067a45a1165');
INSERT INTO blocks VALUES(310047,'a9ccabcc2a098a7d25e4ab8bda7c4e66807eefa42e29890dcd88149a10de7075',1419704700,NULL,NULL,'3e9301c44b151eb0aef9d318310e3aa46d4e381395da7bf8c4a4c60cd18d34a0','4bfe9a03bfaba008ed5b318a53fd4d7e2aa390849c474c2654fc8c8cdf09e1cc','a81d1e11ee742aaa6b465f0bc17c887b4c6452a97a50b87c3b44070669b31f6e');
INSERT INTO blocks VALUES(310048,'610bf3935a85b05a98556c55493c6de45bed4d7b3b6c8553a984718765796309',1419704800,NULL,NULL,'630d71d2e57716a7ea626ee8d7755745ee9ae3b2bebe3f6f92635e18a06d1e12','82e99b7186486aafb3b3914670950ff6ad491848d9e26bb5ed71179263a70d71','eb39b044e8dac21839c76c5cef1a0518877d68d9185478ba0ce3c06f4678c39b');
INSERT INTO blocks VALUES(310049,'4ad2761923ad49ad2b283b640f1832522a2a5d6964486b21591b71df6b33be3c',1419704900,NULL,NULL,'477610b01eb1700bb4a923c72f50b10e1c3ab55b8440091f45a6c12d89c57737','9919543983ab6c1d2517b4e66b25cc2e7da29559d6911395021b808361a11a0f','c1a5af1bb237770c7558d6922006b2d250976b2d69e21a27357bb8aec2c71a44');
INSERT INTO blocks VALUES(310050,'8cfeb60a14a4cec6e9be13d699694d49007d82a31065a17890383e262071e348',1419705000,NULL,NULL,'2e7290d4744ff1517d659c2cc66cce6768231be01e5d7ebf9c5fbb6a6b6ea115','102fba4f1619feb11b3f56c3f4958f2b3cb62a55a0b7484c22568a10460ba3fe','edc2d3fe5eda8e11c79c50449be371dc05ab133dbbb0b9672ebc801a7cd597fe');
INSERT INTO blocks VALUES(310051,'b53c90385dd808306601350920c6af4beb717518493fd23b5c730eea078f33e6',1419705100,NULL,NULL,'bb083157488bbcc9518342bc72abe3943510c6264b309d191f77a02a7972b9b6','c9749d3aea2bc6f6ab5473058293a2a0d40105f7f329e46d5494435069dc6817','85fc84dce9ce6c7f3183960ca1d75dc000b123f3baa0283b465fddb7cb07455f');
INSERT INTO blocks VALUES(310052,'0acdacf4e4b6fca756479cb055191b367b1fa433aa558956f5f08fa5b7b394e2',1419705200,NULL,NULL,'9c3acb3ef66a72d222267a8686eb75950178a715290d12642723eda43de71280','6e8f517ee9b80115c73a613bb4ff290923eb1f0898657f52f5317209fd04e4b4','550cbbbc2dab58137dce8b307e22a325c54ac4ab43fc15e26fe267d52e1a0581');
INSERT INTO blocks VALUES(310053,'68348f01b6dc49b2cb30fe92ac43e527aa90d859093d3bf7cd695c64d2ef744f',1419705300,NULL,NULL,'a519b719b47afc50a386ac50c8a5f7d661a2e9863d26ac0802b2189af3a31dd7','d3c44d8d99abf2f8914c5f7e59c7650b9539f58d7c4375530a00e4421c755963','5853589ab08355a6e0a1f55797f1643e52762f2008adcad3b2edd940fdf46041');
INSERT INTO blocks VALUES(310054,'a8b5f253df293037e49b998675620d5477445c51d5ec66596e023282bb9cd305',1419705400,NULL,NULL,'c789bcad428b4bf149959eff3d6032cb710dadd88d7bdf3d97a302264aaa1550','e0bd7fff2a42829ad073cc7c5a146ac34e61e5c7ceddcfbdb3f9eba0b8bd7abe','9f356f97950b86f96c77d6eda1cfe4df6e2ea9f59f86e9e822c8d4dcddc3cfe5');
INSERT INTO blocks VALUES(310055,'4b069152e2dc82e96ed8a3c3547c162e8c3aceeb2a4ac07972f8321a535b9356',1419705500,NULL,NULL,'187316bfc88e71e13867c33ccd35cf5d35ce76ac5b14c723e35396745638b10d','4165014da9f7d2ce000dc731a048d9ae30e74b29add988c5d4a7acd6542ae918','7676251c49553e1930533f2cea7aefb2316f83c2b8623618f680b039cba125fe');
INSERT INTO blocks VALUES(310056,'7603eaed418971b745256742f9d2ba70b2c2b2f69f61de6cc70e61ce0336f9d3',1419705600,NULL,NULL,'98c84d00b7a9f63ca56c785fb95a323b457bb1920ebb589cd257ee270a2dc28b','25c5d24d3d8486d96d1d6a43a62fdee4f376ff900467b59a37f6cc279e4e89e9','04809840ead2d0c8fb6085dc70ae1295c475e5eeaaa16dbc26ac1283c766d47d');
INSERT INTO blocks VALUES(310057,'4a5fdc84f2d66ecb6ee3e3646aad20751ce8694e64e348d3c8aab09d33a3e411',1419705700,NULL,NULL,'a146c749f84f7881d3a10ed2b7f6b3f988fa6d50122b40fd5ff9454c389f9a22','89a2a98de76c15e01b26e90b638b3ea47d84ffca4e2427d514d67be0aeb627ff','0ef4e04b6dc28fa23531caff14d7bbaca0702597580e910995bf32c9864d7c87');
INSERT INTO blocks VALUES(310058,'a6eef3089896f0cae0bfe9423392e45c48f4efe4310b14d8cfbdb1fea613635f',1419705800,NULL,NULL,'2e0b9f9d0ff716824e4215bec5dce0360eeeddb2ac5f0993a1d85a161c661928','ab7f1364ac28a6f1decbecc8e0bfda85252c230c7baf3650cf54c748b410e187','02f0020c830d7384edd5a53c5295e042aa29f547b49e9e3c1896030938c2729c');
INSERT INTO blocks VALUES(310059,'ab505de874c43f97c90be1c26a769e6c5cb140405c993b4a6cc7afc795f156a9',1419705900,NULL,NULL,'f25533c44ba4259fddf636bf828ebe5e297a076288a3d265aa33bf3f58783560','16f0d5aca68cd238587ac3a4c6be2b6f8a5c875d4636cfa7bb46d303d906dbb4','800d5bb9e7a67db16542bab2b07bebd258f787fafdf2037a68d6bf4f3fb611a0');
INSERT INTO blocks VALUES(310060,'974ad5fbef621e0a38eab811608dc9afaf10c8ecc85fed913075ba1a145e889b',1419706000,NULL,NULL,'91e5ff0d74192d643a58b61029b0bf9184716f12b9bd026ead73e0d2866fbf38','57d4a1a2e7b342614b29679a146b04be41aaa0c8788d72ae499b8cf462bab575','e8173ae43421fe2d8bb915b85f8905ef4962c9e420c653a58978b7916b08a8ac');
INSERT INTO blocks VALUES(310061,'35d267d21ad386e7b7632292af1c422b0310dde7ca49a82f9577525a29c138cf',1419706100,NULL,NULL,'b173b81bea36a93c1fc76e4d2d4683291fee0544b1b52614b5d7523a9fc545fc','6ad738b039ec090dbd22e0e939ffbd1a9b8034de8cf30d0904263cd44f155549','2ae387e6036a4a003463a121b33fe587c67a87eb2cfc676d373dd04309f26d95');
INSERT INTO blocks VALUES(310062,'b31a0054145319ef9de8c1cb19df5bcf4dc8a1ece20053aa494e5d3a00a2852f',1419706200,NULL,NULL,'28c2dad659e4e6af14705a07b74b45e847a29b7d67c9cb992487db9ba0a106f4','28e34bc23535663a501218771d077074b2aead714b42dce2f589c96549ead060','2d0cb596ecc7f9a79567b5f7bf16675f098c4df6594c62de41ab4a74f0d946a5');
INSERT INTO blocks VALUES(310063,'0cbcbcd5b7f2dc288e3a34eab3d4212463a5a56e886804fb4f9f1cf929eadebe',1419706300,NULL,NULL,'b474f9c802c4ba41b9fbbead958fa75cf52c5c30c92d16cff217366cc3074cae','1be60666d656b88a966cda3ca84efac2ff352e8420104583d0ad303deabcdb36','140cbea0706513198502102805a2ef9d7821ea911db5ed2dd0d0fde5710c4996');
INSERT INTO blocks VALUES(310064,'e2db8065a195e85cde9ddb868a17d39893a60fb2b1255aa5f0c88729de7cbf30',1419706400,NULL,NULL,'b955d15762a75c32b7ec6d0aa580a5cf74cc73d34cdec500bafd6092a4dcbeab','d6fb1ea5f5e0c06aab60fd016798120298cc43c6ee94a701d14ce583f6ab8b11','248d55fba5c0d8bce86aba66babf4cd0870e7fa3308f93330980930e9d6b9ea2');
INSERT INTO blocks VALUES(310065,'8a7bc7a77c831ac4fd11b8a9d22d1b6a0661b07cef05c2e600c7fb683b861d2a',1419706500,NULL,NULL,'1d4382c945f105b7fb2eeeb5a9fdbc0a1773082ec7a547f9607a5972496222ff','7a644160d21b7ee45b199cc6b15599765612c11e1704535b78c1caa8e8af0181','434bfea3c94e73d63097905f6cf5030ec4d0b1a372806257dea56190de060431');
INSERT INTO blocks VALUES(310066,'b6959be51eb084747d301f7ccaf9e75f2292c9404633b1532e3692659939430d',1419706600,NULL,NULL,'8f3cf4b54f03e2d7b9240b9fad157e7a32f06b134d7ef8ac1cc443a1fa046e1f','cd6418e29198808a9ca52dc93788d914a976e59e575e6d954bcd8520e604579c','1c63e14aa537567225958d430e1bbd2eec4b5e156dd9f873b1ee7a50f8cadb3d');
INSERT INTO blocks VALUES(310067,'8b08eae98d7193c9c01863fac6effb9162bda010daeacf9e0347112f233b8577',1419706700,NULL,NULL,'8b9285d0cea53b5a898289f1736267e1b92de1c9892b3e2985e562bf3bb7fd4e','5b6ac9d01dfd3c3d9a1cd5d03272da2ecd770b565f4c82a4a846a5064f4a3b2f','f52dadc8481353d1a2461df9f8691b3144d759294e25837471fe614627bb846e');
INSERT INTO blocks VALUES(310068,'9280e7297ef6313341bc81787a36acfc9af58f83a415afff5e3154f126cf52b5',1419706800,NULL,NULL,'ee71bfdc09c524b52aec9c7cefc308a86f7d7fcaf51a7c21631e8e053b5d15a6','54885ff5d7e5c3c0ced1502adb07b729dbc23f011b4293a3cfcf81d1127f6bb1','8837f997fa2e5e13290cfd5631d1c0b0356ddc311cd8e57918f51a288d05ffc9');
INSERT INTO blocks VALUES(310069,'486351f0655bf594ffaab1980cff17353b640b63e9c27239109addece189a6f7',1419706900,NULL,NULL,'ed4b8cf960395b43344af5cb41e2be9ba243afa3e998053f6c3ee04ccbbee56d','466b8139c0eda511c3dcea7b56b56423d6633e6228d20971e693d4419b58b608','16a6f1884a07f9814a2d3f40ff3e407dc2bb622249e7e400c35b408be1e45737');
INSERT INTO blocks VALUES(310070,'8739e99f4dee8bebf1332f37f49a125348b40b93b74fe35579dd52bfba4fa7e5',1419707000,NULL,NULL,'52ffeac4b6a67d54ceb74c46ed6ab2ce28ad61441a0d79b59c110042268d99e2','c3f07fe1d99e42d58f6fca1aaa9393934434002d0bb5c902c64d6ce37ab7e0dd','adbb9ac5c987f8c9114c87f7942b78fbca9f8c56749690fd9cb7077eaadb3db5');
INSERT INTO blocks VALUES(310071,'7a099aa1bba0ead577f1e44f35263a1f115ed6a868c98d4dd71609072ae7f80b',1419707100,NULL,NULL,'bf541ac8f547e8a241641cfe5877e8d443f06953f38e5e913b33e1137a806466','e5d8047b9797d9b776d2695f828494dbd0f926a9bab6b971d87690a14d337d1f','95ef357c67f175b49877ba89b44667f5a60cdf9c71cea499c319f955f4759204');
INSERT INTO blocks VALUES(310072,'7b17ecedc07552551b8129e068ae67cb176ca766ea3f6df74b597a94e3a7fc8a',1419707200,NULL,NULL,'5edf24bdff55c9a63407dae9e4d3fb78b9a6888396c50653e6a78ca09c43cd5d','3f75da1856d371d1b3a19510533c1a9defc5c819b4e71382921813d23d21a455','a12458e1a0968f7ec92458ec8a7b458733402f64fea4cfe0a2727313d6564101');
INSERT INTO blocks VALUES(310073,'ee0fe3cc9b3a48a2746b6090b63b442b97ea6055d48edcf4b2288396764c6943',1419707300,NULL,NULL,'2f10c52a55ea456c4219abc2ff96b0ca31be462c6ae1788914bf5e425846f034','7271b18e892f25746522a97b255dd38d574249cf0ec734f1927a5198a72be949','dfc8cbbe693d0bb2cc5b43094a13c6d0cc08ee5bd924feb154d5db1f7fda1eab');
INSERT INTO blocks VALUES(310074,'ceab38dfde01f711a187601731ad575d67cfe0b7dbc61dcd4f15baaef72089fb',1419707400,NULL,NULL,'c2d80d2f7bb05c54db1bb232b54cdfa8630b92bbd5f108334651f3c84df7d01e','67cb01d23c39617e85d8655c20ebd7b20574ccc2d21309f23de11415650a95a4','355113d7c29ff57562563ffbdc984301eafc1ebca8cd2182a083c76787d3701d');
INSERT INTO blocks VALUES(310075,'ef547198c6e36d829f117cfd7077ccde45158e3c545152225fa24dba7a26847b',1419707500,NULL,NULL,'dd56e6d6f159d28b48f05ad2eb2bf1c4ce99a0c55729cc6654f48c0a916f8c3c','ae987a07dd8728a26e223ff34781957cf97acc6f36de7a7ae91a75fcdb5e9781','7a8b3bc545fdf999e1791ff99c79dfd8a9ed30fb6e06225a13f12ed2620995d6');
INSERT INTO blocks VALUES(310076,'3b0499c2e8e8f0252c7288d4ecf66efc426ca37aad3524424d14c8bc6f8b0d92',1419707600,NULL,NULL,'30ff660f41c24df2d2fa91f0b8215fada3687292abd20fa099407628e2b96d3a','f250c9721d513045abfd72a2638faaf12cc4bf53c91d8682f2874ecffb35acd4','6e458aec2122baa4018d3e99855f1299703f733710e699f54359716fab5bd7d5');
INSERT INTO blocks VALUES(310077,'d2adeefa9024ab3ff2822bc36acf19b6c647cea118cf15b86c6bc00c3322e7dd',1419707700,NULL,NULL,'0afd2982c51a3cf176e12904603528818d2cdceb7a63c315fa456404cd911acd','069b88257869d772cbc88ebb1db0f1442cf860e7f8e2f10771163efeec9fbd8e','a48b6322e95ee0dec42868236bb140623102a8a9b1158bd665297109320afb5e');
INSERT INTO blocks VALUES(310078,'f6c17115ef0efe489c562bcda4615892b4d4b39db0c9791fe193d4922bd82cd6',1419707800,NULL,NULL,'a569649f39fedada9c53e9e143aa8fd1cff0f5aa0cdf4b05fa099d6a58cd7a4e','56df9b1149edc74288d5163abea94f6192f13794d068e814bd98212882b39c40','026b563f7054268e41405d1663f5b37f863f8362714a32936b7fb9eac0a80b36');
INSERT INTO blocks VALUES(310079,'f2fbd2074d804e631db44cb0fb2e1db3fdc367e439c21ffc40d73104c4d7069c',1419707900,NULL,NULL,'c5364b3824ce5fbbccf6581bf700738c14cec463392b65cabeee921005609ee0','4fdd3de811da03155e0a410de50ce0ffeb9d154eb99505723b262f0b337cea6a','cf5b1e1ac048b391ba83a45ee67ff827c2e781cc22a11ef0a170b41e7598dd2b');
INSERT INTO blocks VALUES(310080,'42943b914d9c367000a78b78a544cc4b84b1df838aadde33fe730964a89a3a6c',1419708000,NULL,NULL,'3145a8ff2173c2f8f2978fcee59d18ae120eb641d85851a41d22ded3dcf23074','a90baeb20d629737d1382836304261f7c2a2a773b9de671584a04a3e37ff6853','efaee20505760a70b338910740c24c2301e9bc12d91b4ba2818bbfd2861b24a4');
INSERT INTO blocks VALUES(310081,'6554f9d307976249e7b7e260e08046b3b55d318f8b6af627fed5be3063f123c4',1419708100,NULL,NULL,'bbf408f8a94acedab49ba9bcb19c67a8fc9a5134104e639f3c3247772e65670a','fee087724ee52ff6f40863467fe8f705338b54c4b7b77cd5b7a6298538728fc1','d9d744fd70db01b54b3f7e0c208708feb88ee23bad160b8c1827276b82188b50');
INSERT INTO blocks VALUES(310082,'4f1ef91b1dcd575f8ac2e66a67715500cbca154bd6f3b8148bb7015a6aa6c644',1419708200,NULL,NULL,'8ceb6234c2f1c5818acb675fedccb8993631ffe813d99abf3e8d0dc42bc3a2bf','beb718113ab8f7eeb9657ddec121895e61681b85510cb2368a451053448df610','a4642e2cf514e490b0d12de53ece8b513b786e4faa45d5a3d0f8f147caabc246');
INSERT INTO blocks VALUES(310083,'9b1f6fd6ff9b0dc4e37603cfb0625f49067c775b99e12492afd85392d3c8d850',1419708300,NULL,NULL,'2e3d9b9998194dc953f2b0ab372378d7d9142b1b9016813720f84980fb3c09bb','b5f5324f6497ee5b11cb0e303354cc7824ff987cb8bc18a2b5236478c3846874','d49f58734581fcd733b592a70b413da808edb6392c1ace400cadc42da1e5dd5d');
INSERT INTO blocks VALUES(310084,'1e0972523e80306441b9f4157f171716199f1428db2e818a7f7817ccdc8859e3',1419708400,NULL,NULL,'99984905f248aef49205be3788d634a8b0d1c8e3de50854cbc743c2ad398adcc','7acc75445308ec3128676c38fdcee8999be4ef6da367a4db610a4af6d5d855a4','8e83a36a46b8bc0126890bcf393b96d0ed705b5be2a48a69631042bfbce317d7');
INSERT INTO blocks VALUES(310085,'c5b6e9581831e3bc5848cd7630c499bca26d9ece5156d36579bdb72d54817e34',1419708500,NULL,NULL,'92845d28c51ea77e242cef67298a52ac107511ca30874f0fd6d30faa88ee8995','074e6ec7a097d84e7f30f518dcc2296f8690750947985c820215b1797c0a799f','d5c36c93f03d8fc41c194a8c2e0cb71442217325c44a2083fc6df0cdb5470958');
INSERT INTO blocks VALUES(310086,'080c1dc55a4ecf4824cf9840602498cfc35b5f84099f50b71b45cb63834c7a78',1419708600,NULL,NULL,'e4502595341828a6933aaeaa0cb0303cd5594fcad49d1c77c6e10b37b2b2ceb3','ca3d53256d1c4d9465058a8eeaefaea1ff16b828a25c8b987c1f8ec30350b91a','8024e7f16210b42b4732a52f5990437c8a9afbcf81857846cf14f36fa0d91a0d');
INSERT INTO blocks VALUES(310087,'4ec8cb1c38b22904e8087a034a6406b896eff4dd28e7620601c6bddf82e2738c',1419708700,NULL,NULL,'2ebe44f208bff0dfbab415de53fcb692e5105a1dd92033b1f76d205aeafe2ca9','a743e3e65fae82148ea9983de14469e822db9323df50b8f969e490e3b90f081c','1d470971c338b59655798c5fcf404ac2b6c61805e2fa8155810e793056eeee81');
INSERT INTO blocks VALUES(310088,'e945c815c433cbddd0bf8e66c5c23b51072483492acda98f5c2c201020a8c5b3',1419708800,NULL,NULL,'1fb200d8f05d0f14429272271f8a1a4e899ab899d2852e7f03960ca4c31efb17','5f25194321c79b183483b4c90c3a92f050f5d4c07fdd564d1d8742a30ca56f4c','e39a9c36c76135dbc92d1e7bbe7dd96edad916f3434984553696a06538783913');
INSERT INTO blocks VALUES(310089,'0382437f895ef3e7e38bf025fd4f606fd44d4bbd6aea71dbdc4ed11a7cd46f33',1419708900,NULL,NULL,'24a693290f31ae4bf913610be500af39101962ccbbc0f24d86b502fc117f6e44','65625ba199b23c27440d47cb2c5c62d447216465b501025052b445d6dbaa213c','396921954ce11a12cd6d836278fcf726cd79fc46707d1cb4fda35288d53c1be3');
INSERT INTO blocks VALUES(310090,'b756db71dc037b5a4582de354a3347371267d31ebda453e152f0a13bb2fae969',1419709000,NULL,NULL,'553e9b516cc1b49197e46b865d2ae5b61c8ec1b66c7483c92f1f9f39e7a46c67','ac118b0c3076dddee8cf79f6f19dc563d38356cea0357e85e880a0c78810e7cb','4c663ece7a500c6223b36f63b08f6cac9488907bb653157d2f91cb229c088a6c');
INSERT INTO blocks VALUES(310091,'734a9aa485f36399d5efb74f3b9c47f8b5f6fd68c9967f134b14cfe7e2d7583c',1419709100,NULL,NULL,'32de23e63359093744fbf39712d625a4fd0974f69748b6e9265c940e0e779c63','d064fa665b35962bec8e5b1b6b0dd45a82ee7e94f5b50860b5bcc6632bc23ba2','dfffbb9cddd7ca9db7731f53e04440d7c99a61ed915445caf9fbc811dae7d324');
INSERT INTO blocks VALUES(310092,'56386beb65f9228740d4ad43a1c575645f6daf59e0dd9f22551c59215b5e8c3d',1419709200,NULL,NULL,'35a6753e411c0a9851195aca1af1563f2401a52842663d12ca82f5a605a8b7c8','5bdf48ca0146983054efadae8ed8cb4b17ff624065e9dbfb374181c93f2bf0b9','94fa51a0b07c76e08aee788db9c17a4fde7181e1fe5d54af0d3a543ebe700dd5');
INSERT INTO blocks VALUES(310093,'a74a2425f2f4be24bb5f715173e6756649e1cbf1b064aeb1ef60e0b94b418ddc',1419709300,NULL,NULL,'e840125392e6197cb1def32c1c56ffd7695c4911c354f2735855776e33078eed','67607924da94441a8c71be54b2c5a5bd45c80ea7cd468d42d531b02c9581e7d0','673f1a6b8d8d630ac76ddf50f041d98d9b684d8e1676e6e6ee3ec34f1dc09346');
INSERT INTO blocks VALUES(310094,'2a8f976f20c4e89ff01071915ac96ee35192d54df3a246bf61fd4a0cccfb5b23',1419709400,NULL,NULL,'337dadf31194828b25c0294efbe4250513409a48062e1de07093a01cb49e8e1d','08d0fcede70e2a81c2acac182019ade9fd67e0761c73a74092f90b86ce042771','d6f8391642914a51921b69dcbd85f3b440b75ca4de467be554281858f5872991');
INSERT INTO blocks VALUES(310095,'bed0fa40c9981223fb40b3be8124ca619edc9dd34d0c907369477ea92e5d2cd2',1419709500,NULL,NULL,'f7f0eb348e8827fd7c6208a55f5392fc98c542a7cc74344e21708c59162172d2','182a9d6d85044c92a0e161caf2960a33c8f84dce1bcbd74936e551cf78162069','41069b7563fff3a432d5e0c2e76913a235422a332939efa0bf4dbf32475cfbf6');
INSERT INTO blocks VALUES(310096,'306aeec3db435fabffdf88c2f26ee83caa4c2426375a33daa2be041dbd27ea2f',1419709600,NULL,NULL,'afd66ef121baddfd5167aa076d21392633ac5867e7ed92bfdcee20bb0a45aecf','ca26d930b26521f1d453d65d76a165941fc255adec6186249f93bbf311562ce3','4d8581938348de3de50dc1ee808ef661265db255b876dc3225ee4472ba1c6420');
INSERT INTO blocks VALUES(310097,'13e8e16e67c7cdcc80d477491e554b43744f90e8e1a9728439a11fab42cefadf',1419709700,NULL,NULL,'116d99117704321bcf490e45d9f436f02134252d6f3f3a6edcc6fdf5a70cc18c','e443a400aedc3fb0b5866adb735307b0eee5310544136cdfee9ea96f58a9eb53','d48f22f0ae482066cf68ccb07fb2a655bd7ddefe3a9cd0bdd79d0ad501fe8a95');
INSERT INTO blocks VALUES(310098,'ca5bca4b5ec4fa6183e05176abe921cff884c4e20910fab55b603cef48dc3bca',1419709800,NULL,NULL,'fddb5f7f846f186eb8192febcead9296b71ef490fa8a6cdebd203bb89115c2f5','2ab6e2ed5a02edf406a783d3eaa4c5106a1df489b3dec0663ecedc27d937df22','1702ada7adbc5e46d3bbec72d57fc4b02291ef248ce0c7ca15f6856c4b1d1f08');
INSERT INTO blocks VALUES(310099,'3c4c2279cd7de0add5ec469648a845875495a7d54ebfb5b012dcc5a197b7992a',1419709900,NULL,NULL,'9d0e50a8904543c0e13f0ba12545a7ffb7d7d5e367004be64b1a7a772238fa37','fb3feaa9219d68166a7e4d1e12b3782b9ea3d80dc1e6009b882c32793b4d69cc','3e4c8217593098ddca743aa287cfb1b5352da72f2c5b982e9cd9b46dd0f56010');
INSERT INTO blocks VALUES(310100,'96925c05b3c7c80c716f5bef68d161c71d044252c766ca0e3f17f255764242cb',1419710000,NULL,NULL,'786113f8ce95d9b28586528b1f73e37322513f5478fec735d7ca00ef57f54a5c','4a48d483278431df12064a68a14d8a6f4a3d9a9fff7891ea4e7f9cc7eb6c6d9d','89449d2d473a6694c523d5e6c70ea92d1ff29988e476b41ce92b29e93be6e527');
INSERT INTO blocks VALUES(310101,'369472409995ca1a2ebecbad6bf9dab38c378ab1e67e1bdf13d4ce1346731cd6',1419710100,NULL,NULL,'ef88481494dba7b9cc5be032f63d4f77cd005c924fb4393bbc4e26abde6b0768','f3a25f8a5ba3b82b5e5f78576e8a31755c17a5c43b647718442a8cb69d8805e0','5ec407502b7e1c91b3df45864960a18a62f8d4025b6ae590f0f10ba2bde64721');
-- Triggers and indices on  blocks
CREATE INDEX block_index_idx ON blocks (block_index);
CREATE INDEX index_hash_idx ON blocks (block_index, block_hash);

-- Table  broadcasts
DROP TABLE IF EXISTS broadcasts;
CREATE TABLE broadcasts(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      timestamp INTEGER,
                      value REAL,
                      fee_fraction_int INTEGER,
                      text TEXT,
                      locked BOOL,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
INSERT INTO broadcasts VALUES(12,'41e035a66717c50429f2d8b1b90a7e73f15d4f84a0b32a77acb0f5a4356457b1',310011,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',1388000000,100.0,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(19,'981ca3efb6831e3b9f73438a1d83e06a2d66b730ef87f39668383edf7113eff4',310018,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',1388000050,99.86166,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(20,'0bee8044e76f0be22bea66f32db1938bffae974e6239ed863635de63ac3aceb7',310019,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',1388000101,100.343,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(21,'b3b2f17eaff6f686d2c0d7efba3fc03cbe5cd464426f96c0e88578ff800418e5',310020,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',1388000201,2.0,5000000,'Unit Test',0,'valid');
-- Triggers and indices on  broadcasts
CREATE TRIGGER _broadcasts_delete BEFORE DELETE ON broadcasts BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO broadcasts(rowid,tx_index,tx_hash,block_index,source,timestamp,value,fee_fraction_int,text,locked,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.timestamp)||','||quote(old.value)||','||quote(old.fee_fraction_int)||','||quote(old.text)||','||quote(old.locked)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _broadcasts_insert AFTER INSERT ON broadcasts BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM broadcasts WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _broadcasts_update AFTER UPDATE ON broadcasts BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE broadcasts SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',timestamp='||quote(old.timestamp)||',value='||quote(old.value)||',fee_fraction_int='||quote(old.fee_fraction_int)||',text='||quote(old.text)||',locked='||quote(old.locked)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX status_source_idx ON broadcasts (status, source);
CREATE INDEX status_source_index_idx ON broadcasts (status, source, tx_index);
CREATE INDEX timestamp_idx ON broadcasts (timestamp);

-- Table  btcpays
DROP TABLE IF EXISTS btcpays;
CREATE TABLE btcpays(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      destination TEXT,
                      btc_amount INTEGER,
                      order_match_id TEXT,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
INSERT INTO btcpays VALUES(5,'186f3db77952b50220f20fb875f65eb63064a9c73436dc4fc6a182e0a7e00d6d',310004,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',50000000,'2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df_dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30','valid');
-- Triggers and indices on  btcpays
CREATE TRIGGER _btcpays_delete BEFORE DELETE ON btcpays BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO btcpays(rowid,tx_index,tx_hash,block_index,source,destination,btc_amount,order_match_id,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.destination)||','||quote(old.btc_amount)||','||quote(old.order_match_id)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _btcpays_insert AFTER INSERT ON btcpays BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM btcpays WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _btcpays_update AFTER UPDATE ON btcpays BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE btcpays SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',destination='||quote(old.destination)||',btc_amount='||quote(old.btc_amount)||',order_match_id='||quote(old.order_match_id)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;

-- Table  burns
DROP TABLE IF EXISTS burns;
CREATE TABLE burns(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      burned INTEGER,
                      earned INTEGER,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
INSERT INTO burns VALUES(1,'1b8787f4111f7dd95d56168e3ada0a36c9ac88bb86908b9f921e33d12bd88a37',310000,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',62000000,93000000000,'valid');
INSERT INTO burns VALUES(23,'5d015bfc17193c05376698968fd0474269dc496f4ee1e7e989b91b6b7bd8fde1',310022,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',38000000,56999887262,'valid');
-- Triggers and indices on  burns
CREATE TRIGGER _burns_delete BEFORE DELETE ON burns BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO burns(rowid,tx_index,tx_hash,block_index,source,burned,earned,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.burned)||','||quote(old.earned)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _burns_insert AFTER INSERT ON burns BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM burns WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _burns_update AFTER UPDATE ON burns BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE burns SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',burned='||quote(old.burned)||',earned='||quote(old.earned)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;

-- Table  cancels
DROP TABLE IF EXISTS cancels;
CREATE TABLE cancels(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      offer_hash TEXT,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
-- Triggers and indices on  cancels
CREATE TRIGGER _cancels_delete BEFORE DELETE ON cancels BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO cancels(rowid,tx_index,tx_hash,block_index,source,offer_hash,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.offer_hash)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _cancels_insert AFTER INSERT ON cancels BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM cancels WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _cancels_update AFTER UPDATE ON cancels BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE cancels SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',offer_hash='||quote(old.offer_hash)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX cancels_block_index_idx ON cancels (block_index);

-- Table  contracts
DROP TABLE IF EXISTS contracts;
CREATE TABLE contracts(
                      contract_id TEXT PRIMARY KEY,
                      tx_index INTEGER UNIQUE,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      code BLOB,
                      nonce INTEGER,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
-- Triggers and indices on  contracts
CREATE TRIGGER _contracts_delete BEFORE DELETE ON contracts BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO contracts(rowid,contract_id,tx_index,tx_hash,block_index,source,code,nonce) VALUES('||old.rowid||','||quote(old.contract_id)||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.code)||','||quote(old.nonce)||')');
                            END;
CREATE TRIGGER _contracts_insert AFTER INSERT ON contracts BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM contracts WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _contracts_update AFTER UPDATE ON contracts BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE contracts SET contract_id='||quote(old.contract_id)||',tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',code='||quote(old.code)||',nonce='||quote(old.nonce)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX contract_id_idx ON contracts(contract_id);

-- Table  credits
DROP TABLE IF EXISTS credits;
CREATE TABLE credits(
                      block_index INTEGER,
                      address TEXT,
                      asset TEXT,
                      quantity INTEGER,
                      calling_function TEXT,
                      event TEXT,
                      FOREIGN KEY (block_index) REFERENCES blocks(block_index));
INSERT INTO credits VALUES(310000,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',93000000000,'burn','1b8787f4111f7dd95d56168e3ada0a36c9ac88bb86908b9f921e33d12bd88a37');
INSERT INTO credits VALUES(310001,'1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',50000000,'send','625d8e59a9342ac6dd2f3d32ec9f9f56d3b8a8ed194afcbd5be6f04192669269');
INSERT INTO credits VALUES(310004,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',100000000,'btcpay','186f3db77952b50220f20fb875f65eb63064a9c73436dc4fc6a182e0a7e00d6d');
INSERT INTO credits VALUES(310005,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBB',1000000000,'issuance','91182e55e74dfc06bb108545f2aeb827cb812834b125d3c994bed56b291b5216');
INSERT INTO credits VALUES(310006,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBC',100000,'issuance','776fb4dc98d29b37b676ebf6b19dde4794a048af0e2830ff514920d6e57c10bb');
INSERT INTO credits VALUES(310007,'1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBB',4000000,'send','f2c99a57c1d3eef60f76febcfb65a8f3bf25580fe95266d4b36abaa57514491c');
INSERT INTO credits VALUES(310008,'1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBC',526,'send','7c450e1966a44985ee04628e29a238ce73d81e0b0c3d8cfcb9887839dbf89bea');
INSERT INTO credits VALUES(310009,'1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',24,'dividend','2e28d83564e7a67f0b7e9c34653cd7e4ed9b063ce1cd5b102cbbed4001ad7241');
INSERT INTO credits VALUES(310010,'1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',420800,'dividend','7d57cdc8d7a20c3938c82fb81bdf43878ee0d6f3a70a93098c9f339508abcde8');
INSERT INTO credits VALUES(310013,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',4250000,'filled','f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a');
INSERT INTO credits VALUES(310014,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',5000000,'cancel order','dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30');
INSERT INTO credits VALUES(310014,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',41500000,'recredit forward quantity','4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea_f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a');
INSERT INTO credits VALUES(310014,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',20750000,'recredit backward quantity','4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea_f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a');
INSERT INTO credits VALUES(310015,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',0,'filled','37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9');
INSERT INTO credits VALUES(310015,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',0,'filled','37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9');
INSERT INTO credits VALUES(310016,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',150000000,'recredit forward quantity','fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e_37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9');
INSERT INTO credits VALUES(310016,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',350000000,'recredit backward quantity','fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e_37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9');
INSERT INTO credits VALUES(310017,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',0,'filled','484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473');
INSERT INTO credits VALUES(310017,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',0,'filled','484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473');
INSERT INTO credits VALUES(310018,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',750000000,'recredit forward quantity','766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70_484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473');
INSERT INTO credits VALUES(310018,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',650000000,'recredit backward quantity','766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70_484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473');
INSERT INTO credits VALUES(310022,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',56999887262,'burn','5d015bfc17193c05376698968fd0474269dc496f4ee1e7e989b91b6b7bd8fde1');
INSERT INTO credits VALUES(310023,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',8500000,'recredit wager remaining','4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea');
INSERT INTO credits VALUES(310023,'1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBC',10000,'send','2cfbac01ae9a33a41fc062446bf8b08d85c6ca5082fb3ce9042f3e323999b88d');
INSERT INTO credits VALUES(310032,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBB',50000000,'cancel order','e48c933f928db9b300c045ba33197bfb55cc12ebb6f00dfa9903039aa30bd7c0');
-- Triggers and indices on  credits
CREATE TRIGGER _credits_delete BEFORE DELETE ON credits BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO credits(rowid,block_index,address,asset,quantity,calling_function,event) VALUES('||old.rowid||','||quote(old.block_index)||','||quote(old.address)||','||quote(old.asset)||','||quote(old.quantity)||','||quote(old.calling_function)||','||quote(old.event)||')');
                            END;
CREATE TRIGGER _credits_insert AFTER INSERT ON credits BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM credits WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _credits_update AFTER UPDATE ON credits BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE credits SET block_index='||quote(old.block_index)||',address='||quote(old.address)||',asset='||quote(old.asset)||',quantity='||quote(old.quantity)||',calling_function='||quote(old.calling_function)||',event='||quote(old.event)||' WHERE rowid='||old.rowid);
                            END;

-- Table  debits
DROP TABLE IF EXISTS debits;
CREATE TABLE debits(
                      block_index INTEGER,
                      address TEXT,
                      asset TEXT,
                      quantity INTEGER,
                      action TEXT,
                      event TEXT,
                      FOREIGN KEY (block_index) REFERENCES blocks(block_index));
INSERT INTO debits VALUES(310001,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',50000000,'send','625d8e59a9342ac6dd2f3d32ec9f9f56d3b8a8ed194afcbd5be6f04192669269');
INSERT INTO debits VALUES(310003,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',105000000,'open order','dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30');
INSERT INTO debits VALUES(310005,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',50000000,'issuance fee','91182e55e74dfc06bb108545f2aeb827cb812834b125d3c994bed56b291b5216');
INSERT INTO debits VALUES(310006,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',50000000,'issuance fee','776fb4dc98d29b37b676ebf6b19dde4794a048af0e2830ff514920d6e57c10bb');
INSERT INTO debits VALUES(310007,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBB',4000000,'send','f2c99a57c1d3eef60f76febcfb65a8f3bf25580fe95266d4b36abaa57514491c');
INSERT INTO debits VALUES(310008,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBC',526,'send','7c450e1966a44985ee04628e29a238ce73d81e0b0c3d8cfcb9887839dbf89bea');
INSERT INTO debits VALUES(310009,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',24,'dividend','2e28d83564e7a67f0b7e9c34653cd7e4ed9b063ce1cd5b102cbbed4001ad7241');
INSERT INTO debits VALUES(310009,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',20000,'dividend fee','2e28d83564e7a67f0b7e9c34653cd7e4ed9b063ce1cd5b102cbbed4001ad7241');
INSERT INTO debits VALUES(310010,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',420800,'dividend','7d57cdc8d7a20c3938c82fb81bdf43878ee0d6f3a70a93098c9f339508abcde8');
INSERT INTO debits VALUES(310010,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',20000,'dividend fee','7d57cdc8d7a20c3938c82fb81bdf43878ee0d6f3a70a93098c9f339508abcde8');
INSERT INTO debits VALUES(310012,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',50000000,'bet','4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea');
INSERT INTO debits VALUES(310013,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',25000000,'bet','f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a');
INSERT INTO debits VALUES(310014,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',150000000,'bet','fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e');
INSERT INTO debits VALUES(310015,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',350000000,'bet','37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9');
INSERT INTO debits VALUES(310016,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',750000000,'bet','766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70');
INSERT INTO debits VALUES(310017,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',650000000,'bet','484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473');
INSERT INTO debits VALUES(310021,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBB',50000000,'open order','e48c933f928db9b300c045ba33197bfb55cc12ebb6f00dfa9903039aa30bd7c0');
INSERT INTO debits VALUES(310023,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBC',10000,'send','2cfbac01ae9a33a41fc062446bf8b08d85c6ca5082fb3ce9042f3e323999b88d');
-- Triggers and indices on  debits
CREATE TRIGGER _debits_delete BEFORE DELETE ON debits BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO debits(rowid,block_index,address,asset,quantity,action,event) VALUES('||old.rowid||','||quote(old.block_index)||','||quote(old.address)||','||quote(old.asset)||','||quote(old.quantity)||','||quote(old.action)||','||quote(old.event)||')');
                            END;
CREATE TRIGGER _debits_insert AFTER INSERT ON debits BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM debits WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _debits_update AFTER UPDATE ON debits BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE debits SET block_index='||quote(old.block_index)||',address='||quote(old.address)||',asset='||quote(old.asset)||',quantity='||quote(old.quantity)||',action='||quote(old.action)||',event='||quote(old.event)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX address_idx ON debits (address);
CREATE INDEX asset_idx ON debits (asset);

-- Table  destructions
DROP TABLE IF EXISTS destructions;
CREATE TABLE destructions(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      asset INTEGER,
                      quantity INTEGER,
                      tag TEXT,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
-- Triggers and indices on  destructions
CREATE TRIGGER _destructions_delete BEFORE DELETE ON destructions BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO destructions(rowid,tx_index,tx_hash,block_index,source,asset,quantity,tag,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.asset)||','||quote(old.quantity)||','||quote(old.tag)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _destructions_insert AFTER INSERT ON destructions BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM destructions WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _destructions_update AFTER UPDATE ON destructions BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE destructions SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',asset='||quote(old.asset)||',quantity='||quote(old.quantity)||',tag='||quote(old.tag)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX status_idx ON destructions (status);

-- Table  dividends
DROP TABLE IF EXISTS dividends;
CREATE TABLE dividends(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      asset TEXT,
                      dividend_asset TEXT,
                      quantity_per_unit INTEGER,
                      fee_paid INTEGER,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
INSERT INTO dividends VALUES(10,'2e28d83564e7a67f0b7e9c34653cd7e4ed9b063ce1cd5b102cbbed4001ad7241',310009,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBB','XCP',600,20000,'valid');
INSERT INTO dividends VALUES(11,'7d57cdc8d7a20c3938c82fb81bdf43878ee0d6f3a70a93098c9f339508abcde8',310010,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBC','XCP',800,20000,'valid');
-- Triggers and indices on  dividends
CREATE TRIGGER _dividends_delete BEFORE DELETE ON dividends BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO dividends(rowid,tx_index,tx_hash,block_index,source,asset,dividend_asset,quantity_per_unit,fee_paid,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.asset)||','||quote(old.dividend_asset)||','||quote(old.quantity_per_unit)||','||quote(old.fee_paid)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _dividends_insert AFTER INSERT ON dividends BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM dividends WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _dividends_update AFTER UPDATE ON dividends BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE dividends SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',asset='||quote(old.asset)||',dividend_asset='||quote(old.dividend_asset)||',quantity_per_unit='||quote(old.quantity_per_unit)||',fee_paid='||quote(old.fee_paid)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;

-- Table  executions
DROP TABLE IF EXISTS executions;
CREATE TABLE executions(
                      tx_index INTEGER UNIQUE,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      contract_id TEXT,
                      gas_price INTEGER,
                      gas_start INTEGER,
                      gas_cost INTEGER,
                      gas_remained INTEGER,
                      value INTEGER,
                      data BLOB,
                      output BLOB,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
-- Triggers and indices on  executions
CREATE TRIGGER _executions_delete BEFORE DELETE ON executions BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO executions(rowid,tx_index,tx_hash,block_index,source,contract_id,gas_price,gas_start,gas_cost,gas_remained,value,data,output,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.contract_id)||','||quote(old.gas_price)||','||quote(old.gas_start)||','||quote(old.gas_cost)||','||quote(old.gas_remained)||','||quote(old.value)||','||quote(old.data)||','||quote(old.output)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _executions_insert AFTER INSERT ON executions BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM executions WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _executions_update AFTER UPDATE ON executions BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE executions SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',contract_id='||quote(old.contract_id)||',gas_price='||quote(old.gas_price)||',gas_start='||quote(old.gas_start)||',gas_cost='||quote(old.gas_cost)||',gas_remained='||quote(old.gas_remained)||',value='||quote(old.value)||',data='||quote(old.data)||',output='||quote(old.output)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;

-- Table  issuances
DROP TABLE IF EXISTS issuances;
CREATE TABLE issuances(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      asset TEXT,
                      quantity INTEGER,
                      divisible BOOL,
                      source TEXT,
                      issuer TEXT,
                      transfer BOOL,
                      callable BOOL,
                      call_date INTEGER,
                      call_price REAL,
                      description TEXT,
                      fee_paid INTEGER,
                      locked BOOL,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
INSERT INTO issuances VALUES(6,'91182e55e74dfc06bb108545f2aeb827cb812834b125d3c994bed56b291b5216',310005,'BBBB',1000000000,1,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',0,0,0,0.0,'',50000000,0,'valid');
INSERT INTO issuances VALUES(7,'776fb4dc98d29b37b676ebf6b19dde4794a048af0e2830ff514920d6e57c10bb',310006,'BBBC',100000,0,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',0,0,0,0.0,'foobar',50000000,0,'valid');
-- Triggers and indices on  issuances
CREATE TRIGGER _issuances_delete BEFORE DELETE ON issuances BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO issuances(rowid,tx_index,tx_hash,block_index,asset,quantity,divisible,source,issuer,transfer,callable,call_date,call_price,description,fee_paid,locked,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.asset)||','||quote(old.quantity)||','||quote(old.divisible)||','||quote(old.source)||','||quote(old.issuer)||','||quote(old.transfer)||','||quote(old.callable)||','||quote(old.call_date)||','||quote(old.call_price)||','||quote(old.description)||','||quote(old.fee_paid)||','||quote(old.locked)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _issuances_insert AFTER INSERT ON issuances BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM issuances WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _issuances_update AFTER UPDATE ON issuances BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE issuances SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',asset='||quote(old.asset)||',quantity='||quote(old.quantity)||',divisible='||quote(old.divisible)||',source='||quote(old.source)||',issuer='||quote(old.issuer)||',transfer='||quote(old.transfer)||',callable='||quote(old.callable)||',call_date='||quote(old.call_date)||',call_price='||quote(old.call_price)||',description='||quote(old.description)||',fee_paid='||quote(old.fee_paid)||',locked='||quote(old.locked)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX valid_asset_idx ON issuances (asset, status);

-- Table  mempool
DROP TABLE IF EXISTS mempool;
CREATE TABLE mempool(
                      tx_hash TEXT,
                      command TEXT,
                      category TEXT,
                      bindings TEXT,
                      timestamp INTEGER);

-- Table  messages
DROP TABLE IF EXISTS messages;
CREATE TABLE messages(
                      message_index INTEGER PRIMARY KEY,
                      block_index INTEGER,
                      command TEXT,
                      category TEXT,
                      bindings TEXT,
                      timestamp INTEGER);
INSERT INTO messages VALUES(0,310000,'insert','credits','{"action": "burn", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310000, "event": "1b8787f4111f7dd95d56168e3ada0a36c9ac88bb86908b9f921e33d12bd88a37", "quantity": 93000000000}',0);
INSERT INTO messages VALUES(1,310000,'insert','burns','{"block_index": 310000, "burned": 62000000, "earned": 93000000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "tx_hash": "1b8787f4111f7dd95d56168e3ada0a36c9ac88bb86908b9f921e33d12bd88a37", "tx_index": 1}',0);
INSERT INTO messages VALUES(2,310001,'insert','debits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310001, "event": "625d8e59a9342ac6dd2f3d32ec9f9f56d3b8a8ed194afcbd5be6f04192669269", "quantity": 50000000}',0);
INSERT INTO messages VALUES(3,310001,'insert','credits','{"action": "send", "address": "1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310001, "event": "625d8e59a9342ac6dd2f3d32ec9f9f56d3b8a8ed194afcbd5be6f04192669269", "quantity": 50000000}',0);
INSERT INTO messages VALUES(4,310001,'insert','sends','{"asset": "XCP", "block_index": 310001, "destination": "1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "quantity": 50000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "tx_hash": "625d8e59a9342ac6dd2f3d32ec9f9f56d3b8a8ed194afcbd5be6f04192669269", "tx_index": 2}',0);
INSERT INTO messages VALUES(5,310002,'insert','orders','{"block_index": 310002, "expiration": 10, "expire_index": 310012, "fee_provided": 1000000, "fee_provided_remaining": 1000000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 100000000, "get_remaining": 100000000, "give_asset": "BTC", "give_quantity": 50000000, "give_remaining": 50000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "open", "tx_hash": "2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df", "tx_index": 3}',0);
INSERT INTO messages VALUES(6,310003,'insert','debits','{"action": "open order", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310003, "event": "dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30", "quantity": 105000000}',0);
INSERT INTO messages VALUES(7,310003,'insert','orders','{"block_index": 310003, "expiration": 10, "expire_index": 310013, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 900000, "fee_required_remaining": 900000, "get_asset": "BTC", "get_quantity": 50000000, "get_remaining": 50000000, "give_asset": "XCP", "give_quantity": 105000000, "give_remaining": 105000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "open", "tx_hash": "dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30", "tx_index": 4}',0);
INSERT INTO messages VALUES(8,310003,'update','orders','{"fee_provided_remaining": 142858, "fee_required_remaining": 0, "get_remaining": 0, "give_remaining": 0, "status": "open", "tx_hash": "2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df"}',0);
INSERT INTO messages VALUES(9,310003,'update','orders','{"fee_provided_remaining": 10000, "fee_required_remaining": 42858, "get_remaining": 0, "give_remaining": 5000000, "status": "open", "tx_hash": "dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30"}',0);
INSERT INTO messages VALUES(10,310003,'insert','order_matches','{"backward_asset": "XCP", "backward_quantity": 100000000, "block_index": 310003, "fee_paid": 857142, "forward_asset": "BTC", "forward_quantity": 50000000, "id": "2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df_dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30", "match_expire_index": 310023, "status": "pending", "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "tx0_block_index": 310002, "tx0_expiration": 10, "tx0_hash": "2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df", "tx0_index": 3, "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "tx1_block_index": 310003, "tx1_expiration": 10, "tx1_hash": "dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30", "tx1_index": 4}',0);
INSERT INTO messages VALUES(11,310004,'insert','credits','{"action": "btcpay", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310004, "event": "186f3db77952b50220f20fb875f65eb63064a9c73436dc4fc6a182e0a7e00d6d", "quantity": 100000000}',0);
INSERT INTO messages VALUES(12,310004,'update','order_matches','{"order_match_id": "2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df_dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30", "status": "completed"}',0);
INSERT INTO messages VALUES(13,310004,'insert','btcpays','{"block_index": 310004, "btc_amount": 50000000, "destination": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "order_match_id": "2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df_dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30", "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "tx_hash": "186f3db77952b50220f20fb875f65eb63064a9c73436dc4fc6a182e0a7e00d6d", "tx_index": 5}',0);
INSERT INTO messages VALUES(14,310005,'insert','debits','{"action": "issuance fee", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310005, "event": "91182e55e74dfc06bb108545f2aeb827cb812834b125d3c994bed56b291b5216", "quantity": 50000000}',0);
INSERT INTO messages VALUES(15,310005,'insert','issuances','{"asset": "BBBB", "block_index": 310005, "call_date": 0, "call_price": 0.0, "callable": false, "description": "", "divisible": true, "fee_paid": 50000000, "issuer": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "locked": false, "quantity": 1000000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "transfer": false, "tx_hash": "91182e55e74dfc06bb108545f2aeb827cb812834b125d3c994bed56b291b5216", "tx_index": 6}',0);
INSERT INTO messages VALUES(16,310005,'insert','credits','{"action": "issuance", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "BBBB", "block_index": 310005, "event": "91182e55e74dfc06bb108545f2aeb827cb812834b125d3c994bed56b291b5216", "quantity": 1000000000}',0);
INSERT INTO messages VALUES(17,310006,'insert','debits','{"action": "issuance fee", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310006, "event": "776fb4dc98d29b37b676ebf6b19dde4794a048af0e2830ff514920d6e57c10bb", "quantity": 50000000}',0);
INSERT INTO messages VALUES(18,310006,'insert','issuances','{"asset": "BBBC", "block_index": 310006, "call_date": 0, "call_price": 0.0, "callable": false, "description": "foobar", "divisible": false, "fee_paid": 50000000, "issuer": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "locked": false, "quantity": 100000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "transfer": false, "tx_hash": "776fb4dc98d29b37b676ebf6b19dde4794a048af0e2830ff514920d6e57c10bb", "tx_index": 7}',0);
INSERT INTO messages VALUES(19,310006,'insert','credits','{"action": "issuance", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "BBBC", "block_index": 310006, "event": "776fb4dc98d29b37b676ebf6b19dde4794a048af0e2830ff514920d6e57c10bb", "quantity": 100000}',0);
INSERT INTO messages VALUES(20,310007,'insert','debits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "BBBB", "block_index": 310007, "event": "f2c99a57c1d3eef60f76febcfb65a8f3bf25580fe95266d4b36abaa57514491c", "quantity": 4000000}',0);
INSERT INTO messages VALUES(21,310007,'insert','credits','{"action": "send", "address": "1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "BBBB", "block_index": 310007, "event": "f2c99a57c1d3eef60f76febcfb65a8f3bf25580fe95266d4b36abaa57514491c", "quantity": 4000000}',0);
INSERT INTO messages VALUES(22,310007,'insert','sends','{"asset": "BBBB", "block_index": 310007, "destination": "1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "quantity": 4000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "tx_hash": "f2c99a57c1d3eef60f76febcfb65a8f3bf25580fe95266d4b36abaa57514491c", "tx_index": 8}',0);
INSERT INTO messages VALUES(23,310008,'insert','debits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "BBBC", "block_index": 310008, "event": "7c450e1966a44985ee04628e29a238ce73d81e0b0c3d8cfcb9887839dbf89bea", "quantity": 526}',0);
INSERT INTO messages VALUES(24,310008,'insert','credits','{"action": "send", "address": "1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "BBBC", "block_index": 310008, "event": "7c450e1966a44985ee04628e29a238ce73d81e0b0c3d8cfcb9887839dbf89bea", "quantity": 526}',0);
INSERT INTO messages VALUES(25,310008,'insert','sends','{"asset": "BBBC", "block_index": 310008, "destination": "1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "quantity": 526, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "tx_hash": "7c450e1966a44985ee04628e29a238ce73d81e0b0c3d8cfcb9887839dbf89bea", "tx_index": 9}',0);
INSERT INTO messages VALUES(26,310009,'insert','debits','{"action": "dividend", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310009, "event": "2e28d83564e7a67f0b7e9c34653cd7e4ed9b063ce1cd5b102cbbed4001ad7241", "quantity": 24}',0);
INSERT INTO messages VALUES(27,310009,'insert','debits','{"action": "dividend fee", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310009, "event": "2e28d83564e7a67f0b7e9c34653cd7e4ed9b063ce1cd5b102cbbed4001ad7241", "quantity": 20000}',0);
INSERT INTO messages VALUES(28,310009,'insert','credits','{"action": "dividend", "address": "1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310009, "event": "2e28d83564e7a67f0b7e9c34653cd7e4ed9b063ce1cd5b102cbbed4001ad7241", "quantity": 24}',0);
INSERT INTO messages VALUES(29,310009,'insert','dividends','{"asset": "BBBB", "block_index": 310009, "dividend_asset": "XCP", "fee_paid": 20000, "quantity_per_unit": 600, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "tx_hash": "2e28d83564e7a67f0b7e9c34653cd7e4ed9b063ce1cd5b102cbbed4001ad7241", "tx_index": 10}',0);
INSERT INTO messages VALUES(30,310010,'insert','debits','{"action": "dividend", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310010, "event": "7d57cdc8d7a20c3938c82fb81bdf43878ee0d6f3a70a93098c9f339508abcde8", "quantity": 420800}',0);
INSERT INTO messages VALUES(31,310010,'insert','debits','{"action": "dividend fee", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310010, "event": "7d57cdc8d7a20c3938c82fb81bdf43878ee0d6f3a70a93098c9f339508abcde8", "quantity": 20000}',0);
INSERT INTO messages VALUES(32,310010,'insert','credits','{"action": "dividend", "address": "1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310010, "event": "7d57cdc8d7a20c3938c82fb81bdf43878ee0d6f3a70a93098c9f339508abcde8", "quantity": 420800}',0);
INSERT INTO messages VALUES(33,310010,'insert','dividends','{"asset": "BBBC", "block_index": 310010, "dividend_asset": "XCP", "fee_paid": 20000, "quantity_per_unit": 800, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "tx_hash": "7d57cdc8d7a20c3938c82fb81bdf43878ee0d6f3a70a93098c9f339508abcde8", "tx_index": 11}',0);
INSERT INTO messages VALUES(34,310011,'insert','broadcasts','{"block_index": 310011, "fee_fraction_int": 5000000, "locked": false, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "text": "Unit Test", "timestamp": 1388000000, "tx_hash": "41e035a66717c50429f2d8b1b90a7e73f15d4f84a0b32a77acb0f5a4356457b1", "tx_index": 12, "value": 100.0}',0);
INSERT INTO messages VALUES(35,310012,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310012, "event": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea", "quantity": 50000000}',0);
INSERT INTO messages VALUES(36,310012,'insert','bets','{"bet_type": 0, "block_index": 310012, "counterwager_quantity": 25000000, "counterwager_remaining": 25000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310022, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "leverage": 15120, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "open", "target_value": 0.0, "tx_hash": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea", "tx_index": 13, "wager_quantity": 50000000, "wager_remaining": 50000000}',0);
INSERT INTO messages VALUES(37,310013,'update','orders','{"status": "expired", "tx_hash": "2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df"}',0);
INSERT INTO messages VALUES(38,310013,'insert','order_expirations','{"block_index": 310013, "order_hash": "2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df", "order_index": 3, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2"}',0);
INSERT INTO messages VALUES(39,310013,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310013, "event": "f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a", "quantity": 25000000}',0);
INSERT INTO messages VALUES(40,310013,'insert','bets','{"bet_type": 1, "block_index": 310013, "counterwager_quantity": 41500000, "counterwager_remaining": 41500000, "deadline": 1388000100, "expiration": 10, "expire_index": 310023, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "leverage": 15120, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "open", "target_value": 0.0, "tx_hash": "f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a", "tx_index": 14, "wager_quantity": 25000000, "wager_remaining": 25000000}',0);
INSERT INTO messages VALUES(41,310013,'update','bets','{"counterwager_remaining": 4250000, "status": "open", "tx_hash": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea", "wager_remaining": 8500000}',0);
INSERT INTO messages VALUES(42,310013,'insert','credits','{"action": "filled", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310013, "event": "f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a", "quantity": 4250000}',0);
INSERT INTO messages VALUES(43,310013,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a", "wager_remaining": 4250000}',0);
INSERT INTO messages VALUES(44,310013,'insert','bet_matches','{"backward_quantity": 20750000, "block_index": 310013, "deadline": 1388000100, "fee_fraction_int": 5000000, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "forward_quantity": 41500000, "id": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea_f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a", "initial_value": 100.0, "leverage": 15120, "match_expire_index": 310022, "status": "pending", "target_value": 0.0, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "tx0_bet_type": 0, "tx0_block_index": 310012, "tx0_expiration": 10, "tx0_hash": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea", "tx0_index": 13, "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "tx1_bet_type": 1, "tx1_block_index": 310013, "tx1_expiration": 10, "tx1_hash": "f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a", "tx1_index": 14}',0);
INSERT INTO messages VALUES(45,310014,'update','orders','{"status": "expired", "tx_hash": "dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30"}',0);
INSERT INTO messages VALUES(46,310014,'insert','credits','{"action": "cancel order", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310014, "event": "dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30", "quantity": 5000000}',0);
INSERT INTO messages VALUES(47,310014,'insert','order_expirations','{"block_index": 310014, "order_hash": "dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30", "order_index": 4, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2"}',0);
INSERT INTO messages VALUES(48,310014,'insert','credits','{"action": "recredit forward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310014, "event": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea_f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a", "quantity": 41500000}',0);
INSERT INTO messages VALUES(49,310014,'insert','credits','{"action": "recredit backward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310014, "event": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea_f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a", "quantity": 20750000}',0);
INSERT INTO messages VALUES(50,310014,'update','bet_matches','{"bet_match_id": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea_f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a", "status": "expired"}',0);
INSERT INTO messages VALUES(51,310014,'insert','bet_match_expirations','{"bet_match_id": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea_f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a", "block_index": 310014, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2"}',0);
INSERT INTO messages VALUES(52,310014,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310014, "event": "fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e", "quantity": 150000000}',0);
INSERT INTO messages VALUES(53,310014,'insert','bets','{"bet_type": 0, "block_index": 310014, "counterwager_quantity": 350000000, "counterwager_remaining": 350000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310024, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "leverage": 5040, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "open", "target_value": 0.0, "tx_hash": "fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e", "tx_index": 15, "wager_quantity": 150000000, "wager_remaining": 150000000}',0);
INSERT INTO messages VALUES(54,310015,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310015, "event": "37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9", "quantity": 350000000}',0);
INSERT INTO messages VALUES(55,310015,'insert','bets','{"bet_type": 1, "block_index": 310015, "counterwager_quantity": 150000000, "counterwager_remaining": 150000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310025, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "leverage": 5040, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "open", "target_value": 0.0, "tx_hash": "37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9", "tx_index": 16, "wager_quantity": 350000000, "wager_remaining": 350000000}',0);
INSERT INTO messages VALUES(56,310015,'insert','credits','{"action": "filled", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310015, "event": "37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9", "quantity": 0}',0);
INSERT INTO messages VALUES(57,310015,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(58,310015,'insert','credits','{"action": "filled", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310015, "event": "37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9", "quantity": 0}',0);
INSERT INTO messages VALUES(59,310015,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(60,310015,'insert','bet_matches','{"backward_quantity": 350000000, "block_index": 310015, "deadline": 1388000100, "fee_fraction_int": 5000000, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "forward_quantity": 150000000, "id": "fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e_37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9", "initial_value": 100.0, "leverage": 5040, "match_expire_index": 310024, "status": "pending", "target_value": 0.0, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "tx0_bet_type": 0, "tx0_block_index": 310014, "tx0_expiration": 10, "tx0_hash": "fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e", "tx0_index": 15, "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "tx1_bet_type": 1, "tx1_block_index": 310015, "tx1_expiration": 10, "tx1_hash": "37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9", "tx1_index": 16}',0);
INSERT INTO messages VALUES(61,310016,'insert','credits','{"action": "recredit forward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310016, "event": "fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e_37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9", "quantity": 150000000}',0);
INSERT INTO messages VALUES(62,310016,'insert','credits','{"action": "recredit backward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310016, "event": "fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e_37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9", "quantity": 350000000}',0);
INSERT INTO messages VALUES(63,310016,'update','bet_matches','{"bet_match_id": "fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e_37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9", "status": "expired"}',0);
INSERT INTO messages VALUES(64,310016,'insert','bet_match_expirations','{"bet_match_id": "fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e_37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9", "block_index": 310016, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2"}',0);
INSERT INTO messages VALUES(65,310016,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310016, "event": "766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70", "quantity": 750000000}',0);
INSERT INTO messages VALUES(66,310016,'insert','bets','{"bet_type": 2, "block_index": 310016, "counterwager_quantity": 650000000, "counterwager_remaining": 650000000, "deadline": 1388000200, "expiration": 10, "expire_index": 310026, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "leverage": 5040, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "open", "target_value": 1.0, "tx_hash": "766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70", "tx_index": 17, "wager_quantity": 750000000, "wager_remaining": 750000000}',0);
INSERT INTO messages VALUES(67,310017,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310017, "event": "484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473", "quantity": 650000000}',0);
INSERT INTO messages VALUES(68,310017,'insert','bets','{"bet_type": 3, "block_index": 310017, "counterwager_quantity": 750000000, "counterwager_remaining": 750000000, "deadline": 1388000200, "expiration": 10, "expire_index": 310027, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "leverage": 5040, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "open", "target_value": 1.0, "tx_hash": "484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473", "tx_index": 18, "wager_quantity": 650000000, "wager_remaining": 650000000}',0);
INSERT INTO messages VALUES(69,310017,'insert','credits','{"action": "filled", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310017, "event": "484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473", "quantity": 0}',0);
INSERT INTO messages VALUES(70,310017,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(71,310017,'insert','credits','{"action": "filled", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310017, "event": "484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473", "quantity": 0}',0);
INSERT INTO messages VALUES(72,310017,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(73,310017,'insert','bet_matches','{"backward_quantity": 650000000, "block_index": 310017, "deadline": 1388000200, "fee_fraction_int": 5000000, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "forward_quantity": 750000000, "id": "766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70_484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473", "initial_value": 100.0, "leverage": 5040, "match_expire_index": 310026, "status": "pending", "target_value": 1.0, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "tx0_bet_type": 2, "tx0_block_index": 310016, "tx0_expiration": 10, "tx0_hash": "766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70", "tx0_index": 17, "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "tx1_bet_type": 3, "tx1_block_index": 310017, "tx1_expiration": 10, "tx1_hash": "484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473", "tx1_index": 18}',0);
INSERT INTO messages VALUES(74,310018,'insert','credits','{"action": "recredit forward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310018, "event": "766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70_484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473", "quantity": 750000000}',0);
INSERT INTO messages VALUES(75,310018,'insert','credits','{"action": "recredit backward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310018, "event": "766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70_484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473", "quantity": 650000000}',0);
INSERT INTO messages VALUES(76,310018,'update','bet_matches','{"bet_match_id": "766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70_484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473", "status": "expired"}',0);
INSERT INTO messages VALUES(77,310018,'insert','bet_match_expirations','{"bet_match_id": "766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70_484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473", "block_index": 310018, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2"}',0);
INSERT INTO messages VALUES(78,310018,'insert','broadcasts','{"block_index": 310018, "fee_fraction_int": 5000000, "locked": false, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "text": "Unit Test", "timestamp": 1388000050, "tx_hash": "981ca3efb6831e3b9f73438a1d83e06a2d66b730ef87f39668383edf7113eff4", "tx_index": 19, "value": 99.86166}',0);
INSERT INTO messages VALUES(79,310019,'insert','broadcasts','{"block_index": 310019, "fee_fraction_int": 5000000, "locked": false, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "text": "Unit Test", "timestamp": 1388000101, "tx_hash": "0bee8044e76f0be22bea66f32db1938bffae974e6239ed863635de63ac3aceb7", "tx_index": 20, "value": 100.343}',0);
INSERT INTO messages VALUES(80,310020,'insert','broadcasts','{"block_index": 310020, "fee_fraction_int": 5000000, "locked": false, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "text": "Unit Test", "timestamp": 1388000201, "tx_hash": "b3b2f17eaff6f686d2c0d7efba3fc03cbe5cd464426f96c0e88578ff800418e5", "tx_index": 21, "value": 2.0}',0);
INSERT INTO messages VALUES(81,310021,'insert','debits','{"action": "open order", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "BBBB", "block_index": 310021, "event": "e48c933f928db9b300c045ba33197bfb55cc12ebb6f00dfa9903039aa30bd7c0", "quantity": 50000000}',0);
INSERT INTO messages VALUES(82,310021,'insert','orders','{"block_index": 310021, "expiration": 10, "expire_index": 310031, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 50000000, "get_remaining": 50000000, "give_asset": "BBBB", "give_quantity": 50000000, "give_remaining": 50000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "open", "tx_hash": "e48c933f928db9b300c045ba33197bfb55cc12ebb6f00dfa9903039aa30bd7c0", "tx_index": 22}',0);
INSERT INTO messages VALUES(83,310022,'insert','credits','{"action": "burn", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310022, "event": "5d015bfc17193c05376698968fd0474269dc496f4ee1e7e989b91b6b7bd8fde1", "quantity": 56999887262}',0);
INSERT INTO messages VALUES(84,310022,'insert','burns','{"block_index": 310022, "burned": 38000000, "earned": 56999887262, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "tx_hash": "5d015bfc17193c05376698968fd0474269dc496f4ee1e7e989b91b6b7bd8fde1", "tx_index": 23}',0);
INSERT INTO messages VALUES(85,310023,'update','bets','{"status": "expired", "tx_hash": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea"}',0);
INSERT INTO messages VALUES(86,310023,'insert','credits','{"action": "recredit wager remaining", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310023, "event": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea", "quantity": 8500000}',0);
INSERT INTO messages VALUES(87,310023,'insert','bet_expirations','{"bet_hash": "4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea", "bet_index": 13, "block_index": 310023, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2"}',0);
INSERT INTO messages VALUES(88,310023,'insert','debits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "BBBC", "block_index": 310023, "event": "2cfbac01ae9a33a41fc062446bf8b08d85c6ca5082fb3ce9042f3e323999b88d", "quantity": 10000}',0);
INSERT INTO messages VALUES(89,310023,'insert','credits','{"action": "send", "address": "1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "BBBC", "block_index": 310023, "event": "2cfbac01ae9a33a41fc062446bf8b08d85c6ca5082fb3ce9042f3e323999b88d", "quantity": 10000}',0);
INSERT INTO messages VALUES(90,310023,'insert','sends','{"asset": "BBBC", "block_index": 310023, "destination": "1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "quantity": 10000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "status": "valid", "tx_hash": "2cfbac01ae9a33a41fc062446bf8b08d85c6ca5082fb3ce9042f3e323999b88d", "tx_index": 24}',0);
INSERT INTO messages VALUES(91,310032,'update','orders','{"status": "expired", "tx_hash": "e48c933f928db9b300c045ba33197bfb55cc12ebb6f00dfa9903039aa30bd7c0"}',0);
INSERT INTO messages VALUES(92,310032,'insert','credits','{"action": "cancel order", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "BBBB", "block_index": 310032, "event": "e48c933f928db9b300c045ba33197bfb55cc12ebb6f00dfa9903039aa30bd7c0", "quantity": 50000000}',0);
INSERT INTO messages VALUES(93,310032,'insert','order_expirations','{"block_index": 310032, "order_hash": "e48c933f928db9b300c045ba33197bfb55cc12ebb6f00dfa9903039aa30bd7c0", "order_index": 22, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2"}',0);
-- Triggers and indices on  messages
CREATE INDEX block_index_message_index_idx ON messages (block_index, message_index);

-- Table  nonces
DROP TABLE IF EXISTS nonces;
CREATE TABLE nonces(
                      address TEXT PRIMARY KEY,
                      nonce INTEGER);
-- Triggers and indices on  nonces
CREATE TRIGGER _nonces_delete BEFORE DELETE ON nonces BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO nonces(rowid,address,nonce) VALUES('||old.rowid||','||quote(old.address)||','||quote(old.nonce)||')');
                            END;
CREATE TRIGGER _nonces_insert AFTER INSERT ON nonces BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM nonces WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _nonces_update AFTER UPDATE ON nonces BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE nonces SET address='||quote(old.address)||',nonce='||quote(old.nonce)||' WHERE rowid='||old.rowid);
                            END;

-- Table  order_expirations
DROP TABLE IF EXISTS order_expirations;
CREATE TABLE order_expirations(
                      order_index INTEGER PRIMARY KEY,
                      order_hash TEXT UNIQUE,
                      source TEXT,
                      block_index INTEGER,
                      FOREIGN KEY (block_index) REFERENCES blocks(block_index),
                      FOREIGN KEY (order_index, order_hash) REFERENCES orders(tx_index, tx_hash));
INSERT INTO order_expirations VALUES(3,'2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',310013);
INSERT INTO order_expirations VALUES(4,'dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',310014);
INSERT INTO order_expirations VALUES(22,'e48c933f928db9b300c045ba33197bfb55cc12ebb6f00dfa9903039aa30bd7c0','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',310032);
-- Triggers and indices on  order_expirations
CREATE TRIGGER _order_expirations_delete BEFORE DELETE ON order_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO order_expirations(rowid,order_index,order_hash,source,block_index) VALUES('||old.rowid||','||quote(old.order_index)||','||quote(old.order_hash)||','||quote(old.source)||','||quote(old.block_index)||')');
                            END;
CREATE TRIGGER _order_expirations_insert AFTER INSERT ON order_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM order_expirations WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _order_expirations_update AFTER UPDATE ON order_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE order_expirations SET order_index='||quote(old.order_index)||',order_hash='||quote(old.order_hash)||',source='||quote(old.source)||',block_index='||quote(old.block_index)||' WHERE rowid='||old.rowid);
                            END;

-- Table  order_match_expirations
DROP TABLE IF EXISTS order_match_expirations;
CREATE TABLE order_match_expirations(
                      order_match_id TEXT PRIMARY KEY,
                      tx0_address TEXT,
                      tx1_address TEXT,
                      block_index INTEGER,
                      FOREIGN KEY (order_match_id) REFERENCES order_matches(id),
                      FOREIGN KEY (block_index) REFERENCES blocks(block_index));
-- Triggers and indices on  order_match_expirations
CREATE TRIGGER _order_match_expirations_delete BEFORE DELETE ON order_match_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO order_match_expirations(rowid,order_match_id,tx0_address,tx1_address,block_index) VALUES('||old.rowid||','||quote(old.order_match_id)||','||quote(old.tx0_address)||','||quote(old.tx1_address)||','||quote(old.block_index)||')');
                            END;
CREATE TRIGGER _order_match_expirations_insert AFTER INSERT ON order_match_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM order_match_expirations WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _order_match_expirations_update AFTER UPDATE ON order_match_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE order_match_expirations SET order_match_id='||quote(old.order_match_id)||',tx0_address='||quote(old.tx0_address)||',tx1_address='||quote(old.tx1_address)||',block_index='||quote(old.block_index)||' WHERE rowid='||old.rowid);
                            END;

-- Table  order_matches
DROP TABLE IF EXISTS order_matches;
CREATE TABLE order_matches(
                      id TEXT PRIMARY KEY,
                      tx0_index INTEGER,
                      tx0_hash TEXT,
                      tx0_address TEXT,
                      tx1_index INTEGER,
                      tx1_hash TEXT,
                      tx1_address TEXT,
                      forward_asset TEXT,
                      forward_quantity INTEGER,
                      backward_asset TEXT,
                      backward_quantity INTEGER,
                      tx0_block_index INTEGER,
                      tx1_block_index INTEGER,
                      block_index INTEGER,
                      tx0_expiration INTEGER,
                      tx1_expiration INTEGER,
                      match_expire_index INTEGER,
                      fee_paid INTEGER,
                      status TEXT,
                      FOREIGN KEY (tx0_index, tx0_hash, tx0_block_index) REFERENCES transactions(tx_index, tx_hash, block_index),
                      FOREIGN KEY (tx1_index, tx1_hash, tx1_block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
INSERT INTO order_matches VALUES('2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df_dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30',3,'2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',4,'dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BTC',50000000,'XCP',100000000,310002,310003,310003,10,10,310023,857142,'completed');
-- Triggers and indices on  order_matches
CREATE TRIGGER _order_matches_delete BEFORE DELETE ON order_matches BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO order_matches(rowid,id,tx0_index,tx0_hash,tx0_address,tx1_index,tx1_hash,tx1_address,forward_asset,forward_quantity,backward_asset,backward_quantity,tx0_block_index,tx1_block_index,block_index,tx0_expiration,tx1_expiration,match_expire_index,fee_paid,status) VALUES('||old.rowid||','||quote(old.id)||','||quote(old.tx0_index)||','||quote(old.tx0_hash)||','||quote(old.tx0_address)||','||quote(old.tx1_index)||','||quote(old.tx1_hash)||','||quote(old.tx1_address)||','||quote(old.forward_asset)||','||quote(old.forward_quantity)||','||quote(old.backward_asset)||','||quote(old.backward_quantity)||','||quote(old.tx0_block_index)||','||quote(old.tx1_block_index)||','||quote(old.block_index)||','||quote(old.tx0_expiration)||','||quote(old.tx1_expiration)||','||quote(old.match_expire_index)||','||quote(old.fee_paid)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _order_matches_insert AFTER INSERT ON order_matches BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM order_matches WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _order_matches_update AFTER UPDATE ON order_matches BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE order_matches SET id='||quote(old.id)||',tx0_index='||quote(old.tx0_index)||',tx0_hash='||quote(old.tx0_hash)||',tx0_address='||quote(old.tx0_address)||',tx1_index='||quote(old.tx1_index)||',tx1_hash='||quote(old.tx1_hash)||',tx1_address='||quote(old.tx1_address)||',forward_asset='||quote(old.forward_asset)||',forward_quantity='||quote(old.forward_quantity)||',backward_asset='||quote(old.backward_asset)||',backward_quantity='||quote(old.backward_quantity)||',tx0_block_index='||quote(old.tx0_block_index)||',tx1_block_index='||quote(old.tx1_block_index)||',block_index='||quote(old.block_index)||',tx0_expiration='||quote(old.tx0_expiration)||',tx1_expiration='||quote(old.tx1_expiration)||',match_expire_index='||quote(old.match_expire_index)||',fee_paid='||quote(old.fee_paid)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX backward_status_idx ON order_matches (backward_asset, status);
CREATE INDEX forward_status_idx ON order_matches (forward_asset, status);
CREATE INDEX match_expire_idx ON order_matches (status, match_expire_index);
CREATE INDEX tx0_address_idx ON order_matches (tx0_address);
CREATE INDEX tx1_address_idx ON order_matches (tx1_address);

-- Table  orders
DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
                      tx_index INTEGER UNIQUE,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      give_asset TEXT,
                      give_quantity INTEGER,
                      give_remaining INTEGER,
                      get_asset TEXT,
                      get_quantity INTEGER,
                      get_remaining INTEGER,
                      expiration INTEGER,
                      expire_index INTEGER,
                      fee_required INTEGER,
                      fee_required_remaining INTEGER,
                      fee_provided INTEGER,
                      fee_provided_remaining INTEGER,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index),
                      PRIMARY KEY (tx_index, tx_hash));
INSERT INTO orders VALUES(3,'2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df',310002,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BTC',50000000,0,'XCP',100000000,0,10,310012,0,0,1000000,142858,'expired');
INSERT INTO orders VALUES(4,'dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30',310003,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',105000000,5000000,'BTC',50000000,0,10,310013,900000,42858,10000,10000,'expired');
INSERT INTO orders VALUES(22,'e48c933f928db9b300c045ba33197bfb55cc12ebb6f00dfa9903039aa30bd7c0',310021,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBB',50000000,50000000,'XCP',50000000,50000000,10,310031,0,0,10000,10000,'expired');
-- Triggers and indices on  orders
CREATE TRIGGER _orders_delete BEFORE DELETE ON orders BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO orders(rowid,tx_index,tx_hash,block_index,source,give_asset,give_quantity,give_remaining,get_asset,get_quantity,get_remaining,expiration,expire_index,fee_required,fee_required_remaining,fee_provided,fee_provided_remaining,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.give_asset)||','||quote(old.give_quantity)||','||quote(old.give_remaining)||','||quote(old.get_asset)||','||quote(old.get_quantity)||','||quote(old.get_remaining)||','||quote(old.expiration)||','||quote(old.expire_index)||','||quote(old.fee_required)||','||quote(old.fee_required_remaining)||','||quote(old.fee_provided)||','||quote(old.fee_provided_remaining)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _orders_insert AFTER INSERT ON orders BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM orders WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _orders_update AFTER UPDATE ON orders BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE orders SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',give_asset='||quote(old.give_asset)||',give_quantity='||quote(old.give_quantity)||',give_remaining='||quote(old.give_remaining)||',get_asset='||quote(old.get_asset)||',get_quantity='||quote(old.get_quantity)||',get_remaining='||quote(old.get_remaining)||',expiration='||quote(old.expiration)||',expire_index='||quote(old.expire_index)||',fee_required='||quote(old.fee_required)||',fee_required_remaining='||quote(old.fee_required_remaining)||',fee_provided='||quote(old.fee_provided)||',fee_provided_remaining='||quote(old.fee_provided_remaining)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX expire_idx ON orders (expire_index, status);
CREATE INDEX give_asset_idx ON orders (give_asset);
CREATE INDEX give_get_status_idx ON orders (get_asset, give_asset, status);
CREATE INDEX give_status_idx ON orders (give_asset, status);
CREATE INDEX source_give_status_idx ON orders (source, give_asset, status);

-- Table  poll_votes
DROP TABLE IF EXISTS poll_votes;
CREATE TABLE poll_votes(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      votename TEXT,
                      option TEXT,
                      vote INTEGER UNSIGNED,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
-- Triggers and indices on  poll_votes
CREATE TRIGGER _poll_votes_delete BEFORE DELETE ON poll_votes BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO poll_votes(rowid,tx_index,tx_hash,block_index,source,votename,option,vote) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.votename)||','||quote(old.option)||','||quote(old.vote)||')');
                            END;
CREATE TRIGGER _poll_votes_insert AFTER INSERT ON poll_votes BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM poll_votes WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _poll_votes_update AFTER UPDATE ON poll_votes BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE poll_votes SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',votename='||quote(old.votename)||',option='||quote(old.option)||',vote='||quote(old.vote)||' WHERE rowid='||old.rowid);
                            END;

-- Table  polls
DROP TABLE IF EXISTS polls;
CREATE TABLE polls(
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
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
-- Triggers and indices on  polls
CREATE TRIGGER _polls_delete BEFORE DELETE ON polls BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO polls(rowid,tx_index,tx_hash,block_index,source,votename,stake_block_index,asset,deadline_ts,deadline_block_index,status,options) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.votename)||','||quote(old.stake_block_index)||','||quote(old.asset)||','||quote(old.deadline_ts)||','||quote(old.deadline_block_index)||','||quote(old.status)||','||quote(old.options)||')');
                            END;
CREATE TRIGGER _polls_insert AFTER INSERT ON polls BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM polls WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _polls_update AFTER UPDATE ON polls BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE polls SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',votename='||quote(old.votename)||',stake_block_index='||quote(old.stake_block_index)||',asset='||quote(old.asset)||',deadline_ts='||quote(old.deadline_ts)||',deadline_block_index='||quote(old.deadline_block_index)||',status='||quote(old.status)||',options='||quote(old.options)||' WHERE rowid='||old.rowid);
                            END;

-- Table  postqueue
DROP TABLE IF EXISTS postqueue;
CREATE TABLE postqueue(
                      message BLOB);
-- Triggers and indices on  postqueue
CREATE TRIGGER _postqueue_delete BEFORE DELETE ON postqueue BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO postqueue(rowid,message) VALUES('||old.rowid||','||quote(old.message)||')');
                            END;
CREATE TRIGGER _postqueue_insert AFTER INSERT ON postqueue BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM postqueue WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _postqueue_update AFTER UPDATE ON postqueue BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE postqueue SET message='||quote(old.message)||' WHERE rowid='||old.rowid);
                            END;

-- Table  rps
DROP TABLE IF EXISTS rps;
CREATE TABLE rps(
                      tx_index INTEGER UNIQUE,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      possible_moves INTEGER,
                      wager INTEGER,
                      move_random_hash TEXT,
                      expiration INTEGER,
                      expire_index INTEGER,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index),
                      PRIMARY KEY (tx_index, tx_hash));
-- Triggers and indices on  rps
CREATE TRIGGER _rps_delete BEFORE DELETE ON rps BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO rps(rowid,tx_index,tx_hash,block_index,source,possible_moves,wager,move_random_hash,expiration,expire_index,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.possible_moves)||','||quote(old.wager)||','||quote(old.move_random_hash)||','||quote(old.expiration)||','||quote(old.expire_index)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _rps_insert AFTER INSERT ON rps BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM rps WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _rps_update AFTER UPDATE ON rps BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE rps SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',possible_moves='||quote(old.possible_moves)||',wager='||quote(old.wager)||',move_random_hash='||quote(old.move_random_hash)||',expiration='||quote(old.expiration)||',expire_index='||quote(old.expire_index)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX matching_idx ON rps (wager, possible_moves);

-- Table  rps_expirations
DROP TABLE IF EXISTS rps_expirations;
CREATE TABLE rps_expirations(
                      rps_index INTEGER PRIMARY KEY,
                      rps_hash TEXT UNIQUE,
                      source TEXT,
                      block_index INTEGER,
                      FOREIGN KEY (block_index) REFERENCES blocks(block_index),
                      FOREIGN KEY (rps_index, rps_hash) REFERENCES rps(tx_index, tx_hash));
-- Triggers and indices on  rps_expirations
CREATE TRIGGER _rps_expirations_delete BEFORE DELETE ON rps_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO rps_expirations(rowid,rps_index,rps_hash,source,block_index) VALUES('||old.rowid||','||quote(old.rps_index)||','||quote(old.rps_hash)||','||quote(old.source)||','||quote(old.block_index)||')');
                            END;
CREATE TRIGGER _rps_expirations_insert AFTER INSERT ON rps_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM rps_expirations WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _rps_expirations_update AFTER UPDATE ON rps_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE rps_expirations SET rps_index='||quote(old.rps_index)||',rps_hash='||quote(old.rps_hash)||',source='||quote(old.source)||',block_index='||quote(old.block_index)||' WHERE rowid='||old.rowid);
                            END;

-- Table  rps_match_expirations
DROP TABLE IF EXISTS rps_match_expirations;
CREATE TABLE rps_match_expirations(
                      rps_match_id TEXT PRIMARY KEY,
                      tx0_address TEXT,
                      tx1_address TEXT,
                      block_index INTEGER,
                      FOREIGN KEY (rps_match_id) REFERENCES rps_matches(id),
                      FOREIGN KEY (block_index) REFERENCES blocks(block_index));
-- Triggers and indices on  rps_match_expirations
CREATE TRIGGER _rps_match_expirations_delete BEFORE DELETE ON rps_match_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO rps_match_expirations(rowid,rps_match_id,tx0_address,tx1_address,block_index) VALUES('||old.rowid||','||quote(old.rps_match_id)||','||quote(old.tx0_address)||','||quote(old.tx1_address)||','||quote(old.block_index)||')');
                            END;
CREATE TRIGGER _rps_match_expirations_insert AFTER INSERT ON rps_match_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM rps_match_expirations WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _rps_match_expirations_update AFTER UPDATE ON rps_match_expirations BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE rps_match_expirations SET rps_match_id='||quote(old.rps_match_id)||',tx0_address='||quote(old.tx0_address)||',tx1_address='||quote(old.tx1_address)||',block_index='||quote(old.block_index)||' WHERE rowid='||old.rowid);
                            END;

-- Table  rps_matches
DROP TABLE IF EXISTS rps_matches;
CREATE TABLE rps_matches(
                      id TEXT PRIMARY KEY,
                      tx0_index INTEGER,
                      tx0_hash TEXT,
                      tx0_address TEXT,
                      tx1_index INTEGER,
                      tx1_hash TEXT,
                      tx1_address TEXT,
                      tx0_move_random_hash TEXT,
                      tx1_move_random_hash TEXT,
                      wager INTEGER,
                      possible_moves INTEGER,
                      tx0_block_index INTEGER,
                      tx1_block_index INTEGER,
                      block_index INTEGER,
                      tx0_expiration INTEGER,
                      tx1_expiration INTEGER,
                      match_expire_index INTEGER,
                      status TEXT,
                      FOREIGN KEY (tx0_index, tx0_hash, tx0_block_index) REFERENCES transactions(tx_index, tx_hash, block_index),
                      FOREIGN KEY (tx1_index, tx1_hash, tx1_block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
-- Triggers and indices on  rps_matches
CREATE TRIGGER _rps_matches_delete BEFORE DELETE ON rps_matches BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO rps_matches(rowid,id,tx0_index,tx0_hash,tx0_address,tx1_index,tx1_hash,tx1_address,tx0_move_random_hash,tx1_move_random_hash,wager,possible_moves,tx0_block_index,tx1_block_index,block_index,tx0_expiration,tx1_expiration,match_expire_index,status) VALUES('||old.rowid||','||quote(old.id)||','||quote(old.tx0_index)||','||quote(old.tx0_hash)||','||quote(old.tx0_address)||','||quote(old.tx1_index)||','||quote(old.tx1_hash)||','||quote(old.tx1_address)||','||quote(old.tx0_move_random_hash)||','||quote(old.tx1_move_random_hash)||','||quote(old.wager)||','||quote(old.possible_moves)||','||quote(old.tx0_block_index)||','||quote(old.tx1_block_index)||','||quote(old.block_index)||','||quote(old.tx0_expiration)||','||quote(old.tx1_expiration)||','||quote(old.match_expire_index)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _rps_matches_insert AFTER INSERT ON rps_matches BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM rps_matches WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _rps_matches_update AFTER UPDATE ON rps_matches BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE rps_matches SET id='||quote(old.id)||',tx0_index='||quote(old.tx0_index)||',tx0_hash='||quote(old.tx0_hash)||',tx0_address='||quote(old.tx0_address)||',tx1_index='||quote(old.tx1_index)||',tx1_hash='||quote(old.tx1_hash)||',tx1_address='||quote(old.tx1_address)||',tx0_move_random_hash='||quote(old.tx0_move_random_hash)||',tx1_move_random_hash='||quote(old.tx1_move_random_hash)||',wager='||quote(old.wager)||',possible_moves='||quote(old.possible_moves)||',tx0_block_index='||quote(old.tx0_block_index)||',tx1_block_index='||quote(old.tx1_block_index)||',block_index='||quote(old.block_index)||',tx0_expiration='||quote(old.tx0_expiration)||',tx1_expiration='||quote(old.tx1_expiration)||',match_expire_index='||quote(old.match_expire_index)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX rps_match_expire_idx ON rps_matches (status, match_expire_index);
CREATE INDEX rps_tx0_address_idx ON rps_matches (tx0_address);
CREATE INDEX rps_tx1_address_idx ON rps_matches (tx1_address);

-- Table  rpsresolves
DROP TABLE IF EXISTS rpsresolves;
CREATE TABLE rpsresolves(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      move INTEGER,
                      random TEXT,
                      rps_match_id TEXT,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
-- Triggers and indices on  rpsresolves
CREATE TRIGGER _rpsresolves_delete BEFORE DELETE ON rpsresolves BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO rpsresolves(rowid,tx_index,tx_hash,block_index,source,move,random,rps_match_id,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.move)||','||quote(old.random)||','||quote(old.rps_match_id)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _rpsresolves_insert AFTER INSERT ON rpsresolves BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM rpsresolves WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _rpsresolves_update AFTER UPDATE ON rpsresolves BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE rpsresolves SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',move='||quote(old.move)||',random='||quote(old.random)||',rps_match_id='||quote(old.rps_match_id)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX rps_match_id_idx ON rpsresolves (rps_match_id);

-- Table  sends
DROP TABLE IF EXISTS sends;
CREATE TABLE sends(
                      tx_index INTEGER PRIMARY KEY,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      source TEXT,
                      destination TEXT,
                      asset TEXT,
                      quantity INTEGER,
                      status TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
INSERT INTO sends VALUES(2,'625d8e59a9342ac6dd2f3d32ec9f9f56d3b8a8ed194afcbd5be6f04192669269',310001,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',50000000,'valid');
INSERT INTO sends VALUES(8,'f2c99a57c1d3eef60f76febcfb65a8f3bf25580fe95266d4b36abaa57514491c',310007,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBB',4000000,'valid');
INSERT INTO sends VALUES(9,'7c450e1966a44985ee04628e29a238ce73d81e0b0c3d8cfcb9887839dbf89bea',310008,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBC',526,'valid');
INSERT INTO sends VALUES(24,'2cfbac01ae9a33a41fc062446bf8b08d85c6ca5082fb3ce9042f3e323999b88d',310023,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','BBBC',10000,'valid');
-- Triggers and indices on  sends
CREATE TRIGGER _sends_delete BEFORE DELETE ON sends BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO sends(rowid,tx_index,tx_hash,block_index,source,destination,asset,quantity,status) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.destination)||','||quote(old.asset)||','||quote(old.quantity)||','||quote(old.status)||')');
                            END;
CREATE TRIGGER _sends_insert AFTER INSERT ON sends BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM sends WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _sends_update AFTER UPDATE ON sends BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE sends SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',destination='||quote(old.destination)||',asset='||quote(old.asset)||',quantity='||quote(old.quantity)||',status='||quote(old.status)||' WHERE rowid='||old.rowid);
                            END;
CREATE INDEX destination_idx ON sends (destination);
CREATE INDEX source_idx ON sends (source);

-- Table  storage
DROP TABLE IF EXISTS storage;
CREATE TABLE storage(
                      contract_id TEXT,
                      key BLOB,
                      value BLOB,
                      FOREIGN KEY (contract_id) REFERENCES contracts(contract_id));
-- Triggers and indices on  storage
CREATE TRIGGER _storage_delete BEFORE DELETE ON storage BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO storage(rowid,contract_id,key,value) VALUES('||old.rowid||','||quote(old.contract_id)||','||quote(old.key)||','||quote(old.value)||')');
                            END;
CREATE TRIGGER _storage_insert AFTER INSERT ON storage BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM storage WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _storage_update AFTER UPDATE ON storage BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE storage SET contract_id='||quote(old.contract_id)||',key='||quote(old.key)||',value='||quote(old.value)||' WHERE rowid='||old.rowid);
                            END;

-- Table  suicides
DROP TABLE IF EXISTS suicides;
CREATE TABLE suicides(
                      contract_id TEXT PRIMARY KEY,
                      FOREIGN KEY (contract_id) REFERENCES contracts(contract_id));
-- Triggers and indices on  suicides
CREATE TRIGGER _suicides_delete BEFORE DELETE ON suicides BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO suicides(rowid,contract_id) VALUES('||old.rowid||','||quote(old.contract_id)||')');
                            END;
CREATE TRIGGER _suicides_insert AFTER INSERT ON suicides BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM suicides WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _suicides_update AFTER UPDATE ON suicides BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE suicides SET contract_id='||quote(old.contract_id)||' WHERE rowid='||old.rowid);
                            END;

-- Table  transactions
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions(
                      tx_index INTEGER UNIQUE,
                      tx_hash TEXT UNIQUE,
                      block_index INTEGER,
                      block_hash TEXT,
                      block_time INTEGER,
                      source TEXT,
                      destination TEXT,
                      btc_amount INTEGER,
                      fee INTEGER,
                      data BLOB,
                      supported BOOL DEFAULT 1,
                      FOREIGN KEY (block_index, block_hash) REFERENCES blocks(block_index, block_hash),
                      PRIMARY KEY (tx_index, tx_hash, block_index));
INSERT INTO transactions VALUES(1,'1b8787f4111f7dd95d56168e3ada0a36c9ac88bb86908b9f921e33d12bd88a37',310000,'505d8d82c4ced7daddef7ed0b05ba12ecc664176887b938ef56c6af276f3b30c',1419700000,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,10000,X'',1);
INSERT INTO transactions VALUES(2,'625d8e59a9342ac6dd2f3d32ec9f9f56d3b8a8ed194afcbd5be6f04192669269',310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',1419700100,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'0000000000000000000000010000000002FAF080',1);
INSERT INTO transactions VALUES(3,'2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df',310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',1419700200,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','',0,1000000,X'0000000A00000000000000000000000002FAF08000000000000000010000000005F5E100000A0000000000000000',1);
INSERT INTO transactions VALUES(4,'dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30',310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',1419700300,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','',0,10000,X'0000000A00000000000000010000000006422C4000000000000000000000000002FAF080000A00000000000DBBA0',1);
INSERT INTO transactions VALUES(5,'186f3db77952b50220f20fb875f65eb63064a9c73436dc4fc6a182e0a7e00d6d',310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',1419700400,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',50000000,10000,X'0000000B2593E61DFF78D2397647BFA9C14C7B17B23B2BB1B446BDE8DD23F537B56870DFDDA95FB9E4CCADC9E511622585FF74889C8F76DD572F9B40BB5AF1242B1E6F30',1);
INSERT INTO transactions VALUES(6,'91182e55e74dfc06bb108545f2aeb827cb812834b125d3c994bed56b291b5216',310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',1419700500,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','',0,10000,X'000000140000000000004767000000003B9ACA000100000000000000000000',1);
INSERT INTO transactions VALUES(7,'776fb4dc98d29b37b676ebf6b19dde4794a048af0e2830ff514920d6e57c10bb',310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',1419700600,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','',0,10000,X'00000014000000000000476800000000000186A00000000000000000000006666F6F626172',1);
INSERT INTO transactions VALUES(8,'f2c99a57c1d3eef60f76febcfb65a8f3bf25580fe95266d4b36abaa57514491c',310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',1419700700,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'00000000000000000000476700000000003D0900',1);
INSERT INTO transactions VALUES(9,'7c450e1966a44985ee04628e29a238ce73d81e0b0c3d8cfcb9887839dbf89bea',310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',1419700800,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'000000000000000000004768000000000000020E',1);
INSERT INTO transactions VALUES(10,'2e28d83564e7a67f0b7e9c34653cd7e4ed9b063ce1cd5b102cbbed4001ad7241',310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',1419700900,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','',0,10000,X'00000032000000000000025800000000000047670000000000000001',1);
INSERT INTO transactions VALUES(11,'7d57cdc8d7a20c3938c82fb81bdf43878ee0d6f3a70a93098c9f339508abcde8',310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',1419701000,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','',0,10000,X'00000032000000000000032000000000000047680000000000000001',1);
INSERT INTO transactions VALUES(12,'41e035a66717c50429f2d8b1b90a7e73f15d4f84a0b32a77acb0f5a4356457b1',310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',1419701100,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','',0,10000,X'0000001E52BB33004059000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(13,'4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea',310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',1419701200,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'00000028000052BB33640000000002FAF08000000000017D7840000000000000000000003B100000000A',1);
INSERT INTO transactions VALUES(14,'f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a',310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',1419701300,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'00000028000152BB336400000000017D78400000000002793D60000000000000000000003B100000000A',1);
INSERT INTO transactions VALUES(15,'fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e',310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',1419701400,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'00000028000052BB33640000000008F0D1800000000014DC93800000000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(16,'37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9',310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',1419701500,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'00000028000152BB33640000000014DC93800000000008F0D1800000000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(17,'766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70',310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',1419701600,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'00000028000252BB33C8000000002CB417800000000026BE36803FF0000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(18,'484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473',310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',1419701700,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'00000028000352BB33C80000000026BE3680000000002CB417803FF0000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(19,'981ca3efb6831e3b9f73438a1d83e06a2d66b730ef87f39668383edf7113eff4',310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',1419701800,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','',0,10000,X'0000001E52BB33324058F7256FFC115E004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(20,'0bee8044e76f0be22bea66f32db1938bffae974e6239ed863635de63ac3aceb7',310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',1419701900,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','',0,10000,X'0000001E52BB3365405915F3B645A1CB004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(21,'b3b2f17eaff6f686d2c0d7efba3fc03cbe5cd464426f96c0e88578ff800418e5',310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',1419702000,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','',0,10000,X'0000001E52BB33C94000000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(22,'e48c933f928db9b300c045ba33197bfb55cc12ebb6f00dfa9903039aa30bd7c0',310021,'7c2460bb32c5749c856486393239bf7a0ac789587ac71f32e7237910da8097f2',1419702100,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','',0,10000,X'0000000A00000000000047670000000002FAF08000000000000000010000000002FAF080000A0000000000000000',1);
INSERT INTO transactions VALUES(23,'5d015bfc17193c05376698968fd0474269dc496f4ee1e7e989b91b6b7bd8fde1',310022,'44435f9a99a0aa12a9bfabdc4cb8119f6ea6a6e1350d2d65445fb66a456db5fc',1419702200,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','mvCounterpartyXXXXXXXXXXXXXXW24Hef',100000000,10000,X'',1);
INSERT INTO transactions VALUES(24,'2cfbac01ae9a33a41fc062446bf8b08d85c6ca5082fb3ce9042f3e323999b88d',310023,'d8cf5bec1bbcab8ca4f495352afde3b6572b7e1d61b3976872ebb8e9d30ccb08',1419702300,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'0000000000000000000047680000000000002710',1);
-- Triggers and indices on  transactions
CREATE INDEX index_hash_index_idx ON transactions (tx_index, tx_hash, block_index);
CREATE INDEX index_index_idx ON transactions (block_index, tx_index);
CREATE INDEX tx_hash_idx ON transactions (tx_hash);
CREATE INDEX tx_index_idx ON transactions (tx_index);

-- Table  undolog
DROP TABLE IF EXISTS undolog;
CREATE TABLE undolog(
                        undo_index INTEGER PRIMARY KEY AUTOINCREMENT,
                        sql TEXT);
INSERT INTO undolog VALUES(4,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=93000000000 WHERE rowid=1');
INSERT INTO undolog VALUES(5,'DELETE FROM debits WHERE rowid=1');
INSERT INTO undolog VALUES(6,'DELETE FROM balances WHERE rowid=2');
INSERT INTO undolog VALUES(7,'DELETE FROM credits WHERE rowid=2');
INSERT INTO undolog VALUES(8,'DELETE FROM sends WHERE rowid=2');
INSERT INTO undolog VALUES(9,'DELETE FROM orders WHERE rowid=1');
INSERT INTO undolog VALUES(10,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92950000000 WHERE rowid=1');
INSERT INTO undolog VALUES(11,'DELETE FROM debits WHERE rowid=2');
INSERT INTO undolog VALUES(12,'DELETE FROM orders WHERE rowid=2');
INSERT INTO undolog VALUES(13,'UPDATE orders SET tx_index=3,tx_hash=''2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df'',block_index=310002,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',give_asset=''BTC'',give_quantity=50000000,give_remaining=50000000,get_asset=''XCP'',get_quantity=100000000,get_remaining=100000000,expiration=10,expire_index=310012,fee_required=0,fee_required_remaining=0,fee_provided=1000000,fee_provided_remaining=1000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(14,'UPDATE orders SET tx_index=4,tx_hash=''dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30'',block_index=310003,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',give_asset=''XCP'',give_quantity=105000000,give_remaining=105000000,get_asset=''BTC'',get_quantity=50000000,get_remaining=50000000,expiration=10,expire_index=310013,fee_required=900000,fee_required_remaining=900000,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(15,'DELETE FROM order_matches WHERE rowid=1');
INSERT INTO undolog VALUES(16,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92845000000 WHERE rowid=1');
INSERT INTO undolog VALUES(17,'DELETE FROM credits WHERE rowid=3');
INSERT INTO undolog VALUES(18,'UPDATE order_matches SET id=''2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df_dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30'',tx0_index=3,tx0_hash=''2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df'',tx0_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',tx1_index=4,tx1_hash=''dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30'',tx1_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',forward_asset=''BTC'',forward_quantity=50000000,backward_asset=''XCP'',backward_quantity=100000000,tx0_block_index=310002,tx1_block_index=310003,block_index=310003,tx0_expiration=10,tx1_expiration=10,match_expire_index=310023,fee_paid=857142,status=''pending'' WHERE rowid=1');
INSERT INTO undolog VALUES(19,'DELETE FROM btcpays WHERE rowid=5');
INSERT INTO undolog VALUES(20,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92945000000 WHERE rowid=1');
INSERT INTO undolog VALUES(21,'DELETE FROM debits WHERE rowid=3');
INSERT INTO undolog VALUES(22,'DELETE FROM assets WHERE rowid=3');
INSERT INTO undolog VALUES(23,'DELETE FROM issuances WHERE rowid=6');
INSERT INTO undolog VALUES(24,'DELETE FROM balances WHERE rowid=3');
INSERT INTO undolog VALUES(25,'DELETE FROM credits WHERE rowid=4');
INSERT INTO undolog VALUES(26,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92895000000 WHERE rowid=1');
INSERT INTO undolog VALUES(27,'DELETE FROM debits WHERE rowid=4');
INSERT INTO undolog VALUES(28,'DELETE FROM assets WHERE rowid=4');
INSERT INTO undolog VALUES(29,'DELETE FROM issuances WHERE rowid=7');
INSERT INTO undolog VALUES(30,'DELETE FROM balances WHERE rowid=4');
INSERT INTO undolog VALUES(31,'DELETE FROM credits WHERE rowid=5');
INSERT INTO undolog VALUES(32,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''BBBB'',quantity=1000000000 WHERE rowid=3');
INSERT INTO undolog VALUES(33,'DELETE FROM debits WHERE rowid=5');
INSERT INTO undolog VALUES(34,'DELETE FROM balances WHERE rowid=5');
INSERT INTO undolog VALUES(35,'DELETE FROM credits WHERE rowid=6');
INSERT INTO undolog VALUES(36,'DELETE FROM sends WHERE rowid=8');
INSERT INTO undolog VALUES(37,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''BBBC'',quantity=100000 WHERE rowid=4');
INSERT INTO undolog VALUES(38,'DELETE FROM debits WHERE rowid=6');
INSERT INTO undolog VALUES(39,'DELETE FROM balances WHERE rowid=6');
INSERT INTO undolog VALUES(40,'DELETE FROM credits WHERE rowid=7');
INSERT INTO undolog VALUES(41,'DELETE FROM sends WHERE rowid=9');
INSERT INTO undolog VALUES(42,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92845000000 WHERE rowid=1');
INSERT INTO undolog VALUES(43,'DELETE FROM debits WHERE rowid=7');
INSERT INTO undolog VALUES(44,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92844999976 WHERE rowid=1');
INSERT INTO undolog VALUES(45,'DELETE FROM debits WHERE rowid=8');
INSERT INTO undolog VALUES(46,'UPDATE balances SET address=''1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=50000000 WHERE rowid=2');
INSERT INTO undolog VALUES(47,'DELETE FROM credits WHERE rowid=8');
INSERT INTO undolog VALUES(48,'DELETE FROM dividends WHERE rowid=10');
INSERT INTO undolog VALUES(49,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92844979976 WHERE rowid=1');
INSERT INTO undolog VALUES(50,'DELETE FROM debits WHERE rowid=9');
INSERT INTO undolog VALUES(51,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92844559176 WHERE rowid=1');
INSERT INTO undolog VALUES(52,'DELETE FROM debits WHERE rowid=10');
INSERT INTO undolog VALUES(53,'UPDATE balances SET address=''1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=50000024 WHERE rowid=2');
INSERT INTO undolog VALUES(54,'DELETE FROM credits WHERE rowid=9');
INSERT INTO undolog VALUES(55,'DELETE FROM dividends WHERE rowid=11');
INSERT INTO undolog VALUES(56,'DELETE FROM broadcasts WHERE rowid=12');
INSERT INTO undolog VALUES(57,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92844539176 WHERE rowid=1');
INSERT INTO undolog VALUES(58,'DELETE FROM debits WHERE rowid=11');
INSERT INTO undolog VALUES(59,'DELETE FROM bets WHERE rowid=1');
INSERT INTO undolog VALUES(60,'UPDATE orders SET tx_index=3,tx_hash=''2593e61dff78d2397647bfa9c14c7b17b23b2bb1b446bde8dd23f537b56870df'',block_index=310002,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',give_asset=''BTC'',give_quantity=50000000,give_remaining=0,get_asset=''XCP'',get_quantity=100000000,get_remaining=0,expiration=10,expire_index=310012,fee_required=0,fee_required_remaining=0,fee_provided=1000000,fee_provided_remaining=142858,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(61,'DELETE FROM order_expirations WHERE rowid=3');
INSERT INTO undolog VALUES(62,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92794539176 WHERE rowid=1');
INSERT INTO undolog VALUES(63,'DELETE FROM debits WHERE rowid=12');
INSERT INTO undolog VALUES(64,'DELETE FROM bets WHERE rowid=2');
INSERT INTO undolog VALUES(65,'UPDATE bets SET tx_index=13,tx_hash=''4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea'',block_index=310012,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',bet_type=0,deadline=1388000100,wager_quantity=50000000,wager_remaining=50000000,counterwager_quantity=25000000,counterwager_remaining=25000000,target_value=0.0,leverage=15120,expiration=10,expire_index=310022,fee_fraction_int=5000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(66,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92769539176 WHERE rowid=1');
INSERT INTO undolog VALUES(67,'DELETE FROM credits WHERE rowid=10');
INSERT INTO undolog VALUES(68,'UPDATE bets SET tx_index=14,tx_hash=''f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a'',block_index=310013,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',bet_type=1,deadline=1388000100,wager_quantity=25000000,wager_remaining=25000000,counterwager_quantity=41500000,counterwager_remaining=41500000,target_value=0.0,leverage=15120,expiration=10,expire_index=310023,fee_fraction_int=5000000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(69,'DELETE FROM bet_matches WHERE rowid=1');
INSERT INTO undolog VALUES(70,'UPDATE orders SET tx_index=4,tx_hash=''dda95fb9e4ccadc9e511622585ff74889c8f76dd572f9b40bb5af1242b1e6f30'',block_index=310003,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',give_asset=''XCP'',give_quantity=105000000,give_remaining=5000000,get_asset=''BTC'',get_quantity=50000000,get_remaining=0,expiration=10,expire_index=310013,fee_required=900000,fee_required_remaining=42858,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(71,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92773789176 WHERE rowid=1');
INSERT INTO undolog VALUES(72,'DELETE FROM credits WHERE rowid=11');
INSERT INTO undolog VALUES(73,'DELETE FROM order_expirations WHERE rowid=4');
INSERT INTO undolog VALUES(74,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92778789176 WHERE rowid=1');
INSERT INTO undolog VALUES(75,'DELETE FROM credits WHERE rowid=12');
INSERT INTO undolog VALUES(76,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92820289176 WHERE rowid=1');
INSERT INTO undolog VALUES(77,'DELETE FROM credits WHERE rowid=13');
INSERT INTO undolog VALUES(78,'UPDATE bet_matches SET id=''4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea_f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a'',tx0_index=13,tx0_hash=''4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea'',tx0_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',tx1_index=14,tx1_hash=''f04a820f062566f1990fcf46f4ee2e6bbbc287e281375de2c816576862e16b0a'',tx1_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',tx0_bet_type=0,tx1_bet_type=1,feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',initial_value=100,deadline=1388000100,target_value=0.0,leverage=15120,forward_quantity=41500000,backward_quantity=20750000,tx0_block_index=310012,tx1_block_index=310013,block_index=310013,tx0_expiration=10,tx1_expiration=10,match_expire_index=310022,fee_fraction_int=5000000,status=''pending'' WHERE rowid=1');
INSERT INTO undolog VALUES(79,'DELETE FROM bet_match_expirations WHERE rowid=1');
INSERT INTO undolog VALUES(80,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(81,'DELETE FROM debits WHERE rowid=13');
INSERT INTO undolog VALUES(82,'DELETE FROM bets WHERE rowid=3');
INSERT INTO undolog VALUES(83,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92691039176 WHERE rowid=1');
INSERT INTO undolog VALUES(84,'DELETE FROM debits WHERE rowid=14');
INSERT INTO undolog VALUES(85,'DELETE FROM bets WHERE rowid=4');
INSERT INTO undolog VALUES(86,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(87,'DELETE FROM credits WHERE rowid=14');
INSERT INTO undolog VALUES(88,'UPDATE bets SET tx_index=15,tx_hash=''fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e'',block_index=310014,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',bet_type=0,deadline=1388000100,wager_quantity=150000000,wager_remaining=150000000,counterwager_quantity=350000000,counterwager_remaining=350000000,target_value=0.0,leverage=5040,expiration=10,expire_index=310024,fee_fraction_int=5000000,status=''open'' WHERE rowid=3');
INSERT INTO undolog VALUES(89,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(90,'DELETE FROM credits WHERE rowid=15');
INSERT INTO undolog VALUES(91,'UPDATE bets SET tx_index=16,tx_hash=''37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9'',block_index=310015,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',bet_type=1,deadline=1388000100,wager_quantity=350000000,wager_remaining=350000000,counterwager_quantity=150000000,counterwager_remaining=150000000,target_value=0.0,leverage=5040,expiration=10,expire_index=310025,fee_fraction_int=5000000,status=''open'' WHERE rowid=4');
INSERT INTO undolog VALUES(92,'DELETE FROM bet_matches WHERE rowid=2');
INSERT INTO undolog VALUES(93,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(94,'DELETE FROM credits WHERE rowid=16');
INSERT INTO undolog VALUES(95,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92491039176 WHERE rowid=1');
INSERT INTO undolog VALUES(96,'DELETE FROM credits WHERE rowid=17');
INSERT INTO undolog VALUES(97,'UPDATE bet_matches SET id=''fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e_37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9'',tx0_index=15,tx0_hash=''fbde9d64afd3d06f574b781dd01124fb63914494f516e7505c158e839a38006e'',tx0_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',tx1_index=16,tx1_hash=''37a6cd57ea0d3510c605a07c7c13dd7c65969bad764a8f394d06ab170ddb53c9'',tx1_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',tx0_bet_type=0,tx1_bet_type=1,feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',initial_value=100,deadline=1388000100,target_value=0.0,leverage=5040,forward_quantity=150000000,backward_quantity=350000000,tx0_block_index=310014,tx1_block_index=310015,block_index=310015,tx0_expiration=10,tx1_expiration=10,match_expire_index=310024,fee_fraction_int=5000000,status=''pending'' WHERE rowid=2');
INSERT INTO undolog VALUES(98,'DELETE FROM bet_match_expirations WHERE rowid=2');
INSERT INTO undolog VALUES(99,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(100,'DELETE FROM debits WHERE rowid=15');
INSERT INTO undolog VALUES(101,'DELETE FROM bets WHERE rowid=5');
INSERT INTO undolog VALUES(102,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92091039176 WHERE rowid=1');
INSERT INTO undolog VALUES(103,'DELETE FROM debits WHERE rowid=16');
INSERT INTO undolog VALUES(104,'DELETE FROM bets WHERE rowid=6');
INSERT INTO undolog VALUES(105,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(106,'DELETE FROM credits WHERE rowid=18');
INSERT INTO undolog VALUES(107,'UPDATE bets SET tx_index=17,tx_hash=''766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70'',block_index=310016,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',bet_type=2,deadline=1388000200,wager_quantity=750000000,wager_remaining=750000000,counterwager_quantity=650000000,counterwager_remaining=650000000,target_value=1.0,leverage=5040,expiration=10,expire_index=310026,fee_fraction_int=5000000,status=''open'' WHERE rowid=5');
INSERT INTO undolog VALUES(108,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(109,'DELETE FROM credits WHERE rowid=19');
INSERT INTO undolog VALUES(110,'UPDATE bets SET tx_index=18,tx_hash=''484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473'',block_index=310017,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',bet_type=3,deadline=1388000200,wager_quantity=650000000,wager_remaining=650000000,counterwager_quantity=750000000,counterwager_remaining=750000000,target_value=1.0,leverage=5040,expiration=10,expire_index=310027,fee_fraction_int=5000000,status=''open'' WHERE rowid=6');
INSERT INTO undolog VALUES(111,'DELETE FROM bet_matches WHERE rowid=3');
INSERT INTO undolog VALUES(112,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(113,'DELETE FROM credits WHERE rowid=20');
INSERT INTO undolog VALUES(114,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92191039176 WHERE rowid=1');
INSERT INTO undolog VALUES(115,'DELETE FROM credits WHERE rowid=21');
INSERT INTO undolog VALUES(116,'UPDATE bet_matches SET id=''766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70_484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473'',tx0_index=17,tx0_hash=''766f83995b009b0d4a912b233489231fd23e6232c4c1f2caaafa3c5c1a5cae70'',tx0_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',tx1_index=18,tx1_hash=''484194c207ccc7e72b0232c23d32e20635295198d98553017974849c7c36b473'',tx1_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',tx0_bet_type=2,tx1_bet_type=3,feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',initial_value=100,deadline=1388000200,target_value=1.0,leverage=5040,forward_quantity=750000000,backward_quantity=650000000,tx0_block_index=310016,tx1_block_index=310017,block_index=310017,tx0_expiration=10,tx1_expiration=10,match_expire_index=310026,fee_fraction_int=5000000,status=''pending'' WHERE rowid=3');
INSERT INTO undolog VALUES(117,'DELETE FROM bet_match_expirations WHERE rowid=3');
INSERT INTO undolog VALUES(118,'DELETE FROM broadcasts WHERE rowid=19');
INSERT INTO undolog VALUES(119,'DELETE FROM broadcasts WHERE rowid=20');
INSERT INTO undolog VALUES(120,'DELETE FROM broadcasts WHERE rowid=21');
INSERT INTO undolog VALUES(121,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''BBBB'',quantity=996000000 WHERE rowid=3');
INSERT INTO undolog VALUES(122,'DELETE FROM debits WHERE rowid=17');
INSERT INTO undolog VALUES(123,'DELETE FROM orders WHERE rowid=3');
INSERT INTO undolog VALUES(124,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(125,'DELETE FROM credits WHERE rowid=22');
INSERT INTO undolog VALUES(126,'DELETE FROM burns WHERE rowid=23');
INSERT INTO undolog VALUES(127,'UPDATE bets SET tx_index=13,tx_hash=''4c601826f72f2613c1b2c90e8e649981c005d4d895ae3bb5852ef3489ba6c2ea'',block_index=310012,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',bet_type=0,deadline=1388000100,wager_quantity=50000000,wager_remaining=8500000,counterwager_quantity=25000000,counterwager_remaining=4250000,target_value=0.0,leverage=15120,expiration=10,expire_index=310022,fee_fraction_int=5000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(128,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''XCP'',quantity=149840926438 WHERE rowid=1');
INSERT INTO undolog VALUES(129,'DELETE FROM credits WHERE rowid=23');
INSERT INTO undolog VALUES(130,'DELETE FROM bet_expirations WHERE rowid=13');
INSERT INTO undolog VALUES(131,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''BBBC'',quantity=99474 WHERE rowid=4');
INSERT INTO undolog VALUES(132,'DELETE FROM debits WHERE rowid=18');
INSERT INTO undolog VALUES(133,'UPDATE balances SET address=''1_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''BBBC'',quantity=526 WHERE rowid=6');
INSERT INTO undolog VALUES(134,'DELETE FROM credits WHERE rowid=24');
INSERT INTO undolog VALUES(135,'DELETE FROM sends WHERE rowid=24');
INSERT INTO undolog VALUES(136,'UPDATE orders SET tx_index=22,tx_hash=''e48c933f928db9b300c045ba33197bfb55cc12ebb6f00dfa9903039aa30bd7c0'',block_index=310021,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',give_asset=''BBBB'',give_quantity=50000000,give_remaining=50000000,get_asset=''XCP'',get_quantity=50000000,get_remaining=50000000,expiration=10,expire_index=310031,fee_required=0,fee_required_remaining=0,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=3');
INSERT INTO undolog VALUES(137,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2'',asset=''BBBB'',quantity=946000000 WHERE rowid=3');
INSERT INTO undolog VALUES(138,'DELETE FROM credits WHERE rowid=25');
INSERT INTO undolog VALUES(139,'DELETE FROM order_expirations WHERE rowid=22');

-- Table  undolog_block
DROP TABLE IF EXISTS undolog_block;
CREATE TABLE undolog_block(
                        block_index INTEGER PRIMARY KEY,
                        first_undo_index INTEGER);
INSERT INTO undolog_block VALUES(310001,4);
INSERT INTO undolog_block VALUES(310002,9);
INSERT INTO undolog_block VALUES(310003,10);
INSERT INTO undolog_block VALUES(310004,16);
INSERT INTO undolog_block VALUES(310005,20);
INSERT INTO undolog_block VALUES(310006,26);
INSERT INTO undolog_block VALUES(310007,32);
INSERT INTO undolog_block VALUES(310008,37);
INSERT INTO undolog_block VALUES(310009,42);
INSERT INTO undolog_block VALUES(310010,49);
INSERT INTO undolog_block VALUES(310011,56);
INSERT INTO undolog_block VALUES(310012,57);
INSERT INTO undolog_block VALUES(310013,60);
INSERT INTO undolog_block VALUES(310014,70);
INSERT INTO undolog_block VALUES(310015,83);
INSERT INTO undolog_block VALUES(310016,93);
INSERT INTO undolog_block VALUES(310017,102);
INSERT INTO undolog_block VALUES(310018,112);
INSERT INTO undolog_block VALUES(310019,119);
INSERT INTO undolog_block VALUES(310020,120);
INSERT INTO undolog_block VALUES(310021,121);
INSERT INTO undolog_block VALUES(310022,124);
INSERT INTO undolog_block VALUES(310023,127);
INSERT INTO undolog_block VALUES(310024,136);
INSERT INTO undolog_block VALUES(310025,136);
INSERT INTO undolog_block VALUES(310026,136);
INSERT INTO undolog_block VALUES(310027,136);
INSERT INTO undolog_block VALUES(310028,136);
INSERT INTO undolog_block VALUES(310029,136);
INSERT INTO undolog_block VALUES(310030,136);
INSERT INTO undolog_block VALUES(310031,136);
INSERT INTO undolog_block VALUES(310032,136);
INSERT INTO undolog_block VALUES(310033,140);
INSERT INTO undolog_block VALUES(310034,140);
INSERT INTO undolog_block VALUES(310035,140);
INSERT INTO undolog_block VALUES(310036,140);
INSERT INTO undolog_block VALUES(310037,140);
INSERT INTO undolog_block VALUES(310038,140);
INSERT INTO undolog_block VALUES(310039,140);
INSERT INTO undolog_block VALUES(310040,140);
INSERT INTO undolog_block VALUES(310041,140);
INSERT INTO undolog_block VALUES(310042,140);
INSERT INTO undolog_block VALUES(310043,140);
INSERT INTO undolog_block VALUES(310044,140);
INSERT INTO undolog_block VALUES(310045,140);
INSERT INTO undolog_block VALUES(310046,140);
INSERT INTO undolog_block VALUES(310047,140);
INSERT INTO undolog_block VALUES(310048,140);
INSERT INTO undolog_block VALUES(310049,140);
INSERT INTO undolog_block VALUES(310050,140);
INSERT INTO undolog_block VALUES(310051,140);
INSERT INTO undolog_block VALUES(310052,140);
INSERT INTO undolog_block VALUES(310053,140);
INSERT INTO undolog_block VALUES(310054,140);
INSERT INTO undolog_block VALUES(310055,140);
INSERT INTO undolog_block VALUES(310056,140);
INSERT INTO undolog_block VALUES(310057,140);
INSERT INTO undolog_block VALUES(310058,140);
INSERT INTO undolog_block VALUES(310059,140);
INSERT INTO undolog_block VALUES(310060,140);
INSERT INTO undolog_block VALUES(310061,140);
INSERT INTO undolog_block VALUES(310062,140);
INSERT INTO undolog_block VALUES(310063,140);
INSERT INTO undolog_block VALUES(310064,140);
INSERT INTO undolog_block VALUES(310065,140);
INSERT INTO undolog_block VALUES(310066,140);
INSERT INTO undolog_block VALUES(310067,140);
INSERT INTO undolog_block VALUES(310068,140);
INSERT INTO undolog_block VALUES(310069,140);
INSERT INTO undolog_block VALUES(310070,140);
INSERT INTO undolog_block VALUES(310071,140);
INSERT INTO undolog_block VALUES(310072,140);
INSERT INTO undolog_block VALUES(310073,140);
INSERT INTO undolog_block VALUES(310074,140);
INSERT INTO undolog_block VALUES(310075,140);
INSERT INTO undolog_block VALUES(310076,140);
INSERT INTO undolog_block VALUES(310077,140);
INSERT INTO undolog_block VALUES(310078,140);
INSERT INTO undolog_block VALUES(310079,140);
INSERT INTO undolog_block VALUES(310080,140);
INSERT INTO undolog_block VALUES(310081,140);
INSERT INTO undolog_block VALUES(310082,140);
INSERT INTO undolog_block VALUES(310083,140);
INSERT INTO undolog_block VALUES(310084,140);
INSERT INTO undolog_block VALUES(310085,140);
INSERT INTO undolog_block VALUES(310086,140);
INSERT INTO undolog_block VALUES(310087,140);
INSERT INTO undolog_block VALUES(310088,140);
INSERT INTO undolog_block VALUES(310089,140);
INSERT INTO undolog_block VALUES(310090,140);
INSERT INTO undolog_block VALUES(310091,140);
INSERT INTO undolog_block VALUES(310092,140);
INSERT INTO undolog_block VALUES(310093,140);
INSERT INTO undolog_block VALUES(310094,140);
INSERT INTO undolog_block VALUES(310095,140);
INSERT INTO undolog_block VALUES(310096,140);
INSERT INTO undolog_block VALUES(310097,140);
INSERT INTO undolog_block VALUES(310098,140);
INSERT INTO undolog_block VALUES(310099,140);
INSERT INTO undolog_block VALUES(310100,140);
INSERT INTO undolog_block VALUES(310101,140);

-- For primary key autoincrements the next id to use is stored in
-- sqlite_sequence
DELETE FROM main.sqlite_sequence WHERE name='undolog';
INSERT INTO main.sqlite_sequence VALUES ('undolog', 139);

COMMIT TRANSACTION;
