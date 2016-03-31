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
INSERT INTO balances VALUES('3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',149849426438);
INSERT INTO balances VALUES('3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','XCP',50420824);
INSERT INTO balances VALUES('3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',996000000);
INSERT INTO balances VALUES('3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBC',89474);
INSERT INTO balances VALUES('3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBB',4000000);
INSERT INTO balances VALUES('3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBC',10526);
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
INSERT INTO bet_expirations VALUES(13,'474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310023);
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
INSERT INTO bet_match_expirations VALUES('474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217_b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310014);
INSERT INTO bet_match_expirations VALUES('71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb_836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310016);
INSERT INTO bet_match_expirations VALUES('39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b_0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310018);
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
INSERT INTO bet_matches VALUES('474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217_b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a',13,'474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',14,'b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,1,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',100,1388000100,0.0,15120,41500000,20750000,310012,310013,310013,10,10,310022,5000000,'expired');
INSERT INTO bet_matches VALUES('71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb_836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5',15,'71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',16,'836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,1,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',100,1388000100,0.0,5040,150000000,350000000,310014,310015,310015,10,10,310024,5000000,'expired');
INSERT INTO bet_matches VALUES('39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b_0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0',17,'39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',18,'0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',2,3,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',100,1388000200,1.0,5040,750000000,650000000,310016,310017,310017,10,10,310026,5000000,'expired');
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
INSERT INTO bets VALUES(13,'474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217',310012,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,1388000100,50000000,8500000,25000000,4250000,0.0,15120,10,310022,5000000,'expired');
INSERT INTO bets VALUES(14,'b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a',310013,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1,1388000100,25000000,4250000,41500000,0,0.0,15120,10,310023,5000000,'filled');
INSERT INTO bets VALUES(15,'71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb',310014,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,1388000100,150000000,0,350000000,0,0.0,5040,10,310024,5000000,'filled');
INSERT INTO bets VALUES(16,'836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5',310015,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1,1388000100,350000000,0,150000000,0,0.0,5040,10,310025,5000000,'filled');
INSERT INTO bets VALUES(17,'39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b',310016,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',2,1388000200,750000000,0,650000000,0,1.0,5040,10,310026,5000000,'filled');
INSERT INTO bets VALUES(18,'0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0',310017,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',3,1388000200,650000000,0,750000000,0,1.0,5040,10,310027,5000000,'filled');
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
INSERT INTO blocks VALUES(310000,'505d8d82c4ced7daddef7ed0b05ba12ecc664176887b938ef56c6af276f3b30c',1419700000,NULL,NULL,'61b8d900911023a49473738d5186481759c83d199e5194bc82c9452e84906639','da0e7a921dce9a53bcf5d2c881d2d533037e723659ece6eb337e67068aefe1e4','5e8cdf86e33dd69e3a5ecee23f373b97c63bbc56db5bd8136d4662d7ead61f8d');
INSERT INTO blocks VALUES(310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',1419700100,NULL,NULL,'ebe0f12f47c486891f6459bdbb5d88efd4ca598208678a830179370ba1830687','e494165fce4b8e14398bc8dcab5505baeb5fff9e8c5baa21adcaf929db0c766c','f933ab9f2c8a7a8c3e9fe49eb9b08b0c85d63c405d26a8127233a37445e28e73');
INSERT INTO blocks VALUES(310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',1419700200,NULL,NULL,'5ee662e5b5901393cf880b37a52ace39c55f2d6474aba20fd0529120e298f654','255fae5bb3e7e4d5c305d1069c26905691f1ac525d43f09e04fc15caad91e655','774a28e5c415d1d5ab0b5ff33c78d55473c0e5eb2b7298c2c37ebc50bde36937');
INSERT INTO blocks VALUES(310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',1419700300,NULL,NULL,'ab20efe1b47b7835255641e57894fb59005742fae3cc3823cb2e99050f6baa6c','2ae63dce0e4cc4efbc73a4d6cc4201ff32f84e20241f995a9f0d00a31a3ddadd','6284c133a58f53eacb831bfb3b112cd69d7cb275b6f1ae774d31db896296468c');
INSERT INTO blocks VALUES(310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',1419700400,NULL,NULL,'9c1ae7470ded5d3298dfce8a3a09d839e0edc53b58e0c498ea916cc558f74ac0','f51bebf2fb311a548dc27c2b4417cc07b4d500a21f2a8556a8787d200bc8198f','690ba4f725823758fc36c18945557e481e9318c6333e7a13e5747d5cf72f9962');
INSERT INTO blocks VALUES(310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',1419700500,NULL,NULL,'703760c323dd2de22d8ae32743e35d121bf2ad7b07a1cfd7f6639e40d88a607c','b9902e860e88e6ace5385f4c769170597f05d9d924a31e432f288ab34e8fb376','6cc3d6e8ae4c26afae6650860fb854269c6443266380fa395e0e1f2d0a5451b2');
INSERT INTO blocks VALUES(310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',1419700600,NULL,NULL,'f54b1744002540d32f13bf6357ed1abd56671b1e6bd0008f8edb8df39a17b8bb','a64b8726d49ec92d1b5237081cdb293849a45e99af0047e822304d209ab1db0b','b2792d6f61bde93232bb0e4d8b7323f2bae8e135767d3644313322ee76d11f58');
INSERT INTO blocks VALUES(310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',1419700700,NULL,NULL,'d96d7a605f24dd4c5a1dffdd11da22975337c8acbcb26b5c3534e5e0ded0fa9c','fcc0c7971353182c4ffbcba24eed6d1908bd1be55aba1f1e93a553919b6a5ee6','ce920103ab9bd55cc8757bc29de03568fe954309d83d9d651600ab029105a854');
INSERT INTO blocks VALUES(310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',1419700800,NULL,NULL,'f6e0dd981f49bf4b4a8d7d51d82f1a556aec06b5725c4fdb3716835fdf7a9d76','315d88fd1088791d1f9b6ca3dd27086428f9e2152a9f7fb490834b77ee476295','f2daac9b191c6ff1c963489b5f647c7f688098f7fb49f5c3c0e47204efbd7d29');
INSERT INTO blocks VALUES(310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',1419700900,NULL,NULL,'d40850196547e864aad2086202712fe7fa5fc7ecb1a219e2a0831414546160ea','4f6c3210258b7fa37465b04ef663c808236a9eeeaf827137527726d45922a23a','783d44ec9da2abdc0b4cfdbf7b1634cb3f1e6bffb637076e8db6dd4f5097e9fa');
INSERT INTO blocks VALUES(310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',1419701000,NULL,NULL,'7102ab487dd276b7d9e9edbeca6476ff49097a0e4bd4de8f78783b765f06881e','32178f18641b016b5ff25576473f8220132920cee75c0fcb435e6a3816e34072','2336480a9d5ef308a5c72a012eacb10f247808388ed30384bf0f385daaf2c03f');
INSERT INTO blocks VALUES(310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',1419701100,NULL,NULL,'d6bdac57d1137296d9fd89e01af21273e8c3b498d8d07c5dc36416c259507233','0312287bb149a95eeafa1429085f92d285abc97e4e49328c9d612ed937d7bfa6','f14fbfbd6525e94e09d9d939e37760784315dc3e6afff6e2fb62c6ebd65bbbee');
INSERT INTO blocks VALUES(310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',1419701200,NULL,NULL,'8e1aa013f3f569d4ddbdca2185eea1709e3c03a8a6422785884d7f0965f2d9cf','1a62bd7c7f1e6aefe099075f713ce6030470a37814e7002d8cc3aff5eace7167','967763e990e98a97b7ebb1256d08a3ef1be49f848030f43789abdd8ea28f71dd');
INSERT INTO blocks VALUES(310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',1419701300,NULL,NULL,'8475956c6345170ac29d3b04fa1a814bb408fe46274a7e7afd6d1ca5009b992d','fdcf6d36ae1a9422666e3fbe36aee353ae981658e0e40ad45570a5e0f3c9a3b5','bfc58c435a499c4d1000def89d767b199079aa65e5570a6240ba541da5309b7d');
INSERT INTO blocks VALUES(310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',1419701400,NULL,NULL,'1e93e72eed28c5ff350163c1d4c26a6e3db3c24150e19ba447da40942a0b3dfc','820d044f50b0cfe71e8e5c1ff27ab83930a70e84e79e652d129424f065d21a11','b0204c9af7196f3219c3cd13945810d029b60d96becb0f8c7708ac30f650bd7c');
INSERT INTO blocks VALUES(310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',1419701500,NULL,NULL,'5046670c02bc2ac0dfea033c19c4cf48418d6d1198b1094534c6179ccdc71e1b','70ab87e87c1c6070b1921b3b2c4126a76a70de3e553c7d0ac6c6b85693ab7d04','3e3931974b605a15f2404b697962e72c58b57ef9e2a5576a7144a38664b744b2');
INSERT INTO blocks VALUES(310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',1419701600,NULL,NULL,'75ffd0f4297744f5e6a7e3a4fc6452fc86fffe6e3d9096decd6bc4ee669f2f2f','ad8759b1a8f49b087524bee4df90453ff0bf1ae03eab253e946b31db6bb9bf74','75c93b127281ae8318ec3202423d5a356a4fa6f869c6f64f78d212a30249a320');
INSERT INTO blocks VALUES(310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',1419701700,NULL,NULL,'f1af3bc15787c0348710ae7860362c60f983c8590f52d62175419665d395e6f0','40149d0444c196b489111e38e99ba62bea9d003ece070f20a83f97e93cc06a04','dd4e053871e9dcbd83fc0dcdffc6b3da2cd437d2a743556b146cafb6b5a691d4');
INSERT INTO blocks VALUES(310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',1419701800,NULL,NULL,'37faeda2f2f693768bef75f4412d7c8bb0aef56fc8202c14800b8ee8b8a86796','6eec45554b35747991648e3e7b2de6ee900b12ea9f5fcb6c8cf57516063aa429','94b336e59b2ae00df7c4d2c633b50560d8b6ed5240e0ae0dd0288e9423445488');
INSERT INTO blocks VALUES(310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',1419701900,NULL,NULL,'4cc7dcaac0526e942f4a0168d928341d81421313dae4a2f770a4a7319dbeb928','0604343a465b71842721bf9b28b921b2373d856025df0913f1e688f0bb7386cf','9469d00b1afc09bca5eb86032f393f18632675fd7b22f98dfecc338c70b73cb2');
INSERT INTO blocks VALUES(310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',1419702000,NULL,NULL,'efa54705a7c3a111b51abc7507ad5ecc592d273ea385645bb98e26fecb215700','86dfa0a017478dd175110bc9d4d76030c4ba4bbddfb9c60d3e5e14dd8d439cf3','71809ccec4898ab8b3d386dfb38e620d9234aafa623669aa736074f7d5c1d056');
INSERT INTO blocks VALUES(310021,'7c2460bb32c5749c856486393239bf7a0ac789587ac71f32e7237910da8097f2',1419702100,NULL,NULL,'c7c8e81768bcddd38848cb4cde39aa16154e1f298a9122736be7a079bd3b269d','62c5019e0c642f7a0ca80d5d1639533cba1be21e48c1c29972ca61f56f7b3c98','8e18e3640dae50b1cebb3f6c9957b92ecab6a1c170bb3bf7cdc45e2048e7b84b');
INSERT INTO blocks VALUES(310022,'44435f9a99a0aa12a9bfabdc4cb8119f6ea6a6e1350d2d65445fb66a456db5fc',1419702200,NULL,NULL,'3f8ca81c571d5290761df8ed30d6ff93c4fc9b9fa1d7b8a8c39fa4ddbefe2986','c4dd986396b4dd62b4e3dc5e12bb7fe0b6ce3b7c3a509eab9832037c080b0c33','af860efebe8a9f414016876006f6a5eb465bc3084c9bb740223f033533cc0ffa');
INSERT INTO blocks VALUES(310023,'d8cf5bec1bbcab8ca4f495352afde3b6572b7e1d61b3976872ebb8e9d30ccb08',1419702300,NULL,NULL,'b84e92de0a7c0e717e510234187c6f3ba891adbce990c76864302bd2a12794a4','51bf14c36983259066cd5b1dc953c09d3dd02ce9cf772c8970096a737add8037','c94edc89e765acf8405c3ab9bcb739b7fe6d971455905c7fb476c033e121e53d');
INSERT INTO blocks VALUES(310024,'b03042b4e18a222b4c8d1e9e1970d93e6e2a2d41686d227ff8ecf0a839223dc5',1419702400,NULL,NULL,'aca52c30f08ad2316b8c7bb5870d8ec3cb2a4c9d343faf3b751e332e58113d31','c77cdbf49544e8b50512f67604139dd0b4a49c22f22778d265b6f08e96b1b0e6','a8e043557615390ed077bd1c327293f6703554bb8eaa4653bdaa10d801179fa5');
INSERT INTO blocks VALUES(310025,'a872e560766832cc3b4f7f222228cb6db882ce3c54f6459f62c71d5cd6e90666',1419702500,NULL,NULL,'772d24cc81a7afbe6329f81681f8905a7be940b3f1cd56e7399a3eb37a5e229f','5fe02f61c235affd01f5ae0c3f09928af49c32f683e61a0ce4a8c9bd1227b11f','c7e1b7e68b5462b9e60157ebc58311942e4661b2956ea49ee76d7e6ed24ff466');
INSERT INTO blocks VALUES(310026,'6c96350f6f2f05810f19a689de235eff975338587194a36a70dfd0fcd490941a',1419702600,NULL,NULL,'6311c00f675ed4c8b0372dd95b5aee72e4e1ef0d81490ec9d2fac4747182bdbe','cd9bec9d30ba821b9a6ccefd28d7b493d97bbb3ba0f90be9ecc272e298a1eaf2','d92967761da33208265f1b8da840659c445a76cdbefca66aa8d2c38904375d55');
INSERT INTO blocks VALUES(310027,'d7acfac66df393c4482a14c189742c0571b89442eb7f817b34415a560445699e',1419702700,NULL,NULL,'211da56d44c2c88365b90b8aae55e2f7419bad532ce4858cb7d7e7062c2f7424','d70322dd4ff946923af90e81909815bdcbbf15c579f03519ad59ca1ab53cc3da','42ab09c149a503ae068d25283818799690c9e7009e007cd55a91f1b89328b531');
INSERT INTO blocks VALUES(310028,'02409fcf8fa06dafcb7f11e38593181d9c42cc9d5e2ddc304d098f990bd9530b',1419702800,NULL,NULL,'cf752321327daa7c0e23a4a13533290ebdea215a1ba84f7cb17d576182be1946','942360e0641403bec3398b6a06bdae9f8c7f015ccfcdcc18f8901486d9654107','0d5dd367828086d91c16f7225b13b1ace37a7ce5d9427460e3dc6985992e00c3');
INSERT INTO blocks VALUES(310029,'3c739fa8b40c118d5547ea356ee8d10ee2898871907643ec02e5db9d00f03cc6',1419702900,NULL,NULL,'b4a8d158d15cc82ed42f83733a6a57b56de91e0cb82ceeb11e445c1203cc502e','4c6d3ffc815fce37935ec193520a8d10e76340827178f9a4db81d3687df4b58b','a2d501feadc1eeb2bb8afa0cfb325b46881377721184c0ee665ba6c32cff2c16');
INSERT INTO blocks VALUES(310030,'d5071cddedf89765ee0fd58f209c1c7d669ba8ea66200a57587da8b189b9e4f5',1419703000,NULL,NULL,'5557f4182c060be13e138156a4c5cea4f8f3c2cdba505573791dea241fc297c7','6181c8d4a896e51245b8998619f817ba6fa01d3037515c99d6feaa1930514e37','bc4346a8295355dddb4fb08a2159f54e070ae3dfd986fe3a847d83700374ab5c');
INSERT INTO blocks VALUES(310031,'0b02b10f41380fff27c543ea8891ecb845bf7a003ac5c87e15932aff3bfcf689',1419703100,NULL,NULL,'fc83b14128510d8bb5c745dbf013b47620cead74c1a2cc40eb27168a18b2134c','bda5ddeee0bc0fc0b01fa33c9f19d0612fe940e19090a80423167a5815fa9e3f','d0fc95fce155273a301f255bce10014114bd60e6a54784cfbb5c58d19654db82');
INSERT INTO blocks VALUES(310032,'66346be81e6ba04544f2ae643b76c2b7b1383f038fc2636e02e49dc7ec144074',1419703200,NULL,NULL,'8028e2ec89fb0e88943bbc2772191c78adf99e0f3394634fc44c8101134e6d1b','93fd0f9f32b64ee79c66301c36d2ffa549e75cbe6d72c44e86d7bb42c5848e16','e70bb417a0e40f35eaf47197eb34fbe3b7d2c89f45e0815f7db24c409ea8bced');
INSERT INTO blocks VALUES(310033,'999c65df9661f73e8c01f1da1afda09ac16788b72834f0ff5ea3d1464afb4707',1419703300,NULL,NULL,'9d61b0ce28a3e980772a4aa9f1c14b170c120edae5017cdad14792f109dcb25b','08a268506a2a90911b7db5cf047abdeccbe6aadda758d7e82d0035b4b8505032','f8053ca31c751f59d7d969650794b6914866ccd9cd7d497ba8ca4382e3e7f63f');
INSERT INTO blocks VALUES(310034,'f552edd2e0a648230f3668e72ddf0ddfb1e8ac0f4c190f91b89c1a8c2e357208',1419703400,NULL,NULL,'9643aeee2e7ccfd498cddb0ebfc7dba273840ad522dd814be1023a740cc1b3f8','dca9fdfaf4a628e9a3fff52ee54090179368f512a2eb8c565480eb20b9fca30e','d4cef65eb81290b85f0f15b8fbacf1dfb6386ce985c20733d4b75cfc84942b8f');
INSERT INTO blocks VALUES(310035,'a13cbb016f3044207a46967a4ba1c87dab411f78c55c1179f2336653c2726ae2',1419703500,NULL,NULL,'8e84f3ff7c7134fc9b62d6c2ba6c8d7c4e7c3d55c35797f4732feefc9f023b99','02a642600262cdff4e6c0bab5e3afaddfe1ef44a03977c6c69b2172484390785','50322870cbf391520b2b58d204b430d73927de3e1d7750e03003af48655b498e');
INSERT INTO blocks VALUES(310036,'158648a98f1e1bd1875584ce8449eb15a4e91a99a923bbb24c4210135cef0c76',1419703600,NULL,NULL,'99a2adc4e0f7464ef3ca6397dec03679fd98dda7bdf563a0096cf0144acbda74','0a15e1bab7d59cdbadda6d42c846c7711270b2b8b0c2e8122047dc4b27fc5dcd','0b7ab08f68b678edbed7976fb4cdb6f203484e75c858d0b56b8f0ee2a1ff9173');
INSERT INTO blocks VALUES(310037,'563acfd6d991ce256d5655de2e9429975c8dceeb221e76d5ec6e9e24a2c27c07',1419703700,NULL,NULL,'159e78746c59d9e2ee42378cb04fc2a9609e03284bab31cace0fafae57c11f2f','371f6d3a2265a0cd3d1e36419f651baa168a7385eab6afafd954cce0df58eb60','26f15e8b8e803c808bb2138ce3653ce74015ed00cbb0d807ece88a4784372370');
INSERT INTO blocks VALUES(310038,'b44b4cad12431c32df27940e18d51f63897c7472b70950d18454edfd640490b2',1419703800,NULL,NULL,'85045007277da324408de35b80588ae240c6ac7b0e5b388908c58689a6880aaf','512fb65a002303158a05b9f6a5a125dd0bea2f8577ba468c12bba9bf75c86061','a3faf9e8b35053b141458967061d43a1d5e0ddb6f86db87d0b0f91823bcd89ba');
INSERT INTO blocks VALUES(310039,'5fa1ae9c5e8a599247458987b006ad3a57f686df1f7cc240bf119e911b56c347',1419703900,NULL,NULL,'93f055c218226fca5a6555bce4ae9ce1fc7661a79c794a6c9577c17104454fdd','6188551c4f90353521afd445fc81ece7fe62b4d04f83142505a3c44bc5992556','21b94241853bb3ac8da3a0f110a8f411e7fe741759f929cd2592533afb11cfed');
INSERT INTO blocks VALUES(310040,'7200ded406675453eadddfbb2d14c2a4526c7dc2b5de14bd48b29243df5e1aa3',1419704000,NULL,NULL,'4f8ae6778df565392b5c5745c69799fa009c6e3a73386136995abb106290d7e8','21c9bc6176f034b91485cc263c5dd49d30c3b7e29f245361cf7e923c83a211a6','4858bfb45d35e5c97196f1549075821804c803b6a6828700a84e8d2b110b0ebb');
INSERT INTO blocks VALUES(310041,'5db592ff9ba5fac1e030cf22d6c13b70d330ba397f415340086ee7357143b359',1419704100,NULL,NULL,'3fe897d11f38ee5b86a57b0a546e15cb32674109eb1ae66c671441032aeb64c4','02df7f41dafb7aca044d895450af62eee4aa0c4d6477b42d0505289ebf475bd1','163a94413bee7cf1f66d4c59287cb80d5673a878240f31a27691faa96a715aa3');
INSERT INTO blocks VALUES(310042,'826fd4701ef2824e9559b069517cd3cb990aff6a4690830f78fc845ab77fa3e4',1419704200,NULL,NULL,'d2f80764dfa1591b36f96ce87790056f3a697f395a0c9cc3cc0ba5d449e5569c','6a6756c5c21e13398ae582a740816d330f81570313f7daee502973be2ac5b21c','0b1cc70556ceb1d013f14aa3ef0307131531772d2c60e06a1b267db7e4e5698a');
INSERT INTO blocks VALUES(310043,'2254a12ada208f1dd57bc17547ecaf3c44720323c47bc7d4b1262477cb7f3c51',1419704300,NULL,NULL,'851c283124d711a6cfb4171e83d353ae726e6745ecaf9c1dcc960479e04698bc','2e74bf3d514c0306febf831a37e556b9a09fa3cf769155b41c60f34880a19b90','ba02582f6b7f1089865f84706d9097bfcb600a6af94195868374307e8e60823c');
INSERT INTO blocks VALUES(310044,'3346d24118d8af0b3c6bcc42f8b85792e7a2e7036ebf6e4c25f4f6723c78e46b',1419704400,NULL,NULL,'72d3e08c86682a84b307383a13a0a561576b74ce42a419fcf78e5f501227c12e','a5cef219e157265b71dfa262f5e190eb8d0c82c75d0045402719375782ba75dc','8284a658c954f1ac66de88cd87dde144e534fd78aaff9163c4fda03d56d9823d');
INSERT INTO blocks VALUES(310045,'7bba0ab243839e91ad1a45a762bf074011f8a9883074d68203c6d1b46fffde98',1419704500,NULL,NULL,'4758c12e6c69c881c70419d8305d07de1330c6f167a788886fe4051b76493326','7eb403e6d98a99497d113c1988721ccb94be59cc0b3168226ac6426945e45595','8b2a6d4efb9dee3c275b8d24a5a3849791b72f1582ea01dcbf770dc8f7dcf47f');
INSERT INTO blocks VALUES(310046,'47db6788c38f2d6d712764979e41346b55e78cbb4969e0ef5c4336faf18993a6',1419704600,NULL,NULL,'263db7068fb086e39880d07fc4973d46cf59e1f9841c08b92defb5c34b31db10','7e47aca1c28c5188106760e2abcd47e8b15c8959873e9ba3f06049abfa5ede3e','adcb5a4e9521f90eda57ec464c57d4845c280bcb656fe516ba4ec79a8a62adea');
INSERT INTO blocks VALUES(310047,'a9ccabcc2a098a7d25e4ab8bda7c4e66807eefa42e29890dcd88149a10de7075',1419704700,NULL,NULL,'0440433a85c72b917fe14a9b8c971c91bb80e26701b4650cdab63602f0fa95ef','88fa4387ab50049b553b2e635e33efddf368a64604357a3c65917a1581b2588c','a7a228527a77e5e825997bb3cce8cf86f493fdaf516fdac37acd8f054825f393');
INSERT INTO blocks VALUES(310048,'610bf3935a85b05a98556c55493c6de45bed4d7b3b6c8553a984718765796309',1419704800,NULL,NULL,'d27374c76c907b60a4a9befaf75ae28d6c4d92481f2fe2b88616724d2170e78b','a79952752e5f752178960192c783f59770256feae5c6be9913d87c94b1328c65','a089cad304ec79c2e15c92c7dd48ab5280ec4c82f286941d57ff762a6d0b169f');
INSERT INTO blocks VALUES(310049,'4ad2761923ad49ad2b283b640f1832522a2a5d6964486b21591b71df6b33be3c',1419704900,NULL,NULL,'52b7c1ddfcdaf13d80acf902618fa62de5f7a6a562df76b3ff27cbce396dde05','ac1acd215698ca37e8e9967fda3c7c92011b168272a40f2529394c708905d2f5','1f3de9a528b9abfebbbf32ef9dd480f32d0537e8eded4e8eb08f43a131fb7831');
INSERT INTO blocks VALUES(310050,'8cfeb60a14a4cec6e9be13d699694d49007d82a31065a17890383e262071e348',1419705000,NULL,NULL,'23946f8043f632acbe4e9e3f667d562df14243214cdb31da909d196f5d8c8235','1b207b56a6c342b490b25960b36acf7f48ef4547f45e97060be6c513773d4bbc','16115ccd5f45160216b899cc17aed41f5152f175023ae7ec7a305a5ddeeec5a1');
INSERT INTO blocks VALUES(310051,'b53c90385dd808306601350920c6af4beb717518493fd23b5c730eea078f33e6',1419705100,NULL,NULL,'c0e5c9f04326c1f68f06e0e73563ca4ad59285bed98145928fe682537e6cd0e9','0b0fc3842662be770b46de52407313d99cff549191558f3fe4f2ebf2e30b33cd','42d4a83dd35a272deeb0e87e4fa311fed7290966a8e47ac01f1c74714fb59ea2');
INSERT INTO blocks VALUES(310052,'0acdacf4e4b6fca756479cb055191b367b1fa433aa558956f5f08fa5b7b394e2',1419705200,NULL,NULL,'b9e7307cb107bc9d6ba2d5be1e3aad946939341a44559432ebac564d535c4266','3afd5b0cc8c2dc9deeadb9c8b7afb2bbc075c10c226eebe2dccd3fd03364fa2d','6bc8eea3b40ee385fd6838e2030fa0270c5f638889b5f072d5f58ab62a62fe60');
INSERT INTO blocks VALUES(310053,'68348f01b6dc49b2cb30fe92ac43e527aa90d859093d3bf7cd695c64d2ef744f',1419705300,NULL,NULL,'f34e93c04e048132e3ff06a85596998ccc97ae7c83d782ee542ddb2bcb02ca7b','cfaa4a6c49c962329cd15996b8e57617163100f8fee925d9269953c013c2eb6d','b7802b6f74bef4de9141854be931b114054b9979ecf2a36a91d4890487ea6d42');
INSERT INTO blocks VALUES(310054,'a8b5f253df293037e49b998675620d5477445c51d5ec66596e023282bb9cd305',1419705400,NULL,NULL,'4439c0f1547c444f81934787780febed950229b481a4e42bd67d6e0c85ca4748','bb899b6ea26b8ee41940fa628d61006b64ba7243ad5369b6869879ed4b464fcc','da487199992719b2aa9ac3390008139d1798ab04f6cc1d66dc57e905dd155eb6');
INSERT INTO blocks VALUES(310055,'4b069152e2dc82e96ed8a3c3547c162e8c3aceeb2a4ac07972f8321a535b9356',1419705500,NULL,NULL,'eada5dba5379357181de1b18e3a688655e0c62d2b53b883c80e8775efeb8092a','da620d6768fcdbd2d2f5792dbb601189bedaac48bd91a61d4638163fb9c97a8f','e46231f059d479b5b459377a5e0e96f8e0548a160bef62a5e0473b3f3c80b582');
INSERT INTO blocks VALUES(310056,'7603eaed418971b745256742f9d2ba70b2c2b2f69f61de6cc70e61ce0336f9d3',1419705600,NULL,NULL,'cea0aa80f1f31aa9fb1773972bcec5704af759e187e00449c9b847cf0b0b5e19','6127a4a77a08bd26626f09926055af8894a1451e75474c5dccf8642522374843','eb19a5b1951bee2de321101ef088d7ce5c881ab7b5f7df0c792fbb7a9e835bbc');
INSERT INTO blocks VALUES(310057,'4a5fdc84f2d66ecb6ee3e3646aad20751ce8694e64e348d3c8aab09d33a3e411',1419705700,NULL,NULL,'57d5d814866259e69df0eb7c025383a0c634d0b11c515830ec57c2da1173a741','c7118d31ded85eec64c97f474283e7591df5c6e6fb56a0ff027f0a41f0f2415b','fe0d4f575f2543841044dfe655f1db19b912ea5ddee63481cc4a3d18173fbb5e');
INSERT INTO blocks VALUES(310058,'a6eef3089896f0cae0bfe9423392e45c48f4efe4310b14d8cfbdb1fea613635f',1419705800,NULL,NULL,'72821a48b6dac493bd136a24d415ab386edac92242820882aad0f008b0a2c074','8f80e8cd6b595e2629bb8f2e610302709a02095ff61c81d5e8dca9a20a480bed','b0d6d0a8d3436a95f7da174a5997774a0ca8cd0d2168bb12d511f9597c4c3568');
INSERT INTO blocks VALUES(310059,'ab505de874c43f97c90be1c26a769e6c5cb140405c993b4a6cc7afc795f156a9',1419705900,NULL,NULL,'00d592b7787b24233879d51251898f14c7d259766ca15684e280cbced61dfb60','affd6de6a2c50c0cb34d22b7a840bacf1b9ce76d6a9abcde16db263d192726a0','eabb1c854bc4ae1d9a1bf3daad8fc20ecd47da437a38437c908c98a5b934d0ed');
INSERT INTO blocks VALUES(310060,'974ad5fbef621e0a38eab811608dc9afaf10c8ecc85fed913075ba1a145e889b',1419706000,NULL,NULL,'18d4757817bdd0f950028c1d68167896dfa18c7ed06f8ec01e06fcded0d9e482','c1e5dafbfef34b59e272691222a2ca5701a081ea1e6ee1b15804a72b84d2eda2','6c10dac6d7e79689b16da898f4fbc1bdec19a4989d5185fc042c0fce2e160128');
INSERT INTO blocks VALUES(310061,'35d267d21ad386e7b7632292af1c422b0310dde7ca49a82f9577525a29c138cf',1419706100,NULL,NULL,'ddc11e67e6d9c9d3e0db8c176f92633485799d00213e8762f406b6b21ad557fd','783ce2f95392fde1fb15e67fe6af902c4bb0e6309c1301a20e44462ca9d61e9b','fd521b32f9f00e51520f682a940d7e966d0a358fe9b66dedd76125ba4f57197f');
INSERT INTO blocks VALUES(310062,'b31a0054145319ef9de8c1cb19df5bcf4dc8a1ece20053aa494e5d3a00a2852f',1419706200,NULL,NULL,'2f5e75024bd28cbc042d5c30328a7259f806cec096adda31645f8db2a7e11377','63380d9093e1f5a74946a9ff20ccfb04ba1efe6825c368089d979ca1188b38dc','bc5c5396f69c122a8e476aa01884664ca95805abfe0367b2d02f28c265e8aa67');
INSERT INTO blocks VALUES(310063,'0cbcbcd5b7f2dc288e3a34eab3d4212463a5a56e886804fb4f9f1cf929eadebe',1419706300,NULL,NULL,'7dc6fb1e323a55133e79d4d7bebbfec34ab2201c66d408d2f94610c11a33579c','9f20bf7c8ac6c6b7d7b608bd3843d232903274678881522d6df6c7cc3edde7e3','e91c6a2ef82ff121666b4c87249a40436f3db07e6dc82b9a0ecd2fc07a870f7f');
INSERT INTO blocks VALUES(310064,'e2db8065a195e85cde9ddb868a17d39893a60fb2b1255aa5f0c88729de7cbf30',1419706400,NULL,NULL,'743587268ea14aeca6c07c214439ca56e3db62213cb3f3c7a20bcfa65a031390','8faed742f8f5f3fabf37293fc5767f32498577deea980a272f92ba7af1ea61e6','f1004f647ad3a5e31abdaf9ea2559465e5a885e3a763c24c3bfc9203c8673835');
INSERT INTO blocks VALUES(310065,'8a7bc7a77c831ac4fd11b8a9d22d1b6a0661b07cef05c2e600c7fb683b861d2a',1419706500,NULL,NULL,'00df84494d3e8aed4981b6d7ecbc29a1d0e911ef18c340a835e788620bbd3005','4fa2ce9810ca3c31ca2a684095a0568510b6f531dfbc1bb183054b0c7845aec4','9d7cbd45d9e39c9f4294250997368669817b939e91e2099934cace4d2c33a7b6');
INSERT INTO blocks VALUES(310066,'b6959be51eb084747d301f7ccaf9e75f2292c9404633b1532e3692659939430d',1419706600,NULL,NULL,'a08388e22bbbad92209ceedd4b6183919e6a0375e69805089deb0cd679c24a96','9847a43dab2bbdea99c9ade08e1e32c700aa692a972e9a140d54fad6814a58ac','fc1e29d87d60ee56f10862090d1e603d821d5e9f7412e28c98b590c8d5f82199');
INSERT INTO blocks VALUES(310067,'8b08eae98d7193c9c01863fac6effb9162bda010daeacf9e0347112f233b8577',1419706700,NULL,NULL,'4ef98d4552cc9eb3231b5b7424d91f4d76985861195c73dccee364aca39073f5','7763aaa8c329b431053ccab3f2b37a0022d3c1498c57f1d710d6229aff6256de','dd129b51fee05f1b6e6b4b8a80b0a02607e7e67d325c1fce0868db916c47bdbc');
INSERT INTO blocks VALUES(310068,'9280e7297ef6313341bc81787a36acfc9af58f83a415afff5e3154f126cf52b5',1419706800,NULL,NULL,'df586c79fe757b553bb11207e370e452084d2824c2eff80b86efc3084111e15b','9a13baa401718d28594ae1b44282f751e405274bd3b61470d1254dee9956b9e4','7d7f8e32303ccd76deacfd537fd466f3993ce7f948cb86eea1dbbf8e16e729e9');
INSERT INTO blocks VALUES(310069,'486351f0655bf594ffaab1980cff17353b640b63e9c27239109addece189a6f7',1419706900,NULL,NULL,'321a1e214b884f334283317cfce94a49ae204ca5f045a8b1e117a9bcd2af0481','0b694519cad53bea6b50fd7ff2e226b2670db640e06f9a42668511d830b920d4','f6b06436d0d73e6f493b53cc5a48b711835660915bf95b0b5fd839be1ea30ea3');
INSERT INTO blocks VALUES(310070,'8739e99f4dee8bebf1332f37f49a125348b40b93b74fe35579dd52bfba4fa7e5',1419707000,NULL,NULL,'751bd6afb2b2c6e41ec1117faf4766af75a56fc78705d6629da8db01ac81fdb2','4e34e3f376f3a36f7cec7aa399dc217fcb3c440b8cf944c62d67e0b879cd3d70','25ff910146b417dc8499da6c4217fd52547189964373fa97b5a7d0f6cf9c584f');
INSERT INTO blocks VALUES(310071,'7a099aa1bba0ead577f1e44f35263a1f115ed6a868c98d4dd71609072ae7f80b',1419707100,NULL,NULL,'a925c2159e79263a73c8de39283f44212f42291ea96388b1b54d1a4cf990093b','0602e47df9ba0cefcd27785b52f4d4ac1e0ce71bafbbb9bb4c7b7f9cbcda3cf3','df6cb6441bfba092bf7b60d3030afd8b67e8f533f355afe4bbbc96dbef95a3a6');
INSERT INTO blocks VALUES(310072,'7b17ecedc07552551b8129e068ae67cb176ca766ea3f6df74b597a94e3a7fc8a',1419707200,NULL,NULL,'e85494f41a960ee0fcb9120df9d7266f2b0b5ba9c07b5a3f4d633ecdefa14d2b','3c53d6fd7c77e4fbf4b28d6e6331156b18bbb6ace70277d2c95418b5a01bc965','30dbbee0ae998f8f7d69b7474600f217ead71a85bd6b8cefe6a5657ea4cbca19');
INSERT INTO blocks VALUES(310073,'ee0fe3cc9b3a48a2746b6090b63b442b97ea6055d48edcf4b2288396764c6943',1419707300,NULL,NULL,'70b3a921a813637b57ebe679cc66ebb0ef3c6b2cf8ce9711f37b4e734b348245','5c081c58038984a1c6cbfd16ea33dcc7aed70045fc39f06c52714e7f2c5ec0c8','f3977650a35bf91b65c2daeac2653641b011cc0f66cb9fa5639a426366df7f9f');
INSERT INTO blocks VALUES(310074,'ceab38dfde01f711a187601731ad575d67cfe0b7dbc61dcd4f15baaef72089fb',1419707400,NULL,NULL,'ab58722aba9e98fe9a7af0dc68b17b04fec007e9908790f269cb85f42401c580','e6960d9b1074f890778e166d64b50411cc57e33c3f635febf4dafc345545e53a','9222b8ef19ed9cfde33ce2b6dc16974911805e766f3b3098fa84f3b4bd0c85e1');
INSERT INTO blocks VALUES(310075,'ef547198c6e36d829f117cfd7077ccde45158e3c545152225fa24dba7a26847b',1419707500,NULL,NULL,'0f366b9296c3ef42adac8d8cb74880e94134f9858a1caa453270456891023c31','1e72a72401007b1d1481b19807614815a4b7e1a296f68e1cedea8686352c80d4','305921190344cf988753fa79700d691eb7c6eb1344658d1a591b08964052908e');
INSERT INTO blocks VALUES(310076,'3b0499c2e8e8f0252c7288d4ecf66efc426ca37aad3524424d14c8bc6f8b0d92',1419707600,NULL,NULL,'a3d34df8abf99f67c4d7330f37bef9da4be62a8d722a7ea4eca9eafe7053d6a7','bf05d3cdf9664a464e444f0ef486f263fa94c49169cd160dcdbe5c9dd8694bf3','4e6fc1d1b73ee6d1b05c6a8ac8097ea932b895ff90e4dcdc5050b823e0caa579');
INSERT INTO blocks VALUES(310077,'d2adeefa9024ab3ff2822bc36acf19b6c647cea118cf15b86c6bc00c3322e7dd',1419707700,NULL,NULL,'cc1068b27e1cfd6c79b9abc4143964001041cdc6fbd328dde780a440d7d36108','ce33f8b8f11870ad33d6fa1f8cf18594fbba0e329d07c779243586631e3c73a9','4c8d997d346ea87ee4daac5767708938919a6efd9d62ca6c62c9f32bd2bdf966');
INSERT INTO blocks VALUES(310078,'f6c17115ef0efe489c562bcda4615892b4d4b39db0c9791fe193d4922bd82cd6',1419707800,NULL,NULL,'8e4ecf4a17d4b99d20fd396dac0d3384b5284449b0b320a2fe23f3e269151f08','bec4209602278504030136dc0b1fd19c311286249fecb37298c6060d3524dd92','4d5ade025d6381b42d66942378cc4557b3917eb6919e877460c4636666216f52');
INSERT INTO blocks VALUES(310079,'f2fbd2074d804e631db44cb0fb2e1db3fdc367e439c21ffc40d73104c4d7069c',1419707900,NULL,NULL,'47f1ccffa5e27b10d7f86ebade5991f7f6c79d11efd7b9f4814c390916190c02','3cd26be0f4d6a94007e148178f1bbfeda3b9e1749867a14ae27b69eff8445cdd','8c887c76fcbc409924c7af6f0eaa16278a434a1bd91d435d99d81323635b2c5b');
INSERT INTO blocks VALUES(310080,'42943b914d9c367000a78b78a544cc4b84b1df838aadde33fe730964a89a3a6c',1419708000,NULL,NULL,'90d9e19cae5aa3ed5572e8c905dbf49230c2120ebbd3a136614070f470f2685d','cd5eba18942586f11d109f3474ee16b49084f4807a7bc6417672e8d14fd891c3','a463dc4d10cd64462ab99401aba5b4b6da3f7840fda04e47ac4281ae5a877af0');
INSERT INTO blocks VALUES(310081,'6554f9d307976249e7b7e260e08046b3b55d318f8b6af627fed5be3063f123c4',1419708100,NULL,NULL,'b9300e3e4ca9a54ef651313a2dfa72fead83765113cdfae58917529a1b105729','c2acece48b884414a5c2a8515c4a41958d881e0e4cf4864fc8636ff47c080f52','2d9eb895882a98b7a761647c3da3134b9dfffbf7ae3efd7c245780a73715caf8');
INSERT INTO blocks VALUES(310082,'4f1ef91b1dcd575f8ac2e66a67715500cbca154bd6f3b8148bb7015a6aa6c644',1419708200,NULL,NULL,'cd74e28544c2ff86e51ac22fa790b1a7dfa1d23863af6f4aed92a0a1f05616a8','dd2455b63c64c6144d9f00e9f76b13441ee497ae75f9e44c889f8ebc5ebf3262','141143a7cab9d99543c9f93c467c8a33dce0dbcfa9a32996e8083dd9786d908e');
INSERT INTO blocks VALUES(310083,'9b1f6fd6ff9b0dc4e37603cfb0625f49067c775b99e12492afd85392d3c8d850',1419708300,NULL,NULL,'8cd8dcb5cb9fe50f9a2c4caa6e0839f2ce6545e063e2e831e31e2d3452a3a013','47a19194642bbb707b9de92bc8b0da7a0bcbf9feb55a2e1e0a9d985001786006','16e2fe7bdb5e852e01117589e05663cfe6e314406927c6e34afcc1f9992a266a');
INSERT INTO blocks VALUES(310084,'1e0972523e80306441b9f4157f171716199f1428db2e818a7f7817ccdc8859e3',1419708400,NULL,NULL,'5b3ee92e8d1ce987782b6e659542120c73bdcca8b837d8f377f8c9232fd92137','fd05ff6d8e0ca497a51c8e841bb608c0059c151cbde2544aed1167b5f16cffbb','58d0779a4a7bc0bd2001be52f8da65ff415e058995979442025a954192786be5');
INSERT INTO blocks VALUES(310085,'c5b6e9581831e3bc5848cd7630c499bca26d9ece5156d36579bdb72d54817e34',1419708500,NULL,NULL,'a942e01373b407f9ffc62d9100c8f543ed2c4932b4283cc57419a39faa11f0a1','91d886945e531d31b46afdd66a76e51cc88666811c03de673ee40dcabd71d089','ebbbfe7c379f52837526cb6cb136419e8c855d2925985ba5fb0da7ca61fb4463');
INSERT INTO blocks VALUES(310086,'080c1dc55a4ecf4824cf9840602498cfc35b5f84099f50b71b45cb63834c7a78',1419708600,NULL,NULL,'bbbe6fb208c18969ff525b7c6ca47a5e0b7369754cccf328b39f672393fe6d04','37a5fad4e3122450fb729f93f1058fcd0731b167231b06150432d9d23b8a47e6','35f4da0ba8062ee177fbb40f435078f0202e92c04668c9ac54352e380d1ce856');
INSERT INTO blocks VALUES(310087,'4ec8cb1c38b22904e8087a034a6406b896eff4dd28e7620601c6bddf82e2738c',1419708700,NULL,NULL,'d10d23eb44e4260a483f748f0b423197bd8bbae955c05965150b73de45c61406','b9c23ac1da9764feebc0c4f4f351e189cbb60591b8b8d7d1766c7c0848d372d7','e7bfcd7f3a44e45ec5818d4aa40a1c842b8dffb34b0ab0b9234b1473e4a17e40');
INSERT INTO blocks VALUES(310088,'e945c815c433cbddd0bf8e66c5c23b51072483492acda98f5c2c201020a8c5b3',1419708800,NULL,NULL,'7e5ecab61cf5e3a83d7d299416ec20af16c4323dd506cb1f89cfd8c3103810c7','dd4097efa8f20adc17f6d042ff4e4507f4e05521a151a35bf1f8d34353dbfcce','d435413c94646b97c3598f2f6813a35e333aef4639a7d375c7c2c4316ecbc1f4');
INSERT INTO blocks VALUES(310089,'0382437f895ef3e7e38bf025fd4f606fd44d4bbd6aea71dbdc4ed11a7cd46f33',1419708900,NULL,NULL,'3dc7e8e61295b8b82cc994233c65460805faffdf9c31f21ab891e3d3b4146011','9ed6e3e7e957c287bc0981901473b8b36d38e340de4af767ccd3c4e352967748','d2454500bee17f109a3a774414a46a3812ec1fba4fcf7b070396f9443d63c2d1');
INSERT INTO blocks VALUES(310090,'b756db71dc037b5a4582de354a3347371267d31ebda453e152f0a13bb2fae969',1419709000,NULL,NULL,'dd8a7846a05e113f198042d96dcafcce92072c1dfe2ecd0d72437bb1e88bafcc','4950b327e69c7596ac4bf7ac372b9114ea2e7cc6ba12e891b2834692f71b48ba','8cf2565f42aef42bdd43f633e1859c81c2dec57af309223032b142658cbb89b2');
INSERT INTO blocks VALUES(310091,'734a9aa485f36399d5efb74f3b9c47f8b5f6fd68c9967f134b14cfe7e2d7583c',1419709100,NULL,NULL,'5357ad3bb0ce74c9a14a4edfb498523ddbbdc7762f35214db367d1cef7b054fc','38e8d7a939a546758e90497213e46f927e12694d103fcc7d2ac162ca6f90a026','0185e485abcdd85129ce06d6228a266326bab3327f8c4703ef449a7645ac3b4f');
INSERT INTO blocks VALUES(310092,'56386beb65f9228740d4ad43a1c575645f6daf59e0dd9f22551c59215b5e8c3d',1419709200,NULL,NULL,'e23fe2f05654b77b9da00c9393bc3b23fa6928ff872d22580e8cbbea60f07f3c','99305016587a004c8858b56870f0f0344d54bf41f6e6ffc638dc98e2900fe2dc','85552933ae7bb169805a8c640e3d77e8df89ceb78775b81b20e16c4b2f6f1dfd');
INSERT INTO blocks VALUES(310093,'a74a2425f2f4be24bb5f715173e6756649e1cbf1b064aeb1ef60e0b94b418ddc',1419709300,NULL,NULL,'1bada9634bb98d8af1d61819f6f42c6daf5751443f76c546e582614b34210483','34d24f5596442e49ae4025be91856e18ac58a5f222dadfbeaaa24d74109b5889','6555744da8cb8abee1a240caaccf40a5f905a59d0a4b751e3bf9b07758ac57f7');
INSERT INTO blocks VALUES(310094,'2a8f976f20c4e89ff01071915ac96ee35192d54df3a246bf61fd4a0cccfb5b23',1419709400,NULL,NULL,'439f1e40d3863824bb84b4306be95aa933713f120cf56a8d2b8176f67f24183a','eb6491cd044ff33f708eb0f9cfe4c7d1824dd5c61599083e7544ef8fa7d931fc','da0840f69b30d46287f9bdfb610d36dd0d99bf69127a811fa42266a67d9851bd');
INSERT INTO blocks VALUES(310095,'bed0fa40c9981223fb40b3be8124ca619edc9dd34d0c907369477ea92e5d2cd2',1419709500,NULL,NULL,'10bbd9e0a6a943c8eec801c5a8874df5a6b644ffc1d88358f28956372fa3a94b','1e9f49e988350cae1bb06aff711f9f364b4c2ee4d6415d52416a26f6b1a77faf','4684b2f0357f52d4dc02fe271599c36c8c347497b488394597e4db4c80ad5d57');
INSERT INTO blocks VALUES(310096,'306aeec3db435fabffdf88c2f26ee83caa4c2426375a33daa2be041dbd27ea2f',1419709600,NULL,NULL,'06f7d51c896f49217b2578d26ab95dc5e2b630df40df0ddc842f16d79cdf6a55','8e815c425c944f99638e4ece52678e36ba214d94809d6a502115949253d6f619','974832c1c7d48812fd1f08a3254a3b4a24b565b0356d1649961038d83232c44c');
INSERT INTO blocks VALUES(310097,'13e8e16e67c7cdcc80d477491e554b43744f90e8e1a9728439a11fab42cefadf',1419709700,NULL,NULL,'b1566517d146cd0d211d33a160487df5d6ccfe0a2cd7385a0221ddae3a8c3fbc','e5398ab38ca1f01a50e74c177a711deb1abbdad056916b7e0a5e5cdc3fecc45b','246c1a9b72f88c3dee3b758d46553b23c8163806b117dd3b6cdc2e8eaae3f60f');
INSERT INTO blocks VALUES(310098,'ca5bca4b5ec4fa6183e05176abe921cff884c4e20910fab55b603cef48dc3bca',1419709800,NULL,NULL,'ca14351eeee63612b1fa354b0ac8a3b8f5f381989b1850a06817d7fa9519daa6','687d742c92e94cc627183ff81c0ecdab148c72a61b35351c643506b2eb02871f','41b21fc69ea1ae5012a4d27093ddd23988cb79fd85c81a0ca61abb511e1ed0b0');
INSERT INTO blocks VALUES(310099,'3c4c2279cd7de0add5ec469648a845875495a7d54ebfb5b012dcc5a197b7992a',1419709900,NULL,NULL,'25841a0f33deb9084d2e8b945639bf689bb91dc56076be92e4eb9eacfca585a9','11f3b960d8e734a6310bc2eff675f5b514390940c5f7ef78d1bd200d962d6faf','336264e56c7f074992f90127748cd69f0a61a632b6c10b6afe32c12380cefc34');
INSERT INTO blocks VALUES(310100,'96925c05b3c7c80c716f5bef68d161c71d044252c766ca0e3f17f255764242cb',1419710000,NULL,NULL,'5e88256038de56dfe8fcc19d79f45f8a68bb6e56ad6a5b3f40c757dd544f4173','0e40453199fa3707df6c69421bf5c822e1382b865cce6e962f908c08f316d822','e0d8146a5af628951e0b8f883f4508e5bf03b141d630e4f89b0bc7700a0f02b3');
INSERT INTO blocks VALUES(310101,'369472409995ca1a2ebecbad6bf9dab38c378ab1e67e1bdf13d4ce1346731cd6',1419710100,NULL,NULL,'5b546897126f5aaed0fb4c13809375d64d2f7c75d62e99af9859b48a5ba80fe6','1d88f02c56f5775217b1b948a77ed4940a1b0db5a513157f51ce89375a971d9e','6e6f5b0f1735d8f8abdaa6f579ecd1dfb45dc982813373d477aba5e1d43fb55a');
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
INSERT INTO broadcasts VALUES(12,'cbcdc363cec1baae37d0a402de588bd2152b958c06723a34cba26d78bb0cdead',310011,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1388000000,100.0,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(19,'aa5f6d46e9e43dd0c765738c881628b281d5d88fa8f8f280abd62aaae01049ba',310018,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1388000050,99.86166,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(20,'1b65792893f37c8a62175470b24dbfb35d026680ecc48c7f66695e944061c768',310019,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1388000101,100.343,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(21,'7954cf858f5ab400b267abb7b0681d84a43b2997ef43d6bd579732ba30e83a71',310020,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',1388000201,2.0,5000000,'Unit Test',0,'valid');
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
INSERT INTO btcpays VALUES(5,'76e0c3747a1537888c0e2b55b6c4b04b7a0bf8a2c616cd48687139b589ed6151',310004,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',50000000,'17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b_89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345','valid');
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
INSERT INTO burns VALUES(1,'e99914fcf580f8705559fce8796ffa216d4a3aef2abc95783df5cabea2f0966b',310000,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',62000000,93000000000,'valid');
INSERT INTO burns VALUES(23,'c56318d85bacc3e96b131ebc4a914d12fa09f2a516b090f04b2f7a1085c1d53f',310022,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',38000000,56999887262,'valid');
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
INSERT INTO credits VALUES(310000,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',93000000000,'burn','e99914fcf580f8705559fce8796ffa216d4a3aef2abc95783df5cabea2f0966b');
INSERT INTO credits VALUES(310001,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','XCP',50000000,'send','b3018f8bb0e1b3c263fd9f90ed111550d12859b2d4c48d8a7dc370942f3d5572');
INSERT INTO credits VALUES(310004,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',100000000,'btcpay','76e0c3747a1537888c0e2b55b6c4b04b7a0bf8a2c616cd48687139b589ed6151');
INSERT INTO credits VALUES(310005,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',1000000000,'issuance','44eb0557f8ce3d042d0e3fe0b0a0db98b12ffa20a95d3c17012a042583ecf60c');
INSERT INTO credits VALUES(310006,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBC',100000,'issuance','073653f9647af19b87437d535bfd0f29b8a54b37f8fb2840c876be1c43d903b7');
INSERT INTO credits VALUES(310007,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBB',4000000,'send','2cd2a785c1b7d7588e0eff9d29992a078b24d4ea3c19899f971521d115bf5497');
INSERT INTO credits VALUES(310008,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBC',526,'send','cea6cfb79722c19ef2198328534d6a02cef6ca1f662a79edf69af939f805cfdf');
INSERT INTO credits VALUES(310009,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','XCP',24,'dividend','5e2e7a2b1d5348a5d53e3dd031190448091a67f0ba8e84175de2de2be6192845');
INSERT INTO credits VALUES(310010,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','XCP',420800,'dividend','74fb6e695c2769d8a2a0ce715a9d70138eed6887b0ebb9919b402b034ee4e54b');
INSERT INTO credits VALUES(310013,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',4250000,'filled','b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a');
INSERT INTO credits VALUES(310014,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',5000000,'cancel order','89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345');
INSERT INTO credits VALUES(310014,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',41500000,'recredit forward quantity','474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217_b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a');
INSERT INTO credits VALUES(310014,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',20750000,'recredit backward quantity','474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217_b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a');
INSERT INTO credits VALUES(310015,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',0,'filled','836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5');
INSERT INTO credits VALUES(310015,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',0,'filled','836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5');
INSERT INTO credits VALUES(310016,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',150000000,'recredit forward quantity','71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb_836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5');
INSERT INTO credits VALUES(310016,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',350000000,'recredit backward quantity','71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb_836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5');
INSERT INTO credits VALUES(310017,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',0,'filled','0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0');
INSERT INTO credits VALUES(310017,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',0,'filled','0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0');
INSERT INTO credits VALUES(310018,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',750000000,'recredit forward quantity','39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b_0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0');
INSERT INTO credits VALUES(310018,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',650000000,'recredit backward quantity','39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b_0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0');
INSERT INTO credits VALUES(310022,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',56999887262,'burn','c56318d85bacc3e96b131ebc4a914d12fa09f2a516b090f04b2f7a1085c1d53f');
INSERT INTO credits VALUES(310023,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',8500000,'recredit wager remaining','474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217');
INSERT INTO credits VALUES(310023,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBC',10000,'send','aacc38b5a85e03ed4c215777292043d348303a7811d67acfa57f6b545a6c6fc7');
INSERT INTO credits VALUES(310032,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',50000000,'cancel order','5e77d7764fafbf0ff360a2c7cc7c41c364b28bf8294e06be860b97ad193e4cef');
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
INSERT INTO debits VALUES(310001,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',50000000,'send','b3018f8bb0e1b3c263fd9f90ed111550d12859b2d4c48d8a7dc370942f3d5572');
INSERT INTO debits VALUES(310003,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',105000000,'open order','89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345');
INSERT INTO debits VALUES(310005,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',50000000,'issuance fee','44eb0557f8ce3d042d0e3fe0b0a0db98b12ffa20a95d3c17012a042583ecf60c');
INSERT INTO debits VALUES(310006,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',50000000,'issuance fee','073653f9647af19b87437d535bfd0f29b8a54b37f8fb2840c876be1c43d903b7');
INSERT INTO debits VALUES(310007,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',4000000,'send','2cd2a785c1b7d7588e0eff9d29992a078b24d4ea3c19899f971521d115bf5497');
INSERT INTO debits VALUES(310008,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBC',526,'send','cea6cfb79722c19ef2198328534d6a02cef6ca1f662a79edf69af939f805cfdf');
INSERT INTO debits VALUES(310009,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',24,'dividend','5e2e7a2b1d5348a5d53e3dd031190448091a67f0ba8e84175de2de2be6192845');
INSERT INTO debits VALUES(310009,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',20000,'dividend fee','5e2e7a2b1d5348a5d53e3dd031190448091a67f0ba8e84175de2de2be6192845');
INSERT INTO debits VALUES(310010,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',420800,'dividend','74fb6e695c2769d8a2a0ce715a9d70138eed6887b0ebb9919b402b034ee4e54b');
INSERT INTO debits VALUES(310010,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',20000,'dividend fee','74fb6e695c2769d8a2a0ce715a9d70138eed6887b0ebb9919b402b034ee4e54b');
INSERT INTO debits VALUES(310012,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',50000000,'bet','474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217');
INSERT INTO debits VALUES(310013,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',25000000,'bet','b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a');
INSERT INTO debits VALUES(310014,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',150000000,'bet','71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb');
INSERT INTO debits VALUES(310015,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',350000000,'bet','836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5');
INSERT INTO debits VALUES(310016,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',750000000,'bet','39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b');
INSERT INTO debits VALUES(310017,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',650000000,'bet','0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0');
INSERT INTO debits VALUES(310021,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',50000000,'open order','5e77d7764fafbf0ff360a2c7cc7c41c364b28bf8294e06be860b97ad193e4cef');
INSERT INTO debits VALUES(310023,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBC',10000,'send','aacc38b5a85e03ed4c215777292043d348303a7811d67acfa57f6b545a6c6fc7');
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
INSERT INTO dividends VALUES(10,'5e2e7a2b1d5348a5d53e3dd031190448091a67f0ba8e84175de2de2be6192845',310009,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB','XCP',600,20000,'valid');
INSERT INTO dividends VALUES(11,'74fb6e695c2769d8a2a0ce715a9d70138eed6887b0ebb9919b402b034ee4e54b',310010,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBC','XCP',800,20000,'valid');
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
INSERT INTO issuances VALUES(6,'44eb0557f8ce3d042d0e3fe0b0a0db98b12ffa20a95d3c17012a042583ecf60c',310005,'BBBB',1000000000,1,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,0,0,0.0,'',50000000,0,'valid');
INSERT INTO issuances VALUES(7,'073653f9647af19b87437d535bfd0f29b8a54b37f8fb2840c876be1c43d903b7',310006,'BBBC',100000,0,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',0,0,0,0.0,'foobar',50000000,0,'valid');
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
INSERT INTO messages VALUES(0,310000,'insert','credits','{"action": "burn", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310000, "event": "e99914fcf580f8705559fce8796ffa216d4a3aef2abc95783df5cabea2f0966b", "quantity": 93000000000}',0);
INSERT INTO messages VALUES(1,310000,'insert','burns','{"block_index": 310000, "burned": 62000000, "earned": 93000000000, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "e99914fcf580f8705559fce8796ffa216d4a3aef2abc95783df5cabea2f0966b", "tx_index": 1}',0);
INSERT INTO messages VALUES(2,310001,'insert','debits','{"action": "send", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310001, "event": "b3018f8bb0e1b3c263fd9f90ed111550d12859b2d4c48d8a7dc370942f3d5572", "quantity": 50000000}',0);
INSERT INTO messages VALUES(3,310001,'insert','credits','{"action": "send", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "XCP", "block_index": 310001, "event": "b3018f8bb0e1b3c263fd9f90ed111550d12859b2d4c48d8a7dc370942f3d5572", "quantity": 50000000}',0);
INSERT INTO messages VALUES(4,310001,'insert','sends','{"asset": "XCP", "block_index": 310001, "destination": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "quantity": 50000000, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "b3018f8bb0e1b3c263fd9f90ed111550d12859b2d4c48d8a7dc370942f3d5572", "tx_index": 2}',0);
INSERT INTO messages VALUES(5,310002,'insert','orders','{"block_index": 310002, "expiration": 10, "expire_index": 310012, "fee_provided": 1000000, "fee_provided_remaining": 1000000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 100000000, "get_remaining": 100000000, "give_asset": "BTC", "give_quantity": 50000000, "give_remaining": 50000000, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "tx_hash": "17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b", "tx_index": 3}',0);
INSERT INTO messages VALUES(6,310003,'insert','debits','{"action": "open order", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310003, "event": "89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345", "quantity": 105000000}',0);
INSERT INTO messages VALUES(7,310003,'insert','orders','{"block_index": 310003, "expiration": 10, "expire_index": 310013, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 900000, "fee_required_remaining": 900000, "get_asset": "BTC", "get_quantity": 50000000, "get_remaining": 50000000, "give_asset": "XCP", "give_quantity": 105000000, "give_remaining": 105000000, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "tx_hash": "89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345", "tx_index": 4}',0);
INSERT INTO messages VALUES(8,310003,'update','orders','{"fee_provided_remaining": 142858, "fee_required_remaining": 0, "get_remaining": 0, "give_remaining": 0, "status": "open", "tx_hash": "17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b"}',0);
INSERT INTO messages VALUES(9,310003,'update','orders','{"fee_provided_remaining": 10000, "fee_required_remaining": 42858, "get_remaining": 0, "give_remaining": 5000000, "status": "open", "tx_hash": "89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345"}',0);
INSERT INTO messages VALUES(10,310003,'insert','order_matches','{"backward_asset": "XCP", "backward_quantity": 100000000, "block_index": 310003, "fee_paid": 857142, "forward_asset": "BTC", "forward_quantity": 50000000, "id": "17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b_89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345", "match_expire_index": 310023, "status": "pending", "tx0_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx0_block_index": 310002, "tx0_expiration": 10, "tx0_hash": "17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b", "tx0_index": 3, "tx1_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_block_index": 310003, "tx1_expiration": 10, "tx1_hash": "89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345", "tx1_index": 4}',0);
INSERT INTO messages VALUES(11,310004,'insert','credits','{"action": "btcpay", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310004, "event": "76e0c3747a1537888c0e2b55b6c4b04b7a0bf8a2c616cd48687139b589ed6151", "quantity": 100000000}',0);
INSERT INTO messages VALUES(12,310004,'update','order_matches','{"order_match_id": "17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b_89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345", "status": "completed"}',0);
INSERT INTO messages VALUES(13,310004,'insert','btcpays','{"block_index": 310004, "btc_amount": 50000000, "destination": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "order_match_id": "17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b_89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345", "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "76e0c3747a1537888c0e2b55b6c4b04b7a0bf8a2c616cd48687139b589ed6151", "tx_index": 5}',0);
INSERT INTO messages VALUES(14,310005,'insert','debits','{"action": "issuance fee", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310005, "event": "44eb0557f8ce3d042d0e3fe0b0a0db98b12ffa20a95d3c17012a042583ecf60c", "quantity": 50000000}',0);
INSERT INTO messages VALUES(15,310005,'insert','issuances','{"asset": "BBBB", "block_index": 310005, "call_date": 0, "call_price": 0.0, "callable": false, "description": "", "divisible": true, "fee_paid": 50000000, "issuer": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "locked": false, "quantity": 1000000000, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "transfer": false, "tx_hash": "44eb0557f8ce3d042d0e3fe0b0a0db98b12ffa20a95d3c17012a042583ecf60c", "tx_index": 6}',0);
INSERT INTO messages VALUES(16,310005,'insert','credits','{"action": "issuance", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBB", "block_index": 310005, "event": "44eb0557f8ce3d042d0e3fe0b0a0db98b12ffa20a95d3c17012a042583ecf60c", "quantity": 1000000000}',0);
INSERT INTO messages VALUES(17,310006,'insert','debits','{"action": "issuance fee", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310006, "event": "073653f9647af19b87437d535bfd0f29b8a54b37f8fb2840c876be1c43d903b7", "quantity": 50000000}',0);
INSERT INTO messages VALUES(18,310006,'insert','issuances','{"asset": "BBBC", "block_index": 310006, "call_date": 0, "call_price": 0.0, "callable": false, "description": "foobar", "divisible": false, "fee_paid": 50000000, "issuer": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "locked": false, "quantity": 100000, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "transfer": false, "tx_hash": "073653f9647af19b87437d535bfd0f29b8a54b37f8fb2840c876be1c43d903b7", "tx_index": 7}',0);
INSERT INTO messages VALUES(19,310006,'insert','credits','{"action": "issuance", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBC", "block_index": 310006, "event": "073653f9647af19b87437d535bfd0f29b8a54b37f8fb2840c876be1c43d903b7", "quantity": 100000}',0);
INSERT INTO messages VALUES(20,310007,'insert','debits','{"action": "send", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBB", "block_index": 310007, "event": "2cd2a785c1b7d7588e0eff9d29992a078b24d4ea3c19899f971521d115bf5497", "quantity": 4000000}',0);
INSERT INTO messages VALUES(21,310007,'insert','credits','{"action": "send", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "BBBB", "block_index": 310007, "event": "2cd2a785c1b7d7588e0eff9d29992a078b24d4ea3c19899f971521d115bf5497", "quantity": 4000000}',0);
INSERT INTO messages VALUES(22,310007,'insert','sends','{"asset": "BBBB", "block_index": 310007, "destination": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "quantity": 4000000, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "2cd2a785c1b7d7588e0eff9d29992a078b24d4ea3c19899f971521d115bf5497", "tx_index": 8}',0);
INSERT INTO messages VALUES(23,310008,'insert','debits','{"action": "send", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBC", "block_index": 310008, "event": "cea6cfb79722c19ef2198328534d6a02cef6ca1f662a79edf69af939f805cfdf", "quantity": 526}',0);
INSERT INTO messages VALUES(24,310008,'insert','credits','{"action": "send", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "BBBC", "block_index": 310008, "event": "cea6cfb79722c19ef2198328534d6a02cef6ca1f662a79edf69af939f805cfdf", "quantity": 526}',0);
INSERT INTO messages VALUES(25,310008,'insert','sends','{"asset": "BBBC", "block_index": 310008, "destination": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "quantity": 526, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "cea6cfb79722c19ef2198328534d6a02cef6ca1f662a79edf69af939f805cfdf", "tx_index": 9}',0);
INSERT INTO messages VALUES(26,310009,'insert','debits','{"action": "dividend", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310009, "event": "5e2e7a2b1d5348a5d53e3dd031190448091a67f0ba8e84175de2de2be6192845", "quantity": 24}',0);
INSERT INTO messages VALUES(27,310009,'insert','debits','{"action": "dividend fee", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310009, "event": "5e2e7a2b1d5348a5d53e3dd031190448091a67f0ba8e84175de2de2be6192845", "quantity": 20000}',0);
INSERT INTO messages VALUES(28,310009,'insert','credits','{"action": "dividend", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "XCP", "block_index": 310009, "event": "5e2e7a2b1d5348a5d53e3dd031190448091a67f0ba8e84175de2de2be6192845", "quantity": 24}',0);
INSERT INTO messages VALUES(29,310009,'insert','dividends','{"asset": "BBBB", "block_index": 310009, "dividend_asset": "XCP", "fee_paid": 20000, "quantity_per_unit": 600, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "5e2e7a2b1d5348a5d53e3dd031190448091a67f0ba8e84175de2de2be6192845", "tx_index": 10}',0);
INSERT INTO messages VALUES(30,310010,'insert','debits','{"action": "dividend", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310010, "event": "74fb6e695c2769d8a2a0ce715a9d70138eed6887b0ebb9919b402b034ee4e54b", "quantity": 420800}',0);
INSERT INTO messages VALUES(31,310010,'insert','debits','{"action": "dividend fee", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310010, "event": "74fb6e695c2769d8a2a0ce715a9d70138eed6887b0ebb9919b402b034ee4e54b", "quantity": 20000}',0);
INSERT INTO messages VALUES(32,310010,'insert','credits','{"action": "dividend", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "XCP", "block_index": 310010, "event": "74fb6e695c2769d8a2a0ce715a9d70138eed6887b0ebb9919b402b034ee4e54b", "quantity": 420800}',0);
INSERT INTO messages VALUES(33,310010,'insert','dividends','{"asset": "BBBC", "block_index": 310010, "dividend_asset": "XCP", "fee_paid": 20000, "quantity_per_unit": 800, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "74fb6e695c2769d8a2a0ce715a9d70138eed6887b0ebb9919b402b034ee4e54b", "tx_index": 11}',0);
INSERT INTO messages VALUES(34,310011,'insert','broadcasts','{"block_index": 310011, "fee_fraction_int": 5000000, "locked": false, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "text": "Unit Test", "timestamp": 1388000000, "tx_hash": "cbcdc363cec1baae37d0a402de588bd2152b958c06723a34cba26d78bb0cdead", "tx_index": 12, "value": 100.0}',0);
INSERT INTO messages VALUES(35,310012,'insert','debits','{"action": "bet", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310012, "event": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217", "quantity": 50000000}',0);
INSERT INTO messages VALUES(36,310012,'insert','bets','{"bet_type": 0, "block_index": 310012, "counterwager_quantity": 25000000, "counterwager_remaining": 25000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310022, "fee_fraction_int": 5000000.0, "feed_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 15120, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 0.0, "tx_hash": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217", "tx_index": 13, "wager_quantity": 50000000, "wager_remaining": 50000000}',0);
INSERT INTO messages VALUES(37,310013,'update','orders','{"status": "expired", "tx_hash": "17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b"}',0);
INSERT INTO messages VALUES(38,310013,'insert','order_expirations','{"block_index": 310013, "order_hash": "17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b", "order_index": 3, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(39,310013,'insert','debits','{"action": "bet", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310013, "event": "b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a", "quantity": 25000000}',0);
INSERT INTO messages VALUES(40,310013,'insert','bets','{"bet_type": 1, "block_index": 310013, "counterwager_quantity": 41500000, "counterwager_remaining": 41500000, "deadline": 1388000100, "expiration": 10, "expire_index": 310023, "fee_fraction_int": 5000000.0, "feed_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 15120, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 0.0, "tx_hash": "b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a", "tx_index": 14, "wager_quantity": 25000000, "wager_remaining": 25000000}',0);
INSERT INTO messages VALUES(41,310013,'update','bets','{"counterwager_remaining": 4250000, "status": "open", "tx_hash": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217", "wager_remaining": 8500000}',0);
INSERT INTO messages VALUES(42,310013,'insert','credits','{"action": "filled", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310013, "event": "b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a", "quantity": 4250000}',0);
INSERT INTO messages VALUES(43,310013,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a", "wager_remaining": 4250000}',0);
INSERT INTO messages VALUES(44,310013,'insert','bet_matches','{"backward_quantity": 20750000, "block_index": 310013, "deadline": 1388000100, "fee_fraction_int": 5000000, "feed_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "forward_quantity": 41500000, "id": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217_b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a", "initial_value": 100.0, "leverage": 15120, "match_expire_index": 310022, "status": "pending", "target_value": 0.0, "tx0_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx0_bet_type": 0, "tx0_block_index": 310012, "tx0_expiration": 10, "tx0_hash": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217", "tx0_index": 13, "tx1_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_bet_type": 1, "tx1_block_index": 310013, "tx1_expiration": 10, "tx1_hash": "b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a", "tx1_index": 14}',0);
INSERT INTO messages VALUES(45,310014,'update','orders','{"status": "expired", "tx_hash": "89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345"}',0);
INSERT INTO messages VALUES(46,310014,'insert','credits','{"action": "cancel order", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310014, "event": "89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345", "quantity": 5000000}',0);
INSERT INTO messages VALUES(47,310014,'insert','order_expirations','{"block_index": 310014, "order_hash": "89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345", "order_index": 4, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(48,310014,'insert','credits','{"action": "recredit forward quantity", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310014, "event": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217_b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a", "quantity": 41500000}',0);
INSERT INTO messages VALUES(49,310014,'insert','credits','{"action": "recredit backward quantity", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310014, "event": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217_b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a", "quantity": 20750000}',0);
INSERT INTO messages VALUES(50,310014,'update','bet_matches','{"bet_match_id": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217_b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a", "status": "expired"}',0);
INSERT INTO messages VALUES(51,310014,'insert','bet_match_expirations','{"bet_match_id": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217_b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a", "block_index": 310014, "tx0_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(52,310014,'insert','debits','{"action": "bet", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310014, "event": "71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb", "quantity": 150000000}',0);
INSERT INTO messages VALUES(53,310014,'insert','bets','{"bet_type": 0, "block_index": 310014, "counterwager_quantity": 350000000, "counterwager_remaining": 350000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310024, "fee_fraction_int": 5000000.0, "feed_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 5040, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 0.0, "tx_hash": "71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb", "tx_index": 15, "wager_quantity": 150000000, "wager_remaining": 150000000}',0);
INSERT INTO messages VALUES(54,310015,'insert','debits','{"action": "bet", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310015, "event": "836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5", "quantity": 350000000}',0);
INSERT INTO messages VALUES(55,310015,'insert','bets','{"bet_type": 1, "block_index": 310015, "counterwager_quantity": 150000000, "counterwager_remaining": 150000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310025, "fee_fraction_int": 5000000.0, "feed_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 5040, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 0.0, "tx_hash": "836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5", "tx_index": 16, "wager_quantity": 350000000, "wager_remaining": 350000000}',0);
INSERT INTO messages VALUES(56,310015,'insert','credits','{"action": "filled", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310015, "event": "836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5", "quantity": 0}',0);
INSERT INTO messages VALUES(57,310015,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(58,310015,'insert','credits','{"action": "filled", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310015, "event": "836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5", "quantity": 0}',0);
INSERT INTO messages VALUES(59,310015,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(60,310015,'insert','bet_matches','{"backward_quantity": 350000000, "block_index": 310015, "deadline": 1388000100, "fee_fraction_int": 5000000, "feed_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "forward_quantity": 150000000, "id": "71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb_836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5", "initial_value": 100.0, "leverage": 5040, "match_expire_index": 310024, "status": "pending", "target_value": 0.0, "tx0_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx0_bet_type": 0, "tx0_block_index": 310014, "tx0_expiration": 10, "tx0_hash": "71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb", "tx0_index": 15, "tx1_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_bet_type": 1, "tx1_block_index": 310015, "tx1_expiration": 10, "tx1_hash": "836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5", "tx1_index": 16}',0);
INSERT INTO messages VALUES(61,310016,'insert','credits','{"action": "recredit forward quantity", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310016, "event": "71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb_836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5", "quantity": 150000000}',0);
INSERT INTO messages VALUES(62,310016,'insert','credits','{"action": "recredit backward quantity", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310016, "event": "71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb_836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5", "quantity": 350000000}',0);
INSERT INTO messages VALUES(63,310016,'update','bet_matches','{"bet_match_id": "71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb_836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5", "status": "expired"}',0);
INSERT INTO messages VALUES(64,310016,'insert','bet_match_expirations','{"bet_match_id": "71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb_836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5", "block_index": 310016, "tx0_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(65,310016,'insert','debits','{"action": "bet", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310016, "event": "39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b", "quantity": 750000000}',0);
INSERT INTO messages VALUES(66,310016,'insert','bets','{"bet_type": 2, "block_index": 310016, "counterwager_quantity": 650000000, "counterwager_remaining": 650000000, "deadline": 1388000200, "expiration": 10, "expire_index": 310026, "fee_fraction_int": 5000000.0, "feed_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 5040, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 1.0, "tx_hash": "39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b", "tx_index": 17, "wager_quantity": 750000000, "wager_remaining": 750000000}',0);
INSERT INTO messages VALUES(67,310017,'insert','debits','{"action": "bet", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310017, "event": "0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0", "quantity": 650000000}',0);
INSERT INTO messages VALUES(68,310017,'insert','bets','{"bet_type": 3, "block_index": 310017, "counterwager_quantity": 750000000, "counterwager_remaining": 750000000, "deadline": 1388000200, "expiration": 10, "expire_index": 310027, "fee_fraction_int": 5000000.0, "feed_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "leverage": 5040, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "target_value": 1.0, "tx_hash": "0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0", "tx_index": 18, "wager_quantity": 650000000, "wager_remaining": 650000000}',0);
INSERT INTO messages VALUES(69,310017,'insert','credits','{"action": "filled", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310017, "event": "0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0", "quantity": 0}',0);
INSERT INTO messages VALUES(70,310017,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(71,310017,'insert','credits','{"action": "filled", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310017, "event": "0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0", "quantity": 0}',0);
INSERT INTO messages VALUES(72,310017,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(73,310017,'insert','bet_matches','{"backward_quantity": 650000000, "block_index": 310017, "deadline": 1388000200, "fee_fraction_int": 5000000, "feed_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "forward_quantity": 750000000, "id": "39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b_0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0", "initial_value": 100.0, "leverage": 5040, "match_expire_index": 310026, "status": "pending", "target_value": 1.0, "tx0_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx0_bet_type": 2, "tx0_block_index": 310016, "tx0_expiration": 10, "tx0_hash": "39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b", "tx0_index": 17, "tx1_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_bet_type": 3, "tx1_block_index": 310017, "tx1_expiration": 10, "tx1_hash": "0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0", "tx1_index": 18}',0);
INSERT INTO messages VALUES(74,310018,'insert','credits','{"action": "recredit forward quantity", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310018, "event": "39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b_0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0", "quantity": 750000000}',0);
INSERT INTO messages VALUES(75,310018,'insert','credits','{"action": "recredit backward quantity", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310018, "event": "39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b_0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0", "quantity": 650000000}',0);
INSERT INTO messages VALUES(76,310018,'update','bet_matches','{"bet_match_id": "39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b_0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0", "status": "expired"}',0);
INSERT INTO messages VALUES(77,310018,'insert','bet_match_expirations','{"bet_match_id": "39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b_0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0", "block_index": 310018, "tx0_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "tx1_address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(78,310018,'insert','broadcasts','{"block_index": 310018, "fee_fraction_int": 5000000, "locked": false, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "text": "Unit Test", "timestamp": 1388000050, "tx_hash": "aa5f6d46e9e43dd0c765738c881628b281d5d88fa8f8f280abd62aaae01049ba", "tx_index": 19, "value": 99.86166}',0);
INSERT INTO messages VALUES(79,310019,'insert','broadcasts','{"block_index": 310019, "fee_fraction_int": 5000000, "locked": false, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "text": "Unit Test", "timestamp": 1388000101, "tx_hash": "1b65792893f37c8a62175470b24dbfb35d026680ecc48c7f66695e944061c768", "tx_index": 20, "value": 100.343}',0);
INSERT INTO messages VALUES(80,310020,'insert','broadcasts','{"block_index": 310020, "fee_fraction_int": 5000000, "locked": false, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "text": "Unit Test", "timestamp": 1388000201, "tx_hash": "7954cf858f5ab400b267abb7b0681d84a43b2997ef43d6bd579732ba30e83a71", "tx_index": 21, "value": 2.0}',0);
INSERT INTO messages VALUES(81,310021,'insert','debits','{"action": "open order", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBB", "block_index": 310021, "event": "5e77d7764fafbf0ff360a2c7cc7c41c364b28bf8294e06be860b97ad193e4cef", "quantity": 50000000}',0);
INSERT INTO messages VALUES(82,310021,'insert','orders','{"block_index": 310021, "expiration": 10, "expire_index": 310031, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 50000000, "get_remaining": 50000000, "give_asset": "BBBB", "give_quantity": 50000000, "give_remaining": 50000000, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "open", "tx_hash": "5e77d7764fafbf0ff360a2c7cc7c41c364b28bf8294e06be860b97ad193e4cef", "tx_index": 22}',0);
INSERT INTO messages VALUES(83,310022,'insert','credits','{"action": "burn", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310022, "event": "c56318d85bacc3e96b131ebc4a914d12fa09f2a516b090f04b2f7a1085c1d53f", "quantity": 56999887262}',0);
INSERT INTO messages VALUES(84,310022,'insert','burns','{"block_index": 310022, "burned": 38000000, "earned": 56999887262, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "c56318d85bacc3e96b131ebc4a914d12fa09f2a516b090f04b2f7a1085c1d53f", "tx_index": 23}',0);
INSERT INTO messages VALUES(85,310023,'update','bets','{"status": "expired", "tx_hash": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217"}',0);
INSERT INTO messages VALUES(86,310023,'insert','credits','{"action": "recredit wager remaining", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "XCP", "block_index": 310023, "event": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217", "quantity": 8500000}',0);
INSERT INTO messages VALUES(87,310023,'insert','bet_expirations','{"bet_hash": "474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217", "bet_index": 13, "block_index": 310023, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
INSERT INTO messages VALUES(88,310023,'insert','debits','{"action": "send", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBC", "block_index": 310023, "event": "aacc38b5a85e03ed4c215777292043d348303a7811d67acfa57f6b545a6c6fc7", "quantity": 10000}',0);
INSERT INTO messages VALUES(89,310023,'insert','credits','{"action": "send", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "asset": "BBBC", "block_index": 310023, "event": "aacc38b5a85e03ed4c215777292043d348303a7811d67acfa57f6b545a6c6fc7", "quantity": 10000}',0);
INSERT INTO messages VALUES(90,310023,'insert','sends','{"asset": "BBBC", "block_index": 310023, "destination": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3", "quantity": 10000, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "status": "valid", "tx_hash": "aacc38b5a85e03ed4c215777292043d348303a7811d67acfa57f6b545a6c6fc7", "tx_index": 24}',0);
INSERT INTO messages VALUES(91,310032,'update','orders','{"status": "expired", "tx_hash": "5e77d7764fafbf0ff360a2c7cc7c41c364b28bf8294e06be860b97ad193e4cef"}',0);
INSERT INTO messages VALUES(92,310032,'insert','credits','{"action": "cancel order", "address": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3", "asset": "BBBB", "block_index": 310032, "event": "5e77d7764fafbf0ff360a2c7cc7c41c364b28bf8294e06be860b97ad193e4cef", "quantity": 50000000}',0);
INSERT INTO messages VALUES(93,310032,'insert','order_expirations','{"block_index": 310032, "order_hash": "5e77d7764fafbf0ff360a2c7cc7c41c364b28bf8294e06be860b97ad193e4cef", "order_index": 22, "source": "3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3"}',0);
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
INSERT INTO order_expirations VALUES(3,'17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310013);
INSERT INTO order_expirations VALUES(4,'89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310014);
INSERT INTO order_expirations VALUES(22,'5e77d7764fafbf0ff360a2c7cc7c41c364b28bf8294e06be860b97ad193e4cef','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',310032);
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
INSERT INTO order_matches VALUES('17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b_89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345',3,'17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',4,'89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BTC',50000000,'XCP',100000000,310002,310003,310003,10,10,310023,857142,'completed');
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
INSERT INTO orders VALUES(3,'17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b',310002,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BTC',50000000,0,'XCP',100000000,0,10,310012,0,0,1000000,142858,'expired');
INSERT INTO orders VALUES(4,'89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345',310003,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','XCP',105000000,5000000,'BTC',50000000,0,10,310013,900000,42858,10000,10000,'expired');
INSERT INTO orders VALUES(22,'5e77d7764fafbf0ff360a2c7cc7c41c364b28bf8294e06be860b97ad193e4cef',310021,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','BBBB',50000000,50000000,'XCP',50000000,50000000,10,310031,0,0,10000,10000,'expired');
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
INSERT INTO sends VALUES(2,'b3018f8bb0e1b3c263fd9f90ed111550d12859b2d4c48d8a7dc370942f3d5572',310001,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','XCP',50000000,'valid');
INSERT INTO sends VALUES(8,'2cd2a785c1b7d7588e0eff9d29992a078b24d4ea3c19899f971521d115bf5497',310007,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBB',4000000,'valid');
INSERT INTO sends VALUES(9,'cea6cfb79722c19ef2198328534d6a02cef6ca1f662a79edf69af939f805cfdf',310008,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBC',526,'valid');
INSERT INTO sends VALUES(24,'aacc38b5a85e03ed4c215777292043d348303a7811d67acfa57f6b545a6c6fc7',310023,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3','BBBC',10000,'valid');
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
INSERT INTO transactions VALUES(1,'e99914fcf580f8705559fce8796ffa216d4a3aef2abc95783df5cabea2f0966b',310000,'505d8d82c4ced7daddef7ed0b05ba12ecc664176887b938ef56c6af276f3b30c',1419700000,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,10000,X'',1);
INSERT INTO transactions VALUES(2,'b3018f8bb0e1b3c263fd9f90ed111550d12859b2d4c48d8a7dc370942f3d5572',310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',1419700100,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3',7800,10000,X'0000000000000000000000010000000002FAF080',1);
INSERT INTO transactions VALUES(3,'17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b',310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',1419700200,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,1000000,X'0000000A00000000000000000000000002FAF08000000000000000010000000005F5E100000A0000000000000000',1);
INSERT INTO transactions VALUES(4,'89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345',310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',1419700300,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000000A00000000000000010000000006422C4000000000000000000000000002FAF080000A00000000000DBBA0',1);
INSERT INTO transactions VALUES(5,'76e0c3747a1537888c0e2b55b6c4b04b7a0bf8a2c616cd48687139b589ed6151',310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',1419700400,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',50000000,10000,X'0000000B17500C776ECB9D1AAD1CFA0407E2248C890537934132BB6EC52970C3530A157B89E7F3EA3C4C7BB01AC12D4B4EB8583E8D5351F7D03CF2221C194D324C3CE345',1);
INSERT INTO transactions VALUES(6,'44eb0557f8ce3d042d0e3fe0b0a0db98b12ffa20a95d3c17012a042583ecf60c',310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',1419700500,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'000000140000000000004767000000003B9ACA000100000000000000000000',1);
INSERT INTO transactions VALUES(7,'073653f9647af19b87437d535bfd0f29b8a54b37f8fb2840c876be1c43d903b7',310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',1419700600,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'00000014000000000000476800000000000186A00000000000000000000006666F6F626172',1);
INSERT INTO transactions VALUES(8,'2cd2a785c1b7d7588e0eff9d29992a078b24d4ea3c19899f971521d115bf5497',310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',1419700700,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3',7800,10000,X'00000000000000000000476700000000003D0900',1);
INSERT INTO transactions VALUES(9,'cea6cfb79722c19ef2198328534d6a02cef6ca1f662a79edf69af939f805cfdf',310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',1419700800,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3',7800,10000,X'000000000000000000004768000000000000020E',1);
INSERT INTO transactions VALUES(10,'5e2e7a2b1d5348a5d53e3dd031190448091a67f0ba8e84175de2de2be6192845',310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',1419700900,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'00000032000000000000025800000000000047670000000000000001',1);
INSERT INTO transactions VALUES(11,'74fb6e695c2769d8a2a0ce715a9d70138eed6887b0ebb9919b402b034ee4e54b',310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',1419701000,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'00000032000000000000032000000000000047680000000000000001',1);
INSERT INTO transactions VALUES(12,'cbcdc363cec1baae37d0a402de588bd2152b958c06723a34cba26d78bb0cdead',310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',1419701100,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000001E52BB33004059000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(13,'474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217',310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',1419701200,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000052BB33640000000002FAF08000000000017D7840000000000000000000003B100000000A',1);
INSERT INTO transactions VALUES(14,'b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a',310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',1419701300,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000152BB336400000000017D78400000000002793D60000000000000000000003B100000000A',1);
INSERT INTO transactions VALUES(15,'71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb',310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',1419701400,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000052BB33640000000008F0D1800000000014DC93800000000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(16,'836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5',310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',1419701500,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000152BB33640000000014DC93800000000008F0D1800000000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(17,'39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b',310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',1419701600,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000252BB33C8000000002CB417800000000026BE36803FF0000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(18,'0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0',310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',1419701700,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3',7800,10000,X'00000028000352BB33C80000000026BE3680000000002CB417803FF0000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(19,'aa5f6d46e9e43dd0c765738c881628b281d5d88fa8f8f280abd62aaae01049ba',310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',1419701800,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000001E52BB33324058F7256FFC115E004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(20,'1b65792893f37c8a62175470b24dbfb35d026680ecc48c7f66695e944061c768',310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',1419701900,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000001E52BB3365405915F3B645A1CB004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(21,'7954cf858f5ab400b267abb7b0681d84a43b2997ef43d6bd579732ba30e83a71',310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',1419702000,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000001E52BB33C94000000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(22,'5e77d7764fafbf0ff360a2c7cc7c41c364b28bf8294e06be860b97ad193e4cef',310021,'7c2460bb32c5749c856486393239bf7a0ac789587ac71f32e7237910da8097f2',1419702100,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','',0,10000,X'0000000A00000000000047670000000002FAF08000000000000000010000000002FAF080000A0000000000000000',1);
INSERT INTO transactions VALUES(23,'c56318d85bacc3e96b131ebc4a914d12fa09f2a516b090f04b2f7a1085c1d53f',310022,'44435f9a99a0aa12a9bfabdc4cb8119f6ea6a6e1350d2d65445fb66a456db5fc',1419702200,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','mvCounterpartyXXXXXXXXXXXXXXW24Hef',100000000,10000,X'',1);
INSERT INTO transactions VALUES(24,'aacc38b5a85e03ed4c215777292043d348303a7811d67acfa57f6b545a6c6fc7',310023,'d8cf5bec1bbcab8ca4f495352afde3b6572b7e1d61b3976872ebb8e9d30ccb08',1419702300,'3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3','3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3',7800,10000,X'0000000000000000000047680000000000002710',1);
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
INSERT INTO undolog VALUES(4,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=93000000000 WHERE rowid=1');
INSERT INTO undolog VALUES(5,'DELETE FROM debits WHERE rowid=1');
INSERT INTO undolog VALUES(6,'DELETE FROM balances WHERE rowid=2');
INSERT INTO undolog VALUES(7,'DELETE FROM credits WHERE rowid=2');
INSERT INTO undolog VALUES(8,'DELETE FROM sends WHERE rowid=2');
INSERT INTO undolog VALUES(9,'DELETE FROM orders WHERE rowid=1');
INSERT INTO undolog VALUES(10,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92950000000 WHERE rowid=1');
INSERT INTO undolog VALUES(11,'DELETE FROM debits WHERE rowid=2');
INSERT INTO undolog VALUES(12,'DELETE FROM orders WHERE rowid=2');
INSERT INTO undolog VALUES(13,'UPDATE orders SET tx_index=3,tx_hash=''17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b'',block_index=310002,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',give_asset=''BTC'',give_quantity=50000000,give_remaining=50000000,get_asset=''XCP'',get_quantity=100000000,get_remaining=100000000,expiration=10,expire_index=310012,fee_required=0,fee_required_remaining=0,fee_provided=1000000,fee_provided_remaining=1000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(14,'UPDATE orders SET tx_index=4,tx_hash=''89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345'',block_index=310003,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',give_asset=''XCP'',give_quantity=105000000,give_remaining=105000000,get_asset=''BTC'',get_quantity=50000000,get_remaining=50000000,expiration=10,expire_index=310013,fee_required=900000,fee_required_remaining=900000,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(15,'DELETE FROM order_matches WHERE rowid=1');
INSERT INTO undolog VALUES(16,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92845000000 WHERE rowid=1');
INSERT INTO undolog VALUES(17,'DELETE FROM credits WHERE rowid=3');
INSERT INTO undolog VALUES(18,'UPDATE order_matches SET id=''17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b_89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345'',tx0_index=3,tx0_hash=''17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b'',tx0_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx1_index=4,tx1_hash=''89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345'',tx1_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',forward_asset=''BTC'',forward_quantity=50000000,backward_asset=''XCP'',backward_quantity=100000000,tx0_block_index=310002,tx1_block_index=310003,block_index=310003,tx0_expiration=10,tx1_expiration=10,match_expire_index=310023,fee_paid=857142,status=''pending'' WHERE rowid=1');
INSERT INTO undolog VALUES(19,'DELETE FROM btcpays WHERE rowid=5');
INSERT INTO undolog VALUES(20,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92945000000 WHERE rowid=1');
INSERT INTO undolog VALUES(21,'DELETE FROM debits WHERE rowid=3');
INSERT INTO undolog VALUES(22,'DELETE FROM assets WHERE rowid=3');
INSERT INTO undolog VALUES(23,'DELETE FROM issuances WHERE rowid=6');
INSERT INTO undolog VALUES(24,'DELETE FROM balances WHERE rowid=3');
INSERT INTO undolog VALUES(25,'DELETE FROM credits WHERE rowid=4');
INSERT INTO undolog VALUES(26,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92895000000 WHERE rowid=1');
INSERT INTO undolog VALUES(27,'DELETE FROM debits WHERE rowid=4');
INSERT INTO undolog VALUES(28,'DELETE FROM assets WHERE rowid=4');
INSERT INTO undolog VALUES(29,'DELETE FROM issuances WHERE rowid=7');
INSERT INTO undolog VALUES(30,'DELETE FROM balances WHERE rowid=4');
INSERT INTO undolog VALUES(31,'DELETE FROM credits WHERE rowid=5');
INSERT INTO undolog VALUES(32,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''BBBB'',quantity=1000000000 WHERE rowid=3');
INSERT INTO undolog VALUES(33,'DELETE FROM debits WHERE rowid=5');
INSERT INTO undolog VALUES(34,'DELETE FROM balances WHERE rowid=5');
INSERT INTO undolog VALUES(35,'DELETE FROM credits WHERE rowid=6');
INSERT INTO undolog VALUES(36,'DELETE FROM sends WHERE rowid=8');
INSERT INTO undolog VALUES(37,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''BBBC'',quantity=100000 WHERE rowid=4');
INSERT INTO undolog VALUES(38,'DELETE FROM debits WHERE rowid=6');
INSERT INTO undolog VALUES(39,'DELETE FROM balances WHERE rowid=6');
INSERT INTO undolog VALUES(40,'DELETE FROM credits WHERE rowid=7');
INSERT INTO undolog VALUES(41,'DELETE FROM sends WHERE rowid=9');
INSERT INTO undolog VALUES(42,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92845000000 WHERE rowid=1');
INSERT INTO undolog VALUES(43,'DELETE FROM debits WHERE rowid=7');
INSERT INTO undolog VALUES(44,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92844999976 WHERE rowid=1');
INSERT INTO undolog VALUES(45,'DELETE FROM debits WHERE rowid=8');
INSERT INTO undolog VALUES(46,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3'',asset=''XCP'',quantity=50000000 WHERE rowid=2');
INSERT INTO undolog VALUES(47,'DELETE FROM credits WHERE rowid=8');
INSERT INTO undolog VALUES(48,'DELETE FROM dividends WHERE rowid=10');
INSERT INTO undolog VALUES(49,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92844979976 WHERE rowid=1');
INSERT INTO undolog VALUES(50,'DELETE FROM debits WHERE rowid=9');
INSERT INTO undolog VALUES(51,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92844559176 WHERE rowid=1');
INSERT INTO undolog VALUES(52,'DELETE FROM debits WHERE rowid=10');
INSERT INTO undolog VALUES(53,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3'',asset=''XCP'',quantity=50000024 WHERE rowid=2');
INSERT INTO undolog VALUES(54,'DELETE FROM credits WHERE rowid=9');
INSERT INTO undolog VALUES(55,'DELETE FROM dividends WHERE rowid=11');
INSERT INTO undolog VALUES(56,'DELETE FROM broadcasts WHERE rowid=12');
INSERT INTO undolog VALUES(57,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92844539176 WHERE rowid=1');
INSERT INTO undolog VALUES(58,'DELETE FROM debits WHERE rowid=11');
INSERT INTO undolog VALUES(59,'DELETE FROM bets WHERE rowid=1');
INSERT INTO undolog VALUES(60,'UPDATE orders SET tx_index=3,tx_hash=''17500c776ecb9d1aad1cfa0407e2248c890537934132bb6ec52970c3530a157b'',block_index=310002,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',give_asset=''BTC'',give_quantity=50000000,give_remaining=0,get_asset=''XCP'',get_quantity=100000000,get_remaining=0,expiration=10,expire_index=310012,fee_required=0,fee_required_remaining=0,fee_provided=1000000,fee_provided_remaining=142858,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(61,'DELETE FROM order_expirations WHERE rowid=3');
INSERT INTO undolog VALUES(62,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92794539176 WHERE rowid=1');
INSERT INTO undolog VALUES(63,'DELETE FROM debits WHERE rowid=12');
INSERT INTO undolog VALUES(64,'DELETE FROM bets WHERE rowid=2');
INSERT INTO undolog VALUES(65,'UPDATE bets SET tx_index=13,tx_hash=''474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217'',block_index=310012,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=0,deadline=1388000100,wager_quantity=50000000,wager_remaining=50000000,counterwager_quantity=25000000,counterwager_remaining=25000000,target_value=0.0,leverage=15120,expiration=10,expire_index=310022,fee_fraction_int=5000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(66,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92769539176 WHERE rowid=1');
INSERT INTO undolog VALUES(67,'DELETE FROM credits WHERE rowid=10');
INSERT INTO undolog VALUES(68,'UPDATE bets SET tx_index=14,tx_hash=''b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a'',block_index=310013,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=1,deadline=1388000100,wager_quantity=25000000,wager_remaining=25000000,counterwager_quantity=41500000,counterwager_remaining=41500000,target_value=0.0,leverage=15120,expiration=10,expire_index=310023,fee_fraction_int=5000000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(69,'DELETE FROM bet_matches WHERE rowid=1');
INSERT INTO undolog VALUES(70,'UPDATE orders SET tx_index=4,tx_hash=''89e7f3ea3c4c7bb01ac12d4b4eb8583e8d5351f7d03cf2221c194d324c3ce345'',block_index=310003,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',give_asset=''XCP'',give_quantity=105000000,give_remaining=5000000,get_asset=''BTC'',get_quantity=50000000,get_remaining=0,expiration=10,expire_index=310013,fee_required=900000,fee_required_remaining=42858,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(71,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92773789176 WHERE rowid=1');
INSERT INTO undolog VALUES(72,'DELETE FROM credits WHERE rowid=11');
INSERT INTO undolog VALUES(73,'DELETE FROM order_expirations WHERE rowid=4');
INSERT INTO undolog VALUES(74,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92778789176 WHERE rowid=1');
INSERT INTO undolog VALUES(75,'DELETE FROM credits WHERE rowid=12');
INSERT INTO undolog VALUES(76,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92820289176 WHERE rowid=1');
INSERT INTO undolog VALUES(77,'DELETE FROM credits WHERE rowid=13');
INSERT INTO undolog VALUES(78,'UPDATE bet_matches SET id=''474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217_b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a'',tx0_index=13,tx0_hash=''474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217'',tx0_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx1_index=14,tx1_hash=''b6ab4f2363ce97a477c221d13201d2bb74bfb0486e09ec3210bd839d9f77e19a'',tx1_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx0_bet_type=0,tx1_bet_type=1,feed_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',initial_value=100,deadline=1388000100,target_value=0.0,leverage=15120,forward_quantity=41500000,backward_quantity=20750000,tx0_block_index=310012,tx1_block_index=310013,block_index=310013,tx0_expiration=10,tx1_expiration=10,match_expire_index=310022,fee_fraction_int=5000000,status=''pending'' WHERE rowid=1');
INSERT INTO undolog VALUES(79,'DELETE FROM bet_match_expirations WHERE rowid=1');
INSERT INTO undolog VALUES(80,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(81,'DELETE FROM debits WHERE rowid=13');
INSERT INTO undolog VALUES(82,'DELETE FROM bets WHERE rowid=3');
INSERT INTO undolog VALUES(83,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92691039176 WHERE rowid=1');
INSERT INTO undolog VALUES(84,'DELETE FROM debits WHERE rowid=14');
INSERT INTO undolog VALUES(85,'DELETE FROM bets WHERE rowid=4');
INSERT INTO undolog VALUES(86,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(87,'DELETE FROM credits WHERE rowid=14');
INSERT INTO undolog VALUES(88,'UPDATE bets SET tx_index=15,tx_hash=''71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb'',block_index=310014,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=0,deadline=1388000100,wager_quantity=150000000,wager_remaining=150000000,counterwager_quantity=350000000,counterwager_remaining=350000000,target_value=0.0,leverage=5040,expiration=10,expire_index=310024,fee_fraction_int=5000000,status=''open'' WHERE rowid=3');
INSERT INTO undolog VALUES(89,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(90,'DELETE FROM credits WHERE rowid=15');
INSERT INTO undolog VALUES(91,'UPDATE bets SET tx_index=16,tx_hash=''836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5'',block_index=310015,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=1,deadline=1388000100,wager_quantity=350000000,wager_remaining=350000000,counterwager_quantity=150000000,counterwager_remaining=150000000,target_value=0.0,leverage=5040,expiration=10,expire_index=310025,fee_fraction_int=5000000,status=''open'' WHERE rowid=4');
INSERT INTO undolog VALUES(92,'DELETE FROM bet_matches WHERE rowid=2');
INSERT INTO undolog VALUES(93,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(94,'DELETE FROM credits WHERE rowid=16');
INSERT INTO undolog VALUES(95,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92491039176 WHERE rowid=1');
INSERT INTO undolog VALUES(96,'DELETE FROM credits WHERE rowid=17');
INSERT INTO undolog VALUES(97,'UPDATE bet_matches SET id=''71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb_836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5'',tx0_index=15,tx0_hash=''71fe2222b0f725e5b85733eaf21827fb072770962e82205315051dc9e6dcbefb'',tx0_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx1_index=16,tx1_hash=''836ee84d52af92779eadc29cb60f73a6476d086bc1e578b690e0a2bb847f15c5'',tx1_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx0_bet_type=0,tx1_bet_type=1,feed_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',initial_value=100,deadline=1388000100,target_value=0.0,leverage=5040,forward_quantity=150000000,backward_quantity=350000000,tx0_block_index=310014,tx1_block_index=310015,block_index=310015,tx0_expiration=10,tx1_expiration=10,match_expire_index=310024,fee_fraction_int=5000000,status=''pending'' WHERE rowid=2');
INSERT INTO undolog VALUES(98,'DELETE FROM bet_match_expirations WHERE rowid=2');
INSERT INTO undolog VALUES(99,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(100,'DELETE FROM debits WHERE rowid=15');
INSERT INTO undolog VALUES(101,'DELETE FROM bets WHERE rowid=5');
INSERT INTO undolog VALUES(102,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92091039176 WHERE rowid=1');
INSERT INTO undolog VALUES(103,'DELETE FROM debits WHERE rowid=16');
INSERT INTO undolog VALUES(104,'DELETE FROM bets WHERE rowid=6');
INSERT INTO undolog VALUES(105,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(106,'DELETE FROM credits WHERE rowid=18');
INSERT INTO undolog VALUES(107,'UPDATE bets SET tx_index=17,tx_hash=''39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b'',block_index=310016,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=2,deadline=1388000200,wager_quantity=750000000,wager_remaining=750000000,counterwager_quantity=650000000,counterwager_remaining=650000000,target_value=1.0,leverage=5040,expiration=10,expire_index=310026,fee_fraction_int=5000000,status=''open'' WHERE rowid=5');
INSERT INTO undolog VALUES(108,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(109,'DELETE FROM credits WHERE rowid=19');
INSERT INTO undolog VALUES(110,'UPDATE bets SET tx_index=18,tx_hash=''0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0'',block_index=310017,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=3,deadline=1388000200,wager_quantity=650000000,wager_remaining=650000000,counterwager_quantity=750000000,counterwager_remaining=750000000,target_value=1.0,leverage=5040,expiration=10,expire_index=310027,fee_fraction_int=5000000,status=''open'' WHERE rowid=6');
INSERT INTO undolog VALUES(111,'DELETE FROM bet_matches WHERE rowid=3');
INSERT INTO undolog VALUES(112,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(113,'DELETE FROM credits WHERE rowid=20');
INSERT INTO undolog VALUES(114,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92191039176 WHERE rowid=1');
INSERT INTO undolog VALUES(115,'DELETE FROM credits WHERE rowid=21');
INSERT INTO undolog VALUES(116,'UPDATE bet_matches SET id=''39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b_0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0'',tx0_index=17,tx0_hash=''39351adb4fef0d137d9ba7f04f1217c2d4af94462072ccc09391effac4cfc12b'',tx0_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx1_index=18,tx1_hash=''0e6f27447aa52690c52831281a9b7f3d1fb9396da2671b31e6c9aa630a6958e0'',tx1_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',tx0_bet_type=2,tx1_bet_type=3,feed_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',initial_value=100,deadline=1388000200,target_value=1.0,leverage=5040,forward_quantity=750000000,backward_quantity=650000000,tx0_block_index=310016,tx1_block_index=310017,block_index=310017,tx0_expiration=10,tx1_expiration=10,match_expire_index=310026,fee_fraction_int=5000000,status=''pending'' WHERE rowid=3');
INSERT INTO undolog VALUES(117,'DELETE FROM bet_match_expirations WHERE rowid=3');
INSERT INTO undolog VALUES(118,'DELETE FROM broadcasts WHERE rowid=19');
INSERT INTO undolog VALUES(119,'DELETE FROM broadcasts WHERE rowid=20');
INSERT INTO undolog VALUES(120,'DELETE FROM broadcasts WHERE rowid=21');
INSERT INTO undolog VALUES(121,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''BBBB'',quantity=996000000 WHERE rowid=3');
INSERT INTO undolog VALUES(122,'DELETE FROM debits WHERE rowid=17');
INSERT INTO undolog VALUES(123,'DELETE FROM orders WHERE rowid=3');
INSERT INTO undolog VALUES(124,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(125,'DELETE FROM credits WHERE rowid=22');
INSERT INTO undolog VALUES(126,'DELETE FROM burns WHERE rowid=23');
INSERT INTO undolog VALUES(127,'UPDATE bets SET tx_index=13,tx_hash=''474650e2d71f27d520c184db31965379c2ae2affe1be9224ca5879339088c217'',block_index=310012,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',feed_address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',bet_type=0,deadline=1388000100,wager_quantity=50000000,wager_remaining=8500000,counterwager_quantity=25000000,counterwager_remaining=4250000,target_value=0.0,leverage=15120,expiration=10,expire_index=310022,fee_fraction_int=5000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(128,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''XCP'',quantity=149840926438 WHERE rowid=1');
INSERT INTO undolog VALUES(129,'DELETE FROM credits WHERE rowid=23');
INSERT INTO undolog VALUES(130,'DELETE FROM bet_expirations WHERE rowid=13');
INSERT INTO undolog VALUES(131,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''BBBC'',quantity=99474 WHERE rowid=4');
INSERT INTO undolog VALUES(132,'DELETE FROM debits WHERE rowid=18');
INSERT INTO undolog VALUES(133,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj_3'',asset=''BBBC'',quantity=526 WHERE rowid=6');
INSERT INTO undolog VALUES(134,'DELETE FROM credits WHERE rowid=24');
INSERT INTO undolog VALUES(135,'DELETE FROM sends WHERE rowid=24');
INSERT INTO undolog VALUES(136,'UPDATE orders SET tx_index=22,tx_hash=''5e77d7764fafbf0ff360a2c7cc7c41c364b28bf8294e06be860b97ad193e4cef'',block_index=310021,source=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',give_asset=''BBBB'',give_quantity=50000000,give_remaining=50000000,get_asset=''XCP'',get_quantity=50000000,get_remaining=50000000,expiration=10,expire_index=310031,fee_required=0,fee_required_remaining=0,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=3');
INSERT INTO undolog VALUES(137,'UPDATE balances SET address=''3_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_3'',asset=''BBBB'',quantity=946000000 WHERE rowid=3');
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
