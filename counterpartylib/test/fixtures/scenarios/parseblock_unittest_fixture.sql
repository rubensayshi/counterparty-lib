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
INSERT INTO assets VALUES('697326324582','DIVISIBLE',310001);
INSERT INTO assets VALUES('1911882621324134','NODIVISIBLE',310002);
INSERT INTO assets VALUES('16199343190','CALLABLE',310003);
INSERT INTO assets VALUES('137134819','LOCKED',310004);
INSERT INTO assets VALUES('211518','MAXI',310016);
INSERT INTO assets VALUES('2122675428648001','PAYTOSCRIPT',310107);
INSERT INTO assets VALUES('26819977213','DIVIDEND',310494);
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
INSERT INTO balances VALUES('mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',91950000000);
INSERT INTO balances VALUES('mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','DIVISIBLE',98800000000);
INSERT INTO balances VALUES('mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','NODIVISIBLE',985);
INSERT INTO balances VALUES('mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','CALLABLE',1000);
INSERT INTO balances VALUES('mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','LOCKED',1000);
INSERT INTO balances VALUES('mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','DIVISIBLE',100000000);
INSERT INTO balances VALUES('mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',99999990);
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',300000000);
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','DIVISIBLE',1000000000);
INSERT INTO balances VALUES('mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','NODIVISIBLE',5);
INSERT INTO balances VALUES('1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','NODIVISIBLE',10);
INSERT INTO balances VALUES('mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','MAXI',9223372036854775807);
INSERT INTO balances VALUES('myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','XCP',92999138812);
INSERT INTO balances VALUES('munimLLHjPhGeSU5rYB2HN79LJa8bRZr5b','XCP',92999130460);
INSERT INTO balances VALUES('mwtPsLQxW9xpm7gdLmwWvJK5ABdPUVJm42','XCP',92999122099);
INSERT INTO balances VALUES('2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','XCP',46449556859);
INSERT INTO balances VALUES('2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','PAYTOSCRIPT',1000);
INSERT INTO balances VALUES('2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','DIVISIBLE',100000000);
INSERT INTO balances VALUES('mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','XCP',0);
INSERT INTO balances VALUES('mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','DIVIDEND',90);
INSERT INTO balances VALUES('mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj','DIVIDEND',10);
INSERT INTO balances VALUES('mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj','XCP',92945878046);
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
INSERT INTO bet_match_expirations VALUES('be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',310021);
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
INSERT INTO bet_matches VALUES('be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5',20,'be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',21,'90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',1,0,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',1,1388000001,0.0,5040,9,9,310019,310020,310020,100,100,310119,5000000,'expired');
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
INSERT INTO bets VALUES(20,'be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd',310019,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',1,1388000001,9,0,9,0,0.0,5040,100,310119,5000000,'filled');
INSERT INTO bets VALUES(21,'90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5',310020,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,1388000001,9,0,9,0,0.0,5040,100,310120,5000000,'filled');
INSERT INTO bets VALUES(102,'ba0ef1dfbbc87df94e1d198b0e9e3c06301710d4aab3d85116cbc8199954644a',310101,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',3,1388000200,10,10,10,10,0.0,5040,1000,311101,5000000,'open');
INSERT INTO bets VALUES(111,'81f8ba670b22980b15c944dcd478a274723659d768b0de73b014d06d214e5b90',310110,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',3,1388000200,10,10,10,10,0.0,5040,1000,311110,5000000,'open');
INSERT INTO bets VALUES(488,'cadcc00884e64292c6f899b4abc29df7286d94093a258d0925e2fcc88af495b6',310487,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM',1,1388000101,9,9,9,9,0.0,5040,100,310587,5000000,'open');
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
INSERT INTO blocks VALUES(310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',1419700100,NULL,NULL,'6a91073b35d1151c0b9b93f7916d25e6650b82fe4a1b006851d69b1112cd2954','490572196d4b3d303697f55cc9bf8fe29a4ae659dfc51f63a6af37cb5593413b','0e5a1d103303445b9834b0a01d1179e522ff3389a861f0517b2ee061a9bc1c57');
INSERT INTO blocks VALUES(310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',1419700200,NULL,NULL,'88eac1faa671a7ebc61f63782c4b74d42c813c19e410e240843440f4d4dbaa35','e944f6127f7d13409ace137a670d1503a5412488942fdf7e858fcd99b70e4c2a','d5e23e344547beb15ed6eb88f54504d2f4a8062279e0053a2c9c679655e1870c');
INSERT INTO blocks VALUES(310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',1419700300,NULL,NULL,'93d430c0d7a680aad6fb162af200e95e177ba5d604df1e3cb0e086d3959538c3','d9ba1ab8640ac01642eacf28d3f618a222cc40377db418b1313d880ecb88bce8','c3371ad121359321f66af210da3f7d35b83d45074720a18cb305508ad5a60229');
INSERT INTO blocks VALUES(310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',1419700400,NULL,NULL,'e85e5d82a20fe2e060a7c1f79dc182d3b2da28903b04302e6abe4a3f935ea373','acc9a12b365f51aa9efbe5612f812bf926ef8e5e3bf057c42877aeea1049ee49','ca4856a25799772f900671b7965ecdc36a09744654a1cd697f18969e22850b8a');
INSERT INTO blocks VALUES(310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',1419700500,NULL,NULL,'c6c0f780ffa18de5a5e5afdf4fba5b6a17dce8d767d4b7a9fbbae2ad53ff4718','e9410f15a3b9c93d8416d57295d3a8e03d6313eb73fd2f00678d2f3a8f774e03','db34d651874da19cf2a4fcf50c44f4be7c6e40bc5a0574a46716f10c235b9c43');
INSERT INTO blocks VALUES(310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',1419700600,NULL,NULL,'91458f37f5293fca71cddc6f14874670584e750aa68fbe577b22eac357c5f336','ed50224a1ca02397047900e5770da64a9eb6cb62b6b5b4e57f12d08c5b57ab93','c909c99a5218c152196071f4df6c3dfa2cfdaa70af26e3fc6a490a270ff29339');
INSERT INTO blocks VALUES(310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',1419700700,NULL,NULL,'a8f0f81aebdf77ee1945c2199142696f2c74518f2bc1a45dcfd3cebcabec510c','1635973c36f5d7efc3becc95a2667c1bb808edc692ff28eaa5f5849b7cdb4286','fb670f2509a3384f1c75cfa89770da9f9315cbda733fd6cdb1db89e7bbc80608');
INSERT INTO blocks VALUES(310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',1419700800,NULL,NULL,'df7cae2ef1885eb5916f821be0bb11c24c9cabdc6ccdc84866d60de6af972b94','e7dde4bb0a7aeab7df2cd3f8a39af3d64dd98ef64efbc253e4e6e05c0767f585','4e11197b5662b57b1e8b21d196f1d0bae927e36c4b4634539dd63b1df8b7aa99');
INSERT INTO blocks VALUES(310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',1419700900,NULL,NULL,'1d8caac58a9e5a656a6631fe88be72dfb45dbc25c64d92558db268be01da6024','74b7425efb6832f9cd6ffea0ae5814f192bb6d00c36603700af7a240f878da95','fc53cd08e684798b74bb5b282b72ea18166a7ae83a64ff9b802ae3e3ea6c1d13');
INSERT INTO blocks VALUES(310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',1419701000,NULL,NULL,'ab78a209c465104945458dba209c03409f839d4882a1bf416c504d26fd8b9c80','d4bdc625dead1b87056b74aa843ae9b47a1b61bb63aafc32a04137d5022d67e4','2398b32d34b43c20a0965532863ed3ddd21ee095268ba7d8933f31e417a3689e');
INSERT INTO blocks VALUES(310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',1419701100,NULL,NULL,'5528fec20bfacc31dd43d7284bf1df33e033ec0ac12b14ed813a9dfea4f67741','205fad5e739d6736a483dde222d3fdfc0014a5af1fa1981e652a0fe948d883b3','3f9d7e91b4cfc760c5fa6805975002c258a48e2bc0a9e754bcc69be8e0cb74e5');
INSERT INTO blocks VALUES(310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',1419701200,NULL,NULL,'fa66dc025cbb75b67a7d4c496141eb5f6f0cc42134433276c8a294c983453926','ff933c5dfc4364dc6fa3faa2d5da4096bd1261cc53f74a20af9e55a4dda2d08b','1993f3234c4025eab5bb95ac516594b99c4068b1352652f0327f4fa6c8684d17');
INSERT INTO blocks VALUES(310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',1419701300,NULL,NULL,'442621791a488568ee9dee5d9131db3ce2f17d9d87b4f45dc8079606874823f8','337f673aa1457d390abc97512fbaa5590e4f5e06d663e82627f70fd23c558655','dbe86ee55a221aa0541367039bb0f51ccac45530dd78b0a9b0292b175cef6e56');
INSERT INTO blocks VALUES(310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',1419701400,NULL,NULL,'8551367f346e50b15c6e0cca116d1697d3301725b73562f62d8e4c53581e7bd0','f1f9d937b2f6f2221055c9f967207accd58a388a33677fd7572c882ce2e65b0e','9e054d7d63e96da38b2bb4715a627e3f4f322b8d86a8ad569a9e2e780c036f46');
INSERT INTO blocks VALUES(310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',1419701500,NULL,NULL,'29de016d6301c2c9be33c98d3ca3e5f2dd25d52fd344426d40e3b0126dea019a','e0051523f6891110c18a2250db797d39d6ffd917aeb446906f8059b293e20be6','98ac9ef994c9b058395d5726fb29303fb90ae1cb4130535c9a9525e61dda0702');
INSERT INTO blocks VALUES(310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',1419701600,NULL,NULL,'32ffd4bdf9b1f8506a25b4d2affe792d1eccf322a9ab832ec71a934fea136db9','0c90d5431f84b4fd0739bfe750ddd2b65f1bfee26f3b576f2df5dc77537389ab','8588b5ccadd1f93f8bce990c723efb6118b90d4491cc7ada4cda296469f5a635');
INSERT INTO blocks VALUES(310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',1419701700,NULL,NULL,'64aa58f7e48dfa10bb48ecf48571d832bb94027c7ac07be0d23d5379452ce03b','ee2aa8e8b5c16ff20dc4a37c5483c7b1b9498b3f77cab630c910e29540c3a4f9','a5b974e881ec4e947974f2441f5af722673d08e55dc3daa5d5e0a717080962bf');
INSERT INTO blocks VALUES(310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',1419701800,NULL,NULL,'8d8f404bdc2fb6178286b2581cf8a23e6028d5d285091fa0e67e96e6da91f54e','be9eab485a9d7cba91072ae17389b123dc865fd84b70750f225c76dcdaac1f27','65f30e31bc64ea4f4a2cb6db890a5769b97b32e0bf3a992302b619bfac0af60e');
INSERT INTO blocks VALUES(310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',1419701900,NULL,NULL,'945a8fd2f57cfd5ddab542291fb2e2813762806b806a3e65e688321fefe1986d','7f518d7dec7a31e52840d975a26c5d96d3a202d30d4977205fc14cf76b93dcf2','da444b5d4accf056c6fade57c38869d51a3d9ca102df5c937675398b4b6060b0');
INSERT INTO blocks VALUES(310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',1419702000,NULL,NULL,'3393abc111ee337132103ca04b4f8745952cd03ddbd6efff58a589e00a48fa21','50cc106fcf8581a7d1ea0ccdc6c5251b6f36b6a64f12581ab77ab339bb112ec4','ee59a8bb5eafdaf12ad7c8e55a19060451a959b03a9fe0b23a5628f680b04b6e');
INSERT INTO blocks VALUES(310021,'7c2460bb32c5749c856486393239bf7a0ac789587ac71f32e7237910da8097f2',1419702100,NULL,NULL,'472127d01d3afc9589c9ea9dd38885784fafd30d16154a35adc5a3996a292b60','648f5633ea84b04f3c82873eb245f1632b00e61112a79632e4608be8915d80f9','331b6ebf117da541a052416714107b0c39521d17bb4f7e0aacbbbe366c68b598');
INSERT INTO blocks VALUES(310022,'44435f9a99a0aa12a9bfabdc4cb8119f6ea6a6e1350d2d65445fb66a456db5fc',1419702200,NULL,NULL,'00ff5b4b71b513020ac11f7d7860edc14a875c325d5d898d3c831b1e876b9dd4','26bf7bb14922abb270a25ae77abb45a09271deb901c22dc304b019d610f06f3d','b29dcd68da31672c5b8d9b39a1605c83e015f56d23d095480c44da18ed0a981d');
INSERT INTO blocks VALUES(310023,'d8cf5bec1bbcab8ca4f495352afde3b6572b7e1d61b3976872ebb8e9d30ccb08',1419702300,NULL,NULL,'2728c6f6cb0fa40ef5f19bbba7c592226870ad6a3247d1c5733698dd455fe8d4','cb647a71c09e5bf06576afbd426ddf13e2151e819b07efb2929db444769e4531','1207c1c2a6287fbbe4b19d841d574777980fd9496229bb3dde36186cda529a87');
INSERT INTO blocks VALUES(310024,'b03042b4e18a222b4c8d1e9e1970d93e6e2a2d41686d227ff8ecf0a839223dc5',1419702400,NULL,NULL,'03436954049cab5d385076729f5cf05e2e7b296093c6a46d1f59c643d2b15146','b3990893e9f8f00cefb139c043815e301e951cb919c59e58644034b33551b480','863eba0570dc1637000e035001eb557b8e07d6234afbac3485e8e0cf46829410');
INSERT INTO blocks VALUES(310025,'a872e560766832cc3b4f7f222228cb6db882ce3c54f6459f62c71d5cd6e90666',1419702500,NULL,NULL,'2513398d2034b375c4e7e70352d1ae12985ac2e449814102a71e0333a711b2e0','540d181af55b17757869eb48ef4050732f4bb8d7bb4667793e05770f33dd7f4a','7c8fc05bd6c49c7764ae1472583784082d74bd9b0292345e84c7d0670a88e275');
INSERT INTO blocks VALUES(310026,'6c96350f6f2f05810f19a689de235eff975338587194a36a70dfd0fcd490941a',1419702600,NULL,NULL,'98d726857e2ddc9b0de52cde7f4682bf3169efbecc5f863c4442bd0ab6334151','26a5ce353f383d9bf732d119bf947380fbf7cb7c10d9b65711da6d08f940b692','fe926003bc54b9c7d372391107a535c259af29653957f84498ec39e7d6985e6e');
INSERT INTO blocks VALUES(310027,'d7acfac66df393c4482a14c189742c0571b89442eb7f817b34415a560445699e',1419702700,NULL,NULL,'4b06f50e2918b761b47ae5c88e6c6df886a78f660a5a90aab1b545ab3f718dbc','21eb7db4dff69979f960b34b3d8632d417be2d9087399beaf50cf3a945c101e9','643d46d4ae59645589da82867ee7d0e1fdf202014c29f92a01cd8f1cbe28f1aa');
INSERT INTO blocks VALUES(310028,'02409fcf8fa06dafcb7f11e38593181d9c42cc9d5e2ddc304d098f990bd9530b',1419702800,NULL,NULL,'00c5a07dea49bfb662ec1e873aaf2ef75e3ea14d5722d851c7813fe0399345d0','d8f78dad14405cbd461ccfcacbfdc544ca5e603df3d3021b58d5393560e0d56f','935f69d3254c9fdf5af3544c89d9ef6db8ae61df92b5790259b7e6503d6b3e11');
INSERT INTO blocks VALUES(310029,'3c739fa8b40c118d5547ea356ee8d10ee2898871907643ec02e5db9d00f03cc6',1419702900,NULL,NULL,'2f0a3fff79d642f87c267d9b7d2c7fa6ef30477a1961d2e2dfc57e166df0461e','ba57b2e4eb9132feaa3380491358c8706c44204f7f7a4f7f0060a3ff8a640b97','2c0104006d2aa05ec32824409eefc55376a2dde851d4657d8a885d00c1bf5227');
INSERT INTO blocks VALUES(310030,'d5071cddedf89765ee0fd58f209c1c7d669ba8ea66200a57587da8b189b9e4f5',1419703000,NULL,NULL,'ba65cd99b7dee0daf4d1428acf41a729501f218a401a5ef9973b34abf58ba8e9','29663f45b5eae8b77bb8ec5351e0012efdf03a17fa5d132dd8da0f432acaf9e0','541037847827b6678861785dde0b222f04a67091f0c90dc2b92ad12d63f88bfc');
INSERT INTO blocks VALUES(310031,'0b02b10f41380fff27c543ea8891ecb845bf7a003ac5c87e15932aff3bfcf689',1419703100,NULL,NULL,'6892bdb74064e9f4599f9460b221ef808e9503b89343455866b4c3bc0cc95575','fe36b2450774dfc7db346c45833fbd401d8a234ce87544cd9b373cbc4b79b61a','d219ea7e9afc17cdbb08224b91e3db951fd74daae2ceb416eb579c57745b2de0');
INSERT INTO blocks VALUES(310032,'66346be81e6ba04544f2ae643b76c2b7b1383f038fc2636e02e49dc7ec144074',1419703200,NULL,NULL,'78e88ae868681729d73a1c637adc803781d74fb9bc17910a4a4373c6f40ba446','258bea96c9e1d774eb0fedc7fe99a328b62ee26f557426d036147d1eea033e04','37895120b144d9616c41ce65f36256b04118a8eb390e72f51a31252ae3cb630e');
INSERT INTO blocks VALUES(310033,'999c65df9661f73e8c01f1da1afda09ac16788b72834f0ff5ea3d1464afb4707',1419703300,NULL,NULL,'1221147f7cc9d76e610acc2d34e0678399d1b33a6bff18928501185729e61d22','ce67ed4dddf1582ac85c4825c5f9d059e6c64542e5d0fa6f489858008948a989','2bb43056e0582d8eb28ba154e4bc1981199de5a2b84f2ea687cbac5665f6b6bc');
INSERT INTO blocks VALUES(310034,'f552edd2e0a648230f3668e72ddf0ddfb1e8ac0f4c190f91b89c1a8c2e357208',1419703400,NULL,NULL,'2c3ed667d0729caaddc424f5b311189b6e75525b1e7ffd845c7889fb06841128','4e7e92c9296993b9469c9388ba23e9a5696070ee7e42b09116e45c6078746d00','7dee80b1230d71094e690698219b7af889fb6de3a11e40f8a0e22bf4a5082457');
INSERT INTO blocks VALUES(310035,'a13cbb016f3044207a46967a4ba1c87dab411f78c55c1179f2336653c2726ae2',1419703500,NULL,NULL,'acb3642748f6140a934f99042055ac821f742742f76d70d90838851ac6a5d57e','98919ef5963b86630a60e75cef8b95f24508d65d29c534811a92ed5016cc14dd','45f7f80fa57c9242f8acb77955f0f9cd5937364d4a14f026f8f9b7b217c452b0');
INSERT INTO blocks VALUES(310036,'158648a98f1e1bd1875584ce8449eb15a4e91a99a923bbb24c4210135cef0c76',1419703600,NULL,NULL,'e9fc7ec627ff111872299f73f03bb74580a3e19b2d1a5b33d49c2d21ac5db909','ef9adfbd23bebd3c047db6d82d7d0ca0479bd14fcfeb95b9a4ef6963d7294b99','bcf54717d3edcb43138e611106ca9721c431e8573936f2f11f7fd64906297f3e');
INSERT INTO blocks VALUES(310037,'563acfd6d991ce256d5655de2e9429975c8dceeb221e76d5ec6e9e24a2c27c07',1419703700,NULL,NULL,'69a5aaa49619c561cf53ace4f5705f810aa4090bc27d13f42c277dd299eca1cd','51cbb75a27acf3a67b54f6b64a4f4b86d511fe3d6fe29526fe26238e44a3bd4b','a8073f4fa466cd52dc1196600d38c8703b659ee13929214c43dae6ed15002aff');
INSERT INTO blocks VALUES(310038,'b44b4cad12431c32df27940e18d51f63897c7472b70950d18454edfd640490b2',1419703800,NULL,NULL,'13c879a367ccc55c9129cbc140a5fb75aaef14036ebb23f7e6c0b5349059ffb1','cd45648e95377f9c8503ba747cd2a7312ac0c9108316eb5a77a06fb9fd0df474','81359d9d84765ca2028a62ae8c3c714b4a53e9a1430f6d8a032aa822fa4c87eb');
INSERT INTO blocks VALUES(310039,'5fa1ae9c5e8a599247458987b006ad3a57f686df1f7cc240bf119e911b56c347',1419703900,NULL,NULL,'a5698016280219e17f34aa299e96cddc979f3682176080e6397ca347d95c71b1','ffe0bc6eeace43428a31476e259bf5dfe33c33f70c18001504f158d4be026b5c','372c5be52f928a7314b50252424e77b5dc08be39c7b674ef0a717c8d38d342c6');
INSERT INTO blocks VALUES(310040,'7200ded406675453eadddfbb2d14c2a4526c7dc2b5de14bd48b29243df5e1aa3',1419704000,NULL,NULL,'38923026e04b583ecc1fe3da3f6b124e57699bb122629e44c5c216b206dfe060','3a96f2cea7c289afdd0b6c987bc0081a8726d08eb19bfe3eb9b518442324fe16','db89b0f26abfd0459c556716ee586fc2451cdf6ebb59f2c6fa6e05bebeb913b2');
INSERT INTO blocks VALUES(310041,'5db592ff9ba5fac1e030cf22d6c13b70d330ba397f415340086ee7357143b359',1419704100,NULL,NULL,'17b28ebcc1cf3cd4ddd559c0b3d5610685d5ae0a358ab6fc6fe943e0fbfcb18b','9f35a2e8a94c8a81ddedfc9b0178d7a07f42fee1221b6eca038edc16b4f32495','122c8cb1b4da02940ff5b8befd33051905ca6aab1462658ec674e33960b9f5ea');
INSERT INTO blocks VALUES(310042,'826fd4701ef2824e9559b069517cd3cb990aff6a4690830f78fc845ab77fa3e4',1419704200,NULL,NULL,'bf3604949f3047fa420a995878b679d1974ec26910ef9f340fb6f6e7da063989','9ba21b4c3e4696a8558752ae8f24a407f19827a2973c34cc38289693ea8fe011','6e02b53148a83afbb0e3449f82f72becb2e7a578289f45bf795d6344fefa3c13');
INSERT INTO blocks VALUES(310043,'2254a12ada208f1dd57bc17547ecaf3c44720323c47bc7d4b1262477cb7f3c51',1419704300,NULL,NULL,'c387d253de1a173298f8ecd36ff9e966aa5e1bfed38cd0e89b424d1cec8f7a33','ea9ae316a3d419d8d383d8cd5879757e67825eaba0f0f22455bdee39be6b3986','2f190fba3094ef86b6b844ffa5569e296f3488aaa3c4bf44a9510fd04c586cac');
INSERT INTO blocks VALUES(310044,'3346d24118d8af0b3c6bcc42f8b85792e7a2e7036ebf6e4c25f4f6723c78e46b',1419704400,NULL,NULL,'e60d54339892638677efdcc00ade300e5945f0939a8ccaa2b1b9bd0f63318367','5ed66185648c567cd211fa03b6d887f21854c231743ad20885a83073bf68b1e2','be7ae52689bc3f480da6b07f3ecc28fca94537dcdefbf5de1e7b60eec66cb6b6');
INSERT INTO blocks VALUES(310045,'7bba0ab243839e91ad1a45a762bf074011f8a9883074d68203c6d1b46fffde98',1419704500,NULL,NULL,'bec1879cb7e10a60a69c58abd3a3d93b41485c793f3765783877363c25f5df1f','638e948d625f063dfd65ebc57bb7d87ecfb5b99322ee3a1ab4fa0acb704f581f','1b10666f83538045668de7ca10bb470af1ad35e7e01651e4520d2037f827cb07');
INSERT INTO blocks VALUES(310046,'47db6788c38f2d6d712764979e41346b55e78cbb4969e0ef5c4336faf18993a6',1419704600,NULL,NULL,'e36e78dc229d95dc4075b3ae7487e32d0450e856b07b365cff6ba25a5d5f9ee2','8e4ef49f870af7dde396a108f4c1d5c4286a302a573c1bb1b6a45c423dc7cd2b','05e820d8a482b7873ce7d22234e7f8b323fdea2c8d1f4a20fd780f2bbf348c2c');
INSERT INTO blocks VALUES(310047,'a9ccabcc2a098a7d25e4ab8bda7c4e66807eefa42e29890dcd88149a10de7075',1419704700,NULL,NULL,'193f77d082877bc335612cea4a9914e50a9ea1cad90cd6971f85a4a811d9bd3f','1e61e70016a9c18765c2332d9b3e7a64e119a7dbf533256fc1b88f36c2404055','c3e71d91ecb92afdec2544398a172386f3708dffcea0a6abc6f1a305ed9eb172');
INSERT INTO blocks VALUES(310048,'610bf3935a85b05a98556c55493c6de45bed4d7b3b6c8553a984718765796309',1419704800,NULL,NULL,'f4a23c2a4fba25fc1e21f8dc22464e05a9f9a1a439d13d9309df099a478502ae','ad6559d820513781cb3bd412c74bfd5575595078e42007573a0da9f208bf5aea','de38928e14285d780abbf285341caecb4035e0640c5a2c520968a5c2e1548514');
INSERT INTO blocks VALUES(310049,'4ad2761923ad49ad2b283b640f1832522a2a5d6964486b21591b71df6b33be3c',1419704900,NULL,NULL,'1a764b9f4439bd102c50dbe4eb5bfb786362f645ca8ca33afa7f1bb8ba1370bc','f14c6718b43729126cd3b7fe5b8b4dd27dcec04f379a30f69500f2f0b2f36715','d9380cc464df600d0ecfb247577843616b67fecede3e0d2abaac4e72b963f337');
INSERT INTO blocks VALUES(310050,'8cfeb60a14a4cec6e9be13d699694d49007d82a31065a17890383e262071e348',1419705000,NULL,NULL,'5e73527854a90bf321ffe4f9f2743fc90daa5c52611ae1a0454328ee736c87bd','2a118b6fc1b1c64b790e81895f58bca39a4ec73825f9c40a6e674b14da49e410','99820d55e732fe77026a48cd38b70e0cf98acac6a5f3a95f49ac9088827b1dcd');
INSERT INTO blocks VALUES(310051,'b53c90385dd808306601350920c6af4beb717518493fd23b5c730eea078f33e6',1419705100,NULL,NULL,'16ad5f36e6c86fb337f5c42a53dc3b382971ce1988143ce7c1ff2d4ae0ee35df','a910be4cd65598d4b1031a0afb11644daf91338b7d5714ae5f0619ed1c02aa35','d3ee51797fa40531ac6def6a3008189a2c72e6fd6786ee77721f1c6047378bc2');
INSERT INTO blocks VALUES(310052,'0acdacf4e4b6fca756479cb055191b367b1fa433aa558956f5f08fa5b7b394e2',1419705200,NULL,NULL,'45a73d9dc6cfcc7f2fe14d91d03d19c4a956c7c8aa5a096fee89bbf597c8bbf4','736cf75895c6b0a0899baca213f46b5f1043ae6e774fd85c4e965363c58ad76d','e3c86d1a83d58d81562b0c360f4b30b428665bc5dd2f9184a141cd904b7a502f');
INSERT INTO blocks VALUES(310053,'68348f01b6dc49b2cb30fe92ac43e527aa90d859093d3bf7cd695c64d2ef744f',1419705300,NULL,NULL,'fd7c62644609a158e2b4aaf0bd14eaff1392649f805a2e9d1fa808add35e0544','b6176107f5ed5d22352b9fc00d444c4d62c177147018e9a3123a5ddf86113a92','cd543610150ccf67e2b6233fade89a6a01dcd58291ddd52970a2dfc199a338e7');
INSERT INTO blocks VALUES(310054,'a8b5f253df293037e49b998675620d5477445c51d5ec66596e023282bb9cd305',1419705400,NULL,NULL,'8d9a44b89745e036b67e45724dff383c27c2c67e6dbb959e70e3070d75728213','22ed22ae4cabc3bf271243f79c3a4d2c42e5fe86978a9f860659b2037e69ea0b','f2e8264eee65e886ca8e24e86fad564bdc72e05131afdb9a20cea1977b43497a');
INSERT INTO blocks VALUES(310055,'4b069152e2dc82e96ed8a3c3547c162e8c3aceeb2a4ac07972f8321a535b9356',1419705500,NULL,NULL,'210bb79fcd7754012496ba190c76c2e4fc90a8439d71c85b101b45d68e9325e1','fd10402625c50698b9db78754941b5f3961f19557c5cbdae9321e73a59da85af','ffb1624b4b8cea6cc67323b36f4e9d885001d7d309ecb0a9d4cea1da3d1337ad');
INSERT INTO blocks VALUES(310056,'7603eaed418971b745256742f9d2ba70b2c2b2f69f61de6cc70e61ce0336f9d3',1419705600,NULL,NULL,'875bc142ae6e49eb15e8de0292fb7dd215a81fd6ee5b53877039c7801ce32111','9137c235b9218da6194b0224675ac200ce37e57a280682875b64b614d998f1cd','3fe6a8c8007326f857ede6ac0a94372aaac8572ad4be054bd031f128d6376e6c');
INSERT INTO blocks VALUES(310057,'4a5fdc84f2d66ecb6ee3e3646aad20751ce8694e64e348d3c8aab09d33a3e411',1419705700,NULL,NULL,'50f93f027bf02a9a1aca8ae4576bfc2855a9039ac5f95c2053047c4e0f56313d','dae4bad204dcb46ea70311d316ad02fa49d9643608dd443861402705ffe7f7db','e40c2a62962b1feabbd5deba87aa559991a5e1157a3fea5d57876292d8737f1e');
INSERT INTO blocks VALUES(310058,'a6eef3089896f0cae0bfe9423392e45c48f4efe4310b14d8cfbdb1fea613635f',1419705800,NULL,NULL,'e4f7ecc7c44a83e849c8dc028760d472ce2b9847768e6ff96c2a6eba6e076a46','8dcaccbcaef1b98d192f0b8d62f5b371043d676401c2120be4eda65786fc68c7','48df4670e0706d7c44ec3025531ce56f747143d246f8dafdc9922c21be2b1148');
INSERT INTO blocks VALUES(310059,'ab505de874c43f97c90be1c26a769e6c5cb140405c993b4a6cc7afc795f156a9',1419705900,NULL,NULL,'864145c539814160b0066c771494147ec9b9a7a7dcecd57c9abe2375ca6547f8','96de4dc34f8de9a895d1a45bfb1d72e887ac3c168f2759e9a27a892eb398d63b','96b6d1c3f46bd72f4114e5951db7d7a91523040b21b8e7b8d33e171db46158db');
INSERT INTO blocks VALUES(310060,'974ad5fbef621e0a38eab811608dc9afaf10c8ecc85fed913075ba1a145e889b',1419706000,NULL,NULL,'2ce855064983027c3766cd896af5e109fd041233b62fcd87e1e98d33088e9364','0595e85b26408a75ce220d7afb0111085b2e90aff588a1c828ff389b4c256b4c','999bf94c6a0e63befac8a7c90a8a257452f9f698eac9b2a25edf991c62128aad');
INSERT INTO blocks VALUES(310061,'35d267d21ad386e7b7632292af1c422b0310dde7ca49a82f9577525a29c138cf',1419706100,NULL,NULL,'2cb8f3af8cb4160ca9e6823146a5457e13da26be36e8b6bf7656b8d5fe1dfe91','5e3a2cfbf7e322f28a3254c2af408baae0578e333ed178a80cf416580d5425c7','2829db31c86952e9153df1140348f2720dad998317be36c0530a1c22295b83b3');
INSERT INTO blocks VALUES(310062,'b31a0054145319ef9de8c1cb19df5bcf4dc8a1ece20053aa494e5d3a00a2852f',1419706200,NULL,NULL,'44c858387c0687d7bb51757286a7376afa5a36d21401dd7a963defded51af37f','a8a4c0baa06a4304469c6b9fdeb4ba167e1b795226bf03b655ff759f0b7be9e5','2a893e698d7a2d34c019d4bafca60f1015a28b3297cb956208ed99781c5628ec');
INSERT INTO blocks VALUES(310063,'0cbcbcd5b7f2dc288e3a34eab3d4212463a5a56e886804fb4f9f1cf929eadebe',1419706300,NULL,NULL,'96ade488ca06b72de1cdf522dc985d5cabf0910f0eac00181b6caf3cb930eb89','d777885ff67ef99793a8cd4f4d159580efa194a505eeed1f46a7b003d74d3818','0deb4c7f1035287cdd506f80ac92287860ea553a2e06bdf8c2e38b68dc52105d');
INSERT INTO blocks VALUES(310064,'e2db8065a195e85cde9ddb868a17d39893a60fb2b1255aa5f0c88729de7cbf30',1419706400,NULL,NULL,'f78a16df84177f6da81de31aa773f9332fc341d824ddc3c4dbd92f6b29134ce6','e6a5b1e0c2bdf548abd1826994529d5ec68310fd8a74e05ec5dde281de52ff9c','727cf1a6303b346dba34021c74a46521b251497c512021fad862d1180fb1edcd');
INSERT INTO blocks VALUES(310065,'8a7bc7a77c831ac4fd11b8a9d22d1b6a0661b07cef05c2e600c7fb683b861d2a',1419706500,NULL,NULL,'638e877228c9fd4c5b51fad26436bea40837b32eb96290483031c6bd09df806d','7ce3ffe967f502ba033d3d51165e754b77e6c4a28cc4e569f81cf0a817c1536d','c0b7e2949bfd1f6c161e060143a81438a996714df84d49edb36c44e26ccc0e12');
INSERT INTO blocks VALUES(310066,'b6959be51eb084747d301f7ccaf9e75f2292c9404633b1532e3692659939430d',1419706600,NULL,NULL,'22d839780fe2e75aa75fd29023c63f95b70792c90584ee67dcea0b6f7c629306','2da61818fd2c6fc3a15d998ba79482cb48c49f5a9f195ae4ddba291cac9b416d','cb209bafaa9069b2f9c33add3af262dea37af50ab37b405902dd806d6996e08e');
INSERT INTO blocks VALUES(310067,'8b08eae98d7193c9c01863fac6effb9162bda010daeacf9e0347112f233b8577',1419706700,NULL,NULL,'5a075683d88906314189e211d519bb1ee66c0ca759b7c1658e3fead81bfda405','72cb3676cfd73767e4499bb405f6e07ec421a39239754d75afd8c08cdb49ae45','0f27ce4be6c317de1355ee8003429e3afae47990ae200679551fad505b24c07e');
INSERT INTO blocks VALUES(310068,'9280e7297ef6313341bc81787a36acfc9af58f83a415afff5e3154f126cf52b5',1419706800,NULL,NULL,'78d5046efdfb0e0b65923c042848a16bb150c6ddac63b9b515234f552dc1a8cb','07a593978e6f669c9b378ffd115c951da48fad08b55a7d5adb7ae96bef306061','9e86120612fc4c3e19e9e8a7719684881e6a2497499f6cb4aff0ec315a72090c');
INSERT INTO blocks VALUES(310069,'486351f0655bf594ffaab1980cff17353b640b63e9c27239109addece189a6f7',1419706900,NULL,NULL,'766cd15656356bda83cc8db111bd09fd3236c876b4ec09175f61b2c686929eeb','4822a18f5a177a8a22f1b234c181389614489a33ebf3944b1107acdce0528bb3','bc5aa31dae6891574d7c0c67fbb83643f15887cc7805df5614ed4d4199342414');
INSERT INTO blocks VALUES(310070,'8739e99f4dee8bebf1332f37f49a125348b40b93b74fe35579dd52bfba4fa7e5',1419707000,NULL,NULL,'abe80044416ab39297b400d9f6be10dedd59a3902a5fff4d4bb505c816cde272','54364047ce52153883e68adef9b681266dd725f8e45af89b1dcff3c9edd525e3','b6e9844051b991b4e4bc77d06a01739049d208f4a9cfaf12477a90855f631082');
INSERT INTO blocks VALUES(310071,'7a099aa1bba0ead577f1e44f35263a1f115ed6a868c98d4dd71609072ae7f80b',1419707100,NULL,NULL,'f9a4f37f024e8c2fd4ce589395072e483ee985c83d31c04c4546d049baff2a5c','08991b69e486f1032749e530eee24ffd2d849b1f46aa6ef2f2d5a5202fe06e97','307ce496fe754c9503832bed17e46e4f28fc2fc8adb698691feb87912cca15b5');
INSERT INTO blocks VALUES(310072,'7b17ecedc07552551b8129e068ae67cb176ca766ea3f6df74b597a94e3a7fc8a',1419707200,NULL,NULL,'bde7d166f37e8cb6d4a01dcb89f1aa19f37f1a4d3bdf76b5e851d96b1b6b7a73','e0cd2ae87966825b5f8ebd21c7629fec5ea6ae0f0964ed137f0776d2a1130696','9f3359a3b37fd9a180ebacbf0445ea0de2de5e1fb5ecd6bab681498b0dc448fe');
INSERT INTO blocks VALUES(310073,'ee0fe3cc9b3a48a2746b6090b63b442b97ea6055d48edcf4b2288396764c6943',1419707300,NULL,NULL,'4ae1011f44e11bc96feea5bc6c47675970fd49317b2fcfd701b4d2eb48d912db','4b2ece53331a483fef54d87f0da7e6f712148c0f35388439b73f2aecedc57a12','fe6803ff2d08ed85828363becde4f6b59bda30f6149944aa1e999394b9309d9e');
INSERT INTO blocks VALUES(310074,'ceab38dfde01f711a187601731ad575d67cfe0b7dbc61dcd4f15baaef72089fb',1419707400,NULL,NULL,'09cd8151528b417880a688718754d88a9a30da59d4e89aaf539ed876b9c1a785','28a44c85c432e94d1e15ad9675d2927a983bcde0ad0cbfe47a7d87da00df9f66','49909046f0433b8801a84c1fbcdb983dcae1d14ca1881a5ebfd6d97087b4af4f');
INSERT INTO blocks VALUES(310075,'ef547198c6e36d829f117cfd7077ccde45158e3c545152225fa24dba7a26847b',1419707500,NULL,NULL,'421336787b7f030133ddcd428e2b9ac3d2932b89fb75c6e7cfb9f0a3973f26fb','398cf0362d19717ca11dd2a5f022a1ec94122f7bcfba0c4f25a793826b1a0892','6252884f3fc6c52dee7ffaf6afae4f78d20eb5d01c0a8e50c96be4e36ae143a8');
INSERT INTO blocks VALUES(310076,'3b0499c2e8e8f0252c7288d4ecf66efc426ca37aad3524424d14c8bc6f8b0d92',1419707600,NULL,NULL,'5d81433053ae9fbef355b8aa381d4cd73ca48435f3c5060892ac4ee50c185fe0','5a17953bd90e4ad629cc7c24098e50a5ea86e84a5796b5db5959c807e0f9eba6','cb144dee7bddbab6543d34fa2c96f9e29e7e16c386bbfa5946e0004eeaf3cd1e');
INSERT INTO blocks VALUES(310077,'d2adeefa9024ab3ff2822bc36acf19b6c647cea118cf15b86c6bc00c3322e7dd',1419707700,NULL,NULL,'b5b7b381cde58809526b55861c37832da4cc65bd8a71991c2241bec9ebf5cf14','0491cd1f3f3c8a4b73d26a83aa18067ec31f868df96ed4667f8d4824a768a4d3','f38bacb92dcffa49d51a9276a3ef96e31b41532e9ed6b3d3a6fef8cf63d0ddbe');
INSERT INTO blocks VALUES(310078,'f6c17115ef0efe489c562bcda4615892b4d4b39db0c9791fe193d4922bd82cd6',1419707800,NULL,NULL,'2911187748243e818b0eed824e9516f565c2ebdc877912d7954a19c1dca141e1','ebe0a3e1269a54e03ae9b7b8ad5f00a1e88b4bdbf2c7485ac1188eac31c0a4b1','98cdd8d5ee877881961d755b5288cfc965e4a54d3fc5a31534feeaa6a21df777');
INSERT INTO blocks VALUES(310079,'f2fbd2074d804e631db44cb0fb2e1db3fdc367e439c21ffc40d73104c4d7069c',1419707900,NULL,NULL,'2b7db9ec143e468a717c7c25ee61d2f7030d5d995a21bf55f37a91c8520e4733','8dca0f21abeff518ea5c6a0fff3f3c89e0d6b263a72adfd36cbf911a306080f1','818f39d86b59d5b8f37b33f3ac6c961cd1540a5a3cd0f50babc12fbf9c44c3de');
INSERT INTO blocks VALUES(310080,'42943b914d9c367000a78b78a544cc4b84b1df838aadde33fe730964a89a3a6c',1419708000,NULL,NULL,'939becee8c0ce7d6c8afec978fed5f6611fde457ef196a5ae87f804d0e7f479d','0ebd79095ee1e751b4b694c04d31fe2246db4558ee9763504c9802c2a342e817','bd725b71cb038a1ced7390acafc5d672dc215a48331de72038bf4db0cb565cb1');
INSERT INTO blocks VALUES(310081,'6554f9d307976249e7b7e260e08046b3b55d318f8b6af627fed5be3063f123c4',1419708100,NULL,NULL,'b3ed4826f6858a4fae07dddf3ba604ca0b763cf8e34288dc6b9ba6c1ab3ee279','2eec4afed90d334123b8299d50c192db4b6b7ea0f4868734ea435e5f2cd7c901','bb4fd8cbe61a15372f6fdd780e9e1f0a5dafa0ee1fc062a52fd3b9a9b72141d1');
INSERT INTO blocks VALUES(310082,'4f1ef91b1dcd575f8ac2e66a67715500cbca154bd6f3b8148bb7015a6aa6c644',1419708200,NULL,NULL,'76f73f4dca7173cf7bac03d5766517e92dc8a8465b405784e35456116e31c396','91c5071bbab5368e2338657982adb58c861546c0c0ba9fe9abd6b8b781e415ec','61c1473eef3fcb9238ae808bd3b397eea211eb8074fce9310b1d0e73972056f3');
INSERT INTO blocks VALUES(310083,'9b1f6fd6ff9b0dc4e37603cfb0625f49067c775b99e12492afd85392d3c8d850',1419708300,NULL,NULL,'3ec9b2d70ac6231bfc7ea1e3cc0cfe0f50bfa0de434b9e3e13196672a4b6a847','bf0da4a320545ab08a86a86a81d5702f7d493e6c3173344dc19941c8a527f4c6','4fed41e2be694148776a0b8429a58c573dc81d5ad3e4b3ce48c396f860d8353c');
INSERT INTO blocks VALUES(310084,'1e0972523e80306441b9f4157f171716199f1428db2e818a7f7817ccdc8859e3',1419708400,NULL,NULL,'ecb6fbc241ea346b454f0ec7d00fd583f4c26d3cb95b9dbb959f73db63ed5d94','ebd03846d979ea8af53d9853c2b9ed94bc4a89c1d554cd5d5a2557bec8a127c4','681e1e916c2822b2d7d4a12218d2028aae47e49cebce652304906ee689ac7a21');
INSERT INTO blocks VALUES(310085,'c5b6e9581831e3bc5848cd7630c499bca26d9ece5156d36579bdb72d54817e34',1419708500,NULL,NULL,'de7d57634b5e189553e9717022b1759cf477a5b0704e0e415aa1552522a30151','00e86699ae5a8450e0ebec24deb4932b27686e436c2cae3eca6428a7229edda4','165163b004b0b627edf48414a4f6bf3ad037ffdaa82a33c4d1071a457f35b33b');
INSERT INTO blocks VALUES(310086,'080c1dc55a4ecf4824cf9840602498cfc35b5f84099f50b71b45cb63834c7a78',1419708600,NULL,NULL,'d1074122f3ded1fd3bd5bca15501f2f9c9bf07874ce83ef3c5cbd7eedf616144','8db72da41c05d03d36307441dc8751f1907da2a60e209cb7ff47e99d7b22e88e','829e0e41bfb313f1816990448a14bd82c847c745f35ff5949427a6687996f86c');
INSERT INTO blocks VALUES(310087,'4ec8cb1c38b22904e8087a034a6406b896eff4dd28e7620601c6bddf82e2738c',1419708700,NULL,NULL,'92a26968a9c3a8b8e9f6d348f4c16e91dfd011602212c45a4427ab443e3f7005','9c9e3ae63fbf9180a1d17a19f47f77817eacc0aec0c031bb13046accdde03799','e3d85ba094ef3628fe49cc783d6841684d5f6d2b2f32dd49c58e071968e404b8');
INSERT INTO blocks VALUES(310088,'e945c815c433cbddd0bf8e66c5c23b51072483492acda98f5c2c201020a8c5b3',1419708800,NULL,NULL,'d19145e0639e5f6eb8a5fd85e23b96ce3e96cb7d33f4bd6d5c70e02664925f75','0ea167598525f3a88c6ab4c8f5138a41ddd7fc8e13338fa24706b9a30337f223','a43fe244b2a3aaa718ae5d36b421f6856d04e4f5f260c658bf6f769283a58d02');
INSERT INTO blocks VALUES(310089,'0382437f895ef3e7e38bf025fd4f606fd44d4bbd6aea71dbdc4ed11a7cd46f33',1419708900,NULL,NULL,'fb4a1bb41fc819af29f465b17034203fae234e3738a8081a7c7a2a9bd8b62a64','8257d7e04e5813b7e184ec5b9bdbaad39c779cadbaa31907a8b52ad8371b5d09','d0032d956999d3ee2ae4dc3802b037da07bbc5aa3c52e2f162857919c54008ca');
INSERT INTO blocks VALUES(310090,'b756db71dc037b5a4582de354a3347371267d31ebda453e152f0a13bb2fae969',1419709000,NULL,NULL,'c676090c18fa8ab492c45282e6e5039053a516aae3b7e80db602336ae6a0f3c6','dacabdd06a6ad7c50a6789bde4cbfbf5cf3d85a1e3b5d3621e0e93cf743ccdf7','678aadb2f62149b2d481f94a2c9f9b9c5e350de628028f8a272cf584e8de367b');
INSERT INTO blocks VALUES(310091,'734a9aa485f36399d5efb74f3b9c47f8b5f6fd68c9967f134b14cfe7e2d7583c',1419709100,NULL,NULL,'1ce26249553aed999f71bea23665753076b1657d22d5bb31c68ac4a3cf7a8dca','1b382e2152f884268b32811171913ac28e7a1d40b6eeb6423b6a807ff417052b','cbc1b2a6a96324103348a553122bc58b15ba1ad45def58de517f23e69ca66c51');
INSERT INTO blocks VALUES(310092,'56386beb65f9228740d4ad43a1c575645f6daf59e0dd9f22551c59215b5e8c3d',1419709200,NULL,NULL,'49d1618328f0368cd2827f009f85b394c058b45aee1efe39dacc2c7de23c0122','d3a42c8de911e63c540c541aca141f057a06852f519e89491e25cda63480c442','97410e3dd94373d1799b668db6fe7ec22cbfb1780da1df9964740f55b0a38b9e');
INSERT INTO blocks VALUES(310093,'a74a2425f2f4be24bb5f715173e6756649e1cbf1b064aeb1ef60e0b94b418ddc',1419709300,NULL,NULL,'bcfd1460fd4453cc0fd81a8fab285fadfe3dd4f336b0739c664c7eb3c7ede027','5e36c495f7310dc1815a73ab767f53eb04fe517eecc36d8ac9eedc2c1dcf117e','1333ea32f488cb9254d39a3839e26d08ea9decf843ca07449715e76a8e6092c6');
INSERT INTO blocks VALUES(310094,'2a8f976f20c4e89ff01071915ac96ee35192d54df3a246bf61fd4a0cccfb5b23',1419709400,NULL,NULL,'2cadeee5fd8afa6e4f6a4e79505ec858d168361ec1e7549b6141911b2d922012','296aeb138c815e74a0f41e87ff2f463ac32dc01dd3d24da6fbcdf47542319e6b','4a0433268293f9155e1208782e55d7110b02d19c78f7082329e7665bd58797d7');
INSERT INTO blocks VALUES(310095,'bed0fa40c9981223fb40b3be8124ca619edc9dd34d0c907369477ea92e5d2cd2',1419709500,NULL,NULL,'ffbf40fd04eff254d621b03244beae33963c70c23518b93ccc2ebb46fc505050','17b1f9d5c3426a4edb4734657cba1713f9a56991bd1b78669142ace96327d357','2625992cc03b9f658609757b28a57056f7cc85731290b40409be4dd952b91217');
INSERT INTO blocks VALUES(310096,'306aeec3db435fabffdf88c2f26ee83caa4c2426375a33daa2be041dbd27ea2f',1419709600,NULL,NULL,'85da4ae6b40b4df37fa30db7ac88f6cea4a4fcde59a62665ee5fbd225ce77dc8','6d05d09010684842a6048d4a70e1b08e22515caf58bb41cdf4be8b0643e6a788','c766fa6f7a45a760c365b48464d540bae110756821ca3d24fbf8a2ac0ff3ca33');
INSERT INTO blocks VALUES(310097,'13e8e16e67c7cdcc80d477491e554b43744f90e8e1a9728439a11fab42cefadf',1419709700,NULL,NULL,'11d14f3ac23bc157674105df87b1e7397eebd8d0404d6baca79816aaf882e0a0','e713310f3b49ad5f4a7a33edeede88ebff816f891ad3b75a971d402c470adf92','9435aa449b03e4561946a95e1ad3fdd80728af633d08cebd7b6fffecdc45f0eb');
INSERT INTO blocks VALUES(310098,'ca5bca4b5ec4fa6183e05176abe921cff884c4e20910fab55b603cef48dc3bca',1419709800,NULL,NULL,'a10c95e2364241808f12b3fc748e2726abdd1e1ae00b7dc235ac9c0812f31210','1300dfb9b2c5511a312714c5679e956df96f6556b217245a5af1696300b1183c','e0121ba43e4f92d71c0ee830d735ce7ed19742b8a3ad92b3cf365d227f611b84');
INSERT INTO blocks VALUES(310099,'3c4c2279cd7de0add5ec469648a845875495a7d54ebfb5b012dcc5a197b7992a',1419709900,NULL,NULL,'a7a230cd78baa2631945cf8580650619cf4496bbd62f69f1a268fc149f703ae4','f8c5bf3169d6c75d82c17e0567207db18fa4326b173fa441f574cdd4910e41ab','f9f4a5413863cc5751e4d25c039208541f15f10e24c8c2b33b289134b89c2424');
INSERT INTO blocks VALUES(310100,'96925c05b3c7c80c716f5bef68d161c71d044252c766ca0e3f17f255764242cb',1419710000,NULL,NULL,'de08199eb0b31e21d77b3f25e5d34245354020a9b0b62ae1d675302086bdf5d4','42c7cdc636cbd0905f3bc4479d1a9ef6e0a5905732ce78e6f3cd63ddb2c5f971','fdb19809b7a13dcd43f246b2409c835ca68530eb1e131b28ece08ee54bda5636');
INSERT INTO blocks VALUES(310101,'369472409995ca1a2ebecbad6bf9dab38c378ab1e67e1bdf13d4ce1346731cd6',1419710100,NULL,NULL,'da18d5045cbbc78f4efc9f3f5cb29ab6646b8b5b058347e6aa3b4e1b9ec1eef0','a30a1c534bb5a7fafd3f28af05d1655e9d2fa4a966e420716ca16f05cef355e2','0ead19e3cdc566868f8e20d3da447292929248002f5408a2c4583617b7d29e69');
INSERT INTO blocks VALUES(310102,'11e25883fd0479b78ddb1953ef67e3c3d1ffc82bd1f9e918a75c2194f7137f99',1419710200,NULL,NULL,'a78d0a8b586ab0a9d3d890248892712b3eaf563710af876ed5c3142fa3c34852','7166828ceb34a1c252e97efb04195e3e7713ae81eda55adf1a2b4b694ab05aed','65854b3826f06116cb7aba2fe4a4fedf0ef33d9249df17df315d9c0e13834ff4');
INSERT INTO blocks VALUES(310103,'559a208afea6dd27b8bfeb031f1bd8f57182dcab6cf55c4089a6c49fb4744f17',1419710300,NULL,NULL,'a4825d7f486147b09a1863de535d119989ab213dd3c651cf69a60f979936c74e','0fdfd69cbe22d8b0bc67852b20d85447a7ac6e2b14e29255eb371035245cf3b0','3021656b558789d1effbe1fa228a18cc80b82a499c8db40fa96f127742844857');
INSERT INTO blocks VALUES(310104,'55b82e631b61d22a8524981ff3b5e3ab4ad7b732b7d1a06191064334b8f2dfd2',1419710400,NULL,NULL,'1e3f3263cd29f5087589258c73ce8ae5a95305e403e9552b13e604b118620d1d','e8ca37976b91bb8408f00847a9206db31e5af88aed6ba08b5adad49a3f187e4d','01320ba377d36b407b7ae657bee30ef33fff828900db366d47252d4338899483');
INSERT INTO blocks VALUES(310105,'1d72cdf6c4a02a5f973e6eaa53c28e9e13014b4f5bb13f91621a911b27fe936a',1419710500,NULL,NULL,'90866dbf2705273636b047e2762e7f2590ab465339657eadc0c446f564b1d29c','7e58c01102a7ddfdb8cc1c47a0ec0ac79e77ccf686e8194824deb6fd77447160','9c56c6aade4f6d006251ec3f0ab59f2d17147b301587be9fe0c126750449c8c8');
INSERT INTO blocks VALUES(310106,'9d39cbe8c8a5357fc56e5c2f95bf132382ddad14cbc8abd54e549d58248140ff',1419710600,NULL,NULL,'fd18f88bcc097d38cc495ee4a99e91043e3163c531a8e888d11efd3ec3916945','80e5ca0057cdb1040350bcb420d35433a91bc598da0dbfc8fa819a1efae69438','cd7ad546529520cc87c9e363cdb60f56b256c4bc8adaaa83180a8e4be36ededc');
INSERT INTO blocks VALUES(310107,'51cc04005e49fa49e661946a0e147240b0e5aac174252c96481ab7ddd5487435',1419710700,NULL,NULL,'efa7eeab4524648489724b8d9b28316394b718545ecabbc13e01e06283b94dbd','16ce0464b5fb26942a40db47dcb2add4b9a112d155c474b57816cf2bbffe2346','cdb23e4fd7eff2f696b8f3ef4dad886d4d473f26fb30f18c0a8ac958ba48a0bc');
INSERT INTO blocks VALUES(310108,'8f2d3861aa42f8e75dc14a23d6046bd89feef0d81996b6e1adc2a2828fbc8b34',1419710800,NULL,NULL,'fd641f214936b8e70ec011071ce1272d1f064b0073ae8a8217bf4cedef757790','b21bb20c2c8487c16af58f50fd4a9c6486dc0737b4d30c8dce01aa4b4f6cc95f','cd3abb8dbc23d9a921fc85a786b22897f6c91a4dc41abeb2d51def579076f05f');
INSERT INTO blocks VALUES(310109,'d23aaaae55e6a912eaaa8d20fe2a9ad4819fe9dc1ed58977265af58fad89d8f9',1419710900,NULL,NULL,'8b9f5a8a98f2fc6c1e9876c7d52969f5c30b133a3a442aa480f97e2f01f6247b','f3fa226756ff6da1b729c7643364c3d813dea1ac80d9d727a14e5a96f4e18a46','f7847035f5401aeb9167f0ed3cd221d112741d32e1b05779e9f765ac15887f2f');
INSERT INTO blocks VALUES(310110,'cecc8e4791bd3081995bd9fd67acb6b97415facfd2b68f926a70b22d9a258382',1419711000,NULL,NULL,'b4bb138b9f310d1824d36706fbc337e96faaefb0b0d701da9f825f589e67e88c','9dfd85e6c3e910a365b5e3b23cf776a28cbd4c5efcfcb5432e224acb9badb90f','bab570be63da51f3b187acb7f6228c8d0b5f3bf0c68dd7b561e31cd8ca4d4270');
INSERT INTO blocks VALUES(310111,'fde71b9756d5ba0b6d8b230ee885af01f9c4461a55dbde8678279166a21b20ae',1419711100,NULL,NULL,'b2116f61322e3d3d20ffc80d949dd71c68d191961281671f417f2b112c9ae5ff','86edd891385f7106d8f3751b2d9a758118a59a12766026aa61e2ae2598e1da37','89137b94bf3bd0e9da723fc23aa244fc5cf93fd3e4a6eb148f51c50ae6a48227');
INSERT INTO blocks VALUES(310112,'5b06f69bfdde1083785cf68ebc2211b464839033c30a099d3227b490bf3ab251',1419711200,NULL,NULL,'edc4b78bf4952e685350aaddc74ff658272f55411cac4a68edcfe6b25a02445d','a34fc9f1e5447e5fb5d4fd2658aeae630b1561588132d1d8285a7805f5031b74','38f3de9dc372a1a8f87aed291783ba956c5a68ad73ed347334cb4cc8b217d6bf');
INSERT INTO blocks VALUES(310113,'63914cf376d3076b697b9234810dfc084ed5a885d5cd188dd5462560da25d5e7',1419711300,NULL,NULL,'f538f42fdca649626e6d3a689217082ce4cf4f116bd668ff35720a4ee73e2e9d','d9bbac6b63da17f59c2e9ca69f6aef5a3c158ebfd05c15bf7c2dc69ff5e3a6a5','6b230ea85b1f887d62fa9fd764ebbcc2d7a74844570742da91e10d73bc2f8233');
INSERT INTO blocks VALUES(310114,'24fc2dded4f811eff58b32cda85d90fb5773e81b9267e9a03c359bc730d82283',1419711400,NULL,NULL,'a1595cfd25fa18e2265f8185724ee38da634dbf6a69ccd191693c706f3469243','fa2e6c65c367ab1bcbf9099d8ce153da2b24219ae39a103725e295eae9d0da3a','43cfb05e193cc9101f41a71167b88b682cb7a7253d52f678ff43ee73c2cc1341');
INSERT INTO blocks VALUES(310115,'a632d67ff5f832fe9c3c675f855f08a4969c6d78c0211e71b2a24fe04be5656a',1419711500,NULL,NULL,'b0f361853334d95dd5b7c98dc475652385bebf2d1a9449daee72c06287135084','477abdae7a5b59a35866bf658cce191632c548fe47ec015df9ce24ddc73cabea','e2a649598712635fb411967fe82d92a56dffde5120a01a3ad0cd933901e17322');
INSERT INTO blocks VALUES(310116,'8495ba36b331473c4f3529681a118a4cc4fa4d51cd9b8dccb1f13e5ef841dd84',1419711600,NULL,NULL,'038f5aa1eb2f56a59216d15c117302c676568a8260e225232459f7437f8b2e06','4c10084f42b70959960ddec7cae09fa0deebdfdc94216ff3f585d22234fbe669','0f9008ee276c70624bfe5afc1a223e84527d234860c75b5002b2dfa3682f851f');
INSERT INTO blocks VALUES(310117,'978a3eac44917b82d009332797e2b6fe64c7ce313c0f15bfd9b7bb68e4f35a71',1419711700,NULL,NULL,'5e203bb09a20b37e8799171d8843c0cc3a3ed02a5154d45556ddc7918a2cb7b0','27772c56082a3309195b5082d711e64ecacca9cba0cdef66be6cceceeab76328','b258e275416d242f9cb7b2a5f2920e43de46e9cc08a0085a5fd392ade8afdde9');
INSERT INTO blocks VALUES(310118,'02487d8bd4dadabd06a44fdeb67616e6830c3556ec10faad40a42416039f4723',1419711800,NULL,NULL,'63f5537dab8690bad18f3f67fa9b5b01b7ef1a8e51bdf058db4f3434e2f31e68','ead4194e5bd9bfb1afd679bbc85b9c367172ee6f19418a8f34ce00d7be8b335c','a612e64e56996b74366ad91066f9aa83297b0f53bb9c9225cfbf7024091d01fc');
INSERT INTO blocks VALUES(310119,'6d6be3478c874c27f5d354c9375884089511b1aaaa3cc3421759d8e3aaeb5481',1419711900,NULL,NULL,'7f0732e716f370b21fb0be012f9dd41a2e79cfbea8c85c08c9c13eed01c84079','35d8546a2a9689b9dea62510de36ce3d70ac419c86ec00c2633fba61f0af8718','ba3538a59bd9749ad86fa4d10717205c1fe0372aa2b4c1a4618a4ac276c86c01');
INSERT INTO blocks VALUES(310120,'2bba7fd459ea76fe54d6d7faf437c31af8253438d5685e803c71484c53887deb',1419712000,NULL,NULL,'98e5695e6dbe24eb9d19928a46b2fdb4f18c49f5c4d1b730a755268d5b06c9f7','facc1c8749ee5b87c4c6475ad411aa7beae6c50113fd1cb783c780c161d5f86d','d4138fd4d93f371138965c843791f4b2fb8e708e5c4c6ad3642e278509e27661');
INSERT INTO blocks VALUES(310121,'9b3ea991d6c2fe58906bdc75ba6a2095dcb7f00cfdd6108ac75c938f93c94ee7',1419712100,NULL,NULL,'fe03cde3085c40fd68cd99d42afa82755c60a278e552e9fe318d20c3be01fa6e','92b8341669962dba8fc21d1caa5d9bed4a87b634f08484f38fdd91d0512cdca7','1b4b3d722d692068d4d2b4fcc4056e680ab05a41f2df6c233ce1a2a8f885cb2e');
INSERT INTO blocks VALUES(310122,'d31b927c46e8f9ba2ccfb02f11a72179e08474bdd1b60dd3dcfd2e91a9ea2932',1419712200,NULL,NULL,'b3d083c0d976042d230bec61afe287da440205ae4ffa56c337d295a53c77192e','210048e3367a866cbf2981db827130b7063e3d95ce1f7dfeee7a4d0d2e536d1b','e145f289b0ef77c7a5f6858a8308c5892213aca3b19997a0aed3cb0cd9db4f8e');
INSERT INTO blocks VALUES(310123,'be6d35019a923fcef1125a27387d27237755c136f4926c5eddbf150402ea2bbd',1419712300,NULL,NULL,'e4ed27ac12095509b39ca2659f0a6e185b3a53ad8b1018f9aa14cd7a41c42445','724fec593a9170bdb46db3aeb04f5dd2d402f3d2ba1d544f2e14f215a160338a','ae7b1df63a59d3c4c1b70d6db02f1a4e8b427247183432f8670eb93bd008a13b');
INSERT INTO blocks VALUES(310124,'0984b4a908f1a7dac9dcd94da1ee451e367cc6f3216ee8cdee15eae5d0700810',1419712400,NULL,NULL,'05de89b2740bf020b5f6b86223ac151ba1b4f36afc98aea5a67154cfdf41d539','cde3e0a437b5684f22250eb754ef208f03668fc627fb7af808e21af409dfe72c','83274015226ce5ef06ca8a168c72892d24c7b498f5c4fb1c48394f1509c3eecb');
INSERT INTO blocks VALUES(310125,'cc28d39365904b2f91276d09fae040adb1bbbfd4d37d8c329fced276dc52c6a6',1419712500,NULL,NULL,'b5ee2dfff6786df641df8597326760d7585e732f4cd344a9641533dcae11394c','de8f387f7346ffff2462ea7baa6776f51b3b5a812a19a22df3ce06a13fa802c1','7cc51861353351814ea7383d609e941b4c8c1ba5078749ec0a326bc81ae18008');
INSERT INTO blocks VALUES(310126,'c9d6c2bd3eeb87f3f1033a13de8255a56445341c920a6a0ee2fb030877106797',1419712600,NULL,NULL,'30f2edad0a2080ca75e8d5cb81e3a889fb2eb4e3eab2d976c42b956068a17dd4','a2bc0ac39e12f0b696c8f4c85a13e25dfa2e77a7e1da05bfc346d09b529c7b6a','99f08761b05b008054a2a73173e3158d4cafcff626b5bd19b4dc31a25ff17bb2');
INSERT INTO blocks VALUES(310127,'c952f369e2b3317725b4b73ba1922b84af881bd59054be94406a5d9bbb106904',1419712700,NULL,NULL,'fbfb5edd310aa613d994749dab060a7b05d6b3ef0f3dde62fd52bf0f330ed181','b3c43b881dc2128eb24c43ca15672ec3f5dc94877f384f60f9a344e8c276e9d0','6187db22f01734e596489c9819f67dcafc8e80534cfd553ef8a6d2196544dea4');
INSERT INTO blocks VALUES(310128,'990b0d3575caf5909286b9701ece586338067fbd35357fec7d6a54c6a6120079',1419712800,NULL,NULL,'bb857b6162365c90b541293b1f3272a000ca01b3ea1cc4d1c022b089d15bc89c','796ea263ac014e092aa13cb6eae8e0c03ea8e0ad11056234b94afe5c094e6a9e','a3401585f239c70051ca5a1dea36f227b2cb5eccd3ee7eea3f0ad9e78f99fa3a');
INSERT INTO blocks VALUES(310129,'fa8a7d674a9a3e4b40053cf3b819385a71831eec2f119a0f0640c6870ca1dddc',1419712900,NULL,NULL,'670ea5c18612d5f0f3da5e55c8c70c912467d7a8c5495da762170ef2fc2eb78d','96c268ba3357d63939d294f72eb84bf1e71453a136c06bffac12d08017e92bc9','c4703df95db02ad5fcf151632b0667961f4762747d00e899323540bad06f1b65');
INSERT INTO blocks VALUES(310130,'d3046e8e8ab77a67bf0629a3bab0bea4975631d52099d2ddc9c9fa0860522721',1419713000,NULL,NULL,'3b1c512a454ea513e01954aa3e3e5331a7da67a97b0feec9a1bfd6d453e94a62','ecdffb60b9c783b64417f90119d8485ca3e696d3e1808646510c458929fec393','1c9baefd1298a8768e849ab0562788322bff084273bee6ba7134d87bf1f933e7');
INSERT INTO blocks VALUES(310131,'d6b4357496bc2c42b58a7d1260a3615bfdb86e2ce68cd20914ef3dd3c0cdd34d',1419713100,NULL,NULL,'5d0e6b5c8ba39a5b0a7e6e91474cb4a1f8c4c53bdfe9e396196885c20ff8c989','89bde3828ee2b7af8c53acdcc02883b0ad2b5d04cd087e4aff16ad8bf26a2f70','1802b4828c450dfb217b9bdfa46ebad1c89b72a98515657966b6a8855acabb3b');
INSERT INTO blocks VALUES(310132,'1b95a691bf4abf92f0dde901e1152cc5bd87a792d4b42613655e4046a57ab818',1419713200,NULL,NULL,'323ee01e8827ba137cc07ff9d775860b1ea8a56cec4f5e36690b78e956f8cc95','e7ae90e20379234d37114044c9545922607b56da8e6668319dcdce0a6cb10704','f5a989bcbc659417da524df7b64c3621da98a320122d8e2d4b8eaf2d2e1441b9');
INSERT INTO blocks VALUES(310133,'1029c14051faabf90641371a82f9e2352eaa3d6b1da66737fcf447568ca4ec51',1419713300,NULL,NULL,'99b228e2435ab0c5eb41a219739a4f817ed307d9cdeab299d743fd8567dbf8f4','12b0bac31357a0d259af8af86ce729361f9ff413e51eb1cf379cd008f469ae42','11b65f307af9c79aa378d8b5d754cf739430ecfbdf64e267974141c5c9bbe114');
INSERT INTO blocks VALUES(310134,'1748478069b32162affa59105257d81ef9d78aee27c626e7b24d11beb2831398',1419713400,NULL,NULL,'e7bd503bf8abd0550c38c87e29f19dd80a1640ff193b1a938efd30a8c8c16f07','4a9d6c0e52e287599334b507a633b01155e7bad1f87988235e62e5b4e3426299','ecb85801ce6028326d6d8a013d84edaff51e9f367dfefb4debb8cef8c4c726d7');
INSERT INTO blocks VALUES(310135,'d128d3469b1a5f8fb43e64b40f8a394945d1eb2f19ccbac2603f7044a4097e4f',1419713500,NULL,NULL,'dd2ce67fde428a52376dbe7bbe24cffb6114a3b456d025561443afb61098b3fd','2d1d51ce86c608ccab0a44504bcbbf407517854b9bf7ad8003f9e4ea6525ad73','b699a7fbb8476267cc90bdbfd084e195b996a262cc10e7cf4ea1e58d4a7592be');
INSERT INTO blocks VALUES(310136,'6ec490aaffe2c222a9d6876a18d1c3d385c742ff4c12d1334613a54042a543a5',1419713600,NULL,NULL,'883ff44b97c7ae64e8ea72dfc475fc4f31bd99ee1a940a3df035eb1d7b78bae8','87b931a71c75f2ed7bd0bd2cd9e7556399e9f7641421ad307a7b14a701d44021','d4ea19f14d2f8d119285eae8b979ad590f98618f193b4bd5f6d62730839fa391');
INSERT INTO blocks VALUES(310137,'7b44f07e233498303a57e5350f366b767809f1a3426d57b1b754dc16aba76900',1419713700,NULL,NULL,'93e8d53ee21a4cd5bd4d9f63faa3949bbbbe7af21f202ac4c21a682196d36c97','4bfd2d4475cc42b9e0f1882909dc48a7316c6a82439da439181d0ce4735a466b','3a14f127cdecf276141881c80420aa9837472e7a8b127f19b1f2a975b1a30c2a');
INSERT INTO blocks VALUES(310138,'d2d658ccbf9baa89c32659e8b6c25b640af4b9b2f28f9d40baae840206402ab5',1419713800,NULL,NULL,'41e024e23e6650f5410654519e5cfaf83fffdbe7c4378fa5226a4b130969e563','b2b3269adbc26daa48ab8bc9df7a025360633cc96696b743ca9e619dfa1a78b9','409fd4eb3a3cb7f22bcefe6f808ae38ec1731146f9211e2d69f6be86269ff042');
INSERT INTO blocks VALUES(310139,'b2c6fb61f2ae0b9d75d18fce4c52a53b1d24772b1ad66c51ca51090210527d46',1419713900,NULL,NULL,'55f67ac259890c6cb9efb6d040f367bedb7a63c899df715b32ffbaf03352e8f2','f8944205c72649075ba783a900c3d6e5a5f5d41aa520f1fe83291be6ad0d7441','5aa27c6d9155db9438a1e4af01bf33a14f472242d4212cf3db98003eb9bc35ce');
INSERT INTO blocks VALUES(310140,'edddddea90e07a466298219fd7f5a88975f1213289f7c434ed47152af6b68ebb',1419714000,NULL,NULL,'e00bc8f73852cac182bc619203207f1145aabd56e1d6d6fb8bab01bb2bc0fba4','67068cf2f33a8a41d0c2e85782911ae9f9cf7a5b9aa6d4774abf308e96e2fc11','440f6c55e83357646fd852d3b18b681932bfe99123727b8dbad0fd6d97001831');
INSERT INTO blocks VALUES(310141,'b5b71d2a271bd638561c56f4ffbe94d6086debaaa86bfeb02ef0d71339310709',1419714100,NULL,NULL,'cb0f2644c5d59a97e09ee121102c7159e26b0b24a1f88dd2e2072c8fa7fce9dd','c5b52f05030735b9ef724db2cc40b1f0f611daab64d32afe674b67757cfe813d','05927af4b60d8934a4c6de115da3e0f4cbe85d488f5b31bd15ebe0129271ba6c');
INSERT INTO blocks VALUES(310142,'a98ae174c41ab8fc575d9c8d53d8e02d8e446b8c6c0d98a20ff234eba082b143',1419714200,NULL,NULL,'d20f45d2724df10a2d642161e1f2fd2d886a26c11417ebf786b88ed6d16bc16c','8216f9bf0ee104adff6b0811b6ef2887ba1f960772b4c55423463da2d4c6f151','165239296ad5311a13969f868762f6653bba1c417f44c1b96346a3f1719a327f');
INSERT INTO blocks VALUES(310143,'8ba2f7feb302a5f9ec3e8c7fc718b02379df4698f6387d00858005b8f01e062f',1419714300,NULL,NULL,'3ed9f4cb80292d8e32a82dfd224d2bbe9e6023536374f648ee778beb254376f4','570f96172b939bcb012c6d2fb5a8115383765122e081a5cddb0ca9591b2f06c8','24288be367ae75f1209e66a22df9bad36672ac5481b6bb545bb42aa25610b226');
INSERT INTO blocks VALUES(310144,'879ffa05ae6b24b236591c1f1537909179ed1245a27c5fdadd2218ab2193cdb9',1419714400,NULL,NULL,'d2bda0dff64b340869b8e345d3d639d71154f99bde7f882793ecf036cb2c4839','116d672bd44332e9de84c2e3e246b27f3e366a39a9334124e3030a174abb0ea2','3d99bed994370115d417bd5e53ab43a3570ce34b52b7da487f73050176090d62');
INSERT INTO blocks VALUES(310145,'175449ef0aa4580593ad4a7d0c5a9b117e1549ea772af00caa4ccdc9b1bf7a6e',1419714500,NULL,NULL,'7fb79790b47269cc5d6ac4486d3c49ec8fa0377b03d899cb76f27b2d01f32adb','caf90fb54514810234dfed478fd5b7f711752ecd85e2a754015e2b44fb8350bb','134fad385d9e903f27f7cc5a1cb6ad28b6df80597302eaa477f48eff81c9d7d8');
INSERT INTO blocks VALUES(310146,'e954ab6a110455d745503f7cc8df9d92c1a800fafdd151e7b1912830a9cb7184',1419714600,NULL,NULL,'c1ca5cbc2b3012478b6aaa2953aea9746fcf2760a3010fdc851a75cee3f17651','e10b764b319efbbf30dd6970c43e777c398e0af5dc237efea65b50d59f0d5eb8','cff30029db496c30e11da5fbc7bced2b12edb6d185492ba50993fac39ff45321');
INSERT INTO blocks VALUES(310147,'7650c95eba7bf1cad81575ed12f32a8cc36281a6f41bef13afe1dfc1b03a7e83',1419714700,NULL,NULL,'49dc9b951064db917eed6f6288b99a0aecdd2c8d8555e30d1702f8b99b18cae7','1a77716d8198b02dfa2f567e3d5ad1d25c507d57bf9ced9a17cc1402f1d81a8e','d64ab152d87606833ce9a60960c47c1d57884b8d05c0c3f0d593ffe794403ac6');
INSERT INTO blocks VALUES(310148,'77c29785877724be924f965215eb50ffe916e3b6b3a2beaea3e3ae4796545a7e',1419714800,NULL,NULL,'76d534abbd9e90de3d9a5d41d7604e46ccf41642effa996c5883f1de894f77be','1e49d3246c9a470a62e315bc6506e6334c4abe7be65c9fddaaa4b7cd8388df06','7f0e0ced1573bf182a785bc922841fed09ee56a36b9504d9f56571c93ba86c08');
INSERT INTO blocks VALUES(310149,'526b3c4a74c2663fc04ed5234c86974bffddb7235c8736d76860778c30207b3c',1419714900,NULL,NULL,'631847ef55a860bd66db2df57f8c62941462338d280cd4abe20673584f92b56a','7bab72495eb56e2b9c842a6913e8f7ce1a0c1a8c81a3498e01e9b2c8887e473b','ae9d8245d3099654417ffab4768849cbc2a48a080b3726968c0074b77595df90');
INSERT INTO blocks VALUES(310150,'cdd141f7463967dbeb78bf69dc1cd8e12489f58c4ea0a5dc9c5c01ec4fcea333',1419715000,NULL,NULL,'70955f5701719f63362d4e493ec2e1ac91587649ccfa1262a127f65b4a442364','ee1986e7b4791d28e0e97a0b9afe8ad91982a103298e9e8ee58a76cb811bdb9e','36f3d479b87ee03d5fa202efc23a4e1fbe677a660edc6e45ebb6505111c76fcd');
INSERT INTO blocks VALUES(310151,'a0f31cc6e12ec86e65e999e806ab3bfa18f4f1084e4aeb4fbd699b4fe284b330',1419715100,NULL,NULL,'0494a526e59bccd6299f530876574a924f33ad4bd1e7169fbfc633555829b6af','c9f4472275cd33399e8b31df195362926c3c62a19dbf9274bc8da1121cbdc93d','7d8c430bd5775d2100476e7079b2f37eddc75a51427842d5063505a4f08a33ff');
INSERT INTO blocks VALUES(310152,'89c8cc3a0938c63a35e89d039aa84318a0fc4e13afac6beb849ac37140132c67',1419715200,NULL,NULL,'20909ec46becd553147f979410f84f0e5ab7f6561c3ea0a87874c32db2654169','652574d57bfc75eeb231c332f0c8e3a918dc212cb9239145964284d9fe916dd9','a11d3b967b027067c61abf6aeec157996ad6c84f85994343ee140cd2a813eab8');
INSERT INTO blocks VALUES(310153,'d1121dfa68f4a1de4f97c123d2d2a41a102971a44b34927a78cd539ad8dca482',1419715300,NULL,NULL,'5081e665111e5cbec7851c5f1be97fffbe647c9a4b3b1655f0e3ea4073ff4f0b','539231d7c9ca245da74708bc1684902ceb673b11bbf3978db58e7507d36d4fe9','6589edd77aa0fde66c9f3bd101a6231f74d474c53ebfb652168cb51d0c776847');
INSERT INTO blocks VALUES(310154,'ba982ea2e99d3bc5f574897c85485f89430ae38cf4ab49b7716ed466afa506d6',1419715400,NULL,NULL,'9646e7bfbf6c81b5e231521161bc5b90226dbd3f7c7ec7df7ec51bd5990e4888','acb54ba0dadd7121099421bbfc69a1860712b3bdf1c8811b710d8df6f62f45c2','2e984f66f98ab351bf7d04c8add608f325ffda4b1d2f2d332e65eedce16bde73');
INSERT INTO blocks VALUES(310155,'cefb3b87c7b75a0eb8f062a0cde8e1073774ae035d176e9769fc87071c12d137',1419715500,NULL,NULL,'f7ee5330d44aa09db4c01bd5d1ff635780d4835a0efd4e5d47a3a7a5a0d97278','8db0f4b70602c328223c3819f5f23d23d1c9d7a6b2f5d8210eda1c37f23c4ff9','75f9753b2f0cc660fa06ac47a1925b91cf6c11c669d7191c688ba903ecfce9c3');
INSERT INTO blocks VALUES(310156,'6e3811e65cb02434f9fde0445a7a2b03fe796041458737d0afcc52208f988a83',1419715600,NULL,NULL,'8bcd900346a6c49dd93afd12ce8baa0b0061a452bbfda8aa23be12b53749731b','716e11bebce8d8a77aa8394132eb8f5db7312fb5bdbce57bae637efbdddbe2b9','8bb315327ce05553988c82b5a0e907917d49430c1c6820544b98c8d35a6f6946');
INSERT INTO blocks VALUES(310157,'51dd192502fe797c55287b04c403cc63c087020a01c974a565dd4038db82f94a',1419715700,NULL,NULL,'f0f6bbab16c2f6582ff5ce70665ffc7c5298ea070484c92b7d28f576383edc3a','275f30c4c122f606d3901ad6b16a0ee54d28947f8e5a26f16dfdcb7e624dd4e8','021258ac6b21a6ff9af9648f2d6f3a9dea7032b972240a195eca57b11eab96e9');
INSERT INTO blocks VALUES(310158,'749395af0c3221b8652d31b4c4410c19b10404d941c7e78d765b865f853559d2',1419715800,NULL,NULL,'f463eea6635f38975c45c3fa7bad18686ead715462b000db9ac552671c4e3001','60e80da5df35583ce231708a079dfaa1381f4f77c0c6e1e08cc5c37697c63a4a','3d946fb7277598cb6620f1bc27a07019ebf8a7c853c4e98a6841120ca47f186a');
INSERT INTO blocks VALUES(310159,'fc0e9f7b6ae99080bc41625588cef73b59c8a9f7a21d7f9f1bf96192ba631c12',1419715900,NULL,NULL,'6df5b098887b67a07fc847376b77186e5f796bae979708e4cdce4e94c1c95ead','693757153ccd9dc161a8810bacd888e68c7d795020c3641a059c5d3bdb40fb98','0e83ab7d779a543d17ef4b5e0f392342e288970b36b33f0b0f69fe2f9bfe1af5');
INSERT INTO blocks VALUES(310160,'163a82beeba44b4cb83a31764047880455a94a03e859dc050da782ed89c5fa8b',1419716000,NULL,NULL,'2c81bd671588926061a3d8dea4cabada62322a99178427498acb4409353b9dd7','61185c4a10eb773391950d3be8d081908009ed0ebb89ce8ab8a697a31edb2c1a','5439d170d10ffc3f722ac975cee5c42fbe6e82dd484d255d3ca8a8da42fe0a86');
INSERT INTO blocks VALUES(310161,'609c983d412a23c693e666abdea3f672e256674bf9ee55df89b5d9777c9264d8',1419716100,NULL,NULL,'1438aa377d263abac1a88b56f3628af9f7eff1e44b7fec183322bca0dbe88869','1a3d44170252f606a9b1effa0605e5d960ce1ebd3b9fddc0a7078788cbc61584','5f30b2b8affdf13846bfd4a781b07194ba9c89cf81eac5479958b8c02f0105f4');
INSERT INTO blocks VALUES(310162,'043e9645e019f0b6a019d54c5fef5eebee8ce2da1273a21283c517da126fc804',1419716200,NULL,NULL,'8fcf2ed829bb5fca20155c28a6aed81f393942c6750f62fc604baa20cb1e9c66','003512f155854a8ec3c15af207b7c7fd551d0c5aa7961739275ba44cb9d75e95','5915ab072958840023a5e3a9129ea4ec82624c01d8cae305a22160cfa9305dbf');
INSERT INTO blocks VALUES(310163,'959e0a858a81922d2edf84d1fbb49d7c7e897a8f49f70bd5b066744b77836353',1419716300,NULL,NULL,'9688eeba6affe9f5eb7a214bbd16605baa47d935c5638bfe75df33aec67029c9','c56372dea6f21439fd296678d903b7061fff895f6d33ec1676fb46e54c7f55a2','c80b4e287468dbe243f5c1fa6fcc253be36427aa32eabb7bef1da564c865e2bc');
INSERT INTO blocks VALUES(310164,'781b7188be61c98d864d75954cf412b2a181364cc1046de45266ccc8cdb730e2',1419716400,NULL,NULL,'216ff7eac9f40995ef172698f93c36dd3d1d285a379d017eaac3d2c96d11dedf','967652c8bcaea2f80ffaef9f019e14ba45181da3942b05d75d39c39a1b025c53','9d8719a1c11f50694ad8f8985cf738a2070d0d42d299a1192dad7ab0c5176cae');
INSERT INTO blocks VALUES(310165,'a75081e4143fa95d4aa29618fea17fc3fabd85e84059cc45c96a73473fc32599',1419716500,NULL,NULL,'b84aa10f79c384f507b4d1967208696cd87eed0dc96cbb5ded10ac4fcdeb7f66','f4ee9b52a936ebfb960c2cddc0f2521decc7dc09e1319033b154bac71d6538b4','275624f7854a4d129ac4d3a2a6ad67891a18d605ca42ccc25205e28a27119ff9');
INSERT INTO blocks VALUES(310166,'a440d426adaa83fa9bb7e3d4a04b4fa06e896fc2813f5966941f1ad1f28cfb41',1419716600,NULL,NULL,'2e012bb699419b44fa8a99e2884c61dff0e8561cd8a084166548a423fcf1ea26','e02f7947333bca226a567759c1d9f57a4843b06f0e57b866751ac7cfb5f464df','1c088675d3a30169a0125b924b787c26ec7ef0d8d2bf1fda5ae01b29e0426173');
INSERT INTO blocks VALUES(310167,'ab4293dbea81fedacca1a0d5230fe85a230afc9490d895aa6963acc216125f66',1419716700,NULL,NULL,'dd943680a1c79319f824c9e90fbd7419970f36ed565de2310cf65d5ce84a179a','e4aaf726b41d803f4b1f408a13324c873c940a194d0369fc20e4a374b3e0b709','9dd48a77c6277225438a48f4f3523c36f4198093c3d060e9e9a0ce08309e5c9a');
INSERT INTO blocks VALUES(310168,'a12b36a88c2b0ed41f1419a29cc118fae4ecd2f70003de77848bf4a9b2b72dc9',1419716800,NULL,NULL,'486dd3d1cf947639f943f0d527029a238a68f77d395574034a0d605083611a5f','097acfe8db1cdbab8606aa734b608dfdde6dd43b141c7d2d1360b9373b1da67c','80f96dc4ed1a61a2943139a4fc021612e946fa7e4b82f50f06d59cdbda6663cf');
INSERT INTO blocks VALUES(310169,'204809a85ead8ba63f981fc1db8ae95afe92015f003eaebbec166021867421f3',1419716900,NULL,NULL,'dfe93f4192058ea8052132f42d4f71172aecd424d31594ce8f39b59ca0237d04','c096f2d81b5fb242bdeb33ec098fbc78591e6aa360f94f94fd884452e4d89ea2','8bfd0d20a2d5c9e4150067a2a0d657240dae79f78dd19de163f15c16e91339c6');
INSERT INTO blocks VALUES(310170,'b38b0345a20a367dfe854e455e5752f63ac2d9be8de33eab264a29e87f94d119',1419717000,NULL,NULL,'73a9f2788004ef32ba8097d688da13a3183fb32423b8cefece1d2a93c02ad891','c0f007f3b0f8e656ff87f48b20d7e380e857858700f422cbd5e00b8de318c96b','823142a4df58b3b4b277bde7931ff33a2427d5b908c25e6da4dac8e83bed5504');
INSERT INTO blocks VALUES(310171,'b8ba5ae8d97900ce37dd451e8c6d8b3a0e2664bb1c103bf697355bf3b1de2d2d',1419717100,NULL,NULL,'9302daa5b468ea6ee26b1b9cf5abb3ca6f97f7a9876f6a4dd130f37bf0f9d59f','50d60e028a3b932c272c82b591fe7425e35e1ca137b6492fc0011ad1e7c8fd4d','b158e09e9fcfe6144975825555b8b55358f5b735a08d4d2f579d15fd308462ff');
INSERT INTO blocks VALUES(310172,'b17fda199c609ab4cc2d85194dd53fa51ba960212f3964a9d2fe2cfe0bb57055',1419717200,NULL,NULL,'7e5bb71c1c39851a09ab50bdaffa3233cc514dc39ae3eff55fc5451a0badebbc','d57c5e2521a991b5f45a5188117f3b7fcbf2984d0360bc21eb4f1ffbc6429ff9','777edd9f87a384bfb597e6dc25bef901676fbef71ca3f7b28b5211308a58b77a');
INSERT INTO blocks VALUES(310173,'f2dcdc5ffc0aca2e71e6e0466391b388870229398a1f3c57dec646b806a65016',1419717300,NULL,NULL,'bd8e451d26796897e56e6d097600831649388a797b9f2f20d8185ced1eb12259','ab05a5981d5e838a96ceab7d5a8f131b76b7ef88ed820161b4570439f3522d5d','4d397ce827cfd42b4336da51f8c99a5650e1310f1b0ed2cd9fd93b761b9c63f3');
INSERT INTO blocks VALUES(310174,'fa6f46af9e3664353a473f6fffce56fa295e07985018bface8141b4bf7924679',1419717400,NULL,NULL,'1f47155cfd8c10d29bb0ca16df254a6070c142312dae3deac8e7b7ac35e12109','d01263ff53da71fffd2facb65625b4ad67e12bcd5abab28f4971a7fc7c0823e1','b7e670e1702ac5429dcc484ec9ec1db8a507afaeb60221fb6492959c0330520e');
INSERT INTO blocks VALUES(310175,'f71e79fe5f03c3bc7f1360febc5d8f79fc2768ce0ff1872cf27a829b49017333',1419717500,NULL,NULL,'449908c05ba0c6d220772f0658047322ce732fc2707daafd9ec55ede3cf66e74','f212e5996a8abdc009416cd5f6b441c4dc30cdaa84d718a5d070afb5a58998ee','a3aaa1550587fa109126868b38fe915a411e9a9401e3e6564e11bef8d3fa86f3');
INSERT INTO blocks VALUES(310176,'67cd1d81f2998f615602346065e37f9ceb8916abb74b5762ead317d5e26453c6',1419717600,NULL,NULL,'67bb2b6ee64758b55311a6e959b4491cc8e30b477af1b7f8cea3cfff480ad9be','61762412ebeb89d758d1ad93fb3c3ca33ad766dc45841eeda6f866be01f90176','9ad2b3358a1674080a126885fe453a79dc7424bda536e635a84c088e9e3c3db9');
INSERT INTO blocks VALUES(310177,'6856b1971121b91c907aaf7aed286648a6074f0bd1f66bd55da2b03116192a52',1419717700,NULL,NULL,'f539a07844bf4f6fb6f6199cf7607d70ca12357f982d53969774a8ed9781b0c9','e76ab94487162c81d43f82a33f2de3b59aee90025a62aa73af6b7324f2709e6f','196acc9467e867d06eed26337f2a5bfa93778ff428f20bdf6497dac5f4c9cd97');
INSERT INTO blocks VALUES(310178,'8094fdc6e549c4fab18c62e4a9be5583990c4167721a7e72f46eaf1e4e04d816',1419717800,NULL,NULL,'965dcdebd99307eeb59cd9e7f51e1a6d34835824897646a1bc1a957d66541407','50f5128d4b267cd13315aa3a893c9738020905de29692d24b56de5496c320d71','abb370e1b5f1920aef3aac19d726afbe48a433127c5344324cb972ef5097ec98');
INSERT INTO blocks VALUES(310179,'d1528027cd25a1530cdc32c4eaff3751a851c947ddc748d99a7d3026a5e581a7',1419717900,NULL,NULL,'1377fccd032d0e087cd3f57e193db56757b00463dc0bf6a006c2c6d1ab69c0ce','8bbe3f3a3f56d7d95fd98ab2d30b7fa5c294f69ac78a973d643429ece8d1ad48','4f3685e1184088a356a485a7725ee7012f771bc1cacf8e5bc28e621f7c1f7716');
INSERT INTO blocks VALUES(310180,'f2f401a5e3141a8387aaf9799e8fef92eb0fc68370dae1e27622893406d685c1',1419718000,NULL,NULL,'5540567649c2b43c72a22ac93cdaf989cf69347415595eb82965d175b2b630c7','26fbec110a8481e17b9b413971b956568af9b2467d7b75c0840f976f30bb0513','e24a8a7f73d3baebcb05cfc2c124933b1e5e8962452957dc648ec1d76e5295bd');
INSERT INTO blocks VALUES(310181,'bd59318cdba0e511487d1e4e093b146b0f362c875d35ab5251592b3d9fed7145',1419718100,NULL,NULL,'be680f89277a7270d274700af58d980672539bebe8147c4a89894e76c3697520','a4f26db0fd82da1eb2b415c92661be5cfd708c8287abd93e1857aa86f28450ec','690431c5a98a0c18b05d1231dab8e9c64ca18a7b790975c6cf86e61bb8704839');
INSERT INTO blocks VALUES(310182,'a7e66b4671a11af2743889a10b19d4af09ec873e2b8eb36949d710d22e1d768f',1419718200,NULL,NULL,'d37b39c0301d29bba738275a1d5ee079718d459a9ac5aa45b7aaefd057ae43b8','aeb623222415941f3bccb738f1255cc37cb77c7bd5e1fddc8d3062f073439c11','306f26c711cab397ea53aa423e49a5a3f7f062ac22f5c1b91df6cc7e3934a955');
INSERT INTO blocks VALUES(310183,'85318afb50dc77cf9edfef4d6192f7203415e93be43f19b15ca53e170b0477bb',1419718300,NULL,NULL,'d06ac4a74d2c048b8db9d9e38ca876c9a8d2dee6cbccf6036edbbaf9228adc01','e35c2e845584e64bc5f63784890555f69740923bf94883ec80609662c847b432','f73c78a7dbba0d42cbeb21709db5150e8556731e9bb8e4f02f3a71e170a2f5d0');
INSERT INTO blocks VALUES(310184,'042a898e29c2ebf0fdbb4156d29d9ba1a5935e7ed707928cb21824c76dd53bfc',1419718400,NULL,NULL,'a02554a263bc0786e3d4b3f0dee5cba01f2e6fa5166a948171aea8d864afb1b3','41287a2301b1311c7e3da53a4081fa6ae4e654398bdcd95335170129079db8d9','9cdfc7525383ecd498b5fceece104019b847f7a223161f5e5c851bd6190f9a5d');
INSERT INTO blocks VALUES(310185,'bd78c092ae353c78798482830c007aac1be07e9bc8e52855f620a3d48f46811f',1419718500,NULL,NULL,'48bc91e89924b284af03c315ce62e5da5e676ff42b65f876912cd66e8f4916a4','6bf53020e6dd4e65dc3b6ff4ba78831e1463fb31b8084b88e8e10549793b31ee','dbc73f674f8f408e84e29bca5f92d5f641499a6a6bc4c0a287730bc55d00f4db');
INSERT INTO blocks VALUES(310186,'e30a3a92cc2e5ad0133e5cee1f789a1a28bea620974f9ab8fa663da53e5bf707',1419718600,NULL,NULL,'9a8fac19a644e37673412234cfd52740f2e2cbb454f92e3aacad7744bd6f9bd2','eee999e3eb86c004113fe5aa73be685a06130e5405f1c93027ff1414e42f66ec','28311b168784813ef2d185ec1e3415ca1eba785fd4fc3803bccabea31add3159');
INSERT INTO blocks VALUES(310187,'fc6402c86b66b6e953d23ed33d149faa0988fa90aa9f7434e2863e33da2f3414',1419718700,NULL,NULL,'aa2d615cd9352549269123a8e272aabaa47419930b775e823ee4ed76efbbc2fd','2562e1e0eb58079cf32ac1de6ecc2b0b132038996a72e2c2a7e649b849e612fb','52caedcf814f51bfcaa8a38ec640c97ceff19bf6b1749ed0e0805ded0f04a72f');
INSERT INTO blocks VALUES(310188,'85694a80e534a53d921b5d2c6b789b747aa73bf5556b91eeed2df148e2ada917',1419718800,NULL,NULL,'1b591c6d68b0b8d7f6afe22af9f36fc42463e2a692d6ffb73ddc53950fc619ff','9e6eae49a456024f30b7b85f21b223920e68383ff23f20a3e78b9ddb92af2c6f','bb2b69a736126933661dea533ea7a60bc2ef4bfd605cb1643ec470da4855c298');
INSERT INTO blocks VALUES(310189,'7c036dadf19348348edbe0abe84861f03370415ed2fec991b9374dbb0ca19a06',1419718900,NULL,NULL,'92fbe026cfec379949cdb6150ef14de7372fee2f2e5b95c5b255903b8a45bb79','b828443c4f2d65e731a00022b32e52808d751d1357ae5a69b6c185aecedd7732','bc75f24dd588b540bba7af14d85789f356bfa70837bf259546ed88d0b02ff4e6');
INSERT INTO blocks VALUES(310190,'d6ef65299fb9dfc165284015ff2b23804ffef0b5c8baf6e5fa631211a2edbd8d',1419719000,NULL,NULL,'bed59a51ddb0403b39fef39f39e1aed9c33943bb0230508cd1bc00ad73280e52','cd8b5287a36b1f7d740e783b62afe4b07a0fd0659a54c2fd3f5f067d75673522','1ede6091d5d9c625815f01adb629e5d4180bdf0778c70222d87c54204d5ef88a');
INSERT INTO blocks VALUES(310191,'5987ffecb8d4a70887a7ce2b7acb9a326f176cca3ccf270f6040219590329139',1419719100,NULL,NULL,'a7916a504e07f7533009025bce1f551a386c1a190a555693a2b53f4830720ff5','391a5b5ef8b3afb5ef899ea0e95e79e6f80148edbe0557a49bdccb8a9d9fc7b0','d9b7423c187cc212fa47e5edacd554175ecadc9c5195f1688e3133f104864548');
INSERT INTO blocks VALUES(310192,'31b7be43784f8cc2ce7bc982d29a48ff93ef95ba18f82380881c901c50cd0caa',1419719200,NULL,NULL,'9ef868fe910c9d56e1e5ddd7a2027a51dd57c47f041f44f9db3d5813a27fb234','17a09b64b9e475ddfcafa83a691f5a46983d6ab30f427163d20b5b04d587d1e4','95a08f163e34e2ebcb70bd48206ce8aa8b843c44455369705e9fb72df1b29fe5');
INSERT INTO blocks VALUES(310193,'ff3bb9c107f3a6e138440dee2d60c65e342dfbf216e1872c7cdb45f2a4d8852a',1419719300,NULL,NULL,'aaccaa131b6dd032da94afccb68ad041e2eba70eca87041a5cd5f10044762f71','73861eb58dc328fef0d402cd383c433055d3b85cfdfd4f60a6b2331a8b5b1e4d','1a1cb2aec5fde0d22fd9568ac615c3a90381e842f79fd031ee9e1b5bb9953973');
INSERT INTO blocks VALUES(310194,'d1d8f8c242a06005f59d3c4f85983f1fa5d5edcc65eb48e7b75ed7165558434a',1419719400,NULL,NULL,'df3fd105bddb53af3e6378b8ca2d943ba62819de2e5300736cb0cd313e64b59b','660d9309c57323d628e6ebaca2162d56e7d51b535d338899e7928a6f1dd17bac','f8345424b589b3f4cc97b3a704e95f6ef78ad28cb5a3ace4d7de47f0bbd15e2a');
INSERT INTO blocks VALUES(310195,'0b2f1f57c9a7546faac835cbe43243473fa6533b6e4d8bf8d13b8e3c710faf53',1419719500,NULL,NULL,'67761a429e56d64bb070a24e1479beddaefa8d568463d50cd9bb17666642d375','7b73be42ba8d1a51aba30359153b85a7c0ea16ad9778ec04fc358c7229ecb48b','735eddb0661c38e7d2d08024cd1994cf73d4cd4ceeb8418fee18309289b2e3c5');
INSERT INTO blocks VALUES(310196,'280e7f4c9d1457e116b27f6fc2b806d3787002fe285826e468e07f4a0e3bd2e6',1419719600,NULL,NULL,'80be8d3ca9813a635bc82e6fae8ca6f5115ad3d39cc1e7644f309cf79a0117a1','e361b29accc881782a6dd1037c11a270d615f26d04dbccfb86a8df16bd630cee','2b76b2364118fc4a278fbf70e0909156950261c08f293e971876f9d5e28bcb9c');
INSERT INTO blocks VALUES(310197,'68de4c7fd020395a407ef59ea267412bbd2f19b0a654f09c0dafbc7c9ada4467',1419719700,NULL,NULL,'e19a08e4c10e456fb97e19f0c68b70b7f3deac1b013ddff543cba6376a6c235f','591e7e8f6a9588b2150d1258021911b209abb2b273984458b43a527a52c0578c','ac91836e5fa2e2e67e2ef125e1408c4e9dc74323312ce24f41f17c7b1d01c62c');
INSERT INTO blocks VALUES(310198,'30340d4b655879e82543773117d72017a546630ceac29f591d514f37dd5b1cc2',1419719800,NULL,NULL,'ca7a06c7cab8f02059249dff3df5a89bc799a3887323515da1d8984d9dd76309','37ca591ccbb422465435e2af28c7c1d14877cab57beeb7d8e214338365506850','e37b65630eed78f279e8bfb938a2e23731ebf14f9b24b1156eeb34d7475b79ab');
INSERT INTO blocks VALUES(310199,'494ebe4ce57d53dc0f51e1281f7e335c7315a6a064e982c3852b7179052a4613',1419719900,NULL,NULL,'6a49e9c3e95c70b2d994a596637702f891ee5e611cdc010483321b52b2b2ca26','752ef478d6ff0febbcef4a4c19568ca385570e305c62d577a39bce77f0aee677','8bfcf0be540deedbe6748e54ffaba76d07b007c374883211e05d956ce5e48458');
INSERT INTO blocks VALUES(310200,'d5169d7b23c44e02a5322e91039ccc7959b558608cf164328cd63dbaf9c81a03',1419720000,NULL,NULL,'d7d55477da8776e217925b9a756c70391b8cb6f9c42a7920488a331eba72ef12','660d5ecbea7eb6395fc5b8047912fbeaef9a1462cd81f380d52412c64b99fcc4','b2c1517966ec926e41cbd7d0e45e270edd18eab8279050d7f46b7762670daacf');
INSERT INTO blocks VALUES(310201,'8842bf23ded504bb28765128c0097e1de47d135f01c5cf47680b3bcf5720ad95',1419720100,NULL,NULL,'f7d18e3b78aa6033e3850872f44deaf5ca69ff3b2c3ecfa4d7b8481f14c26a95','f8d2fc1116891bbb4a90c48e157ae3b59d8b5c8b8434a03543c9bc8f1a0861ab','fb57ae22ad9ef460b800d6d45d800048441ce160118bc1706c26daad1dc0d812');
INSERT INTO blocks VALUES(310202,'95fa18eecbc0905377a70b3ccd48636528d5131ccfa0126ed4639bc60d0003d8',1419720200,NULL,NULL,'05b3b6e2815ad2e8a9762a44668cf66ca17060ebf9ba25576d1a8764ce104117','9cc71bc89cc3b9735b77c62c0afbcf1fdc7c92cfcf65b3bc9796f0fd7d1348e2','d9446df2b68b51ab9282a095f45d2c1f89d750a85e19452e69800b6e49e30b5d');
INSERT INTO blocks VALUES(310203,'ab15c43e5ac0b9d4bd7da5a14b8030b55b83d5d1855d9174364adbebf42432f8',1419720300,NULL,NULL,'92c4689695a115f8c4d11018737e97d272216e2042ea5dd7335c06e31068f23f','e83ed34cc03dc9cebe162b57dd98dff4cc3e4caf555601e5cda770d351f48731','f6bb2df50131e9deed1106cd6895bcd6689f4e28c5954389cb710888054540b0');
INSERT INTO blocks VALUES(310204,'18996fb47d68e7f4ae140dc1eb80df3e5aba513a344a949fd7c3b4f7cd4d64cb',1419720400,NULL,NULL,'8107d961f9e1fcbd2d4c7bd60003b6855117351fe3ba1968f7a4187c400760e7','afb4504dceffa348f1b365484550ef6a31fa3c801fdef8e94eae73310d581fa8','3a60dc4960003de245c50c6fa434004f504914155b2d88ad8aacdf784365f846');
INSERT INTO blocks VALUES(310205,'5363526ff34a35e018d1a18544ad865352a9abf4c801c50aa55742e71630c13a',1419720500,NULL,NULL,'d66981ab191c560bc60a3f40247dca28a1f48462d0bc49e3b368ca6b5a6d6ade','7f0ca44184412359b1e647dc09d1b6892bcc8afb27bed31502c6f656e33ee345','783da23226505a7018b65e751fedb808b1f5749e43b262488f62a7969db5e373');
INSERT INTO blocks VALUES(310206,'0615d9fca5bdf694dca2b255fb9e9256f316aa6b8a9fc700aa63e769189b0518',1419720600,NULL,NULL,'a0ce96348648ae444a7f676b77c4d9d6fd669bae461356e2f327dfaa086b5a22','9f2fce5cd62bce977e447d537e0c5265808d00d836824f0394467fb6b3ff65a3','e1fc20e1f9114210efe2a39d0b1cc50d0e7eaa1e122bcf4a2a1d5fbfc30c0477');
INSERT INTO blocks VALUES(310207,'533b4ece95c58d080f958b3982cbd4d964e95f789d0beffe4dd3c67c50f62585',1419720700,NULL,NULL,'8fefe0dad11d7d9064b466a8a32ef1615594243719c69be13be695581216e01d','77c993671303ae92d974cd373e165583fe46f681576fddeeac041ba8be9da1b6','39481b78d795afd7ceb25a3f59553e442cbe279f738292058f05faa031ba2105');
INSERT INTO blocks VALUES(310208,'26c1535b00852aec245bac47ad0167b3fa76f6e661fc96534b1c5e7fdc752f44',1419720800,NULL,NULL,'8c618f1d3c6125c0949b362a38f464b8a7e821ee08c1e88ce5e9b6627af6d5b7','73713d4d626f4cdba78f3670d864e20292230aaf5e01bd8dda4b25af195ecec3','01d5e49e8c5b306b5ad00afdd0ff19f17b6398281313116d51a28a7880c370f0');
INSERT INTO blocks VALUES(310209,'23827b94762c64225d218fa3070a3ea1efce392e3a47a1663d894b8ff8a429bf',1419720900,NULL,NULL,'27ba4fc848d19996f8d7c00dd3f0c557516314a8e4d06ce12185091143caea44','eb268c018128a76ec90a455f444a332261e3ec653806ffb19ead6220a747decb','cb3c09448e1ea8b1993c7dc808ee2a92834ff723a9ef587b420c4fa79de65b79');
INSERT INTO blocks VALUES(310210,'70b24078df58ecc8f7370b73229d39e52bbadcf539814deccb98948ebd86ccc0',1419721000,NULL,NULL,'5c6428a310984c26dfc10dc9f0172498f1d8b62d62e36f4a1f3955581846b4b8','e75b47765a5af53dd7f374def9cc2f7ec10574e9a0ad60ccc6f85420fd4984bd','3755d796f70a70dbaf5b06945519f34c8151ca88c57f0692528bb3bd7cbfa8df');
INSERT INTO blocks VALUES(310211,'4acb44225e022e23c7fdea483db5b1f2e04069431a29c682604fe97d270c926d',1419721100,NULL,NULL,'52d4f42f1fc5175c82cf3e1caa33bd4032502e4fc4193f3b14b1e4c992274728','3f13de3bf9440a959442033612d54dea218341fc32575d9e6352f353b9b8f959','45fd84e224cfd804927b239b1d88b68f12fe67b250459abc7fcf09a952a707ae');
INSERT INTO blocks VALUES(310212,'6ef5229ec6ea926e99bf4467b0ed49d444eedb652cc792d2b8968b1e9f3b0547',1419721200,NULL,NULL,'626ae9e1df3a77c6179bddcfb39e421498d24af094ce4eba6cfbfbeefeb0db7e','ab07bcc7cfb238632a0cb9b702bcc40daa9802e21ffab523b63b57676325effd','33b7bd7c4d9e2a8bd03dc70bcf41bcc8efb1956144d26be895712a32d0fbe329');
INSERT INTO blocks VALUES(310213,'17673a8aeff01a8cdc80528df2bd87cdd4a748fcb36d44f3a6d221a6cbddcbe7',1419721300,NULL,NULL,'6ce1113ee021b3fe32c097c1eee0c38c8e08d0a240ce159d24f0e47ff5ae035e','761cfcff19441d8a262eb2491b963a0dcba346c4601440486ecbe6400602dbc9','35bf6ec7688fb47fdbcbc68506c42a161d6ede82882ea9dd3dfb696d25573b4b');
INSERT INTO blocks VALUES(310214,'4393b639990f6f7cd47b56da62c3470dcbb31ef37094b76f53829fc12d313454',1419721400,NULL,NULL,'27d0af0d0e954a945cb439ac095da2ea46f85528fd56aa1c6f94b82e12feaa51','a0d621bcd7f9ee22e2c682ed07b83b939061285c2e37c187bff15317c9dd90b7','46050b15b1667fb7128ee45ff31f7bbd7e26727f217bdbeb1abf1c839b7b4dc4');
INSERT INTO blocks VALUES(310215,'c26253deaf7e8df5d62b158ea4290fc9e92a4a689dadc36915650679743a74c7',1419721500,NULL,NULL,'85c36eea8d51a7038f84241194a40e108e40b52b2ebd3da340fd0360268a2d8e','271935142e90308ea60df957e1c4c215e4608b23138879cdcb8426f9c784b267','fae71bad4eabcec1a0384d471d8ecd0134b37123017b40b78fe2316a57c52b5a');
INSERT INTO blocks VALUES(310216,'6b77673d16911635a36fe55575d26d58cda818916ef008415fa58076eb15b524',1419721600,NULL,NULL,'90da837fbd815eca85e464fcf84b727bf6de7bd7f867b8d8d86e0243fa9fb6e9','4d743e5ccf5dcb48c07b403e9ae9d281044daccf2a4d0f8da6f7b6f9263f6311','abcf6438c09721345f134bfe452ffba78b01bee99ce43e8ba7d69365d0694ba4');
INSERT INTO blocks VALUES(310217,'0e09244f49225d1115a2a0382365b5728adbf04f997067ea17df89e84f9c13a8',1419721700,NULL,NULL,'b6d8b82b7114c54270f94aa3e6b30afe1a13ebfd723e112b15ac92e9ca0ba5d1','036231a8be1bd9e6a0cd2f2fccaabab2dd194fd57a98ed83076d69cc2b27ca8e','8d8b3b951b8b6de2d44f6e9ae3dc74ffe560db70438371f397163bdfa7d5c6af');
INSERT INTO blocks VALUES(310218,'3eb26381d8c93399926bb83c146847bfe0b69024220cb145fe6601f6dda957d9',1419721800,NULL,NULL,'7bfdd1cc7198b584e2f8bfd0c3ba59c6b3a730aa300e1886d4448519d39d545e','edf4d0f0fdf81a36567cf0f76f8cf3fde30941f1368e9b552a931403be17b5d1','7c4fb46dee765f8b2ff784fc448a56f71423186e3b0b386234889af2e68d8ff2');
INSERT INTO blocks VALUES(310219,'60da40e38967aadf08696641d44ee5372586b884929974e1cbd5c347dc5befbf',1419721900,NULL,NULL,'9fff284f1fc877cd0901485c40947a74bd1397e05efa9622ea93377d69f3a046','4991dbe0dec50095cc7a6116cc6283474075fe77e2e2db3021d24034984f4d7b','43ac121a091f1763c66a96feb336262e0adb62bd8b2338f4f6087814363a50cb');
INSERT INTO blocks VALUES(310220,'d78c428ac4d622ab4b4554aa87aeee013d58f428422b35b0ba0f736d491392ef',1419722000,NULL,NULL,'355c9167bd912133070ab919ec58ff8c2370fd9ae5d7ad72ecbd15a4faef9a7d','bb39db1a5dba9da2a105ede1e25a9bffc142271b6fd0929204c378e22547b0ea','c0c258c934236f6a26f35f5ba38b9a5e9186e81fae90a78e8228e866aed5ede0');
INSERT INTO blocks VALUES(310221,'cf5263e382afd268e6059b28dc5862285632efe8d36ba218930765e633d48f2d',1419722100,NULL,NULL,'814518f2f259f36a7793686c46a76b97c055919b701bad5938ed20273d2ca46c','058e3ad97af5a8a53a5b86052f1514dd10a2fa6b552f139800f5d424480a3356','cc3b5579c55839ffb6f0600daead7dc86aa77246cce056fac10f5cee6cc6e1b1');
INSERT INTO blocks VALUES(310222,'1519f6ec801bf490282065f5299d631be6553af4b0883df344e7f7e5f49c4993',1419722200,NULL,NULL,'8a568cc2fcd5d40523e8af309452e2042ad47c003dfc02cb3912f82cd75b3663','4cbae9efad025d0519635a1c82d3e2b715484428c7ae2e18d5ff554f220ff459','f1e878e92287ce8c79ce4cd8f827683899317f38d3b8c1140476d902b0260505');
INSERT INTO blocks VALUES(310223,'af208e2029fa49c19aa4770e582e32e0802d0baac463b00393a7a668fa2ea047',1419722300,NULL,NULL,'95c0dedcbd3c68323d474883cd7ed23d445c2465123e73078e17b9a439ff2a94','2992ef63d3294e6677bba07747b3777953c780d63748657e1a4a3fdf5b407143','2532e868e346862dcc59bf26c572f872d8c7736616a8ca9b02aa7b6ac5c75e28');
INSERT INTO blocks VALUES(310224,'5b57815583a5333b14beb50b4a35aeb108375492ee452feeeeb7c4a96cfd6e4c',1419722400,NULL,NULL,'6ba6dedb7250ad4179453e0743040d34a6b3211df0c9a7ce9dc345ac1b1ea2e5','2011a3d40c51d85911433c369d3c137c6e8a8b1a7d8f666b1f49cfb228e93679','54523ee376b6f240cf201e217acf00bd8b951dae0ec7d93935ce9e43092158a7');
INSERT INTO blocks VALUES(310225,'0c2992fc10b2ce8d6d08e018397d366c94231d3a05953e79f2db00605c82e41c',1419722500,NULL,NULL,'61452699f9725a2b0b1c1a445ce45758d7f8964291f0103909bcb5cd1262a21a','b899921b56132bed043f577676a286f4521fce0c6654809836ad42af7a6a7b02','a780527d1f941c29d136c3249662143943f49a529856ae8ac1410b7a7784a796');
INSERT INTO blocks VALUES(310226,'b3f6cd212aee8c17ae964536852e7a53c69433bef01e212425a5e99ec0b7e1cb',1419722600,NULL,NULL,'4c7f41d277cb3ce8bad7f09686a84d1252c1a53c2188ffd8ba2890b4e8f63f5d','4deb7536d549529779fdba8a01898959088fc7f7fc518d01f7e1b9aa2b554877','bc97b8f6935c949c407ad2f3efb14ff184217c9efec2cfeff320b1393bcfb121');
INSERT INTO blocks VALUES(310227,'ea8386e130dd4e84669dc8b2ef5f4818e2f5f35403f2dc1696dba072af2bc552',1419722700,NULL,NULL,'9d0df65e7297d00091fcdaa4f754e8b33d8ebb11dc58c3e6e621feabe846f1a5','d1fb2712a0ba65312fb489c32026091168700aeab9f50854b9682fb77c32acbb','b54422cb45d28f1f797f86fdb7e3bff7f019cf3c6a7031a2ea86895a86ed17ce');
INSERT INTO blocks VALUES(310228,'8ab465399d5feb5b7933f3e55539a2f53495277dd0780b7bf15f9338560efc7b',1419722800,NULL,NULL,'726b8e6305f360cad7f6914346fa13a9eed983bb2e485832af2a20bd61e2b04d','ffb35f070d61cf543d2a759c56e1d16c8dc7c0579250d0c710583a7ac3949a95','eb119ee170db730debe39e2419792de5eb4f794e8b25db9b5475b8f1e2c57920');
INSERT INTO blocks VALUES(310229,'d0ccca58f131c8a12ef375dc70951c3aa79c638b4c4d371c7f720c9c784f3297',1419722900,NULL,NULL,'d81e4ffa6cb126939dcfd703e426fd4e361d40bbaa99d59875e5f4bcf7c4cb0c','9bf859adbb18982a6f49e590be07a36eff20d09832ac7af8e95df1035b0aa697','c9f9520618df85f79ac9b04a94a2d76887820930d1856c35d2769b640c0a7e6f');
INSERT INTO blocks VALUES(310230,'f126b9318ad8e2d5812d3703ce083a43e179775615b03bd379dae5db46362f35',1419723000,NULL,NULL,'cfb2ecb0322a9e20fd07f868044a5f8bca7e9b42b36e3510f2f4e895953caf1a','386a911be20c171560ebab1ba54395c0c6445f85afacb7e2fe7566c89e24b113','3b5dfe198cccb50a8ecb6df2c33593fcd72cd9791aaa516bc29a4f8d7ee5b4a6');
INSERT INTO blocks VALUES(310231,'8667a5b933b6a43dab53858e76e4b9f24c3ac83d3f10b97bb20fde902abd4ceb',1419723100,NULL,NULL,'66a66d343c2995a0fe0d364c0570d5137f6fa8a7ca8de32c0f81f967c4681d04','e52a58aa742aad9b130008e5e375f803c9f9864b8b7be6c5996edd05c3640f99','81cc6088c3b1d295d72167302b4eff0998daae263b8077b86b14afe78f6a4b08');
INSERT INTO blocks VALUES(310232,'813813cec50fd01b6d28277785f9e0ae81f3f0ca4cdee9c4a4415d3719c294e8',1419723200,NULL,NULL,'6724b045039e7711c549852370b5781807c397be301e7d725579538227a99caf','f686d815afddc5821ed18db0c7441dad925cdcd8583d66d54c1b5a7e8ec5d3f9','b25bda8ccb93fb73559bc90db16539a9c6a43ac34af25dcf3ac2422c5e80e240');
INSERT INTO blocks VALUES(310233,'79a443f726c2a7464817deb2c737a264c10488cac02c001fd1a4d1a76de411d6',1419723300,NULL,NULL,'16bafa9fe4b72726804211e321b93fd328d0f1d06c6457a37ed5dbf9130858ad','d7ce2d676f03a0f342cf35a66fc9eda5f19f25a1b56c8d1c91499374cbdea662','703e8950e4ffc13e79983c6ca462418cd4f6046aa86b93d0fe037758c6d1158e');
INSERT INTO blocks VALUES(310234,'662e70a85ddc71d3feae92864315e63c2e1be0db715bb5d8432c21a0c14a63cd',1419723400,NULL,NULL,'6c45438a5a8c3470d24797cda397ca94a14447a96054dddb7550d2e8143d167b','1c5a08e1e2e9434af9a3c862a5f9e129df526fb15a0db8c4fb55259ba16304d0','68283102e90ddbb98ae1a4157069c4be3d26e1caef5a1ae89b059d1f4ed239a8');
INSERT INTO blocks VALUES(310235,'66915fa9ef2878c38eaf21c50df95d87669f63b40da7bdf30e3c72c6b1fba38e',1419723500,NULL,NULL,'0ce0eb3a75f5ecd0aa90c60dd11a6ba1aa70b6e915b5867fb21b8833d14c2b91','709478ae1daa2c8d06437d25c4629bc6b104966f54aaa89c7faf8c6ee70d370f','9a4e203822f6c8b8a1a6d8ae673a00da929945976bc911a4ace6984c85256993');
INSERT INTO blocks VALUES(310236,'d47fadd733c145ad1a3f4b00e03016697ad6e83b15bd6a781589a3a574de23e4',1419723600,NULL,NULL,'fb71e2ace83080f3810af9064dd17bb80f40879f3e068b5f70adeca09cbdcf65','a7005a5aa24de497ea8082ab68898e4b2e9cf1d6e5a27b8a433bd57621880a41','1f946bb1924afab78e84a558d26bc8b6030e63ec029c77a97577aba72b4b8854');
INSERT INTO blocks VALUES(310237,'2561400b16b93cfbb1eaba0f10dfaa1b06d70d9a4d560639d1bcc7759e012095',1419723700,NULL,NULL,'7c6a7b80fb85ad632d1bcdf961de0f0caeeb1ed554d74d2fae98000a70c55125','74fd13095dfb9f01f03b86830e2306c7761cea95b8f2ae9ca21d83616c33a3eb','0d85d3111046af10c75fc0d231b62700fb20c12e3231465b4057971d7efc8b7f');
INSERT INTO blocks VALUES(310238,'43420903497d2735dc3077f4d4a2227c29e6fc2fa1c8fd5d55e7ba88782d3d55',1419723800,NULL,NULL,'e6871aca1a08527f9668f5b34e43f96d7fe3a0222fc1366c75034d9cb82a40d0','16477d08dda3bb054272d6c6c57d80525d2f29eda9dfab08b23d5322c2c5948d','b942006228381fead7a60e28c13955ff9d5118f6074449ebc9bb2ebdf99a09c8');
INSERT INTO blocks VALUES(310239,'065efefe89eadd92ef1d12b092fd891690da79eec79f96b969fbaa9166cd6ef1',1419723900,NULL,NULL,'79783403c245e2ea857da2f0dec47a308920ae7f694c8120a3ab1bee2d8d4f98','bc7d99aac75131042f2ae9a2e4a33645441555bbb88bde46f70c56c6b675a1f8','a82ca343ec6bc5dffb2c0fd741c527fb6b48d0a94828076eb4635870484d0d5f');
INSERT INTO blocks VALUES(310240,'50aac88bb1fa76530134b6826a6cc0d056b0f4c784f86744aae3cfc487eeeb26',1419724000,NULL,NULL,'64867ceddb374007913a54d4678c79f66c9e1dfd7cac07486d689922d08db6ed','c45c9c7a866b221b10b27ac7b41a79470c05869bdfd540314879d557c49d8be2','5cec513b25942759262fb7834690549140bf7695595f8c82332de721892aed93');
INSERT INTO blocks VALUES(310241,'792d50a3f8c22ddafe63fa3ba9a0a39dd0e358ba4e2ebcd853ca12941e85bee4',1419724100,NULL,NULL,'f9bece739c922bae1e013faa02cf61e1cdca93db1e1ef2887008e4c12e931528','339eed807da3655057087ad5bc20f2eb819f3cb36614951d1eeed59a2a3bbc38','57079b17cd7ab615c5cf5bbc56998068de91e285dbc04bacd604d6759d1dde5b');
INSERT INTO blocks VALUES(310242,'85dda4f2d80069b72728c9e6af187e79f486254666604137533cbfe216c5ea93',1419724200,NULL,NULL,'1b8e6d896ee387c9766cc575fe962a773c4dc872750dec50c5dcd714473af0ca','2e9169872af9796958eebfc94c323601106a54134e6d2d56c1110fc106bbc68d','4b8b67070bb3e1347b2ad5b36f93eddfa43995d6cfadc6908a4a93c14969efd5');
INSERT INTO blocks VALUES(310243,'a1f51c9370b0c1171b5be282b5b4892000d8e932d5d41963e28e5d55436ba1bd',1419724300,NULL,NULL,'85db2435bea08b47e389bc864a9043124c6382db0d3ecf353de7fee90af62d39','4a793bd383723c7b93919344865493d83eee1ca92cdb6028b0d353377d9d64cc','923acf1768915928832aa3aa19f5689c4a89d98bca5716b5bee9b0b3f2cf7902');
INSERT INTO blocks VALUES(310244,'46e98809a8af5158ede4dfaa5949f5be35578712d59a9f4f1de995a6342c58df',1419724400,NULL,NULL,'9576d7a73b5cac52c2a30f1e2c9f133c46cb74ddfda4265c01e7774d8e3e5723','88a8915cbe0dfb36e20fd57a40d36086c08651ad199753cf27eb6d55317e9662','6d2f482ebcb5cb55b85f5dc72618fee245b80fb02269d99408dd2f46309a76fd');
INSERT INTO blocks VALUES(310245,'59f634832088aced78462dd164efd7081148062a63fd5b669af422f4fb55b7ae',1419724500,NULL,NULL,'494210fc9a20ad97c6e2b217de0203f75cf3efadcf0e8bf5e05613c59935fbb7','aae19d25d7321b0f21e07c32d2034c66600d3fbf71b219f66aa570aa9d4ed8c3','37c54c1c18edab7808b1f5f0dc17211e6f5e1a8014f0999b1f82acb504c59b44');
INSERT INTO blocks VALUES(310246,'6f3d690448b1bd04aaf01cd2a8e7016d0618a61088f2b226b442360d02b2e4cd',1419724600,NULL,NULL,'c55049278804ea55aa352e7eb8f5a058da5337098858146e4c813c06335f0624','bed76cfb4949b0e202574c37060f67c154e2bbca01d260e848ba6b228db3580e','0ffc84bf8af100e2603b855fb1d5c95afdf1e081d45ccfe05041745b8ce64190');
INSERT INTO blocks VALUES(310247,'fce808e867645071dc8c198bc9a3757536948b972292f743b1e14d2d8283ed66',1419724700,NULL,NULL,'cadba7e6f4271b6167581a383725d378974708f8a4ceec51680de8599c3de9d3','94d5db3ac15ad583112979b389ff66401c37ff59a6f772df59dc6eefa7f397f9','6ad83b4366222d6555183e60eb075df5d3e4a33fd6db60ed66cae2f9709d4d01');
INSERT INTO blocks VALUES(310248,'26c05bbcfef8bcd00d0967e804903d340c337b9d9f3a3e3e5a9773363c3e9275',1419724800,NULL,NULL,'adafc0f88bc4be7486c327fcc8677869104cd9ff30c44bd76d021f2600c7d9cc','03713288b270e7b738522851ed463ce045f88f902df9f6479f8ac5c2a55f8280','bdeaa47a63f0f52cc16c017d31fec5213cb035fa944a1738831fe3cbbcaececb');
INSERT INTO blocks VALUES(310249,'93f5a32167b07030d75400af321ca5009a2cf9fce0e97ea763b92593b8133617',1419724900,NULL,NULL,'7b35f5510098634937b7c9b99f5be96aeffdc08880e8500dc25252e8bf2b8814','141f4cba239600f0f735cfd4a6089780097a138a60d27b8d329e5397dbc560e0','b705b2e64125a790d02476b214e9014c3ef8c8e3fa24fd3aa9d222e3f8bf5729');
INSERT INTO blocks VALUES(310250,'4364d780ef6a5e11c1bf2e36374e848dbbd8d041cde763f9a2f3b85f5bb017a2',1419725000,NULL,NULL,'b6f8d3948ac9ad0e37e48b222ef88929d53acc9f1cc00e2822da5885362e9c4b','f2cd5f1b8537e7dd1fa069c5bf30c6a26a3d8feb2bbf0542297f32ba802814d8','63f352d0a11f26f296ca197fdedf84133bc5fc500335886aa2bf4f2f0a4d1a25');
INSERT INTO blocks VALUES(310251,'63a3897d988330d59b8876ff13aa9eac968de3807f1800b343bd246571f0dca7',1419725100,NULL,NULL,'e5969c00b1ab1ca714f1425cc1b1e6426a537b65567e872245951543e1930bc4','8e5531610785331fedf288a5e9e24f3764e6fd8cbe5ea014793b1b64351dc368','7d7e039ed2b7546a5152bcf773555c49a49c204d84f756008c6f0b9e24da92ab');
INSERT INTO blocks VALUES(310252,'768d65dfb67d6b976279cbfcf5927bb082fad08037bc0c72127fab0ebab7bc43',1419725200,NULL,NULL,'38de273f8e8ca656ed9d4a7f4064fd7731597d512839d46a29fd49b567faa256','22ee896a763dc1cb37f3c4117f671a20626e3c853a7f4708bf6f138b2de803bf','cb6ffc431e14750d8f323c330af588c0cef6afa5a850b9e9013f567cb2351ad3');
INSERT INTO blocks VALUES(310253,'bc167428ff6b39acf39fa56f5ca83db24493d8dd2ada59b02b45f59a176dbe9e',1419725300,NULL,NULL,'70fb1b1f8ed3d0c080c4faab7cfed1154d34ac57ad5dddfa4527ce7aba3ae514','6c1e96a152ae2529b46e98cee7dbad19e8948e4a448a37f04ea6e276b0822ed1','3518a59b8e2a3481600975cbf0ca31ae1fd11faa29dc147fa289210e035734e2');
INSERT INTO blocks VALUES(310254,'ebda5a4932d24f6cf250ffbb9232913ae47af84d0f0317c12ae6506c05db26e0',1419725400,NULL,NULL,'79a8aa31ead89ca8092ace9c83837db4f7e71cf71d513381cdf870d2ce69dda3','d049a04e311e1244d17feff4001dc4477432babccd851b025732d21e72478db1','6c8014a31a364ab3cf31bebb7182fdd376359622bab4eab2c21afad062c883c7');
INSERT INTO blocks VALUES(310255,'cf36803c1789a98e8524f7bcaff084101d4bc98593ef3c9b9ad1a75d2961f8f4',1419725500,NULL,NULL,'73f613e6a05c1bf5b747735942df5e7ff87682fa08fae1cb13ba6664a5480902','69c967f750ea0476758c54d46c23ff8c39d2f8aceb6a80ba3f7067b6ecbcfc80','6b1680ecace0733f564a0968e480c5c2afdd35188b5ff5033b6c4c1fb65da587');
INSERT INTO blocks VALUES(310256,'d0b4cf4e77cbbaee784767f3c75675ab1bf50e733db73fa337aa20edefdd5619',1419725600,NULL,NULL,'f308106511332c9438349b77b167fe01ddb3f057644d8a3e37253dbc3cb62aaf','8d9576ab018f9617a5b2b6fbce241f8044a376312463d144aa150120ba6c353b','fbbcc2ec2320109042b04ca77d0b97b0b6875afc4fe8acb3e8204c7f5101d191');
INSERT INTO blocks VALUES(310257,'0f42e304acaa582130b496647aa41dcb6b76b5700f7c43dd74b8275c35565f34',1419725700,NULL,NULL,'6d12b4d8a8eefac0fd0cf2e2146941ae7b9b29f1e6d6cb0d003bf796cdc0dabf','ca510d9af3b47df18081f5c4a1da499f108e14c0116f5f84d39cf93de7eb9191','2fbf0511c561df9da6fa96a49b0972849c0efbeaa228d9f0c91350e0d22d305e');
INSERT INTO blocks VALUES(310258,'3a0156dd7512738a0a7adba8eeac1815fac224f49312f75b19a36afb744c579f',1419725800,NULL,NULL,'e06627fc69a6a755527dc4b6bb1f2d9a74d09e8db8193720958af0667e96d171','aa0c64c5e965f932e0cd72f27f995782568348cae09781a67a8e8b48c04063f9','b499689eaf11182b98c0cf42278c673347c05af7b9d05620f7b697a5caeaa00f');
INSERT INTO blocks VALUES(310259,'e5ed3cdaaf637dd7aa2a7db134253afe716ffdf153e05672df3159b71f8538a9',1419725900,NULL,NULL,'810d8faac6b8830417246f3f0465c258609e2595ea676bc8f346151c0e85f0d9','7c8bf0d9a1f94dd9d252ebf62effa33e2fb0ac605eca8f6cfdf641bafbe72382','ec3ae4454d99eec7fbc5b7f7c33d0c33d7b60bb1d4dae4db3b26b3189ae31295');
INSERT INTO blocks VALUES(310260,'8717ddcc837032ad1dc0bb148ddc0f6a561ed0d483b81abb0c493c5c82ec33cd',1419726000,NULL,NULL,'4abcc585d096536e7442a32bce9db10cd3197c273f2d7efe0be600a65a5fc955','b2812f2c68c07f38bc3cdbc701e2e62b976a0f74c6873bb5ed9b8d3435f33370','ee5b35eeec619fd3fa610bde5f2e8898e2b86c142fcd588a7aa9bbaee0ef5159');
INSERT INTO blocks VALUES(310261,'a2a9d8c28ea41df606e81bf99cddb84b593bf5ed1e68743d38d63a7b49a50232',1419726100,NULL,NULL,'d368910a77cda85aac121e409a6245abbd05caa5164cd77dc91f03b0aad2843b','fe855d19bd1ed9679080dacad8bd359ab1fd016900116354d6f89dfdb23b0572','85c8298470f1eafa0a616b80a56f382a1c155c1df815fc957ee9e8d498b0b0bc');
INSERT INTO blocks VALUES(310262,'e8ebcee80fbf5afb735db18419a68d61a5ffdde1b3f189e51967155c559ee4ce',1419726200,NULL,NULL,'cdd21c79d2cabac408dec6ba850271f354229cc60e4b22c1df80ac5f5e4b1b24','809b5932d287e04bf61800ac732826ca8dbb83b73b86227b661c3eb12cf219aa','a843afe0ae97c010872072ea2ba3734df39b31276c38e9960cc866d086fa71ca');
INSERT INTO blocks VALUES(310263,'f5a2d8d77ac9aac8f0c9218eecbb814e4dd0032ec764f15c11407072e037b3c2',1419726300,NULL,NULL,'2698d23358b8d3ae0d7d6bb85b5a5f23e3dad20a8fc406cfe007a32241ba225f','adecf1f1392c26220c19c2e9dfa5e2d04ac15721717bfead60ee3d02530262d1','37ab4a8b66ec1849362cc7818e187a6047ffaff5215f2fd39278546f83e903ef');
INSERT INTO blocks VALUES(310264,'ae968fb818cd631d3e3774d176c24ae6a035de4510b133f0a0dd135dc0ae7416',1419726400,NULL,NULL,'774df793fc2d59798e0b14d3716ae93e742180a7242c8665bb3de9bc90f8eb2c','6256c8b90324a50ee69b8db76389498db1b34caf8ca89b1948f35399573c4890','53bbaf01e7ad7440d0faf03f01bfa457172d0deb5925504236e961be725e22a6');
INSERT INTO blocks VALUES(310265,'41b50a1dfd10119afd4f288c89aad1257b22471a7d2177facb328157ed6346a1',1419726500,NULL,NULL,'2ea7d42e5a43c640f93fb7ee77f81bc3b390172c1694e24e18a8629bbf6a31e9','9b8490b3862b63c7ac088cd3a614203f7492fdc31b9592f6b35c8c4c90288ec7','56d632a39b9b875eaddbfce426a8e3ba8317bd754afa8931285d537e3a770340');
INSERT INTO blocks VALUES(310266,'1c7c8fa2dc51e8f3cecd776435e68c10d0da238032ebba29cbd4e18b6c299431',1419726600,NULL,NULL,'b9b700175901aaf233647f70c4a9fd016b5f0832e7bf6fceb76bb77e3d443fdb','7ede0b29408d94f8ca3989f8c1adc6829a3ebd33ccb50603065134cb467ee203','6d37efb70f3e5abd597fb2128c9b713d5e11cdac440da192904d9ec50658e0ab');
INSERT INTO blocks VALUES(310267,'c0aa0f7d4b7bb6842bf9f86f1ff7f028831ee7e7e2d7e495cc85623e5ad39199',1419726700,NULL,NULL,'abccf89554a8116fe49b49992374893ab285ae427c17b2a61fd624639029b287','a6e2d1b15452ac2c06627dac8a80aac20d8e1d9d98bbd8eb18d9acfa5cd5748f','6dbd77108e78a8804f518bcf1524b1fa661de4809e06517c32e8256ec00a28b9');
INSERT INTO blocks VALUES(310268,'b476840cc1ce090f6cf61d31a01807864e0a18dc117d60793d34df4f748189af',1419726800,NULL,NULL,'3325b2f48107d5f1d34f5233e4e6b988aed04f9fce4f3a499b0ec952b66a226b','bf8459a00b0b548a4ad2256c67d9d75dfd7c00f04fdc8f12ef33247d9e7c8b2a','a235331e422b1a66f21970cdfff24c596a06bac92da2721e578b3094a5ff5c86');
INSERT INTO blocks VALUES(310269,'37460a2ed5ecbad3303fd73e0d9a0b7ba1ab91b552a022d5f300b4da1b14e21e',1419726900,NULL,NULL,'346eddeb534d460d71203a7bfa3752bf75628bcf84b1756e39e9ffdc21e7fac4','21ec1e4c9dee7d898f3f631b9e33807089fde5c3fc27d01e584e972e9cf2287d','968c14b0a7f5ed217b1ec1d031992988c7d22eb61439dcd78f4437cc19dff031');
INSERT INTO blocks VALUES(310270,'a534f448972c42450ad7b7a7b91a084cf1e9ad08863107ef5abc2b2b4997395d',1419727000,NULL,NULL,'4b548ccc840f03d42c1afbc56abb5eb9f06fc6f7e6e804692b805acf7a18228d','f6648a62bdd18aa831ed4d7e88970bf098d8393b34783a3d1937286bcd1beef7','e3f6b4b39b3c657f798d3e124b8219453f7a909865bd8abdb8e50f5669a26a4d');
INSERT INTO blocks VALUES(310271,'67e6efb2226a2489d4c1d7fd5dd4c38531aca8e3d687062d2274aa5348363b0b',1419727100,NULL,NULL,'8cef6c12cfcb4305bf10bc21b213fdbfa04b27f7efe14f7c62e8f058254f0a2f','3fa2c60d3017de4f1439936448a8379bbd75da05cd200b782dfb2b7332898b47','dc70de4ece63aefb4557d0b4cb9de4b7d3326f55c7ead814d1422ff1248905ba');
INSERT INTO blocks VALUES(310272,'6015ede3e28e642cbcf60bc8d397d066316935adbce5d27673ea95e8c7b78eea',1419727200,NULL,NULL,'3603e7a9159aaa6a69284e0f45c7467f32e3796b51755863115cb9f523431f56','d8ae4a89540be130e1c536b5e223a773ccabd788d87cbca951c547a65a4ef75c','25c75adf6137f3570261905e973aa841f9ea31e635b5a28b9ccfa3676fec605e');
INSERT INTO blocks VALUES(310273,'625dad04c47f3f1d7f0794fe98d80122c7621284d0c3cf4a110a2e4f2153c96a',1419727300,NULL,NULL,'7502801c5c7bf4c0c68e9000ced6db612c7b0197fa4bf2a621efd5183c7741e7','a3c1407fa93870879c52ed09feb2d65688af224c86501dfb3e894fd5ceba6e1b','1619e12feb10e673302d84ed6f4bc967584af593407b325e07c83fc50700c973');
INSERT INTO blocks VALUES(310274,'925266253df52bed8dc44148f22bbd85648840f83baee19a9c1ab0a4ce8003b6',1419727400,NULL,NULL,'91b465ffbaca9243343595f2732d9c24dd255f99d7d060faab00ec24de72d750','beb7bf0153a98183423c739ce753bd85eca6cb8d35829305921589a7d5b20894','68a4646b08b83ff65b32e68cb0635af74eb24adb63227a6f15ec5ac46c89e869');
INSERT INTO blocks VALUES(310275,'85adc228e31fb99c910e291e36e3c6eafdfd7dcaebf5609a6e017269a6c705c9',1419727500,NULL,NULL,'15c99c1fa51a79084332f6ca1e0a0b7253e42d8878ee3b8225fd8955d5938212','b6a0a5104b85f5759e4b51987d7797411d7764939e52ab4a6904fc2d651a5cae','3fe82006e373ad720f174a894a38bc54da8712ac999b08c8746b25b11788fe4a');
INSERT INTO blocks VALUES(310276,'ba172f268e6d1a966075623814c8403796b4eab22ef9885345c7b59ab973cc77',1419727600,NULL,NULL,'7540a98af30cfc90177ac90be3ca461829ff90460b3d50957d8339e383bbf8cd','8d8fa9af398f7a7436b6de81a27588d330696ced7a2ce31318e4e178dac1b301','f104adfdeb6dc1451b56db2e931a1a046b161caeb3bc895fc50e6f37700347b8');
INSERT INTO blocks VALUES(310277,'c74bd3d505a05204eb020119b72a291a2684f5a849682632e4f24b73e9524f93',1419727700,NULL,NULL,'28a024d36462a22cc7d0917f840df52b8b53c075c97fe9592a3cee6f745d3095','6179f41fb7e76ae0dd7afc02db1bd5d2c2383f9111c3561d1c4f4e9bf5618fcc','4952b36107fb187aa5ba2c16bed06aa1acdedb717d348c693b3adf281d008738');
INSERT INTO blocks VALUES(310278,'7945512bca68961325e5e1054df4d02ee87a0bc60ac4e1306be3d95479bada05',1419727800,NULL,NULL,'895464d36c55e816b790ab0b5f2dce4dbb34ac22d8ba6ba352d06cf4ea3c3c18','a29334e4745e2851782f8e1efb8223e1e8b3e4e7461bc9b6615e82a506138616','5e233915a4900215cc2014aad2cc0dee4450c269fadf501382ed2d7055f1da3b');
INSERT INTO blocks VALUES(310279,'1a9417f9adc7551b82a8c9e1e79c0639476ed9329e0233e7f0d6499618d04b4f',1419727900,NULL,NULL,'7a6a3921ad9f82d2d7124aaf14c62e1d4b5fbd5fa2c253c178674eefb2cdb583','1bed55220a5a7a4d7467c89c089bb896717724da579ce61431ddc1da40e309e7','937ad2ad8476b5d402c702a490e56871d2de2e1e62d12c40b7a974b690a52dae');
INSERT INTO blocks VALUES(310280,'bf2195835108e32903e4b57c8dd7e25b4d15dd96b4b000d3dbb62f609f800142',1419728000,NULL,NULL,'5c1a4a5b687521c4a9cbcc2c70a8f81db61494d5f5374837df30ab40c8e99d2d','dc0fc11378b6c55cf24f5c728aada2b79438215ecf88354424c05d0351fd3931','7d3699e20bdfff665bd09633a56b59b3bb6bd42e810a15de732dcc5c9538cc50');
INSERT INTO blocks VALUES(310281,'4499b9f7e17fc1ecc7dc54c0c77e57f3dc2c9ea55593361acbea0e456be8830f',1419728100,NULL,NULL,'9cfdda4cda735bab2d0ee99fe9763cb2503116fa3e064a9a8aa77075a45d6bbe','7b5b4b18cac5210ee2a2e813eb5d806506452b06bc97f94430208011c0668621','e72c7a5df2453ef53764639d3f223938108721f22b8c071937e9a3ce8d2f8a0a');
INSERT INTO blocks VALUES(310282,'51a29336aa32e5b121b40d4eba0beb0fd337c9f622dacb50372990e5f5134e6f',1419728200,NULL,NULL,'93c5380794e1b44c41c19bf9c7333ffc81a1aca28c7db5b1b6ffdb02dda9733b','d80e0afc49e62ce69d6423467d550d58551d07c181b8a904bdcc09c227c1129f','90efd4e32e3e3b98613732fd125c7f301a8eb460fe0b075ad9e31d3cccb5d4b1');
INSERT INTO blocks VALUES(310283,'df8565428e67e93a62147b440477386758da778364deb9fd0c81496e0321cf49',1419728300,NULL,NULL,'3d9fc5c87451862518a0def0ee952d8e636c9438b597ed7acfb66e29c039cb76','9c597d77d84e60944f06ae1fc3b681a4c714ff0eac27000b1678441805f9ebcc','5c34ab3018fe8ebdba1de32676fc174f22d225f1cbe10851bea2e7ff81a16579');
INSERT INTO blocks VALUES(310284,'f9d05d83d3fa7bb3f3c79b8c554301d20f12fbb953f82616ac4aad6e6cc0abe7',1419728400,NULL,NULL,'7dfed9c43af81f08f54db325f74174390fd4e174717706cd7cadebc909d97216','26a403472185ff8fc028f73a5fd074dd87dcf30c515c1491e82a99c97b255fbf','b02e7dd41db60ba5e22a2d2936a302436a64f49898900b6357ed7e7aa489221c');
INSERT INTO blocks VALUES(310285,'8cef48dbc69cd0a07a5acd4f4190aa199ebce996c47e24ecc44f17de5e3c285a',1419728500,NULL,NULL,'e59545a0c31ff77eb048a9117009ccff25ba1b1665bd2a80d734867a65477d28','b515c193298e1a9bac96b9daa31cefc0d99f2b306500e9ce831c957f843b6c95','85fd47f9704876ec2101dbf1ce0ce59eaa3569b3fa2a6f53202baad45f05ad23');
INSERT INTO blocks VALUES(310286,'d4e01fb028cc6f37497f2231ebf6c00125b12e5353e65bdbf5b2ce40691d47d0',1419728600,NULL,NULL,'929902bb16887bc57ec07477e32380724a8d62db5b177f5023b319d22f019f52','8e91b408d4741557d0a0127883005b4d3d7570568b02f44b6d4a03e03699cd20','9c69f7dfdacc07d3e1464ce6ec108c44687b1d8f46e921b5b9141ac0d4cc3efb');
INSERT INTO blocks VALUES(310287,'a78514aa15a5096e4d4af3755e090390727cfa628168f1d35e8ac1d179fb51f4',1419728700,NULL,NULL,'f57d3a18925c608b59ee795d265cd79a94ea1a5cc923f0a6d126c0a747c5dd66','1c1e3058fbe006e3a69b050cce377036828e962d48f6243d1290082efae6c54f','ccd824e1441df765d46a718f99f8f8c12c57c1ffe62cfbbd40a6a4a9c8734e15');
INSERT INTO blocks VALUES(310288,'2a5c5b3406a944a9ae2615f97064de9af5da07b0258d58c1d6949e95501249e7',1419728800,NULL,NULL,'cb45d44ddefdb8789bf28846e9c308b32b24e188bcb7b7139cf9b92bbf6bb5d4','3b34e5d2c06750bb824188c660e4da2c1a2b52e5a85bd679e2b5fbf79be7e745','352925b5935c57faf4ffdb8a3f36c2bdbb279763c14fffdbf4d1010ad5eb1a4d');
INSERT INTO blocks VALUES(310289,'dda3dc28762969f5b068768d52ddf73f04674ffeddb1cc4f6a684961ecca8f75',1419728900,NULL,NULL,'63584648e4164e9d0f998bb4a6c10a2161ac10ed85adbd6375cc527c41354868','9ae8a0692128a30f80b86b61e949c937e36a516f6cff67699a6f579ab1efe37c','8df798e8c57c2c557221b54cd3f83b0dbf85dd64ede282551384063b9cd67876');
INSERT INTO blocks VALUES(310290,'fe962fe98ce9f3ee1ed1e71dbffce93735d8004e7a9b95804fb456f18501a370',1419729000,NULL,NULL,'5669e2249c2c32388e86b74f57af38d649e0fc4be8d1dc7a333de8093c143bc5','17e0204e7be676eece5baf83ce4f7ca60d7a0da49a992497ce526b165867cb21','1138aa8a891ccb1085b7e65300bc9ca6638ab997703292b0650b955dd3ef8c3a');
INSERT INTO blocks VALUES(310291,'1eeb72097fd0bce4c2377160926b25bf8166dfd6e99402570bf506e153e25aa2',1419729100,NULL,NULL,'95b3b9c91685836dfe48cf62aebdee0040b401a5366123d476f4f4b4df1cc771','e4b3ad912ca3f5be90f04642eaaccf544e22d34450f54eb7f3349a414f452b16','2617efe7c444e8b96cfa0f9af2164a034b774ec4989fdc986b3ee8530b159c41');
INSERT INTO blocks VALUES(310292,'9c87d12effe7e07dcaf3f71074c0a4f9f8a23c2ed49bf2634dc83e286ba3131d',1419729200,NULL,NULL,'9db38f008fe0536fbeefa4ae682f44faf97261cf47b73bd0d09759c42fff00aa','d1a9465be7c36c5eea1dd4d7d59839fc22b1b5f730caacbab6086dac6f2aa74e','8689e00b68c87009eb43b0f9a0fa4d84668b2e3d3f96f8b9b1fddafbd27f89a4');
INSERT INTO blocks VALUES(310293,'bc18127444c7aebf0cdc5d9d30a3108b25dd3f29bf28d904176c986fa5433712',1419729300,NULL,NULL,'4726105149793642962d32346261d28ae5196de226d5d781cd84d7bb32e995d8','5fb93664d8266a3d0f1d680ffdb2d3b67e78d5b9a60d620d48bd63ec50c572ad','63f4ecc7bc16ceabbfc069fa990f0cce4b69ee6da40882c0f184a78bd825d64e');
INSERT INTO blocks VALUES(310294,'4d6ee08b06c8a11b88877b941282dc679e83712880591213fb51c2bf1838cd4d',1419729400,NULL,NULL,'aceb71862ed00caec152a619a36cdf99d1493465aaa8e235904639210172ad04','1dc557bed6068fc43bd4928ddaa94c49c4c9a6712f93bdb1af2743ead159933c','46eb08cd83a743d7214152facdde23fb3a358d658a5b4148ead8eaee3571610a');
INSERT INTO blocks VALUES(310295,'66b8b169b98858de4ceefcb4cbf3a89383e72180a86aeb2694d4f3467a654a53',1419729500,NULL,NULL,'0bc5d5e4acac2cf8c13f24980880b40641c5e935513623f4253193f1b142eda1','96afe02f3dd1260915058c48703b57bae9ccc7650eef018a873009887f66cb68','477331a8b11933e92b088ba7414cf388314eeaacc6ade8b7d48a8ae65eaa0a83');
INSERT INTO blocks VALUES(310296,'75ceb8b7377c650147612384601cf512e27db7b70503d816b392b941531b5916',1419729600,NULL,NULL,'33f53a4b8f5dcf50dd94d2c181d057e0052f3cd39018da0a18303b88fc2b0f3a','2390e012ffd6ab42a830641ad45e90175a3b61f3fc1d84f812029b0e0c900948','6811cf42092db2774a6bd7465a68434512c102a96003246edaee7b514192e5d3');
INSERT INTO blocks VALUES(310297,'d8ccb0c27b1ee885d882ab6314a294b2fb13068b877e35539a51caa46171b650',1419729700,NULL,NULL,'5bf49134ac42665225fe000c8a6e2e787cd598b5cd9492ee38992633dc0a863a','806a8a0241f9940a5aae140075e943edc54a638170a3d2ab966109bbdcb843f4','b47ef0fca0f762c84d9688fdfc01d0ffa812047a7ba4a63cc7b0701e09fe6a68');
INSERT INTO blocks VALUES(310298,'8ca08f7c45e9de5dfc053183c3ee5fadfb1a85c9e5ca2570e2480ef05175547a',1419729800,NULL,NULL,'499dcc04e71caa3fc2702bad3c1f20cf4059151068d18031f6e6217e94a79252','05735f63be11cb85d2c5768c7beda0510900789019a666b4a339c3d25b2d869a','4048c8f5ce5eb03ccf5a74da7380930ddda7ae798a238a52835aa98cb559635b');
INSERT INTO blocks VALUES(310299,'a1cdac6a49a5b71bf5802df800a97310bbf964d53e6464563e5490a0b6fef5e9',1419729900,NULL,NULL,'347a2369541d28ee1858b987d62ed256f292a69365be3e9a30438c5213e7aae7','2c9362a32566a4eb3942e1d07154d4841bf8356ecd772acd848217829e2b00d1','1a1132c730f6836cfeb6beaa96ec29f74f516642980c99b252fb36f098987421');
INSERT INTO blocks VALUES(310300,'395b0b4d289c02416af743d28fb7516486dea87844309ebef2663dc21b76dcb2',1419730000,NULL,NULL,'0976861eb9e944220a7b867029ff21ce1cc1f9911890150c8132190829c76c52','7df3788c56e9d5d45133808848bbcfae8c67d2442c4f7ffd272bb35cbc730889','579f3ba296e36172cf1a366898bdf85efc3ae0bf4dc0edba945dd44c08a79b68');
INSERT INTO blocks VALUES(310301,'52f13163068f40428b55ccb8496653d0e63e3217ce1dbea8deda8407b7810e8a',1419730100,NULL,NULL,'b0e849c47546defbd23059d6748225fb2c13a613e18993ad6dfd42f22e768946','283c71b9bc0117d0e78f240a7b2a2cb53c77993690a906053f72407db535cfb0','569df5cdcd557484a6707161013fca82894edc30d251cecbf65e5ca7b457b3fd');
INSERT INTO blocks VALUES(310302,'ca03ebc1453dbb1b52c8cc1bc6b343d76ef4c1eaac321a0837c6028384b8d5aa',1419730200,NULL,NULL,'29fc14c3e9be9110077e1a7969beba9cf4fe101d9056d91bc1fd99aaa28860ef','eebe3c25140d103769f06af477293fb59689eac648cb46e97ca5d981afb1fbad','fb9eaf7be76f497ddf197d702017222b67e587562788925e3ac220c5bcd62126');
INSERT INTO blocks VALUES(310303,'d4e6600c553f0f1e3c3af36dd9573352a25033920d7b1e9912e7daae3058dcca',1419730300,NULL,NULL,'ff717cff1fa5fea41a3fee5ac3817b46dd5b5289e66540937aee29607f31c350','54cb17fa527f84a4f3c7dd64c250aa1cd842432e741caf0e68a55031fc719462','79e1bfb352eebd357ef4142ddca3f8226cf5d3d402e23c0975fb654e7cb96cea');
INSERT INTO blocks VALUES(310304,'b698b0c6cb64ca397b3616ce0c4297ca94b20a5332dcc2e2b85d43f5b69a4f1c',1419730400,NULL,NULL,'25e5740eda771ec14cf2ea35ea0c485ec91321c030a5e9e05ebc9dbba22b4753','1297ccd82728c68c11c647faf03a14ec066f44daa08acce5a6b36e86b016b629','7b2eaf4b829d54e152d73909545981f49907506086a5125c939e44285cb151b1');
INSERT INTO blocks VALUES(310305,'cfba0521675f1e08aef4ecdbc2848fe031e47f8b41014bcd4b5934c1aa483c5b',1419730500,NULL,NULL,'2d6f0547b61fc370d4c3c0f97debed43723d0747014990316027b1aca27f1e02','d9920000131529f0f8ff2d880ec35ea0f7e82e715a14e1cb1351d41e6949eb26','c78b1f1b61c026c1adc6868bf49a9ae5ce8e2699a50bef3f36895b12945fe5fe');
INSERT INTO blocks VALUES(310306,'a88a07c577a6f2f137f686036411a866cae27ff8af4e1dfb8290606780ec722a',1419730600,NULL,NULL,'e2385f534c637aef884ffaaa61a4254db59c31b18bb46dae073737de444ef391','04e1d2b1d1ad878090065aea0b7df70562ece6a65605a9aa9668d62b21f40255','03dc483208e9f0a9fe04abf4b70c0252b132635199ed9c65e70f84444586a0a7');
INSERT INTO blocks VALUES(310307,'bc5ccf771903eb94e336daf54b134459e1f9dd4465dec9eaa66a8ee0e76d426c',1419730700,NULL,NULL,'ddfaf1ffebda4d60da43faf60add99ac8f210f54800635d9f535d7b9a3a8351a','fbf1beea6d3e373b43e1f3a99eff5e5c52eefc06e91ee932c9e47f999eb0eb2b','8532e66ec3cf190a4b826a6659e92d7fadec2bee193a51d5df011904b7d9bb7c');
INSERT INTO blocks VALUES(310308,'2291ffd9650760ff861660a70403252d078c677bb037a38e9d4a506b10ee2a30',1419730800,NULL,NULL,'ae8341832cd0c58f38ec94beff6ce7ffef392a80dc5ecf7ff3995499e2b9bb2e','946ad644e3a90eb5fd97695565e48a726b9a67146dfeaef1fc6d6a26010b67c8','e51c67b930fca6476a4b6a1672579144d749adf30c5873ea6301a2f502843dc4');
INSERT INTO blocks VALUES(310309,'ca3ca8819aa3e5fc4238d80e5f06f74ca0c0980adbbf5e2be0076243e7731737',1419730900,NULL,NULL,'378bf70bfd2b2d6a519c56b79fe7c89f44c46732788477d58bc023af0a4ae0d7','9f03a00dd3c286192f158e1cb1b54a3f41b03e2268cc2400201adabfb07acea2','a46fea690c3b4fc3cb0d4b6af44d585bb489333155b4dea64d6142f1d8355a1d');
INSERT INTO blocks VALUES(310310,'07cd7252e3e172168e33a1265b396c3708ae43b761d02448add81e476b1bcb2c',1419731000,NULL,NULL,'0d56313d541de7994cea499ea86be67f60766d1035aa3132900db4a5ac369602','37b91b0502570b13c4ff892faf82bc7ec4984e2d37e56d5305f88921ba3d12e4','4f08a9f768d92adc5e3ebc86adb23467d81fe0fac72d69a49f86708a4f7f81c5');
INSERT INTO blocks VALUES(310311,'2842937eabfdd890e3f233d11c030bed6144b884d3a9029cd2252126221caf36',1419731100,NULL,NULL,'8af3f9760225b11699b3fafaf8089a93d19c2e8b2386512ade57d909f009cdb8','6f7a83621e8b20415d5ac11257f12f1185a7fa14ea02c763d045a628ed5be7a4','0c4617d6040843b4e7384acb094949c4a030cd4398a3af541879a7f31fe6c876');
INSERT INTO blocks VALUES(310312,'8168511cdfdc0018672bf22f3c6808af709430dd0757609abe10fcd0c3aabfd7',1419731200,NULL,NULL,'9c691797ae4e49059711b5397ef04cb387eb60a1122f8b69993781859147ad33','e5660d79c038610128940f44482b27d0cebe2b37dc324b4078026f2686f5e48b','32ee9f357030aa11b28aea6c9b4c9029c1b922a4925707c4fd988422f5c1c07d');
INSERT INTO blocks VALUES(310313,'7c1b734c019c4f3e27e8d5cbee28e64aa6c66bb041d2a450e03537e3fac8e7e5',1419731300,NULL,NULL,'5643b4b837c8f3e2aca98a03258bb7d480d250660352fe8aab9d5dc0788a62c2','f4efad23f2c5296e7864e6ef3312fdc55597af736769e469ce693b86560e5046','7bec0b1b59d6de5163ee77daff4286ac257100d13864a70e65e12c7b8767a774');
INSERT INTO blocks VALUES(310314,'1ce78314eee22e87ccae74ff129b1803115a953426a5b807f2c55fb10fb63dc8',1419731400,NULL,NULL,'a5c221e90715422e25d8d1cbe74f72f0911802871cace6f9d8165610b19b1668','80f0e68f0a280aa1991e5d637fc8accf922d290d0e380355e79e412620e62119','d62a8b6f148956105117fc968ec228f9ea54574637841d605744d3cd21829f6b');
INSERT INTO blocks VALUES(310315,'bd356b1bce263f7933fb4b64cf8298d2f085ca1480975d6346a8f5dab0db72cb',1419731500,NULL,NULL,'729f5efbd95c0a83e5cf1d3a89f9ec060ebd15d1b0fec65f4cb40acffd21d2d0','3bb023b65d2c8d3da6cb11b19560296c48d15ae2a38275f80ce30dd9c7cd8478','712b4d30df098693eb8ece408fd4e5d28df5e84a9b19c284dc06dd3b3b2f2353');
INSERT INTO blocks VALUES(310316,'ea9e5e747996c8d8741877afdcf296413126e2b45c693f3abdb602a5dae3fa44',1419731600,NULL,NULL,'84785db92c1d7fc6cc1f52a5233ab35665ecb7e5aeca2a3a233a76163ae60135','11d9da99fd9dc590c870c404c434d6fb65611c896f2dad4d899bcd4e5272f4d0','8cbcd3917fa5b36e4976480e9ae3fb0950fc8bc839406bfa0364c7f4c0f6926e');
INSERT INTO blocks VALUES(310317,'aa8a533edd243f1484917951e45f0b7681446747cebcc54d43c78eda68134d63',1419731700,NULL,NULL,'1197e623925f7b96462a3200825f67111ff0378fee1084ef3da3d31c17d1febd','c167a81e25f4780bd66f782c73e9e21b483780a67cd45f1b48238e0e76acd4d6','7c99b13f2c15e93422366f013c726d36a1018993488a28164e0f665920cd6188');
INSERT INTO blocks VALUES(310318,'c1be6c211fbad07a10b96ac7e6850a90c43ba2a38e05d53225d913cc2cf60b03',1419731800,NULL,NULL,'2637ff22bb48a19a3543c782bfb5202bf1739decd08e9a62e14a2066cd3a117f','c3e10318b1342afc6e41d131ddc82df9d9a9a788d3d1cbdb7adb6bdeae82bbac','2605598a64b7c8cd021f8b52a325d27fcce03214bfc72d7dde32ee0a8f12b625');
INSERT INTO blocks VALUES(310319,'f7fc6204a576c37295d0c65aac3d8202db94b6a4fa879fff63510d470dcefa71',1419731900,NULL,NULL,'792a7613e2ec7de1eb056ec0ca98094b02ae6ebccafab9095943aef971a48b7f','e7a5ea6d75f29fb6294a1ed0a8a61ad9eb797fbf5225dc835961de2631ff2b1c','4ae48e31f8957c133c9604c5c0ae601ff7f47a2bb95e2621737234aba50af43d');
INSERT INTO blocks VALUES(310320,'fd34ebe6ba298ba423d860a62c566c05372521438150e8341c430116824e7e0b',1419732000,NULL,NULL,'3116153e3466819152bb9fa289a07128a93ecad32b8b63f711362affb65dbc9d','ec696c5be578bf8861210362c03581e1dc7b800c303aa62f27df2b51992d9b24','7d66cd7ad6b401d0df98852b2b161e4b4620325fea456606de49c2656d36e7cc');
INSERT INTO blocks VALUES(310321,'f74be89e9ceb0779f3c7f97c34fb97cd7c51942244cbc2018d17a3f423dd3ae5',1419732100,NULL,NULL,'ea20b9dc3fc6e2c289d253c1d5596b2ffaa73d3a646fd588ccc1c0a29eedea96','3aabdd5640ad702a2afd4caab2bd5a38c15058a2bf681067cefb09f571163bf7','add71e199980934304ddf76fdb4d095c8a35faf90ad34bb1b7e5da115b4b7b4e');
INSERT INTO blocks VALUES(310322,'ce0b1afb355e6fd897e74b556a9441f202e3f2b524d1d88bc54e18f860b57668',1419732200,NULL,NULL,'239a4ddfa0ef674358513d9c6a39ba94271e03c5d448cc191024f31d6ec8db47','fd2de2c2dfb8af4be0bed6561c5c71724d7f3b97bc24a3d78270f4700cd9c273','ba6cd04ba8103133b9afb6650446b0d673a208ee0fde878077d09319c048bea6');
INSERT INTO blocks VALUES(310323,'df82040c0cbd905e7991a88786090b93606168a7248c8b099d6b9c166c7e80fd',1419732300,NULL,NULL,'8630a40fc600b301b62669ff72cf31b9645086cceb666fdc795ddd31911ada54','c87949776071cdc78ba8b1cf75cfb19b6b9242a35161b7eeccb17fe098878354','249fd93d7116970a259f864c5e5af2aafe57258b23fd3a39f7e9d80564c4fc32');
INSERT INTO blocks VALUES(310324,'367d0ac107cbc7f93857d79e6fa96d47b1c98f88b3fdda97c51f9163e2366826',1419732400,NULL,NULL,'0f46d51042497e2d882d391619a066414f0c1eab81fba68994e261c6acdbb847','e14b8fc2624cc6ae887b75cdb3743f71d36f11b71536a064cef8c0c08a3e2ae2','77409137fe076269c341186c3c9c5c9f2d8284fc749be8a8f69c165aee1f38c9');
INSERT INTO blocks VALUES(310325,'60d50997f57a876b2f9291e1ae19c776df95b2e46c14fe6574fb0e4ce8021eac',1419732500,NULL,NULL,'2a1e713369e972f7f340a379117e2f57ac94205a23deb97ef724ad0b228eea51','4042a65e13d8c00f95905eb90de5f6c20c44ca7d1398a47e8c2bb6ba4f82223f','34a43e5c8a4eaec35825bcf6bb4aae0eacba68b94247c04a9c73477faeabd100');
INSERT INTO blocks VALUES(310326,'d6f210a1617e1a8eb819fc0e9ef06bd135e15ae65af407e7413f0901f5996573',1419732600,NULL,NULL,'adfa711cb1774b2be3c86b307c3a061a10c498a83cf04f9f02337fb03fb9fbc7','7bceaed3e4a65b4ceabfb0cfbadf4bf277fb86464171a917adba25268694f3f7','54af6e0329c806c19f00dcb779ab4b08613bcc86d278c2debdff29031cb3495d');
INSERT INTO blocks VALUES(310327,'9fa4076881b482d234c2085a93526b057ead3c73a6e73c1ed1cdee1a59af8adc',1419732700,NULL,NULL,'24e74914a42acf40c41994132f6aadb19877e3c128e12e8cd79058cc12c54214','3a44861d290932765aa7f4586da644fc5810358ca7f008277831583c4383aa01','af645e7d20f7579938521ea849087cff53353afbb75509e88822cb316ce3f55e');
INSERT INTO blocks VALUES(310328,'c7ffd388714d8d0fc77e92d05145e6845c72e6bfd32aeb61845515eca2fa2daf',1419732800,NULL,NULL,'7a7d904dba595e83aed799402467fe9e77a00f45f6ab249337b065ce24bee807','76f7645bd78a8f4bd16d5a77d2b53055c2bcf99203db442d1e428febc18fdf8b','99b0c0f1470596571ca2ea2e49bf596657783a828709712ba46819e6add166f6');
INSERT INTO blocks VALUES(310329,'67fb2e77f8d77924c877a58c1af13e1e16b9df425340ed30e9816a9553fd5a30',1419732900,NULL,NULL,'e9477d96b638a62fedb77eaffcf4113fca8c314d4d10854f0c3f0de5e7a2116b','59cdab26fa1ff4c0ec22503effe8ff2ba5170e93bb56d473cb1fc9691857cd4c','489fd57223c91c62d0f0158d3f2621cd7eb26b88c6b8c6530a84c41fc290ff2a');
INSERT INTO blocks VALUES(310330,'b62c222ad5a41084eb4d779e36f635c922ff8fe275df41a9259f9a54b9adcc0c',1419733000,NULL,NULL,'2b5f5143a39befaecc19e7b083f371c158880a4885f09df4dc195d4176835b1b','fd853b0014891c6297e36fd854b508af7f0d8a04218506f0e88e28f9ecdd84a8','9385dc768e02d92898c3119d98985b2384d1b76ab4cce5c87599d260604f4872');
INSERT INTO blocks VALUES(310331,'52fb4d803a141f02b12a603244801e2e555a2dffb13a76c93f9ce13f9cf9b21e',1419733100,NULL,NULL,'9167f4b1be5861cd82c274865f47a581e191fae49bb11a7b2b2a5b4182d67f9f','729f8db960db63f28945e58d7c008cb7e321e596202e34ee99263df4c669fb58','800f100a9cbb71fccb0fa0f72f190180ee26eac4ced1e99bc565ddd9c9675116');
INSERT INTO blocks VALUES(310332,'201086b0aab856c8b9c7b57d40762e907746fea722dbed8efb518f4bfd0dfdf2',1419733200,NULL,NULL,'5483595ba2344506b9083c3eac8db134d4e2c73fc42173fd4726da780f40f1cf','a40ecf03b5ab3d3c909ad7e150bb24dd60a5c54c7ee06012c1eeb9eb30306287','fde3d09d0d40f8d4abde11276a08079f5c47bd38d7c879e39c4417548280e774');
INSERT INTO blocks VALUES(310333,'b7476114e72d4a38d0bebb0b388444619c6f1b62f97b598fed2e1ec7cd08ee82',1419733300,NULL,NULL,'285e44e1406e2ffe9b49e4906a80fc21f1096131ed032282f15f67019d6d85be','103148569b38a7ab3c54eacb041ea17635ab40c55a75cf986ecad01b304e174b','6fd1befa9a29235387706fddcd650a28df438b2419bf580ee47cfe574d616ee3');
INSERT INTO blocks VALUES(310334,'a39eb839c62b127287ea01dd087b2fc3ad59107ef012decae298e40c1dec52cd',1419733400,NULL,NULL,'bd9b21fc0cada735d611c93352311537347184113a2fdf883d49838649c6d53d','724f57f2311f93c119580e9b8c2d8a72bfdbbe68f0e7c21009e9abb16d877cc5','ce4ec7ed856da55cfdd2171567e5c08de84edf8a37784502c481ae4d14210467');
INSERT INTO blocks VALUES(310335,'23bd6092da66032357b13b95206e6527a8d22e6637a097d696d7a96c8858cc89',1419733500,NULL,NULL,'758b0eed3f61e2a6fddd5210f4004b6e05309911ec60385d88820cf4e5763b33','c9d81ea706359cb92fbb5fd842f327a84cd97c9ba4fefaa1f674f3c3c55b93e0','930c82c277780ddc595926a44937e4cf685325244d64380dd9b35d01b2a10ed0');
INSERT INTO blocks VALUES(310336,'ec4b8d0968dbae28789be96ffa5a7e27c3846064683acd7c3eb86f1f0cc58199',1419733600,NULL,NULL,'2a3dd21752b538a7b84361bc4eadd5a4868071c7c9a794df1452d030f9fd29f5','8a6f951fa3346f2dafd22c04626d943fc2725155ea7147f131187951f7802239','fdd72859b47cd2cd8dd4ab89a917c6bbdc85c78fafa039120b03825137926f8f');
INSERT INTO blocks VALUES(310337,'055247d24ba9860eb2eadf9ec7ea966b86794a0e3727e6ffbcba0af38f2bc34a',1419733700,NULL,NULL,'7ae0f64ec51ade0f3ee7f2f15434dda29de06359f6f659315f5c658ec9a99e93','68f72c5ac0cf7e3a558cb855f78cd06875b545902d46d71fc23cfb90404be1e4','a6a137f7b79413fdd6163df486c6fd3bd65722369f5f443fe15ac7f1a9f2c906');
INSERT INTO blocks VALUES(310338,'97944272a7e86b716c6587d0da0d2094b6f7e29714daa00fec8677205a049bcd',1419733800,NULL,NULL,'a1f9e0ac1e0cb74a840e49eb4dfeff64b521ce52a4cde9adc8601fb147df2ad8','15ae4438160f187292b755d6a3a7dd1d6687143d0ff1344fbde7307c56a9a048','669dd13bd38726ca28aae76d7575fceecb3c975d3170e1903ba447bcf3a178a8');
INSERT INTO blocks VALUES(310339,'99d59ea38842e00c8ba156276582ff67c5fc8c3d3c6929246623d8f51239a052',1419733900,NULL,NULL,'f1ebabac7ee3ec9a46480b57e3d8d7db45f5bccbb3c16170a0205c2f7f46234f','00ab01c534d60becb254e2361f5d4b45ec8cf3758b1733e48d20969840fdfbad','7446ed03c41dcdb9a1029e049a8d7364dad2531733e9af1e904815055bb79bc1');
INSERT INTO blocks VALUES(310340,'f7a193f14949aaae1167aebf7a6814c44712d2b19f6bf802e72be5f97dd7f5a0',1419734000,NULL,NULL,'12a7f53fa25b9c56b9408eaeddc2d3d7203e40c8e528ac50b8cdd677f597370b','1176393edd3705f85da8607074f47e6da1bacd0d8bcc43aa1f95dd345e365eb6','c79c1c32c89b30c6c04e70102598dee44d3e54dcef69c53ea88e3595275eef13');
INSERT INTO blocks VALUES(310341,'6c468431e0169b7df175afd661bc21a66f6b4353160f7a6c9df513a6b1788a7f',1419734100,NULL,NULL,'b9b3d26fae2f66163280a355c4a49db1b3c2f9bb0d0b560bd5f4af31cdb78dd8','6881b03a7c6897701658b2f89c952ca070fab7193a1b4b0f178f413c6fbb04e1','588985721a68e09f0702e602bda9610cd83f264a4ac42edaa718acec54345770');
INSERT INTO blocks VALUES(310342,'48669c2cb8e6bf2ca7f8e4846816d35396cbc88c349a8d1318ded0598a30edf7',1419734200,NULL,NULL,'589238d4613584c2186efb1596d23d2cb1bf52375dc405eef99891e2c38b44e2','f239c29d8c04596657ca1739764faa4233db2df30319ee99548638d997ccb609','fddc2af99ed95f93c677afa5c38d02f7a00e8653a146b1fd01aff519e663bff5');
INSERT INTO blocks VALUES(310343,'41a1030c13ae11f5565e0045c73d15edc583a1ff6f3a8f5eac94ffcfaf759e11',1419734300,NULL,NULL,'083406d00c648d87d42afd23d00f1be45452ac4cea8fa9d0bf3fe9f97dfb3714','f8a1b7d98b840563a799f36d6bc2c6b788c903da12b3ca37f7d4121f2abf6579','551fc06d86e961012208c45fd3d1248b82d9b2b479b0d6691047de5b433b0847');
INSERT INTO blocks VALUES(310344,'97b74842207c7cd27160b23d74d7deb603882e4e5e61e2899c96a39b079b3977',1419734400,NULL,NULL,'ed5fc7b814c67677748977ebc1fbab18c5f175b1946987249237564e9f3c0055','5738076be56c0f4db80799fd19b8f23818b58cf01191cd29e2f27c582db88c27','cce06ad4050e488cd7583da4a2f7f9a4e1341a333c9c6f3ab489289c462f6d41');
INSERT INTO blocks VALUES(310345,'0bda7b13d1bc2ba4c3c72e0f27157067677595264d6430038f0b227118de8c65',1419734500,NULL,NULL,'72ffc73a5299817f5124c4c1e673e4da4f6d8fe6618eb9e44d35236b49f4e31d','e78404bdfba213e8a5f8b459e913ff6602903af0de1279bda9ab63dff14c155f','258126761a79f026b030d6f72608bf2e7db9197c6c1bf13397ce3bb9f90557ff');
INSERT INTO blocks VALUES(310346,'0635503844de474dd694ecbcfb93e578268f77a80230a29986dfa7eeade15b16',1419734600,NULL,NULL,'ace6672b007f4505bd079dc4ad0c0e2694289247e8421df4a7d87eba89d7cf66','4dc091a3dcba56d2670f34d952590c21ce1c66c1228024fac882d72b8534ebbb','69f92fe40532448ca3e92e3745b000153f8d82bc234163edd3265a1a60924506');
INSERT INTO blocks VALUES(310347,'f3f6b7e7a27c8da4318f9f2f694f37aaa9255bbdad260cb46f319a4755a1a84d',1419734700,NULL,NULL,'fe5d56fc1abd1bcf7b91f7e4196668d26b8ef730ddfba37bcb65ddbca3122e2d','c2ab550896c702efa3145763140c08cb40ced35f95f3addc9dc7f8090e0f2b3a','e57c21ad3b01349cbed65cf6e3e5d3cc38eca647f90ed679a25845ca675aba8a');
INSERT INTO blocks VALUES(310348,'c912af0d57982701bcda4293ad1ff3456299fd9e4a1da939d8d94bcb86634412',1419734800,NULL,NULL,'630782af97e4cfa22d2676915d66b146b874e0920d76000a0fc44c9f1cb6c647','74100dbfc05482b763126b358fdf2b5ac07de77da075ecb42480fc0cb37a077e','37a2839ed0109835dcc18504e68865fccc25bea15956c073b986232a0b450ebb');
INSERT INTO blocks VALUES(310349,'ca911c788add2e16726f4e194137f595823092482e48ff8dd3bdbe56c203523c',1419734900,NULL,NULL,'cb41fba0b8b3536467100c17367b02858b20b897fca97921a4ffa041f3ddadbf','a881eb9a8585ab83d5929a70abebc7d171343418997f6afe76ba441a10943156','12f305f8e22029a9f8fc7b61fb6af9f851e025b7cc9636f17827f447d8a8fa6b');
INSERT INTO blocks VALUES(310350,'c20d54368c4e558c44e2fbaa0765d3aecc8c9f01d456e3ff219508b5d06bd69d',1419735000,NULL,NULL,'4af9bda15dd15956d11d9922eecf7027a3a62231b9672c3b45118e384518e564','5cf7f7eaef281dbfd16de267f9f2b8badf74b89c366c2dc6a3d4adc4ac85fd9d','a05052dcd60819735caf685d971c7e9185efac9370607a6a8f077f1a8581fdcc');
INSERT INTO blocks VALUES(310351,'656bd69a59329dbea94b8b22cfdaaec8de9ab50204868f006494d78e7f88e26f',1419735100,NULL,NULL,'b1d47f24ccbdb1b66b178b8608485cae3e9b2d4081fd2488dd9856e6ebe51aba','0bdca49370d0cff363a20d68b3a584e0e447a40990e349d238f4023751ca1ef4','560455f82d78c3740d71c428421145a1043a9911f1bb35f1f9f5c84575556cd4');
INSERT INTO blocks VALUES(310352,'fb97d2f766a23acb9644fef833e0257fdb74546e50d9e2303cf88d2e82b71a50',1419735200,NULL,NULL,'6d8b45bddb9de6af8c81805e8705fcec25d66255c1c97d94a2796409ff4d07c6','13bd80e0cdbf70345f4daba08f7ec36a99d36bbf27cb663db19c4ada434ecda1','cd4fb4d284da1ded8f29f32ed071deb6d8d0b11bb0f3bec81ba2c8f95906a5d8');
INSERT INTO blocks VALUES(310353,'2d3e451f189fc2f29704b1b09820278dd1eeb347fef11352d7a680c9aecc13b8',1419735300,NULL,NULL,'77f9329fa833669f4488cccc7905c8db782ae288efaa104be3fbdc183020d217','12c89ebff335d9c832b88c25a2bf7492931443968390ab8a2535c24de5384d96','e8f57363121fbefa3ca9b948bf18ae1d176013a8e0b1c1bf20b2ddfb8c7404d7');
INSERT INTO blocks VALUES(310354,'437d9635e1702247e0d9330347cc6e339e3678be89a760ba9bf79dd2cd8803e0',1419735400,NULL,NULL,'dd0f5b08da273fdb3f4dd6e678ffd784c4561dc755af6fe5a8b719fcede9979a','6e84ec2c5ba0995398cd73cd71d5aae2a1efa1b93e51dfa23b7b09bb71ae7954','02d092eb1032c24e96c623b1deb2d5dd18141ecbc00b3063c3bee2d513b43227');
INSERT INTO blocks VALUES(310355,'ea80897a4f9167bfc775e4e43840d9ea6f839f3571c7ab4433f1e082f4bbe37d',1419735500,NULL,NULL,'ab4fa6cb02bef46f32da1d9021cbd94059f2c553efb8d7bcbf2fde23e04eb0cd','6d20c01766cafe9e74083ddba63f7f7c4900eb3529f9481ef52d2cff0774d7df','f8eb8e96699052a6768468bc9e8a14a5bf7e792531aecdd6e2da74e9fa832d51');
INSERT INTO blocks VALUES(310356,'68088305f7eba74c1d50458e5e5ca5a849f0b4a4e9935709d8ee56877b1b55c4',1419735600,NULL,NULL,'4e3c28bb0aac24e98261bba79aab0ae89f0d4a662e22afcdac673345667b5aab','724960b477b77475bee187501af3d2960d92c3f9f6215a1660b84903a5c257f3','753799222810764efb629acee23583c3dbf714bcf51d0d79e0b9eb060034fed1');
INSERT INTO blocks VALUES(310357,'4572f7f4ad467ef78212e9e08fa2ce3f01f2acc28c0b8ca9d1479380726bab1f',1419735700,NULL,NULL,'b6f618cde16a4c250ef3391e05f3cd80f298f997297d5ae353173fd85a944286','34755463460d39552d471e34aa9fbb4e1e8125a12474476dd6fe0953358a24f4','fe18901ecdaf00627155f2ee613c571aec5d3e1d57626cad237a357d80718fe9');
INSERT INTO blocks VALUES(310358,'d5eae5513f1264d00d8c83fe9271e984774526d89b03ecd78d62d4d95ec1dea6',1419735800,NULL,NULL,'990f038829e96bae5fa970d036c7b0b106e6e08279959670b8c80e545303ebc6','58c442ef3d6699823e4ec09654821cbc8849b677f5fb0b045d5cc070749d9e2e','6ec6c811b857aa686bfc740fe37fadc7a786c52c7c526980513b82ba92b64cd8');
INSERT INTO blocks VALUES(310359,'4fa301160e7e0be18a33065475b1511e859475f390133857a803de0692a9b74f',1419735900,NULL,NULL,'8072d1b3316820dd44dc65c3b8237fa7e40382778245ee4a2aed4ed1bea10c36','7906dcc6f9be5bc5f7a1dd527bf9fe21b428f24b5f2f7d31ccc2f5dd7238bcbb','bcbf602ec3bcc882b5a263350969c9fd9f7c0ef54d84d7113d2d5d0b192f50ac');
INSERT INTO blocks VALUES(310360,'cc852c3c20dbb58466f9a3c9f6df59ef1c3584f849272e100823a95b7a3c79f0',1419736000,NULL,NULL,'3028fe89f4ad958b6ac57f74a589c9df88178e3ac40aa591aa42cf39382c6890','caebb49c87d2df6f833f44fa07e364361c8374bcfc434599068400dd6f5c2eca','1b6c1fbbb8b50623d882431180ee96fc9c489bca938528508e317785fddd77df');
INSERT INTO blocks VALUES(310361,'636110c0af5c76ada1a19fa5cd012e3ee796723f8a7b3a5457d8cb81d6c57019',1419736100,NULL,NULL,'b24746430d91429691ce983408bf7a22beeee67fb8c06f52286d42a41ea3a5ce','cffea7f937335ef97ac65df329fbc8319562899de28b90c3c786660da259f250','a0b2310402e3d37cb7307ee5169a79be1183020aed3932e78a9223f303c63216');
INSERT INTO blocks VALUES(310362,'6199591a598e9b2159adb828ab26d48c37c26b784f8467a6bb55d51d7b6390f2',1419736200,NULL,NULL,'67eff43ca6b542533d3153044eacc60ce91a946122f50bff62270af848f13a09','0a4931eddb5092db45da500faa8459cae424f3d387584e6085e1a916b4fd3c32','1e605ad32193e421df2f45cbc7ffce7d1f21df986df3c5e1f765b3319eaa8b4c');
INSERT INTO blocks VALUES(310363,'a31967b730f72da6ad20f563df18c081c13e3537ba7ea5ab5d01db40e02647e6',1419736300,NULL,NULL,'ba4039a19d3b34fb0d9c258f76a3c93266e7d4c029908366084b7472349e5610','46e25910f3855b624095d224e9e2257e3cc967b37bf1235d7abdb9a796ed2e77','0220d6c9b7651291ed5719b6c06e132f99701610c67a137ce91e0f003d01d216');
INSERT INTO blocks VALUES(310364,'67025b6f69e33546f3309b229ea1ae22ed12b0544b48e202f5387e08d13be0c9',1419736400,NULL,NULL,'7cc2aa1fbbb2f226ad811cbae157509acea1965c3704381899a0a708b791d301','8c0342a05242924301359d1ffad2ff03939c2886b1a9e6f82b81c6741b960e4e','b7b34a70a2f500c2f2386380d4099f17f4498171cec313b07bc1df951e7d9a0e');
INSERT INTO blocks VALUES(310365,'b65b578ed93a85ea5f5005ec957765e2d41e741480adde6968315fe09784c409',1419736500,NULL,NULL,'1114d0b5aaf36c349257973149ac3f833cb4acb8cbb3c2790b0dbdeea7d9f6a9','0274599b7ed2c87478bc8a94995a522d4211e202900814e17646f8d448bf10d1','80b92b4c68fa8eae7d62997e34ccfd4dc51dcd19413e329b1dd1a4f560eab9c8');
INSERT INTO blocks VALUES(310366,'a7843440b110ab26327672e3d65125a1b9efd838671422b6ede6c85890352440',1419736600,NULL,NULL,'e0c812f83b73f87e5898932122957e6dd28d9747ee0c525496704637b0c484fd','b5e7108b4b460374c482874713ca347ef1674c1057cc4359c8a4c93afe0d4b72','219f450b841d621ca476d6c63e928ec00c839f203665b23fa01fe51e853b01a3');
INSERT INTO blocks VALUES(310367,'326c7e51165800a892b48909d105ff5ea572ff408d56d1623ad66d3dfeeb4f47',1419736700,NULL,NULL,'4ff231ebfea47f8a0eaf015c9b9da8815bc5f666fe402dc70dfd4105f9be077f','4a553005fa4aeed0c51b631cc51c0bb483ef12f6bf933d99b8a282790c2568cb','30b87cef5cdee80483a7520be1023b33f91726a01fbaa73d5e8716282054713d');
INSERT INTO blocks VALUES(310368,'f7bfee2feb32c2bfd998dc0f6bff5e5994a3131808b912d692c3089528b4e006',1419736800,NULL,NULL,'a38c4d7a0fbde34adcbaa39b11ef6b903a4f1b9fafee331feddfceafc5c2cac5','0f825f5cfdfaa2d0acba0808f5f59015d5201848899dc9d4e36e4b022022f99d','b6645faadf3901ace3a9d9affb09cafbbb3185cb61f976facb4b28f5fbffbec0');
INSERT INTO blocks VALUES(310369,'0f836b76eb06019a6bb01776e80bc10dac9fb77002262c80d6683fd42dbfc8da',1419736900,NULL,NULL,'f84e77b8c0128ca8f834e7c7a4b3246e05708a681bffc39a5d4d0f638432ece7','2f88d7093d0a1d52d61e9631d22cf6fb1248885224510fd3cf355511b64b7d64','0262274c2a081995b746a5b66f954ec33aefad013228d1012c9106362921d024');
INSERT INTO blocks VALUES(310370,'9eb8f1f6cc0ed3d2a77c5b2c66965150c8ceb26d357b9844e19674d8221fef67',1419737000,NULL,NULL,'35a290d20f110fcf5663fedcc77d884051d95381fc933e54ef3dc9db5d314d2e','ef8a9e6ff0d19927260fa9ebd671fab17f92a4e3a3db95420381530f7d24427b','60e5bb7ca78cc42e08038936b95fd6fcaf1bbcbe90a75312c4a58b48286ebea4');
INSERT INTO blocks VALUES(310371,'7404cb31a39887a9841c2c27309d8c50b88748ed5fa8a3e5ba4cc3fc18310154',1419737100,NULL,NULL,'b188e50c29c752a8800504fa8eb77e58916ee0c6b3156c52a737ca50db0f5b0e','c47a87a1afaf7d55a88ba38ee91d43beabf7ab25e01c7c18eaef4a109c0cb556','7f069d68aa261b32fccd075a9daba2c8577be5d2c74d5d31994ff2f16014ba1f');
INSERT INTO blocks VALUES(310372,'d3a790f6f5f85e2662a9d5fcd94a38bfe9f318ffd695f4770b6ea0770e1ae18d',1419737200,NULL,NULL,'360a36cd1599e38f9783cb6e79862ec26ee9b325cf9f7e134ffaa1a19ecba31a','d0dd05e76d8b3971e760b324fe78371426ba6d7c471341d54a4f41eea23a45a3','afb64acf16b7898d2aca901e894d9cdf21f9b2e517945a7dc23f2e76ba0796b7');
INSERT INTO blocks VALUES(310373,'c192bec419937220c2705ce8a260ba0922940af116e10a2bc9db94f7497cf9c0',1419737300,NULL,NULL,'ff867359964490f65e1784c59fcb5c981244e5a026f72c2e9e9db8dddfe0bd8a','101b345174b0e985d453d04278bf9a743fb01c09513407b25a4ed1b8bfa75fbd','906390ca25664d9ecd77799c5abe183e9db46b334bf94a767fa28358a4c65e2e');
INSERT INTO blocks VALUES(310374,'f541273d293a084509916c10aec0de40092c7695888ec7510f23e0c7bb405f8e',1419737400,NULL,NULL,'58187f0e0332a6c7d8e5fd789ec6e3479102c4fb18761520b3ddf6080146daa3','40719df5cc4d08cd544ceb4692086ce473feb6378627c45acf0cbc426171aacc','ce17a6222c21883b59fc08795db9a87b023c34a98bfa005c23a765f9fe5d1a6a');
INSERT INTO blocks VALUES(310375,'da666e1886212e20c154aba9d6b617e471106ddc9b8c8a28e9860baf82a17458',1419737500,NULL,NULL,'dcbb711f50b92da3277ef3e757c99eab3fc28b3ca377d045a544242ccdc9b836','d0e8d1f1f76eaa86684828cd9aed6cf36f1c4856435d21096e76705d069e5653','5e590d7d1f16747ba415410780562c582faf1215e29fc79e273e10626263d417');
INSERT INTO blocks VALUES(310376,'5dc483d7d1697eb823cba64bb8d6c0aded59d00ea37067de0caeebf3ea4ea7dc',1419737600,NULL,NULL,'71ef226b718bd6616f9e70b74a968bb452b38febd0f8283182a393a75c02f6a2','5bee3ac5974afa3e695ea4654ea71c96472dc07def89147b52776a20de60ddb3','f6ce48562faba65e980591addcf78ff7ba8e8a741c780c8be9e2ac8b58ea6fa7');
INSERT INTO blocks VALUES(310377,'f8d1cac1fef3fa6e7ad1c44ff6ae2c6920985bad74e77a6868612ee81f16b0b3',1419737700,NULL,NULL,'d7148743538fbaa80e3def932dd9d2949c6cd18bb5d93fd4f26db7d15fd40139','0379e5f709377366b604d3bc43c94df9ab3064d3bb510386f19350115cac8c4c','23b955438880db9a66cb5598c1a8bb897a3f97a14a83f1c0d07130f4961c5c5c');
INSERT INTO blocks VALUES(310378,'fec994dd24e213aa78f166ca315c90cb74ee871295a252723dd269c13fc614ce',1419737800,NULL,NULL,'039fe63049574ebf82653cdab762fefb7f364390f3de0f65d9821f040668ca8b','c8736e45ff1c5dafb9c102dd9427d2c4eb22d75fbdf26bdcc1f43c7d35735c46','a332a65dd2f1a8451113eddbb6e166ac5c28a4264775bbdf3a901e1d8965be14');
INSERT INTO blocks VALUES(310379,'d86cdb36616976eafb054477058de5670a02194f3ee27911df1822ff1c26f19c',1419737900,NULL,NULL,'dc6d9e59190fa477fbd5e0ac018766f027405b5da6a40dcfc95320d6a8850dbe','81dcb8319affae63a5d08561eff3f95d7f94179ef2bb24f51546efe32a6ea632','6295bb799468426d8b7ff4fac3b9a09ab3088157e87bfc69d1ac6b4bd838b3f2');
INSERT INTO blocks VALUES(310380,'292dba1b887326f0719fe00caf9863afc613fc1643e041ba7678a325cf2b6aae',1419738000,NULL,NULL,'a81ebb1f834271bdda8149b55b5f176846519f367fde4cea436c5cf394171b0c','6f5ca8cdc7d92e94074db7cc5692dd76a073a09e48932da937d9e04842531184','0f61b4762e059a5b2af222fe61ffb0a7b7357b7fd3de5e723ff3ea31ba256b5b');
INSERT INTO blocks VALUES(310381,'6726e0171d41e8b03e8c7a245ef69477b44506b651efe999e892e1e6d9d4cf38',1419738100,NULL,NULL,'67e4f0514f11993995935fa97c5b97c3508fa9ab958c263f5bb47c79e372b247','b0689a08014d9b91d8d52e9803d7502eb99e3f4fd53f89d867aa7243ee0098e8','a4df07e9559486c326ce224134064c789e0f3a6ee3bf2cfa724e243112f5bc53');
INSERT INTO blocks VALUES(310382,'0be33004c34938cedd0901b03c95e55d91590aa2fec6c5f6e44aec5366a0e7d8',1419738200,NULL,NULL,'c7955f56d7d885c2c4fc53790df22c531289334213a5bfae3706ba9b47412f9f','714d3ebbe1873f531ef2c37c8c7c90e868b412b86127b10ad6eac63b8ac1abc7','c342273de1379cc10fb3ecd35f3602c03a4160a326854f31855121fc6fc69cac');
INSERT INTO blocks VALUES(310383,'992ff9a3b2f4e303854514d4cad554ff333c1f3f84961aa5a6b570af44a74508',1419738300,NULL,NULL,'e85ff5122b9fb7ae713871020b4638637b91295f62b21d9888beb898eba29f16','235224536fdacab5cafbc58383c7c286b244932ae65dee28f13830c29b7fcc28','bdfc4103c3fcf80bba059c9cad1efb8ba959301ed8119273d1815744d86c93ee');
INSERT INTO blocks VALUES(310384,'d518c696796401d77956d878cbdc247e207f03198eabc2749d61ebeadee87e5e',1419738400,NULL,NULL,'a624363697ced9f8786fdedeeefef0588592f68da0790c470f2e3d812dfa87ab','cc13ab3e7bc5d0ce1b993b5c9104209762b94bebed497af97bda2f34456244ec','5509b64fa7d611ffc05d84a0a0a9ee96ff66b1499e13f955c0b8f24084abe316');
INSERT INTO blocks VALUES(310385,'2aa6a491a03a1a16adbc5f5e795c97ec338345cfdf10ff711ffb7ac3a0e26e28',1419738500,NULL,NULL,'221c1bbf97f72528475b79917949a0ebba60ccc25d23de11c5c97117033514f3','794924d5cbd64409f1fa6ea9b623d22a25f78c08044ee41d50aa122ae5aa4813','55f7be3b32386b5615c0315194819435bb118db49cd234e42930758c70ad064b');
INSERT INTO blocks VALUES(310386,'9d19a754b48a180fd5ebb0ae63e96fa9f4a67e475aeefa41f8f4f8420e677eda',1419738600,NULL,NULL,'167d8bc76cfe63877d052d33bdea66fa41b17c6c2ac5ccd6d5d79d797dd38205','6498fa2a892b5e579e3f6874ba9210b9b775b418518d828baefc976a4760d5fd','8984ab1459890651a3a3ef04dad90af50e5de479e7fb7a68c257afce841b1bb6');
INSERT INTO blocks VALUES(310387,'b4cac00f59c626206e193575b3ba9bfddd83bbfc374ebeb2838acd25e34a6c2b',1419738700,NULL,NULL,'b7c82fca13fa467cb2e1c61fa7af820b73eb631e8e3419369d2a8cd6313af360','428a0b8c77f0ba53fa1d05de88100e9c6d8f19968580ac2ddfdc26a0a1e11586','2d3f21a1fe36cec6a21ced21de56a137b85e4b65ad2a851680f06399c1694745');
INSERT INTO blocks VALUES(310388,'41a04637694ea47a57b76fb52d3e8cfe67ee28e3e8744218f652166abe833284',1419738800,NULL,NULL,'31d99b58e65f4d4c098382af4eb3ff2740c918be791cc4ff3e01e009ebc1904f','13791d92561ce9add1abf0c84aa8cc5fff1a729b1098a7a4599a98fa1e5e4f38','06e5fbffae0d97305ae0af02ce6ea17bfa9e890dd2c031d482505ca1910e301b');
INSERT INTO blocks VALUES(310389,'3ec95ae011161c6752f308d28bde892b2846e96a96de164e5f3394744d0aa607',1419738900,NULL,NULL,'b16074bd125e4fe92b6d4d95bb7f3c694c716c3d89915e712e01d61b8d5bf657','a8c8660d3dc19da4125b1db8dabbb3ce40cc739c73420b4ce1cdaf629ff02dc4','a166453ba1028f0df18aa4fa761e1e87a8f634b33bf9fdc3c92613a80623bfd6');
INSERT INTO blocks VALUES(310390,'f05a916c6be28909fa19d176e0232f704d8108f73083dded5365d05b306ddf1a',1419739000,NULL,NULL,'b02bea28a1ab37cb9a4e747caa8494642c81bf8d1efbbaba6ad27bff2ef633a9','863270d4eeb5a2e6a146ba228a202c7a3ed34d3a67565994479356d132d79edb','a194c1c8c9b6b5895227569702308388d6a3fa62d9df86101277a2b763370c15');
INSERT INTO blocks VALUES(310391,'fc26112b7fdd8aaf333645607dabc9781eac067d4468d63bb46628623e122952',1419739100,NULL,NULL,'7b2df7c1894a46ecf805faeb3b17a497b2689a3afa2c2bf8dbde6c97e694e3d3','edc07289f5adc6c98a4508b4db4db095c98df7c99bfe4a5f15a4cfdc33b010b5','c85b3c66a2bcf55f03836077ea19438838ee87a0cc3cd5c3b8a7bede08052bc8');
INSERT INTO blocks VALUES(310392,'f7022ecab2f2179c398580460f50c643b10d4b6869e5519db6ef5d5a27d84a1d',1419739200,NULL,NULL,'2eb7b7be23c4d99be550baa5f0fdd6ddf444bc3d40948eab55d283dff750c952','6552b20325db5f9009d0f5408c04f2db7cb8259beeab71ab2203e92a38197b09','35b1e6efedfd837e721691ebdb08a91c5eadb9f02627ea277a096dee5fbbeeff');
INSERT INTO blocks VALUES(310393,'e6aeef89ab079721e7eae02f7b197acfb37c2de587d35a5cf4dd1e3c54d68308',1419739300,NULL,NULL,'f38a71ea6247de2e151bb243e7978264cce6b079261d17e62e7561e33c4d9805','73f39186e4ac2dda7944d15e51776595826afa274e6436a24ea476683aab6866','1bcd1024fd8b8bd202e2f5f2750e6e2aec3bb0c5dcc3f0730ed950e8348a9e8f');
INSERT INTO blocks VALUES(310394,'2a944743c3beb3bf1b530bd6a210682a0a0e9b0e6a9ff938d9be856236779a6f',1419739400,NULL,NULL,'2839f4bfb3e28b1b63c342a5e65a00f1a23ca4cc90a359c1f43a1dc27dfe0338','6b0063b10b5d2c344efe7bb5463c4fa1435ffc4b861a00951cb2aa43261f6334','020f83bdc647cfbdaf39ab87f96df943639eac83b1dfbeee9977e1a7e4afb1db');
INSERT INTO blocks VALUES(310395,'19eb891ce70b82db2f2745e1d60e0cf445363aaff4e96335f9014d92312d20e4',1419739500,NULL,NULL,'2d3f498ad1963347e8c908d636ae83492cb8044d63a6ad4a2130ce1daec6593c','256b9a3eb004963d73728cebb6b651a5ac7349197204fea44dd17ba0b7058b97','933a5013cbac373da0510564df483effc64c2a920f1518079b40464652ab4ba1');
INSERT INTO blocks VALUES(310396,'aea407729ac8d8e9221efd9d70106d14df6aaf9f2f87dc6f490835a9caadf08e',1419739600,NULL,NULL,'c7db8b31d764e481391ca1001ed9c828e9ae2c9f21ea8270f5fd04c190b7f136','0920c2edeb8071ca6e0663002edcafad7bfabffd198f32d22b70235e62d1823a','4f80495d4c2e0520d1399d72f7c221e2cdf8995147a7f4407464bdf6461d7994');
INSERT INTO blocks VALUES(310397,'7c429e56a19e884a8a77a759b52334a4b79404081b976270114043ba94d7985c',1419739700,NULL,NULL,'16b2e09b4783e36408e993553c6a2d3d2352cd1ba6e59a30da9207ebf52e39e5','f83950061a9578c6694b39d054db6a3f9a458a06561de785ba63183f815fd2b2','e1f5b5224083f0cbb45d1456832130f7acf3fa4fcbf2c5a9ff809dd6ef767fa1');
INSERT INTO blocks VALUES(310398,'55c046db86dee1d63c0e46e6df79b5b77dfd4ab2ff5da79e6360ce77dd98335e',1419739800,NULL,NULL,'afea8e29e0dbc0c341b8408aecddaac6f0591f84539b65c346a8fcf7f4687412','3a6110b59f1b98578e949bbc951c87a5c097a1c4b447b29e12c4cd36ec40c78f','4340b5c2d6f42963afe62e353855dfd47b98598a750c54f2525898e8ee126aa0');
INSERT INTO blocks VALUES(310399,'765abc449b3127d71ab971e0c2ae69c570284e0c5dacf4c3c07f2e4eca180e7a',1419739900,NULL,NULL,'8636e95abe973755024b12969663d480fc3b4bb8de24469e2a959044ed40efdc','dcc1e2fa0ed78e2a88a870c90251c6cdbe7c36de1a4743548262f6013244d6df','b4f783ba8891d7b588d212f04355fa2a41d89f5f6aef95af49b168f6f39a3aec');
INSERT INTO blocks VALUES(310400,'925bc6f6f45fe2fb2d494e852aaf667d8623e5dae2e92fdffa80f15661f04218',1419740000,NULL,NULL,'39ee2f90bdcc758119ade0406b2a67c5846947d72732d5f90b98954ba3548269','c78a6a97906f89f61414f0e844a7438730f18ce89b00f1283176503fba33511d','116740a1ff21553137d16737bf1377c58e748212f6cb987df0f560c208e80de4');
INSERT INTO blocks VALUES(310401,'f7b9af2e2cd16c478eed4a34021f2009944dbc9b757bf8fe4fc03f9d900e0351',1419740100,NULL,NULL,'9d365219115b6bf3a43888eafe88ec661f9a80b4717ec84347e7dd677e23adab','67f857f0b2e5832eb6177c0574d2e1f92bb8119ac93e8bf42e273d01ab25276f','91cf09a07ed377a59eb48fe476cca700c1578c7dbbdf92181929795749474d0a');
INSERT INTO blocks VALUES(310402,'1404f1826cd93e1861dd92ca3f3b05c65e8578b88626577a3cbad1e771b96e44',1419740200,NULL,NULL,'5fdb28bf805d3d2abf66a49ea23429b3de682547eebba9ca6ecdb945d77c2f30','343ac9fc147a72e35aae821d59dfabe2fe47ed510dd694534dc0104341c0d826','ec9f28f476c07c11281b5522c57d476b6eda395109cdf08e29047f22de724b09');
INSERT INTO blocks VALUES(310403,'f7426dbd4a0808148b5fc3eb66df4a8ad606c97888c175850f65099286c7581c',1419740300,NULL,NULL,'181f97ad6acba6d75edf9d0510f1ae2279539c0ff5a8be11434b370faf0112b8','16ad2b3f647f02818f7c5b2d00cf5e5b5c5a7ca2110f01bd73c35c7fb1ebde84','30103ec67fba16da3ebb832e7f4252d3074bda20da0f2e665ae7837d40ebcee4');
INSERT INTO blocks VALUES(310404,'401c327424b39a6d908f1a2f2202208a7893a5bedc2b9aff8e7eda0b64040040',1419740400,NULL,NULL,'c94e340f2685dbde6e2bb909479474c952da2f5a5bd02c350792dcb48425596b','0d7877d621915ce696f8943c9ad6fcf18a19ba229e14299633da1dcf3d522024','9ee3872eb36504b6101911a36fe6975451731d8f617f0605014e9c56bb1d82fe');
INSERT INTO blocks VALUES(310405,'4f6928561724e0f6aab2fc40719f591823ca7e57e42d1589a943f8c55400430a',1419740500,NULL,NULL,'3f64ad18d41849b3691e85460643b5f3bc215b75a754add81e586a2d94e61298','4f258b63bf4f4ee0376b71ce160deb069fea3211d75e53025c963702cfd151f2','9cab1d32adfaa3872b9fa3fb70a0dbe08c1597acb4271d5bf627398248b249d0');
INSERT INTO blocks VALUES(310406,'6784365c24e32a1dd59043f89283c7f4ac8ceb3ef75310414ded9903a9967b97',1419740600,NULL,NULL,'0c665ce5b410d93cde5255d83930fe9ece67fc7e65b8c03b4b0ba1ce09d29dd6','67751b8caa227b6bd6827deea8be0f28cfcb9ea37a071a122517e189fe367ea1','9579cae14da0a200be8838e41cb294ab6676b776da2956f2724893a063a61d1e');
INSERT INTO blocks VALUES(310407,'84396eb206e0ec366059d9e60aefdb381bca5082d58bffb3d2a7e7b6227fc01e',1419740700,NULL,NULL,'54203f1c35f3fcb8d085250d062d0ba9cdadb7d6ab206fd78dbf66c36b85fdad','28508d25c8b7ab5c2e1ce5c78f12d2603ce97579e99dfd2cc4cb8ba5055b83d3','a1e2ae7b1ffe7d59c9741f8d751930fb9451d8c839a0b34d213a55f90b21261f');
INSERT INTO blocks VALUES(310408,'4827c178805e2abae5cb6625605623b3260622b364b7b6be455060deaaec2cda',1419740800,NULL,NULL,'a0abbd80b7b267e3a810509c3d6448e9e0e02d376199780998d8f11515612e09','3d1ab141366cc6d90385bc09cf7babb25580edd7209628d58f3371d4fd5d348b','aa4ac37b6e1b7003a862961fff43dd98f700ea0a680d97fb5286d98009a90402');
INSERT INTO blocks VALUES(310409,'01a719656ad1140e975b2bdc8eebb1e7395905fd814b30690ab0a7abd4f76bba',1419740900,NULL,NULL,'c0b147281b1be573eed3202159fb7de13ed318feca77aa737618096d44b63d4e','ce21ca4f5adbc758790048dba31ad6b3a8afe06066779d230064203612515ee0','803a75fced9da3b45c7547c5356671c846887977e03547c9338c2e74a0004063');
INSERT INTO blocks VALUES(310410,'247a0070ac1ab6a3bd3ec5e73f802d9fbdcfa7ee562eaeeb21193f487ec4d348',1419741000,NULL,NULL,'148150d63bddbbdbfbeca70efd1fe3a10a1927ed9ccd8af751428ef96f65d2a3','d798029092b32b65ff24e5bc581db49b6453ea557cf8f55b98568a8b617358e2','db1f8226f82740398754856ffb621d30b81a8a8f5fa311d83e64560c35b6b411');
INSERT INTO blocks VALUES(310411,'26cae3289bb171773e9e876faa3e45f0ccc992380bb4d00c3a01d087ef537ae2',1419741100,NULL,NULL,'62873e6029b234a5ebfbb36115a6649d166f033b0866b55f23b72d50c7c9dc4b','39f9c9aaadff81eeefe6b597797e98a40de855b307abd8c2e2c0bda1952b6ccd','185e69d30aa35ed0b1f35a2ae5df8db25073c54a2b6ba38c5ae6da5e6bd45736');
INSERT INTO blocks VALUES(310412,'ab84ad5a3df5cfdce9f90b8d251eb6f68b55e6976a980de6de5bcda148b0cd20',1419741200,NULL,NULL,'07d84c8451f40384cc6477b3d7a7cc77a3706a1202fa91aa666d65bcae2f6c79','c710c08e69b8ee90885720301cc23b7657bdd1bd5478b6aaf5cc26456dea5f94','e2ab3e4e53c786fb8f840d15596efca9de95abff8741813917d85b9ff27cc0c2');
INSERT INTO blocks VALUES(310413,'21c33c9fd432343b549f0036c3620754565c3ad99f19f91f4e42344f10ec79bf',1419741300,NULL,NULL,'c250faa6924719f9a69ccda12b724a89b6c174a76c10d0ef30bdbfe97a4bb670','adc86d73e2c50ac205f944405d6144cf612acca226dbbd063f54e5412a9158e2','4d295d3b8b50d8108fd798f1656928ef0d840f70a95623652fa143a41dcb246d');
INSERT INTO blocks VALUES(310414,'8cff03c07fd2a899c3bcf6ac93e05840e00de3133da14a413e9807304db854b6',1419741400,NULL,NULL,'3af437962a6bff2f041d6b5cc37626d7f72905c255b0c82c0b613c4b23a2093c','7781f0dafea5b5cc5a396960493130c3afb50d5c446104068d16c4149aa870c4','06d1206ff8acc124076a865d5d0605e3b8f2da10de2533a4490aa660ca92e750');
INSERT INTO blocks VALUES(310415,'dd0facbd37cca09870f6054d95710d5d97528ed3d1faf2557914b61a1fc9c1cc',1419741500,NULL,NULL,'1ee76faea1ed678ccf8212271c24a23b127fa10d7db931ca0d7fd611c81b87dc','cc5f94649f98ac1d7de3eb5fe31e81960e8943a5f9900b70045925ac0cee5824','027b24fa14f1e6dcc1695a75f028c6a257e31e7c54e7c0ce754058c08f95397c');
INSERT INTO blocks VALUES(310416,'7302158055327843ded75203f7cf9320c8719b9d1a044207d2a97f09791a5b6b',1419741600,NULL,NULL,'ae94c58180ab273351dd487f88ea95c48e3ce83aa6b9c937b32bd77d478916b2','90fe63fd8863242b4dca267634ba5d2f4d44be52b2a6a420e3c6e8fee4dff41c','aa62eb5c9a8ede2624a4590c44116d87c1b1a4f4aa40b7ec3b6f1b410e4d6e38');
INSERT INTO blocks VALUES(310417,'2fef6d72654cbd4ea08e0989c18c32f2fe22de70a4c2d863c1778086b0449002',1419741700,NULL,NULL,'087125f87e41305cded631570387e269bac5f078d7869f28d6f2b07adbfe0659','2695ee09b22949d478e6638a15994a933bec38b8f9bdb5dccfccaf384fd78832','402ae204ef8559bf6961273ab5c8fbb8a37dec89f0add380d7c6042b78d4bb68');
INSERT INTO blocks VALUES(310418,'fc27f87607fd57cb02ce54d83cec184cf7d196738f52a8eb9c91b1ea7d071509',1419741800,NULL,NULL,'45394e52924e44c23439f0b7fd6baf561b818865abb3ab3ecf6604c13330e653','dc0246d30d7fb32c4af3bc5df5596f56c6ab9c23f48e876bc91c9e097f51c183','4956cecd52ec3cf3d822706adefcbec4f47a8f4d34841b8a950b8a69c2a48b19');
INSERT INTO blocks VALUES(310419,'9df404f5ce813fe6eb0541203c108bc7a0a2bac341a69d607c6641c140e21c8e',1419741900,NULL,NULL,'005962cd4ac9de5b56bdf3349d30aa3378b918c385649feeb6919ecd8c07f74f','fcd58584b4d28c6702ff0a3fd27579f59b97058a8fc5fda7d91b3609d9400db6','19122a1ba6cba1d0af851392fa68836d12a8a5c7be7d37e0f1f5cece2fe4f716');
INSERT INTO blocks VALUES(310420,'138b3f1773159c0dd265a2d32dd2141202d174c2e52a4aeac3588224a3558372',1419742000,NULL,NULL,'7f9a5d9184fdf07167f020d395b76bcf47636485e5edaea97cd7fd002e2f78b4','eb7db10ca74000795a9284ac7a8e0b8ed1563995968e337247d370f821b0c7e5','86a48912b3d7c841bb834f39e164b954c9354122a7981967e573b292c693acda');
INSERT INTO blocks VALUES(310421,'71fe2b0e02c5cad8588636016483ddd97a4ef0737283b5fd4ab6ea5dc5c56b9a',1419742100,NULL,NULL,'1772637072c10448fad9742d6d5be9553c238de74a03c605ab116f8c7a7c9c61','45abc0644da5243da5d9533ea338462f0ea72c09084b93b2da4f7c84a35823d3','39b7f662e804ea0750ac7c8103e9fa3599f3abf23a50d11799aae90f3d9bea48');
INSERT INTO blocks VALUES(310422,'cd40260541b9ed20abaac53b8f601d01cd972c34f28d91718854f1f3a4026158',1419742200,NULL,NULL,'ff47f1b2555729c55139ce9b1b6ea1266e99af94c4fa25cf48a1da53a338a955','ae0b15238f1d97043f99c7415fc155410841937a3e30df0d37126ecf26a5d645','6580f98cd36d9cbec0df17a5c74af7e6522128c686bff10f08cf29d8cc9a04c2');
INSERT INTO blocks VALUES(310423,'6ca0d6d246108b2df3de62a4dd454ff940e1945f194ba72566089f98ad72f4db',1419742300,NULL,NULL,'579c355f0dc9b355382921a1d8d6c428f753bed2d0bd72a5296a9692562f76e5','07008ced0b05b1efdd1ad7f2a7e7ebf5ec18b9f651fdba464ebfdb453b17f016','7dcaeaf540a3eb72fdf70d40c50a16a36c75d501dd922746c6bc4182589b161b');
INSERT INTO blocks VALUES(310424,'ed42fe6896e4ba9ded6ea352a1e7e02f3d786bfc9379780daba4e7aa049668ad',1419742400,NULL,NULL,'beadc7a39ca24a321052ad70294f3fd6f58fd1690006f1dde468715e4fe9bfb4','d8685ce88a0680b8bc72a1e20862c245b2b1a289ee0e8f6249383debc7de1215','90b567c78a5505c36a97ee96ff81e04cd7bd33900ac65ea56899eb11091ae409');
INSERT INTO blocks VALUES(310425,'73f4be91e41a2ccd1c4d836a5cea28aea906ac9ede7773d9cd51dff5936f1ba7',1419742500,NULL,NULL,'2937b263b26041419bbfe116a76ce41f477f476ff06f57f74f8f0f62fdf7946e','005fed8ce5ffbfc7c772e26499a129ef5a32175c080994fef9da82f16f3b4a63','15e8d7eff8a1b397c751b57bd5632548a187d6c55cb59a7991fe569e151c5ea7');
INSERT INTO blocks VALUES(310426,'9d28065325bb70b8e272f6bee3bc2cd5ea4ea4d36e293075096e204cb53dc415',1419742600,NULL,NULL,'bc8f6fc4188f29a3988764b2796d72b2f56319b97a25a04d2b3bf77f533eb55f','7322b4065aff746d7aeab16fc2f499241e63823ec180a9d4a69ab3fb7039b246','108ab4877b652c9660b3c308cb3c24860d088a762a6662d2c665c990f08b456b');
INSERT INTO blocks VALUES(310427,'d08e8bc7035bbf08ec91bf42839eccb3d7e489d68f85a0be426f95709a976a2a',1419742700,NULL,NULL,'6344495f59b44df1f2cc1d1e8d1894177be2ba125395613b33cea426a9a4e632','a3fa8ca028d3fb27b2abcdc5bd15e2fe5f1d36a827754c9344290b3fc2b33506','b91dbd5c7033e45229144ecde1e07f14aa2251c476fd484d337e255280600709');
INSERT INTO blocks VALUES(310428,'2eef4e1784ee12bcb13628f2c0dc7c008db6aaf55930d5de09513425f55658a2',1419742800,NULL,NULL,'46059eee9a455e9fc16e269e980cd6550042d174a5ae15078e92910ac22e4c65','c7cb490f563979b361254de41f845112a6a825cde20fdc5fdfa51fed9e168d41','3437e1b547bb7b219999b58a9d78314b5978d3f58b09ba3734c3c4fd9e0166dc');
INSERT INTO blocks VALUES(310429,'086bfbba799c6d66a39d90a810b8dd6753f2904a48e2c01590845adda214cf8d',1419742900,NULL,NULL,'41c55d367cc32eb3043faf2d0d02e3873158b1d258fce7486cfac98cc10afee3','66cec5b386ad21b25f27126424e3c19fb04f29df6aa09da41f51d8ed2aff8e6c','2d6aabc7c5d9bb547d7001fad77c175d4dac841017791ed6688401b6be9052e7');
INSERT INTO blocks VALUES(310430,'870cf1829f84d1f29c231190205fe2e961738240fc16477c7de24da037763048',1419743000,NULL,NULL,'dcdd10435857eb03570c919e24702bbd9c7301d964e139c3f620dd8f2e41472e','6fa1ee0369f11cf0aaf91e824474a7f9b4973407fd2b1f6a849b7c78e9cc80d6','e2149883deba9a47b0f1af30d537bd46365e79109672f264a923952c3890b159');
INSERT INTO blocks VALUES(310431,'20b72324e40ffc43a49569b560d6245c679e638b9d20404fc1e3386992d63648',1419743100,NULL,NULL,'7f8f67904b764ecaf689ffbad5ba1376d72b332c68e95eab34668a5e0cba26ff','bcbdaf18a59d6eb79cef9b7493b1000f7b09290b43019790bb9c60fd2783c749','5be7c8c6f6e959cbde1ffc481b5760448b55653b113306d591021e907c371239');
INSERT INTO blocks VALUES(310432,'c81811aca423aa2ccb3fd717b54a24a990611365c360667687dc723e9208ad93',1419743200,NULL,NULL,'d427483e3cb4bc27918ae377f4d9e656330f49c96cc07afb158edeb943877e8f','68de5c9f4a04f9860780734c52f2c8a810e8afb67432bce15c60299c35abdf2f','e751533e50ba7e543d4d57bbe5aad9ca532b55998023aa527c0691064422e2ea');
INSERT INTO blocks VALUES(310433,'997e4a145d638ad3dcdb2865f8b8fd95242cbc4a4359407791f421f129b1d725',1419743300,NULL,NULL,'7bac28b6b022b2042a1e8760854a754c184097c850a0bf97986001dbd0c6f16c','4b6bcdcbb6f5785e57e5989f08b926e089ffa2dd45b6e02d7bb76ef20106d929','39c88ded2f5b59242ab775cefab2b47bdb28f7d4df5706412773edff7fa59554');
INSERT INTO blocks VALUES(310434,'61df9508e53a7fe477f063e0ff7e86fbb0aef80ff2ddedc556236a38f49ac4d8',1419743400,NULL,NULL,'ba194d4831e289cffec328e206d812b3042506d432bca7ca668954f1be7c358b','0c6a41439c6cd8fb4b166cec1c9d64b6fc09ab08df6eb06c1a35de3afd64becd','07bc92d81738e8f784ac7799d9d12c3d912b57edb3693677edac20de3b058196');
INSERT INTO blocks VALUES(310435,'f24cf5e1296952a47556ac80a455a2c45da5c0dc2b388b51d235a3f741793d5f',1419743500,NULL,NULL,'5d55758f402de733bddf868bfce53c3336bf2a5dc5117254395dd283eb41fef6','ba17a22e8af98e663a03491c666e0682286d74a8f1220b7bacb79a2f036099f1','6ba365949b852c132794054bef5d157a7be214d4f401478c41adb78dbc235e4f');
INSERT INTO blocks VALUES(310436,'a5e341ba92bdf9b3938691cd3aab87731eba5428bb61a804cecf9178c8da0c19',1419743600,NULL,NULL,'ba1afeb37eb04a8b1930e9df99b46d3524f5e0995c1840cd5ec3b654ed84dff9','7b67cfbe60debfd756ceb7d6cf46eb35c7553063afb7e60219b092b6b311e1f3','dad7c5834aa82a1d278feb19c98cd1914d0020038413210567f1017a96e62a41');
INSERT INTO blocks VALUES(310437,'9e18d0ffff2cb464c664cefc76e32d35752c9e639045542a73746f5ec2f3b002',1419743700,NULL,NULL,'5b6b68e19323516cf0f667cdcdb76032edebba25f4c05ed8f8bf59794daebbe2','cc384acb9f42c6c4e0f29518693688131b0a386454aaa7e5f7be5ed837f105b2','9b5dcf6d3a507427244907837586ca35299b0a7a0d2d102c138d0eba7ccd4a9c');
INSERT INTO blocks VALUES(310438,'36be4b3470275ff5e23ed4be8f380d6e034eb827ebe9143218d6e4689ea5a9fc',1419743800,NULL,NULL,'f32e75e202e6ad744a1db9a08347e262496bec23864cacc95a885ea66d8cf7e8','11d6a732388224226cc1c8a5ddf295c9f5ef2121e805adaf8d17468b72b588fa','e317d193ea24121b68f58765aec069f08e1f604109302e77613ea8318effc6b2');
INSERT INTO blocks VALUES(310439,'4f2449fce22be0edb4d2aefac6f35ce5a47b871623d07c2a8c166363112b2877',1419743900,NULL,NULL,'8f1590ab7077e5602afba2b23350226c77e2b40b65b3d3bfdc9b0a6fbb1703ec','eac575f567de9b0eae611cd447cbd8aa012f74edf556ebbd253f6377796c9b99','77b3b562e540d4b4d858171d2b53ad2057dd578e8463ae5d028be7c6f626f594');
INSERT INTO blocks VALUES(310440,'89d6bd4cdac1cae08c704490406c41fbc5e1efa6c2d7f161e9175149175ef12a',1419744000,NULL,NULL,'6e99b11d8b547b638f6416c6253a3d09602e9bd92ac23f73be19cf8f682dc34b','d3f915194065fd8ae412d4bb37ee49dbf387b6df9023bebae4b56a4ce8b902a8','a8514305498debd9270866ff678a7c24940ae01d78ed3f415940cf6123bd34c2');
INSERT INTO blocks VALUES(310441,'2df1dc53d6481a1ce3a6fee51ad4adcce95f702606fee7c43feda4965cf9ee15',1419744100,NULL,NULL,'bab32743583e540252ddc9ebce61ec7544d7bee1f9b3d573ffbd8986854dda9f','eb5f89ecc958e4f75301b2e91f3a54ebfb86019935602f8d36577946c893a469','6f4f01d222912eb1220c98a7cdbd7c5ba5ac68074d2113a8cf4cc86d12ae2472');
INSERT INTO blocks VALUES(310442,'50844c48722edb7681c5d0095c524113415106691e71db34acc44dbc6462bfec',1419744200,NULL,NULL,'a3aca5271bcae8d6abf24849078f880ed97d5176baeb1e932dbd107577721ad7','854ea4d47704b7238b32de1bc180ec5e48b37634b96cdf7fcac65491e0a6e568','c73ed9a62b1d87b5b98918104d422c2d294c530dd61468b0f670edd7d2f6b38d');
INSERT INTO blocks VALUES(310443,'edc940455632270b7deda409a3489b19b147be89c4d8f434c284e326b749c79a',1419744300,NULL,NULL,'41dae1231861b100873a1bf05414afa26fbb919952fbb9fc48c87cc527c901f1','b908c8905815b95d32271217fb1c0632857c5c97eb3d85fa4d266630fb4650c3','41a440b0c773076fc1486a97f27011a7d152b8822f55e46c9f5a1e3eeba6cf24');
INSERT INTO blocks VALUES(310444,'68c9efab28e78e0ef8d316239612f918408ce66be09e8c03428049a6ee3d32e4',1419744400,NULL,NULL,'bdce0a3621babb4dc5f72cdb521237601df07ff11ca4853cfc3467e3ab4ce030','e07c9e1ecb8a61b63b47e60c4704764d281cd01c5bd1b12bcfbc0dd6b6c0445d','55e2c8b344e01aa1385fcd65fc507ff5bdae65c94b56b765742e34cbed221582');
INSERT INTO blocks VALUES(310445,'22a2e3896f1c56aefb2d27032a234ea38d93edf2b6331e72e7b4e3952f0234ef',1419744500,NULL,NULL,'33b531179486087dee184623871aafbc382157390a8a8b73c5f2bceab84d74e9','f3e9509650d302994dfd211effc5166bc3193df76c7031f5ff47f61208e1144f','c63695456e73b0c71ef45e6e179a0424d20baf17801d838a29177d57e9584d63');
INSERT INTO blocks VALUES(310446,'e8b0856eff3efce5f5114d6378a4e5c9e69e972825bc55cc00c26954cd1c8837',1419744600,NULL,NULL,'4268811f97153ed8cfaf8447ef5db7a8480f48b660220aae426785814303e88e','c98d448fb0d9510da94fcc43f1375b990ea3476bb1588405e626bdc163c2883a','86149e6a416defeecd34b0ff773e6eae3fe4b4a8ac122e7980ef1e8e9f3d23ec');
INSERT INTO blocks VALUES(310447,'3f4bc894c0bc04ee24ed1e34849af9f719f55df50c8bc36dc059ec5fa0e1c8a8',1419744700,NULL,NULL,'20f3e0c010662f396197ed5dc7a5017c2eff9e91dd96cc9cb2946cdf0e55553d','d67dbe25474eaeeb8aa66e48da46a24d1595b649d6c2d9b79187ca42ef1c704f','1410cfd63afab53817f27ac2eef58cfd3316cefd6665cd819d198b1dc35d252e');
INSERT INTO blocks VALUES(310448,'6a6c7c07ba5b579abd81a7e888bd36fc0e02a2bcfb69dbfa061b1b64bfa1bd10',1419744800,NULL,NULL,'c04d24548f1f5ae9ad66a791179d7cbd38bf494a17efbfec6ea0011c3693ea8f','b5da0bb81c92901d9ebb940c28f404ddbc9c3d8d23c8e58847acdc5e1211f37a','373a82188d0cb36df5db8c10fdcac8a49e6817c5476edebd630caed44f199ae4');
INSERT INTO blocks VALUES(310449,'9e256a436ff8dae9ff77ed4cac4c3bfbbf026681548265a1b62c771d9d8e0779',1419744900,NULL,NULL,'8bea79fe7649bbb8e1fd15a4aa32ab883f2483daf892adc55f20b279395941ea','286578e813217361f93a2ebd735cce89f258fd9937c675b9b80238bf3c9143f2','f436b8e849f1001d9d42d8b06ebe71ce67f8050a73d79af4cdc576c75ad9803d');
INSERT INTO blocks VALUES(310450,'2d9b2ccc3ad3a32910295d7f7f0d0e671b074494adc373fc49aa874d575e36a3',1419745000,NULL,NULL,'bb02f3dd522e868d9e8a35bec3a6f691aec91f06ac55cbd351edc12ea1559acc','4aeb85a4dddf5feb5aa5eb195a0a54899d6735f9c45f7255dccd3c1e86b77e9a','06f54631f62e8e607327bdef060087f21a84291e6aedb5999bfb044739076a9f');
INSERT INTO blocks VALUES(310451,'55731a82b9b28b1aa82445a9e351c9df3a58420f1c2f6b1c9db1874483277296',1419745100,NULL,NULL,'e886613c331a5f0f2ebdb0c3c1ca230698f030fd019af0a9f1f0429c692c0a37','b9a47a42004b4fbbdaf23f9281480c7596a01b3d69dc626aa7a514a532998854','ea4698f05fa757a5bcfd1575e750bdfb38d151881cacdd4f416d8c999e991f14');
INSERT INTO blocks VALUES(310452,'016abbaa1163348d8b6bc497cc487880d469f9300374a72ecb793a03d64572aa',1419745200,NULL,NULL,'a3557ed5cc33c99057c12f3e838c2ef2de1192e14fc560ab788da22788f24372','e4855f97963d18b7fc3d80a07dbdcf2fdb3265e5edbcacd5aea2f2a5dcccecb9','2fd25f604773b374577f17d6fa914a005b61524d84e290432c425c9f01517988');
INSERT INTO blocks VALUES(310453,'610be2f49623d3fe8c86eacf3620347ed1dc53194bf01e77393b83541ba5d776',1419745300,NULL,NULL,'3d17bd4b5cba1d7f3756b324196b752e89735e526a88bd3fdb08fd82bb4d9ba0','b07620f88d69dbd9342e188739f46a3278e370304310de87eb2c829194d14d9f','2b6c2db5900192fc192f068f5d61aeb5196b1caba15e86cdd4b801fdd2fd08a8');
INSERT INTO blocks VALUES(310454,'baea6ad71f16d05b37bb30ca881c73bc48fd931f4bf3ac908a28d7681e976ee9',1419745400,NULL,NULL,'388ad9c7d9c19b5dbcfcb196ff3931b39c797c0c66e997db25d4674c294a052e','fcac5a5aba02d75ac066b929c833c686e4227c8eff01eba0fcd4948813ec732c','7571b7232785c00acec0951f62c56044694f0fbee3934d00106d86bdc495dfbf');
INSERT INTO blocks VALUES(310455,'31a375541362b0037245816d50628b0428a28255ff6eddd3dd92ef0262a0a744',1419745500,NULL,NULL,'c6d6f05fb4c0190dfc8be458dc18e243fff2bef2f2e4f10305b96d5b2db3f2d4','d0e67e0fbb4d5e4000f69b08fb09aa33e4658cc9b71bb7c43f1671a1f1809ab7','c2c95be5c273c61366b6190b8c1eaf444e8730be8262484598d331c540ff38d1');
INSERT INTO blocks VALUES(310456,'5fee45c5019669a46a049142c0c4b6cf382e06127211e822f5f6f7320b6b50fa',1419745600,NULL,NULL,'02cd1b00c081aec0ba98ccf83363abb768cd6025d92a22c10b24d412a4bf432c','53b6ffb3d2ccd1e2b1c089351704287edad4bc82c5e674bd9ed17a349e8022cc','b389cdf45dc4a718a5915926a2464a1ce09efe279cae20a2d7e67c293cd82bb6');
INSERT INTO blocks VALUES(310457,'9ce5a2673739be824552754ce60fd5098cf954729bb18be1078395f0c437cce9',1419745700,NULL,NULL,'02d0256b5ebc6c7af351231266a757ef9f94388406894f75b51fc29c988f0ff1','a349a38c466e8f355dc3d0597417c9ba4ee2f9060cd001186905405edb516f03','9cbfdbab8112097d4b08d38fad1366cec61dfd4b89ce02c488d6ef61cf41a096');
INSERT INTO blocks VALUES(310458,'deca40ba154ebc8c6268668b69a447e35ad292db4504d196e8a91abdc5312aac',1419745800,NULL,NULL,'90d0c41e7373863c245aebf29e40047103e27308af90bb6698047f7dc60cd175','15871a60b18ca55df953873fb61590b35a29b1a4aaece1a5350dbe031cd46568','a2284a63cc0ea4e5297b3de1aa626061700dbfcc7bc4bae39f88fe6155afe2a1');
INSERT INTO blocks VALUES(310459,'839c15fa5eea10c91851e160a73a6a8ee273a31ab5385fe5bd71920cbc08b565',1419745900,NULL,NULL,'1fba116191ed2918e694e9b3e08f351278881c5b0f67b0c757cc0e3516752d30','7ddf0f159bb07008dbfb5b731f3744de9acb9f22a263f6e6d7f306716ecaf8d6','5ce204c9e9bd78f5621219f01fa6e315aea359f4ea5c6b96ec7b3331973c9249');
INSERT INTO blocks VALUES(310460,'9b5f351a5c85aaaa737b6a55f20ebf04cafdf36013cdee73c4aaac376ad4562b',1419746000,NULL,NULL,'4f85b2219332b899db3ddd936caba34275127f31fc751a93a9ad87ce96c88215','2a8477ffb0344d67510daed17b33a66fffe64dd31d3fd8bb10140a4f6403cda1','aceb7cb0e3b7f4b36fd023775c14a2584e738d379bd2c3e5fbbf664cbd7f8401');
INSERT INTO blocks VALUES(310461,'8131c823f11c22066362517f8c80d93bfc4c3b0a12890bdd51a0e5a043d26b7b',1419746100,NULL,NULL,'1357bc1c5354586ac80e270bb9290c4027346ad5fed22b0b0d065442858ff588','5de05fc8c021a08d767e0e6fbeeab49f80bcabd4ff5e1a60a58c9b2e9e4c417d','8b204dbd4b1f45161b663909fec80e86a9d517c2d27cdb333ca398d66fb6d74a');
INSERT INTO blocks VALUES(310462,'16f8fad8c21560b9d7f88c3b22293192c24f5264c964d2de303a0c742c27d146',1419746200,NULL,NULL,'080835308cf3374fc5e5c1bccc0329cf66cb86722f49949189cc104203a7cbff','d738ed7c3c9b4609f771fa1968ee5971bc7286baf9fb3585a19bfabd7a448e13','d30def07fb3d2aa9ebe6e2fcff69b9fe275adeaefb5660ad02dd092413bf1637');
INSERT INTO blocks VALUES(310463,'bf919937d8d1b5d5f421b9f59e5893ecb9e77861c6ab6ffe6d2722f52483bd94',1419746300,NULL,NULL,'f02c38f61a006d7c7039d2e671c57acd4afce3a00b6258b052bef48aa29ca521','98329e74802a736be70af0ae15a8f4087332c74412659343a28a413246c4d84e','f9e57084375fde1f6c4e9314161d57372a0f42f0ad3cb19aacb4a0734495057d');
INSERT INTO blocks VALUES(310464,'91f08dec994751a6057753945249e9c11964b98b654704e585d9239462bc6f60',1419746400,NULL,NULL,'22ae1fb9e4af0a695dcb88e56c8f4d7eec2746187365c89afd832681430bc23b','9252495869ca2ced3aa6dfdad589c4f7ca08b7ae34947df3378aec51801f90d9','8b07e6d4b854b09b1209f02a0de4d908a9e832fae229c1b3bf364dffeae6fefc');
INSERT INTO blocks VALUES(310465,'5686aaff2718a688b9a69411e237912869699f756c3eb7bf7c3cf2b9e3756b3d',1419746500,NULL,NULL,'62f54384f9f08bf3c265f805f82ecf757d837d62b0f1301f26181ecc8117ee55','6782998b7919cd1fca2a66eb57e76780e101f1f1f188e73109a3a73e5fb10531','d081254d672ac92ac1dda4a8e0fdd74367861e80aeb954548f989ea82ed526a3');
INSERT INTO blocks VALUES(310466,'8a68637850c014116da671bb544fb5deddda7682223055a58bdcf7b2e79501fc',1419746600,NULL,NULL,'169ee809df2bc233fcaaec54fefd9336b947437bf2f8463f336c502a70b5ae28','38c1195a2c99dfda9cbae5c7b7c18503dc7527df7bc83433083852d249f40cd0','e99f2d287a8f5733be49ca2444b997ab23c980c37c50d147915b0086722f29be');
INSERT INTO blocks VALUES(310467,'d455a803e714bb6bd9e582edc34e624e7e3d80ee6c7b42f7207d763fff5c2bd3',1419746700,NULL,NULL,'250480aae586b44f89f785e82963cc643988a8d7ac411e30cb0bfc2bc93fd0be','23d8c5f673e028a7fd5d178d8812334201cba2da77f1bb034a2fe0f837398fac','615be9c33b9bc693d766816a588a9cee47cb20989dc4e00b7988e92ddd6baafc');
INSERT INTO blocks VALUES(310468,'d84dfd2fcf6d8005aeeac01e03b287af788c81955612375510e37a4ab5766891',1419746800,NULL,NULL,'84dd455a2a56ccf3e98ce29d09960f4b75e2bfee867ea56dd52aac798351b855','43001c5cd5009de20e0b519007f33dc521e8113a9b3f4a0a73ae6f69c39dba7a','e9aa4ca66fd5fb21764ec8aed9e88baae5fa2d16275df7be462026ebd63fdb63');
INSERT INTO blocks VALUES(310469,'2fbbf2724f537d539b675acb6a479e530c7aac5f93b4045f4356ea4b0f8a8755',1419746900,NULL,NULL,'5e7bc7c69237853df8468b493e25434862d80789babf9231b657214bbc787a38','085634952c820ffc24e7961fe20c5d9dd8d55a7ddfe8a62dc3ada1dd6e386b35','56652de81693e44f9fd32cee9b77e8b1aaf9d605f6601c79bfb975f710d85c03');
INSERT INTO blocks VALUES(310470,'ebb7c8e3fbe0b123a456d753b85b8c123ca3b315da14a00379ebd34784b28921',1419747000,NULL,NULL,'eafb111c574ffbfcbd764bbeda43e2fc2c609fbb9c99bf228568e2f86617dd68','e37c99990491c606a69871ebfdfd8c00bf87fec4d80466d56425c3a52f8090b5','f8a904e37fa7fb5f753811258cbfd6f1b5e5d44ea974f5348ab2d02b84b18c86');
INSERT INTO blocks VALUES(310471,'fc6f8162c55ecffeaabb09f70f071fd0cb7a9ef1bccaafaf27fe9a936defb739',1419747100,NULL,NULL,'4e306cf455b3782486fc7409fd5e6a47478a865e112d7771c5b85dc79e128872','186269f76cc2621d27f925b7be3f711b6f177263e6f1d58fec1c411baa235b51','be9bab87fc5a08d03c7c6ac82be8392d379bce784462769752dd6a7111343e63');
INSERT INTO blocks VALUES(310472,'57ee5dec5e95b3d9c65a21c407294a32ed538658a6910b16124f18020f16bdf7',1419747200,NULL,NULL,'6078c1609ae56dbca8d2b6838bd83637d08810ee8aa146067f0dcab0b7a665fe','e9dd2ff54e29301744d27bb88f53ec75326c3c14d15d67922afb39b84d3156da','a4fa4c10a6f02646ac286a8c62f573ea919bbadd2cc6f65b388af7831bee6b11');
INSERT INTO blocks VALUES(310473,'33994c8f6d06134f886b47e14cb4b5af8fc0fd66e6bd60b3a71986622483e095',1419747300,NULL,NULL,'d30965995e0047d2fcff798d804eb8678ea54c8b01bb9edb6cfa71d5a69c3038','a72a530df885473ba62e214ab9723c456fec9aba5415ea96e6b867b521dcbf01','ece835033f44c4e2e0e11997059811f6899a57f1410441aba6605bd4263971e9');
INSERT INTO blocks VALUES(310474,'312ee99e9526e9c240d76e3c3d1fe4c0a21f58156a15f2789605b3e7f7794a09',1419747400,NULL,NULL,'7efb007f3e4221cb4069ba39b428dcee2ac4e0afc604b11e646bdea4285962b4','3d0f0acc5ff39e4577b8452c8170a42c3c62dd13f24c108d679ec8aa67e593fb','c501b9438b1d65407807fe15c4277775041c0ebb1098e73d49a8cc3feb0c6621');
INSERT INTO blocks VALUES(310475,'bb9289bcd79075962117aef1161b333dbc403efebd593d93fc315146a2f040eb',1419747500,NULL,NULL,'1e4cd7edd7eccf95ee8babe92f82294c96e39b31f5491e1860befbddd6f2fd4e','dc2b74df4a447858b234551292a581a27c7d65cb6c8f945a8a19bb73da473cde','ceb9f65b5c9e67b0d8cde54e5b6e028e486946151f1d43668521918d2b7eaa45');
INSERT INTO blocks VALUES(310476,'3712e1ebd195749e0dc92f32f7f451dd76f499bf16d709462309ce358a9370d0',1419747600,NULL,NULL,'dd712c053c30a77475d0e95f10a5152cc42ba2c3935799ecadd3b7e33e47d18f','c84289ded1bd94a361cc3b4d4d65f4a32348fab8b6a588b03d6b03bc024725b5','ae395caf302530385c65701a75054b556d8cfe18ee28f9c79561f86153d0a36c');
INSERT INTO blocks VALUES(310477,'7381973c554ac2bbdc849e8ea8c4a0ecbb46e7967d322446d0d83c3f9deab918',1419747700,NULL,NULL,'4e8da84a358d640a3f2f5b73c1a1d937a627e684dfbc0af08e9356f6333c67ef','d8ee2baddf42b2aec0108fe2bcf27ca23454dcb54869ab9a6321c14f858c28bf','c0dad834ea1cddeea3f0c4a164a9afdcf8e6ae4a1018f94b40c0db6ff0eb63bf');
INSERT INTO blocks VALUES(310478,'c09ee871af7f2a611d43e6130aed171e301c23c5d1a29d183d40bf15898b4fa0',1419747800,NULL,NULL,'7e4e5198c91d4213fc4d11d08a758533fc837247abcdf08d857ab41895b2deea','b0ce36ac23861e0a90c52af879462faef274d67daae83418bdeb4e20ffa2fbc2','970c80b53853e7559909d88ffab4d21304ccd396fe080367106de657902e1ec6');
INSERT INTO blocks VALUES(310479,'f3d691ce35f62df56d142160b6e2cdcba19d4995c01f802da6ce30bfe8d30030',1419747900,NULL,NULL,'345b129524a60520209fef94ede2be0ac2a01f1f6bf3aae824ffd3e88d4fd4f0','48b4ae4bab76450a0b55679a6c53f0e6913a2ca3f35e3f3f824664cfc1622dc1','6afc55d7b297a5012801546aeb4d851fd7b860f92cfb95c693d13a36b12de8d9');
INSERT INTO blocks VALUES(310480,'2694e89a62b3abd03a38dfd318c05eb5871f1be00a6e1bf06826fd54d142e681',1419748000,NULL,NULL,'529c4ceedb9aba2a402029c611c55727f96829d499fa342569704faaacc30d9c','08ed93e4f756e0a1706678ba2535ecad7fb8e0ff7159ee365597b176e377501d','d145e65832158b7a478f50b37edb90b15ce3801bc3913d5672416991072722ad');
INSERT INTO blocks VALUES(310481,'db37d8f98630ebc61767736ae2c523e4e930095bf54259c01de4d36fd60b6f4a',1419748100,NULL,NULL,'d876a6e67a92a8aae079a7e88a6b6c6af9743edadfdc4061946ff692fb2cbca3','00cf0baecf9e6dfeffe1093d8e92fa5fa21ab8d9f9716044d6231d62ea74e3bb','4400eb6603fde08a1159b58fd5ccbed4dfa034789eefddeda310d8e308d0c372');
INSERT INTO blocks VALUES(310482,'2e27db87dfb6439c006637734e876cc662d1ca74c717756f90f0e535df0787d6',1419748200,NULL,NULL,'bf61a5aa7038140b96fa4efae0eff1c764b0805cd5417544527e33655bbc47ea','9b074103c1b746ca986ccd0fd2cace88fd28a701aa159bb8923f93f3e0ddca9d','821a261e2c3acfc4d1c1479b23d9749317c93406a987e5669cfda88de8177dca');
INSERT INTO blocks VALUES(310483,'013bac61f8e33c8d8d0f60f5e6a4ec3de9b16696703dea9802f64a258601c460',1419748300,NULL,NULL,'e5ac2ef725be86eb3144c7dd2fbdd1c58bb3070315f6635b5c45f9292ec1230f','8780d2bc1fa3ef920d556905d9f18b25b150b924c823c0311e8edc3d1af3b5bd','dc6916b1a9121e7c1628def8c172cf849985d53ee62e6cb466129d2a2aca34a5');
INSERT INTO blocks VALUES(310484,'7cac2b3630c31b592fa0497792bed58d3c41120c009471c348b16b5578b3aa2b',1419748400,NULL,NULL,'1205589e7c08c80b88b0e7319cd59aac98cdd3fd15039a331faaad6940e5e4c7','09205c9d3f0eaae1d9fa3e02c4300b8ec70b1e35ee90b68bab02789644c4b5ef','e227add8716c5e2d5fc9be3fe16abecb5b542cdf44b08a9e933fcd3ce2257a8b');
INSERT INTO blocks VALUES(310485,'eab5febc9668cd438178496417b22da5f77ceaed5bb6e01fc0f04bef1f5b4478',1419748500,NULL,NULL,'b3e79b34935a4f429efe9abf5cf94eb4a3e4dde74e228c3619bef1471080fc2b','5b948211698278221a8e2b4b1440f048cb3a1ff67ee567c048a79faeaccb6bde','1bc1ff29b38f34dd42765472e7eccdae04b0ffd662747d5be198cd6500c4cf96');
INSERT INTO blocks VALUES(310486,'d4fbe610cc60987f2d1d35c7d8ad3ce32156ee5fe36ef8cc4f08b46836388862',1419748600,NULL,NULL,'de929494279e3051185a505f835538e91c0ebcf15f628c2fc396f31c8d24db18','5315eacf9f90b87ea41053d62c7f67281c8d085c017b1a55a45a82fe4d44438e','4286a8c5439211f7140d7df91e802aff97063f1ed0dc12d945e1a93c3458c802');
INSERT INTO blocks VALUES(310487,'32aa1b132d0643350bbb62dbd5f38ae0c270d8f491a2012c83b99158d58e464f',1419748700,NULL,NULL,'06df732d43b7d1ed3ba2b8dc34bc0c562442f19e07b5375d6a1b77c5a029c044','3ef1a3b79f8fd3f857f6301f4aec63e130f544ad7402550e064377865a7e1bc5','35f6928a429fd1c1c913cf15c4dbb8eaf34ac5ec8a9cec32b87893da393b6b28');
INSERT INTO blocks VALUES(310488,'80b8dd5d7ce2e4886e6721095b892a39fb699980fe2bc1c17e747f822f4c4b1b',1419748800,NULL,NULL,'272590c131e4f11463a48b4ef9bdc7e13a1cfce72e962b4d3a244ad75d246494','76c80d327e40e0884a00a7ce5934ae1e699d6e6869982d133ca73c40fab1303b','bdf72294c490d94e33a74da7171f6238c4f6113088e3ae03313bf2b400869e31');
INSERT INTO blocks VALUES(310489,'2efdb36f986b3e3ccc6cc9b0c1c3cdcb07429fb43cbc0cc3b6c87d1b33f258b6',1419748900,NULL,NULL,'521acc7489bd646f67aed1f2a2d2bacb46e63d5b1411f15078c216f29e34542f','43332507cdde6280c69432180c3c39295fc730ebf51eceacb0fb018fb9fa1bc6','c318bc6fe63d8e4931a59939321839d35ba7882d997540fe7c1bbc8670602049');
INSERT INTO blocks VALUES(310490,'e2cb04b8a7368c95359c9d5ff33e64209200fb606de0d64b7c0f67bb1cb8d87c',1419749000,NULL,NULL,'a2c1c707e36bda1f59f33988b9a3eb73c3a43667a3dc076bf631859d16639a30','36ffab07c053b1fc50f36d75a5cd32c23d6317d3ad39e4e65551ecc97d26ac17','5162ae72fa65b12b4de2f7b130f1c36ce80717b913f80ee0ee5263ade7f71f81');
INSERT INTO blocks VALUES(310491,'811abd7cf2b768cfdaa84ab44c63f4463c96a368ead52125bf149cf0c7447b16',1419749100,NULL,NULL,'806ae6d351cccfd9723992c532048448bbeb96309ff8be3f09293b0b4be61a87','dd88f0f68f8f0558fa6e71659544f254541dd4ec4108ff59064c0ce0fc6d9278','a92441da74eb074d86d9749d5267c8a3047a4bb8a76ec7e468f7c9881e02d54e');
INSERT INTO blocks VALUES(310492,'8a09b2faf0a7ad67eb4ab5c948b9769fc87eb2ec5e16108f2cde8bd9e6cf7607',1419749200,NULL,NULL,'13bbb77d047269d5690ef785f2425407cb40e1f608da63b2f0953a91dfe7d023','61cc1aa7338982ef97aa166185fc4558dd6221544508be2d045faede8b5c58b3','a52d65cc81b0c4c0185963e4969d3cb3849d9c63161d6866bac11e1cc66652e5');
INSERT INTO blocks VALUES(310493,'c19e2915b750279b2be4b52e57e5ce29f63dffb4e14d9aad30c9e820affc0cbf',1419749300,NULL,NULL,'f37fbaf11f17168e56f24739f826b4f07199d45e96a1aa0df26b3e2d0c5b4d62','8ef0d76363ccbe128fbafa937f6edb040f3b59d158c673a6f29f71fd9d1165a5','6b0e888ba4a9264cc952a1b82e34e98742ed75676f6510b019614b9021f407f0');
INSERT INTO blocks VALUES(310494,'7dda1d3e12785313d5651ee5314d0aecf17588196f9150b10c55695dbaebee5d',1419749400,NULL,NULL,'774580e80da60958332c2f98e33583176c30f6659dd23d6c92738266d6e8e59e','879b3d41f13d9d74cde94f223034bbcbc44b99518d025a987b71d72fcc49992a','77596523979dc12df13923ada78fdf3b97df3b747883e16cb2edf5e593b60472');
INSERT INTO blocks VALUES(310495,'4769aa7030f28a05a137a85ef4ee0c1765c37013773212b93ec90f1227168b67',1419749500,NULL,NULL,'7df39feb9cda6a209677b594fe26d1afbf343dfa51111b2d891e349f4ce7f43e','b9254c651d7ddff7a64bc015f8421934f43b23715b2471dcaa8f74aec68100eb','6ba341dec631f23ec7b11a92cb54cb75062c354a3b05952099c21f9c0225bbf1');
INSERT INTO blocks VALUES(310496,'65884816927e8c566655e85c07bc2bc2c7ee26e625742f219939d43238fb31f8',1419749600,NULL,NULL,'61b21cbdaa1abef70a141b7dc73e691d965e28632f321483bc9785de7bc856ec','f20c43dafb2c92a329be30e7ac23c234597142fa2aa18fe6ed679ab28cf88b9e','3b59420ed706020d727b97eff5b82bc34722fa3c867ecd80a07e2ee7728e5838');
INSERT INTO blocks VALUES(310497,'f1118591fe79b8bf52ccf0c5de9826bfd266b1fdc24b44676cf22bbcc76d464e',1419749700,NULL,NULL,'5f975c481f44deccca88e1d6b29e0ac33cfc5323c53482a071a00920b733de92','f9bc2df349a20f71dcc937d1563ffeca5c02f516afe15693f7b4c99776184aa3','d1d0eb2a7b221e0e56ad510faba8a7ba554a1b95d728cbf3b6f62cdb0a8fcfde');
INSERT INTO blocks VALUES(310498,'b7058b6d1ddc325a10bf33144937e06ce6025215b416518ae120da9440ae279e',1419749800,NULL,NULL,'f4a54c210aa34fed1920d62ecedbb0bed8bd556fefb578350d6d36478e406f7f','629d39cd6fa52945f0cae97afbb1f6a66680e6b1fa6c81506fdd62babcdf088c','3e389a61190846978b89489f8cd400ab00e7e0b577f0ac5727faec4d93f112c4');
INSERT INTO blocks VALUES(310499,'1950e1a4d7fc820ed9603f6df6819c3c953c277c726340dec2a4253e261a1764',1419749900,NULL,NULL,'d177887e484eabe6d3027be050ff59b860f64e9d8583cfd83fb0b498912062d0','c4dd666c4447726cd07dde898790126f64f315ae6acfad6686d3fa17b51d50dd','9b7bb4ecbed23f9f24867e2cf7ec703b183f3ae552bc96a947b3a94d5022bf1d');
INSERT INTO blocks VALUES(310500,'54aeaf47d5387964e2d51617bf3af50520a0449410e0d096cf8c2aa9dad5550b',1419750000,NULL,NULL,'bdbe09deb9b4f5fedd65cbe8916d6d6b63424366ab9b81c47f4c5c2ee89c2341','9f830f77cc8f1d041bef6d94875a2ed663ae2b0faa1a2580089c6705c31fa7dd','31092e4d365958acc49e176f08c75a9a49ee71e37890ccfe076ff9efe798518f');
INSERT INTO blocks VALUES(310501,'9d9019d15a1d878f2c39c7e3de4340a043a4a31aebb298acdf8e913284ae26ba',1419750100,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO broadcasts VALUES(18,'9b70f9ad8c0d92ff27127d081169cebee68a776f4974e757de09a46e85682d66',310017,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',1388000000,1.0,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(19,'f6548d72d0726bd869fdfdcf44766871f7ab721efda6ed7bce0d4c88b43bf1cf',310018,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH',0,NULL,NULL,NULL,1,'valid');
INSERT INTO broadcasts VALUES(103,'18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e',310102,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',1388000002,1.0,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(110,'d858c6855038048b1d5e31a34ceae2069d7c7bc311ca49d189ccbf44cee58031',310109,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',1388000002,1.0,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(112,'9d70aa209efe54d0ac6f497e2553386b0095cced5a5e2bbac93cf4e4be73c517',310111,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM',1388000000,-3.0,0,'4INITVOTE TESTSCENARIOPOLL XCP 311501 OPTS TRUE FALSE',0,'valid');
INSERT INTO broadcasts VALUES(113,'22b9d1b536f079c1f0c435fdc33f41bcb21fa7bc4579944033fdbafc89a56c33',310112,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM',1388000001,-3.0,0,'CASTVOTE TESTSCENARIOPOLL TRUE 70',0,'valid');
INSERT INTO broadcasts VALUES(487,'f847362f6669c558922032a575b57da93af5e367ab7ba3154b71587cbbb50551',310486,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM',1388000100,1.0,5000000,'Unit Test',0,'valid');
INSERT INTO broadcasts VALUES(489,'93ff662d6409f5a2b381e76fdd659a7dffee6fada7869574de201d29fa2b15b4',310488,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM',0,NULL,NULL,NULL,1,'valid');
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
INSERT INTO burns VALUES(104,'6e96414550ec512d2272497e3e2cbc908ec472cc1b871d82f51a9a66af3cf148',310103,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM',62000000,92999138821,'valid');
INSERT INTO burns VALUES(105,'1f4e8d91b61fff6132ee060b80008f7739e8215282a5bd7c57fe088c056d9f72',310104,'munimLLHjPhGeSU5rYB2HN79LJa8bRZr5b',62000000,92999130460,'valid');
INSERT INTO burns VALUES(106,'3152127f7b6645e8b066f6691aeed95fa38f404df85df1447c320b38a79240c6',310105,'mwtPsLQxW9xpm7gdLmwWvJK5ABdPUVJm42',62000000,92999122099,'valid');
INSERT INTO burns VALUES(107,'bcf44f53dc42ae50f3f0f2dc36ff16e432ddbc298f70ec143806cb58e53d4403',310106,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',31000000,46499556869,'valid');
INSERT INTO burns VALUES(494,'d6adfa92e20b6211ff5fabb2f7a1c8b037168797984c94734c28e82e92d3b1d6',310493,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH',62000000,92995878046,'valid');
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
INSERT INTO credits VALUES(310001,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','DIVISIBLE',100000000000,'issuance','82e357fac0f41bc8c0c01e781ce96f0871bd3d6aaf57a8e99255d5e9d9fba554');
INSERT INTO credits VALUES(310002,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','NODIVISIBLE',1000,'issuance','6ecaeb544ce2f8a4a24d8d497ecba6ef7b71082a3f1cfdabc48726d5bc90fdca');
INSERT INTO credits VALUES(310003,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','CALLABLE',1000,'issuance','a36a2d510757def22f0aa0f1cd1b4cf5e9bb160b051b83df25a101d5bb048928');
INSERT INTO credits VALUES(310004,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','LOCKED',1000,'issuance','044c9ac702136ee7839dc776cb7b43bbb9d5328415925a958679d801ac6c6b63');
INSERT INTO credits VALUES(310007,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','DIVISIBLE',100000000,'send','d21d82d8298d545b91e4467c287322d2399d8eb08af15bee68f58c4bcfa9a5f9');
INSERT INTO credits VALUES(310008,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',100000000,'send','e64aac59d8759cde5785f3e1c4af448d95a152a30c76d97c114a3025e5ec118b');
INSERT INTO credits VALUES(310012,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',300000000,'send','d4428cf4082bc5fe8fed72673f956d351f269a308cf0d0d0b87f76dd3b6165f4');
INSERT INTO credits VALUES(310013,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','DIVISIBLE',1000000000,'send','97aaf458fdbe3a8d7e57b4c238706419c001fc5810630c0c3cd2361821052a0d');
INSERT INTO credits VALUES(310014,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','NODIVISIBLE',5,'send','29cd663b5e5b0801717e46891bc57e1d050680da0a803944623f6021151d2592');
INSERT INTO credits VALUES(310015,'1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','NODIVISIBLE',10,'send','b285ff2379716e92ab7b68ad4e68ba74a999dc9ca8c312c377231a89da7e9361');
INSERT INTO credits VALUES(310016,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','MAXI',9223372036854775807,'issuance','cd929bf57f5f26550a56ba40eecd258b684842777dfc434a46b65a86e924bf52');
INSERT INTO credits VALUES(310020,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',0,'filled','90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5');
INSERT INTO credits VALUES(310020,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',0,'filled','90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5');
INSERT INTO credits VALUES(310021,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',9,'recredit forward quantity','be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5');
INSERT INTO credits VALUES(310021,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',9,'recredit backward quantity','be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5');
INSERT INTO credits VALUES(310103,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','XCP',92999138821,'burn','6e96414550ec512d2272497e3e2cbc908ec472cc1b871d82f51a9a66af3cf148');
INSERT INTO credits VALUES(310104,'munimLLHjPhGeSU5rYB2HN79LJa8bRZr5b','XCP',92999130460,'burn','1f4e8d91b61fff6132ee060b80008f7739e8215282a5bd7c57fe088c056d9f72');
INSERT INTO credits VALUES(310105,'mwtPsLQxW9xpm7gdLmwWvJK5ABdPUVJm42','XCP',92999122099,'burn','3152127f7b6645e8b066f6691aeed95fa38f404df85df1447c320b38a79240c6');
INSERT INTO credits VALUES(310106,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','XCP',46499556869,'burn','bcf44f53dc42ae50f3f0f2dc36ff16e432ddbc298f70ec143806cb58e53d4403');
INSERT INTO credits VALUES(310107,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','PAYTOSCRIPT',1000,'issuance','63145ad2bcc7030aabcfec42a5cce5dfe6829a5694fc0b3566406bb2fd8b6444');
INSERT INTO credits VALUES(310108,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','DIVISIBLE',100000000,'send','075b91828d0c7b0017f1b5876ef4909ba37db9bc2877588483d8a64bad2bd412');
INSERT INTO credits VALUES(310493,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','XCP',92995878046,'burn','d6adfa92e20b6211ff5fabb2f7a1c8b037168797984c94734c28e82e92d3b1d6');
INSERT INTO credits VALUES(310494,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','DIVIDEND',100,'issuance','084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e');
INSERT INTO credits VALUES(310495,'mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj','DIVIDEND',10,'send','9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602');
INSERT INTO credits VALUES(310496,'mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj','XCP',92945878046,'send','54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef');
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
INSERT INTO debits VALUES(310001,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',50000000,'issuance fee','82e357fac0f41bc8c0c01e781ce96f0871bd3d6aaf57a8e99255d5e9d9fba554');
INSERT INTO debits VALUES(310002,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',50000000,'issuance fee','6ecaeb544ce2f8a4a24d8d497ecba6ef7b71082a3f1cfdabc48726d5bc90fdca');
INSERT INTO debits VALUES(310003,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',50000000,'issuance fee','a36a2d510757def22f0aa0f1cd1b4cf5e9bb160b051b83df25a101d5bb048928');
INSERT INTO debits VALUES(310004,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',50000000,'issuance fee','044c9ac702136ee7839dc776cb7b43bbb9d5328415925a958679d801ac6c6b63');
INSERT INTO debits VALUES(310005,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',0,'issuance fee','bd919f9a31982a6dbc6253e38bfba0a367e24fbd65cf79575648f799b98849b4');
INSERT INTO debits VALUES(310006,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',100000000,'open order','074fa38a84a81c0ed7957484ebe73836104d3068f66b189e05a7cf0b95c737f3');
INSERT INTO debits VALUES(310007,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','DIVISIBLE',100000000,'send','d21d82d8298d545b91e4467c287322d2399d8eb08af15bee68f58c4bcfa9a5f9');
INSERT INTO debits VALUES(310008,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',100000000,'send','e64aac59d8759cde5785f3e1c4af448d95a152a30c76d97c114a3025e5ec118b');
INSERT INTO debits VALUES(310009,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',100000000,'open order','a9f78534e7f340ba0f0d2ac1851a11a011ca7aa1262349eeba71add8777b162b');
INSERT INTO debits VALUES(310010,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',100000000,'open order','b6db5c8412a58d9fa75bff41f8a7519353ffd4d359c7c8fa7ee1900bc05e4d9d');
INSERT INTO debits VALUES(310012,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',300000000,'send','d4428cf4082bc5fe8fed72673f956d351f269a308cf0d0d0b87f76dd3b6165f4');
INSERT INTO debits VALUES(310013,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','DIVISIBLE',1000000000,'send','97aaf458fdbe3a8d7e57b4c238706419c001fc5810630c0c3cd2361821052a0d');
INSERT INTO debits VALUES(310014,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','NODIVISIBLE',5,'send','29cd663b5e5b0801717e46891bc57e1d050680da0a803944623f6021151d2592');
INSERT INTO debits VALUES(310015,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','NODIVISIBLE',10,'send','b285ff2379716e92ab7b68ad4e68ba74a999dc9ca8c312c377231a89da7e9361');
INSERT INTO debits VALUES(310016,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',50000000,'issuance fee','cd929bf57f5f26550a56ba40eecd258b684842777dfc434a46b65a86e924bf52');
INSERT INTO debits VALUES(310019,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',9,'bet','be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd');
INSERT INTO debits VALUES(310020,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',9,'bet','90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5');
INSERT INTO debits VALUES(310101,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',10,'bet','ba0ef1dfbbc87df94e1d198b0e9e3c06301710d4aab3d85116cbc8199954644a');
INSERT INTO debits VALUES(310107,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','XCP',50000000,'issuance fee','63145ad2bcc7030aabcfec42a5cce5dfe6829a5694fc0b3566406bb2fd8b6444');
INSERT INTO debits VALUES(310108,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','DIVISIBLE',100000000,'send','075b91828d0c7b0017f1b5876ef4909ba37db9bc2877588483d8a64bad2bd412');
INSERT INTO debits VALUES(310110,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','XCP',10,'bet','81f8ba670b22980b15c944dcd478a274723659d768b0de73b014d06d214e5b90');
INSERT INTO debits VALUES(310487,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','XCP',9,'bet','cadcc00884e64292c6f899b4abc29df7286d94093a258d0925e2fcc88af495b6');
INSERT INTO debits VALUES(310491,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',100000000,'open order','9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b');
INSERT INTO debits VALUES(310494,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','XCP',50000000,'issuance fee','084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e');
INSERT INTO debits VALUES(310495,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','DIVIDEND',10,'send','9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602');
INSERT INTO debits VALUES(310496,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','XCP',92945878046,'send','54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef');
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
INSERT INTO issuances VALUES(2,'82e357fac0f41bc8c0c01e781ce96f0871bd3d6aaf57a8e99255d5e9d9fba554',310001,'DIVISIBLE',100000000000,1,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,0,0,0.0,'Divisible asset',50000000,0,'valid');
INSERT INTO issuances VALUES(3,'6ecaeb544ce2f8a4a24d8d497ecba6ef7b71082a3f1cfdabc48726d5bc90fdca',310002,'NODIVISIBLE',1000,0,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,0,0,0.0,'No divisible asset',50000000,0,'valid');
INSERT INTO issuances VALUES(4,'a36a2d510757def22f0aa0f1cd1b4cf5e9bb160b051b83df25a101d5bb048928',310003,'CALLABLE',1000,1,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,0,0,0.0,'Callable asset',50000000,0,'valid');
INSERT INTO issuances VALUES(5,'044c9ac702136ee7839dc776cb7b43bbb9d5328415925a958679d801ac6c6b63',310004,'LOCKED',1000,1,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,0,0,0.0,'Locked asset',50000000,0,'valid');
INSERT INTO issuances VALUES(6,'bd919f9a31982a6dbc6253e38bfba0a367e24fbd65cf79575648f799b98849b4',310005,'LOCKED',0,1,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,0,0,0.0,'Locked asset',0,1,'valid');
INSERT INTO issuances VALUES(17,'cd929bf57f5f26550a56ba40eecd258b684842777dfc434a46b65a86e924bf52',310016,'MAXI',9223372036854775807,1,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',0,0,0,0.0,'Maximum quantity',50000000,0,'valid');
INSERT INTO issuances VALUES(108,'63145ad2bcc7030aabcfec42a5cce5dfe6829a5694fc0b3566406bb2fd8b6444',310107,'PAYTOSCRIPT',1000,0,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',0,0,0,0.0,'PSH issued asset',50000000,0,'valid');
INSERT INTO issuances VALUES(495,'084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e',310494,'DIVIDEND',100,1,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH',0,0,0,0.0,'Test dividend',50000000,0,'valid');
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
INSERT INTO messages VALUES(2,310001,'insert','debits','{"action": "issuance fee", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310001, "event": "82e357fac0f41bc8c0c01e781ce96f0871bd3d6aaf57a8e99255d5e9d9fba554", "quantity": 50000000}',0);
INSERT INTO messages VALUES(3,310001,'insert','issuances','{"asset": "DIVISIBLE", "block_index": 310001, "call_date": 0, "call_price": 0.0, "callable": false, "description": "Divisible asset", "divisible": true, "fee_paid": 50000000, "issuer": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "locked": false, "quantity": 100000000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "transfer": false, "tx_hash": "82e357fac0f41bc8c0c01e781ce96f0871bd3d6aaf57a8e99255d5e9d9fba554", "tx_index": 2}',0);
INSERT INTO messages VALUES(4,310001,'insert','credits','{"action": "issuance", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "DIVISIBLE", "block_index": 310001, "event": "82e357fac0f41bc8c0c01e781ce96f0871bd3d6aaf57a8e99255d5e9d9fba554", "quantity": 100000000000}',0);
INSERT INTO messages VALUES(5,310002,'insert','debits','{"action": "issuance fee", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310002, "event": "6ecaeb544ce2f8a4a24d8d497ecba6ef7b71082a3f1cfdabc48726d5bc90fdca", "quantity": 50000000}',0);
INSERT INTO messages VALUES(6,310002,'insert','issuances','{"asset": "NODIVISIBLE", "block_index": 310002, "call_date": 0, "call_price": 0.0, "callable": false, "description": "No divisible asset", "divisible": false, "fee_paid": 50000000, "issuer": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "locked": false, "quantity": 1000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "transfer": false, "tx_hash": "6ecaeb544ce2f8a4a24d8d497ecba6ef7b71082a3f1cfdabc48726d5bc90fdca", "tx_index": 3}',0);
INSERT INTO messages VALUES(7,310002,'insert','credits','{"action": "issuance", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "NODIVISIBLE", "block_index": 310002, "event": "6ecaeb544ce2f8a4a24d8d497ecba6ef7b71082a3f1cfdabc48726d5bc90fdca", "quantity": 1000}',0);
INSERT INTO messages VALUES(8,310003,'insert','debits','{"action": "issuance fee", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310003, "event": "a36a2d510757def22f0aa0f1cd1b4cf5e9bb160b051b83df25a101d5bb048928", "quantity": 50000000}',0);
INSERT INTO messages VALUES(9,310003,'insert','issuances','{"asset": "CALLABLE", "block_index": 310003, "call_date": 0, "call_price": 0.0, "callable": false, "description": "Callable asset", "divisible": true, "fee_paid": 50000000, "issuer": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "locked": false, "quantity": 1000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "transfer": false, "tx_hash": "a36a2d510757def22f0aa0f1cd1b4cf5e9bb160b051b83df25a101d5bb048928", "tx_index": 4}',0);
INSERT INTO messages VALUES(10,310003,'insert','credits','{"action": "issuance", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "CALLABLE", "block_index": 310003, "event": "a36a2d510757def22f0aa0f1cd1b4cf5e9bb160b051b83df25a101d5bb048928", "quantity": 1000}',0);
INSERT INTO messages VALUES(11,310004,'insert','debits','{"action": "issuance fee", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310004, "event": "044c9ac702136ee7839dc776cb7b43bbb9d5328415925a958679d801ac6c6b63", "quantity": 50000000}',0);
INSERT INTO messages VALUES(12,310004,'insert','issuances','{"asset": "LOCKED", "block_index": 310004, "call_date": 0, "call_price": 0.0, "callable": false, "description": "Locked asset", "divisible": true, "fee_paid": 50000000, "issuer": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "locked": false, "quantity": 1000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "transfer": false, "tx_hash": "044c9ac702136ee7839dc776cb7b43bbb9d5328415925a958679d801ac6c6b63", "tx_index": 5}',0);
INSERT INTO messages VALUES(13,310004,'insert','credits','{"action": "issuance", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "LOCKED", "block_index": 310004, "event": "044c9ac702136ee7839dc776cb7b43bbb9d5328415925a958679d801ac6c6b63", "quantity": 1000}',0);
INSERT INTO messages VALUES(14,310005,'insert','debits','{"action": "issuance fee", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310005, "event": "bd919f9a31982a6dbc6253e38bfba0a367e24fbd65cf79575648f799b98849b4", "quantity": 0}',0);
INSERT INTO messages VALUES(15,310005,'insert','issuances','{"asset": "LOCKED", "block_index": 310005, "call_date": 0, "call_price": 0.0, "callable": false, "description": "Locked asset", "divisible": true, "fee_paid": 0, "issuer": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "locked": true, "quantity": 0, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "transfer": false, "tx_hash": "bd919f9a31982a6dbc6253e38bfba0a367e24fbd65cf79575648f799b98849b4", "tx_index": 6}',0);
INSERT INTO messages VALUES(16,310006,'insert','debits','{"action": "open order", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310006, "event": "074fa38a84a81c0ed7957484ebe73836104d3068f66b189e05a7cf0b95c737f3", "quantity": 100000000}',0);
INSERT INTO messages VALUES(17,310006,'insert','orders','{"block_index": 310006, "expiration": 2000, "expire_index": 312006, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "DIVISIBLE", "get_quantity": 100000000, "get_remaining": 100000000, "give_asset": "XCP", "give_quantity": 100000000, "give_remaining": 100000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "tx_hash": "074fa38a84a81c0ed7957484ebe73836104d3068f66b189e05a7cf0b95c737f3", "tx_index": 7}',0);
INSERT INTO messages VALUES(18,310007,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "DIVISIBLE", "block_index": 310007, "event": "d21d82d8298d545b91e4467c287322d2399d8eb08af15bee68f58c4bcfa9a5f9", "quantity": 100000000}',0);
INSERT INTO messages VALUES(19,310007,'insert','credits','{"action": "send", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "DIVISIBLE", "block_index": 310007, "event": "d21d82d8298d545b91e4467c287322d2399d8eb08af15bee68f58c4bcfa9a5f9", "quantity": 100000000}',0);
INSERT INTO messages VALUES(20,310007,'insert','sends','{"asset": "DIVISIBLE", "block_index": 310007, "destination": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "quantity": 100000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "d21d82d8298d545b91e4467c287322d2399d8eb08af15bee68f58c4bcfa9a5f9", "tx_index": 8}',0);
INSERT INTO messages VALUES(21,310008,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310008, "event": "e64aac59d8759cde5785f3e1c4af448d95a152a30c76d97c114a3025e5ec118b", "quantity": 100000000}',0);
INSERT INTO messages VALUES(22,310008,'insert','credits','{"action": "send", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "XCP", "block_index": 310008, "event": "e64aac59d8759cde5785f3e1c4af448d95a152a30c76d97c114a3025e5ec118b", "quantity": 100000000}',0);
INSERT INTO messages VALUES(23,310008,'insert','sends','{"asset": "XCP", "block_index": 310008, "destination": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "quantity": 100000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "e64aac59d8759cde5785f3e1c4af448d95a152a30c76d97c114a3025e5ec118b", "tx_index": 9}',0);
INSERT INTO messages VALUES(24,310009,'insert','debits','{"action": "open order", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310009, "event": "a9f78534e7f340ba0f0d2ac1851a11a011ca7aa1262349eeba71add8777b162b", "quantity": 100000000}',0);
INSERT INTO messages VALUES(25,310009,'insert','orders','{"block_index": 310009, "expiration": 2000, "expire_index": 312009, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "DIVISIBLE", "get_quantity": 100000000, "get_remaining": 100000000, "give_asset": "XCP", "give_quantity": 100000000, "give_remaining": 100000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "tx_hash": "a9f78534e7f340ba0f0d2ac1851a11a011ca7aa1262349eeba71add8777b162b", "tx_index": 10}',0);
INSERT INTO messages VALUES(26,310010,'insert','debits','{"action": "open order", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310010, "event": "b6db5c8412a58d9fa75bff41f8a7519353ffd4d359c7c8fa7ee1900bc05e4d9d", "quantity": 100000000}',0);
INSERT INTO messages VALUES(27,310010,'insert','orders','{"block_index": 310010, "expiration": 2000, "expire_index": 312010, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 900000, "fee_required_remaining": 900000, "get_asset": "BTC", "get_quantity": 1000000, "get_remaining": 1000000, "give_asset": "XCP", "give_quantity": 100000000, "give_remaining": 100000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "tx_hash": "b6db5c8412a58d9fa75bff41f8a7519353ffd4d359c7c8fa7ee1900bc05e4d9d", "tx_index": 11}',0);
INSERT INTO messages VALUES(28,310011,'insert','orders','{"block_index": 310011, "expiration": 2000, "expire_index": 312011, "fee_provided": 1000000, "fee_provided_remaining": 1000000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 100000000, "get_remaining": 100000000, "give_asset": "BTC", "give_quantity": 666667, "give_remaining": 666667, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "tx_hash": "8a63e7a516d36c17ac32999222ac282ab94fb9c5ea30637cd06660b3139510f6", "tx_index": 12}',0);
INSERT INTO messages VALUES(29,310012,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310012, "event": "d4428cf4082bc5fe8fed72673f956d351f269a308cf0d0d0b87f76dd3b6165f4", "quantity": 300000000}',0);
INSERT INTO messages VALUES(30,310012,'insert','credits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "XCP", "block_index": 310012, "event": "d4428cf4082bc5fe8fed72673f956d351f269a308cf0d0d0b87f76dd3b6165f4", "quantity": 300000000}',0);
INSERT INTO messages VALUES(31,310012,'insert','sends','{"asset": "XCP", "block_index": 310012, "destination": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "quantity": 300000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "d4428cf4082bc5fe8fed72673f956d351f269a308cf0d0d0b87f76dd3b6165f4", "tx_index": 13}',0);
INSERT INTO messages VALUES(32,310013,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "DIVISIBLE", "block_index": 310013, "event": "97aaf458fdbe3a8d7e57b4c238706419c001fc5810630c0c3cd2361821052a0d", "quantity": 1000000000}',0);
INSERT INTO messages VALUES(33,310013,'insert','credits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "DIVISIBLE", "block_index": 310013, "event": "97aaf458fdbe3a8d7e57b4c238706419c001fc5810630c0c3cd2361821052a0d", "quantity": 1000000000}',0);
INSERT INTO messages VALUES(34,310013,'insert','sends','{"asset": "DIVISIBLE", "block_index": 310013, "destination": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "quantity": 1000000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "97aaf458fdbe3a8d7e57b4c238706419c001fc5810630c0c3cd2361821052a0d", "tx_index": 14}',0);
INSERT INTO messages VALUES(35,310014,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "NODIVISIBLE", "block_index": 310014, "event": "29cd663b5e5b0801717e46891bc57e1d050680da0a803944623f6021151d2592", "quantity": 5}',0);
INSERT INTO messages VALUES(36,310014,'insert','credits','{"action": "send", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "NODIVISIBLE", "block_index": 310014, "event": "29cd663b5e5b0801717e46891bc57e1d050680da0a803944623f6021151d2592", "quantity": 5}',0);
INSERT INTO messages VALUES(37,310014,'insert','sends','{"asset": "NODIVISIBLE", "block_index": 310014, "destination": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "quantity": 5, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "29cd663b5e5b0801717e46891bc57e1d050680da0a803944623f6021151d2592", "tx_index": 15}',0);
INSERT INTO messages VALUES(38,310015,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "NODIVISIBLE", "block_index": 310015, "event": "b285ff2379716e92ab7b68ad4e68ba74a999dc9ca8c312c377231a89da7e9361", "quantity": 10}',0);
INSERT INTO messages VALUES(39,310015,'insert','credits','{"action": "send", "address": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "asset": "NODIVISIBLE", "block_index": 310015, "event": "b285ff2379716e92ab7b68ad4e68ba74a999dc9ca8c312c377231a89da7e9361", "quantity": 10}',0);
INSERT INTO messages VALUES(40,310015,'insert','sends','{"asset": "NODIVISIBLE", "block_index": 310015, "destination": "1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2", "quantity": 10, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "b285ff2379716e92ab7b68ad4e68ba74a999dc9ca8c312c377231a89da7e9361", "tx_index": 16}',0);
INSERT INTO messages VALUES(41,310016,'insert','debits','{"action": "issuance fee", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310016, "event": "cd929bf57f5f26550a56ba40eecd258b684842777dfc434a46b65a86e924bf52", "quantity": 50000000}',0);
INSERT INTO messages VALUES(42,310016,'insert','issuances','{"asset": "MAXI", "block_index": 310016, "call_date": 0, "call_price": 0.0, "callable": false, "description": "Maximum quantity", "divisible": true, "fee_paid": 50000000, "issuer": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "locked": false, "quantity": 9223372036854775807, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "transfer": false, "tx_hash": "cd929bf57f5f26550a56ba40eecd258b684842777dfc434a46b65a86e924bf52", "tx_index": 17}',0);
INSERT INTO messages VALUES(43,310016,'insert','credits','{"action": "issuance", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "MAXI", "block_index": 310016, "event": "cd929bf57f5f26550a56ba40eecd258b684842777dfc434a46b65a86e924bf52", "quantity": 9223372036854775807}',0);
INSERT INTO messages VALUES(44,310017,'insert','broadcasts','{"block_index": 310017, "fee_fraction_int": 5000000, "locked": false, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "text": "Unit Test", "timestamp": 1388000000, "tx_hash": "9b70f9ad8c0d92ff27127d081169cebee68a776f4974e757de09a46e85682d66", "tx_index": 18, "value": 1.0}',0);
INSERT INTO messages VALUES(45,310018,'insert','broadcasts','{"block_index": 310018, "fee_fraction_int": null, "locked": true, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "text": null, "timestamp": 0, "tx_hash": "f6548d72d0726bd869fdfdcf44766871f7ab721efda6ed7bce0d4c88b43bf1cf", "tx_index": 19, "value": null}',0);
INSERT INTO messages VALUES(46,310019,'insert','debits','{"action": "bet", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310019, "event": "be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd", "quantity": 9}',0);
INSERT INTO messages VALUES(47,310019,'insert','bets','{"bet_type": 1, "block_index": 310019, "counterwager_quantity": 9, "counterwager_remaining": 9, "deadline": 1388000001, "expiration": 100, "expire_index": 310119, "fee_fraction_int": 5000000.0, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "leverage": 5040, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "target_value": 0.0, "tx_hash": "be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd", "tx_index": 20, "wager_quantity": 9, "wager_remaining": 9}',0);
INSERT INTO messages VALUES(48,310020,'insert','debits','{"action": "bet", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "XCP", "block_index": 310020, "event": "90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "quantity": 9}',0);
INSERT INTO messages VALUES(49,310020,'insert','bets','{"bet_type": 0, "block_index": 310020, "counterwager_quantity": 9, "counterwager_remaining": 9, "deadline": 1388000001, "expiration": 100, "expire_index": 310120, "fee_fraction_int": 5000000.0, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "leverage": 5040, "source": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "status": "open", "target_value": 0.0, "tx_hash": "90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "tx_index": 21, "wager_quantity": 9, "wager_remaining": 9}',0);
INSERT INTO messages VALUES(50,310020,'insert','credits','{"action": "filled", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310020, "event": "90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "quantity": 0}',0);
INSERT INTO messages VALUES(51,310020,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(52,310020,'insert','credits','{"action": "filled", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "XCP", "block_index": 310020, "event": "90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "quantity": 0}',0);
INSERT INTO messages VALUES(53,310020,'update','bets','{"counterwager_remaining": 0, "status": "filled", "tx_hash": "90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "wager_remaining": 0}',0);
INSERT INTO messages VALUES(54,310020,'insert','bet_matches','{"backward_quantity": 9, "block_index": 310020, "deadline": 1388000001, "fee_fraction_int": 5000000, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "forward_quantity": 9, "id": "be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "initial_value": 1.0, "leverage": 5040, "match_expire_index": 310119, "status": "pending", "target_value": 0.0, "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx0_bet_type": 1, "tx0_block_index": 310019, "tx0_expiration": 100, "tx0_hash": "be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd", "tx0_index": 20, "tx1_address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "tx1_bet_type": 0, "tx1_block_index": 310020, "tx1_expiration": 100, "tx1_hash": "90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "tx1_index": 21}',0);
INSERT INTO messages VALUES(55,310021,'insert','credits','{"action": "recredit forward quantity", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310021, "event": "be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "quantity": 9}',0);
INSERT INTO messages VALUES(56,310021,'insert','credits','{"action": "recredit backward quantity", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "XCP", "block_index": 310021, "event": "be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "quantity": 9}',0);
INSERT INTO messages VALUES(57,310021,'update','bet_matches','{"bet_match_id": "be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "status": "expired"}',0);
INSERT INTO messages VALUES(58,310021,'insert','bet_match_expirations','{"bet_match_id": "be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "block_index": 310021, "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx1_address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns"}',0);
INSERT INTO messages VALUES(59,310101,'insert','debits','{"action": "bet", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "XCP", "block_index": 310101, "event": "ba0ef1dfbbc87df94e1d198b0e9e3c06301710d4aab3d85116cbc8199954644a", "quantity": 10}',0);
INSERT INTO messages VALUES(60,310101,'insert','bets','{"bet_type": 3, "block_index": 310101, "counterwager_quantity": 10, "counterwager_remaining": 10, "deadline": 1388000200, "expiration": 1000, "expire_index": 311101, "fee_fraction_int": 5000000.0, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "leverage": 5040, "source": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "status": "open", "target_value": 0.0, "tx_hash": "ba0ef1dfbbc87df94e1d198b0e9e3c06301710d4aab3d85116cbc8199954644a", "tx_index": 102, "wager_quantity": 10, "wager_remaining": 10}',0);
INSERT INTO messages VALUES(61,310102,'insert','broadcasts','{"block_index": 310102, "fee_fraction_int": 5000000, "locked": false, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "text": "Unit Test", "timestamp": 1388000002, "tx_hash": "18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e", "tx_index": 103, "value": 1.0}',0);
INSERT INTO messages VALUES(62,310103,'insert','credits','{"action": "burn", "address": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "asset": "XCP", "block_index": 310103, "event": "6e96414550ec512d2272497e3e2cbc908ec472cc1b871d82f51a9a66af3cf148", "quantity": 92999138821}',0);
INSERT INTO messages VALUES(63,310103,'insert','burns','{"block_index": 310103, "burned": 62000000, "earned": 92999138821, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "valid", "tx_hash": "6e96414550ec512d2272497e3e2cbc908ec472cc1b871d82f51a9a66af3cf148", "tx_index": 104}',0);
INSERT INTO messages VALUES(64,310104,'insert','credits','{"action": "burn", "address": "munimLLHjPhGeSU5rYB2HN79LJa8bRZr5b", "asset": "XCP", "block_index": 310104, "event": "1f4e8d91b61fff6132ee060b80008f7739e8215282a5bd7c57fe088c056d9f72", "quantity": 92999130460}',0);
INSERT INTO messages VALUES(65,310104,'insert','burns','{"block_index": 310104, "burned": 62000000, "earned": 92999130460, "source": "munimLLHjPhGeSU5rYB2HN79LJa8bRZr5b", "status": "valid", "tx_hash": "1f4e8d91b61fff6132ee060b80008f7739e8215282a5bd7c57fe088c056d9f72", "tx_index": 105}',0);
INSERT INTO messages VALUES(66,310105,'insert','credits','{"action": "burn", "address": "mwtPsLQxW9xpm7gdLmwWvJK5ABdPUVJm42", "asset": "XCP", "block_index": 310105, "event": "3152127f7b6645e8b066f6691aeed95fa38f404df85df1447c320b38a79240c6", "quantity": 92999122099}',0);
INSERT INTO messages VALUES(67,310105,'insert','burns','{"block_index": 310105, "burned": 62000000, "earned": 92999122099, "source": "mwtPsLQxW9xpm7gdLmwWvJK5ABdPUVJm42", "status": "valid", "tx_hash": "3152127f7b6645e8b066f6691aeed95fa38f404df85df1447c320b38a79240c6", "tx_index": 106}',0);
INSERT INTO messages VALUES(68,310106,'insert','credits','{"action": "burn", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "XCP", "block_index": 310106, "event": "bcf44f53dc42ae50f3f0f2dc36ff16e432ddbc298f70ec143806cb58e53d4403", "quantity": 46499556869}',0);
INSERT INTO messages VALUES(69,310106,'insert','burns','{"block_index": 310106, "burned": 31000000, "earned": 46499556869, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "valid", "tx_hash": "bcf44f53dc42ae50f3f0f2dc36ff16e432ddbc298f70ec143806cb58e53d4403", "tx_index": 107}',0);
INSERT INTO messages VALUES(70,310107,'insert','debits','{"action": "issuance fee", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "XCP", "block_index": 310107, "event": "63145ad2bcc7030aabcfec42a5cce5dfe6829a5694fc0b3566406bb2fd8b6444", "quantity": 50000000}',0);
INSERT INTO messages VALUES(71,310107,'insert','issuances','{"asset": "PAYTOSCRIPT", "block_index": 310107, "call_date": 0, "call_price": 0.0, "callable": false, "description": "PSH issued asset", "divisible": false, "fee_paid": 50000000, "issuer": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "locked": false, "quantity": 1000, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "valid", "transfer": false, "tx_hash": "63145ad2bcc7030aabcfec42a5cce5dfe6829a5694fc0b3566406bb2fd8b6444", "tx_index": 108}',0);
INSERT INTO messages VALUES(72,310107,'insert','credits','{"action": "issuance", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "PAYTOSCRIPT", "block_index": 310107, "event": "63145ad2bcc7030aabcfec42a5cce5dfe6829a5694fc0b3566406bb2fd8b6444", "quantity": 1000}',0);
INSERT INTO messages VALUES(73,310108,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "DIVISIBLE", "block_index": 310108, "event": "075b91828d0c7b0017f1b5876ef4909ba37db9bc2877588483d8a64bad2bd412", "quantity": 100000000}',0);
INSERT INTO messages VALUES(74,310108,'insert','credits','{"action": "send", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "DIVISIBLE", "block_index": 310108, "event": "075b91828d0c7b0017f1b5876ef4909ba37db9bc2877588483d8a64bad2bd412", "quantity": 100000000}',0);
INSERT INTO messages VALUES(75,310108,'insert','sends','{"asset": "DIVISIBLE", "block_index": 310108, "destination": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "quantity": 100000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "075b91828d0c7b0017f1b5876ef4909ba37db9bc2877588483d8a64bad2bd412", "tx_index": 109}',0);
INSERT INTO messages VALUES(76,310109,'insert','broadcasts','{"block_index": 310109, "fee_fraction_int": 5000000, "locked": false, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "valid", "text": "Unit Test", "timestamp": 1388000002, "tx_hash": "d858c6855038048b1d5e31a34ceae2069d7c7bc311ca49d189ccbf44cee58031", "tx_index": 110, "value": 1.0}',0);
INSERT INTO messages VALUES(77,310110,'insert','debits','{"action": "bet", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "XCP", "block_index": 310110, "event": "81f8ba670b22980b15c944dcd478a274723659d768b0de73b014d06d214e5b90", "quantity": 10}',0);
INSERT INTO messages VALUES(78,310110,'insert','bets','{"bet_type": 3, "block_index": 310110, "counterwager_quantity": 10, "counterwager_remaining": 10, "deadline": 1388000200, "expiration": 1000, "expire_index": 311110, "fee_fraction_int": 5000000.0, "feed_address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "leverage": 5040, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "open", "target_value": 0.0, "tx_hash": "81f8ba670b22980b15c944dcd478a274723659d768b0de73b014d06d214e5b90", "tx_index": 111, "wager_quantity": 10, "wager_remaining": 10}',0);
INSERT INTO messages VALUES(79,310111,'insert','broadcasts','{"block_index": 310111, "fee_fraction_int": 0, "locked": false, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "valid", "text": "4INITVOTE TESTSCENARIOPOLL XCP 311501 OPTS TRUE FALSE", "timestamp": 1388000000, "tx_hash": "9d70aa209efe54d0ac6f497e2553386b0095cced5a5e2bbac93cf4e4be73c517", "tx_index": 112, "value": -3.0}',0);
INSERT INTO messages VALUES(80,310112,'insert','broadcasts','{"block_index": 310112, "fee_fraction_int": 0, "locked": false, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "valid", "text": "CASTVOTE TESTSCENARIOPOLL TRUE 70", "timestamp": 1388000001, "tx_hash": "22b9d1b536f079c1f0c435fdc33f41bcb21fa7bc4579944033fdbafc89a56c33", "tx_index": 113, "value": -3.0}',0);
INSERT INTO messages VALUES(81,310486,'insert','broadcasts','{"block_index": 310486, "fee_fraction_int": 5000000, "locked": false, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "valid", "text": "Unit Test", "timestamp": 1388000100, "tx_hash": "f847362f6669c558922032a575b57da93af5e367ab7ba3154b71587cbbb50551", "tx_index": 487, "value": 1.0}',0);
INSERT INTO messages VALUES(82,310487,'insert','debits','{"action": "bet", "address": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "asset": "XCP", "block_index": 310487, "event": "cadcc00884e64292c6f899b4abc29df7286d94093a258d0925e2fcc88af495b6", "quantity": 9}',0);
INSERT INTO messages VALUES(83,310487,'insert','bets','{"bet_type": 1, "block_index": 310487, "counterwager_quantity": 9, "counterwager_remaining": 9, "deadline": 1388000101, "expiration": 100, "expire_index": 310587, "fee_fraction_int": 5000000.0, "feed_address": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "leverage": 5040, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "open", "target_value": 0.0, "tx_hash": "cadcc00884e64292c6f899b4abc29df7286d94093a258d0925e2fcc88af495b6", "tx_index": 488, "wager_quantity": 9, "wager_remaining": 9}',0);
INSERT INTO messages VALUES(84,310488,'insert','broadcasts','{"block_index": 310488, "fee_fraction_int": null, "locked": true, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "valid", "text": null, "timestamp": 0, "tx_hash": "93ff662d6409f5a2b381e76fdd659a7dffee6fada7869574de201d29fa2b15b4", "tx_index": 489, "value": null}',0);
INSERT INTO messages VALUES(85,310491,'insert','debits','{"action": "open order", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310491, "event": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b", "quantity": 100000000}',0);
INSERT INTO messages VALUES(86,310491,'insert','orders','{"block_index": 310491, "expiration": 2000, "expire_index": 312491, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 900000, "fee_required_remaining": 900000, "get_asset": "BTC", "get_quantity": 800000, "get_remaining": 800000, "give_asset": "XCP", "give_quantity": 100000000, "give_remaining": 100000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "tx_hash": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b", "tx_index": 492}',0);
INSERT INTO messages VALUES(87,310492,'insert','orders','{"block_index": 310492, "expiration": 2000, "expire_index": 312492, "fee_provided": 1000000, "fee_provided_remaining": 1000000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 100000000, "get_remaining": 100000000, "give_asset": "BTC", "give_quantity": 800000, "give_remaining": 800000, "source": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "status": "open", "tx_hash": "14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0", "tx_index": 493}',0);
INSERT INTO messages VALUES(88,310492,'update','orders','{"fee_provided_remaining": 10000, "fee_required_remaining": 892800, "get_remaining": 0, "give_remaining": 0, "status": "open", "tx_hash": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b"}',0);
INSERT INTO messages VALUES(89,310492,'update','orders','{"fee_provided_remaining": 992800, "fee_required_remaining": 0, "get_remaining": 0, "give_remaining": 0, "status": "open", "tx_hash": "14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0"}',0);
INSERT INTO messages VALUES(90,310492,'insert','order_matches','{"backward_asset": "BTC", "backward_quantity": 800000, "block_index": 310492, "fee_paid": 7200, "forward_asset": "XCP", "forward_quantity": 100000000, "id": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b_14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0", "match_expire_index": 310512, "status": "pending", "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx0_block_index": 310491, "tx0_expiration": 2000, "tx0_hash": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b", "tx0_index": 492, "tx1_address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "tx1_block_index": 310492, "tx1_expiration": 2000, "tx1_hash": "14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0", "tx1_index": 493}',0);
INSERT INTO messages VALUES(91,310493,'insert','credits','{"action": "burn", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "XCP", "block_index": 310493, "event": "d6adfa92e20b6211ff5fabb2f7a1c8b037168797984c94734c28e82e92d3b1d6", "quantity": 92995878046}',0);
INSERT INTO messages VALUES(92,310493,'insert','burns','{"block_index": 310493, "burned": 62000000, "earned": 92995878046, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "tx_hash": "d6adfa92e20b6211ff5fabb2f7a1c8b037168797984c94734c28e82e92d3b1d6", "tx_index": 494}',0);
INSERT INTO messages VALUES(93,310494,'insert','debits','{"action": "issuance fee", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "XCP", "block_index": 310494, "event": "084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e", "quantity": 50000000}',0);
INSERT INTO messages VALUES(94,310494,'insert','issuances','{"asset": "DIVIDEND", "block_index": 310494, "call_date": 0, "call_price": 0.0, "callable": false, "description": "Test dividend", "divisible": true, "fee_paid": 50000000, "issuer": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "locked": false, "quantity": 100, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "transfer": false, "tx_hash": "084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e", "tx_index": 495}',0);
INSERT INTO messages VALUES(95,310494,'insert','credits','{"action": "issuance", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "DIVIDEND", "block_index": 310494, "event": "084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e", "quantity": 100}',0);
INSERT INTO messages VALUES(96,310495,'insert','debits','{"action": "send", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "DIVIDEND", "block_index": 310495, "event": "9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602", "quantity": 10}',0);
INSERT INTO messages VALUES(97,310495,'insert','credits','{"action": "send", "address": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "asset": "DIVIDEND", "block_index": 310495, "event": "9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602", "quantity": 10}',0);
INSERT INTO messages VALUES(98,310495,'insert','sends','{"asset": "DIVIDEND", "block_index": 310495, "destination": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "quantity": 10, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "tx_hash": "9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602", "tx_index": 496}',0);
INSERT INTO messages VALUES(99,310496,'insert','debits','{"action": "send", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "XCP", "block_index": 310496, "event": "54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef", "quantity": 92945878046}',0);
INSERT INTO messages VALUES(100,310496,'insert','credits','{"action": "send", "address": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "asset": "XCP", "block_index": 310496, "event": "54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef", "quantity": 92945878046}',0);
INSERT INTO messages VALUES(101,310496,'insert','sends','{"asset": "XCP", "block_index": 310496, "destination": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "quantity": 92945878046, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "tx_hash": "54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef", "tx_index": 497}',0);
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
INSERT INTO order_matches VALUES('9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b_14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0',492,'9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',493,'14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',100000000,'BTC',800000,310491,310492,310492,2000,2000,310512,7200,'pending');
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
INSERT INTO orders VALUES(7,'074fa38a84a81c0ed7957484ebe73836104d3068f66b189e05a7cf0b95c737f3',310006,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',100000000,100000000,'DIVISIBLE',100000000,100000000,2000,312006,0,0,10000,10000,'open');
INSERT INTO orders VALUES(10,'a9f78534e7f340ba0f0d2ac1851a11a011ca7aa1262349eeba71add8777b162b',310009,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',100000000,100000000,'DIVISIBLE',100000000,100000000,2000,312009,0,0,10000,10000,'open');
INSERT INTO orders VALUES(11,'b6db5c8412a58d9fa75bff41f8a7519353ffd4d359c7c8fa7ee1900bc05e4d9d',310010,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',100000000,100000000,'BTC',1000000,1000000,2000,312010,900000,900000,10000,10000,'open');
INSERT INTO orders VALUES(12,'8a63e7a516d36c17ac32999222ac282ab94fb9c5ea30637cd06660b3139510f6',310011,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','BTC',666667,666667,'XCP',100000000,100000000,2000,312011,0,0,1000000,1000000,'open');
INSERT INTO orders VALUES(492,'9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b',310491,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',100000000,0,'BTC',800000,0,2000,312491,900000,892800,10000,10000,'open');
INSERT INTO orders VALUES(493,'14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0',310492,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','BTC',800000,0,'XCP',100000000,0,2000,312492,0,0,1000000,992800,'open');
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
INSERT INTO sends VALUES(8,'d21d82d8298d545b91e4467c287322d2399d8eb08af15bee68f58c4bcfa9a5f9',310007,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','DIVISIBLE',100000000,'valid');
INSERT INTO sends VALUES(9,'e64aac59d8759cde5785f3e1c4af448d95a152a30c76d97c114a3025e5ec118b',310008,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',100000000,'valid');
INSERT INTO sends VALUES(13,'d4428cf4082bc5fe8fed72673f956d351f269a308cf0d0d0b87f76dd3b6165f4',310012,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','XCP',300000000,'valid');
INSERT INTO sends VALUES(14,'97aaf458fdbe3a8d7e57b4c238706419c001fc5810630c0c3cd2361821052a0d',310013,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','DIVISIBLE',1000000000,'valid');
INSERT INTO sends VALUES(15,'29cd663b5e5b0801717e46891bc57e1d050680da0a803944623f6021151d2592',310014,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','NODIVISIBLE',5,'valid');
INSERT INTO sends VALUES(16,'b285ff2379716e92ab7b68ad4e68ba74a999dc9ca8c312c377231a89da7e9361',310015,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2','NODIVISIBLE',10,'valid');
INSERT INTO sends VALUES(109,'075b91828d0c7b0017f1b5876ef4909ba37db9bc2877588483d8a64bad2bd412',310108,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','DIVISIBLE',100000000,'valid');
INSERT INTO sends VALUES(496,'9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602',310495,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj','DIVIDEND',10,'valid');
INSERT INTO sends VALUES(497,'54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef',310496,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj','XCP',92945878046,'valid');
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
INSERT INTO transactions VALUES(2,'82e357fac0f41bc8c0c01e781ce96f0871bd3d6aaf57a8e99255d5e9d9fba554',310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',1419700100,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'00000014000000A25BE34B66000000174876E800010000000000000000000F446976697369626C65206173736574',1);
INSERT INTO transactions VALUES(3,'6ecaeb544ce2f8a4a24d8d497ecba6ef7b71082a3f1cfdabc48726d5bc90fdca',310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',1419700200,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'000000140006CAD8DC7F0B6600000000000003E800000000000000000000124E6F20646976697369626C65206173736574',1);
INSERT INTO transactions VALUES(4,'a36a2d510757def22f0aa0f1cd1b4cf5e9bb160b051b83df25a101d5bb048928',310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',1419700300,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001400000003C58E5C5600000000000003E8010000000000000000000E43616C6C61626C65206173736574',1);
INSERT INTO transactions VALUES(5,'044c9ac702136ee7839dc776cb7b43bbb9d5328415925a958679d801ac6c6b63',310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',1419700400,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001400000000082C82E300000000000003E8010000000000000000000C4C6F636B6564206173736574',1);
INSERT INTO transactions VALUES(6,'bd919f9a31982a6dbc6253e38bfba0a367e24fbd65cf79575648f799b98849b4',310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',1419700500,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001400000000082C82E3000000000000000001000000000000000000044C4F434B',1);
INSERT INTO transactions VALUES(7,'074fa38a84a81c0ed7957484ebe73836104d3068f66b189e05a7cf0b95c737f3',310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',1419700600,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000A25BE34B660000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(8,'d21d82d8298d545b91e4467c287322d2399d8eb08af15bee68f58c4bcfa9a5f9',310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',1419700700,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'00000000000000A25BE34B660000000005F5E100',1);
INSERT INTO transactions VALUES(9,'e64aac59d8759cde5785f3e1c4af448d95a152a30c76d97c114a3025e5ec118b',310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',1419700800,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'0000000000000000000000010000000005F5E100',1);
INSERT INTO transactions VALUES(10,'a9f78534e7f340ba0f0d2ac1851a11a011ca7aa1262349eeba71add8777b162b',310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',1419700900,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000A25BE34B660000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(11,'b6db5c8412a58d9fa75bff41f8a7519353ffd4d359c7c8fa7ee1900bc05e4d9d',310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',1419701000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000000000000000000000000F424007D000000000000DBBA0',1);
INSERT INTO transactions VALUES(12,'8a63e7a516d36c17ac32999222ac282ab94fb9c5ea30637cd06660b3139510f6',310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',1419701100,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,1000000,X'0000000A000000000000000000000000000A2C2B00000000000000010000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(13,'d4428cf4082bc5fe8fed72673f956d351f269a308cf0d0d0b87f76dd3b6165f4',310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',1419701200,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'0000000000000000000000010000000011E1A300',1);
INSERT INTO transactions VALUES(14,'97aaf458fdbe3a8d7e57b4c238706419c001fc5810630c0c3cd2361821052a0d',310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',1419701300,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'00000000000000A25BE34B66000000003B9ACA00',1);
INSERT INTO transactions VALUES(15,'29cd663b5e5b0801717e46891bc57e1d050680da0a803944623f6021151d2592',310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',1419701400,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'000000000006CAD8DC7F0B660000000000000005',1);
INSERT INTO transactions VALUES(16,'b285ff2379716e92ab7b68ad4e68ba74a999dc9ca8c312c377231a89da7e9361',310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',1419701500,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'000000000006CAD8DC7F0B66000000000000000A',1);
INSERT INTO transactions VALUES(17,'cd929bf57f5f26550a56ba40eecd258b684842777dfc434a46b65a86e924bf52',310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',1419701600,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'000000140000000000033A3E7FFFFFFFFFFFFFFF01000000000000000000104D6178696D756D207175616E74697479',1);
INSERT INTO transactions VALUES(18,'9b70f9ad8c0d92ff27127d081169cebee68a776f4974e757de09a46e85682d66',310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',1419701700,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001E52BB33003FF0000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(19,'f6548d72d0726bd869fdfdcf44766871f7ab721efda6ed7bce0d4c88b43bf1cf',310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',1419701800,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','',0,10000,X'0000001E4CC552003FF000000000000000000000046C6F636B',1);
INSERT INTO transactions VALUES(20,'be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd',310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',1419701900,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000152BB3301000000000000000900000000000000090000000000000000000013B000000064',1);
INSERT INTO transactions VALUES(21,'90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5',310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',1419702000,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000052BB3301000000000000000900000000000000090000000000000000000013B000000064',1);
INSERT INTO transactions VALUES(102,'ba0ef1dfbbc87df94e1d198b0e9e3c06301710d4aab3d85116cbc8199954644a',310101,'369472409995ca1a2ebecbad6bf9dab38c378ab1e67e1bdf13d4ce1346731cd6',1419710100,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000352BB33C8000000000000000A000000000000000A0000000000000000000013B0000003E8',1);
INSERT INTO transactions VALUES(103,'18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e',310102,'11e25883fd0479b78ddb1953ef67e3c3d1ffc82bd1f9e918a75c2194f7137f99',1419710200,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001E52BB33023FF0000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(104,'6e96414550ec512d2272497e3e2cbc908ec472cc1b871d82f51a9a66af3cf148',310103,'559a208afea6dd27b8bfeb031f1bd8f57182dcab6cf55c4089a6c49fb4744f17',1419710300,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,-99990000,X'',1);
INSERT INTO transactions VALUES(105,'1f4e8d91b61fff6132ee060b80008f7739e8215282a5bd7c57fe088c056d9f72',310104,'55b82e631b61d22a8524981ff3b5e3ab4ad7b732b7d1a06191064334b8f2dfd2',1419710400,'munimLLHjPhGeSU5rYB2HN79LJa8bRZr5b','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,-99990000,X'',1);
INSERT INTO transactions VALUES(106,'3152127f7b6645e8b066f6691aeed95fa38f404df85df1447c320b38a79240c6',310105,'1d72cdf6c4a02a5f973e6eaa53c28e9e13014b4f5bb13f91621a911b27fe936a',1419710500,'mwtPsLQxW9xpm7gdLmwWvJK5ABdPUVJm42','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,-99990000,X'',1);
INSERT INTO transactions VALUES(107,'bcf44f53dc42ae50f3f0f2dc36ff16e432ddbc298f70ec143806cb58e53d4403',310106,'9d39cbe8c8a5357fc56e5c2f95bf132382ddad14cbc8abd54e549d58248140ff',1419710600,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','mvCounterpartyXXXXXXXXXXXXXXW24Hef',31000000,10000,X'',1);
INSERT INTO transactions VALUES(108,'63145ad2bcc7030aabcfec42a5cce5dfe6829a5694fc0b3566406bb2fd8b6444',310107,'51cc04005e49fa49e661946a0e147240b0e5aac174252c96481ab7ddd5487435',1419710700,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','',0,10000,X'0000001400078A8FE2E5E44100000000000003E8000000000000000000001050534820697373756564206173736574',1);
INSERT INTO transactions VALUES(109,'075b91828d0c7b0017f1b5876ef4909ba37db9bc2877588483d8a64bad2bd412',310108,'8f2d3861aa42f8e75dc14a23d6046bd89feef0d81996b6e1adc2a2828fbc8b34',1419710800,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',5430,10000,X'00000000000000A25BE34B660000000005F5E100',1);
INSERT INTO transactions VALUES(110,'d858c6855038048b1d5e31a34ceae2069d7c7bc311ca49d189ccbf44cee58031',310109,'d23aaaae55e6a912eaaa8d20fe2a9ad4819fe9dc1ed58977265af58fad89d8f9',1419710900,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','',0,10000,X'0000001E52BB33023FF0000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(111,'81f8ba670b22980b15c944dcd478a274723659d768b0de73b014d06d214e5b90',310110,'cecc8e4791bd3081995bd9fd67acb6b97415facfd2b68f926a70b22d9a258382',1419711000,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',5430,10000,X'00000028000352BB33C8000000000000000A000000000000000A0000000000000000000013B0000003E8',1);
INSERT INTO transactions VALUES(112,'9d70aa209efe54d0ac6f497e2553386b0095cced5a5e2bbac93cf4e4be73c517',310111,'fde71b9756d5ba0b6d8b230ee885af01f9c4461a55dbde8678279166a21b20ae',1419711100,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','',0,-99990000,X'0000001E52BB3300C0080000000000000000000034494E4954564F544520544553545343454E4152494F504F4C4C2058435020333131353031204F50545320545255452046414C5345',1);
INSERT INTO transactions VALUES(113,'22b9d1b536f079c1f0c435fdc33f41bcb21fa7bc4579944033fdbafc89a56c33',310112,'5b06f69bfdde1083785cf68ebc2211b464839033c30a099d3227b490bf3ab251',1419711200,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','',0,-99990000,X'0000001E52BB3301C008000000000000000000002143415354564F544520544553545343454E4152494F504F4C4C2054525545203730',1);
INSERT INTO transactions VALUES(487,'f847362f6669c558922032a575b57da93af5e367ab7ba3154b71587cbbb50551',310486,'d4fbe610cc60987f2d1d35c7d8ad3ce32156ee5fe36ef8cc4f08b46836388862',1419748600,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','',0,-99990000,X'0000001E52BB33643FF0000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(488,'cadcc00884e64292c6f899b4abc29df7286d94093a258d0925e2fcc88af495b6',310487,'32aa1b132d0643350bbb62dbd5f38ae0c270d8f491a2012c83b99158d58e464f',1419748700,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM',5430,-99990000,X'00000028000152BB3365000000000000000900000000000000090000000000000000000013B000000064',1);
INSERT INTO transactions VALUES(489,'93ff662d6409f5a2b381e76fdd659a7dffee6fada7869574de201d29fa2b15b4',310488,'80b8dd5d7ce2e4886e6721095b892a39fb699980fe2bc1c17e747f822f4c4b1b',1419748800,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','',0,-99990000,X'0000001E52BB33663FF000000000000000000000046C6F636B',1);
INSERT INTO transactions VALUES(492,'9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b',310491,'811abd7cf2b768cfdaa84ab44c63f4463c96a368ead52125bf149cf0c7447b16',1419749100,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000000000000000000000000C350007D000000000000DBBA0',1);
INSERT INTO transactions VALUES(493,'14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0',310492,'8a09b2faf0a7ad67eb4ab5c948b9769fc87eb2ec5e16108f2cde8bd9e6cf7607',1419749200,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','',0,1000000,X'0000000A000000000000000000000000000C350000000000000000010000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(494,'d6adfa92e20b6211ff5fabb2f7a1c8b037168797984c94734c28e82e92d3b1d6',310493,'c19e2915b750279b2be4b52e57e5ce29f63dffb4e14d9aad30c9e820affc0cbf',1419749300,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,10000,X'',1);
INSERT INTO transactions VALUES(495,'084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e',310494,'7dda1d3e12785313d5651ee5314d0aecf17588196f9150b10c55695dbaebee5d',1419749400,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','',0,10000,X'00000014000000063E985FFD0000000000000064010000000000000000000D54657374206469766964656E64',1);
INSERT INTO transactions VALUES(496,'9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602',310495,'4769aa7030f28a05a137a85ef4ee0c1765c37013773212b93ec90f1227168b67',1419749500,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj',5430,10000,X'00000000000000063E985FFD000000000000000A',1);
INSERT INTO transactions VALUES(497,'54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef',310496,'65884816927e8c566655e85c07bc2bc2c7ee26e625742f219939d43238fb31f8',1419749600,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj',5430,10000,X'00000000000000000000000100000015A4018C1E',1);
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
INSERT INTO undolog VALUES(131,'DELETE FROM broadcasts WHERE rowid=487');
INSERT INTO undolog VALUES(132,'UPDATE balances SET address=''myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM'',asset=''XCP'',quantity=92999138821 WHERE rowid=13');
INSERT INTO undolog VALUES(133,'DELETE FROM debits WHERE rowid=22');
INSERT INTO undolog VALUES(134,'DELETE FROM bets WHERE rowid=5');
INSERT INTO undolog VALUES(135,'DELETE FROM broadcasts WHERE rowid=489');
INSERT INTO undolog VALUES(136,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92050000000 WHERE rowid=1');
INSERT INTO undolog VALUES(137,'DELETE FROM debits WHERE rowid=23');
INSERT INTO undolog VALUES(138,'DELETE FROM orders WHERE rowid=5');
INSERT INTO undolog VALUES(139,'DELETE FROM orders WHERE rowid=6');
INSERT INTO undolog VALUES(140,'UPDATE orders SET tx_index=492,tx_hash=''9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b'',block_index=310491,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',give_asset=''XCP'',give_quantity=100000000,give_remaining=100000000,get_asset=''BTC'',get_quantity=800000,get_remaining=800000,expiration=2000,expire_index=312491,fee_required=900000,fee_required_remaining=900000,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=5');
INSERT INTO undolog VALUES(141,'UPDATE orders SET tx_index=493,tx_hash=''14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0'',block_index=310492,source=''mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns'',give_asset=''BTC'',give_quantity=800000,give_remaining=800000,get_asset=''XCP'',get_quantity=100000000,get_remaining=100000000,expiration=2000,expire_index=312492,fee_required=0,fee_required_remaining=0,fee_provided=1000000,fee_provided_remaining=1000000,status=''open'' WHERE rowid=6');
INSERT INTO undolog VALUES(142,'DELETE FROM order_matches WHERE rowid=1');
INSERT INTO undolog VALUES(143,'DELETE FROM balances WHERE rowid=19');
INSERT INTO undolog VALUES(144,'DELETE FROM credits WHERE rowid=23');
INSERT INTO undolog VALUES(145,'DELETE FROM burns WHERE rowid=494');
INSERT INTO undolog VALUES(146,'UPDATE balances SET address=''mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH'',asset=''XCP'',quantity=92995878046 WHERE rowid=19');
INSERT INTO undolog VALUES(147,'DELETE FROM debits WHERE rowid=24');
INSERT INTO undolog VALUES(148,'DELETE FROM assets WHERE rowid=9');
INSERT INTO undolog VALUES(149,'DELETE FROM issuances WHERE rowid=495');
INSERT INTO undolog VALUES(150,'DELETE FROM balances WHERE rowid=20');
INSERT INTO undolog VALUES(151,'DELETE FROM credits WHERE rowid=24');
INSERT INTO undolog VALUES(152,'UPDATE balances SET address=''mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH'',asset=''DIVIDEND'',quantity=100 WHERE rowid=20');
INSERT INTO undolog VALUES(153,'DELETE FROM debits WHERE rowid=25');
INSERT INTO undolog VALUES(154,'DELETE FROM balances WHERE rowid=21');
INSERT INTO undolog VALUES(155,'DELETE FROM credits WHERE rowid=25');
INSERT INTO undolog VALUES(156,'DELETE FROM sends WHERE rowid=496');
INSERT INTO undolog VALUES(157,'UPDATE balances SET address=''mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH'',asset=''XCP'',quantity=92945878046 WHERE rowid=19');
INSERT INTO undolog VALUES(158,'DELETE FROM debits WHERE rowid=26');
INSERT INTO undolog VALUES(159,'DELETE FROM balances WHERE rowid=22');
INSERT INTO undolog VALUES(160,'DELETE FROM credits WHERE rowid=26');
INSERT INTO undolog VALUES(161,'DELETE FROM sends WHERE rowid=497');

-- Table  undolog_block
DROP TABLE IF EXISTS undolog_block;
CREATE TABLE undolog_block(
                        block_index INTEGER PRIMARY KEY,
                        first_undo_index INTEGER);
INSERT INTO undolog_block VALUES(310400,131);
INSERT INTO undolog_block VALUES(310401,131);
INSERT INTO undolog_block VALUES(310402,131);
INSERT INTO undolog_block VALUES(310403,131);
INSERT INTO undolog_block VALUES(310404,131);
INSERT INTO undolog_block VALUES(310405,131);
INSERT INTO undolog_block VALUES(310406,131);
INSERT INTO undolog_block VALUES(310407,131);
INSERT INTO undolog_block VALUES(310408,131);
INSERT INTO undolog_block VALUES(310409,131);
INSERT INTO undolog_block VALUES(310410,131);
INSERT INTO undolog_block VALUES(310411,131);
INSERT INTO undolog_block VALUES(310412,131);
INSERT INTO undolog_block VALUES(310413,131);
INSERT INTO undolog_block VALUES(310414,131);
INSERT INTO undolog_block VALUES(310415,131);
INSERT INTO undolog_block VALUES(310416,131);
INSERT INTO undolog_block VALUES(310417,131);
INSERT INTO undolog_block VALUES(310418,131);
INSERT INTO undolog_block VALUES(310419,131);
INSERT INTO undolog_block VALUES(310420,131);
INSERT INTO undolog_block VALUES(310421,131);
INSERT INTO undolog_block VALUES(310422,131);
INSERT INTO undolog_block VALUES(310423,131);
INSERT INTO undolog_block VALUES(310424,131);
INSERT INTO undolog_block VALUES(310425,131);
INSERT INTO undolog_block VALUES(310426,131);
INSERT INTO undolog_block VALUES(310427,131);
INSERT INTO undolog_block VALUES(310428,131);
INSERT INTO undolog_block VALUES(310429,131);
INSERT INTO undolog_block VALUES(310430,131);
INSERT INTO undolog_block VALUES(310431,131);
INSERT INTO undolog_block VALUES(310432,131);
INSERT INTO undolog_block VALUES(310433,131);
INSERT INTO undolog_block VALUES(310434,131);
INSERT INTO undolog_block VALUES(310435,131);
INSERT INTO undolog_block VALUES(310436,131);
INSERT INTO undolog_block VALUES(310437,131);
INSERT INTO undolog_block VALUES(310438,131);
INSERT INTO undolog_block VALUES(310439,131);
INSERT INTO undolog_block VALUES(310440,131);
INSERT INTO undolog_block VALUES(310441,131);
INSERT INTO undolog_block VALUES(310442,131);
INSERT INTO undolog_block VALUES(310443,131);
INSERT INTO undolog_block VALUES(310444,131);
INSERT INTO undolog_block VALUES(310445,131);
INSERT INTO undolog_block VALUES(310446,131);
INSERT INTO undolog_block VALUES(310447,131);
INSERT INTO undolog_block VALUES(310448,131);
INSERT INTO undolog_block VALUES(310449,131);
INSERT INTO undolog_block VALUES(310450,131);
INSERT INTO undolog_block VALUES(310451,131);
INSERT INTO undolog_block VALUES(310452,131);
INSERT INTO undolog_block VALUES(310453,131);
INSERT INTO undolog_block VALUES(310454,131);
INSERT INTO undolog_block VALUES(310455,131);
INSERT INTO undolog_block VALUES(310456,131);
INSERT INTO undolog_block VALUES(310457,131);
INSERT INTO undolog_block VALUES(310458,131);
INSERT INTO undolog_block VALUES(310459,131);
INSERT INTO undolog_block VALUES(310460,131);
INSERT INTO undolog_block VALUES(310461,131);
INSERT INTO undolog_block VALUES(310462,131);
INSERT INTO undolog_block VALUES(310463,131);
INSERT INTO undolog_block VALUES(310464,131);
INSERT INTO undolog_block VALUES(310465,131);
INSERT INTO undolog_block VALUES(310466,131);
INSERT INTO undolog_block VALUES(310467,131);
INSERT INTO undolog_block VALUES(310468,131);
INSERT INTO undolog_block VALUES(310469,131);
INSERT INTO undolog_block VALUES(310470,131);
INSERT INTO undolog_block VALUES(310471,131);
INSERT INTO undolog_block VALUES(310472,131);
INSERT INTO undolog_block VALUES(310473,131);
INSERT INTO undolog_block VALUES(310474,131);
INSERT INTO undolog_block VALUES(310475,131);
INSERT INTO undolog_block VALUES(310476,131);
INSERT INTO undolog_block VALUES(310477,131);
INSERT INTO undolog_block VALUES(310478,131);
INSERT INTO undolog_block VALUES(310479,131);
INSERT INTO undolog_block VALUES(310480,131);
INSERT INTO undolog_block VALUES(310481,131);
INSERT INTO undolog_block VALUES(310482,131);
INSERT INTO undolog_block VALUES(310483,131);
INSERT INTO undolog_block VALUES(310484,131);
INSERT INTO undolog_block VALUES(310485,131);
INSERT INTO undolog_block VALUES(310486,131);
INSERT INTO undolog_block VALUES(310487,132);
INSERT INTO undolog_block VALUES(310488,135);
INSERT INTO undolog_block VALUES(310489,136);
INSERT INTO undolog_block VALUES(310490,136);
INSERT INTO undolog_block VALUES(310491,136);
INSERT INTO undolog_block VALUES(310492,139);
INSERT INTO undolog_block VALUES(310493,143);
INSERT INTO undolog_block VALUES(310494,146);
INSERT INTO undolog_block VALUES(310495,152);
INSERT INTO undolog_block VALUES(310496,157);
INSERT INTO undolog_block VALUES(310497,162);
INSERT INTO undolog_block VALUES(310498,162);
INSERT INTO undolog_block VALUES(310499,162);
INSERT INTO undolog_block VALUES(310500,162);

-- For primary key autoincrements the next id to use is stored in
-- sqlite_sequence
DELETE FROM main.sqlite_sequence WHERE name='undolog';
INSERT INTO main.sqlite_sequence VALUES ('undolog', 161);

COMMIT TRANSACTION;
