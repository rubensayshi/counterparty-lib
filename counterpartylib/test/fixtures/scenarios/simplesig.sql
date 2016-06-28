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
INSERT INTO balances VALUES('mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',149849426438);
INSERT INTO balances VALUES('mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',50420824);
INSERT INTO balances VALUES('mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBB',996000000);
INSERT INTO balances VALUES('mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBC',89474);
INSERT INTO balances VALUES('mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','BBBB',4000000);
INSERT INTO balances VALUES('mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','BBBC',10526);
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
INSERT INTO bet_expirations VALUES(13,'5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',310023);
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
INSERT INTO bet_match_expirations VALUES('5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a_edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',310014);
INSERT INTO bet_match_expirations VALUES('bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c_faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',310016);
INSERT INTO bet_match_expirations VALUES('0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d_864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',310018);
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
INSERT INTO bet_matches VALUES('5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a_edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a',13,'5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',14,'edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,1,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',100,1388000100,0.0,15120,41500000,20750000,310012,310013,310013,10,10,310022,5000000,'expired');
INSERT INTO bet_matches VALUES('bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c_faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67',15,'bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',16,'faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,1,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',100,1388000100,0.0,5040,150000000,350000000,310014,310015,310015,10,10,310024,5000000,'expired');
INSERT INTO bet_matches VALUES('0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d_864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715',17,'0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',18,'864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',2,3,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',100,1388000200,1.0,5040,750000000,650000000,310016,310017,310017,10,10,310026,5000000,'expired');
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
INSERT INTO bets VALUES(13,'5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a',310012,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,1388000100,50000000,8500000,25000000,4250000,0.0,15120,10,310022,5000000,'expired');
INSERT INTO bets VALUES(14,'edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a',310013,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',1,1388000100,25000000,4250000,41500000,0,0.0,15120,10,310023,5000000,'filled');
INSERT INTO bets VALUES(15,'bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c',310014,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,1388000100,150000000,0,350000000,0,0.0,5040,10,310024,5000000,'filled');
INSERT INTO bets VALUES(16,'faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67',310015,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',1,1388000100,350000000,0,150000000,0,0.0,5040,10,310025,5000000,'filled');
INSERT INTO bets VALUES(17,'0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d',310016,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',2,1388000200,750000000,0,650000000,0,1.0,5040,10,310026,5000000,'filled');
INSERT INTO bets VALUES(18,'864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715',310017,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',3,1388000200,650000000,0,750000000,0,1.0,5040,10,310027,5000000,'filled');
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
INSERT INTO blocks VALUES(310000,'505d8d82c4ced7daddef7ed0b05ba12ecc664176887b938ef56c6af276f3b30c',1419700000,NULL,NULL,'f3e1d432b546670845393fae1465975aa99602a7648e0da125e6b8f4d55cbcac','0fc8b9a115ba49c78879c5d75b92bdccd2f5e398e8e8042cc9d0e4568cea9f53','88838f2cfc1eef675714adf7cfef07e7934a12ae60cfa75ca571888ef3d47b5c');
INSERT INTO blocks VALUES(310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',1419700100,NULL,NULL,'799a07e7b411c96c92618baa5b998db22fa9ac0a9f7e231e571a237132a813c7','2232e3c5e460148e6c3170643de634af34b78e3c6778b5cda5d0a9f361c05186','bf633fa02403943431451d766dd6bda164a5750fe24a40fbf0dc5593eceae22a');
INSERT INTO blocks VALUES(310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',1419700200,NULL,NULL,'c5ac2b0cc1745402a7693afc6e5aa4394c1c2c1c70b069911fa793cfef55a4d3','28ffcc056815d1bd8fb9b15101e75318643348dfae3de71c4c8f15b3603e7781','008554413f04fecfab22254a59f36a513ebc91dea343930cefa454e1a3d1141e');
INSERT INTO blocks VALUES(310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',1419700300,NULL,NULL,'0c22178d665b7b83b80d9686df23f12ecd6ae3a5744b729c528f9ecc3c94b051','79e7f0d78f450f30b7a24060d08a6c457ae3f66bae1869c739134d79fb25b58e','53d87de16d9e5fa9461c0657b2b2aba2fbee5d9cf4873898dfc6d92a300b0290');
INSERT INTO blocks VALUES(310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',1419700400,NULL,NULL,'9b1bb2d232c1e24fd52c4fd299776924fae5b0deab3d37dc359632777c80294b','8f22bb96e46eb95cb5fc28625ec4a11e910082820713fb0f139e4c00d2260cf8','3309e278511bcc4dfc3a84353652c094d2c00dd60c1c187d4acc4a0b5ddcdcb7');
INSERT INTO blocks VALUES(310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',1419700500,NULL,NULL,'92ab51eb151104ac16d901ee7bddd5b6cec176a7ce91359b331767963bdbc2f8','9cba99d917c0978ea045695e5ea30f2394f8583e097e7a9a2510cb7f316e2087','8417e1bf70a6f5fb3bfd2dadf524c533f81278ddc1509d213e4d518a018e06b4');
INSERT INTO blocks VALUES(310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',1419700600,NULL,NULL,'ca4d8f6af1678bc1c40c60b97d409d1503b6a93cffc828a132abe7fd4f77a911','6e58e2efdeceaa2b277a02268bee313f08e389dbbc8d8c80f98d179c73a2e395','98e32478f3c6b43d0bf4fc41db167617ef8c6041fc272cbe9e701ab8c3cfb0b6');
INSERT INTO blocks VALUES(310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',1419700700,NULL,NULL,'ec5ea53c7c9980060c08faa94fe708d0560bd4667843071cdd49ca07781f8197','96861e114b5429406a5863acebdcb44633898c6f59c4b15eb95d87f428796df4','9d486d0e558a12175c309b966655d10816ff1e6aec1fa21879e737128ecc8cd5');
INSERT INTO blocks VALUES(310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',1419700800,NULL,NULL,'c805eed4b9512a6d277cc5814145f6db7a12ddce6f9df1a1656aafd11730c433','33c928168cec22c62351622dbb777f02e8c16b1ddbe5ed208b600913957d14d9','93a59ba291e911f994cef10c8298a7fce5712ec4ec036462850473b65c8bad1b');
INSERT INTO blocks VALUES(310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',1419700900,NULL,NULL,'89b985b58171d607af4fca31f87774e68ffe9c5e6ce6819555242df327225300','66624aee36323782397a05fa187736123469fa715e81a5c2644a136e10676dc5','e7ff38221b51714138836fdf286673150c8cfb0ed81d063ccff6d14e89d60ece');
INSERT INTO blocks VALUES(310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',1419701000,NULL,NULL,'9364be6a0b1c52254b405f51631f654b7670b1e8befc3171cd3d6b00e8679b5e','0c15109bea6696aed0c06aac8c13c250d556d8f9cc7859ff25a4f539bc35a831','8f4f43582796918e9dcb649e81d4b883441a68df54e0d17cebbe6a4dd2c4b360');
INSERT INTO blocks VALUES(310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',1419701100,NULL,NULL,'8d855d1d96fc2439e12cea023a8b89188d66af4f2b0909899088f6f49bc19788','264818523740e398ed833c5e7b34a2cf9e5949675059bfb775e4cf541d02fa2f','f025eb31c4a9ce9fe2b69eb4e8c605f0e23c1caaadc2b9d3c6fa6f7c3d494fb5');
INSERT INTO blocks VALUES(310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',1419701200,NULL,NULL,'c44aa2983ed171cc07ff6e5d0c4b5c8b11e5d91dd07e38be0c1b9125ae3bf456','a984e362c397e3784e4a90561c01e53e6e4dd1e7eaa369b610387b4866ab92de','76dccceba60e337cb63e5679fbf834e62a4392fa3dce28ed669e17cb3e52e48a');
INSERT INTO blocks VALUES(310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',1419701300,NULL,NULL,'5be56741bca8dec52d2a67e53dcd63160d4526f7dc0df67fda0de77bf4e9da8a','97090ae9efbabaeec9a98851237df96e334a9a83edd4544c611235d785e4c04a','87e4f0b01d11d5c66bec5f8328c90380856d77ab308900c32253ed809b640b6d');
INSERT INTO blocks VALUES(310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',1419701400,NULL,NULL,'105326aeb7876e56f1ee5efd3c91accf5903827884fe327f6a0333fad39e3a75','73b7fbf41550001a033797d12f2bab25add240780c4b8daa039792ffd1e6533a','a047bb82e5fc2e5ebea3dcde3588b0aef980c32e02757ea5a4357f22fe606808');
INSERT INTO blocks VALUES(310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',1419701500,NULL,NULL,'73eb93f8ebb8d2c1c481de12cb1af0d0f1e1e4ea2d71404dd5abd1580f00dc84','f52ada585f5c697b6649a31479bab9d63f96c73a5903146bfe13c50ed786d2de','fae918c6bd8709ab72f5a018c268a665e12d6903af530b87bdd00bdf3ebda1ec');
INSERT INTO blocks VALUES(310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',1419701600,NULL,NULL,'9a55337dcc6aff12a73ee5cfa654547998a15c6b831aca1140dda8dcc6be768a','737eb368596ffe1ec9e78446c71422bba061eaf65d45dbf9066c3be44589ca80','cfebf08f4ee0d60fb4ede98b38d8df3b90c78abd11e686eed2cfb63ed0708bc4');
INSERT INTO blocks VALUES(310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',1419701700,NULL,NULL,'fb3d3934fb2fd3770a6f8029a350e5eb2ef74e6ecf88a22af8a9f795ba1bdd36','acaf199c9964d80d58c9044a5eadab04055a55db5195267117f8e68a3f12eeb8','ee1d3696def84c668e7464eae63bc34d3270f6120798fa41645f5d6fbd958a66');
INSERT INTO blocks VALUES(310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',1419701800,NULL,NULL,'e025e837ef2d698d54b27cd2574309b6bb1a08eb49b41e5cabd6a41cbd5d333e','eba60e9c8fde65eaf53815878a73a42e440db46ed06e33a9488739d0ec1cd648','6d3b95d7e938f2bf9ef0502abd6264dc080e48f983b84fabd56e78f388bfd1ba');
INSERT INTO blocks VALUES(310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',1419701900,NULL,NULL,'def09d934e0c65bdef83da8ba67e8bd3c2f4c54de0a8cce0106f9140fb8ef68d','8c75a20b7524ec41f1d3188a9f7915309f9a4b5abf746ec36ba3286647a0419f','405bc4ea487275be943c92a5dbbaa3338001c194e208ea24e81e197178b5a980');
INSERT INTO blocks VALUES(310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',1419702000,NULL,NULL,'254cf244a6b963f64cf461c69ef5a0e36f97d4f2955dbb49d73ad99d3c6445df','0a15d574b60d11688b540c813ccce992d4f933d4654ab4f64e515ffd7f9acb60','0575328f2f1ff0508565f0945293cb296f8bb359c7ca4b90680982b6b6902a29');
INSERT INTO blocks VALUES(310021,'7c2460bb32c5749c856486393239bf7a0ac789587ac71f32e7237910da8097f2',1419702100,NULL,NULL,'a93d16f0876728874c6f374d34d823ff18ccf6c6c3091b2e0f07bf73b2eecc5c','387f6da91e146039add192bf7ac60b65059736a449c00083bfe135c1e5de0979','32a700e50d4c8c195438cf95b72c20b9bae6553a775f676d62e182a223ffdea2');
INSERT INTO blocks VALUES(310022,'44435f9a99a0aa12a9bfabdc4cb8119f6ea6a6e1350d2d65445fb66a456db5fc',1419702200,NULL,NULL,'f6e05d3fe5aa3659e5481b00194f4be9cc1eea734f3d1e2e87cce1d529ad4270','c4adf61f734030268b9cfa6e5dac2f4da24e61fca8e4a1a0ddc185613bcd2b18','aba8adcab6595f8a93da1baeca1e4399f908f02d320c6a6adf9255a5f6166a77');
INSERT INTO blocks VALUES(310023,'d8cf5bec1bbcab8ca4f495352afde3b6572b7e1d61b3976872ebb8e9d30ccb08',1419702300,NULL,NULL,'00c54d6f0d13a3acccdc3dc608ed5386f9370ac203e692eb2630486fee18d0d4','90baaacd9e69dfd2a737cc3bc0099cc37c9f238158188a3eecd263989930e654','9d7573ce3527c5d1d3026c451cdd955e98f588d5b712bcaadf924532d92e921d');
INSERT INTO blocks VALUES(310024,'b03042b4e18a222b4c8d1e9e1970d93e6e2a2d41686d227ff8ecf0a839223dc5',1419702400,NULL,NULL,'df76cb732d79d60b75817b38967778afb2ccad2f52f77b817c2567a9c31321fb','bce413e5e2c676f19f025ece8b959f2214ea03285aafc9f80774f47a5946f1e6','a53d48ea51ba9af347d921fbf2c36d16544c8652081e15af8fb19694d0529e66');
INSERT INTO blocks VALUES(310025,'a872e560766832cc3b4f7f222228cb6db882ce3c54f6459f62c71d5cd6e90666',1419702500,NULL,NULL,'007e225cf707fccee6f3ec771a016ab19b5336c38f0dbe278801997678e0ffea','fcd55a2f4664eae9cdc5e5f9bb4c316c9f22dd854e21d16885236297bc51d8c2','321645723d5cee333ca7cf61e4c265a3a7d9cdaee3f09ac2fcd488179ce0a39c');
INSERT INTO blocks VALUES(310026,'6c96350f6f2f05810f19a689de235eff975338587194a36a70dfd0fcd490941a',1419702600,NULL,NULL,'1a62ce6621ec8bdf4f1380b7a2ff3fd826059586005fcc3375be964abdcb8bc9','d150a0c5dcc14cab2750c0c9d5a8271ae44d5e7e8d9a1067048d39a12c7aca62','ea793b73ca154297c1fac4e4310d134f24d3e80225869e06f04b7be7c7c19598');
INSERT INTO blocks VALUES(310027,'d7acfac66df393c4482a14c189742c0571b89442eb7f817b34415a560445699e',1419702700,NULL,NULL,'3204415735a4882957191b659b880e9b0d84f4e16149bd9e3f82447e6985e3f3','f3b12f616f9e32f9afc5ef8482f93634dca26362b4767a97270e8849e88e2e77','d74469ef81a9a16a0d61799ff7c5d8372c85131984c03c5e93e07cdde39eba7d');
INSERT INTO blocks VALUES(310028,'02409fcf8fa06dafcb7f11e38593181d9c42cc9d5e2ddc304d098f990bd9530b',1419702800,NULL,NULL,'1df2c271bdf635b731a4cf0aea7fc22a1c528b025a9a484d9c9c042cf1ec5c50','2aed660c0cbf6c579cc0797b876012f607a5d5ae2785903a3015973eda88ebdb','36acdb3ea6641284823fe80dfb8001f5840b98c705febeec4e0088ff1e61986b');
INSERT INTO blocks VALUES(310029,'3c739fa8b40c118d5547ea356ee8d10ee2898871907643ec02e5db9d00f03cc6',1419702900,NULL,NULL,'e92ea2ceac9a4c0a63e58269b2b5d10388995cee47a7823ff49e8247b58375e0','1ae90c082db0f0634a6035cd4f30055d898feca4cf7614b7525c39312a12df22','fcacfd32625e8cff5f9bc9dc9dc8e1597bd9f69115598ae33933cbb38fc8ca17');
INSERT INTO blocks VALUES(310030,'d5071cddedf89765ee0fd58f209c1c7d669ba8ea66200a57587da8b189b9e4f5',1419703000,NULL,NULL,'e6b8b206d8ee3d9c955a6b3d14db8f22e7212cd9cfe9ab47e2bdbe35f379b780','278ac956f294951dce31f8be0d05315b02556841603d46ccfc962f9be4c3dbb3','9636ddfbcee6fb3feb224fd291a733bbcea9dff24c486cfae5db7fe9cf34f225');
INSERT INTO blocks VALUES(310031,'0b02b10f41380fff27c543ea8891ecb845bf7a003ac5c87e15932aff3bfcf689',1419703100,NULL,NULL,'9fc2e86a0cf1cbf0ab73b8158b54863bb60e90c8ccb00423a57334118cd2b60e','05e2dd5758c2afbef5b403b80137269381f1cc7cc6ec32df0dc4f8d9fd51d83f','15374d2166913d8dc388a4ef742eab1eb7d98fefcda2795b38bf712f93c48f9a');
INSERT INTO blocks VALUES(310032,'66346be81e6ba04544f2ae643b76c2b7b1383f038fc2636e02e49dc7ec144074',1419703200,NULL,NULL,'e0802d82e53ff8c8f25ad6ccba8a5875ac4d009e4e5ca8e7d6962317c23f1ed7','66d763b3c0db8f223a6c640eb605a96099d5df0a4018e3f518f5d2938041fa2e','3c6f54d331f4d2319461ec91397bebb915fbdf35ffc55caad7e1942f3b5262ea');
INSERT INTO blocks VALUES(310033,'999c65df9661f73e8c01f1da1afda09ac16788b72834f0ff5ea3d1464afb4707',1419703300,NULL,NULL,'4d53f1e91da30c895c404e37289cc5722954b82f4abae396abfbe87872991f08','274b384f3e62eb9a1c100cf666c7635b5a5b3696bc4c08b9bde9923e72908aed','55ccbc20eabc96ca0d2dfab9918a20a2e6d738ee67c182fe856fa2e9898c06db');
INSERT INTO blocks VALUES(310034,'f552edd2e0a648230f3668e72ddf0ddfb1e8ac0f4c190f91b89c1a8c2e357208',1419703400,NULL,NULL,'670c3fea120a65e5039f1bf6d04dc28d624a2f6dfb075ee2873b5e7a49992296','6e8157aff22e9fd417f02eea81b2a73f6d59a26f89e7bbb08df5b42996dc14c5','775138bab8753b49d248fdd3dbbfba737080b2e7a30a323a444a47fd01026ec8');
INSERT INTO blocks VALUES(310035,'a13cbb016f3044207a46967a4ba1c87dab411f78c55c1179f2336653c2726ae2',1419703500,NULL,NULL,'6bd6d9da2d6d76e157763915f60bac81ca1706ca2dc163c518b35283779bb2b9','cb6a47ec031e6f5573bcf45904a4fd3fa37ba47a2fdd75d94bec6b480e0ff51c','9c8f539085662269db7dd4a16b7a8aaac81731f36d4dcf1ea8ba106e434022c0');
INSERT INTO blocks VALUES(310036,'158648a98f1e1bd1875584ce8449eb15a4e91a99a923bbb24c4210135cef0c76',1419703600,NULL,NULL,'db92fba1bcf104d96fdc65e933876309a0dfd095a9ac0994b2ab6dde5d4f849a','374bfa64231cf6254cc6c92e224077cb3d28d577a2964e0f5492116f4896db4c','e1c9976b4d3d10f59726cd9fd7af8bcdd5f063d42234bb21908a88f6842e653f');
INSERT INTO blocks VALUES(310037,'563acfd6d991ce256d5655de2e9429975c8dceeb221e76d5ec6e9e24a2c27c07',1419703700,NULL,NULL,'75258bf1a0fbd5be5983fc2262aab45d416ae34b2bf7a04288d41001d14ac0ac','68b96e616c61a614d56d3f32b4a69ad123968ea070d3a2274309549868859ac9','34cd3167c7a731822c894db07d322662052f85b8ef35ebabcf3f8b43ae224c01');
INSERT INTO blocks VALUES(310038,'b44b4cad12431c32df27940e18d51f63897c7472b70950d18454edfd640490b2',1419703800,NULL,NULL,'230efa5901fb584b6d962b57619ff18447cbe4d2d4a4e7448a7ed98fb8a16b8e','6cf687c194823c834ed1267cc2105a89a7799d2ac689ece2681f3d687c509a4c','762dc92bea74b52a9e059015790364433134d302a817f0a46706017a0f3ee733');
INSERT INTO blocks VALUES(310039,'5fa1ae9c5e8a599247458987b006ad3a57f686df1f7cc240bf119e911b56c347',1419703900,NULL,NULL,'8e512b8a9d618a08803373a9255f3dbd6bc362085029d1dce05cf93c49020926','5c1728476998542d3d7cd7e9168d029c5810a4f3a0fb8648941e93c6db85305c','2fbdc6362d8dd24da6a3f51ffa640c716885e912f98373dbab072bc208d3c2e3');
INSERT INTO blocks VALUES(310040,'7200ded406675453eadddfbb2d14c2a4526c7dc2b5de14bd48b29243df5e1aa3',1419704000,NULL,NULL,'ea94ae3d938a70e72e98efd4d6a4ab610cdcab6644d96c69b84051d7555f2bdb','3782801cf2c1fae2442b7ea20ca588fdac98903313a7780d956695095e5791c2','a01c4bb0b30b704b8f455de4d059b7b5caffcc918859888211b289c20c77dccd');
INSERT INTO blocks VALUES(310041,'5db592ff9ba5fac1e030cf22d6c13b70d330ba397f415340086ee7357143b359',1419704100,NULL,NULL,'6e712022d2494dbd17767bcc61729c038724989813d2664a67963ed7dc43a52f','9cb582cd8c296ac280b6bbb5e5afd6ab83c6f07148ed321cada9715ea72dbde8','1197d5ce56cc331b28f93fd51f04e6a7c4c7029bd062dc3c1c9c26a01f0a118e');
INSERT INTO blocks VALUES(310042,'826fd4701ef2824e9559b069517cd3cb990aff6a4690830f78fc845ab77fa3e4',1419704200,NULL,NULL,'108c28a4aafc05883737abf9de198ad591a6c6a837b34895aca471bdfd609c65','bc5190c323ef9cd134e45b102a56fe6b3ca2fc6d7194f95d439af81ea8c4878f','3eb24b03da92efaaf35449de5eab487b80b7873b8cfd1ddfebaa5e1fa56b7400');
INSERT INTO blocks VALUES(310043,'2254a12ada208f1dd57bc17547ecaf3c44720323c47bc7d4b1262477cb7f3c51',1419704300,NULL,NULL,'f0467d03c03417ad147d7c92811744ee08abcf30660cfe6213a82e91692fcab9','dfb0a23b42d43e7e5b3513131bca821df335de538b7e0725d873e1335d630381','212af18fa852e76fefb1122525f6966a015bb1329d20ea426d02f09c7a55cc96');
INSERT INTO blocks VALUES(310044,'3346d24118d8af0b3c6bcc42f8b85792e7a2e7036ebf6e4c25f4f6723c78e46b',1419704400,NULL,NULL,'a629657128fb1362d5a68ab5a18e020ce1e64c88eecf1f90d00712c145222e57','2a8e1f0dd77a298613d6b599a76af87a81982444966f6fa1a39dbd45ef2116e3','7e368421fc15284d9dd16b3550775111add963bd7b261179097804d594ac2fbb');
INSERT INTO blocks VALUES(310045,'7bba0ab243839e91ad1a45a762bf074011f8a9883074d68203c6d1b46fffde98',1419704500,NULL,NULL,'32fb7824ae61f7bbab1bfd4495d4a1259c1e6f73ecd41796a4dabda9bbda6aea','ea051be0cb444fec25c8338a83381057f69105eb54d7712a509b1ed9311f5590','0d3cf5fccd6798cb0387505f2f0f14f6b5157468eea5efaa409b83c2464510bf');
INSERT INTO blocks VALUES(310046,'47db6788c38f2d6d712764979e41346b55e78cbb4969e0ef5c4336faf18993a6',1419704600,NULL,NULL,'ccfd3359190dd533b400e9a521272afebdb0ec852fb8c4b281edf5312df31533','57605afcd40387ae53e9fe91c3f6c4e9a01c966091e481d4649d07ca87be68f8','adcf1a15874474d0a60076c2775108472c87ed1305baa22a465befedcacb8302');
INSERT INTO blocks VALUES(310047,'a9ccabcc2a098a7d25e4ab8bda7c4e66807eefa42e29890dcd88149a10de7075',1419704700,NULL,NULL,'838749c3115493dc7d22adf5a24d3edf1802162d27264224743131ae18ea2e6d','b1f0cd20fb753d64c2d711066d1d481b1747cbabe99f18492e55fd335d67fbe9','4a100685c74b401c5f1348314b898d64ca554b0d14914065e9b64f55568dcd61');
INSERT INTO blocks VALUES(310048,'610bf3935a85b05a98556c55493c6de45bed4d7b3b6c8553a984718765796309',1419704800,NULL,NULL,'4a01ba6d7c40a5470e3180651f87f88e484fe06ede2fa4568f6a8e04ccd59b98','beccaf441267733664e544ab901b9f2eabd174335bc325293c99fceeeef00430','968245c0de5f3616af9e20cee1efcf186352f63f2c579efc9c79754782c48092');
INSERT INTO blocks VALUES(310049,'4ad2761923ad49ad2b283b640f1832522a2a5d6964486b21591b71df6b33be3c',1419704900,NULL,NULL,'1cec74c85adb35526a213ca8261a741644b690aef0a23b636f5429e10d8b7246','a966cead838244b31b60ccf16a2468ae959da2a7a676f0fe5ce50b6034f71a5a','56220389d92f6fe4dfaee5a6b63b7efecf1fa6445a9866edd8a6a17f172af873');
INSERT INTO blocks VALUES(310050,'8cfeb60a14a4cec6e9be13d699694d49007d82a31065a17890383e262071e348',1419705000,NULL,NULL,'c499568d258ea95e5a6bd6d14d336cbee644168c80cdb01795809fdd4c555d86','e8f34a9c6aa1be48f05c24e5010c21c557f1e4c02326a5731fc2bbaa0f38625f','432ef2751c661c853c31a268b57358751087d786399bd8f7801eef27885f849a');
INSERT INTO blocks VALUES(310051,'b53c90385dd808306601350920c6af4beb717518493fd23b5c730eea078f33e6',1419705100,NULL,NULL,'b33b0aa72f499ef55b69234648ca88e64fa3d18810b607ed38b3137cf145ad58','9f7b1c48406f41a3311897c28f3792317cf1e1f6f17d54c5b03fe35cf421851f','f0fedba4261110df81bdbfa5b381992d85bccabdcccad90739aadb1689595edb');
INSERT INTO blocks VALUES(310052,'0acdacf4e4b6fca756479cb055191b367b1fa433aa558956f5f08fa5b7b394e2',1419705200,NULL,NULL,'b533539e543323c0e49b4527da4f8ee165127e6a415edbdf8dc9e22297796c3d','373948efa2369f2443f24468ffbee25496ec55cafb949a620e5973576ee4fb68','50ddb05e31b48bb0a6d12bec45a3790ecdebd76a1600e9bda0e95ad03be94831');
INSERT INTO blocks VALUES(310053,'68348f01b6dc49b2cb30fe92ac43e527aa90d859093d3bf7cd695c64d2ef744f',1419705300,NULL,NULL,'f5dd6b41e429ae035bde790ee5eeccd28d9f93ab025642538de2e0ff829a9dfb','35a4ca6fb995483d5693c0bd147e75f924b5f28070bb426041c19bb3d7afcb1d','cb39f2c76c1731163c3c6f42f78fe2a2fc9d7f642b0e730c40529b181da7a296');
INSERT INTO blocks VALUES(310054,'a8b5f253df293037e49b998675620d5477445c51d5ec66596e023282bb9cd305',1419705400,NULL,NULL,'cfd748cfd46a9e4e1314d5a982514f7dc6f7268659a5fca95764e4a5608a31ea','87f0309523201015d13222a74f1f26fe622ef6c5c302264dd781de98cc714565','d3d8e0c749596ec8ae0f095164579ff8ef62e07b8758ecd343f5913221a035da');
INSERT INTO blocks VALUES(310055,'4b069152e2dc82e96ed8a3c3547c162e8c3aceeb2a4ac07972f8321a535b9356',1419705500,NULL,NULL,'92381503ec8d32ea60317aa5b0eb9b4175f2c78766522233216426034c49f2bb','3e6b5ff6a1ebb886591f77b2950b3d41c1900bc036a55b4c8d169cd44f0e56b9','911b7a9879fd139d0caa4b8af47743dc3e2b7cef1567a51db699d1512e4bf3c2');
INSERT INTO blocks VALUES(310056,'7603eaed418971b745256742f9d2ba70b2c2b2f69f61de6cc70e61ce0336f9d3',1419705600,NULL,NULL,'47c3135e2ed3ed6d1ede300eb6a4b94d90de26cddb84f3562ab15b21524d69bf','b9f79e0464b204ba0b837f4e266c55f380a1d7c357829501c94fbf2b43a1dafe','9ec6708cca0ea0cf1a67d250943664712ba4bcdd13fba3e9004ada5a4cb497fa');
INSERT INTO blocks VALUES(310057,'4a5fdc84f2d66ecb6ee3e3646aad20751ce8694e64e348d3c8aab09d33a3e411',1419705700,NULL,NULL,'258562abe150de24eb442775b729cc1e77e50df6309c2cb1400f94eb85aca550','d06654b4522d2fda37b1cd53494cff9c9b6d147585b678e25716feb069359a01','e3dc39eb2851605abd69d469dd9befc08e2816a243963dc0d1cbba8178d2e09d');
INSERT INTO blocks VALUES(310058,'a6eef3089896f0cae0bfe9423392e45c48f4efe4310b14d8cfbdb1fea613635f',1419705800,NULL,NULL,'03bbb7619869f85a713ee3522ab1385166d80518bd384b7a065568492c7ece3d','5865d32873fe9fbfd8520eaacf20bc2f8948060414a297101496298f5dc0af0a','d630839745ce37e15a21e74ab4e50e0847651a3a3879e98dd8247fa8565f1ecb');
INSERT INTO blocks VALUES(310059,'ab505de874c43f97c90be1c26a769e6c5cb140405c993b4a6cc7afc795f156a9',1419705900,NULL,NULL,'0132fc0843ddcd97d6056d1840d2915090b8bc99892df83e5f4d4dfecf884850','1470e164d2ee9d04eda65300c20cd1e09c5eedae6ed8e2c12b96b2460ef0a5e5','256cf5074254d56b0ea62844f2b9e7c23157d45bb5e2dd3046c3fdd00757f806');
INSERT INTO blocks VALUES(310060,'974ad5fbef621e0a38eab811608dc9afaf10c8ecc85fed913075ba1a145e889b',1419706000,NULL,NULL,'4278189ba0841404af05ad81ca3bb1a2d434cd6e3ba5389aa141586dd86b2044','1cf72083165c8d099b09415b6401b40e0d318c48df6840e37ab9d60745460e14','efc9c2bea1253da3f26d1f37b1bf81125681cd45331422f6de32c1852f142ef5');
INSERT INTO blocks VALUES(310061,'35d267d21ad386e7b7632292af1c422b0310dde7ca49a82f9577525a29c138cf',1419706100,NULL,NULL,'2a52e3d6635be2a616ddb475d99a9e67a713e8af70f2e5edd71dfc0d6aa6c674','c6e32c8c9c229a281dbaccb5bb5956d903837296e6820553d92773ba2d7e0d2b','288bcbc3571848f0730f2f8374881758d9bd7982df696bb52e11d3563bdf8d5e');
INSERT INTO blocks VALUES(310062,'b31a0054145319ef9de8c1cb19df5bcf4dc8a1ece20053aa494e5d3a00a2852f',1419706200,NULL,NULL,'3b042ed1b91780ef5d1422007c453af90ee8914ba03c85e8a907cca43533bcba','fdab4ea05c461313a0ec3f8ecea0e18ed8a40e00f2018f7c6b5a0fc0a1b911aa','6ea6a6b3846ad642be5db8eac7a4dc05efce458332ee9f556663df1aa3e99868');
INSERT INTO blocks VALUES(310063,'0cbcbcd5b7f2dc288e3a34eab3d4212463a5a56e886804fb4f9f1cf929eadebe',1419706300,NULL,NULL,'99d234ec776e7e966a068bfbd94d2dff2777fd70726d17cfa4254559dab801aa','6e8ac158d6cdf7755b93b2d96a4c2dafce5e9c11be00234b2de8cdcf05f101f5','4e59f5632d1fdc5cfbe65d8e0d6bc8be7c0d2901a631e4cd1807132c5cbc2f29');
INSERT INTO blocks VALUES(310064,'e2db8065a195e85cde9ddb868a17d39893a60fb2b1255aa5f0c88729de7cbf30',1419706400,NULL,NULL,'84446e4dfcf9abbb7b0effaa786e33cdb01083733fcd00df2deb301e21a9c620','145c3bacaa4310561f26baf2ff7b6bc37bbf4f9af382301d9de5f4f615e35098','c8d8f4e7fdc4ba5d5307aae0bbe01a30bf3f23e840c52b438b0bec5d08ae4be8');
INSERT INTO blocks VALUES(310065,'8a7bc7a77c831ac4fd11b8a9d22d1b6a0661b07cef05c2e600c7fb683b861d2a',1419706500,NULL,NULL,'21ee486896aa018ebf15859ef722b5c636d839ab9ca8e7ca59d22a4d408129d1','e91bc08d4b53e524382c162414168ead164f517c5ce81bc06fc2fc47a81c496f','b824985fab4119e80803ebd7732ced38b00e9a45db5b521a40a967ff1cdfe28c');
INSERT INTO blocks VALUES(310066,'b6959be51eb084747d301f7ccaf9e75f2292c9404633b1532e3692659939430d',1419706600,NULL,NULL,'153950e01eea11304b3787061513c9b87c8ac5ece5bf90edd81c0f1c686cfd87','6c10c833d801c6dd2bc47bcde652b5ff3312adbdbca0039c9a1f7c46fa0342d6','11200e869035609c0d816089697f627372cdf885cc17521b83414bb25c6c2611');
INSERT INTO blocks VALUES(310067,'8b08eae98d7193c9c01863fac6effb9162bda010daeacf9e0347112f233b8577',1419706700,NULL,NULL,'2f77d1490ed3433843cc5dc0bf00a77ad771ca60e2ef15790c2e0956c68973a4','531407d4b2f070b1afe2c6e40b4e2882b4bf6f7f1513e575431a15742494e2f6','8536abe2edd258e95bfe3de79be5d319c20f099bd07dfd2f451c6ec118f8d9a0');
INSERT INTO blocks VALUES(310068,'9280e7297ef6313341bc81787a36acfc9af58f83a415afff5e3154f126cf52b5',1419706800,NULL,NULL,'e25215503a3ed9161e451477c8021c76651c385b435dec7a8290bd0c79abec87','4e8fa136fca771341151f3386c86c37ef79911c6d2d174c1aa689772c04df7c4','ca4f3985f0fe1cc20ce7db1cf7a866616fe8abd6cfb21239e7084549f21397af');
INSERT INTO blocks VALUES(310069,'486351f0655bf594ffaab1980cff17353b640b63e9c27239109addece189a6f7',1419706900,NULL,NULL,'63048ede78153de849ca820ded35632850b964765f12593b230371ecd4dae433','1857ccce292372d9eff0fcef647d7d39aef8d29302f79f328f861b64d123d450','6605098492d70e7e4d4475dfb62efd7ea92e416b57e186dcc9ade0f51ae004e6');
INSERT INTO blocks VALUES(310070,'8739e99f4dee8bebf1332f37f49a125348b40b93b74fe35579dd52bfba4fa7e5',1419707000,NULL,NULL,'98b3c211af15841e7b8444df8c03ebc074a362c12c0518f981fd40e18cea66f2','dc6070c7e100ce45cdc12b95c0014d28decabc075cd2a65324a396716b994967','ae55c9b974ca7d5e77d106125929c5a9b337c2acf48aab3cc3d4f01fb0ce3bde');
INSERT INTO blocks VALUES(310071,'7a099aa1bba0ead577f1e44f35263a1f115ed6a868c98d4dd71609072ae7f80b',1419707100,NULL,NULL,'1778bcae987cfab399b5fd0344b3eeedbc8fa7be12d6d01c807ddfb3707b4371','6af3cc9c9134902f3833eb264d35ad22c1bfbd396beeed4f01299fcd0ddf8881','b5ac6d5a067c89410eef1ab92fc3462e97ad1af46f2dd3604bfa1715639edb91');
INSERT INTO blocks VALUES(310072,'7b17ecedc07552551b8129e068ae67cb176ca766ea3f6df74b597a94e3a7fc8a',1419707200,NULL,NULL,'7aad2e7b6ccd49976a3ef33eb461943370d874687985cd8ad6a313c048b7479c','5dd28a2e332f5af2ca191e4a6152474a5a2016a849e7f305f27cdfd954fb4995','781ad8baf969c409433a50906d55ed380092c783b0e2286725ad6ff6c02fb19b');
INSERT INTO blocks VALUES(310073,'ee0fe3cc9b3a48a2746b6090b63b442b97ea6055d48edcf4b2288396764c6943',1419707300,NULL,NULL,'6f5c58954b16299cab3f2e0c8e88eeaea247be7ff5fca8692ede2ba94ac22bbd','68641213010eaac1171ccc6410add7e1d62dd1b0f1da9254dc30789a4a2276f9','39335ca56836a35f23f16a4a2101cf9ef13db6a71a8856381432dad737132715');
INSERT INTO blocks VALUES(310074,'ceab38dfde01f711a187601731ad575d67cfe0b7dbc61dcd4f15baaef72089fb',1419707400,NULL,NULL,'5f6cbcb3311854a29fff12522810379434826a589ade0c1a7ca14e70414659e9','276a8197746095a896e93991b6307041e51c88e81b32ad1d93dad6e1bb7e5c81','118789567f92490f2dd3d23bdee7c4574547be1f2cf1c34d7b8c28ef30973955');
INSERT INTO blocks VALUES(310075,'ef547198c6e36d829f117cfd7077ccde45158e3c545152225fa24dba7a26847b',1419707500,NULL,NULL,'502c3aa96e49300e02022fef17547bd6733de2c78fc56f7d1146d2b65ccc1efd','3d16dbc4405d1b7b771a62a440ef036b39ac081444d1639898f4d01a7037c9c6','49164ca6c865bdc39a2d4f73558181faa1195fc42aa91f6a07bdee340fcc79da');
INSERT INTO blocks VALUES(310076,'3b0499c2e8e8f0252c7288d4ecf66efc426ca37aad3524424d14c8bc6f8b0d92',1419707600,NULL,NULL,'89aff23d1cf654a55f3b5b4bb4be26a02a43b2453465a77ed9e09928e862eb9d','3157fef889e5a0ca476eb18aac1b1fde4ea7fc41630300afaac9473cc7af847e','936ba51319f4d7495757386df89cd49957cbc8281a026c3d4fb103a4647b5354');
INSERT INTO blocks VALUES(310077,'d2adeefa9024ab3ff2822bc36acf19b6c647cea118cf15b86c6bc00c3322e7dd',1419707700,NULL,NULL,'b71f7ee020a53a6275f1b6f9f933adf226e2006b3b4d904a4ed22bd4e6356602','3223f452e5c800ff0bf41d905444b42781a22992740f97b34f666d7fd7dbdf57','1665459abfd1b16512d02c500be6472478ed07d94b1b54a0913f09b080b594f5');
INSERT INTO blocks VALUES(310078,'f6c17115ef0efe489c562bcda4615892b4d4b39db0c9791fe193d4922bd82cd6',1419707800,NULL,NULL,'dc15e2bab1d35d14f565ebb7f81f1a7cc62a68bf8ac843ce0a2a189ed2134cb5','873adca30c2f33413e6b4bb70b06a3b6054637e8cb1b06d447091819f55dd3e4','ce8fe4617dbee852bb8907ee11518a6e9d8f5e307ceb48c8179f48b1c8185afa');
INSERT INTO blocks VALUES(310079,'f2fbd2074d804e631db44cb0fb2e1db3fdc367e439c21ffc40d73104c4d7069c',1419707900,NULL,NULL,'37c18c06a9ad5cad5cbe04b7334775a84bfba6ffc36a95bf5496365c1ee7179e','4dc67d40deff202d1d1abc185f52e355e7934172785752812856764e26d60f18','137b71fdfc617bdca748039b084c8c495afc2672f8a09d8724b41cffbdc30a80');
INSERT INTO blocks VALUES(310080,'42943b914d9c367000a78b78a544cc4b84b1df838aadde33fe730964a89a3a6c',1419708000,NULL,NULL,'2872aebda09cafd584d9135a3f5e6a83d0286565c9a90ab5974392c4790a68ea','860932261933fd8ad0c35c2974614145750a12e40ec2cd99663f35b9d8725af6','c3187e7119d8250e6d079ce03201d45f502d2755220d4a7addfffd648b5c7dea');
INSERT INTO blocks VALUES(310081,'6554f9d307976249e7b7e260e08046b3b55d318f8b6af627fed5be3063f123c4',1419708100,NULL,NULL,'913b1498be1d70f2a84e9a3fb948b098341ff8b0109bf03663b45f81e5fc3883','cb77b25ccb27450147b6d5ca71a509f56e187b23ff8dae9fd5f9ebdb75a3b637','d6cf763385f0eb08fb69452d0cff21906479921cc3094bc049fdedfdda2bff8e');
INSERT INTO blocks VALUES(310082,'4f1ef91b1dcd575f8ac2e66a67715500cbca154bd6f3b8148bb7015a6aa6c644',1419708200,NULL,NULL,'002febc669ec655e87e9979f748014cac67b1df48a30dfd4480b6b38536f5c1a','4471a2774c9e93d044dabf2ca4efc7d761739a96c9f7b2d10b6c6fe521147062','522098384a01b8a94e3ceff2a3a61f13cc241219b4ed7fb41360546722be4cd3');
INSERT INTO blocks VALUES(310083,'9b1f6fd6ff9b0dc4e37603cfb0625f49067c775b99e12492afd85392d3c8d850',1419708300,NULL,NULL,'d491710e72b4f883c54f347c03bd674b851f175b369bef80ce4b8aa2d087361f','c703b2724e4b4a98a33a6a232fa978954783ac6c0b5460b012d0bb8271d126f0','e435da2e4fdf5792042d790cddfe42546628d6f8f82ed4a8180ee43d01800070');
INSERT INTO blocks VALUES(310084,'1e0972523e80306441b9f4157f171716199f1428db2e818a7f7817ccdc8859e3',1419708400,NULL,NULL,'9eb5b7ff47d137c1d1a8a0d4745b93fccf98f7ba5258c32e868c3e607507bdbf','470cd6c35672c1f7bfb05d4731ce2d8d8feb394e5e052e9a6bee91fb7a073863','93f7620b9497ca6feeafde219ddd6047770905911ef3a50af02cba2f39b5a285');
INSERT INTO blocks VALUES(310085,'c5b6e9581831e3bc5848cd7630c499bca26d9ece5156d36579bdb72d54817e34',1419708500,NULL,NULL,'5df042be7acf75ed45637736f822c3eefe7b73df224dda19af5762ba130d6705','de4cef0283ae527e7867ca75f44b75a4eccdf95b5292551d83099cfe88b438ba','ce2622b848c681172d066f4de56c015a9a34237b936c4264daf9ccbc3eaaf54b');
INSERT INTO blocks VALUES(310086,'080c1dc55a4ecf4824cf9840602498cfc35b5f84099f50b71b45cb63834c7a78',1419708600,NULL,NULL,'2b49a67a177a1d98a33a25034492a57510381bb5620e408abbe9ffec7f778afe','c86df16db5948d90194992b4fd465e4a64ca0f2a1a625f0057813f89b88714da','f06058fd4ac80df0091432ac392e165df95ad5756ec4ff10313b63e67d2d0f82');
INSERT INTO blocks VALUES(310087,'4ec8cb1c38b22904e8087a034a6406b896eff4dd28e7620601c6bddf82e2738c',1419708700,NULL,NULL,'35b782d9a69b641a8c2a146a497ef3c193b4fc06eec7cf4fa0e3526c6f5a90b6','d5ec571936be5e9e80b170f0a7c2160f47bb45e35105dcd970a85b08aeedba25','28d05b6fc032cb553250e089fdb28415f72a9dbc3d59f805dc012405908187fb');
INSERT INTO blocks VALUES(310088,'e945c815c433cbddd0bf8e66c5c23b51072483492acda98f5c2c201020a8c5b3',1419708800,NULL,NULL,'a93b3e8ef04cab3afc47147e4736ea3aa3ef13b5650569febc5787799d560c99','8f4201ea0e34738ac9d99b712c27faf8c3c28abd529d80ae602a736301de103a','ed9d67f6a94daf962926135f7f4758d0fff08eda6e699738eb2d5f7e354aa4fd');
INSERT INTO blocks VALUES(310089,'0382437f895ef3e7e38bf025fd4f606fd44d4bbd6aea71dbdc4ed11a7cd46f33',1419708900,NULL,NULL,'e2477b4c3c1f1017cd8e5ed04fea2147f48f0c0f603848012f45b315915c7345','178a2e565392366f8025593b1e98ed9b927cadace73b6be1e8ac35d8da897f1f','3fef87f8bb5780783306d790454139f18997b492fda10474da3bc958e9ba64e9');
INSERT INTO blocks VALUES(310090,'b756db71dc037b5a4582de354a3347371267d31ebda453e152f0a13bb2fae969',1419709000,NULL,NULL,'956bfb4337e08af03bd6fe31dcf6bc56c68144b04617c60fe6443f4262872972','f170e8194ed01c67a7876bef23b1051a3b62ce7839dea949fa1d5e56d6750a29','7a0c12554b580afde3b94b747324a24347ad4c12a76640eec2ea4dfd8154a2a6');
INSERT INTO blocks VALUES(310091,'734a9aa485f36399d5efb74f3b9c47f8b5f6fd68c9967f134b14cfe7e2d7583c',1419709100,NULL,NULL,'e13976ed1d9bd595ef01b52d386dd3fbedaea6839162634901e8c997e014155a','99691d83e83c84fbf70cdaa37a1355297f2ff784c4cf850d659794ce2647b00e','28e8df913d62123e227705986e46d1b8698c33269a5a90e375d724429a306ac2');
INSERT INTO blocks VALUES(310092,'56386beb65f9228740d4ad43a1c575645f6daf59e0dd9f22551c59215b5e8c3d',1419709200,NULL,NULL,'29836ca3bb7b1cea7cf1fac6ab6413f9a3a7aaeb5fbb2e284f5ee62ff1ab9d1b','eccf76d8165b55bb8709ab1768823b6cca37b646333383bb1ce933f0c9507d64','86b2dd681fab58ea298759995f0419c5c44dff0b5f2c83b5f180e46be918191a');
INSERT INTO blocks VALUES(310093,'a74a2425f2f4be24bb5f715173e6756649e1cbf1b064aeb1ef60e0b94b418ddc',1419709300,NULL,NULL,'622166d7017fef4c6c6e221920d58cf4ab09cb2b4c1f59b2ecb2029400cc8238','ca9f99ce6723f55221cf645b8bec3e8de3c6f0aa5083e883dd5ee58412c0982b','7799be7db9aa8337868eb79d877e3c86da210dbde3472deee6d2f3b720d500d7');
INSERT INTO blocks VALUES(310094,'2a8f976f20c4e89ff01071915ac96ee35192d54df3a246bf61fd4a0cccfb5b23',1419709400,NULL,NULL,'0c09e951bb82aee0cfc48a371d6c719ab54d23e5ced294a48e377c9204a0aecc','94737f16e13391d4d22848e7427247198ddbd760d211162485050d4c48be40fa','561b72f95acce1df737c1b4f72b49fb5bb533565388956f11a00f3b6ba9522bc');
INSERT INTO blocks VALUES(310095,'bed0fa40c9981223fb40b3be8124ca619edc9dd34d0c907369477ea92e5d2cd2',1419709500,NULL,NULL,'7e540b17a77c075f8c1a8e7457a56c9f2995ab1a636f5783b31d073003b5967a','61e2ba65112abb54325dd81508198f715af99f4f9aee46e55012f4c7e9a60555','80b07d4ab391bf1e177b9498434cb6a41d32eac8c0a844eb589825bccd8725d9');
INSERT INTO blocks VALUES(310096,'306aeec3db435fabffdf88c2f26ee83caa4c2426375a33daa2be041dbd27ea2f',1419709600,NULL,NULL,'244a2aa8c1834ffb076cdae8d78c61dfb76a85bdb19e005bddc2efa9b043a3d5','b4e352494c87c9eb1f054fb1acfa0ece70ae16338d769670544a615627e847a4','24c85da36b889412566af445e0abd992bdbc0755a6132770451aaf4a2914ce51');
INSERT INTO blocks VALUES(310097,'13e8e16e67c7cdcc80d477491e554b43744f90e8e1a9728439a11fab42cefadf',1419709700,NULL,NULL,'44915c5495f134f16398ad249278c3a2da56be1bd93823d4551e8d348e921ec8','11d1e1d0a4290596b4d2f0780f1f9646ea54a50117678b8da5ab76cb8fbc4a72','159813a39f41b3b4dbb487882aeabd2958bc6392c491dbb58655eca42f9e4169');
INSERT INTO blocks VALUES(310098,'ca5bca4b5ec4fa6183e05176abe921cff884c4e20910fab55b603cef48dc3bca',1419709800,NULL,NULL,'64593962664c1d087d7aaafbcd29e3c7d7708116b77ef6f327b1faca25059769','5efc15f9db3a52592eb052d646641f79adc91a43f9f001746de11d85e4429f32','3c0b238ea70cf07cdf7d7804c04c028bc10beacff0b7230828ea0595bd89ba5c');
INSERT INTO blocks VALUES(310099,'3c4c2279cd7de0add5ec469648a845875495a7d54ebfb5b012dcc5a197b7992a',1419709900,NULL,NULL,'e100625c64daf064216b04ed501800222c8a71c7ddd3a626327b3be496ab1ebd','cd37340baa00e8d2681359cbf158258b9f5dde833e2517a174f899e0e2235fc7','bb4341a4ae875314fd5af02cf05645327c2d27e1abf7c463ca217872e28e5963');
INSERT INTO blocks VALUES(310100,'96925c05b3c7c80c716f5bef68d161c71d044252c766ca0e3f17f255764242cb',1419710000,NULL,NULL,'d579bdeafaf952dfed87fcb551141f95912bd94015fd96297a3495781bbb6776','c3b23b6391d84b6f103d399b179df343b8e21a6a85b29aa26a6d4411312a13b2','67f1f3947eeda14865b9b94842b0ee6aaf460b4f78938fa32295e7525bfe87eb');
INSERT INTO blocks VALUES(310101,'369472409995ca1a2ebecbad6bf9dab38c378ab1e67e1bdf13d4ce1346731cd6',1419710100,NULL,NULL,'04e00b1fb6ade108784e5984a8929bd54dba58aa3a8da64c0790bc373592b4d9','5f5ce440878bcdc231daa0fa8f8d5040f4c3c1f79b588b0ccb897eadeacc5042','84a31fc4fdb8bb653eae3e1e7b79c28e811a98a9a579731d23c36674dfe3e2d2');
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
INSERT INTO broadcasts VALUES(12,'f9eb323c1032b8b66432591f8dca1568a97cbdb2062ed5b8792c226671945e37',310011,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',1388000000,100.0,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(19,'2cd827a7d27adf046e9735abaad1d376ad7ef1f8fad1a10e44a691f9ddc3957b',310018,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',1388000050,99.86166,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(20,'bd43db240fc7d12dcf355a246c260a7baf2ccd0935ebda51c728b30072e4f420',310019,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',1388000101,100.343,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(21,'7901472b8045571531191f34980d497f1793c806718b9cfdbbba656b641852d6',310020,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',1388000201,2.0,5000000,'Unit Test',0,'valid');
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
INSERT INTO btcpays VALUES(5,'69f56e706e73bd62dfcbe113744432bee5f2af57933b720d9dd72fef53ccfbf3',310004,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',50000000,'ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a_833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a','valid');
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
INSERT INTO burns VALUES(1,'610b15f0c2d3845f124cc6026b6c212033de94218b25f89d5dbde47d11085a89',310000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',62000000,93000000000,'valid');
INSERT INTO burns VALUES(23,'6d1a0e0dedda4a78cf11ac7a1c6fd2c32d9fd7c99d97ae7d524f223641646b85',310022,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',38000000,56999887262,'valid');
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
INSERT INTO credits VALUES(310000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',93000000000,'burn','610b15f0c2d3845f124cc6026b6c212033de94218b25f89d5dbde47d11085a89');
INSERT INTO credits VALUES(310001,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',50000000,'send','72928dacb4dc84a6b9ebf9f43ea2a9ab8791f7ffa8e94a5c38b05d7cfd4a5c3f');
INSERT INTO credits VALUES(310004,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',100000000,'btcpay','69f56e706e73bd62dfcbe113744432bee5f2af57933b720d9dd72fef53ccfbf3');
INSERT INTO credits VALUES(310005,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBB',1000000000,'issuance','81972e1b6d68a5b857edf2a874805ca26013c7d5cf6d186a4bbd35699545b52a');
INSERT INTO credits VALUES(310006,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBC',100000,'issuance','d7ab55e6bd9d4c60143d68db9ef75c6d7cb72b5a73f196c356a76b3f3849da83');
INSERT INTO credits VALUES(310007,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','BBBB',4000000,'send','a5e00545ea476f6ce3fad4fcd0a18faceef4bea400d1132f450796c1112295ce');
INSERT INTO credits VALUES(310008,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','BBBC',526,'send','623aa2a13bd21853e263e41767fc7ce91c2e938d5a175400e807102924f4921e');
INSERT INTO credits VALUES(310009,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',24,'dividend','dda46f3ab92292e4ce918567ebc2c83e0a3707d78a07acb86517cf936f78638c');
INSERT INTO credits VALUES(310010,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',420800,'dividend','5995ba45f8db07202fb542aaac7bd6b9224091764295034e8cf68d2752824d87');
INSERT INTO credits VALUES(310013,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',4250000,'filled','edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a');
INSERT INTO credits VALUES(310014,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',5000000,'cancel order','833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a');
INSERT INTO credits VALUES(310014,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',41500000,'recredit forward quantity','5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a_edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a');
INSERT INTO credits VALUES(310014,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',20750000,'recredit backward quantity','5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a_edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a');
INSERT INTO credits VALUES(310015,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',0,'filled','faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67');
INSERT INTO credits VALUES(310015,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',0,'filled','faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67');
INSERT INTO credits VALUES(310016,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',150000000,'recredit forward quantity','bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c_faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67');
INSERT INTO credits VALUES(310016,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',350000000,'recredit backward quantity','bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c_faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67');
INSERT INTO credits VALUES(310017,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',0,'filled','864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715');
INSERT INTO credits VALUES(310017,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',0,'filled','864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715');
INSERT INTO credits VALUES(310018,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',750000000,'recredit forward quantity','0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d_864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715');
INSERT INTO credits VALUES(310018,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',650000000,'recredit backward quantity','0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d_864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715');
INSERT INTO credits VALUES(310022,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',56999887262,'burn','6d1a0e0dedda4a78cf11ac7a1c6fd2c32d9fd7c99d97ae7d524f223641646b85');
INSERT INTO credits VALUES(310023,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',8500000,'recredit wager remaining','5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a');
INSERT INTO credits VALUES(310023,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','BBBC',10000,'send','a40605acb5b55718ba35b408883c20eecd845425ec463c0720b57901585820e2');
INSERT INTO credits VALUES(310032,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBB',50000000,'cancel order','38d5ec6c73a559b1d1409e0506e2bec30b7db9fd6ca385f2b50202ede6cede56');
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
INSERT INTO debits VALUES(310001,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',50000000,'send','72928dacb4dc84a6b9ebf9f43ea2a9ab8791f7ffa8e94a5c38b05d7cfd4a5c3f');
INSERT INTO debits VALUES(310003,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',105000000,'open order','833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a');
INSERT INTO debits VALUES(310005,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',50000000,'issuance fee','81972e1b6d68a5b857edf2a874805ca26013c7d5cf6d186a4bbd35699545b52a');
INSERT INTO debits VALUES(310006,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',50000000,'issuance fee','d7ab55e6bd9d4c60143d68db9ef75c6d7cb72b5a73f196c356a76b3f3849da83');
INSERT INTO debits VALUES(310007,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBB',4000000,'send','a5e00545ea476f6ce3fad4fcd0a18faceef4bea400d1132f450796c1112295ce');
INSERT INTO debits VALUES(310008,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBC',526,'send','623aa2a13bd21853e263e41767fc7ce91c2e938d5a175400e807102924f4921e');
INSERT INTO debits VALUES(310009,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',24,'dividend','dda46f3ab92292e4ce918567ebc2c83e0a3707d78a07acb86517cf936f78638c');
INSERT INTO debits VALUES(310009,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',20000,'dividend fee','dda46f3ab92292e4ce918567ebc2c83e0a3707d78a07acb86517cf936f78638c');
INSERT INTO debits VALUES(310010,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',420800,'dividend','5995ba45f8db07202fb542aaac7bd6b9224091764295034e8cf68d2752824d87');
INSERT INTO debits VALUES(310010,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',20000,'dividend fee','5995ba45f8db07202fb542aaac7bd6b9224091764295034e8cf68d2752824d87');
INSERT INTO debits VALUES(310012,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',50000000,'bet','5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a');
INSERT INTO debits VALUES(310013,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',25000000,'bet','edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a');
INSERT INTO debits VALUES(310014,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',150000000,'bet','bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c');
INSERT INTO debits VALUES(310015,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',350000000,'bet','faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67');
INSERT INTO debits VALUES(310016,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',750000000,'bet','0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d');
INSERT INTO debits VALUES(310017,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',650000000,'bet','864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715');
INSERT INTO debits VALUES(310021,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBB',50000000,'open order','38d5ec6c73a559b1d1409e0506e2bec30b7db9fd6ca385f2b50202ede6cede56');
INSERT INTO debits VALUES(310023,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBC',10000,'send','a40605acb5b55718ba35b408883c20eecd845425ec463c0720b57901585820e2');
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
INSERT INTO dividends VALUES(10,'dda46f3ab92292e4ce918567ebc2c83e0a3707d78a07acb86517cf936f78638c',310009,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBB','XCP',600,20000,'valid');
INSERT INTO dividends VALUES(11,'5995ba45f8db07202fb542aaac7bd6b9224091764295034e8cf68d2752824d87',310010,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBC','XCP',800,20000,'valid');
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
INSERT INTO issuances VALUES(6,'81972e1b6d68a5b857edf2a874805ca26013c7d5cf6d186a4bbd35699545b52a',310005,'BBBB',1000000000,1,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,0,0,0.0,'',50000000,0,'valid');
INSERT INTO issuances VALUES(7,'d7ab55e6bd9d4c60143d68db9ef75c6d7cb72b5a73f196c356a76b3f3849da83',310006,'BBBC',100000,0,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,0,0,0.0,'foobar',50000000,0,'valid');
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
INSERT INTO messages VALUES(0,310000,'insert','credits','{"action": "burn", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310000, "event": "610b15f0c2d3845f124cc6026b6c212033de94218b25f89d5dbde47d11085a89", "quantity": 93000000000}',0);
INSERT INTO messages VALUES(1,310000,'insert','burns','{"block_index": 310000, "burned": 62000000, "earned": 93000000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "610b15f0c2d3845f124cc6026b6c212033de94218b25f89d5dbde47d11085a89", "tx_index": 1}',0);
INSERT INTO messages VALUES(2,310001,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310001, "event": "72928dacb4dc84a6b9ebf9f43ea2a9ab8791f7ffa8e94a5c38b05d7cfd4a5c3f", "quantity": 50000000}',0);
INSERT INTO messages VALUES(3,310001,'insert','credits','{"action": "send", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "XCP", "block_index": 310001, "event": "72928dacb4dc84a6b9ebf9f43ea2a9ab8791f7ffa8e94a5c38b05d7cfd4a5c3f", "quantity": 50000000}',0);
INSERT INTO messages VALUES(4,310001,'insert','sends','{"asset": "XCP", "block_index": 310001, "destination": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "quantity": 50000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "72928dacb4dc84a6b9ebf9f43ea2a9ab8791f7ffa8e94a5c38b05d7cfd4a5c3f", "tx_index": 2}',0);
INSERT INTO messages VALUES(5,310002,'insert','orders','{"block_index": 310002, "expiration": 10, "expire_index": 310012, "fee_provided": 1000000, "fee_provided_remaining": 1000000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 100000000, "get_remaining": 100000000, "give_asset": "BTC", "give_quantity": 50000000, "give_remaining": 50000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "tx_hash": "ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a", "tx_index": 3}',0);
INSERT INTO messages VALUES(6,310003,'insert','debits','{"action": "open order", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310003, "event": "833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a", "quantity": 105000000}',0);
INSERT INTO messages VALUES(7,310003,'insert','orders','{"block_index": 310003, "expiration": 10, "expire_index": 310013, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 900000, "fee_required_remaining": 900000, "get_asset": "BTC", "get_quantity": 50000000, "get_remaining": 50000000, "give_asset": "XCP", "give_quantity": 105000000, "give_remaining": 105000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "tx_hash": "833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a", "tx_index": 4}',0);
INSERT INTO messages VALUES(8,310003,'update','orders','{"fee_provided_remaining": 142858, "fee_required_remaining": 0, "get_remaining": 0, "give_remaining": 0, "status": "open", "tx_hash": "ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a"}',0);
INSERT INTO messages VALUES(9,310003,'update','orders','{"fee_provided_remaining": 10000, "fee_required_remaining": 42858, "get_remaining": 0, "give_remaining": 5000000, "status": "open", "tx_hash": "833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a"}',0);
INSERT INTO messages VALUES(10,310003,'insert','order_matches','{"backward_asset": "XCP", "backward_quantity": 100000000, "block_index": 310003, "fee_paid": 857142, "forward_asset": "BTC", "forward_quantity": 50000000, "id": "ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a_833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a", "match_expire_index": 310023, "status": "pending", "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx0_block_index": 310002, "tx0_expiration": 10, "tx0_hash": "ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a", "tx0_index": 3, "tx1_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx1_block_index": 310003, "tx1_expiration": 10, "tx1_hash": "833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a", "tx1_index": 4}',0);
INSERT INTO messages VALUES(11,310004,'insert','credits','{"action": "btcpay", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310004, "event": "69f56e706e73bd62dfcbe113744432bee5f2af57933b720d9dd72fef53ccfbf3", "quantity": 100000000}',0);
INSERT INTO messages VALUES(12,310004,'update','order_matches','{"order_match_id": "ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a_833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a", "status": "completed"}',0);
INSERT INTO messages VALUES(13,310004,'insert','btcpays','{"block_index": 310004, "btc_amount": 50000000, "destination": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "order_match_id": "ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a_833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a", "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "69f56e706e73bd62dfcbe113744432bee5f2af57933b720d9dd72fef53ccfbf3", "tx_index": 5}',0);
INSERT INTO messages VALUES(14,310005,'insert','debits','{"action": "issuance fee", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310005, "event": "81972e1b6d68a5b857edf2a874805ca26013c7d5cf6d186a4bbd35699545b52a", "quantity": 50000000}',0);
INSERT INTO messages VALUES(15,310005,'insert','issuances','{"asset": "BBBB", "block_index": 310005, "call_date": 0, "call_price": 0.0, "callable": false, "description": "", "divisible": true, "fee_paid": 50000000, "issuer": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "locked": false, "quantity": 1000000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "transfer": false, "tx_hash": "81972e1b6d68a5b857edf2a874805ca26013c7d5cf6d186a4bbd35699545b52a", "tx_index": 6}',0);
INSERT INTO messages VALUES(16,310005,'insert','credits','{"action": "issuance", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "BBBB", "block_index": 310005, "event": "81972e1b6d68a5b857edf2a874805ca26013c7d5cf6d186a4bbd35699545b52a", "quantity": 1000000000}',0);
INSERT INTO messages VALUES(17,310006,'insert','debits','{"action": "issuance fee", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310006, "event": "d7ab55e6bd9d4c60143d68db9ef75c6d7cb72b5a73f196c356a76b3f3849da83", "quantity": 50000000}',0);
INSERT INTO messages VALUES(18,310006,'insert','issuances','{"asset": "BBBC", "block_index": 310006, "call_date": 0, "call_price": 0.0, "callable": false, "description": "foobar", "divisible": false, "fee_paid": 50000000, "issuer": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "locked": false, "quantity": 100000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "transfer": false, "tx_hash": "d7ab55e6bd9d4c60143d68db9ef75c6d7cb72b5a73f196c356a76b3f3849da83", "tx_index": 7}',0);
INSERT INTO messages VALUES(19,310006,'insert','credits','{"action": "issuance", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "BBBC", "block_index": 310006, "event": "d7ab55e6bd9d4c60143d68db9ef75c6d7cb72b5a73f196c356a76b3f3849da83", "quantity": 100000}',0);
INSERT INTO messages VALUES(20,310007,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "BBBB", "block_index": 310007, "event": "a5e00545ea476f6ce3fad4fcd0a18faceef4bea400d1132f450796c1112295ce", "quantity": 4000000}',0);
INSERT INTO messages VALUES(21,310007,'insert','credits','{"action": "send", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "BBBB", "block_index": 310007, "event": "a5e00545ea476f6ce3fad4fcd0a18faceef4bea400d1132f450796c1112295ce", "quantity": 4000000}',0);
INSERT INTO messages VALUES(22,310007,'insert','sends','{"asset": "BBBB", "block_index": 310007, "destination": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "quantity": 4000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "a5e00545ea476f6ce3fad4fcd0a18faceef4bea400d1132f450796c1112295ce", "tx_index": 8}',0);
INSERT INTO messages VALUES(23,310008,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "BBBC", "block_index": 310008, "event": "623aa2a13bd21853e263e41767fc7ce91c2e938d5a175400e807102924f4921e", "quantity": 526}',0);
INSERT INTO messages VALUES(24,310008,'insert','credits','{"action": "send", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "BBBC", "block_index": 310008, "event": "623aa2a13bd21853e263e41767fc7ce91c2e938d5a175400e807102924f4921e", "quantity": 526}',0);
INSERT INTO messages VALUES(25,310008,'insert','sends','{"asset": "BBBC", "block_index": 310008, "destination": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "quantity": 526, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "623aa2a13bd21853e263e41767fc7ce91c2e938d5a175400e807102924f4921e", "tx_index": 9}',0);
INSERT INTO messages VALUES(26,310009,'insert','debits','{"action": "dividend", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310009, "event": "dda46f3ab92292e4ce918567ebc2c83e0a3707d78a07acb86517cf936f78638c", "quantity": 24}',0);
INSERT INTO messages VALUES(27,310009,'insert','debits','{"action": "dividend fee", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310009, "event": "dda46f3ab92292e4ce918567ebc2c83e0a3707d78a07acb86517cf936f78638c", "quantity": 20000}',0);
INSERT INTO messages VALUES(28,310009,'insert','credits','{"action": "dividend", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "XCP", "block_index": 310009, "event": "dda46f3ab92292e4ce918567ebc2c83e0a3707d78a07acb86517cf936f78638c", "quantity": 24}',0);
INSERT INTO messages VALUES(29,310009,'insert','dividends','{"asset": "BBBB", "block_index": 310009, "dividend_asset": "XCP", "fee_paid": 20000, "quantity_per_unit": 600, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "dda46f3ab92292e4ce918567ebc2c83e0a3707d78a07acb86517cf936f78638c", "tx_index": 10}',0);
INSERT INTO messages VALUES(30,310010,'insert','debits','{"action": "dividend", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310010, "event": "5995ba45f8db07202fb542aaac7bd6b9224091764295034e8cf68d2752824d87", "quantity": 420800}',0);
INSERT INTO messages VALUES(31,310010,'insert','debits','{"action": "dividend fee", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310010, "event": "5995ba45f8db07202fb542aaac7bd6b9224091764295034e8cf68d2752824d87", "quantity": 20000}',0);
INSERT INTO messages VALUES(32,310010,'insert','credits','{"action": "dividend", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "XCP", "block_index": 310010, "event": "5995ba45f8db07202fb542aaac7bd6b9224091764295034e8cf68d2752824d87", "quantity": 420800}',0);
INSERT INTO messages VALUES(33,310010,'insert','dividends','{"asset": "BBBC", "block_index": 310010, "dividend_asset": "XCP", "fee_paid": 20000, "quantity_per_unit": 800, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "5995ba45f8db07202fb542aaac7bd6b9224091764295034e8cf68d2752824d87", "tx_index": 11}',0);
INSERT INTO messages VALUES(34,310011,'insert','broadcasts','{"block_index": 310011, "fee_fraction_int": 5000000, "locked": false, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "text": "Unit Test", "timestamp": 1388000000, "tx_hash": "f9eb323c1032b8b66432591f8dca1568a97cbdb2062ed5b8792c226671945e37", "tx_index": 12, "value": 100.0}',0);
INSERT INTO messages VALUES(35,310012,'insert','debits','{"action": "bet", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310012, "event": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a", "quantity": 50000000}',0);
INSERT INTO messages VALUES(36,310012,'insert','bets','{"bet_type": 0, "block_index": 310012, "counterwager_quantity": 25000000, "counterwager_remaining": 25000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310022, "fee_fraction_int": 5000000.0, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "leverage": 15120, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "target_value": 0.0, "tx_hash": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a", "tx_index": 13, "wager_quantity": 50000000, "wager_remaining": 50000000}',0);
INSERT INTO messages VALUES(37,310013,'update','orders','{"status": "expired", "tx_hash": "ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a"}',0);
INSERT INTO messages VALUES(38,310013,'insert','order_expirations','{"block_index": 310013, "order_hash": "ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a", "order_index": 3, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc"}',0);
INSERT INTO messages VALUES(39,310013,'insert','debits','{"action": "bet", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310013, "event": "edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a", "quantity": 25000000}',0);
INSERT INTO messages VALUES(40,310013,'insert','bets','{"bet_type": 1, "block_index": 310013, "counterwager_quantity": 41500000, "counterwager_remaining": 41500000, "deadline": 1388000100, "expiration": 10, "expire_index": 310023, "fee_fraction_int": 5000000.0, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "leverage": 15120, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "target_value": 0.0, "tx_hash": "edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a", "tx_index": 14, "wager_quantity": 25000000, "wager_remaining": 25000000}',0);
INSERT INTO messages VALUES(41,310013,'update','bets','{"counterwager_remaining": 4250000, "status": "open", "tx_hash": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a", "wager_remaining": 8500000}',0);
INSERT INTO messages VALUES(42,310013,'insert','credits','{"action": "filled", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310013, "event": "edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a", "quantity": 4250000}',0);
INSERT INTO messages VALUES(43,310013,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a", "wager_remaining": 4250000}',0);
INSERT INTO messages VALUES(44,310013,'insert','bet_matches','{"backward_quantity": 20750000, "block_index": 310013, "deadline": 1388000100, "fee_fraction_int": 5000000, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "forward_quantity": 41500000, "id": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a_edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a", "initial_value": 100.0, "leverage": 15120, "match_expire_index": 310022, "status": "pending", "target_value": 0.0, "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx0_bet_type": 0, "tx0_block_index": 310012, "tx0_expiration": 10, "tx0_hash": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a", "tx0_index": 13, "tx1_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx1_bet_type": 1, "tx1_block_index": 310013, "tx1_expiration": 10, "tx1_hash": "edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a", "tx1_index": 14}',0);
INSERT INTO messages VALUES(45,310014,'update','orders','{"status": "expired", "tx_hash": "833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a"}',0);
INSERT INTO messages VALUES(46,310014,'insert','credits','{"action": "cancel order", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310014, "event": "833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a", "quantity": 5000000}',0);
INSERT INTO messages VALUES(47,310014,'insert','order_expirations','{"block_index": 310014, "order_hash": "833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a", "order_index": 4, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc"}',0);
INSERT INTO messages VALUES(48,310014,'insert','credits','{"action": "recredit forward quantity", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310014, "event": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a_edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a", "quantity": 41500000}',0);
INSERT INTO messages VALUES(49,310014,'insert','credits','{"action": "recredit backward quantity", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310014, "event": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a_edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a", "quantity": 20750000}',0);
INSERT INTO messages VALUES(50,310014,'update','bet_matches','{"bet_match_id": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a_edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a", "status": "expired"}',0);
INSERT INTO messages VALUES(51,310014,'insert','bet_match_expirations','{"bet_match_id": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a_edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a", "block_index": 310014, "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx1_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc"}',0);
INSERT INTO messages VALUES(52,310014,'insert','debits','{"action": "bet", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310014, "event": "bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c", "quantity": 150000000}',0);
INSERT INTO messages VALUES(53,310014,'insert','bets','{"bet_type": 0, "block_index": 310014, "counterwager_quantity": 350000000, "counterwager_remaining": 350000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310024, "fee_fraction_int": 5000000.0, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "leverage": 5040, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "target_value": 0.0, "tx_hash": "bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c", "tx_index": 15, "wager_quantity": 150000000, "wager_remaining": 150000000}',0);
INSERT INTO messages VALUES(54,310015,'insert','debits','{"action": "bet", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310015, "event": "faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67", "quantity": 350000000}',0);
INSERT INTO messages VALUES(55,310015,'insert','bets','{"bet_type": 1, "block_index": 310015, "counterwager_quantity": 150000000, "counterwager_remaining": 150000000, "deadline": 1388000100, "expiration": 10, "expire_index": 310025, "fee_fraction_int": 5000000.0, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "leverage": 5040, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "target_value": 0.0, "tx_hash": "faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67", "tx_index": 16, "wager_quantity": 350000000, "wager_remaining": 350000000}',0);
INSERT INTO messages VALUES(56,310015,'insert','credits','{"action": "filled", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310015, "event": "faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67", "quantity": 0}',0);
INSERT INTO messages VALUES(57,310015,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(58,310015,'insert','credits','{"action": "filled", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310015, "event": "faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67", "quantity": 0}',0);
INSERT INTO messages VALUES(59,310015,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(60,310015,'insert','bet_matches','{"backward_quantity": 350000000, "block_index": 310015, "deadline": 1388000100, "fee_fraction_int": 5000000, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "forward_quantity": 150000000, "id": "bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c_faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67", "initial_value": 100.0, "leverage": 5040, "match_expire_index": 310024, "status": "pending", "target_value": 0.0, "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx0_bet_type": 0, "tx0_block_index": 310014, "tx0_expiration": 10, "tx0_hash": "bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c", "tx0_index": 15, "tx1_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx1_bet_type": 1, "tx1_block_index": 310015, "tx1_expiration": 10, "tx1_hash": "faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67", "tx1_index": 16}',0);
INSERT INTO messages VALUES(61,310016,'insert','credits','{"action": "recredit forward quantity", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310016, "event": "bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c_faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67", "quantity": 150000000}',0);
INSERT INTO messages VALUES(62,310016,'insert','credits','{"action": "recredit backward quantity", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310016, "event": "bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c_faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67", "quantity": 350000000}',0);
INSERT INTO messages VALUES(63,310016,'update','bet_matches','{"bet_match_id": "bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c_faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67", "status": "expired"}',0);
INSERT INTO messages VALUES(64,310016,'insert','bet_match_expirations','{"bet_match_id": "bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c_faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67", "block_index": 310016, "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx1_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc"}',0);
INSERT INTO messages VALUES(65,310016,'insert','debits','{"action": "bet", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310016, "event": "0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d", "quantity": 750000000}',0);
INSERT INTO messages VALUES(66,310016,'insert','bets','{"bet_type": 2, "block_index": 310016, "counterwager_quantity": 650000000, "counterwager_remaining": 650000000, "deadline": 1388000200, "expiration": 10, "expire_index": 310026, "fee_fraction_int": 5000000.0, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "leverage": 5040, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "target_value": 1.0, "tx_hash": "0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d", "tx_index": 17, "wager_quantity": 750000000, "wager_remaining": 750000000}',0);
INSERT INTO messages VALUES(67,310017,'insert','debits','{"action": "bet", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310017, "event": "864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715", "quantity": 650000000}',0);
INSERT INTO messages VALUES(68,310017,'insert','bets','{"bet_type": 3, "block_index": 310017, "counterwager_quantity": 750000000, "counterwager_remaining": 750000000, "deadline": 1388000200, "expiration": 10, "expire_index": 310027, "fee_fraction_int": 5000000.0, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "leverage": 5040, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "target_value": 1.0, "tx_hash": "864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715", "tx_index": 18, "wager_quantity": 650000000, "wager_remaining": 650000000}',0);
INSERT INTO messages VALUES(69,310017,'insert','credits','{"action": "filled", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310017, "event": "864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715", "quantity": 0}',0);
INSERT INTO messages VALUES(70,310017,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(71,310017,'insert','credits','{"action": "filled", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310017, "event": "864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715", "quantity": 0}',0);
INSERT INTO messages VALUES(72,310017,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(73,310017,'insert','bet_matches','{"backward_quantity": 650000000, "block_index": 310017, "deadline": 1388000200, "fee_fraction_int": 5000000, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "forward_quantity": 750000000, "id": "0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d_864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715", "initial_value": 100.0, "leverage": 5040, "match_expire_index": 310026, "status": "pending", "target_value": 1.0, "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx0_bet_type": 2, "tx0_block_index": 310016, "tx0_expiration": 10, "tx0_hash": "0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d", "tx0_index": 17, "tx1_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx1_bet_type": 3, "tx1_block_index": 310017, "tx1_expiration": 10, "tx1_hash": "864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715", "tx1_index": 18}',0);
INSERT INTO messages VALUES(74,310018,'insert','credits','{"action": "recredit forward quantity", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310018, "event": "0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d_864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715", "quantity": 750000000}',0);
INSERT INTO messages VALUES(75,310018,'insert','credits','{"action": "recredit backward quantity", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310018, "event": "0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d_864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715", "quantity": 650000000}',0);
INSERT INTO messages VALUES(76,310018,'update','bet_matches','{"bet_match_id": "0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d_864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715", "status": "expired"}',0);
INSERT INTO messages VALUES(77,310018,'insert','bet_match_expirations','{"bet_match_id": "0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d_864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715", "block_index": 310018, "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx1_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc"}',0);
INSERT INTO messages VALUES(78,310018,'insert','broadcasts','{"block_index": 310018, "fee_fraction_int": 5000000, "locked": false, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "text": "Unit Test", "timestamp": 1388000050, "tx_hash": "2cd827a7d27adf046e9735abaad1d376ad7ef1f8fad1a10e44a691f9ddc3957b", "tx_index": 19, "value": 99.86166}',0);
INSERT INTO messages VALUES(79,310019,'insert','broadcasts','{"block_index": 310019, "fee_fraction_int": 5000000, "locked": false, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "text": "Unit Test", "timestamp": 1388000101, "tx_hash": "bd43db240fc7d12dcf355a246c260a7baf2ccd0935ebda51c728b30072e4f420", "tx_index": 20, "value": 100.343}',0);
INSERT INTO messages VALUES(80,310020,'insert','broadcasts','{"block_index": 310020, "fee_fraction_int": 5000000, "locked": false, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "text": "Unit Test", "timestamp": 1388000201, "tx_hash": "7901472b8045571531191f34980d497f1793c806718b9cfdbbba656b641852d6", "tx_index": 21, "value": 2.0}',0);
INSERT INTO messages VALUES(81,310021,'insert','debits','{"action": "open order", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "BBBB", "block_index": 310021, "event": "38d5ec6c73a559b1d1409e0506e2bec30b7db9fd6ca385f2b50202ede6cede56", "quantity": 50000000}',0);
INSERT INTO messages VALUES(82,310021,'insert','orders','{"block_index": 310021, "expiration": 10, "expire_index": 310031, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 50000000, "get_remaining": 50000000, "give_asset": "BBBB", "give_quantity": 50000000, "give_remaining": 50000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "tx_hash": "38d5ec6c73a559b1d1409e0506e2bec30b7db9fd6ca385f2b50202ede6cede56", "tx_index": 22}',0);
INSERT INTO messages VALUES(83,310022,'insert','credits','{"action": "burn", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310022, "event": "6d1a0e0dedda4a78cf11ac7a1c6fd2c32d9fd7c99d97ae7d524f223641646b85", "quantity": 56999887262}',0);
INSERT INTO messages VALUES(84,310022,'insert','burns','{"block_index": 310022, "burned": 38000000, "earned": 56999887262, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "6d1a0e0dedda4a78cf11ac7a1c6fd2c32d9fd7c99d97ae7d524f223641646b85", "tx_index": 23}',0);
INSERT INTO messages VALUES(85,310023,'update','bets','{"status": "expired", "tx_hash": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a"}',0);
INSERT INTO messages VALUES(86,310023,'insert','credits','{"action": "recredit wager remaining", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310023, "event": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a", "quantity": 8500000}',0);
INSERT INTO messages VALUES(87,310023,'insert','bet_expirations','{"bet_hash": "5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a", "bet_index": 13, "block_index": 310023, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc"}',0);
INSERT INTO messages VALUES(88,310023,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "BBBC", "block_index": 310023, "event": "a40605acb5b55718ba35b408883c20eecd845425ec463c0720b57901585820e2", "quantity": 10000}',0);
INSERT INTO messages VALUES(89,310023,'insert','credits','{"action": "send", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "BBBC", "block_index": 310023, "event": "a40605acb5b55718ba35b408883c20eecd845425ec463c0720b57901585820e2", "quantity": 10000}',0);
INSERT INTO messages VALUES(90,310023,'insert','sends','{"asset": "BBBC", "block_index": 310023, "destination": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "quantity": 10000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "a40605acb5b55718ba35b408883c20eecd845425ec463c0720b57901585820e2", "tx_index": 24}',0);
INSERT INTO messages VALUES(91,310032,'update','orders','{"status": "expired", "tx_hash": "38d5ec6c73a559b1d1409e0506e2bec30b7db9fd6ca385f2b50202ede6cede56"}',0);
INSERT INTO messages VALUES(92,310032,'insert','credits','{"action": "cancel order", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "BBBB", "block_index": 310032, "event": "38d5ec6c73a559b1d1409e0506e2bec30b7db9fd6ca385f2b50202ede6cede56", "quantity": 50000000}',0);
INSERT INTO messages VALUES(93,310032,'insert','order_expirations','{"block_index": 310032, "order_hash": "38d5ec6c73a559b1d1409e0506e2bec30b7db9fd6ca385f2b50202ede6cede56", "order_index": 22, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc"}',0);
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
INSERT INTO order_expirations VALUES(3,'ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',310013);
INSERT INTO order_expirations VALUES(4,'833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',310014);
INSERT INTO order_expirations VALUES(22,'38d5ec6c73a559b1d1409e0506e2bec30b7db9fd6ca385f2b50202ede6cede56','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',310032);
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
INSERT INTO order_matches VALUES('ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a_833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a',3,'ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',4,'833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BTC',50000000,'XCP',100000000,310002,310003,310003,10,10,310023,857142,'completed');
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
INSERT INTO orders VALUES(3,'ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a',310002,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BTC',50000000,0,'XCP',100000000,0,10,310012,0,0,1000000,142858,'expired');
INSERT INTO orders VALUES(4,'833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a',310003,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',105000000,5000000,'BTC',50000000,0,10,310013,900000,42858,10000,10000,'expired');
INSERT INTO orders VALUES(22,'38d5ec6c73a559b1d1409e0506e2bec30b7db9fd6ca385f2b50202ede6cede56',310021,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BBBB',50000000,50000000,'XCP',50000000,50000000,10,310031,0,0,10000,10000,'expired');
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
INSERT INTO sends VALUES(2,'72928dacb4dc84a6b9ebf9f43ea2a9ab8791f7ffa8e94a5c38b05d7cfd4a5c3f',310001,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',50000000,'valid');
INSERT INTO sends VALUES(8,'a5e00545ea476f6ce3fad4fcd0a18faceef4bea400d1132f450796c1112295ce',310007,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','BBBB',4000000,'valid');
INSERT INTO sends VALUES(9,'623aa2a13bd21853e263e41767fc7ce91c2e938d5a175400e807102924f4921e',310008,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','BBBC',526,'valid');
INSERT INTO sends VALUES(24,'a40605acb5b55718ba35b408883c20eecd845425ec463c0720b57901585820e2',310023,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','BBBC',10000,'valid');
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
INSERT INTO transactions VALUES(1,'610b15f0c2d3845f124cc6026b6c212033de94218b25f89d5dbde47d11085a89',310000,'505d8d82c4ced7daddef7ed0b05ba12ecc664176887b938ef56c6af276f3b30c',1419700000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,10000,X'',1);
INSERT INTO transactions VALUES(2,'72928dacb4dc84a6b9ebf9f43ea2a9ab8791f7ffa8e94a5c38b05d7cfd4a5c3f',310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',1419700100,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'0000000000000000000000010000000002FAF080',1);
INSERT INTO transactions VALUES(3,'ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a',310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',1419700200,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,1000000,X'0000000A00000000000000000000000002FAF08000000000000000010000000005F5E100000A0000000000000000',1);
INSERT INTO transactions VALUES(4,'833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a',310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',1419700300,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000006422C4000000000000000000000000002FAF080000A00000000000DBBA0',1);
INSERT INTO transactions VALUES(5,'69f56e706e73bd62dfcbe113744432bee5f2af57933b720d9dd72fef53ccfbf3',310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',1419700400,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',50000000,10000,X'0000000BAD6082998925F47865B58B6D344C1B1CF0AB059D091F33334CCB92436F37EB8A833AC1C9139ACC7A9AAABBF04BDF3E4AF95A3425762D39D8CC2CC23113861D2A',1);
INSERT INTO transactions VALUES(6,'81972e1b6d68a5b857edf2a874805ca26013c7d5cf6d186a4bbd35699545b52a',310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',1419700500,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'000000140000000000004767000000003B9ACA000100000000000000000000',1);
INSERT INTO transactions VALUES(7,'d7ab55e6bd9d4c60143d68db9ef75c6d7cb72b5a73f196c356a76b3f3849da83',310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',1419700600,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'00000014000000000000476800000000000186A00000000000000000000006666F6F626172',1);
INSERT INTO transactions VALUES(8,'a5e00545ea476f6ce3fad4fcd0a18faceef4bea400d1132f450796c1112295ce',310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',1419700700,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'00000000000000000000476700000000003D0900',1);
INSERT INTO transactions VALUES(9,'623aa2a13bd21853e263e41767fc7ce91c2e938d5a175400e807102924f4921e',310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',1419700800,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'000000000000000000004768000000000000020E',1);
INSERT INTO transactions VALUES(10,'dda46f3ab92292e4ce918567ebc2c83e0a3707d78a07acb86517cf936f78638c',310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',1419700900,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'00000032000000000000025800000000000047670000000000000001',1);
INSERT INTO transactions VALUES(11,'5995ba45f8db07202fb542aaac7bd6b9224091764295034e8cf68d2752824d87',310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',1419701000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'00000032000000000000032000000000000047680000000000000001',1);
INSERT INTO transactions VALUES(12,'f9eb323c1032b8b66432591f8dca1568a97cbdb2062ed5b8792c226671945e37',310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',1419701100,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001E52BB33004059000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(13,'5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a',310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',1419701200,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000052BB33640000000002FAF08000000000017D7840000000000000000000003B100000000A',1);
INSERT INTO transactions VALUES(14,'edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a',310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',1419701300,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000152BB336400000000017D78400000000002793D60000000000000000000003B100000000A',1);
INSERT INTO transactions VALUES(15,'bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c',310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',1419701400,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000052BB33640000000008F0D1800000000014DC93800000000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(16,'faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67',310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',1419701500,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000152BB33640000000014DC93800000000008F0D1800000000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(17,'0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d',310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',1419701600,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000252BB33C8000000002CB417800000000026BE36803FF0000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(18,'864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715',310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',1419701700,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000352BB33C80000000026BE3680000000002CB417803FF0000000000000000013B00000000A',1);
INSERT INTO transactions VALUES(19,'2cd827a7d27adf046e9735abaad1d376ad7ef1f8fad1a10e44a691f9ddc3957b',310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',1419701800,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001E52BB33324058F7256FFC115E004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(20,'bd43db240fc7d12dcf355a246c260a7baf2ccd0935ebda51c728b30072e4f420',310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',1419701900,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001E52BB3365405915F3B645A1CB004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(21,'7901472b8045571531191f34980d497f1793c806718b9cfdbbba656b641852d6',310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',1419702000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001E52BB33C94000000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(22,'38d5ec6c73a559b1d1409e0506e2bec30b7db9fd6ca385f2b50202ede6cede56',310021,'7c2460bb32c5749c856486393239bf7a0ac789587ac71f32e7237910da8097f2',1419702100,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000047670000000002FAF08000000000000000010000000002FAF080000A0000000000000000',1);
INSERT INTO transactions VALUES(23,'6d1a0e0dedda4a78cf11ac7a1c6fd2c32d9fd7c99d97ae7d524f223641646b85',310022,'44435f9a99a0aa12a9bfabdc4cb8119f6ea6a6e1350d2d65445fb66a456db5fc',1419702200,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mvCounterpartyXXXXXXXXXXXXXXW24Hef',100000000,10000,X'',1);
INSERT INTO transactions VALUES(24,'a40605acb5b55718ba35b408883c20eecd845425ec463c0720b57901585820e2',310023,'d8cf5bec1bbcab8ca4f495352afde3b6572b7e1d61b3976872ebb8e9d30ccb08',1419702300,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'0000000000000000000047680000000000002710',1);
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
INSERT INTO undolog VALUES(4,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=93000000000 WHERE rowid=1');
INSERT INTO undolog VALUES(5,'DELETE FROM debits WHERE rowid=1');
INSERT INTO undolog VALUES(6,'DELETE FROM balances WHERE rowid=2');
INSERT INTO undolog VALUES(7,'DELETE FROM credits WHERE rowid=2');
INSERT INTO undolog VALUES(8,'DELETE FROM sends WHERE rowid=2');
INSERT INTO undolog VALUES(9,'DELETE FROM orders WHERE rowid=1');
INSERT INTO undolog VALUES(10,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92950000000 WHERE rowid=1');
INSERT INTO undolog VALUES(11,'DELETE FROM debits WHERE rowid=2');
INSERT INTO undolog VALUES(12,'DELETE FROM orders WHERE rowid=2');
INSERT INTO undolog VALUES(13,'UPDATE orders SET tx_index=3,tx_hash=''ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a'',block_index=310002,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',give_asset=''BTC'',give_quantity=50000000,give_remaining=50000000,get_asset=''XCP'',get_quantity=100000000,get_remaining=100000000,expiration=10,expire_index=310012,fee_required=0,fee_required_remaining=0,fee_provided=1000000,fee_provided_remaining=1000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(14,'UPDATE orders SET tx_index=4,tx_hash=''833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a'',block_index=310003,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',give_asset=''XCP'',give_quantity=105000000,give_remaining=105000000,get_asset=''BTC'',get_quantity=50000000,get_remaining=50000000,expiration=10,expire_index=310013,fee_required=900000,fee_required_remaining=900000,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(15,'DELETE FROM order_matches WHERE rowid=1');
INSERT INTO undolog VALUES(16,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92845000000 WHERE rowid=1');
INSERT INTO undolog VALUES(17,'DELETE FROM credits WHERE rowid=3');
INSERT INTO undolog VALUES(18,'UPDATE order_matches SET id=''ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a_833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a'',tx0_index=3,tx0_hash=''ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a'',tx0_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',tx1_index=4,tx1_hash=''833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a'',tx1_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',forward_asset=''BTC'',forward_quantity=50000000,backward_asset=''XCP'',backward_quantity=100000000,tx0_block_index=310002,tx1_block_index=310003,block_index=310003,tx0_expiration=10,tx1_expiration=10,match_expire_index=310023,fee_paid=857142,status=''pending'' WHERE rowid=1');
INSERT INTO undolog VALUES(19,'DELETE FROM btcpays WHERE rowid=5');
INSERT INTO undolog VALUES(20,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92945000000 WHERE rowid=1');
INSERT INTO undolog VALUES(21,'DELETE FROM debits WHERE rowid=3');
INSERT INTO undolog VALUES(22,'DELETE FROM assets WHERE rowid=3');
INSERT INTO undolog VALUES(23,'DELETE FROM issuances WHERE rowid=6');
INSERT INTO undolog VALUES(24,'DELETE FROM balances WHERE rowid=3');
INSERT INTO undolog VALUES(25,'DELETE FROM credits WHERE rowid=4');
INSERT INTO undolog VALUES(26,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92895000000 WHERE rowid=1');
INSERT INTO undolog VALUES(27,'DELETE FROM debits WHERE rowid=4');
INSERT INTO undolog VALUES(28,'DELETE FROM assets WHERE rowid=4');
INSERT INTO undolog VALUES(29,'DELETE FROM issuances WHERE rowid=7');
INSERT INTO undolog VALUES(30,'DELETE FROM balances WHERE rowid=4');
INSERT INTO undolog VALUES(31,'DELETE FROM credits WHERE rowid=5');
INSERT INTO undolog VALUES(32,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''BBBB'',quantity=1000000000 WHERE rowid=3');
INSERT INTO undolog VALUES(33,'DELETE FROM debits WHERE rowid=5');
INSERT INTO undolog VALUES(34,'DELETE FROM balances WHERE rowid=5');
INSERT INTO undolog VALUES(35,'DELETE FROM credits WHERE rowid=6');
INSERT INTO undolog VALUES(36,'DELETE FROM sends WHERE rowid=8');
INSERT INTO undolog VALUES(37,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''BBBC'',quantity=100000 WHERE rowid=4');
INSERT INTO undolog VALUES(38,'DELETE FROM debits WHERE rowid=6');
INSERT INTO undolog VALUES(39,'DELETE FROM balances WHERE rowid=6');
INSERT INTO undolog VALUES(40,'DELETE FROM credits WHERE rowid=7');
INSERT INTO undolog VALUES(41,'DELETE FROM sends WHERE rowid=9');
INSERT INTO undolog VALUES(42,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92845000000 WHERE rowid=1');
INSERT INTO undolog VALUES(43,'DELETE FROM debits WHERE rowid=7');
INSERT INTO undolog VALUES(44,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92844999976 WHERE rowid=1');
INSERT INTO undolog VALUES(45,'DELETE FROM debits WHERE rowid=8');
INSERT INTO undolog VALUES(46,'UPDATE balances SET address=''mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns'',asset=''XCP'',quantity=50000000 WHERE rowid=2');
INSERT INTO undolog VALUES(47,'DELETE FROM credits WHERE rowid=8');
INSERT INTO undolog VALUES(48,'DELETE FROM dividends WHERE rowid=10');
INSERT INTO undolog VALUES(49,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92844979976 WHERE rowid=1');
INSERT INTO undolog VALUES(50,'DELETE FROM debits WHERE rowid=9');
INSERT INTO undolog VALUES(51,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92844559176 WHERE rowid=1');
INSERT INTO undolog VALUES(52,'DELETE FROM debits WHERE rowid=10');
INSERT INTO undolog VALUES(53,'UPDATE balances SET address=''mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns'',asset=''XCP'',quantity=50000024 WHERE rowid=2');
INSERT INTO undolog VALUES(54,'DELETE FROM credits WHERE rowid=9');
INSERT INTO undolog VALUES(55,'DELETE FROM dividends WHERE rowid=11');
INSERT INTO undolog VALUES(56,'DELETE FROM broadcasts WHERE rowid=12');
INSERT INTO undolog VALUES(57,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92844539176 WHERE rowid=1');
INSERT INTO undolog VALUES(58,'DELETE FROM debits WHERE rowid=11');
INSERT INTO undolog VALUES(59,'DELETE FROM bets WHERE rowid=1');
INSERT INTO undolog VALUES(60,'UPDATE orders SET tx_index=3,tx_hash=''ad6082998925f47865b58b6d344c1b1cf0ab059d091f33334ccb92436f37eb8a'',block_index=310002,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',give_asset=''BTC'',give_quantity=50000000,give_remaining=0,get_asset=''XCP'',get_quantity=100000000,get_remaining=0,expiration=10,expire_index=310012,fee_required=0,fee_required_remaining=0,fee_provided=1000000,fee_provided_remaining=142858,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(61,'DELETE FROM order_expirations WHERE rowid=3');
INSERT INTO undolog VALUES(62,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92794539176 WHERE rowid=1');
INSERT INTO undolog VALUES(63,'DELETE FROM debits WHERE rowid=12');
INSERT INTO undolog VALUES(64,'DELETE FROM bets WHERE rowid=2');
INSERT INTO undolog VALUES(65,'UPDATE bets SET tx_index=13,tx_hash=''5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a'',block_index=310012,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',feed_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',bet_type=0,deadline=1388000100,wager_quantity=50000000,wager_remaining=50000000,counterwager_quantity=25000000,counterwager_remaining=25000000,target_value=0.0,leverage=15120,expiration=10,expire_index=310022,fee_fraction_int=5000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(66,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92769539176 WHERE rowid=1');
INSERT INTO undolog VALUES(67,'DELETE FROM credits WHERE rowid=10');
INSERT INTO undolog VALUES(68,'UPDATE bets SET tx_index=14,tx_hash=''edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a'',block_index=310013,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',feed_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',bet_type=1,deadline=1388000100,wager_quantity=25000000,wager_remaining=25000000,counterwager_quantity=41500000,counterwager_remaining=41500000,target_value=0.0,leverage=15120,expiration=10,expire_index=310023,fee_fraction_int=5000000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(69,'DELETE FROM bet_matches WHERE rowid=1');
INSERT INTO undolog VALUES(70,'UPDATE orders SET tx_index=4,tx_hash=''833ac1c9139acc7a9aaabbf04bdf3e4af95a3425762d39d8cc2cc23113861d2a'',block_index=310003,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',give_asset=''XCP'',give_quantity=105000000,give_remaining=5000000,get_asset=''BTC'',get_quantity=50000000,get_remaining=0,expiration=10,expire_index=310013,fee_required=900000,fee_required_remaining=42858,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=2');
INSERT INTO undolog VALUES(71,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92773789176 WHERE rowid=1');
INSERT INTO undolog VALUES(72,'DELETE FROM credits WHERE rowid=11');
INSERT INTO undolog VALUES(73,'DELETE FROM order_expirations WHERE rowid=4');
INSERT INTO undolog VALUES(74,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92778789176 WHERE rowid=1');
INSERT INTO undolog VALUES(75,'DELETE FROM credits WHERE rowid=12');
INSERT INTO undolog VALUES(76,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92820289176 WHERE rowid=1');
INSERT INTO undolog VALUES(77,'DELETE FROM credits WHERE rowid=13');
INSERT INTO undolog VALUES(78,'UPDATE bet_matches SET id=''5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a_edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a'',tx0_index=13,tx0_hash=''5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a'',tx0_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',tx1_index=14,tx1_hash=''edd28543ae87ae56f5bd55437cab05f7f4d8a1709cb12e139dab176eb5f7e74a'',tx1_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',tx0_bet_type=0,tx1_bet_type=1,feed_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',initial_value=100,deadline=1388000100,target_value=0.0,leverage=15120,forward_quantity=41500000,backward_quantity=20750000,tx0_block_index=310012,tx1_block_index=310013,block_index=310013,tx0_expiration=10,tx1_expiration=10,match_expire_index=310022,fee_fraction_int=5000000,status=''pending'' WHERE rowid=1');
INSERT INTO undolog VALUES(79,'DELETE FROM bet_match_expirations WHERE rowid=1');
INSERT INTO undolog VALUES(80,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(81,'DELETE FROM debits WHERE rowid=13');
INSERT INTO undolog VALUES(82,'DELETE FROM bets WHERE rowid=3');
INSERT INTO undolog VALUES(83,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92691039176 WHERE rowid=1');
INSERT INTO undolog VALUES(84,'DELETE FROM debits WHERE rowid=14');
INSERT INTO undolog VALUES(85,'DELETE FROM bets WHERE rowid=4');
INSERT INTO undolog VALUES(86,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(87,'DELETE FROM credits WHERE rowid=14');
INSERT INTO undolog VALUES(88,'UPDATE bets SET tx_index=15,tx_hash=''bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c'',block_index=310014,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',feed_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',bet_type=0,deadline=1388000100,wager_quantity=150000000,wager_remaining=150000000,counterwager_quantity=350000000,counterwager_remaining=350000000,target_value=0.0,leverage=5040,expiration=10,expire_index=310024,fee_fraction_int=5000000,status=''open'' WHERE rowid=3');
INSERT INTO undolog VALUES(89,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(90,'DELETE FROM credits WHERE rowid=15');
INSERT INTO undolog VALUES(91,'UPDATE bets SET tx_index=16,tx_hash=''faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67'',block_index=310015,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',feed_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',bet_type=1,deadline=1388000100,wager_quantity=350000000,wager_remaining=350000000,counterwager_quantity=150000000,counterwager_remaining=150000000,target_value=0.0,leverage=5040,expiration=10,expire_index=310025,fee_fraction_int=5000000,status=''open'' WHERE rowid=4');
INSERT INTO undolog VALUES(92,'DELETE FROM bet_matches WHERE rowid=2');
INSERT INTO undolog VALUES(93,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92341039176 WHERE rowid=1');
INSERT INTO undolog VALUES(94,'DELETE FROM credits WHERE rowid=16');
INSERT INTO undolog VALUES(95,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92491039176 WHERE rowid=1');
INSERT INTO undolog VALUES(96,'DELETE FROM credits WHERE rowid=17');
INSERT INTO undolog VALUES(97,'UPDATE bet_matches SET id=''bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c_faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67'',tx0_index=15,tx0_hash=''bc42268279947c6dd5a517df41ae838c22c7194c686180700d8087dc3c8ce36c'',tx0_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',tx1_index=16,tx1_hash=''faca8b02a24a4e8a29164f5d3a4ce443c55c4060c34f7ad3cb42ad862c5a6f67'',tx1_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',tx0_bet_type=0,tx1_bet_type=1,feed_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',initial_value=100,deadline=1388000100,target_value=0.0,leverage=5040,forward_quantity=150000000,backward_quantity=350000000,tx0_block_index=310014,tx1_block_index=310015,block_index=310015,tx0_expiration=10,tx1_expiration=10,match_expire_index=310024,fee_fraction_int=5000000,status=''pending'' WHERE rowid=2');
INSERT INTO undolog VALUES(98,'DELETE FROM bet_match_expirations WHERE rowid=2');
INSERT INTO undolog VALUES(99,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(100,'DELETE FROM debits WHERE rowid=15');
INSERT INTO undolog VALUES(101,'DELETE FROM bets WHERE rowid=5');
INSERT INTO undolog VALUES(102,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92091039176 WHERE rowid=1');
INSERT INTO undolog VALUES(103,'DELETE FROM debits WHERE rowid=16');
INSERT INTO undolog VALUES(104,'DELETE FROM bets WHERE rowid=6');
INSERT INTO undolog VALUES(105,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(106,'DELETE FROM credits WHERE rowid=18');
INSERT INTO undolog VALUES(107,'UPDATE bets SET tx_index=17,tx_hash=''0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d'',block_index=310016,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',feed_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',bet_type=2,deadline=1388000200,wager_quantity=750000000,wager_remaining=750000000,counterwager_quantity=650000000,counterwager_remaining=650000000,target_value=1.0,leverage=5040,expiration=10,expire_index=310026,fee_fraction_int=5000000,status=''open'' WHERE rowid=5');
INSERT INTO undolog VALUES(108,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(109,'DELETE FROM credits WHERE rowid=19');
INSERT INTO undolog VALUES(110,'UPDATE bets SET tx_index=18,tx_hash=''864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715'',block_index=310017,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',feed_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',bet_type=3,deadline=1388000200,wager_quantity=650000000,wager_remaining=650000000,counterwager_quantity=750000000,counterwager_remaining=750000000,target_value=1.0,leverage=5040,expiration=10,expire_index=310027,fee_fraction_int=5000000,status=''open'' WHERE rowid=6');
INSERT INTO undolog VALUES(111,'DELETE FROM bet_matches WHERE rowid=3');
INSERT INTO undolog VALUES(112,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=91441039176 WHERE rowid=1');
INSERT INTO undolog VALUES(113,'DELETE FROM credits WHERE rowid=20');
INSERT INTO undolog VALUES(114,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92191039176 WHERE rowid=1');
INSERT INTO undolog VALUES(115,'DELETE FROM credits WHERE rowid=21');
INSERT INTO undolog VALUES(116,'UPDATE bet_matches SET id=''0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d_864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715'',tx0_index=17,tx0_hash=''0bedbaab766013a9381fee7cf956cb5a93eda3df67762633c7427706bbd3349d'',tx0_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',tx1_index=18,tx1_hash=''864b93f55d4aa6cec4717b264d7cc351d7b0ef169d4d584008be703ade736715'',tx1_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',tx0_bet_type=2,tx1_bet_type=3,feed_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',initial_value=100,deadline=1388000200,target_value=1.0,leverage=5040,forward_quantity=750000000,backward_quantity=650000000,tx0_block_index=310016,tx1_block_index=310017,block_index=310017,tx0_expiration=10,tx1_expiration=10,match_expire_index=310026,fee_fraction_int=5000000,status=''pending'' WHERE rowid=3');
INSERT INTO undolog VALUES(117,'DELETE FROM bet_match_expirations WHERE rowid=3');
INSERT INTO undolog VALUES(118,'DELETE FROM broadcasts WHERE rowid=19');
INSERT INTO undolog VALUES(119,'DELETE FROM broadcasts WHERE rowid=20');
INSERT INTO undolog VALUES(120,'DELETE FROM broadcasts WHERE rowid=21');
INSERT INTO undolog VALUES(121,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''BBBB'',quantity=996000000 WHERE rowid=3');
INSERT INTO undolog VALUES(122,'DELETE FROM debits WHERE rowid=17');
INSERT INTO undolog VALUES(123,'DELETE FROM orders WHERE rowid=3');
INSERT INTO undolog VALUES(124,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92841039176 WHERE rowid=1');
INSERT INTO undolog VALUES(125,'DELETE FROM credits WHERE rowid=22');
INSERT INTO undolog VALUES(126,'DELETE FROM burns WHERE rowid=23');
INSERT INTO undolog VALUES(127,'UPDATE bets SET tx_index=13,tx_hash=''5da0ca591e5336da0304bc8f7a201af3465685c492b284495898da35a402e32a'',block_index=310012,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',feed_address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',bet_type=0,deadline=1388000100,wager_quantity=50000000,wager_remaining=8500000,counterwager_quantity=25000000,counterwager_remaining=4250000,target_value=0.0,leverage=15120,expiration=10,expire_index=310022,fee_fraction_int=5000000,status=''open'' WHERE rowid=1');
INSERT INTO undolog VALUES(128,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=149840926438 WHERE rowid=1');
INSERT INTO undolog VALUES(129,'DELETE FROM credits WHERE rowid=23');
INSERT INTO undolog VALUES(130,'DELETE FROM bet_expirations WHERE rowid=13');
INSERT INTO undolog VALUES(131,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''BBBC'',quantity=99474 WHERE rowid=4');
INSERT INTO undolog VALUES(132,'DELETE FROM debits WHERE rowid=18');
INSERT INTO undolog VALUES(133,'UPDATE balances SET address=''mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns'',asset=''BBBC'',quantity=526 WHERE rowid=6');
INSERT INTO undolog VALUES(134,'DELETE FROM credits WHERE rowid=24');
INSERT INTO undolog VALUES(135,'DELETE FROM sends WHERE rowid=24');
INSERT INTO undolog VALUES(136,'UPDATE orders SET tx_index=22,tx_hash=''38d5ec6c73a559b1d1409e0506e2bec30b7db9fd6ca385f2b50202ede6cede56'',block_index=310021,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',give_asset=''BBBB'',give_quantity=50000000,give_remaining=50000000,get_asset=''XCP'',get_quantity=50000000,get_remaining=50000000,expiration=10,expire_index=310031,fee_required=0,fee_required_remaining=0,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=3');
INSERT INTO undolog VALUES(137,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''BBBB'',quantity=946000000 WHERE rowid=3');
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
