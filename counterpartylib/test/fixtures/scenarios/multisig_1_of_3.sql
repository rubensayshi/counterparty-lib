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
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',149849426438);
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','XCP',50420824);
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',996000000);
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBC',89474);
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBB',4000000);
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBC',10526);
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
INSERT INTO bet_expirations VALUES(13,'0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310023);
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
INSERT INTO bet_match_expirations VALUES('0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a_64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310014);
INSERT INTO bet_match_expirations VALUES('11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d_c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310016);
INSERT INTO bet_match_expirations VALUES('274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9_f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310018);
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
INSERT INTO bet_matches VALUES('0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a_64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78',13,'0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',14,'64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,1,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',100,1388000100,0.0,15120,41500000,20750000,310012,310013,310013,10,10,310022,5000000,'expired');
INSERT INTO bet_matches VALUES('11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d_c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460',15,'11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',16,'c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,1,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',100,1388000100,0.0,5040,150000000,350000000,310014,310015,310015,10,10,310024,5000000,'expired');
INSERT INTO bet_matches VALUES('274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9_f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c',17,'274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',18,'f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',2,3,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',100,1388000200,1.0,5040,750000000,650000000,310016,310017,310017,10,10,310026,5000000,'expired');
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
INSERT INTO bets VALUES(13,'0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a',310012,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,1388000100,50000000,8500000,25000000,4250000,0.0,15120,10,310022,5000000,'expired');
INSERT INTO bets VALUES(14,'64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78',310013,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1,1388000100,25000000,4250000,41500000,0,0.0,15120,10,310023,5000000,'filled');
INSERT INTO bets VALUES(15,'11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d',310014,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,1388000100,150000000,0,350000000,0,0.0,5040,10,310024,5000000,'filled');
INSERT INTO bets VALUES(16,'c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460',310015,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1,1388000100,350000000,0,150000000,0,0.0,5040,10,310025,5000000,'filled');
INSERT INTO bets VALUES(17,'274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9',310016,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',2,1388000200,750000000,0,650000000,0,1.0,5040,10,310026,5000000,'filled');
INSERT INTO bets VALUES(18,'f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c',310017,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',3,1388000200,650000000,0,750000000,0,1.0,5040,10,310027,5000000,'filled');
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
INSERT INTO blocks VALUES(310000,'505d8d82c4ced7daddef7ed0b05ba12ecc664176887b938ef56c6af276f3b30c',1419700000,NULL,NULL,'9611bac1511391e69f998bbe61eaf2fec6749a5481bf33de1f638d4a4e06d4b1','4331245e342208cde9ac24ba15325fc9d75cb53cbcc35e65889a0ba5b226d6fb','3a27aa1784c4b389d484731bf1267f29a01a9e94743ffb71b46b652679b0144b');
INSERT INTO blocks VALUES(310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',1419700100,NULL,NULL,'23524e060dbe4d711aaf134eb2d381058d5c0963570c20787c59758681ecd753','5ca63a3b39edda748fe913e3d03e321bce4dac933554a8cd653990d7701a7f5b','f5a85f05be81975a8e38ae33598e194e4d4dcc19df72e13f08e08b2d7086ec25');
INSERT INTO blocks VALUES(310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',1419700200,NULL,NULL,'b3a45d96698854a73573d427ed4c322eed452637f5c0431120ee8b7b1f4754a2','58a830c43c59bd3b6a66101ada6ce9daecedeeeea6b35a9f7e0f0a9277812900','60c617e2b14d8cefbc17ac4d53fb6ffcc27654ee294017e055a29504b6de8ec3');
INSERT INTO blocks VALUES(310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',1419700300,NULL,NULL,'58e27edf809cf3864846a039b043482f678894d73030a620b1d65cad0d766c39','148c81d0df1f00f516fd50e78bc8d12fc37fdb4c1bda24cb74e8a09bff199625','c4ce1a5e6a1ca73f595dbe04483745f3547f26f45af24fed732c0416d624778c');
INSERT INTO blocks VALUES(310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',1419700400,NULL,NULL,'42012a290ac4e1a97b5633c5a6014218137b707f2b63ebe81d0f74bcff20ca7a','1275c619bba085c2d4b801a0781b294d7b61eeb5463e27479cd553ed40ca11cf','6f95f0a65a6eb059c800709660b251cc7afae8d0b5368e27eea8cd1ea1402ec0');
INSERT INTO blocks VALUES(310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',1419700500,NULL,NULL,'f481d2d378ae3440908fd72a1d1d2c468a6bfca8dab161990045009bae7f4bd2','5534bc630bf0b458465413dfce910ae25b1d6a6905dfe79e543604d2d3556dde','220bef557dbe53d7fbc52a1319fd5ad3464a878480df2d3b2aa41bb0e8eb993e');
INSERT INTO blocks VALUES(310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',1419700600,NULL,NULL,'58e65382e4d9ea76674cabbfcc6bec4e3f88923af94e76346bdbcdc07d8668ce','72f9f5b1b9b25a2c0e34ce879397c9afa28818f65b294f89c9c6e4074dfb60d9','f49a8ee731e95a499af33cf0f3f6be61058eb2daa8fd094ccb0ec5c42f528269');
INSERT INTO blocks VALUES(310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',1419700700,NULL,NULL,'a4f7291590768dc34e35aa4109a435a80a7f821fbc7dad771be17ab775066897','4ff4499b846d9ebd0c4d2f2fb352a160eb787d64201ae4d8ec30b15208b80888','0708569819572aa27483f881d26f0dcdfa257903e4162a43594b4d48ac359c2a');
INSERT INTO blocks VALUES(310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',1419700800,NULL,NULL,'bb78ed412d1e527de42e89c6b3a1c6795d6901ca62dab3f78a69d0d2543cdef5','c9403f61715f14fe4c1358a939083ca64009cbe454faa02923a14cb61228521a','0a88c6ef14914ab234d82720a51db649e902bb5af76a0e564dd737912270a194');
INSERT INTO blocks VALUES(310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',1419700900,NULL,NULL,'ad57f9d61033363fb8ec7b80da6d7f5fa62f9bb2ca7946b5be027655ec8d4aaa','c9660bd00f8a2095aa19f1596879e37b766d0869fda8319a115bfa1eb2b8b212','23f517cb983e63133fa3bf2317ccd0db3a95f3ad63a69ff451d42a1b748632f3');
INSERT INTO blocks VALUES(310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',1419701000,NULL,NULL,'701b80f153fd468f3f6a8d4ae3b7e19540cbba0c21852dff620778e2fe7ac573','291e802def33b958d8ea68f8e4ce142567ffa97041c04c1e83dd59fee6f26409','da84d38e16f57c4521acc5e8a0485cc39175d1d4bd90a96767c3e7df8f6d2ea5');
INSERT INTO blocks VALUES(310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',1419701100,NULL,NULL,'93838d263cdb4644efa4416574d6d1c73d982355cbeb6fc1cd7c479c820f1573','a5e2b4164777134f3a2f55e02fcab5916b2d9239c82d88c6a57682135c52be11','1066bf2949251ad5cdd1a135d35185c2a6fffc317c1ba639ccc4d65b802557fc');
INSERT INTO blocks VALUES(310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',1419701200,NULL,NULL,'46a79c04cf497af049ffb91bed9cb8b5d3371597ed4620a827795eb7e4764691','bbf272b57651a9fbd096d50863d36ca38e2cb81cca5c4257f3551b50f202015c','15a1a47bd68494d4305987fa841cd61e2347610db8e91e8cc999dfae1ec338c1');
INSERT INTO blocks VALUES(310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',1419701300,NULL,NULL,'62c9f063f31c474f01a568865efc0d1e58cd2fc0d9ca908e57802c4436a19756','a86b8f88dda719e37e012e66991690b6ffec73add66bdc48a6fe9c9285bb0902','a1cf343b16da113c87aae17de663518056ece5f7fbc005a7c3b38f028cb02e19');
INSERT INTO blocks VALUES(310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',1419701400,NULL,NULL,'abe195d3e19ef498ac989442af935442d1c538c1812b4ce10aa2dd4f6d3415e2','93e2b02aa7c783a824e8262ff7ce0414265b600f14cbeaa989876dfda0423752','d1f70963ecac920865ab5fe2abbefa0c6d3b9e69239fe14d2400df2b5c84aa0f');
INSERT INTO blocks VALUES(310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',1419701500,NULL,NULL,'5a2b9e1a87420b440eeead5456f437a29cc83904baf49d2b7b4211726833335c','b08888a867cb2b26f57adeefa1b148e87dc037b2a826fd2dd163f82a24232fd7','e5f7c9a53cca043eb39fa111aa5a0a07f7d2638c69c0ee1323d2a30769d72fbd');
INSERT INTO blocks VALUES(310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',1419701600,NULL,NULL,'25eaeba33a612cf526583c2ae15e8190a2bab31646e2b8082319b9c27b1eb67e','db962f0a37abe1303a004e9b80fadde734c0280b38376a844532b157f7cd0383','17f4381a2b1c5e57fbc8d454c45b759f301c3aea333945ba2dcb4a9e508f44c8');
INSERT INTO blocks VALUES(310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',1419701700,NULL,NULL,'2d026730368aeb12cd9af22ada0eb44c63616b43f392552f847208540c668a0e','7e3d451339ae992d81a248185d57e6049d1e123fd63bec760ecf48bb0a7bc218','35c0c655f481bc86dad35718618e10bbbbc3c28a0d54657a7dd8c1b404c1e905');
INSERT INTO blocks VALUES(310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',1419701800,NULL,NULL,'2195800165fc49fc797b89e35eb4e4f765ee90e21c7244c330e93a2aa5bb5f86','ae65efbf4e832121f58e781123a0c1eff7796de244f8074e84817be1d7f16343','7c083e4ab9f145f403a433b00867b9f8be17a2f14d6cd6422c5ca2cbb707fb79');
INSERT INTO blocks VALUES(310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',1419701900,NULL,NULL,'6af0980e4f46588e8be4bb33b518fe0aa9c5805e073f8a3aa48169ac2df3a27c','68183dd33cbe3767d04ae88536722925d33e53ad09c61b851617a13761f7498f','6a1b237f022f778250975c0c67c2cbb4d25de0cd14beb70ae251d145f666a6d9');
INSERT INTO blocks VALUES(310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',1419702000,NULL,NULL,'95f9cc333a952e1da10947e8d787ec933f023580b5e73f417446436eb6c9a993','16f80dc817d14e08bb420b2ea44ab1225fa285f8c10bab073a7771e8f0cb3450','7359ae10f07d88369f8ed9022e1ade408ac1a089edd78e678174b7fe296e1de1');
INSERT INTO blocks VALUES(310021,'7c2460bb32c5749c856486393239bf7a0ac789587ac71f32e7237910da8097f2',1419702100,NULL,NULL,'d598fca9d01ee94135041dc7bcb6330215d6855fc97d27ef7aa74f4c86b45a84','7d3158b8917bc405f07a10b98aa257b664ca264803d5e8a793611747a36f2cc1','3743ae7aebddf1f7250b3f04e782e3312f3249f7facf64e1c65e462465687919');
INSERT INTO blocks VALUES(310022,'44435f9a99a0aa12a9bfabdc4cb8119f6ea6a6e1350d2d65445fb66a456db5fc',1419702200,NULL,NULL,'597564749315edacc921dbe5a92621fb6d7859191e29b910a5014d1ac81e9cec','3574c284449d0e3d3ee0f127a125910768813bbc61a4468f75eda041e94e3a3e','be1a52529653ef2103b5745cd4109d8936deadc362a26a12f19323d2b60269d7');
INSERT INTO blocks VALUES(310023,'d8cf5bec1bbcab8ca4f495352afde3b6572b7e1d61b3976872ebb8e9d30ccb08',1419702300,NULL,NULL,'11e497648b02a63bf25b3379be6c9f92d4c5cba2fd707a337eebcc4abf97e1fb','7e9ad00a9f343b4f63f2dff16eb06c6972892b125bf781c57e0897f50110d050','86644e66872955f07fad369e4012e5d40bcc492748174c826433b0bd687165a2');
INSERT INTO blocks VALUES(310024,'b03042b4e18a222b4c8d1e9e1970d93e6e2a2d41686d227ff8ecf0a839223dc5',1419702400,NULL,NULL,'430b5a6a53273b9af5756db1576089a458d780aaaf2452d69ebb1fc336760e46','4b9a797694b324700f5886a4c0e55af1c6616cc40ebdc3116208b94df20374b8','e763e9e0dc8e13272a084b1701df49f99933f1b6d3c26386fc91562176e002db');
INSERT INTO blocks VALUES(310025,'a872e560766832cc3b4f7f222228cb6db882ce3c54f6459f62c71d5cd6e90666',1419702500,NULL,NULL,'727aebb27c0b24abcc960373ab1cb12af4d181767cd448e639756cef01e1d1a2','336c220327fcc707fa2f9a1ac554c5e04dbc5df0cc598e8900b1b77648ca51e1','80db09cb1931d1b6b29561175c1b6e718a72e2831668097ae123a3b87e267120');
INSERT INTO blocks VALUES(310026,'6c96350f6f2f05810f19a689de235eff975338587194a36a70dfd0fcd490941a',1419702600,NULL,NULL,'a4d0c82a01010366214f885903bff80573eeb37cae61988ff34a6a8ed8b6093f','d725cc1a86746b32882f16fc196e4d0c5cd244a15f581778ddb8eceb007c2d71','b18c7eae0ce30595de246b1acfa6758166bf3afcca7055a24b587e505a381221');
INSERT INTO blocks VALUES(310027,'d7acfac66df393c4482a14c189742c0571b89442eb7f817b34415a560445699e',1419702700,NULL,NULL,'e342537993cc57fbabba7d746ad2e6dc34a2e5183cffd102c034a57c93b24133','d1ea582d8901967870797090286b1809712cac1efe1e87000350c848ef8b7512','35c9610d9c299303bd5b93eb16e21ef65a3d014f322e092b3e7068e139589ff3');
INSERT INTO blocks VALUES(310028,'02409fcf8fa06dafcb7f11e38593181d9c42cc9d5e2ddc304d098f990bd9530b',1419702800,NULL,NULL,'8fd102a879613f6a5397cfb59c1a5b97de3c11994fac6d196dbae6cff9a9a0dd','f213fcf84466204d7ae1bab05ed923d380e554774a96fb80c29a4297c867a1e0','9b0bbe2cc58617e9a9852e80d1d4b9d671009e0101ed3475ef59bb32145021ad');
INSERT INTO blocks VALUES(310029,'3c739fa8b40c118d5547ea356ee8d10ee2898871907643ec02e5db9d00f03cc6',1419702900,NULL,NULL,'9df365ce16a2752fabecdd59e100fa53fd5802079ffe466e5a393e9bfac88ee5','080e1abec98015951496faff8eb69dc79807e85a83f4550451d2cf7f07afe192','a3b2832ccb0e98b9b6d79cf881657c211d357c88b1dbf2d32914b4ad95229d4a');
INSERT INTO blocks VALUES(310030,'d5071cddedf89765ee0fd58f209c1c7d669ba8ea66200a57587da8b189b9e4f5',1419703000,NULL,NULL,'01effeb08ebdb811e46ea9cb3d96414779c6995bae5ad644e085a09b14783caf','ae7baab6cdbed55153d80c9b7458e97053cd5efa6e30efebd6a3b9743d8693de','2f0f89f6119787317452c5ee293830f1488618df8ddee4aeebf7aad3b332b706');
INSERT INTO blocks VALUES(310031,'0b02b10f41380fff27c543ea8891ecb845bf7a003ac5c87e15932aff3bfcf689',1419703100,NULL,NULL,'2c7e0be4f858001f9d0d8e8856080c6edf2c828833c5b97be3bd816950ec4468','cb060dbd054987bac751a5bca2a93750e62868ea737dbe360d6aebefddbf86aa','acd5422c22feeb83e94a2f7ebc328f9554e7a100c47999b07aeeca183f21b7d2');
INSERT INTO blocks VALUES(310032,'66346be81e6ba04544f2ae643b76c2b7b1383f038fc2636e02e49dc7ec144074',1419703200,NULL,NULL,'bb7cf37cf5940239eb8d92a3b0befacff139f7524e9e9924c4a31e169a198b4b','064e815ed7fa6c9d7d7ddfb842644b18a96a6a1bf868207a984ee43f6dd7d3e5','6072f931d9e920ee641c49e62dd1b0fcab36153d6cbf9e1be2117f494f8c81e9');
INSERT INTO blocks VALUES(310033,'999c65df9661f73e8c01f1da1afda09ac16788b72834f0ff5ea3d1464afb4707',1419703300,NULL,NULL,'5efe10b35508428734a317d27082c6348b4dc19645fa8c1471279ec03c263690','2343c3941dc3293c441537f9c28205338c91de10be1da2648069921a5d86fd44','d62540faf815544e29058c03fced621ce64483dba63cba474f36b658ed7047ab');
INSERT INTO blocks VALUES(310034,'f552edd2e0a648230f3668e72ddf0ddfb1e8ac0f4c190f91b89c1a8c2e357208',1419703400,NULL,NULL,'a73b2d34363e47244752674051d14c321ed6b6e8bb32699dd2e69cbb40f8738f','6c96f9ac9ec380541e1ce628fb55df66d37bae59cd5587a9dc6dabd84d9a51d6','0a479a9797c7246b6ee7746ee031f0fed94d4c1a2b02d2558bfd2f46ad789f6e');
INSERT INTO blocks VALUES(310035,'a13cbb016f3044207a46967a4ba1c87dab411f78c55c1179f2336653c2726ae2',1419703500,NULL,NULL,'cf669d160c4e4315442be49dae924b071e484701f6bb69cca9f1ec9b5e3307e9','8922bd38b6c25cdcc4d336c97b2eab66adeb37ae9a3d508f564ec4276652f2c8','86d052873cf6339cf65f3221c67c032e047ba994dce7357bcf6b013f5f9cb055');
INSERT INTO blocks VALUES(310036,'158648a98f1e1bd1875584ce8449eb15a4e91a99a923bbb24c4210135cef0c76',1419703600,NULL,NULL,'adee17bc1a995fbc44b3c692ee155f4a4b0515820ae9ea810b6841b59b0bca2d','ae798bac8a46c1e12059e8f71ae0e118a0c2bc5c07dddc3b6788a38a3c48b79c','f8eca7f6570e41384e9ca971e49620a85de15308cc74f99352ab7fb8bf92b794');
INSERT INTO blocks VALUES(310037,'563acfd6d991ce256d5655de2e9429975c8dceeb221e76d5ec6e9e24a2c27c07',1419703700,NULL,NULL,'389ce6906a4d83f1007d0393df4384c6aee8301bac7c520bde58d265297f15e0','858ba807b6a28395e4fe2372a0832c9bf4a854ca2303faee42e809701b6b2bf9','567f67ac5916ee4a1ce3d20b871b3019d8ef2ab245e9b234c2ac563504914b93');
INSERT INTO blocks VALUES(310038,'b44b4cad12431c32df27940e18d51f63897c7472b70950d18454edfd640490b2',1419703800,NULL,NULL,'2f2766251f66fe1a56ed246d8e6cbbb3366c84756392147394fa276ee2b27b99','f619dcea56afe0b5b680f0f828459e875b51d3b5843f2d513a4edf54a57f5942','758b94eeb0e80b42686fdbd6518c08d182e0f9e1701d0046b7d1aea3ef488855');
INSERT INTO blocks VALUES(310039,'5fa1ae9c5e8a599247458987b006ad3a57f686df1f7cc240bf119e911b56c347',1419703900,NULL,NULL,'b45fb11125d17af2852fd55688b8e4d3281823d6e9806a8f80be41d562b5f4ec','db2a61deeb9c16cd464611eb66c19571f86e706d15d93170e284be1af63713d3','996a00448290ba00e3bd98a8d56f7069835b6fc5f6e4ce9cb4ca114d12efbd88');
INSERT INTO blocks VALUES(310040,'7200ded406675453eadddfbb2d14c2a4526c7dc2b5de14bd48b29243df5e1aa3',1419704000,NULL,NULL,'205b47017736f6bada0addc40c171fbddd761eed79b6ec096df7d2538e10a7e2','5d9e371cfbc67cc35dfc9f812253a3eb747e5c0f2429e260e5d68191097b8075','04fb72622c212c0383aa6ccedccaa7634058388954f60bfd3bca38674cebe67e');
INSERT INTO blocks VALUES(310041,'5db592ff9ba5fac1e030cf22d6c13b70d330ba397f415340086ee7357143b359',1419704100,NULL,NULL,'a7f54426b483d9115b7d5b7ad187d9a7c43556302883ed9cb7663695aa617725','4a2e8a5c84c686eb2daf98f8b6e983296bffd6b0b281eb9796064d41c9539a18','78ca1dcd17aa4c3e0ebe59c0f05eb28d123e561f5695f6e7c1ab471edf5e2229');
INSERT INTO blocks VALUES(310042,'826fd4701ef2824e9559b069517cd3cb990aff6a4690830f78fc845ab77fa3e4',1419704200,NULL,NULL,'eb27a509ab30b69d8834e4dda8315ab2285bbd73f4c8d5d62b9d708201e94ede','9a0a528d22e27b0a3af0bab7b11fb0b248a14bea82eea91cd6c29a1983f6be4f','8dd6dcfe6d90c8cff88a26895c48caa1704df95f5e21b1489e689e47fd37302e');
INSERT INTO blocks VALUES(310043,'2254a12ada208f1dd57bc17547ecaf3c44720323c47bc7d4b1262477cb7f3c51',1419704300,NULL,NULL,'327a0b115eee64a87b893c26fd680a50759388450ca623e7dc9f0ea8b009ec6a','7a215a46832abcc71fed31bfb3157cf29b158cdecb48693fa31360759fef8165','45382bcab3dda3c65c9184314593f3cbdce13eada9776ca7a7aeddc752708fd7');
INSERT INTO blocks VALUES(310044,'3346d24118d8af0b3c6bcc42f8b85792e7a2e7036ebf6e4c25f4f6723c78e46b',1419704400,NULL,NULL,'0e16374c3317c345983d0717d47e6fcf58fae444035718f4d8ae10cd6d27c74a','adbc871f9f0695576a863f326d83f6d4900f627df87b17d31d5266b0ce3b5113','3ff312f4d54dc19c5efe323c04f0af5d0fa9c3531977188d65080ba5ca3b6497');
INSERT INTO blocks VALUES(310045,'7bba0ab243839e91ad1a45a762bf074011f8a9883074d68203c6d1b46fffde98',1419704500,NULL,NULL,'39c2473a98cf7fb57c171420f7755cb88a7af7b301543b1486612541a4cfba6e','0c1e5498a870709a549a30e3029a3126c011bfc429d29014528ae1f54852685c','299ab9d984655a9601bb7e9db90a419c4c5332d87096e8946bb0052b4cd2ded7');
INSERT INTO blocks VALUES(310046,'47db6788c38f2d6d712764979e41346b55e78cbb4969e0ef5c4336faf18993a6',1419704600,NULL,NULL,'ba77c05154da554fd930dcb6a9df3c70cb6486ca928a486e80738cd6dabcfdb4','afc288db7eeecf4a2d743a3de56df7a2ebfde25a916539c362e24c2c45dc3cba','7bccde6ee9500a1f7ad075a942c59a98673954836a77a603167c19dd1dae6a6b');
INSERT INTO blocks VALUES(310047,'a9ccabcc2a098a7d25e4ab8bda7c4e66807eefa42e29890dcd88149a10de7075',1419704700,NULL,NULL,'5ff06fa13dc0a4345163602819e64c106edec86dc015db477afaab82be2850a2','066482633b29b3bfb719382f6de50060ad9bd960e3d0da296551791f385ab5e7','5ff8f51e101df1ee625506fa2499d79fbd1736ec7fa8e282e0b035cf6bad297f');
INSERT INTO blocks VALUES(310048,'610bf3935a85b05a98556c55493c6de45bed4d7b3b6c8553a984718765796309',1419704800,NULL,NULL,'733ad84d35d4e4d90de49ef3dfcfcaa9c2caf1e619d020eb85ab9e49d1ea0fbe','41d568346df1c8ab508e9c1954c9a5fb15a998566922823cdc2f1f220c77333d','bf534253820c8b08c63b0b13901be7b291e2eeda4f0ea38fa9d4992a1affcdb3');
INSERT INTO blocks VALUES(310049,'4ad2761923ad49ad2b283b640f1832522a2a5d6964486b21591b71df6b33be3c',1419704900,NULL,NULL,'55dba4f8fe592314f117d3beeb4c6e59f9be45a1cbf17dbb5a4c6989d0f5276f','d53ad1a5dde6c1c539ffa1144ec45d0d524f635845edd0295df266a7e611bd18','f2bc8fb8bcc630bc3afc2327e5b5f5069fc5a2fd176bf7f865c820ecf60e31b4');
INSERT INTO blocks VALUES(310050,'8cfeb60a14a4cec6e9be13d699694d49007d82a31065a17890383e262071e348',1419705000,NULL,NULL,'0bbb2432ad20f2519157e1aa621aa26fd40139ecd398541c73455e173358d883','a06d8698fe4b4a3439b930df662d46d38d29e62cfe9dc64500481d6b70d69395','123558b0c75476b93ab4467b560a766d77cb63b0d58045989acc40460f71a76a');
INSERT INTO blocks VALUES(310051,'b53c90385dd808306601350920c6af4beb717518493fd23b5c730eea078f33e6',1419705100,NULL,NULL,'f4c760995f4835b5454ea465bd29412ee2c1b5b2046bdc484b06eb33f1bf81e2','18b2ed2b0508b77c639b944a31390216ad743a003a8e47866c8295547256e048','2b3a355ac7a18f67f9c7147af415d206f588810811ed731ee5d70118bd43bcf0');
INSERT INTO blocks VALUES(310052,'0acdacf4e4b6fca756479cb055191b367b1fa433aa558956f5f08fa5b7b394e2',1419705200,NULL,NULL,'325c49eef33d627db08af0db0cfcdd614f03c86c3fab79808dbb95d27c8514b7','347d6058641cbd07ff49973c4f130dfa5e2967a85bc193d4a4598887a53a2749','cd7ade02d879b46c67171175798ba7571cb78f4cb44bd5ecb53b6fcb41b6232e');
INSERT INTO blocks VALUES(310053,'68348f01b6dc49b2cb30fe92ac43e527aa90d859093d3bf7cd695c64d2ef744f',1419705300,NULL,NULL,'49eb2f3e0e1a37fac5992f43818d295155ef2a6f30dfec1b6deadd5186ae6d8e','987c5ac9452e9110e34eb43400c569c198e33ff34008d4dcc9377009e02de8db','a14d863dcab5e0e136162b233a432f50461d4081d80b448cc5a61f67298b8756');
INSERT INTO blocks VALUES(310054,'a8b5f253df293037e49b998675620d5477445c51d5ec66596e023282bb9cd305',1419705400,NULL,NULL,'69215d9c7a59ca94726e3ed41d4c4355292f9d620d24f188a812e992e9b7d9c7','a0b4266e960b3a785ba86784d82696a0154415ba0c783e81eaea93e900ebac88','0b71c6c0839206fbd73f634cbd024e491407caa9e72e12088ec5a16f54bbb755');
INSERT INTO blocks VALUES(310055,'4b069152e2dc82e96ed8a3c3547c162e8c3aceeb2a4ac07972f8321a535b9356',1419705500,NULL,NULL,'4d2fe87b0d0e0f2b26e85624512451c14cb9e4f08b7459f19635dbfa5088dbfb','95542d8157afbec96d54a9688c26079733522910fb8f35e6630db047b5c026a2','e933100f90d2bfb1276292b94907edf0faebdac4130e4e59dcc28aeddb2d5fd8');
INSERT INTO blocks VALUES(310056,'7603eaed418971b745256742f9d2ba70b2c2b2f69f61de6cc70e61ce0336f9d3',1419705600,NULL,NULL,'03d7fffc05f01b00669c8332215b79c6802fed9014db7c2fea69f524c74fa245','413f89e403140aaa0834d74a7542be1348f52894c44265327fd6a088abb7001f','2404b4fa63709bc1317078faea62ddb6707eda002968458af6a86e375e59343e');
INSERT INTO blocks VALUES(310057,'4a5fdc84f2d66ecb6ee3e3646aad20751ce8694e64e348d3c8aab09d33a3e411',1419705700,NULL,NULL,'5a8e61f3a4f5ccdb7b5f867ac4198390538c40d89d36d46cb1590fe9f4c4daa4','1032f54ac7d4204909a64902c90c0c39b3bb21871fa273dbe62e6f4cdb9b789c','09b0d6064b8ed36f52f77dd3ad6dbfe338b967607907710fbeaa8c131d4ee3d6');
INSERT INTO blocks VALUES(310058,'a6eef3089896f0cae0bfe9423392e45c48f4efe4310b14d8cfbdb1fea613635f',1419705800,NULL,NULL,'ff345b3826833ec682b9b67b3eb40e8fb9d50abc58231647c7705f0d002c1603','9ad5bc269f166ff9dcbb68edcfa1dadac4ec61f5a5038f0b556e38f187dc87c7','aa1784574f394e086351d8b8ed3804c9375d7e1e48c6c612f7aeced5605f99eb');
INSERT INTO blocks VALUES(310059,'ab505de874c43f97c90be1c26a769e6c5cb140405c993b4a6cc7afc795f156a9',1419705900,NULL,NULL,'bc5230a542990c3e7f058564ac98c8fef7c922b307c43d2fc37605a9bd35434d','a822cbd54c82eec0a7d2f9a2679fc84cd4e31df336d4771949cab9a8aaa70680','852bc8dbe5973efe8eb59374a7efde866a373604139d3ffe8756e7d1bb0b68bf');
INSERT INTO blocks VALUES(310060,'974ad5fbef621e0a38eab811608dc9afaf10c8ecc85fed913075ba1a145e889b',1419706000,NULL,NULL,'939ba4ae187ca5c7cd2c479ec7c4edb80268ed5be938396047fe1c2da7034f73','fb9bc0f596a03c0bcace3bdbf19b77a3d85920c57a236e768459a4a3ac66dd6a','6543135a35fd1f086c8efea238ada2a025870f8605c8ee31b725ea547262df0e');
INSERT INTO blocks VALUES(310061,'35d267d21ad386e7b7632292af1c422b0310dde7ca49a82f9577525a29c138cf',1419706100,NULL,NULL,'b34970bc96c8315b17802b62dec19c128712d1d9ee615a25dcbcfc927d098cb1','5a909ec547a39d3777e2c6eeb804eaf93a585f70dc564284ef794373a2e24d4d','c7a7a8588786bd4605f37aa02596b37c6e70fabbce389962e5c03ccaeaef24f5');
INSERT INTO blocks VALUES(310062,'b31a0054145319ef9de8c1cb19df5bcf4dc8a1ece20053aa494e5d3a00a2852f',1419706200,NULL,NULL,'9f1b63a8c5083e33fa940bded197af1ce6824edf88e366a0dcc379f2cdd6acc5','6a2aff7ef9288d58ff293a8c4e909b488f4dc788bc80efd207913d3860ff5782','06e4517eef85bf2b48142af4e72bb5b00915cb21cd4c71c202bcfcff1218d78a');
INSERT INTO blocks VALUES(310063,'0cbcbcd5b7f2dc288e3a34eab3d4212463a5a56e886804fb4f9f1cf929eadebe',1419706300,NULL,NULL,'e6fc3f47ca2c98eb3012dcec2ed3fcd507157a45b54d414fcbefda4619172594','7503c7c70cc8eca40d30bf254b2c1de338fc4862715a64e5389e9657b16c9beb','6e05ab30713d071c1706d90592565c7c02e3d6c2d522e912c71207044b705244');
INSERT INTO blocks VALUES(310064,'e2db8065a195e85cde9ddb868a17d39893a60fb2b1255aa5f0c88729de7cbf30',1419706400,NULL,NULL,'7add1f3f903760a4e7aad32a46ea1c4599de48ec9053c1f4008b7d803e971c6f','c8bbe0fdd115ac25800093087ee28c5171b3de5736a5004a3fda9f2e575d0c5c','a471aec689917aa6ef51c37d25baa7b00bca6b87e368d82fb001f313cb44a551');
INSERT INTO blocks VALUES(310065,'8a7bc7a77c831ac4fd11b8a9d22d1b6a0661b07cef05c2e600c7fb683b861d2a',1419706500,NULL,NULL,'b49df2e60ac0ba53298ac67d3dc56a2849c5c172d5c76641047bb612046fd043','2bbb9972817790aebb7ee7909246eff27e1743663be41f78f5ad2f4bb5218224','4fc7c469b25b73ace2b93ed1b8adecf3310e6baf0207734fcd442bdd6bf4437c');
INSERT INTO blocks VALUES(310066,'b6959be51eb084747d301f7ccaf9e75f2292c9404633b1532e3692659939430d',1419706600,NULL,NULL,'b31036bf1cc5a3d1a9438b8dd66df617cb9b79c54d86d4b55b3abb5f83991fc7','07a10976c2c09db0b3ed6f381c5d33dd608b4f9bbc9c0c8d464f8f212f96a278','8d728f38ccf6ea6f388122ce8d4d2589ddc02b39962e497e80160157993314fe');
INSERT INTO blocks VALUES(310067,'8b08eae98d7193c9c01863fac6effb9162bda010daeacf9e0347112f233b8577',1419706700,NULL,NULL,'ecac075af61239719c071115c023a3c010290690088cb0801bb874afb83eabac','d051806af16558c2f6f8cbad89d371f3e309ae1a0f4efaa9f290d4fc8ca701bc','f4ccc65431a5d62deec29bcb623339d102b031af857746aae6b1d6821403525a');
INSERT INTO blocks VALUES(310068,'9280e7297ef6313341bc81787a36acfc9af58f83a415afff5e3154f126cf52b5',1419706800,NULL,NULL,'5f2967743f8994cda260cdca5023fdbcae63bf01edf5d658746d73833680d7fc','a4d57cdb5820349dbd9da5b08014870bbcbd86fca54c3d92b7d7911038740d21','4d7f97604dde9302d9778b6fe048f7599b19dfa473ba600e34b4a0f12a444efb');
INSERT INTO blocks VALUES(310069,'486351f0655bf594ffaab1980cff17353b640b63e9c27239109addece189a6f7',1419706900,NULL,NULL,'c1be903b8b1f6081358420aaf11b55720767bcb99f6b3499489104330fdb6338','45ad08e5278e47394a2f7db34ac0a815a43314ebe242e0eab0fcd8afcd9afd42','6245ae441d1c2453e8216a1639543cadaeefed9ab7561c3868fbbaebe0c348cc');
INSERT INTO blocks VALUES(310070,'8739e99f4dee8bebf1332f37f49a125348b40b93b74fe35579dd52bfba4fa7e5',1419707000,NULL,NULL,'94408aeb454682a1086b94ccbc759a986783d05e370642bdfdb74090f62c6cd0','f61279a777dfe762ce4e2a8976bea9927600480d66784df6a3c6581b136da3ff','756b22b1d03c6df228cbe855154c8528f8523c99b48763a66ea8a9250c0bcf46');
INSERT INTO blocks VALUES(310071,'7a099aa1bba0ead577f1e44f35263a1f115ed6a868c98d4dd71609072ae7f80b',1419707100,NULL,NULL,'9603159c0dbb1be5a5805a282f4e08bf03e23ff62d8a2f4db0ce4daf5b205dec','e8eb858672dbab11eab34e52832e8a6a8a3e7e0f59bafdbed7a6ed2d8f2829cb','228b05d049e3121fd18a643c25399ad5ff3c70fcaa6e297d7a4a92d0cb5b8b09');
INSERT INTO blocks VALUES(310072,'7b17ecedc07552551b8129e068ae67cb176ca766ea3f6df74b597a94e3a7fc8a',1419707200,NULL,NULL,'ac0a2e9509b58412be67df27657e6f9451ecba51acde6c9d73f1b27c291efaa4','83e4eaf9cc180490bc39868439c21a13848a477a7520165aea491d828c8b1427','31021fc1787b3d751dd4aa072ef76ec8fd48764d26b6b9b405d82b198fc1f543');
INSERT INTO blocks VALUES(310073,'ee0fe3cc9b3a48a2746b6090b63b442b97ea6055d48edcf4b2288396764c6943',1419707300,NULL,NULL,'45f77191f7edbc976a59864445b169c0344d4e4deaa990043b7405c8ad91ab6d','badb37662b29e0bc62cf702f7421fffa94679fa69986de40e57b3eb1ae6fb367','ed7c8bf65e5c37edf34e0bc93c6155462c10d15522dd1cf492ca7d34cd93e8d4');
INSERT INTO blocks VALUES(310074,'ceab38dfde01f711a187601731ad575d67cfe0b7dbc61dcd4f15baaef72089fb',1419707400,NULL,NULL,'c2991f92177fc0c2fb344a3b82f854c207d7427926d3ff7c061dcd9b614adad6','b4975b242b48a8e735c88f4906b8a99df0e95e1cd33b591a6350526715c9e496','770656725aabef7dc1d865f0c8461090f4af47e5b73e4fd69bd16dd5fda1052f');
INSERT INTO blocks VALUES(310075,'ef547198c6e36d829f117cfd7077ccde45158e3c545152225fa24dba7a26847b',1419707500,NULL,NULL,'8e65ee80365d56c99521864679aaece9f7c8918c02f2e000f91ab8077ee6fa23','0c9389138db5c541d4106b4b51e47db5a57294d34c26cb10c1fae679dafe3a15','51152f6ca5f288f7776d06ce54ea4744f4dc1949e4037f14503b9bc88b629679');
INSERT INTO blocks VALUES(310076,'3b0499c2e8e8f0252c7288d4ecf66efc426ca37aad3524424d14c8bc6f8b0d92',1419707600,NULL,NULL,'312d522e966588b12ed488fbb2851d4399e9a7b006f13f1e0ba6d268c083d619','d83bd6a4eef0e52fc3d828735fe022aabe6e5cd1841d69e5504f9d31ee7b086d','fa0d1a219127fc1819f1366e0074bf17507c2fb3766798dce124bd2647d0942a');
INSERT INTO blocks VALUES(310077,'d2adeefa9024ab3ff2822bc36acf19b6c647cea118cf15b86c6bc00c3322e7dd',1419707700,NULL,NULL,'db300bb277a3ea00e651196d926288de74a14f8b39482efdde41e849a41330e5','fd5f1c7eadc062d96985778df08ac74d851e71d1ebc73016883b50a2efbaec56','409e590f11a71f78c270a1d364df61d35c54d492be4f00a1f627f7f29503d514');
INSERT INTO blocks VALUES(310078,'f6c17115ef0efe489c562bcda4615892b4d4b39db0c9791fe193d4922bd82cd6',1419707800,NULL,NULL,'d010c4889726f7d33b16893ebe1cea465fde66e35325700f4218e98724204c4d','f551a4cde7dc13e0fb808f460b0b937297ae4af829a44bcba7838ea8392e3e78','72d08f9df53f3c4e3f96d1537bffa2534124916ec291806e7ed70823940992c1');
INSERT INTO blocks VALUES(310079,'f2fbd2074d804e631db44cb0fb2e1db3fdc367e439c21ffc40d73104c4d7069c',1419707900,NULL,NULL,'3a05343a04240ed78415198d3f1ffd2ea006b77042935a727d8683ebe443a8cf','026b5d7254834df710032130754dee86778863ec052ec0edb5d88806d319eb44','6a4e0a6a9e1793f5edb8f2ef89bb3114d5542d09a90d01f0209508b562ab515f');
INSERT INTO blocks VALUES(310080,'42943b914d9c367000a78b78a544cc4b84b1df838aadde33fe730964a89a3a6c',1419708000,NULL,NULL,'1357c1b019622307812e7d5090f5e71f65c792e577909b056346f7bbaa3ad0f5','3b3274145a6c7fc29a5e3e89540bdf95c6ffbaad43abb78af211277d44227993','73638ffe46025b37a31e7bb508e31782fb3b1d1cfe0b6777b6a2ebd065191e75');
INSERT INTO blocks VALUES(310081,'6554f9d307976249e7b7e260e08046b3b55d318f8b6af627fed5be3063f123c4',1419708100,NULL,NULL,'dbee2ccfc9146d9b870f9c4a0f9fb1a10439c83e01d0c9241824833fd5b24919','f428af3be15c845bea4ad1b4177370e4b0d73edd883c12b4aab628e0f3c25443','2533b78d3412a568cd89611a9b1821456fa84b56d653fb64d33afd61ef55c4cb');
INSERT INTO blocks VALUES(310082,'4f1ef91b1dcd575f8ac2e66a67715500cbca154bd6f3b8148bb7015a6aa6c644',1419708200,NULL,NULL,'42c2209ee0a812c744b5f48ed5cb41249ca8c97d82fae28895fc836230667e3f','ecd2263715235b8259b38cf54aaa8bbf08298c6244c763f1e2a919fa93e5b29a','51050d110b4e6d2e22802bfd65941c48f2e002a5cc65de2c062756aae16d524a');
INSERT INTO blocks VALUES(310083,'9b1f6fd6ff9b0dc4e37603cfb0625f49067c775b99e12492afd85392d3c8d850',1419708300,NULL,NULL,'1cffa4cfe012f4954e573b4908900a29d4297eff61dfa3fdf3f190c37e14e507','25a7c74d0404045684676ce996aeb0119854da22b78cffdb907ebbadacdb8a4d','d10e470cc24dc8e63efbbc951aea489ce072b8e217aae6c1dda3aa3ee4a736d0');
INSERT INTO blocks VALUES(310084,'1e0972523e80306441b9f4157f171716199f1428db2e818a7f7817ccdc8859e3',1419708400,NULL,NULL,'4cc7094ff33a055952455ad46e2d1e68bdc79c5387a816b4f6634aa867096c4e','32bfea55218988c1947071496a545a6c1e459e7a2a72346aaec75c9674b0e543','6710eef2c0e6ada59eacdd81b181cdfd8038ba5c4aa74ca1f9800e9864276573');
INSERT INTO blocks VALUES(310085,'c5b6e9581831e3bc5848cd7630c499bca26d9ece5156d36579bdb72d54817e34',1419708500,NULL,NULL,'8027af48faf31917f8612c96c0392cfbe7b27812554b218f76ef476c0c080bf7','02a93dd74105df143b2a22cbee96b875c5a9de76dc1a4e8437bb8d89abcfb3ea','6286e92477b51c564cb0519a3740600c726197fe98ac99ebe427b113c74d3b24');
INSERT INTO blocks VALUES(310086,'080c1dc55a4ecf4824cf9840602498cfc35b5f84099f50b71b45cb63834c7a78',1419708600,NULL,NULL,'7a9ca00609c8e987d5b176e5652831f23fff1fb9cc34f8fe5c6a1c579a3eb0f2','22dd5c42f300778ba67f3062a7a9869f0c804811562ff2a2ee696d4573283d03','14910e0e65e0653b2db693a677a713dadd07c0bd5d8a02229bc7b187b457b024');
INSERT INTO blocks VALUES(310087,'4ec8cb1c38b22904e8087a034a6406b896eff4dd28e7620601c6bddf82e2738c',1419708700,NULL,NULL,'037a4e60aa20a065773f969405b8c8d1069389ad810b734f9c8397331fea7800','eb917e5b34c3414cf0b59e1ff03d72b3b58041d4451acc53cde6a3e8293d7ccf','45354b18d795141ab37ad6b80a73529033b4e555b8f4c003a2266902527aecea');
INSERT INTO blocks VALUES(310088,'e945c815c433cbddd0bf8e66c5c23b51072483492acda98f5c2c201020a8c5b3',1419708800,NULL,NULL,'767da4db373c2f04b67f7ce9e4ea9b9a00a27c3ecee94b8dd814f7cca4928391','28e750c173dce65ad657761c3b7b42eb9192314b4f17cdb5753b1510768b6fd4','9dd3cb664b188724f27c8ce42fe24e754e6d3a914149cd89af61280f8291faa0');
INSERT INTO blocks VALUES(310089,'0382437f895ef3e7e38bf025fd4f606fd44d4bbd6aea71dbdc4ed11a7cd46f33',1419708900,NULL,NULL,'3826290d3a6f1784ab9da4056c04f9a79f6331be710cd8a236623bf24a4d8d61','b7afce36e5663fdd53046c8015f03cfa7b6765e94c565a99e8e57bcf5b33692e','b201bcd63667c9f6f084689c1aa2b5332065771818f3c8fba253ee0d2aacfe1b');
INSERT INTO blocks VALUES(310090,'b756db71dc037b5a4582de354a3347371267d31ebda453e152f0a13bb2fae969',1419709000,NULL,NULL,'5768e5ba2fba07aba68511af608f38b6287a2180234823601485ac110ca9d434','5251ac319cdfba057df06e32b27e90cc0fc968056e05ec10668d70ad6e51719d','955fb1736d738a252c6e7e79500aded94aee0fa390ce053b6693e2205d9f1103');
INSERT INTO blocks VALUES(310091,'734a9aa485f36399d5efb74f3b9c47f8b5f6fd68c9967f134b14cfe7e2d7583c',1419709100,NULL,NULL,'57905c0d8aa6607e270da8a1313c7817595efd9c69496fa678101ae89cf08456','800511b0b3595ac2c53957aac45d28b004109bca1c82c2ce804e4d48fa808820','171c82bab179b44099c69139e0aa799aac731dea42fc23c89084fd2c73c695e6');
INSERT INTO blocks VALUES(310092,'56386beb65f9228740d4ad43a1c575645f6daf59e0dd9f22551c59215b5e8c3d',1419709200,NULL,NULL,'13ce91b5c65caa932963e97dc4845ee603469e4b2d1c910e310a87ba2e15a1ce','3f03309d7bbf1572763818d0562de6468a9e96aca74d9f7e693441646aa71447','87f9d82c1daf0502bdfe85787a3d95765680bcc067500e7adcf1b772baf8eb12');
INSERT INTO blocks VALUES(310093,'a74a2425f2f4be24bb5f715173e6756649e1cbf1b064aeb1ef60e0b94b418ddc',1419709300,NULL,NULL,'6bceb00c6f73e9b8ba1d88889f1c544e2084538980a57265d81d8ce97e7b48c2','f03a38bbc5798f1018fdde37baf7ae028b64101ce861023caf341eade9bc1b80','1bde51c823dfe12e586692abed0f2c3a2d9f3a1ddddad2b989cf474807ce9c4f');
INSERT INTO blocks VALUES(310094,'2a8f976f20c4e89ff01071915ac96ee35192d54df3a246bf61fd4a0cccfb5b23',1419709400,NULL,NULL,'061bf2e2287eb957010db198655df7454bd54200c608a2c2e35f235c1bedff59','ae5070ed6818e7fe52555e9ddee4f92143cf7da337469dddf504d08b349d1cdc','fba26908b12a0061e970e0e8ac21a13290aa4296c80f93dee5564680b646ecf3');
INSERT INTO blocks VALUES(310095,'bed0fa40c9981223fb40b3be8124ca619edc9dd34d0c907369477ea92e5d2cd2',1419709500,NULL,NULL,'4b4eeb5f12adec48152a729a910c6256d827d7e7bce75419b8f4fb86911e87bb','72402791b0fbaeedc192c19ddf2ba0a1892ab8a5dc99e4e614ddf4fa5c93079b','6a9119e77ae5f9720ba61d3ea91c5bc68c40a079dd34fb202f9cb182bcec240e');
INSERT INTO blocks VALUES(310096,'306aeec3db435fabffdf88c2f26ee83caa4c2426375a33daa2be041dbd27ea2f',1419709600,NULL,NULL,'e470ba18cffb11fe4400a4ef2ced1a4be9557dfea3038de5f0001db7b2556b94','1fdf6bd9284b0ab9036118a073a1551cbce5614f0b40b750da770003b28a72b1','3b9db869053107a1591ee2d248169a60acea91922269a5a37fd08520b232d4bf');
INSERT INTO blocks VALUES(310097,'13e8e16e67c7cdcc80d477491e554b43744f90e8e1a9728439a11fab42cefadf',1419709700,NULL,NULL,'d1022a213c6be6f92d136e92c640c8284e6e361137e99d01d7aa7a0479e3b920','2cc7ac589cb42159830a017fdc1055ac660106262c5b9bda7df302c9fbc888b3','ba419ba379ef627f5ce9e661f6d781a74e88d4affe7ba325ed0a4d97b45a00a0');
INSERT INTO blocks VALUES(310098,'ca5bca4b5ec4fa6183e05176abe921cff884c4e20910fab55b603cef48dc3bca',1419709800,NULL,NULL,'c273578819c09dfeafb604bc0d3d9ed46d9e093951977b86328780757ba50591','687207463b04d738c6549d3cef7cb49f15632fe7c9aa2d7416696fa6431cfa3d','3be197fd539aa41c139cc4e0804e4269e0f73eeb2d3dd54b38703fd74b6b2031');
INSERT INTO blocks VALUES(310099,'3c4c2279cd7de0add5ec469648a845875495a7d54ebfb5b012dcc5a197b7992a',1419709900,NULL,NULL,'1d7b6eecc6075bf2227f545b8578bd2e61868b1cdfdf5e8d0500900c7425db29','3aed66ba21418107628e96183566699bb9f2b9912116d50030de9adf03693228','04c199b62bc7548a25e11d2082378423c31b4c427db844b300c29ffab35b085a');
INSERT INTO blocks VALUES(310100,'96925c05b3c7c80c716f5bef68d161c71d044252c766ca0e3f17f255764242cb',1419710000,NULL,NULL,'437f8109e8a3d78175d205940feff169805dc1f810b350d3e9537cdeb49966a0','7dd603b0c17a422a0808dfeb0e87a7241f3a5ead261c919f1b9ccdfbf592c529','fcfafaa96b57538ac93b3b5efd4b7cee529cc57acbf02a52b72c188bdda47dbf');
INSERT INTO blocks VALUES(310101,'369472409995ca1a2ebecbad6bf9dab38c378ab1e67e1bdf13d4ce1346731cd6',1419710100,NULL,NULL,'dd1a3245e85137714b98c2173f844d12dd066e987225b9d55e6dea9fb35baa11','d0e6498ee301d1b5e839de00f403a0fcf3d0e2233c5665b87c7d41e91dada918','95cb1b584e9142e92bf97f5c13c610ade81505be1d624716f28e3b3085d13284');
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
INSERT INTO broadcasts VALUES(12,'c51e2772404042d1d4ccbaf4cb56b22d990943172fe2c03b12241ac26d552bff',310011,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1388000000,100.0,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(19,'9419f0ab4bbbf7eb6bce2cfa731d619f4e583b228ede774db00a77fed6a97960',310018,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1388000050,99.86166,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(20,'84e21df5f3d10795c5439a66dda03399e4f6cb915f7c141e684565e9fb55bbdc',310019,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1388000101,100.343,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(21,'f63fdf467229e05304c42e373e215ef86c1bc4e6cc7d9d0615301168b32cede7',310020,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1388000201,2.0,5000000,'Unit Test',0,'valid');
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
INSERT INTO btcpays VALUES(5,'6dff822c561bf6ff5504a16e54cc3bd8a591f294fbd7a404ed60e7a7b7524988',310004,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',50000000,'e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517_9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d','valid');
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
INSERT INTO burns VALUES(1,'37f2ff45d34097306c63d4cbb9699354bd6ab9cac6cc362eb8be563de3e74981',310000,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',62000000,93000000000,'valid');
INSERT INTO burns VALUES(23,'5b1c6a89eb129c3193bc6c6e2876f9e5aaff3c65ef58d591fe743a5a59a51e94',310022,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',38000000,56999887262,'valid');
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
INSERT INTO credits VALUES(310000,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',93000000000,'burn','37f2ff45d34097306c63d4cbb9699354bd6ab9cac6cc362eb8be563de3e74981');
INSERT INTO credits VALUES(310001,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','XCP',50000000,'send','c8965f816ec849438f24ed603131b983cc9f3ab881686f44da4be853cf2ecb1d');
INSERT INTO credits VALUES(310004,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',100000000,'btcpay','6dff822c561bf6ff5504a16e54cc3bd8a591f294fbd7a404ed60e7a7b7524988');
INSERT INTO credits VALUES(310005,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',1000000000,'issuance','39dc01835ecabc07f3f7390f692dfbf495adfab0f3bedda4ddc6647904c7e719');
INSERT INTO credits VALUES(310006,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBC',100000,'issuance','ac50584491e6a6f76dfb70b23ffd0cbc1f06426126588b8477b26064eba41aa2');
INSERT INTO credits VALUES(310007,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBB',4000000,'send','893ba7699b526e4a1a919ad7671e901d6fabf13ac22d2fb54f2bb427ed23f13e');
INSERT INTO credits VALUES(310008,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBC',526,'send','fe27b3bea249061f253b4219793d244dd41448e8ddff7177d3045f5eeefa3fe1');
INSERT INTO credits VALUES(310009,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','XCP',24,'dividend','78f94515b5769fa354cbd5b857e48665f1f826ac65eb18c34ad958f85e29a6dd');
INSERT INTO credits VALUES(310010,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','XCP',420800,'dividend','25ec88deb553d89c45619a83794e060a76953a7fefbdbba20df4009300c37550');
INSERT INTO credits VALUES(310013,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',4250000,'filled','64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78');
INSERT INTO credits VALUES(310014,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',5000000,'cancel order','9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d');
INSERT INTO credits VALUES(310014,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',41500000,'recredit forward quantity','0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a_64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78');
INSERT INTO credits VALUES(310014,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',20750000,'recredit backward quantity','0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a_64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78');
INSERT INTO credits VALUES(310015,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',0,'filled','c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460');
INSERT INTO credits VALUES(310015,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',0,'filled','c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460');
INSERT INTO credits VALUES(310016,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',150000000,'recredit forward quantity','11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d_c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460');
INSERT INTO credits VALUES(310016,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',350000000,'recredit backward quantity','11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d_c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460');
INSERT INTO credits VALUES(310017,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',0,'filled','f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c');
INSERT INTO credits VALUES(310017,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',0,'filled','f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c');
INSERT INTO credits VALUES(310018,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',750000000,'recredit forward quantity','274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9_f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c');
INSERT INTO credits VALUES(310018,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',650000000,'recredit backward quantity','274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9_f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c');
INSERT INTO credits VALUES(310022,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',56999887262,'burn','5b1c6a89eb129c3193bc6c6e2876f9e5aaff3c65ef58d591fe743a5a59a51e94');
INSERT INTO credits VALUES(310023,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',8500000,'recredit wager remaining','0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a');
INSERT INTO credits VALUES(310023,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBC',10000,'send','07fd8a2913753c3ca53cddc3992bf2be36119b23082ba29a8c33192f09131594');
INSERT INTO credits VALUES(310032,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',50000000,'cancel order','8b53787bd6551eddb5302769b48361275d1402039b46eb1ae87d1e90d3711e07');
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
INSERT INTO debits VALUES(310001,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',50000000,'send','c8965f816ec849438f24ed603131b983cc9f3ab881686f44da4be853cf2ecb1d');
INSERT INTO debits VALUES(310003,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',105000000,'open order','9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d');
INSERT INTO debits VALUES(310005,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',50000000,'issuance fee','39dc01835ecabc07f3f7390f692dfbf495adfab0f3bedda4ddc6647904c7e719');
INSERT INTO debits VALUES(310006,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',50000000,'issuance fee','ac50584491e6a6f76dfb70b23ffd0cbc1f06426126588b8477b26064eba41aa2');
INSERT INTO debits VALUES(310007,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',4000000,'send','893ba7699b526e4a1a919ad7671e901d6fabf13ac22d2fb54f2bb427ed23f13e');
INSERT INTO debits VALUES(310008,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBC',526,'send','fe27b3bea249061f253b4219793d244dd41448e8ddff7177d3045f5eeefa3fe1');
INSERT INTO debits VALUES(310009,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',24,'dividend','78f94515b5769fa354cbd5b857e48665f1f826ac65eb18c34ad958f85e29a6dd');
INSERT INTO debits VALUES(310009,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',20000,'dividend fee','78f94515b5769fa354cbd5b857e48665f1f826ac65eb18c34ad958f85e29a6dd');
INSERT INTO debits VALUES(310010,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',420800,'dividend','25ec88deb553d89c45619a83794e060a76953a7fefbdbba20df4009300c37550');
INSERT INTO debits VALUES(310010,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',20000,'dividend fee','25ec88deb553d89c45619a83794e060a76953a7fefbdbba20df4009300c37550');
INSERT INTO debits VALUES(310012,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',50000000,'bet','0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a');
INSERT INTO debits VALUES(310013,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',25000000,'bet','64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78');
INSERT INTO debits VALUES(310014,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',150000000,'bet','11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d');
INSERT INTO debits VALUES(310015,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',350000000,'bet','c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460');
INSERT INTO debits VALUES(310016,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',750000000,'bet','274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9');
INSERT INTO debits VALUES(310017,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',650000000,'bet','f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c');
INSERT INTO debits VALUES(310021,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',50000000,'open order','8b53787bd6551eddb5302769b48361275d1402039b46eb1ae87d1e90d3711e07');
INSERT INTO debits VALUES(310023,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBC',10000,'send','07fd8a2913753c3ca53cddc3992bf2be36119b23082ba29a8c33192f09131594');
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
INSERT INTO dividends VALUES(10,'78f94515b5769fa354cbd5b857e48665f1f826ac65eb18c34ad958f85e29a6dd',310009,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB','XCP',600,20000,'valid');
INSERT INTO dividends VALUES(11,'25ec88deb553d89c45619a83794e060a76953a7fefbdbba20df4009300c37550',310010,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBC','XCP',800,20000,'valid');
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
INSERT INTO issuances VALUES(6,'39dc01835ecabc07f3f7390f692dfbf495adfab0f3bedda4ddc6647904c7e719',310005,'BBBB',1000000000,1,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,0,0,0.0,'',50000000,0,'valid');
INSERT INTO issuances VALUES(7,'ac50584491e6a6f76dfb70b23ffd0cbc1f06426126588b8477b26064eba41aa2',310006,'BBBC',100000,0,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,0,0,0.0,'foobar',50000000,0,'valid');
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
INSERT INTO messages VALUES(0,310000,'insert','credits','{"action": "burn", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310000, "event": "37f2ff45d34097306c63d4cbb9699354bd6ab9cac6cc362eb8be563de3e74981", "quantity": 93000000000}',0);
INSERT INTO messages VALUES(1,310000,'insert','burns','{"block_index": 310000, "burned": 62000000, "earned": 93000000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "37f2ff45d34097306c63d4cbb9699354bd6ab9cac6cc362eb8be563de3e74981", "tx_index": 1}',0);
INSERT INTO messages VALUES(2,310001,'insert','debits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310001, "event": "c8965f816ec849438f24ed603131b983cc9f3ab881686f44da4be853cf2ecb1d", "quantity": 50000000}',0);
INSERT INTO messages VALUES(3,310001,'insert','credits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "XCP", "block_index": 310001, "event": "c8965f816ec849438f24ed603131b983cc9f3ab881686f44da4be853cf2ecb1d", "quantity": 50000000}',0);
INSERT INTO messages VALUES(4,310001,'insert','sends','{"asset": "XCP", "block_index": 310001, "destination": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "quantity": 50000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "c8965f816ec849438f24ed603131b983cc9f3ab881686f44da4be853cf2ecb1d", "tx_index": 2}',0);
INSERT INTO messages VALUES(5,310002,'insert','orders','{"block_index": 310002, "expiration": 10, "expire_index": 310012, "fee_provided": 1000000, "fee_provided_remaining": 1000000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 100000000, "get_remaining": 100000000, "give_asset": "BTC", "give_quantity": 50000000, "give_remaining": 50000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "tx_hash": "e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517", "tx_index": 3}',0);
INSERT INTO messages VALUES(6,310003,'insert','debits','{"action": "open order", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310003, "event": "9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d", "quantity": 105000000}',0);
INSERT INTO messages VALUES(7,310003,'insert','orders','{"block_index": 310003, "expiration": 10, "expire_index": 310013, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 900000, "fee_required_remaining": 900000, "get_asset": "BTC", "get_quantity": 50000000, "get_remaining": 50000000, "give_asset": "XCP", "give_quantity": 105000000, "give_remaining": 105000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "tx_hash": "9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d", "tx_index": 4}',0);
INSERT INTO messages VALUES(8,310003,'update','orders','{"fee_provided_remaining": 142858, "fee_required_remaining": 0, "get_remaining": 0, "give_remaining": 0, "status": "open", "tx_hash": "e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517"}',0);
INSERT INTO messages VALUES(9,310003,'update','orders','{"fee_provided_remaining": 10000, "fee_required_remaining": 42858, "get_remaining": 0, "give_remaining": 5000000, "status": "open", "tx_hash": "9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d"}',0);
INSERT INTO messages VALUES(10,310003,'insert','order_matches','{"backward_asset": "XCP", "backward_quantity": 100000000, "block_index": 310003, "fee_paid": 857142, "forward_asset": "BTC", "forward_quantity": 50000000, "id": "e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517_9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d", "match_expire_index": 310023, "status": "pending", "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx0_block_index": 310002, "tx0_expiration": 10, "tx0_hash": "e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517", "tx0_index": 3, "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_block_index": 310003, "tx1_expiration": 10, "tx1_hash": "9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d", "tx1_index": 4}',0);
INSERT INTO messages VALUES(11,310004,'insert','credits','{"action": "btcpay", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310004, "event": "6dff822c561bf6ff5504a16e54cc3bd8a591f294fbd7a404ed60e7a7b7524988", "quantity": 100000000}',0);
INSERT INTO messages VALUES(12,310004,'update','order_matches','{"order_match_id": "e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517_9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d", "status": "completed"}',0);
INSERT INTO messages VALUES(13,310004,'insert','btcpays','{"block_index": 310004, "btc_amount": 50000000, "destination": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "order_match_id": "e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517_9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d", "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "6dff822c561bf6ff5504a16e54cc3bd8a591f294fbd7a404ed60e7a7b7524988", "tx_index": 5}',0);
INSERT INTO messages VALUES(14,310005,'insert','debits','{"action": "issuance fee", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310005, "event": "39dc01835ecabc07f3f7390f692dfbf495adfab0f3bedda4ddc6647904c7e719", "quantity": 50000000}',0);
INSERT INTO messages VALUES(15,310005,'insert','issuances','{"asset": "BBBB", "block_index": 310005, "call_date": 0, "call_price": 0.0, "callable": false, "description": "", "divisible": true, "fee_paid": 50000000, "issuer": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "locked": false, "quantity": 1000000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "transfer": false, "tx_hash": "39dc01835ecabc07f3f7390f692dfbf495adfab0f3bedda4ddc6647904c7e719", "tx_index": 6}',0);
INSERT INTO messages VALUES(16,310005,'insert','credits','{"action": "issuance", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBB", "block_index": 310005, "event": "39dc01835ecabc07f3f7390f692dfbf495adfab0f3bedda4ddc6647904c7e719", "quantity": 1000000000}',0);
INSERT INTO messages VALUES(17,310006,'insert','debits','{"action": "issuance fee", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310006, "event": "ac50584491e6a6f76dfb70b23ffd0cbc1f06426126588b8477b26064eba41aa2", "quantity": 50000000}',0);
INSERT INTO messages VALUES(18,310006,'insert','issuances','{"asset": "BBBC", "block_index": 310006, "call_date": 0, "call_price": 0.0, "callable": false, "description": "foobar", "divisible": false, "fee_paid": 50000000, "issuer": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "locked": false, "quantity": 100000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "transfer": false, "tx_hash": "ac50584491e6a6f76dfb70b23ffd0cbc1f06426126588b8477b26064eba41aa2", "tx_index": 7}',0);
INSERT INTO messages VALUES(19,310006,'insert','credits','{"action": "issuance", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBC", "block_index": 310006, "event": "ac50584491e6a6f76dfb70b23ffd0cbc1f06426126588b8477b26064eba41aa2", "quantity": 100000}',0);
INSERT INTO messages VALUES(20,310007,'insert','debits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBB", "block_index": 310007, "event": "893ba7699b526e4a1a919ad7671e901d6fabf13ac22d2fb54f2bb427ed23f13e", "quantity": 4000000}',0);
INSERT INTO messages VALUES(21,310007,'insert','credits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "BBBB", "block_index": 310007, "event": "893ba7699b526e4a1a919ad7671e901d6fabf13ac22d2fb54f2bb427ed23f13e", "quantity": 4000000}',0);
INSERT INTO messages VALUES(22,310007,'insert','sends','{"asset": "BBBB", "block_index": 310007, "destination": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "quantity": 4000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "893ba7699b526e4a1a919ad7671e901d6fabf13ac22d2fb54f2bb427ed23f13e", "tx_index": 8}',0);
INSERT INTO messages VALUES(23,310008,'insert','debits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBC", "block_index": 310008, "event": "fe27b3bea249061f253b4219793d244dd41448e8ddff7177d3045f5eeefa3fe1", "quantity": 526}',0);
INSERT INTO messages VALUES(24,310008,'insert','credits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "BBBC", "block_index": 310008, "event": "fe27b3bea249061f253b4219793d244dd41448e8ddff7177d3045f5eeefa3fe1", "quantity": 526}',0);
INSERT INTO messages VALUES(25,310008,'insert','sends','{"asset": "BBBC", "block_index": 310008, "destination": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "quantity": 526, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "fe27b3bea249061f253b4219793d244dd41448e8ddff7177d3045f5eeefa3fe1", "tx_index": 9}',0);
INSERT INTO messages VALUES(26,310009,'insert','debits','{"action": "dividend", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310009, "event": "78f94515b5769fa354cbd5b857e48665f1f826ac65eb18c34ad958f85e29a6dd", "quantity": 24}',0);
INSERT INTO messages VALUES(27,310009,'insert','debits','{"action": "dividend fee", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310009, "event": "78f94515b5769fa354cbd5b857e48665f1f826ac65eb18c34ad958f85e29a6dd", "quantity": 20000}',0);
INSERT INTO messages VALUES(28,310009,'insert','credits','{"action": "dividend", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "XCP", "block_index": 310009, "event": "78f94515b5769fa354cbd5b857e48665f1f826ac65eb18c34ad958f85e29a6dd", "quantity": 24}',0);
INSERT INTO messages VALUES(29,310009,'insert','dividends','{"asset": "BBBB", "block_index": 310009, "dividend_asset": "XCP", "fee_paid": 20000, "quantity_per_unit": 600, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "78f94515b5769fa354cbd5b857e48665f1f826ac65eb18c34ad958f85e29a6dd", "tx_index": 10}',0);
INSERT INTO messages VALUES(30,310010,'insert','debits','{"action": "dividend", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310010, "event": "25ec88deb553d89c45619a83794e060a76953a7fefbdbba20df4009300c37550", "quantity": 420800}',0);
INSERT INTO messages VALUES(31,310010,'insert','debits','{"action": "dividend fee", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310010, "event": "25ec88deb553d89c45619a83794e060a76953a7fefbdbba20df4009300c37550", "quantity": 20000}',0);
INSERT INTO messages VALUES(32,310010,'insert','credits','{"action": "dividend", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "XCP", "block_index": 310010, "event": "25ec88deb553d89c45619a83794e060a76953a7fefbdbba20df4009300c37550", "quantity": 420800}',0);
INSERT INTO messages VALUES(33,310010,'insert','dividends','{"asset": "BBBC", "block_index": 310010, "dividend_asset": "XCP", "fee_paid": 20000, "quantity_per_unit": 800, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "25ec88deb553d89c45619a83794e060a76953a7fefbdbba20df4009300c37550", "tx_index": 11}',0);
INSERT INTO messages VALUES(34,310011,'insert','broadcasts','{"block_index": 310011, "fee_fraction_int": 5000000, "locked": false, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "text": "Unit Test", "timestamp": 1388000000, "tx_hash": "c51e2772404042d1d4ccbaf4cb56b22d990943172fe2c03b12241ac26d552bff", "tx_index": 12, "value": 100.0}',0);
INSERT INTO messages VALUES(35,310012,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310012, "event": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a", "quantity": 50000000}',0);
INSERT INTO messages VALUES(36,310012,'insert','bets','{"bet_type": 0, "block_index": 310012, "counterwager_quantity": 25000000, "counterwager_remaining": 25000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310022, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 15120, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 0.0, "tx_hash": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a", "tx_index": 13, "wager_quantity": 50000000, "wager_remaining": 50000000}',0);
INSERT INTO messages VALUES(37,310013,'update','orders','{"status": "expired", "tx_hash": "e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517"}',0);
INSERT INTO messages VALUES(38,310013,'insert','order_expirations','{"block_index": 310013, "order_hash": "e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517", "order_index": 3, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(39,310013,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310013, "event": "64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78", "quantity": 25000000}',0);
INSERT INTO messages VALUES(40,310013,'insert','bets','{"bet_type": 1, "block_index": 310013, "counterwager_quantity": 41500000, "counterwager_remaining": 41500000, "deadline": 1388000100, "expiration": 10, "expire_index": 310023, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 15120, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 0.0, "tx_hash": "64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78", "tx_index": 14, "wager_quantity": 25000000, "wager_remaining": 25000000}',0);
INSERT INTO messages VALUES(41,310013,'update','bets','{"counterwager_remaining": 4250000, "status": "open", "tx_hash": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a", "wager_remaining": 8500000}',0);
INSERT INTO messages VALUES(42,310013,'insert','credits','{"action": "filled", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310013, "event": "64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78", "quantity": 4250000}',0);
INSERT INTO messages VALUES(43,310013,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78", "wager_remaining": 4250000}',0);
INSERT INTO messages VALUES(44,310013,'insert','bet_matches','{"backward_quantity": 20750000, "block_index": 310013, "deadline": 1388000100, "fee_fraction_int": 5000000, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "forward_quantity": 41500000, "id": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a_64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78", "initial_value": 100.0, "leverage": 15120, "match_expire_index": 310022, "status": "pending", "target_value": 0.0, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx0_bet_type": 0, "tx0_block_index": 310012, "tx0_expiration": 10, "tx0_hash": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a", "tx0_index": 13, "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_bet_type": 1, "tx1_block_index": 310013, "tx1_expiration": 10, "tx1_hash": "64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78", "tx1_index": 14}',0);
INSERT INTO messages VALUES(45,310014,'update','orders','{"status": "expired", "tx_hash": "9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d"}',0);
INSERT INTO messages VALUES(46,310014,'insert','credits','{"action": "cancel order", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310014, "event": "9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d", "quantity": 5000000}',0);
INSERT INTO messages VALUES(47,310014,'insert','order_expirations','{"block_index": 310014, "order_hash": "9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d", "order_index": 4, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(48,310014,'insert','credits','{"action": "recredit forward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310014, "event": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a_64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78", "quantity": 41500000}',0);
INSERT INTO messages VALUES(49,310014,'insert','credits','{"action": "recredit backward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310014, "event": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a_64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78", "quantity": 20750000}',0);
INSERT INTO messages VALUES(50,310014,'update','bet_matches','{"bet_match_id": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a_64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78", "status": "expired"}',0);
INSERT INTO messages VALUES(51,310014,'insert','bet_match_expirations','{"bet_match_id": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a_64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78", "block_index": 310014, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(52,310014,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310014, "event": "11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d", "quantity": 150000000}',0);
INSERT INTO messages VALUES(53,310014,'insert','bets','{"bet_type": 0, "block_index": 310014, "counterwager_quantity": 350000000, "counterwager_remaining": 350000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310024, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 5040, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 0.0, "tx_hash": "11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d", "tx_index": 15, "wager_quantity": 150000000, "wager_remaining": 150000000}',0);
INSERT INTO messages VALUES(54,310015,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310015, "event": "c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460", "quantity": 350000000}',0);
INSERT INTO messages VALUES(55,310015,'insert','bets','{"bet_type": 1, "block_index": 310015, "counterwager_quantity": 150000000, "counterwager_remaining": 150000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310025, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 5040, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 0.0, "tx_hash": "c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460", "tx_index": 16, "wager_quantity": 350000000, "wager_remaining": 350000000}',0);
INSERT INTO messages VALUES(56,310015,'insert','credits','{"action": "filled", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310015, "event": "c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460", "quantity": 0}',0);
INSERT INTO messages VALUES(57,310015,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(58,310015,'insert','credits','{"action": "filled", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310015, "event": "c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460", "quantity": 0}',0);
INSERT INTO messages VALUES(59,310015,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(60,310015,'insert','bet_matches','{"backward_quantity": 350000000, "block_index": 310015, "deadline": 1388000100, "fee_fraction_int": 5000000, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "forward_quantity": 150000000, "id": "11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d_c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460", "initial_value": 100.0, "leverage": 5040, "match_expire_index": 310024, "status": "pending", "target_value": 0.0, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx0_bet_type": 0, "tx0_block_index": 310014, "tx0_expiration": 10, "tx0_hash": "11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d", "tx0_index": 15, "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_bet_type": 1, "tx1_block_index": 310015, "tx1_expiration": 10, "tx1_hash": "c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460", "tx1_index": 16}',0);
INSERT INTO messages VALUES(61,310016,'insert','credits','{"action": "recredit forward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310016, "event": "11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d_c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460", "quantity": 150000000}',0);
INSERT INTO messages VALUES(62,310016,'insert','credits','{"action": "recredit backward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310016, "event": "11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d_c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460", "quantity": 350000000}',0);
INSERT INTO messages VALUES(63,310016,'update','bet_matches','{"bet_match_id": "11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d_c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460", "status": "expired"}',0);
INSERT INTO messages VALUES(64,310016,'insert','bet_match_expirations','{"bet_match_id": "11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d_c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460", "block_index": 310016, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(65,310016,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310016, "event": "274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9", "quantity": 750000000}',0);
INSERT INTO messages VALUES(66,310016,'insert','bets','{"bet_type": 2, "block_index": 310016, "counterwager_quantity": 650000000, "counterwager_remaining": 650000000, "deadline": 1388000200, "expiration": 10, "expire_index": 310026, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 5040, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 1.0, "tx_hash": "274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9", "tx_index": 17, "wager_quantity": 750000000, "wager_remaining": 750000000}',0);
INSERT INTO messages VALUES(67,310017,'insert','debits','{"action": "bet", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310017, "event": "f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c", "quantity": 650000000}',0);
INSERT INTO messages VALUES(68,310017,'insert','bets','{"bet_type": 3, "block_index": 310017, "counterwager_quantity": 750000000, "counterwager_remaining": 750000000, "deadline": 1388000200, "expiration": 10, "expire_index": 310027, "fee_fraction_int": 5000000.0, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 5040, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 1.0, "tx_hash": "f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c", "tx_index": 18, "wager_quantity": 650000000, "wager_remaining": 650000000}',0);
INSERT INTO messages VALUES(69,310017,'insert','credits','{"action": "filled", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310017, "event": "f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c", "quantity": 0}',0);
INSERT INTO messages VALUES(70,310017,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(71,310017,'insert','credits','{"action": "filled", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310017, "event": "f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c", "quantity": 0}',0);
INSERT INTO messages VALUES(72,310017,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(73,310017,'insert','bet_matches','{"backward_quantity": 650000000, "block_index": 310017, "deadline": 1388000200, "fee_fraction_int": 5000000, "feed_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "forward_quantity": 750000000, "id": "274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9_f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c", "initial_value": 100.0, "leverage": 5040, "match_expire_index": 310026, "status": "pending", "target_value": 1.0, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx0_bet_type": 2, "tx0_block_index": 310016, "tx0_expiration": 10, "tx0_hash": "274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9", "tx0_index": 17, "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_bet_type": 3, "tx1_block_index": 310017, "tx1_expiration": 10, "tx1_hash": "f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c", "tx1_index": 18}',0);
INSERT INTO messages VALUES(74,310018,'insert','credits','{"action": "recredit forward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310018, "event": "274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9_f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c", "quantity": 750000000}',0);
INSERT INTO messages VALUES(75,310018,'insert','credits','{"action": "recredit backward quantity", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310018, "event": "274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9_f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c", "quantity": 650000000}',0);
INSERT INTO messages VALUES(76,310018,'update','bet_matches','{"bet_match_id": "274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9_f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c", "status": "expired"}',0);
INSERT INTO messages VALUES(77,310018,'insert','bet_match_expirations','{"bet_match_id": "274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9_f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c", "block_index": 310018, "tx0_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(78,310018,'insert','broadcasts','{"block_index": 310018, "fee_fraction_int": 5000000, "locked": false, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "text": "Unit Test", "timestamp": 1388000050, "tx_hash": "9419f0ab4bbbf7eb6bce2cfa731d619f4e583b228ede774db00a77fed6a97960", "tx_index": 19, "value": 99.86166}',0);
INSERT INTO messages VALUES(79,310019,'insert','broadcasts','{"block_index": 310019, "fee_fraction_int": 5000000, "locked": false, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "text": "Unit Test", "timestamp": 1388000101, "tx_hash": "84e21df5f3d10795c5439a66dda03399e4f6cb915f7c141e684565e9fb55bbdc", "tx_index": 20, "value": 100.343}',0);
INSERT INTO messages VALUES(80,310020,'insert','broadcasts','{"block_index": 310020, "fee_fraction_int": 5000000, "locked": false, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "text": "Unit Test", "timestamp": 1388000201, "tx_hash": "f63fdf467229e05304c42e373e215ef86c1bc4e6cc7d9d0615301168b32cede7", "tx_index": 21, "value": 2.0}',0);
INSERT INTO messages VALUES(81,310021,'insert','debits','{"action": "open order", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBB", "block_index": 310021, "event": "8b53787bd6551eddb5302769b48361275d1402039b46eb1ae87d1e90d3711e07", "quantity": 50000000}',0);
INSERT INTO messages VALUES(82,310021,'insert','orders','{"block_index": 310021, "expiration": 10, "expire_index": 310031, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 50000000, "get_remaining": 50000000, "give_asset": "BBBB", "give_quantity": 50000000, "give_remaining": 50000000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "tx_hash": "8b53787bd6551eddb5302769b48361275d1402039b46eb1ae87d1e90d3711e07", "tx_index": 22}',0);
INSERT INTO messages VALUES(83,310022,'insert','credits','{"action": "burn", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310022, "event": "5b1c6a89eb129c3193bc6c6e2876f9e5aaff3c65ef58d591fe743a5a59a51e94", "quantity": 56999887262}',0);
INSERT INTO messages VALUES(84,310022,'insert','burns','{"block_index": 310022, "burned": 38000000, "earned": 56999887262, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "5b1c6a89eb129c3193bc6c6e2876f9e5aaff3c65ef58d591fe743a5a59a51e94", "tx_index": 23}',0);
INSERT INTO messages VALUES(85,310023,'update','bets','{"status": "expired", "tx_hash": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a"}',0);
INSERT INTO messages VALUES(86,310023,'insert','credits','{"action": "recredit wager remaining", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310023, "event": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a", "quantity": 8500000}',0);
INSERT INTO messages VALUES(87,310023,'insert','bet_expirations','{"bet_hash": "0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a", "bet_index": 13, "block_index": 310023, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(88,310023,'insert','debits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBC", "block_index": 310023, "event": "07fd8a2913753c3ca53cddc3992bf2be36119b23082ba29a8c33192f09131594", "quantity": 10000}',0);
INSERT INTO messages VALUES(89,310023,'insert','credits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "BBBC", "block_index": 310023, "event": "07fd8a2913753c3ca53cddc3992bf2be36119b23082ba29a8c33192f09131594", "quantity": 10000}',0);
INSERT INTO messages VALUES(90,310023,'insert','sends','{"asset": "BBBC", "block_index": 310023, "destination": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "quantity": 10000, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "07fd8a2913753c3ca53cddc3992bf2be36119b23082ba29a8c33192f09131594", "tx_index": 24}',0);
INSERT INTO messages VALUES(91,310032,'update','orders','{"status": "expired", "tx_hash": "8b53787bd6551eddb5302769b48361275d1402039b46eb1ae87d1e90d3711e07"}',0);
INSERT INTO messages VALUES(92,310032,'insert','credits','{"action": "cancel order", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBB", "block_index": 310032, "event": "8b53787bd6551eddb5302769b48361275d1402039b46eb1ae87d1e90d3711e07", "quantity": 50000000}',0);
INSERT INTO messages VALUES(93,310032,'insert','order_expirations','{"block_index": 310032, "order_hash": "8b53787bd6551eddb5302769b48361275d1402039b46eb1ae87d1e90d3711e07", "order_index": 22, "source": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
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
INSERT INTO order_expirations VALUES(3,'e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310013);
INSERT INTO order_expirations VALUES(4,'9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310014);
INSERT INTO order_expirations VALUES(22,'8b53787bd6551eddb5302769b48361275d1402039b46eb1ae87d1e90d3711e07','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310032);
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
INSERT INTO order_matches VALUES('e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517_9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d',3,'e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',4,'9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BTC',50000000,'XCP',100000000,310002,310003,310003,10,10,310023,857142,'completed');
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
INSERT INTO orders VALUES(3,'e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517',310002,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BTC',50000000,0,'XCP',100000000,0,10,310012,0,0,1000000,142858,'expired');
INSERT INTO orders VALUES(4,'9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d',310003,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',105000000,5000000,'BTC',50000000,0,10,310013,900000,42858,10000,10000,'expired');
INSERT INTO orders VALUES(22,'8b53787bd6551eddb5302769b48361275d1402039b46eb1ae87d1e90d3711e07',310021,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',50000000,50000000,'XCP',50000000,50000000,10,310031,0,0,10000,10000,'expired');
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
INSERT INTO sends VALUES(2,'c8965f816ec849438f24ed603131b983cc9f3ab881686f44da4be853cf2ecb1d',310001,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','XCP',50000000,'valid');
INSERT INTO sends VALUES(8,'893ba7699b526e4a1a919ad7671e901d6fabf13ac22d2fb54f2bb427ed23f13e',310007,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBB',4000000,'valid');
INSERT INTO sends VALUES(9,'fe27b3bea249061f253b4219793d244dd41448e8ddff7177d3045f5eeefa3fe1',310008,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBC',526,'valid');
INSERT INTO sends VALUES(24,'07fd8a2913753c3ca53cddc3992bf2be36119b23082ba29a8c33192f09131594',310023,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBC',10000,'valid');
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
INSERT INTO transactions VALUES(1,'37f2ff45d34097306c63d4cbb9699354bd6ab9cac6cc362eb8be563de3e74981',310000,'505d8d82c4ced7daddef7ed0b05ba12ecc664176887b938ef56c6af276f3b30c',1419700000,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,10000,X'',1);
INSERT INTO transactions VALUES(2,'c8965f816ec849438f24ed603131b983cc9f3ab881686f44da4be853cf2ecb1d',310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',1419700100,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3',7800,10000,X'0000000000000000000000010000000002FAF080',1);
INSERT INTO transactions VALUES(3,'e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517',310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',1419700200,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,1000000,X'0000000A00000000000000000000000002FAF08000000000000000010000000005F5E100000A0000000000000000',1);
INSERT INTO transactions VALUES(4,'9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d',310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',1419700300,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000000A00000000000000010000000006422C4000000000000000000000000002FAF080000A00000000000DBBA0',1);
INSERT INTO transactions VALUES(5,'6dff822c561bf6ff5504a16e54cc3bd8a591f294fbd7a404ed60e7a7b7524988',310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',1419700400,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',50000000,10000,X'0000000BE1C19FEF00AA067D54FCD72239999D499470C41F878807BB67E681A03EE615179BC459C9D72BCC916E391D7D393CABB21FB3EDB9369837452BABC6F0E0C9D83D',1);
INSERT INTO transactions VALUES(6,'39dc01835ecabc07f3f7390f692dfbf495adfab0f3bedda4ddc6647904c7e719',310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',1419700500,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'000000140000000000004767000000003B9ACA000100000000000000000000',1);
INSERT INTO transactions VALUES(7,'ac50584491e6a6f76dfb70b23ffd0cbc1f06426126588b8477b26064eba41aa2',310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',1419700600,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'00000014000000000000476800000000000186A00000000000000000000006666F6F626172',1);
INSERT INTO transactions VALUES(8,'893ba7699b526e4a1a919ad7671e901d6fabf13ac22d2fb54f2bb427ed23f13e',310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',1419700700,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3',7800,10000,X'00000000000000000000476700000000003D0900',1);
INSERT INTO transactions VALUES(9,'fe27b3bea249061f253b4219793d244dd41448e8ddff7177d3045f5eeefa3fe1',310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',1419700800,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3',7800,10000,X'000000000000000000004768000000000000020E',1);
INSERT INTO transactions VALUES(10,'78f94515b5769fa354cbd5b857e48665f1f826ac65eb18c34ad958f85e29a6dd',310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',1419700900,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'00000032000000000000025800000000000047670000000000000001',1);
INSERT INTO transactions VALUES(11,'25ec88deb553d89c45619a83794e060a76953a7fefbdbba20df4009300c37550',310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',1419701000,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'00000032000000000000032000000000000047680000000000000001',1);
INSERT INTO transactions VALUES(12,'c51e2772404042d1d4ccbaf4cb56b22d990943172fe2c03b12241ac26d552bff',310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',1419701100,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000001E52BB33004059000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(13,'0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a',310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',1419701200,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000052BB33640000000002FAF08000000000017D7840000000000000000000003B100000000A',1);
INSERT INTO transactions VALUES(14,'64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78',310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',1419701300,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000152BB336400000000017D78400000000002793D60000000000000000000003B100000000A',1);
INSERT INTO transactions VALUES(15,'11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d',310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',1419701400,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000052BB33640000000008F0D1800000000014DC93800000000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(16,'c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460',310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',1419701500,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000152BB33640000000014DC93800000000008F0D1800000000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(17,'274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9',310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',1419701600,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000252BB33C8000000002CB417800000000026BE36803FF0000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(18,'f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c',310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',1419701700,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000352BB33C80000000026BE3680000000002CB417803FF0000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(19,'9419f0ab4bbbf7eb6bce2cfa731d619f4e583b228ede774db00a77fed6a97960',310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',1419701800,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000001E52BB33324058F7256FFC115E004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(20,'84e21df5f3d10795c5439a66dda03399e4f6cb915f7c141e684565e9fb55bbdc',310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',1419701900,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000001E52BB3365405915F3B645A1CB004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(21,'f63fdf467229e05304c42e373e215ef86c1bc4e6cc7d9d0615301168b32cede7',310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',1419702000,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000001E52BB33C94000000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(22,'8b53787bd6551eddb5302769b48361275d1402039b46eb1ae87d1e90d3711e07',310021,'7c2460bb32c5749c856486393239bf7a0ac789587ac71f32e7237910da8097f2',1419702100,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000000A00000000000047670000000002FAF08000000000000000010000000002FAF080000A0000000000000000',1);
INSERT INTO transactions VALUES(23,'5b1c6a89eb129c3193bc6c6e2876f9e5aaff3c65ef58d591fe743a5a59a51e94',310022,'44435f9a99a0aa12a9bfabdc4cb8119f6ea6a6e1350d2d65445fb66a456db5fc',1419702200,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','mvCounterpartyXXXXXXXXXXXXXXW24Hef',100000000,10000,X'',1);
INSERT INTO transactions VALUES(24,'07fd8a2913753c3ca53cddc3992bf2be36119b23082ba29a8c33192f09131594',310023,'d8cf5bec1bbcab8ca4f495352afde3b6572b7e1d61b3976872ebb8e9d30ccb08',1419702300,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3',7800,10000,X'0000000000000000000047680000000000002710',1);
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
INSERT INTO undolog VALUES(4,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=93000000000 WHERE rowid=1');
INSERT INTO undolog VALUES(5,'DELETE FROM debits WHERE rowid=1');
INSERT INTO undolog VALUES(6,'DELETE FROM balances WHERE rowid=2');
INSERT INTO undolog VALUES(7,'DELETE FROM credits WHERE rowid=2');
INSERT INTO undolog VALUES(8,'DELETE FROM sends WHERE rowid=2');
INSERT INTO undolog VALUES(9,'DELETE FROM orders WHERE rowid=1');
INSERT INTO undolog VALUES(10,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92950000000 WHERE rowid=1');
INSERT INTO undolog VALUES(11,'DELETE FROM debits WHERE rowid=2');
INSERT INTO undolog VALUES(12,'DELETE FROM orders WHERE rowid=2');
INSERT INTO undolog VALUES(13,'UPDATE orders SET tx_index=3,tx_hash=''e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517'',block_index=310002,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',give_asset=''BTC'',give_quantity=50000000,give_remaining=50000000,get_asset=''XCP'',get_quantity=100000000,get_remaining=100000000,expiration=10,expire_index=310012,fee_required=0,fee_required_remaining=0,fee_provided=1000000,fee_provided_remaining=1000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(14,'UPDATE orders SET tx_index=4,tx_hash=''9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d'',block_index=310003,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',give_asset=''XCP'',give_quantity=105000000,give_remaining=105000000,get_asset=''BTC'',get_quantity=50000000,get_remaining=50000000,expiration=10,expire_index=310013,fee_required=900000,fee_required_remaining=900000,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(15,'DELETE FROM order_matches WHERE rowid=1');
INSERT INTO undolog VALUES(16,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92845000000 WHERE rowid=1');
INSERT INTO undolog VALUES(17,'DELETE FROM credits WHERE rowid=3');
INSERT INTO undolog VALUES(18,'UPDATE order_matches SET id=''e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517_9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d'',tx0_index=3,tx0_hash=''e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517'',tx0_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx1_index=4,tx1_hash=''9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d'',tx1_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',forward_asset=''BTC'',forward_quantity=50000000,backward_asset=''XCP'',backward_quantity=100000000,tx0_block_index=310002,tx1_block_index=310003,block_index=310003,tx0_expiration=10,tx1_expiration=10,match_expire_index=310023,fee_paid=857142,status=''pending'' WHERE rowid=1');
INSERT INTO undolog VALUES(19,'DELETE FROM btcpays WHERE rowid=5');
INSERT INTO undolog VALUES(20,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92945000000 WHERE rowid=1');
INSERT INTO undolog VALUES(21,'DELETE FROM debits WHERE rowid=3');
INSERT INTO undolog VALUES(22,'DELETE FROM assets WHERE rowid=3');
INSERT INTO undolog VALUES(23,'DELETE FROM issuances WHERE rowid=6');
INSERT INTO undolog VALUES(24,'DELETE FROM balances WHERE rowid=3');
INSERT INTO undolog VALUES(25,'DELETE FROM credits WHERE rowid=4');
INSERT INTO undolog VALUES(26,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92895000000 WHERE rowid=1');
INSERT INTO undolog VALUES(27,'DELETE FROM debits WHERE rowid=4');
INSERT INTO undolog VALUES(28,'DELETE FROM assets WHERE rowid=4');
INSERT INTO undolog VALUES(29,'DELETE FROM issuances WHERE rowid=7');
INSERT INTO undolog VALUES(30,'DELETE FROM balances WHERE rowid=4');
INSERT INTO undolog VALUES(31,'DELETE FROM credits WHERE rowid=5');
INSERT INTO undolog VALUES(32,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''BBBB'',quantity=1000000000 WHERE rowid=3');
INSERT INTO undolog VALUES(33,'DELETE FROM debits WHERE rowid=5');
INSERT INTO undolog VALUES(34,'DELETE FROM balances WHERE rowid=5');
INSERT INTO undolog VALUES(35,'DELETE FROM credits WHERE rowid=6');
INSERT INTO undolog VALUES(36,'DELETE FROM sends WHERE rowid=8');
INSERT INTO undolog VALUES(37,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''BBBC'',quantity=100000 WHERE rowid=4');
INSERT INTO undolog VALUES(38,'DELETE FROM debits WHERE rowid=6');
INSERT INTO undolog VALUES(39,'DELETE FROM balances WHERE rowid=6');
INSERT INTO undolog VALUES(40,'DELETE FROM credits WHERE rowid=7');
INSERT INTO undolog VALUES(41,'DELETE FROM sends WHERE rowid=9');
INSERT INTO undolog VALUES(42,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92845000000 WHERE rowid=1');
INSERT INTO undolog VALUES(43,'DELETE FROM debits WHERE rowid=7');
INSERT INTO undolog VALUES(44,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92844999976 WHERE rowid=1');
INSERT INTO undolog VALUES(45,'DELETE FROM debits WHERE rowid=8');
INSERT INTO undolog VALUES(46,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3'',asset=''XCP'',quantity=50000000 WHERE rowid=2');
INSERT INTO undolog VALUES(47,'DELETE FROM credits WHERE rowid=8');
INSERT INTO undolog VALUES(48,'DELETE FROM dividends WHERE rowid=10');
INSERT INTO undolog VALUES(49,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92844979976 WHERE rowid=1');
INSERT INTO undolog VALUES(50,'DELETE FROM debits WHERE rowid=9');
INSERT INTO undolog VALUES(51,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92844559176 WHERE rowid=1');
INSERT INTO undolog VALUES(52,'DELETE FROM debits WHERE rowid=10');
INSERT INTO undolog VALUES(53,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3'',asset=''XCP'',quantity=50000024 WHERE rowid=2');
INSERT INTO undolog VALUES(54,'DELETE FROM credits WHERE rowid=9');
INSERT INTO undolog VALUES(55,'DELETE FROM dividends WHERE rowid=11');
INSERT INTO undolog VALUES(56,'DELETE FROM broadcasts WHERE rowid=12');
INSERT INTO undolog VALUES(57,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92844539176 WHERE rowid=1');
INSERT INTO undolog VALUES(58,'DELETE FROM debits WHERE rowid=11');
INSERT INTO undolog VALUES(59,'DELETE FROM bets WHERE rowid=1');
INSERT INTO undolog VALUES(60,'UPDATE orders SET tx_index=3,tx_hash=''e1c19fef00aa067d54fcd72239999d499470c41f878807bb67e681a03ee61517'',block_index=310002,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',give_asset=''BTC'',give_quantity=50000000,give_remaining=0,get_asset=''XCP'',get_quantity=100000000,get_remaining=0,expiration=10,expire_index=310012,fee_required=0,fee_required_remaining=0,fee_provided=1000000,fee_provided_remaining=142858,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(61,'DELETE FROM order_expirations WHERE rowid=3');
INSERT INTO undolog VALUES(62,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92794539176 WHERE rowid=1');
INSERT INTO undolog VALUES(63,'DELETE FROM debits WHERE rowid=12');
INSERT INTO undolog VALUES(64,'DELETE FROM bets WHERE rowid=2');
INSERT INTO undolog VALUES(65,'UPDATE bets SET tx_index=13,tx_hash=''0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a'',block_index=310012,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=0,deadline=1388000100,wager_quantity=50000000,wager_remaining=50000000,counterwager_quantity=25000000,counterwager_remaining=25000000,target_value=0.0,leverage=15120,expiration=10,expire_index=310022,fee_fraction_int=5000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(66,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92769539176 WHERE rowid=1');
INSERT INTO undolog VALUES(67,'DELETE FROM credits WHERE rowid=10');
INSERT INTO undolog VALUES(68,'UPDATE bets SET tx_index=14,tx_hash=''64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78'',block_index=310013,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=1,deadline=1388000100,wager_quantity=25000000,wager_remaining=25000000,counterwager_quantity=41500000,counterwager_remaining=41500000,target_value=0.0,leverage=15120,expiration=10,expire_index=310023,fee_fraction_int=5000000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(69,'DELETE FROM bet_matches WHERE rowid=1');
INSERT INTO undolog VALUES(70,'UPDATE orders SET tx_index=4,tx_hash=''9bc459c9d72bcc916e391d7d393cabb21fb3edb9369837452babc6f0e0c9d83d'',block_index=310003,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',give_asset=''XCP'',give_quantity=105000000,give_remaining=5000000,get_asset=''BTC'',get_quantity=50000000,get_remaining=0,expiration=10,expire_index=310013,fee_required=900000,fee_required_remaining=42858,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(71,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92773789176 WHERE rowid=1');
INSERT INTO undolog VALUES(72,'DELETE FROM credits WHERE rowid=11');
INSERT INTO undolog VALUES(73,'DELETE FROM order_expirations WHERE rowid=4');
INSERT INTO undolog VALUES(74,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92778789176 WHERE rowid=1');
INSERT INTO undolog VALUES(75,'DELETE FROM credits WHERE rowid=12');
INSERT INTO undolog VALUES(76,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92820289176 WHERE rowid=1');
INSERT INTO undolog VALUES(77,'DELETE FROM credits WHERE rowid=13');
INSERT INTO undolog VALUES(78,'UPDATE bet_matches SET id=''0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a_64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78'',tx0_index=13,tx0_hash=''0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a'',tx0_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx1_index=14,tx1_hash=''64e1f1f443ebfd3ca20600ab3ad57791340bc6b8034795d7f009346bccc1aa78'',tx1_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx0_bet_type=0,tx1_bet_type=1,feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',initial_value=100,deadline=1388000100,target_value=0.0,leverage=15120,forward_quantity=41500000,backward_quantity=20750000,tx0_block_index=310012,tx1_block_index=310013,block_index=310013,tx0_expiration=10,tx1_expiration=10,match_expire_index=310022,fee_fraction_int=5000000,status=''pending'' WHERE rowid=1');
INSERT INTO undolog VALUES(79,'DELETE FROM bet_match_expirations WHERE rowid=1');
INSERT INTO undolog VALUES(80,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(81,'DELETE FROM debits WHERE rowid=13');
INSERT INTO undolog VALUES(82,'DELETE FROM bets WHERE rowid=3');
INSERT INTO undolog VALUES(83,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92691039176 WHERE rowid=1');
INSERT INTO undolog VALUES(84,'DELETE FROM debits WHERE rowid=14');
INSERT INTO undolog VALUES(85,'DELETE FROM bets WHERE rowid=4');
INSERT INTO undolog VALUES(86,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(87,'DELETE FROM credits WHERE rowid=14');
INSERT INTO undolog VALUES(88,'UPDATE bets SET tx_index=15,tx_hash=''11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d'',block_index=310014,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=0,deadline=1388000100,wager_quantity=150000000,wager_remaining=150000000,counterwager_quantity=350000000,counterwager_remaining=350000000,target_value=0.0,leverage=5040,expiration=10,expire_index=310024,fee_fraction_int=5000000,status=''open'' WHERE rowid=3');
INSERT INTO undolog VALUES(89,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(90,'DELETE FROM credits WHERE rowid=15');
INSERT INTO undolog VALUES(91,'UPDATE bets SET tx_index=16,tx_hash=''c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460'',block_index=310015,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=1,deadline=1388000100,wager_quantity=350000000,wager_remaining=350000000,counterwager_quantity=150000000,counterwager_remaining=150000000,target_value=0.0,leverage=5040,expiration=10,expire_index=310025,fee_fraction_int=5000000,status=''open'' WHERE rowid=4');
INSERT INTO undolog VALUES(92,'DELETE FROM bet_matches WHERE rowid=2');
INSERT INTO undolog VALUES(93,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(94,'DELETE FROM credits WHERE rowid=16');
INSERT INTO undolog VALUES(95,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92491039176 WHERE rowid=1');
INSERT INTO undolog VALUES(96,'DELETE FROM credits WHERE rowid=17');
INSERT INTO undolog VALUES(97,'UPDATE bet_matches SET id=''11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d_c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460'',tx0_index=15,tx0_hash=''11bc78cc61d9ca7cb5fec0bbbe04caeae2037a98bf04cf6d3e0f4a7d98f5707d'',tx0_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx1_index=16,tx1_hash=''c5c6127eb0ba121d4b5d9c7e3b372634e32ac8cc4d4299e6ae9233afe43c5460'',tx1_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx0_bet_type=0,tx1_bet_type=1,feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',initial_value=100,deadline=1388000100,target_value=0.0,leverage=5040,forward_quantity=150000000,backward_quantity=350000000,tx0_block_index=310014,tx1_block_index=310015,block_index=310015,tx0_expiration=10,tx1_expiration=10,match_expire_index=310024,fee_fraction_int=5000000,status=''pending'' WHERE rowid=2');
INSERT INTO undolog VALUES(98,'DELETE FROM bet_match_expirations WHERE rowid=2');
INSERT INTO undolog VALUES(99,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(100,'DELETE FROM debits WHERE rowid=15');
INSERT INTO undolog VALUES(101,'DELETE FROM bets WHERE rowid=5');
INSERT INTO undolog VALUES(102,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92091039176 WHERE rowid=1');
INSERT INTO undolog VALUES(103,'DELETE FROM debits WHERE rowid=16');
INSERT INTO undolog VALUES(104,'DELETE FROM bets WHERE rowid=6');
INSERT INTO undolog VALUES(105,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(106,'DELETE FROM credits WHERE rowid=18');
INSERT INTO undolog VALUES(107,'UPDATE bets SET tx_index=17,tx_hash=''274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9'',block_index=310016,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=2,deadline=1388000200,wager_quantity=750000000,wager_remaining=750000000,counterwager_quantity=650000000,counterwager_remaining=650000000,target_value=1.0,leverage=5040,expiration=10,expire_index=310026,fee_fraction_int=5000000,status=''open'' WHERE rowid=5');
INSERT INTO undolog VALUES(108,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(109,'DELETE FROM credits WHERE rowid=19');
INSERT INTO undolog VALUES(110,'UPDATE bets SET tx_index=18,tx_hash=''f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c'',block_index=310017,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=3,deadline=1388000200,wager_quantity=650000000,wager_remaining=650000000,counterwager_quantity=750000000,counterwager_remaining=750000000,target_value=1.0,leverage=5040,expiration=10,expire_index=310027,fee_fraction_int=5000000,status=''open'' WHERE rowid=6');
INSERT INTO undolog VALUES(111,'DELETE FROM bet_matches WHERE rowid=3');
INSERT INTO undolog VALUES(112,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(113,'DELETE FROM credits WHERE rowid=20');
INSERT INTO undolog VALUES(114,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92191039176 WHERE rowid=1');
INSERT INTO undolog VALUES(115,'DELETE FROM credits WHERE rowid=21');
INSERT INTO undolog VALUES(116,'UPDATE bet_matches SET id=''274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9_f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c'',tx0_index=17,tx0_hash=''274a5b05b135bd9af40c6c9751d837784f53bcc6cf940e87cee449782de9f4e9'',tx0_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx1_index=18,tx1_hash=''f61ffdef0cb63ea09da9458b028d3d73a918a0f2de9d0e6c02d3e765ea15c50c'',tx1_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx0_bet_type=2,tx1_bet_type=3,feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',initial_value=100,deadline=1388000200,target_value=1.0,leverage=5040,forward_quantity=750000000,backward_quantity=650000000,tx0_block_index=310016,tx1_block_index=310017,block_index=310017,tx0_expiration=10,tx1_expiration=10,match_expire_index=310026,fee_fraction_int=5000000,status=''pending'' WHERE rowid=3');
INSERT INTO undolog VALUES(117,'DELETE FROM bet_match_expirations WHERE rowid=3');
INSERT INTO undolog VALUES(118,'DELETE FROM broadcasts WHERE rowid=19');
INSERT INTO undolog VALUES(119,'DELETE FROM broadcasts WHERE rowid=20');
INSERT INTO undolog VALUES(120,'DELETE FROM broadcasts WHERE rowid=21');
INSERT INTO undolog VALUES(121,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''BBBB'',quantity=996000000 WHERE rowid=3');
INSERT INTO undolog VALUES(122,'DELETE FROM debits WHERE rowid=17');
INSERT INTO undolog VALUES(123,'DELETE FROM orders WHERE rowid=3');
INSERT INTO undolog VALUES(124,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(125,'DELETE FROM credits WHERE rowid=22');
INSERT INTO undolog VALUES(126,'DELETE FROM burns WHERE rowid=23');
INSERT INTO undolog VALUES(127,'UPDATE bets SET tx_index=13,tx_hash=''0e0de93eee84d5b96c696cf0c3d84b6ff1f197fa13718ea3faaf68e4648bda3a'',block_index=310012,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=0,deadline=1388000100,wager_quantity=50000000,wager_remaining=8500000,counterwager_quantity=25000000,counterwager_remaining=4250000,target_value=0.0,leverage=15120,expiration=10,expire_index=310022,fee_fraction_int=5000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(128,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=149840926438 WHERE rowid=1');
INSERT INTO undolog VALUES(129,'DELETE FROM credits WHERE rowid=23');
INSERT INTO undolog VALUES(130,'DELETE FROM bet_expirations WHERE rowid=13');
INSERT INTO undolog VALUES(131,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''BBBC'',quantity=99474 WHERE rowid=4');
INSERT INTO undolog VALUES(132,'DELETE FROM debits WHERE rowid=18');
INSERT INTO undolog VALUES(133,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3'',asset=''BBBC'',quantity=526 WHERE rowid=6');
INSERT INTO undolog VALUES(134,'DELETE FROM credits WHERE rowid=24');
INSERT INTO undolog VALUES(135,'DELETE FROM sends WHERE rowid=24');
INSERT INTO undolog VALUES(136,'UPDATE orders SET tx_index=22,tx_hash=''8b53787bd6551eddb5302769b48361275d1402039b46eb1ae87d1e90d3711e07'',block_index=310021,source=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',give_asset=''BBBB'',give_quantity=50000000,give_remaining=50000000,get_asset=''XCP'',get_quantity=50000000,get_remaining=50000000,expiration=10,expire_index=310031,fee_required=0,fee_required_remaining=0,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=3');
INSERT INTO undolog VALUES(137,'UPDATE balances SET address=''1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''BBBB'',quantity=946000000 WHERE rowid=3');
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
