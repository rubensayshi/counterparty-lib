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
INSERT INTO bet_match_resolutions VALUES('be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5',1,310102,'1',9,9,NULL,NULL,0);
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
INSERT INTO bet_matches VALUES('be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5',20,'be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',21,'90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',1,0,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',1,1388000001,0.0,5040,9,9,310019,310020,310020,100,100,310119,5000000,'settled');
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
INSERT INTO blocks VALUES(309999,'8b3bef249cb3b0fa23a4936c1249b6bd41daeadc848c8d2e409ea1cbc10adfe7',309999000,NULL,NULL,'3e2cd73017159fdc874453f227e9d0dc4dabba6d10e03458f3399f1d340c4ad1','3e2cd73017159fdc874453f227e9d0dc4dabba6d10e03458f3399f1d340c4ad1','3e2cd73017159fdc874453f227e9d0dc4dabba6d10e03458f3399f1d340c4ad1');
INSERT INTO blocks VALUES(310000,'505d8d82c4ced7daddef7ed0b05ba12ecc664176887b938ef56c6af276f3b30c',310000000,NULL,NULL,'f3e1d432b546670845393fae1465975aa99602a7648e0da125e6b8f4d55cbcac','0fc8b9a115ba49c78879c5d75b92bdccd2f5e398e8e8042cc9d0e4568cea9f53','88838f2cfc1eef675714adf7cfef07e7934a12ae60cfa75ca571888ef3d47b5c');
INSERT INTO blocks VALUES(310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',310001000,NULL,NULL,'6a91073b35d1151c0b9b93f7916d25e6650b82fe4a1b006851d69b1112cd2954','490572196d4b3d303697f55cc9bf8fe29a4ae659dfc51f63a6af37cb5593413b','0e5a1d103303445b9834b0a01d1179e522ff3389a861f0517b2ee061a9bc1c57');
INSERT INTO blocks VALUES(310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',310002000,NULL,NULL,'88eac1faa671a7ebc61f63782c4b74d42c813c19e410e240843440f4d4dbaa35','e944f6127f7d13409ace137a670d1503a5412488942fdf7e858fcd99b70e4c2a','d5e23e344547beb15ed6eb88f54504d2f4a8062279e0053a2c9c679655e1870c');
INSERT INTO blocks VALUES(310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',310003000,NULL,NULL,'93d430c0d7a680aad6fb162af200e95e177ba5d604df1e3cb0e086d3959538c3','d9ba1ab8640ac01642eacf28d3f618a222cc40377db418b1313d880ecb88bce8','c3371ad121359321f66af210da3f7d35b83d45074720a18cb305508ad5a60229');
INSERT INTO blocks VALUES(310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',310004000,NULL,NULL,'e85e5d82a20fe2e060a7c1f79dc182d3b2da28903b04302e6abe4a3f935ea373','acc9a12b365f51aa9efbe5612f812bf926ef8e5e3bf057c42877aeea1049ee49','ca4856a25799772f900671b7965ecdc36a09744654a1cd697f18969e22850b8a');
INSERT INTO blocks VALUES(310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',310005000,NULL,NULL,'c6c0f780ffa18de5a5e5afdf4fba5b6a17dce8d767d4b7a9fbbae2ad53ff4718','e9410f15a3b9c93d8416d57295d3a8e03d6313eb73fd2f00678d2f3a8f774e03','db34d651874da19cf2a4fcf50c44f4be7c6e40bc5a0574a46716f10c235b9c43');
INSERT INTO blocks VALUES(310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',310006000,NULL,NULL,'91458f37f5293fca71cddc6f14874670584e750aa68fbe577b22eac357c5f336','ed50224a1ca02397047900e5770da64a9eb6cb62b6b5b4e57f12d08c5b57ab93','c909c99a5218c152196071f4df6c3dfa2cfdaa70af26e3fc6a490a270ff29339');
INSERT INTO blocks VALUES(310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',310007000,NULL,NULL,'a8f0f81aebdf77ee1945c2199142696f2c74518f2bc1a45dcfd3cebcabec510c','1635973c36f5d7efc3becc95a2667c1bb808edc692ff28eaa5f5849b7cdb4286','fb670f2509a3384f1c75cfa89770da9f9315cbda733fd6cdb1db89e7bbc80608');
INSERT INTO blocks VALUES(310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',310008000,NULL,NULL,'df7cae2ef1885eb5916f821be0bb11c24c9cabdc6ccdc84866d60de6af972b94','e7dde4bb0a7aeab7df2cd3f8a39af3d64dd98ef64efbc253e4e6e05c0767f585','4e11197b5662b57b1e8b21d196f1d0bae927e36c4b4634539dd63b1df8b7aa99');
INSERT INTO blocks VALUES(310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',310009000,NULL,NULL,'1d8caac58a9e5a656a6631fe88be72dfb45dbc25c64d92558db268be01da6024','74b7425efb6832f9cd6ffea0ae5814f192bb6d00c36603700af7a240f878da95','fc53cd08e684798b74bb5b282b72ea18166a7ae83a64ff9b802ae3e3ea6c1d13');
INSERT INTO blocks VALUES(310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',310010000,NULL,NULL,'ab78a209c465104945458dba209c03409f839d4882a1bf416c504d26fd8b9c80','d4bdc625dead1b87056b74aa843ae9b47a1b61bb63aafc32a04137d5022d67e4','2398b32d34b43c20a0965532863ed3ddd21ee095268ba7d8933f31e417a3689e');
INSERT INTO blocks VALUES(310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',310011000,NULL,NULL,'5528fec20bfacc31dd43d7284bf1df33e033ec0ac12b14ed813a9dfea4f67741','205fad5e739d6736a483dde222d3fdfc0014a5af1fa1981e652a0fe948d883b3','3f9d7e91b4cfc760c5fa6805975002c258a48e2bc0a9e754bcc69be8e0cb74e5');
INSERT INTO blocks VALUES(310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',310012000,NULL,NULL,'fa66dc025cbb75b67a7d4c496141eb5f6f0cc42134433276c8a294c983453926','ff933c5dfc4364dc6fa3faa2d5da4096bd1261cc53f74a20af9e55a4dda2d08b','1993f3234c4025eab5bb95ac516594b99c4068b1352652f0327f4fa6c8684d17');
INSERT INTO blocks VALUES(310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',310013000,NULL,NULL,'442621791a488568ee9dee5d9131db3ce2f17d9d87b4f45dc8079606874823f8','337f673aa1457d390abc97512fbaa5590e4f5e06d663e82627f70fd23c558655','dbe86ee55a221aa0541367039bb0f51ccac45530dd78b0a9b0292b175cef6e56');
INSERT INTO blocks VALUES(310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',310014000,NULL,NULL,'8551367f346e50b15c6e0cca116d1697d3301725b73562f62d8e4c53581e7bd0','f1f9d937b2f6f2221055c9f967207accd58a388a33677fd7572c882ce2e65b0e','9e054d7d63e96da38b2bb4715a627e3f4f322b8d86a8ad569a9e2e780c036f46');
INSERT INTO blocks VALUES(310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',310015000,NULL,NULL,'29de016d6301c2c9be33c98d3ca3e5f2dd25d52fd344426d40e3b0126dea019a','e0051523f6891110c18a2250db797d39d6ffd917aeb446906f8059b293e20be6','98ac9ef994c9b058395d5726fb29303fb90ae1cb4130535c9a9525e61dda0702');
INSERT INTO blocks VALUES(310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',310016000,NULL,NULL,'32ffd4bdf9b1f8506a25b4d2affe792d1eccf322a9ab832ec71a934fea136db9','0c90d5431f84b4fd0739bfe750ddd2b65f1bfee26f3b576f2df5dc77537389ab','8588b5ccadd1f93f8bce990c723efb6118b90d4491cc7ada4cda296469f5a635');
INSERT INTO blocks VALUES(310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',310017000,NULL,NULL,'64aa58f7e48dfa10bb48ecf48571d832bb94027c7ac07be0d23d5379452ce03b','ee2aa8e8b5c16ff20dc4a37c5483c7b1b9498b3f77cab630c910e29540c3a4f9','a5b974e881ec4e947974f2441f5af722673d08e55dc3daa5d5e0a717080962bf');
INSERT INTO blocks VALUES(310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',310018000,NULL,NULL,'8d8f404bdc2fb6178286b2581cf8a23e6028d5d285091fa0e67e96e6da91f54e','be9eab485a9d7cba91072ae17389b123dc865fd84b70750f225c76dcdaac1f27','65f30e31bc64ea4f4a2cb6db890a5769b97b32e0bf3a992302b619bfac0af60e');
INSERT INTO blocks VALUES(310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',310019000,NULL,NULL,'945a8fd2f57cfd5ddab542291fb2e2813762806b806a3e65e688321fefe1986d','7f518d7dec7a31e52840d975a26c5d96d3a202d30d4977205fc14cf76b93dcf2','da444b5d4accf056c6fade57c38869d51a3d9ca102df5c937675398b4b6060b0');
INSERT INTO blocks VALUES(310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',310020000,NULL,NULL,'3393abc111ee337132103ca04b4f8745952cd03ddbd6efff58a589e00a48fa21','50cc106fcf8581a7d1ea0ccdc6c5251b6f36b6a64f12581ab77ab339bb112ec4','ee59a8bb5eafdaf12ad7c8e55a19060451a959b03a9fe0b23a5628f680b04b6e');
INSERT INTO blocks VALUES(310021,'7c2460bb32c5749c856486393239bf7a0ac789587ac71f32e7237910da8097f2',310021000,NULL,NULL,'d05fe9705db7b30e6ea6b18e9ae92ba794dd72f25b4e33daf4d46b3b609a02de','648f5633ea84b04f3c82873eb245f1632b00e61112a79632e4608be8915d80f9','1dfc96f94d02b90f20c16923937b21a5701ab03699f647bb08e0d1ae0258171b');
INSERT INTO blocks VALUES(310022,'44435f9a99a0aa12a9bfabdc4cb8119f6ea6a6e1350d2d65445fb66a456db5fc',310022000,NULL,NULL,'c2b2b2c3bdd895c74f3ea22db3d9c66301578436b6fa9175ce0b242c4bfaccc5','26bf7bb14922abb270a25ae77abb45a09271deb901c22dc304b019d610f06f3d','5538c6d7b34b2b2e0c08106feeeea791542e1740ab8dd6fdd8be9cf4dfc17d83');
INSERT INTO blocks VALUES(310023,'d8cf5bec1bbcab8ca4f495352afde3b6572b7e1d61b3976872ebb8e9d30ccb08',310023000,NULL,NULL,'fad5b61545d8ef317918f07df063554d4f321c0ebf462f759513212960bdf523','cb647a71c09e5bf06576afbd426ddf13e2151e819b07efb2929db444769e4531','9e420592fcb4ba1bb1fc537ef50f118992964090e525d62c6f47abbf65fd6329');
INSERT INTO blocks VALUES(310024,'b03042b4e18a222b4c8d1e9e1970d93e6e2a2d41686d227ff8ecf0a839223dc5',310024000,NULL,NULL,'61a71d0ac67eba15c63a531f797e6d68c83613489730bc2b4e4054094f63105a','b3990893e9f8f00cefb139c043815e301e951cb919c59e58644034b33551b480','1aa35c67d550dd3e39d6b1e99cee07decd694edba633db9295c72207d793cdc7');
INSERT INTO blocks VALUES(310025,'a872e560766832cc3b4f7f222228cb6db882ce3c54f6459f62c71d5cd6e90666',310025000,NULL,NULL,'f7d41404c3d1e57bbc390af958d1596212112068e4986954d11ff8abd13bc8e4','540d181af55b17757869eb48ef4050732f4bb8d7bb4667793e05770f33dd7f4a','23ddec44887f0d9d638316bcf4524e4a107f7b8f1c2739ebbd3dc160196d0524');
INSERT INTO blocks VALUES(310026,'6c96350f6f2f05810f19a689de235eff975338587194a36a70dfd0fcd490941a',310026000,NULL,NULL,'31530d7febb577d7588e12d10629fd82966df48a93a613a480879531d5dbd374','26a5ce353f383d9bf732d119bf947380fbf7cb7c10d9b65711da6d08f940b692','55fa2a20ec89af2c4cc82aba44c0028fbaf0f166f0cd2dc5c9d02d9e6f4b657f');
INSERT INTO blocks VALUES(310027,'d7acfac66df393c4482a14c189742c0571b89442eb7f817b34415a560445699e',310027000,NULL,NULL,'f54085346ae4608c57c55d321a413a00ffeb85499138559d7d05245f57cc0da3','21eb7db4dff69979f960b34b3d8632d417be2d9087399beaf50cf3a945c101e9','19d6fcff51a87f131362e8bd7f8bbd800e985cd54321ba8a233e3341bff64d11');
INSERT INTO blocks VALUES(310028,'02409fcf8fa06dafcb7f11e38593181d9c42cc9d5e2ddc304d098f990bd9530b',310028000,NULL,NULL,'a841b7f634fc24553d1c8cb2d66fc3103293dcfd297cb5bf241b0c5da84bd376','d8f78dad14405cbd461ccfcacbfdc544ca5e603df3d3021b58d5393560e0d56f','4359591ae7f06509856433c765a1ac49724211e941408c17f3cf28853758a13d');
INSERT INTO blocks VALUES(310029,'3c739fa8b40c118d5547ea356ee8d10ee2898871907643ec02e5db9d00f03cc6',310029000,NULL,NULL,'69d40c69b4989f7a59da99b56577b0651887d9422757e38d5410379f95fda641','ba57b2e4eb9132feaa3380491358c8706c44204f7f7a4f7f0060a3ff8a640b97','243c7e0f8a44221eeb8a0e448d7ba8bd8372e6c3a76a6e9b36ddada846d9e43e');
INSERT INTO blocks VALUES(310030,'d5071cddedf89765ee0fd58f209c1c7d669ba8ea66200a57587da8b189b9e4f5',310030000,NULL,NULL,'192fe51d3a7af659670a8899582c29aedf3a5608ca906b274ce986751dad2d7a','29663f45b5eae8b77bb8ec5351e0012efdf03a17fa5d132dd8da0f432acaf9e0','91193c1f216574251bed7b42946b450587bd765a4b5f4138924dde66e3fd9297');
INSERT INTO blocks VALUES(310031,'0b02b10f41380fff27c543ea8891ecb845bf7a003ac5c87e15932aff3bfcf689',310031000,NULL,NULL,'125784cdeba1e433b3411c368cdf676efb33021f51c26a8b2bd6ec00fe4f767d','fe36b2450774dfc7db346c45833fbd401d8a234ce87544cd9b373cbc4b79b61a','267edd0d998a1957ac14462b1a5af7055297ed1034e995123512c0d17654e6b7');
INSERT INTO blocks VALUES(310032,'66346be81e6ba04544f2ae643b76c2b7b1383f038fc2636e02e49dc7ec144074',310032000,NULL,NULL,'fa7832080a2b6ae8829794d70603351755fa4816f15a6e92716f83265daa59a4','258bea96c9e1d774eb0fedc7fe99a328b62ee26f557426d036147d1eea033e04','17d2cb78af47a0cb58a0191eacdce2b7c3f27d4ddc342fb11f619ecebc42ae94');
INSERT INTO blocks VALUES(310033,'999c65df9661f73e8c01f1da1afda09ac16788b72834f0ff5ea3d1464afb4707',310033000,NULL,NULL,'7b86f430bc44ad5d81a43b5a8ea118b458d995e3832d88bb74bc62429194e45c','ce67ed4dddf1582ac85c4825c5f9d059e6c64542e5d0fa6f489858008948a989','b3834107703858d2f18470e6d6f939d756c9e6a6407a40a78cec8636832749a2');
INSERT INTO blocks VALUES(310034,'f552edd2e0a648230f3668e72ddf0ddfb1e8ac0f4c190f91b89c1a8c2e357208',310034000,NULL,NULL,'1f2c5ac4375f77fb79612d343dd5fc4489cf94ff983fc05ba2009a9e390d6c06','4e7e92c9296993b9469c9388ba23e9a5696070ee7e42b09116e45c6078746d00','0ff41ea30f20b7bf90c66003f29d41bf7bd7c526881db0b645bc1a76911afb63');
INSERT INTO blocks VALUES(310035,'a13cbb016f3044207a46967a4ba1c87dab411f78c55c1179f2336653c2726ae2',310035000,NULL,NULL,'81cdae9b978935ad40a1032e7f22ddd7117b9c7580d6d7e4b7e20d1c875f5e63','98919ef5963b86630a60e75cef8b95f24508d65d29c534811a92ed5016cc14dd','7bf7cdcf88fde6747b8ad3477bb1ea645cfb95ff7d6cfeeab33c87eee54cf744');
INSERT INTO blocks VALUES(310036,'158648a98f1e1bd1875584ce8449eb15a4e91a99a923bbb24c4210135cef0c76',310036000,NULL,NULL,'ff02952dce15c249501d8485decad0ad9fe02fda766b7b83720806f726d02ee4','ef9adfbd23bebd3c047db6d82d7d0ca0479bd14fcfeb95b9a4ef6963d7294b99','623dd05dbd17d04175b720d8b1d37b9137f1ea83ddfb4c98ba2c91dfa5f4df46');
INSERT INTO blocks VALUES(310037,'563acfd6d991ce256d5655de2e9429975c8dceeb221e76d5ec6e9e24a2c27c07',310037000,NULL,NULL,'760e5a00feb6c8c4baf4421ad07be2af962bfcac7705b773484b449356d6c230','51cbb75a27acf3a67b54f6b64a4f4b86d511fe3d6fe29526fe26238e44a3bd4b','a8dfa56a89e1475996abb64ba1b4ccc878c44540b31bbdfd937b61db889d4dce');
INSERT INTO blocks VALUES(310038,'b44b4cad12431c32df27940e18d51f63897c7472b70950d18454edfd640490b2',310038000,NULL,NULL,'c79381c51fa93cc320d8bf19c943f98232a99446ac098ff66823cf691e0fa01c','cd45648e95377f9c8503ba747cd2a7312ac0c9108316eb5a77a06fb9fd0df474','7f15dd0f7c34494fc4c0a1fab509d3de57867acb7277a4e505cbdd0486457330');
INSERT INTO blocks VALUES(310039,'5fa1ae9c5e8a599247458987b006ad3a57f686df1f7cc240bf119e911b56c347',310039000,NULL,NULL,'7382f007315783c9a6ffd29bc0eaa62282c6ec72c5fff09322d6dea6b0ee3a96','ffe0bc6eeace43428a31476e259bf5dfe33c33f70c18001504f158d4be026b5c','cec197d33ac2efeb87943aa58e10272cf7bd662984a64929e18530e4c839f73b');
INSERT INTO blocks VALUES(310040,'7200ded406675453eadddfbb2d14c2a4526c7dc2b5de14bd48b29243df5e1aa3',310040000,NULL,NULL,'38d3b548be554a0ae92504244a88930b989ea6fefc9bc59c69b68ed560afee9a','3a96f2cea7c289afdd0b6c987bc0081a8726d08eb19bfe3eb9b518442324fe16','f972ad30b7564a70a05264cabff7dbdc6f43fcf97cc2c253031d7df804622135');
INSERT INTO blocks VALUES(310041,'5db592ff9ba5fac1e030cf22d6c13b70d330ba397f415340086ee7357143b359',310041000,NULL,NULL,'0c1c7aa19c015a67da214bf8a6ae3d77979a09de6a63621e320a28ceebdbf333','9f35a2e8a94c8a81ddedfc9b0178d7a07f42fee1221b6eca038edc16b4f32495','d98a7e2b0a03a6fe91fc8a5a51412d00b9130f0b1906238085fa917536998212');
INSERT INTO blocks VALUES(310042,'826fd4701ef2824e9559b069517cd3cb990aff6a4690830f78fc845ab77fa3e4',310042000,NULL,NULL,'9d20f77d4afff9179cffe46574f1b2dd23d2987142c943de05e411baee2dbf05','9ba21b4c3e4696a8558752ae8f24a407f19827a2973c34cc38289693ea8fe011','5b9e3fda69ff3d175c5871d2c26513b82479e30c3612bef95b03b4d9a64cf33b');
INSERT INTO blocks VALUES(310043,'2254a12ada208f1dd57bc17547ecaf3c44720323c47bc7d4b1262477cb7f3c51',310043000,NULL,NULL,'d818e5a1a5cb6c59771b63997a8737cdb041c3579de1ecd808a269f5d72a3abf','ea9ae316a3d419d8d383d8cd5879757e67825eaba0f0f22455bdee39be6b3986','16d9fdbb509f0abe6ad2824a85e059a01d733ecdbb3d02d3dc5f2172020b348a');
INSERT INTO blocks VALUES(310044,'3346d24118d8af0b3c6bcc42f8b85792e7a2e7036ebf6e4c25f4f6723c78e46b',310044000,NULL,NULL,'9de166ff18c5eec97b838292ae894ce18e5a890e8a841a294b2d14894c60a0d7','5ed66185648c567cd211fa03b6d887f21854c231743ad20885a83073bf68b1e2','597f45d7ce19813ff9473721f0897baac61e97d11608d1d6e209efddaa67dadd');
INSERT INTO blocks VALUES(310045,'7bba0ab243839e91ad1a45a762bf074011f8a9883074d68203c6d1b46fffde98',310045000,NULL,NULL,'bb3c0a260dc082534c95e894751e38e80de117b091bc0e34c66134d374b8db2d','638e948d625f063dfd65ebc57bb7d87ecfb5b99322ee3a1ab4fa0acb704f581f','c2c57a8b58f7b19acec45896093fff26c73994bb7b2a849e42a38d50ff7c8610');
INSERT INTO blocks VALUES(310046,'47db6788c38f2d6d712764979e41346b55e78cbb4969e0ef5c4336faf18993a6',310046000,NULL,NULL,'b4605c50ee3e5e2958c908e099563cf997e20932cc2370109ab50049e43723cf','8e4ef49f870af7dde396a108f4c1d5c4286a302a573c1bb1b6a45c423dc7cd2b','4dbab042d742d2548ce81853ae36a362faa304090b2fd8686793fae0e3090cf5');
INSERT INTO blocks VALUES(310047,'a9ccabcc2a098a7d25e4ab8bda7c4e66807eefa42e29890dcd88149a10de7075',310047000,NULL,NULL,'b840a7af6301c798c9a6670308a2684051ff8f3fb2e69bddaafa82cfd3d83186','1e61e70016a9c18765c2332d9b3e7a64e119a7dbf533256fc1b88f36c2404055','c1100a1111baa1ad9f7fb39c146b78b65c427741e91617fc1f1637a16bf62380');
INSERT INTO blocks VALUES(310048,'610bf3935a85b05a98556c55493c6de45bed4d7b3b6c8553a984718765796309',310048000,NULL,NULL,'6bd591d3336ea112789ad6675a9b1d8e1578fe42e44ca7f7be5557089d374c3f','ad6559d820513781cb3bd412c74bfd5575595078e42007573a0da9f208bf5aea','70dd3957cb5dc4ea2623bf5e1d474475d525e13159cff152b77bd7cce325e00e');
INSERT INTO blocks VALUES(310049,'4ad2761923ad49ad2b283b640f1832522a2a5d6964486b21591b71df6b33be3c',310049000,NULL,NULL,'04fe1e6631d503a9ee646584cda33857fac6eeca11fa60d442e09b2ed1380e5c','f14c6718b43729126cd3b7fe5b8b4dd27dcec04f379a30f69500f2f0b2f36715','dd5b8edb0019ca4157a3fea69f3c25d2c69b3eab62aa693e8972598a0022e9da');
INSERT INTO blocks VALUES(310050,'8cfeb60a14a4cec6e9be13d699694d49007d82a31065a17890383e262071e348',310050000,NULL,NULL,'dc73bfb66386f237f127f607a4522c0a8c650b6d0f76a87e30632938cf905155','2a118b6fc1b1c64b790e81895f58bca39a4ec73825f9c40a6e674b14da49e410','027181bdf4ce697b5ba2ad5fb2da0c7760ccc44805f7313fa32a6bcfc65bba56');
INSERT INTO blocks VALUES(310051,'b53c90385dd808306601350920c6af4beb717518493fd23b5c730eea078f33e6',310051000,NULL,NULL,'e4eea2d144c8f9c6dfe731efee419056de42f53108f83ebee503c9114b8e4192','a910be4cd65598d4b1031a0afb11644daf91338b7d5714ae5f0619ed1c02aa35','a1ae010bdf7178d602fdda887c947933af3e57f2bcb89b9a859f009468a3aee5');
INSERT INTO blocks VALUES(310052,'0acdacf4e4b6fca756479cb055191b367b1fa433aa558956f5f08fa5b7b394e2',310052000,NULL,NULL,'8d12b561e7cf87b0aabe000a93a57e5f31db75510b1e9feb19b4f557cc0e6604','736cf75895c6b0a0899baca213f46b5f1043ae6e774fd85c4e965363c58ad76d','f1af0e8b196a6f47d1b61cd550615b3d4bce1af8667a7668036851916da25b33');
INSERT INTO blocks VALUES(310053,'68348f01b6dc49b2cb30fe92ac43e527aa90d859093d3bf7cd695c64d2ef744f',310053000,NULL,NULL,'f47b81b3dfc522d9b601d1776fa2deef8543ca077cb0743556cd970bb119d640','b6176107f5ed5d22352b9fc00d444c4d62c177147018e9a3123a5ddf86113a92','9def6bd964910651ad1148c9e070b677df998e5fe2d89e0f7526f4b306e88036');
INSERT INTO blocks VALUES(310054,'a8b5f253df293037e49b998675620d5477445c51d5ec66596e023282bb9cd305',310054000,NULL,NULL,'df191ed877eb1856d6780a717c04d6925246cdee7dd6df74216ea983560d5a2b','22ed22ae4cabc3bf271243f79c3a4d2c42e5fe86978a9f860659b2037e69ea0b','f182aa045d7baaf72eb3a28f9488bc3d0adfcccb270f5a825e7ff72cb6895c34');
INSERT INTO blocks VALUES(310055,'4b069152e2dc82e96ed8a3c3547c162e8c3aceeb2a4ac07972f8321a535b9356',310055000,NULL,NULL,'4b0ab72111202b1f9a5add4bf9a812df203cb6761a8d16b5f7a8b9ed6f2b2476','fd10402625c50698b9db78754941b5f3961f19557c5cbdae9321e73a59da85af','f36a4fb85c64a4959a940ba247d5c945e33f41009ca6bbd776fe6c847b65f5f6');
INSERT INTO blocks VALUES(310056,'7603eaed418971b745256742f9d2ba70b2c2b2f69f61de6cc70e61ce0336f9d3',310056000,NULL,NULL,'8e76b5be6a94e1b50ba16fe265965d4cba01b792216485c54360052e78788f20','9137c235b9218da6194b0224675ac200ce37e57a280682875b64b614d998f1cd','735e35e38481317f7c6b8b948297ad669c422747f40e865601d38da6ed971d89');
INSERT INTO blocks VALUES(310057,'4a5fdc84f2d66ecb6ee3e3646aad20751ce8694e64e348d3c8aab09d33a3e411',310057000,NULL,NULL,'e14dde2bfbe4f9076b7ba548aad37269752858361af094b4be8b956c0a28b9c5','dae4bad204dcb46ea70311d316ad02fa49d9643608dd443861402705ffe7f7db','e7c7f03c38f40e3556a5baa91db4a738cdec7e564de52b39d82990b2d5fb98bb');
INSERT INTO blocks VALUES(310058,'a6eef3089896f0cae0bfe9423392e45c48f4efe4310b14d8cfbdb1fea613635f',310058000,NULL,NULL,'b986e5f6486ceac7f1af41b1da968e453cc19376d588d8e884439b51313d6e30','8dcaccbcaef1b98d192f0b8d62f5b371043d676401c2120be4eda65786fc68c7','ea8bae443c8df855e40e8bcff3dcfe618b1d46a1ec783b106c31e6424b10bfac');
INSERT INTO blocks VALUES(310059,'ab505de874c43f97c90be1c26a769e6c5cb140405c993b4a6cc7afc795f156a9',310059000,NULL,NULL,'da978ee5b06812ee42cda43e1d9943c4e34e9e940cb0461f0ed463b9299402d8','96de4dc34f8de9a895d1a45bfb1d72e887ac3c168f2759e9a27a892eb398d63b','81c4338c8e7197c802f1ad8716aedc5a359a50460d08ad29991f4be832ea68c3');
INSERT INTO blocks VALUES(310060,'974ad5fbef621e0a38eab811608dc9afaf10c8ecc85fed913075ba1a145e889b',310060000,NULL,NULL,'09ccea87988cc385b9d2580613581b90157f1366d27cd3dc1a4385e104430d15','0595e85b26408a75ce220d7afb0111085b2e90aff588a1c828ff389b4c256b4c','589d6d7e670f0c96db995c4acf20385ed3f14e078bc7ac7e8a36663be49602b9');
INSERT INTO blocks VALUES(310061,'35d267d21ad386e7b7632292af1c422b0310dde7ca49a82f9577525a29c138cf',310061000,NULL,NULL,'4caebeb5ab6468e116cc0cf137977649a15dd30d9b214a5081057a551174ec48','5e3a2cfbf7e322f28a3254c2af408baae0578e333ed178a80cf416580d5425c7','ce4a967dfa5f4db7c546fe6b75f8fc29dc823944788587ebb63b79bd03fcd086');
INSERT INTO blocks VALUES(310062,'b31a0054145319ef9de8c1cb19df5bcf4dc8a1ece20053aa494e5d3a00a2852f',310062000,NULL,NULL,'51cb3f1005127e3240721c47805d67a123afdc40084692a9cc2b3215cec99dc3','a8a4c0baa06a4304469c6b9fdeb4ba167e1b795226bf03b655ff759f0b7be9e5','0184f70bf24b7b95fe1eadab1b35cfd5971bafe03044204dd2726339d413ac34');
INSERT INTO blocks VALUES(310063,'0cbcbcd5b7f2dc288e3a34eab3d4212463a5a56e886804fb4f9f1cf929eadebe',310063000,NULL,NULL,'e12864a0f955320278c215897cf4f65e5c378e534294b0bb90ebd7e4b5efd4f7','d777885ff67ef99793a8cd4f4d159580efa194a505eeed1f46a7b003d74d3818','c8f710d147f338a3288556f9eebdd109a796daa60ef1ec60e53bfaa7ccbc79e0');
INSERT INTO blocks VALUES(310064,'e2db8065a195e85cde9ddb868a17d39893a60fb2b1255aa5f0c88729de7cbf30',310064000,NULL,NULL,'ee27c3b46aa890d18be950006879874a094ecddd086db195e032fb4fe12559f5','e6a5b1e0c2bdf548abd1826994529d5ec68310fd8a74e05ec5dde281de52ff9c','22cad399931fbb4c620c887b3dd0f0e5284e1ab45f74900b7c4706868ca2c936');
INSERT INTO blocks VALUES(310065,'8a7bc7a77c831ac4fd11b8a9d22d1b6a0661b07cef05c2e600c7fb683b861d2a',310065000,NULL,NULL,'d40dbc4b5faaf8918f9cae54e5a247e3904dc65994ce0f04f417c1a595404464','7ce3ffe967f502ba033d3d51165e754b77e6c4a28cc4e569f81cf0a817c1536d','e930bfd4b6eac1822485cfa3953c550525ad1d1a6ba5177677e481fcf24edfe6');
INSERT INTO blocks VALUES(310066,'b6959be51eb084747d301f7ccaf9e75f2292c9404633b1532e3692659939430d',310066000,NULL,NULL,'19f2b00477a6fae0e10f4693d949cb409b1ed74ad20dbd9aa4a7f1f17cb813ac','2da61818fd2c6fc3a15d998ba79482cb48c49f5a9f195ae4ddba291cac9b416d','e6de9d8f4d9c0a5ec3a51ab0f886f4fd35fd9cd8d1bb6afb2b615b58996bb26a');
INSERT INTO blocks VALUES(310067,'8b08eae98d7193c9c01863fac6effb9162bda010daeacf9e0347112f233b8577',310067000,NULL,NULL,'d72891c22fcea6c51496fc1777fa736ef5aba378320a1f718d597f8f9fea3c7d','72cb3676cfd73767e4499bb405f6e07ec421a39239754d75afd8c08cdb49ae45','2e750809d79b40966d2533d7d726cff2b802cc2678244d3e235508750ca838da');
INSERT INTO blocks VALUES(310068,'9280e7297ef6313341bc81787a36acfc9af58f83a415afff5e3154f126cf52b5',310068000,NULL,NULL,'5793e10b8329d3ac71aed6347dfcf61fc7b74ca162ad99918f5c20065f8d0746','07a593978e6f669c9b378ffd115c951da48fad08b55a7d5adb7ae96bef306061','1ed832c547e29ffa2cb45660129f32f56613d2fcc0d36dbaf3872ab47e77f582');
INSERT INTO blocks VALUES(310069,'486351f0655bf594ffaab1980cff17353b640b63e9c27239109addece189a6f7',310069000,NULL,NULL,'61040e7c1a58f41d708785347f4985c1fb522b6f947d3e14dacd91157e153ab7','4822a18f5a177a8a22f1b234c181389614489a33ebf3944b1107acdce0528bb3','6de08d8b4df6538298c2599a166548d12175ffa9a7db682df4111e03107bfd22');
INSERT INTO blocks VALUES(310070,'8739e99f4dee8bebf1332f37f49a125348b40b93b74fe35579dd52bfba4fa7e5',310070000,NULL,NULL,'ce115625fbda90a0f261b2c524108a7393078cb4c3f861d6d7846501c7960008','54364047ce52153883e68adef9b681266dd725f8e45af89b1dcff3c9edd525e3','5f53766a278e20f6eb70bf3b8786d4b3191a0f76358a97ad89a2dc901cb3ac16');
INSERT INTO blocks VALUES(310071,'7a099aa1bba0ead577f1e44f35263a1f115ed6a868c98d4dd71609072ae7f80b',310071000,NULL,NULL,'3c2d4d81e90a42a0c18e9c02b8a59f99e13f2a084ee66b4b1bd410077adc383d','08991b69e486f1032749e530eee24ffd2d849b1f46aa6ef2f2d5a5202fe06e97','be328287331db13c6a631277a635da9c87768946ac8380ae14fc2fbd5aec6303');
INSERT INTO blocks VALUES(310072,'7b17ecedc07552551b8129e068ae67cb176ca766ea3f6df74b597a94e3a7fc8a',310072000,NULL,NULL,'8a28e33306582346f1d965a0393621b4aa307f6614c84369064465f95a6c727e','e0cd2ae87966825b5f8ebd21c7629fec5ea6ae0f0964ed137f0776d2a1130696','85c6c68b477ddb33e954a67c3116e75da8012443888ca1638f471481de4c899f');
INSERT INTO blocks VALUES(310073,'ee0fe3cc9b3a48a2746b6090b63b442b97ea6055d48edcf4b2288396764c6943',310073000,NULL,NULL,'e6c5b393a21df54479c4cd8e991b37d877794166c19b9f61ad7e47eb34f63bdc','4b2ece53331a483fef54d87f0da7e6f712148c0f35388439b73f2aecedc57a12','994a079c0bb105d73fc0464453adef90844be7be0426ebc47bbad7bef29fed83');
INSERT INTO blocks VALUES(310074,'ceab38dfde01f711a187601731ad575d67cfe0b7dbc61dcd4f15baaef72089fb',310074000,NULL,NULL,'b2db452daf280f1cc5f02668d0cbd33732a2fe9f04307d9c072eba97c95acf5c','28a44c85c432e94d1e15ad9675d2927a983bcde0ad0cbfe47a7d87da00df9f66','252b3e5ce81eddfd53c6086a2aaf6630aa2fe15f3c55b364c4b8f586f4228eb0');
INSERT INTO blocks VALUES(310075,'ef547198c6e36d829f117cfd7077ccde45158e3c545152225fa24dba7a26847b',310075000,NULL,NULL,'09998443cf1cd79e193a7b09681ae07ea9a835458151a7f8c7d80a00c5d8e99a','398cf0362d19717ca11dd2a5f022a1ec94122f7bcfba0c4f25a793826b1a0892','6a6f7117e0c8814d4b6a7245b8e9719dbf727738c6efc5cd81aa7071dd50de53');
INSERT INTO blocks VALUES(310076,'3b0499c2e8e8f0252c7288d4ecf66efc426ca37aad3524424d14c8bc6f8b0d92',310076000,NULL,NULL,'a0be1e88f10b5214f7c12dd32d0742537072d5eb3e54f9abf57a8577f7756d7e','5a17953bd90e4ad629cc7c24098e50a5ea86e84a5796b5db5959c807e0f9eba6','f3bcb0d573f3e7505220ce606a9c6896ee1a32e71fcc6d138b4c86c7e5095a8f');
INSERT INTO blocks VALUES(310077,'d2adeefa9024ab3ff2822bc36acf19b6c647cea118cf15b86c6bc00c3322e7dd',310077000,NULL,NULL,'d41e39038756ee538d9438228512e31b4a524bbd05bc9b9034d603fd20e00f05','0491cd1f3f3c8a4b73d26a83aa18067ec31f868df96ed4667f8d4824a768a4d3','81928269ae8abf6fec03eb3775ba5b2292de5f14a0b75f780e705c973b88871f');
INSERT INTO blocks VALUES(310078,'f6c17115ef0efe489c562bcda4615892b4d4b39db0c9791fe193d4922bd82cd6',310078000,NULL,NULL,'996092432a2d94df1db34533aa7033e672fac73de5193a696c05ae7c30d75247','ebe0a3e1269a54e03ae9b7b8ad5f00a1e88b4bdbf2c7485ac1188eac31c0a4b1','ea1514429815a58d3b87a8358d2f7171db18db6a308b31a22c5dcfbcc36fff92');
INSERT INTO blocks VALUES(310079,'f2fbd2074d804e631db44cb0fb2e1db3fdc367e439c21ffc40d73104c4d7069c',310079000,NULL,NULL,'e3f536e930e39b421e3a0566eba6b8f5f781ad1ff48530a5671752fd3eaf35ac','8dca0f21abeff518ea5c6a0fff3f3c89e0d6b263a72adfd36cbf911a306080f1','70b5ccd472fe0afab81fd3cfd7a51a2f384e7c8bb03bf0b7e8b598c999893e42');
INSERT INTO blocks VALUES(310080,'42943b914d9c367000a78b78a544cc4b84b1df838aadde33fe730964a89a3a6c',310080000,NULL,NULL,'57122dc41d7de2bdc65002905617c357496432fa4d80af48f4ca69ba1332e634','0ebd79095ee1e751b4b694c04d31fe2246db4558ee9763504c9802c2a342e817','f8c3dcf3dc7daad074cc82a00eff3086bb6ef8cbe063245446d096b20dfce677');
INSERT INTO blocks VALUES(310081,'6554f9d307976249e7b7e260e08046b3b55d318f8b6af627fed5be3063f123c4',310081000,NULL,NULL,'3a0fc7b2f0396d257a0a5c5a313910cb4073e4c79ef8cf0d3cd12f494e563105','2eec4afed90d334123b8299d50c192db4b6b7ea0f4868734ea435e5f2cd7c901','4cc5061efa8f9165f844f5ce14b6dd0602f15027dfd64dff653f3785659e434e');
INSERT INTO blocks VALUES(310082,'4f1ef91b1dcd575f8ac2e66a67715500cbca154bd6f3b8148bb7015a6aa6c644',310082000,NULL,NULL,'e876c406f682ed6f0dbd6e4c97bac13409cd400b59e894eebeb3252be306494a','91c5071bbab5368e2338657982adb58c861546c0c0ba9fe9abd6b8b781e415ec','11d09e0d0361dedfb42e1c7a15bdb6a190967a5d59e833605bd6c4a145f6fceb');
INSERT INTO blocks VALUES(310083,'9b1f6fd6ff9b0dc4e37603cfb0625f49067c775b99e12492afd85392d3c8d850',310083000,NULL,NULL,'533fc3eea80caa46cf8fd62745c5d21d09f32b18eaca70283a4bd72924c2100a','bf0da4a320545ab08a86a86a81d5702f7d493e6c3173344dc19941c8a527f4c6','735ab4d3b9692aab21e75948c17a197d1395bb1ec579e450b7be53b389b3e7a1');
INSERT INTO blocks VALUES(310084,'1e0972523e80306441b9f4157f171716199f1428db2e818a7f7817ccdc8859e3',310084000,NULL,NULL,'e3fd22f2e1470246ca99c569d187934f4b7bbb1eedb9626696cbaf9e2b46253b','ebd03846d979ea8af53d9853c2b9ed94bc4a89c1d554cd5d5a2557bec8a127c4','a44994aad22375af3e1c2742179fb71538aa8401e478ada17328580f9675612e');
INSERT INTO blocks VALUES(310085,'c5b6e9581831e3bc5848cd7630c499bca26d9ece5156d36579bdb72d54817e34',310085000,NULL,NULL,'bf04750fe13f663adb12afd3a166636a4511bf94684a77217de1bd7ef9077d94','00e86699ae5a8450e0ebec24deb4932b27686e436c2cae3eca6428a7229edda4','99b298ffc6ac4a1d80fb65e89584a98987abf2b108051e48a233300a0ef90b32');
INSERT INTO blocks VALUES(310086,'080c1dc55a4ecf4824cf9840602498cfc35b5f84099f50b71b45cb63834c7a78',310086000,NULL,NULL,'a0e8403085ba63ba72432f27ce8125921ef24742f988ab7f85dd8e4309f27a2c','8db72da41c05d03d36307441dc8751f1907da2a60e209cb7ff47e99d7b22e88e','2e57b42191dda49cebd61f4146e0a5d47dafc75da5441e6db9fa43ca024dcefd');
INSERT INTO blocks VALUES(310087,'4ec8cb1c38b22904e8087a034a6406b896eff4dd28e7620601c6bddf82e2738c',310087000,NULL,NULL,'0861b02e980ad5958bd23ac02603b132efd72ee2a70dbb0415fa5d39cc524681','9c9e3ae63fbf9180a1d17a19f47f77817eacc0aec0c031bb13046accdde03799','d5eda98454ed499fb8a7f49c09d28f60ae20c2868f519af70303206e191f44f1');
INSERT INTO blocks VALUES(310088,'e945c815c433cbddd0bf8e66c5c23b51072483492acda98f5c2c201020a8c5b3',310088000,NULL,NULL,'d52cdaa449f63f6d3abc79080378855206f91a5db865dfaf37a5a2529ea6eb9a','0ea167598525f3a88c6ab4c8f5138a41ddd7fc8e13338fa24706b9a30337f223','255847fef16d7e0a5cb78205cbcdaa9734ef64485b395f3a661230d0d23436fe');
INSERT INTO blocks VALUES(310089,'0382437f895ef3e7e38bf025fd4f606fd44d4bbd6aea71dbdc4ed11a7cd46f33',310089000,NULL,NULL,'d15a7a60b8bf8618667863b3e31eaf6202664e5aebc16d1f7a337b857ac31f90','8257d7e04e5813b7e184ec5b9bdbaad39c779cadbaa31907a8b52ad8371b5d09','5bdf07ac766cc4bdbca99d449e6758d77a9e4c3b680ea0460967298c49091836');
INSERT INTO blocks VALUES(310090,'b756db71dc037b5a4582de354a3347371267d31ebda453e152f0a13bb2fae969',310090000,NULL,NULL,'68475dcfe8252c18501fd1fef2afa2a91d20b92cacbabb542c12f43403e66ea3','dacabdd06a6ad7c50a6789bde4cbfbf5cf3d85a1e3b5d3621e0e93cf743ccdf7','265c44182c4b94a6a94f00defb701b72151830dcdc39c105039f1b86735559cf');
INSERT INTO blocks VALUES(310091,'734a9aa485f36399d5efb74f3b9c47f8b5f6fd68c9967f134b14cfe7e2d7583c',310091000,NULL,NULL,'5d584f255e5bbebc32c78a30fa816e1203fe7d3454611bef9222cdfc91dfcb63','1b382e2152f884268b32811171913ac28e7a1d40b6eeb6423b6a807ff417052b','be4ed062b28aa5e249dac7823e60344b07fbe187121386d061dc244a8406343c');
INSERT INTO blocks VALUES(310092,'56386beb65f9228740d4ad43a1c575645f6daf59e0dd9f22551c59215b5e8c3d',310092000,NULL,NULL,'ef992ad033b047b7f6ab038604736f444da55be187834f8152b173cf535c68eb','d3a42c8de911e63c540c541aca141f057a06852f519e89491e25cda63480c442','3b63f70bc2d208d99717e630c93b508806b85d84c0b389c29226503e443d40ce');
INSERT INTO blocks VALUES(310093,'a74a2425f2f4be24bb5f715173e6756649e1cbf1b064aeb1ef60e0b94b418ddc',310093000,NULL,NULL,'9cdee996d0e67ac3f9f283151b428ac5f223b72590965f41f93adcece6b88f2a','5e36c495f7310dc1815a73ab767f53eb04fe517eecc36d8ac9eedc2c1dcf117e','b9be6b071b8a2626675a0b18e8d0b1024af4bf3ec19706c1176c17f87e3e9445');
INSERT INTO blocks VALUES(310094,'2a8f976f20c4e89ff01071915ac96ee35192d54df3a246bf61fd4a0cccfb5b23',310094000,NULL,NULL,'fa25dc3f15fb28718d788f85373555966251f54bc6ed1f4dd2244b438d27b281','296aeb138c815e74a0f41e87ff2f463ac32dc01dd3d24da6fbcdf47542319e6b','adefbc319f56c50c4afcb1fbe42d5dd3bef88531c07aa522509c090504498c79');
INSERT INTO blocks VALUES(310095,'bed0fa40c9981223fb40b3be8124ca619edc9dd34d0c907369477ea92e5d2cd2',310095000,NULL,NULL,'1ba8cd971f9a169d43b6de1a136cb8e6153649fde1f7a8e7fb2f7de926fdf8b2','17b1f9d5c3426a4edb4734657cba1713f9a56991bd1b78669142ace96327d357','373887ae39db4493a059faf7901de9504168045b7f83c9911a5446bcd0e35b3c');
INSERT INTO blocks VALUES(310096,'306aeec3db435fabffdf88c2f26ee83caa4c2426375a33daa2be041dbd27ea2f',310096000,NULL,NULL,'42c36df2c53d762b9b132e622f52b2fca99bc0370978463acd22cdf6469587a8','6d05d09010684842a6048d4a70e1b08e22515caf58bb41cdf4be8b0643e6a788','3a3601a55329b1175dc55d3c85574553dd2a3349602bccc97d8b36b0ac1e661e');
INSERT INTO blocks VALUES(310097,'13e8e16e67c7cdcc80d477491e554b43744f90e8e1a9728439a11fab42cefadf',310097000,NULL,NULL,'d96af5cf3f431535689653555c29f268c931f9fb271447aed050303d364f92a8','e713310f3b49ad5f4a7a33edeede88ebff816f891ad3b75a971d402c470adf92','1734705bf30b95def63d9eb7ba430ce2f3a09b64414db512cd88dd06c1c078fa');
INSERT INTO blocks VALUES(310098,'ca5bca4b5ec4fa6183e05176abe921cff884c4e20910fab55b603cef48dc3bca',310098000,NULL,NULL,'153c9ce12e8d9f9d10c4005fc9af158613480d38b2c6551fc49bc57380c229de','1300dfb9b2c5511a312714c5679e956df96f6556b217245a5af1696300b1183c','22e30bdadf26a27de152119217e8e34efb9551f8db1fb77b02d62cb0c741c351');
INSERT INTO blocks VALUES(310099,'3c4c2279cd7de0add5ec469648a845875495a7d54ebfb5b012dcc5a197b7992a',310099000,NULL,NULL,'49f33b269d717b56a399843cf4627449010133b47079134b9e299ac5386468ee','f8c5bf3169d6c75d82c17e0567207db18fa4326b173fa441f574cdd4910e41ab','c5ea44442beb863638bc18a58c4010a6d58a944ba347d989b24277a11bb79617');
INSERT INTO blocks VALUES(310100,'96925c05b3c7c80c716f5bef68d161c71d044252c766ca0e3f17f255764242cb',310100000,NULL,NULL,'c9e72f7db2950f0b0e6e8fa3bc47d37a0d643da6ec61b236f7224b63ac60467e','42c7cdc636cbd0905f3bc4479d1a9ef6e0a5905732ce78e6f3cd63ddb2c5f971','7f3efc399d7278404aaa1293c002c06eb242145e5c2615a96d3014e666c7e7f6');
INSERT INTO blocks VALUES(310101,'369472409995ca1a2ebecbad6bf9dab38c378ab1e67e1bdf13d4ce1346731cd6',310101000,NULL,NULL,'a4387c8c785a8407f2dda176a7e182617904e7ce00c695ea8aa2f9d0429d9e74','a30a1c534bb5a7fafd3f28af05d1655e9d2fa4a966e420716ca16f05cef355e2','840c0c140e7dc809919a4b6bd3b993bf5cd3973ad1f8894b8f92d41199ae6879');
INSERT INTO blocks VALUES(310102,'11e25883fd0479b78ddb1953ef67e3c3d1ffc82bd1f9e918a75c2194f7137f99',310102000,NULL,NULL,'fc81f97474f7b35ef92ba93de82d38650a28afd140d3320e6f6b62337cfd1e94','7166828ceb34a1c252e97efb04195e3e7713ae81eda55adf1a2b4b694ab05aed','a8fff4b3df42c88663463a3c9ef10879dfe5ed2762fafb257326f5ea5402d2b9');
INSERT INTO blocks VALUES(310103,'559a208afea6dd27b8bfeb031f1bd8f57182dcab6cf55c4089a6c49fb4744f17',310103000,NULL,NULL,'3a502a89a3b66438cd2b944f8951a78999ba18c5f5bc8abeafe373ae4625ed4a','0fdfd69cbe22d8b0bc67852b20d85447a7ac6e2b14e29255eb371035245cf3b0','ecc2cce93b12ef7282bba058bfaf5e10fad24a9cb45054d422cafcb18a39eb61');
INSERT INTO blocks VALUES(310104,'55b82e631b61d22a8524981ff3b5e3ab4ad7b732b7d1a06191064334b8f2dfd2',310104000,NULL,NULL,'74ab5df2cdd13b654c80ef12e460120c96ce30d4690a06671474235fb93fee4a','e8ca37976b91bb8408f00847a9206db31e5af88aed6ba08b5adad49a3f187e4d','7b9438b7db954879a3c675591cfa32f7ab90b01d0d53ba204310a4543b61b1e3');
INSERT INTO blocks VALUES(310105,'1d72cdf6c4a02a5f973e6eaa53c28e9e13014b4f5bb13f91621a911b27fe936a',310105000,NULL,NULL,'dcc1940370421712cc668dc401169a55dd7077a49feddfd70e9e455aa5893962','7e58c01102a7ddfdb8cc1c47a0ec0ac79e77ccf686e8194824deb6fd77447160','bed4dea5e3110c34583650c2d1f4f67bd4107f451a734219bc4f652139c9175b');
INSERT INTO blocks VALUES(310106,'9d39cbe8c8a5357fc56e5c2f95bf132382ddad14cbc8abd54e549d58248140ff',310106000,NULL,NULL,'6ec3678f9b647dc1ea3dfd0d76ffd240da9a94097ad29e48e7b327d6198f4f78','80e5ca0057cdb1040350bcb420d35433a91bc598da0dbfc8fa819a1efae69438','77a7b6ec2671214d1163f2fe235c08d339a174943b99d68f45aee9b21cb19544');
INSERT INTO blocks VALUES(310107,'51cc04005e49fa49e661946a0e147240b0e5aac174252c96481ab7ddd5487435',310107000,NULL,NULL,'8e3c2d75c7a81175405f39386e2367c7a655afb53d7cf5b5c2e7dd2c79a40d9e','16ce0464b5fb26942a40db47dcb2add4b9a112d155c474b57816cf2bbffe2346','d6bdbf92b29c84932d4efc2121d47970ed13eb68f52b93e2c00c0eaa703daa35');
INSERT INTO blocks VALUES(310108,'8f2d3861aa42f8e75dc14a23d6046bd89feef0d81996b6e1adc2a2828fbc8b34',310108000,NULL,NULL,'b00c403723eba6ffb5db3d9903fbaa8a04a783c61949b9220e2caece1a8b86eb','b21bb20c2c8487c16af58f50fd4a9c6486dc0737b4d30c8dce01aa4b4f6cc95f','22365ee686d134052d4ac17746b88bddd97c816c3c473dc1f1fbb7a33fe38092');
INSERT INTO blocks VALUES(310109,'d23aaaae55e6a912eaaa8d20fe2a9ad4819fe9dc1ed58977265af58fad89d8f9',310109000,NULL,NULL,'69d2150543fe997a6685eac965283a3e7c9d3f9aa4eb2e08e8e4fe7a15054d26','f3fa226756ff6da1b729c7643364c3d813dea1ac80d9d727a14e5a96f4e18a46','7353c74a0277eaac360cfc9638820566fbff4e220fc8ec7b128e3af7c2b85540');
INSERT INTO blocks VALUES(310110,'cecc8e4791bd3081995bd9fd67acb6b97415facfd2b68f926a70b22d9a258382',310110000,NULL,NULL,'0122bef9da908b66c64aae0057d2052e1333c7e71075aed739de6838f03802a8','9dfd85e6c3e910a365b5e3b23cf776a28cbd4c5efcfcb5432e224acb9badb90f','6abee86b883567ee1744692e6687bd01f5601867ac4c18f7a63fc1dd8d131f37');
INSERT INTO blocks VALUES(310111,'fde71b9756d5ba0b6d8b230ee885af01f9c4461a55dbde8678279166a21b20ae',310111000,NULL,NULL,'d3ff81444800b8c914171c58ef93c9e9ce87dbeab3b7bad16729685eb0e2e55e','2dc80f5853488987bc2994450f53288564608ee58566c11facba13d807c05e1d','0fe299a3e0b4d5ee8fa6ec54c91bfd9478a5e242eb9a37232463d702e2366cde');
INSERT INTO blocks VALUES(310112,'5b06f69bfdde1083785cf68ebc2211b464839033c30a099d3227b490bf3ab251',310112000,NULL,NULL,'e316c6a4f4d1dcd800bb94f80dfcb66e9d8fc52927673c91865460b8a85aa84a','a74acab9c3da2dc14c3315e707c79894f3d8542e69f235c0267d2c3dbc16c277','8e27b70e932ff86dc3a7ea6ae42727d685ce89e7a8a39f0e65a5bd6412d5073f');
INSERT INTO blocks VALUES(310113,'63914cf376d3076b697b9234810dfc084ed5a885d5cd188dd5462560da25d5e7',310113000,NULL,NULL,'44ffb0b4be579060aa2a0fb574935764189ded92d31cc4ea94e4042734a9377a','27f2a930aa05d103b33d3716e3d53433644bb6b720d870921aff4b31ca9c8d43','727a9d11e49dd4e70238e07ab6498248fa0e5ed07c21acea02c5f8683c44cee6');
INSERT INTO blocks VALUES(310114,'24fc2dded4f811eff58b32cda85d90fb5773e81b9267e9a03c359bc730d82283',310114000,NULL,NULL,'a256d5377258011a8a4d887ba734094b7dcf2dc5fe99333069abaf71a7233948','1bf4636be3b9c834f52990dc06a02e344b39d7d002a533981676a8e9ac66e1c5','b945adfa51304bce74b38f70e84fd7180bc119b355efb15982ae29c3391f864b');
INSERT INTO blocks VALUES(310115,'a632d67ff5f832fe9c3c675f855f08a4969c6d78c0211e71b2a24fe04be5656a',310115000,NULL,NULL,'40e8739b957a2316bde9e5727b7f57427691850996a794c6fb6095e8510e88a7','53d725c65a222aabbc0c8046a4259249656bc3ac69e6af5ba1267bb4d06be7c3','c42048c2e9a9a106012ebab00b01adc22c8e569314dffcffe7a2bd8888079acf');
INSERT INTO blocks VALUES(310116,'8495ba36b331473c4f3529681a118a4cc4fa4d51cd9b8dccb1f13e5ef841dd84',310116000,NULL,NULL,'cddef956a174dc306823ac6c25d66f6b0df70918c90fb94bf6b0b0033443dad9','f77e4acbe8864c3b7257fa6d0194492dc0ad343f68e47866d6f9c7c63576fbf0','a3611a6f6be5a556491d9d01bb16c200f69889a16a3594cb730d4717474c9115');
INSERT INTO blocks VALUES(310117,'978a3eac44917b82d009332797e2b6fe64c7ce313c0f15bfd9b7bb68e4f35a71',310117000,NULL,NULL,'235c743e4857b7bffc03628ee42350b5bf550ed10bbcd9ed7e405ec17f30b67d','926d206ccb1a3bfef735464b7f8bca2977e0ff3df496ffa077fb97b736d23de8','b183b5330bd72524ea535f169367415863847d1d9d5aef09f784be9b8fb0eeb4');
INSERT INTO blocks VALUES(310118,'02487d8bd4dadabd06a44fdeb67616e6830c3556ec10faad40a42416039f4723',310118000,NULL,NULL,'5559796f49bc96fb1ca98a673a137f3c98ccbef8f9110d05b770ecb1cf805e37','317ac4f7e04a12d29595ce07800e8c22fe4a29a8a274a89010f4e357bf543472','52b867d7f3bb1dc372c9309809c6e260327006edf07663960d3d7e9a8e3c2d30');
INSERT INTO blocks VALUES(310119,'6d6be3478c874c27f5d354c9375884089511b1aaaa3cc3421759d8e3aaeb5481',310119000,NULL,NULL,'576597cb241dfa9eada633311916072451225339aed38d1a481c82d5e2833fd5','57d7e1c0f3ce48776594f365fbb25f6e91ac37fe6d41c5b4b794255b7a8a4a17','51f03bedc5ae0918e971c9c0c2de3487f22926827f2475f242b5c8ffff683353');
INSERT INTO blocks VALUES(310120,'2bba7fd459ea76fe54d6d7faf437c31af8253438d5685e803c71484c53887deb',310120000,NULL,NULL,'abb63a7c4edb99c71e21d1f634fb7e95d104e420133b2d216af99c0a367be94b','6da98b491db0a604772b1d749cda5f3596fb898e7a6c2c77501286a58e2d4dcc','258097bf422de026e1579a909242bd56cb3448128728bca2d54a16fc4628a714');
INSERT INTO blocks VALUES(310121,'9b3ea991d6c2fe58906bdc75ba6a2095dcb7f00cfdd6108ac75c938f93c94ee7',310121000,NULL,NULL,'b72746feb9077aafae6737529b4c1f0552c20ae45edaa72c2df4bea3c018d532','b15e99b11919a0a202edab7ab645758d4fd3ad044e56dff94a2a77d44799806c','d906c5caccf15674f5b807c8775ca6885c5eadf80ec899e373d02e2b30c3fc69');
INSERT INTO blocks VALUES(310122,'d31b927c46e8f9ba2ccfb02f11a72179e08474bdd1b60dd3dcfd2e91a9ea2932',310122000,NULL,NULL,'add1e878e00a20f8f357bc783cde6116665655b241d473f854f0808ddd9b73c8','225843d2e5043d0a775676e493f00e1049d13de659442094b8157342e82e7596','fb930cd73ca873c9bcad7eb0d4b25227b97f18e7ab03f5924bc8f81d15c65882');
INSERT INTO blocks VALUES(310123,'be6d35019a923fcef1125a27387d27237755c136f4926c5eddbf150402ea2bbd',310123000,NULL,NULL,'d85015fd04e9cb0b6fffedeb2f925e2dcc80666528daaf98124ec3565e8d3cc0','b561760402b7a2dcd1247d118b13c2fddeeab6e7110f9833027c1336f92f54d9','80260c842fd89690f482405efe2fda639a0e0b82403995fd30cf8c5f21638193');
INSERT INTO blocks VALUES(310124,'0984b4a908f1a7dac9dcd94da1ee451e367cc6f3216ee8cdee15eae5d0700810',310124000,NULL,NULL,'156bd9f1502fb3eefb80646fc15df6a2855e0548c5d877dabb7d4660324609dd','3b07f788897fea8e2fcaea33bcf48dfb879c6851661b657dba779e079774ca2c','82284387d49f5bb8791d37b4024f6c4192ffb27aea96d8e38fb8ef9e20dc7411');
INSERT INTO blocks VALUES(310125,'cc28d39365904b2f91276d09fae040adb1bbbfd4d37d8c329fced276dc52c6a6',310125000,NULL,NULL,'d0b288be666bd1e4a7a6ace21c2b373330dd73348825f93cc46086cbbcd48a0f','46f314fdc3bc826a47b37decdb442e5e1048addbd666c401fa2e331dc65ccf28','2b1882d74dcb19ad3246903705146969a351060a815eea370c9e33f483d1e41d');
INSERT INTO blocks VALUES(310126,'c9d6c2bd3eeb87f3f1033a13de8255a56445341c920a6a0ee2fb030877106797',310126000,NULL,NULL,'c2c842ff8f74fdecd9604a947792420c1e8a16d9eae381a2bc9aaee9694f4067','537e0305b6d69f2bd9567e5807ff139468de81fd445d93473ff505870637d0f0','4da64decdd20a14c492ad0600496bafd19586e4e49f76f7b4a1ded3c66af2a53');
INSERT INTO blocks VALUES(310127,'c952f369e2b3317725b4b73ba1922b84af881bd59054be94406a5d9bbb106904',310127000,NULL,NULL,'d8cca33e7e524da7740a21d5958359a3e6a6f314251e5250f0bfa06bd16f358c','bd67f1b8a5f7a3ae4865bd8cee5b3989d729a8747452a790dff465a024f369d3','2c669f6384729cccd1894e3af43f6dd1cf1ce5c26fa0e9086df1f124f9b3efdc');
INSERT INTO blocks VALUES(310128,'990b0d3575caf5909286b9701ece586338067fbd35357fec7d6a54c6a6120079',310128000,NULL,NULL,'5458f1a4d540dc33c0338b94b2ce0bd7a6398a9d3369de8f3ec6f7a8a690f753','1e83e3adccce65f0aa5be9201a553e01a2fea8fe864fdf690e594b8c2637053c','5c78a98ef9f378528d9d19adcb67fa74e1e9fc69f39c124221521e42e85bf58e');
INSERT INTO blocks VALUES(310129,'fa8a7d674a9a3e4b40053cf3b819385a71831eec2f119a0f0640c6870ca1dddc',310129000,NULL,NULL,'5e6d75061f2ea056056681fd3f856407249975a5a4a327bbf8bc20a96743fffc','6863fd38f0d84c5d98226d401db09c7dbb97090c427a699649aa9c1132d2f05d','c1cabe3e793e6d857ba1460e807d90147ee188e93b24b91e8c848343b4ce064a');
INSERT INTO blocks VALUES(310130,'d3046e8e8ab77a67bf0629a3bab0bea4975631d52099d2ddc9c9fa0860522721',310130000,NULL,NULL,'200b50c17c51fdb4275ec49e7300227a63ced6e3ff9292be49eb7b402d3db1b5','1ffc1e1774a75f3607baaa0a90e00f9ab9f45b3f8b3a4de450dc6810c403b428','c4556a604721fa1f6da1f4955e7fb04e74a8e0eb6a2d5a40af86c37528df459a');
INSERT INTO blocks VALUES(310131,'d6b4357496bc2c42b58a7d1260a3615bfdb86e2ce68cd20914ef3dd3c0cdd34d',310131000,NULL,NULL,'de1c49ab1e413b11cff49cb50b22b8ac76a1ad93a024beebc8f9ad0d959525d5','fe2993610507156c40b67df5e7cf5f8096dc6447c1ebe6db545b9e4c00e774ae','60e5cd307a76a362a7d57c9bd8c409d889b3e9f9c015b988263f9ec1dc78337a');
INSERT INTO blocks VALUES(310132,'1b95a691bf4abf92f0dde901e1152cc5bd87a792d4b42613655e4046a57ab818',310132000,NULL,NULL,'306d6f01cc778512334b73d66435983c57183e7c4f87c26f1166a7a83a36a155','b088b2483d77c02c606e5911c247078f619cfe9cf2559fc3b89355ba06c90273','03cdb330a94adc40194eb38fb9a8759fcc4673307119291a4760e95d6b26af56');
INSERT INTO blocks VALUES(310133,'1029c14051faabf90641371a82f9e2352eaa3d6b1da66737fcf447568ca4ec51',310133000,NULL,NULL,'e156b907295c14968c5fbe5e8fcc9fdc0415f3413a36a7ed737ea9e9f153e958','7ae4d667ee484ea3e953ff9096ed380807965b46b5c6dfcdf8e6efeed804b05c','b0f327fbc382627297df00de8e4a3b5f61bbd7946ebc14d78578fc07cd100408');
INSERT INTO blocks VALUES(310134,'1748478069b32162affa59105257d81ef9d78aee27c626e7b24d11beb2831398',310134000,NULL,NULL,'2528daefb0d2432358a70b10e11397535232c4fd2e69eacc77219c423df1d3f8','6f3ce0777b2d604c2029c3f3a57b48c346bf4823123047db284b176b23f74268','fe6dc39e539e63295ce45925fef7f02d1677cec5fc2754e94d507173c24591a3');
INSERT INTO blocks VALUES(310135,'d128d3469b1a5f8fb43e64b40f8a394945d1eb2f19ccbac2603f7044a4097e4f',310135000,NULL,NULL,'81b3a7fe120fd6f795536d275ac4b1621fea8a4d968b14a51a71ecee6944a819','08dad94c0b2eb415068dd083e7e105969fefbdb62180fc607c421dcf5546c9e2','c190d8d7f69e70367786124732d0b129764ad84acff7545e8a2e59f9272bed78');
INSERT INTO blocks VALUES(310136,'6ec490aaffe2c222a9d6876a18d1c3d385c742ff4c12d1334613a54042a543a5',310136000,NULL,NULL,'405c424434f5e9036d00704008be3793514d29a5bc619c6f5cdfd3c86326fd77','c6bd5995c8a5772bcd4b0c68b69563bc3783f0303b240fde2338e47797d3fef1','eaf2329e446f9578f8859c2043fec4e0ab6ada0cc44579dadd0de9cdf9cdd7e6');
INSERT INTO blocks VALUES(310137,'7b44f07e233498303a57e5350f366b767809f1a3426d57b1b754dc16aba76900',310137000,NULL,NULL,'7ee1d757a81c357ea0d18e59433d275a28f04f384baa35cbb874d75ec0182dad','1ef968fbffdd7f47594b2079329f0c776dc50f140cb6e3e3d63e6cc09188d44e','cf851421f1921a703b5098072177d9e82790c41167ecd96027761e639ef3ff4b');
INSERT INTO blocks VALUES(310138,'d2d658ccbf9baa89c32659e8b6c25b640af4b9b2f28f9d40baae840206402ab5',310138000,NULL,NULL,'1306ff4026b302043a5f418cc64aa65a1e5da7ced92aef50ba9c5699509f9eec','94b70c8238f279ee5b7e49fff26b1aec13f021bf08086767117f047aea42d099','98d864f3c6be515643f981b419a93858c1f933c6655e57c86bc1e82781c387ff');
INSERT INTO blocks VALUES(310139,'b2c6fb61f2ae0b9d75d18fce4c52a53b1d24772b1ad66c51ca51090210527d46',310139000,NULL,NULL,'ea081adf4304d85433da18652bdb032ac5916bc6a1b96410cf0ec51f87a5c519','58519708c6794fa60e4beec2826c240c0b2ac800f02c8dcf120ff6dc5c4f51f8','67ce3f9345281d2bf2db28641d00ba2d061cd4bfde5ef7a6847dc9f5d5f50e95');
INSERT INTO blocks VALUES(310140,'edddddea90e07a466298219fd7f5a88975f1213289f7c434ed47152af6b68ebb',310140000,NULL,NULL,'96f0be399144ab67ac49b54f80ef596a5c508e0f052d35b07259aff88a559a0d','b9f97ae9ecdd2911b393174d5d8c2225acfc4e842e56116f9b51a00b62df78ab','b7449911d8cd888ed5eeb12e6f58437c012acf49a78d215c60c5776fd27529d9');
INSERT INTO blocks VALUES(310141,'b5b71d2a271bd638561c56f4ffbe94d6086debaaa86bfeb02ef0d71339310709',310141000,NULL,NULL,'fed95d3c66979f94f4cf0ee075476b5a3e37d17285e1e84e2dcea837212ec8ce','4e271540413d4ab11dd48a61813e366d47f93b3880ed6cce51279263654ae4a0','91272055ffe27fd9151fa762e8ea6ebe3be017cdde0350e3bb8cae015faf369c');
INSERT INTO blocks VALUES(310142,'a98ae174c41ab8fc575d9c8d53d8e02d8e446b8c6c0d98a20ff234eba082b143',310142000,NULL,NULL,'d062c8df1d3bbbed10c67250e4273f47d9edadbeae329e91a0d9214d62e2dafc','39928659208d3f9a054b639d8c7650c2da343dc934a08ae0a69ea2b51e317def','6250da01c0b1df9a09a836bcc1aff0fce9ec6a10b2aefbb0ff189f10723b9192');
INSERT INTO blocks VALUES(310143,'8ba2f7feb302a5f9ec3e8c7fc718b02379df4698f6387d00858005b8f01e062f',310143000,NULL,NULL,'8b58427567f04bea48d8ef1643b1936731dfa1d44ab5ae8a0a725f5808e5cb25','a9c72c71dcb9dcf30487a7ec1aaee463eb4e8b281e39f8016ec2024723afdeba','601cdb4184593598be489de5522f01a7a79361347e75ec3b5670db970f409046');
INSERT INTO blocks VALUES(310144,'879ffa05ae6b24b236591c1f1537909179ed1245a27c5fdadd2218ab2193cdb9',310144000,NULL,NULL,'17fea61e6f803d990bfd78ae94f5482755577ffac62c56ae964a9ba4eba2a4e7','168d186ca641f40695d052e9007ad2660561d464e1a4f6111ebd1e72ad952cae','917e834ff7f576d4fe46d94d570ff4ce123e493fc2b356281349e1151cd67da2');
INSERT INTO blocks VALUES(310145,'175449ef0aa4580593ad4a7d0c5a9b117e1549ea772af00caa4ccdc9b1bf7a6e',310145000,NULL,NULL,'fc7745aaf59225dfd4055496462ef19352e31e7a681d5ddeee5d8d305914cd63','da6920538ffaa2eca301066428870733cb4efcd4b6655b19f48dc1be277c3b56','abea574b73c10cd3cf29bc606353212cb74d948cbbf86f4e74b67bff99f452d4');
INSERT INTO blocks VALUES(310146,'e954ab6a110455d745503f7cc8df9d92c1a800fafdd151e7b1912830a9cb7184',310146000,NULL,NULL,'b21400cea27ddadec8c336f757c1f250be59c2608323f5492cc40f0c2c54c086','97084a36563931b1b57efdb0da19bfe5cf1ab6aba93c18e64da11a38fcd74e29','ca5c2eb12e3c1f5f915bd7fdaee4cc03ee95263e7f556cf22b68d5ad2235c3a6');
INSERT INTO blocks VALUES(310147,'7650c95eba7bf1cad81575ed12f32a8cc36281a6f41bef13afe1dfc1b03a7e83',310147000,NULL,NULL,'47ed87885040679eaed04907a9adcbeb5fd23c3220d106cf991c692e56a47c85','aa62ee7cb639ab45c2366e8cb26fa098885237d7bcaa5e0df113fdd549668261','429938497b21d48b22b1a9e2f808febbc82545ede97a51ee8bd04af428d7f776');
INSERT INTO blocks VALUES(310148,'77c29785877724be924f965215eb50ffe916e3b6b3a2beaea3e3ae4796545a7e',310148000,NULL,NULL,'f2b6fbf8a0d2d8ca5b7f837059d3d5d4e377606d715255ece9d66cedb1ebcb5b','526d5c3dc78d64566c79802de9f344098868a908a1914880218f95c08c49af5a','3f3bed056fb645619ea9bd98a42ea042131feb7d38df6e426541761d8fcff2dc');
INSERT INTO blocks VALUES(310149,'526b3c4a74c2663fc04ed5234c86974bffddb7235c8736d76860778c30207b3c',310149000,NULL,NULL,'7cf62dc8d0f09332900b3d3faeb973c75f60e7118ba2f5ec25f9a1d02e5373de','42bb4e4fdb78319fa0cb1f0a8b5dee8b93964ecb34555d95d35353ec36dcf0be','174c51c506a538e6392b5c0aa822d89372b55cc7702e7ca648a9053a4cd7c79d');
INSERT INTO blocks VALUES(310150,'cdd141f7463967dbeb78bf69dc1cd8e12489f58c4ea0a5dc9c5c01ec4fcea333',310150000,NULL,NULL,'773cd82211234feb848d9246f3e7da054bd0083d24aed81143cffc9c0dc00074','382dc558386cbabbe654b7ee234502430fe85744bfa8e2d7dfe6f75852164f66','b846258d1116eade85164811c56ee60ac946c20fda24b41dd4a2269ceaafdd9d');
INSERT INTO blocks VALUES(310151,'a0f31cc6e12ec86e65e999e806ab3bfa18f4f1084e4aeb4fbd699b4fe284b330',310151000,NULL,NULL,'532dcd1eae2240e6117d592dbfde30600f391007daa8e233ff99cb26ebae995b','ff9e87c0caeac0624bcb42ebdbb5cedfb11002f494bfbfe2ffa2423142a13380','250185109684e52651c6366c06cab4d79bc7355dbee7dde78af9d7206b8b9b8f');
INSERT INTO blocks VALUES(310152,'89c8cc3a0938c63a35e89d039aa84318a0fc4e13afac6beb849ac37140132c67',310152000,NULL,NULL,'2c5346c3aab989386ee49d27c30939760b6ff2eddad88147a715f0b4346f5c81','8ade3672179a522010405415e5293c3c9a65a5835a4fcf1452615ff07fa1639f','8a0aaf151790957386ef775fc831fb40f8f57906ca2d9ab67d927300a87ad266');
INSERT INTO blocks VALUES(310153,'d1121dfa68f4a1de4f97c123d2d2a41a102971a44b34927a78cd539ad8dca482',310153000,NULL,NULL,'2662192765845a97bc1bb97f4b8b0a1d8c73d6c4a57ba6a36062bd75094131cc','d2d22e5b67a06c03da8b97d63a3ac509ad12947c7ab16bd88ba7285277ad6f98','06dd42e582d38ebdffb079d4f8aa606d5f8f88f69ae53a696c35cfaf511f8c1c');
INSERT INTO blocks VALUES(310154,'ba982ea2e99d3bc5f574897c85485f89430ae38cf4ab49b7716ed466afa506d6',310154000,NULL,NULL,'662789c8199a23fd244f020fca7cf70af20e9792dd66801ac0cfe5a871279fc3','7581124c0e23d40bc65ba7e0dea9c1e09420fbc90caf64f28dd4884f118804ad','6d298ea50faaea60c47c48d9bddcc7a20eabf15463f34dc89a1eaced65892811');
INSERT INTO blocks VALUES(310155,'cefb3b87c7b75a0eb8f062a0cde8e1073774ae035d176e9769fc87071c12d137',310155000,NULL,NULL,'6db116d18753ecb4c147346942c7cd41f3ddcd0b8b5300c8560c6cf2a1ff2b0e','3f81f6ab33970fbe73487805b4b91cbeadb698e6867903b0aaaa3a34e784d5b4','95dc929e236e183b84c7cedfe92896dbafdd7299d7437bf9702b6343bd79f5df');
INSERT INTO blocks VALUES(310156,'6e3811e65cb02434f9fde0445a7a2b03fe796041458737d0afcc52208f988a83',310156000,NULL,NULL,'18738df90f8ad63adfea0d45249c8c11e3429badec69f9d80e4d542ad78af26d','1bcbdd12054f34977a15af3bea0621b08545d593c7581af56cbf7724c0d390db','82de89e2fe84e2d40d190456e6b0dad71d53ab4daeda583afc8dce2796349328');
INSERT INTO blocks VALUES(310157,'51dd192502fe797c55287b04c403cc63c087020a01c974a565dd4038db82f94a',310157000,NULL,NULL,'41d6b09f49e434e7cee1c174880a19624f796685d18cca88049572cc924240e6','3cb35e82ade3ed9598340583d4388d14ac6eb8f3d7a20565688a3e67581d63eb','f9617902c8114cb2063db833faf641ec14377e41c8bf65742612f9c19ddb116b');
INSERT INTO blocks VALUES(310158,'749395af0c3221b8652d31b4c4410c19b10404d941c7e78d765b865f853559d2',310158000,NULL,NULL,'4c436a14a5f2fb45f9525122d91559961c5ae92b182d1458f421d72b8689c555','a14b9e98fcbf6dbc7f6765be62a35255ef01708b61fbd7cb091d9caf9ccc189f','837e7a230832d4cd58d233152ac94b938626a0310e29e3917a5e994d5271e0a4');
INSERT INTO blocks VALUES(310159,'fc0e9f7b6ae99080bc41625588cef73b59c8a9f7a21d7f9f1bf96192ba631c12',310159000,NULL,NULL,'9f3c424fdc6eaf4fc11fd4bf6d389af9aaf82dddeb378f050446ed0f191c415e','c5584dff4a2eac015e971adc7577c86e42b8477a587372dd47b7fa424878c2fe','730ba4fdad6e0d5396721144b0a8bca6b1289858b563cc026007e22517ddd435');
INSERT INTO blocks VALUES(310160,'163a82beeba44b4cb83a31764047880455a94a03e859dc050da782ed89c5fa8b',310160000,NULL,NULL,'7a2c16fb611558b70b31f8f12c6d0ee08f0c04d6901f5e674984407400dc4f7c','386b4d139820f689ea6c74ff84367f1ca3d4e4ed79fdecd387e2743fa98a07d3','9933cc6ede28e31c6b06795f858cbef51e7ef9a9b404fa98b95c270a8478ad79');
INSERT INTO blocks VALUES(310161,'609c983d412a23c693e666abdea3f672e256674bf9ee55df89b5d9777c9264d8',310161000,NULL,NULL,'b8566b51d69aaedc491add41ea3a4260406b04b8d417163c9122b6d46b23e043','e5cdce282821cca89d96cfcb8325876f3939ea732a6930fdf2d6b4a90fef2d77','0f7100c9c54386ff4aea49dbc6f4f7712d780285b165bdc8551c1f200596ae8b');
INSERT INTO blocks VALUES(310162,'043e9645e019f0b6a019d54c5fef5eebee8ce2da1273a21283c517da126fc804',310162000,NULL,NULL,'8bc4f34f2ff6ee796a9ee54cc8e3374136a2226343ad506680ba94a04a74efdd','2c25f452eb14456b1da2e8ed0dca4747d665758f898d685d4fef7cbb672b93de','4b4b2629d953c0f389c790536a0342d384c4739616b1323264d15bde5c547880');
INSERT INTO blocks VALUES(310163,'959e0a858a81922d2edf84d1fbb49d7c7e897a8f49f70bd5b066744b77836353',310163000,NULL,NULL,'d5b71a21ec5123be72bf29d699facd204140d1863ac22ef9973920a7f4fc0773','c26f473cd315846cd4edac85798fae0c8d1ee9cd060545018fcd848d1951dc85','79a49373bebb3292d04c8ce2a0654bd5604cdd02cda09c75127a38610db61d7e');
INSERT INTO blocks VALUES(310164,'781b7188be61c98d864d75954cf412b2a181364cc1046de45266ccc8cdb730e2',310164000,NULL,NULL,'2f8c3ed867557c8cad28de08cf82fa2484ceb8f7d7cc26fd5c68e15019ac5f87','ef077301605bebdea3c268dbdd92ddfdb5861a2045ce767e598174907479f865','e69e4afc48a8f3e82d48e7be2646340d7ed3f4c23c777a520b5d1114d282d15c');
INSERT INTO blocks VALUES(310165,'a75081e4143fa95d4aa29618fea17fc3fabd85e84059cc45c96a73473fc32599',310165000,NULL,NULL,'eedb0e236cd48b9afe186b5c34002e4a17679ab7b10ed8c0854d2683ea7b4df0','64d09bfe6e0d4bf5ebec8e19ecdd7459c2d348b6d1eefd1cdf47ed6e91a0c8df','7b25a746ece6e8579658d140dc7a79dc49c855b51be9bfc957549628e2bfaa3e');
INSERT INTO blocks VALUES(310166,'a440d426adaa83fa9bb7e3d4a04b4fa06e896fc2813f5966941f1ad1f28cfb41',310166000,NULL,NULL,'392df958448612ffdfec7f6aea1d3fa37c6f15147be61667bca1f16ba101050f','05e25be5b2017f9333778ed14260b9eec427e966fa27c1e574a668be7bce29f2','08d2435720393cd8b37c84ef4ee96381cc69e88e6c2554aa4612122bbb736bf8');
INSERT INTO blocks VALUES(310167,'ab4293dbea81fedacca1a0d5230fe85a230afc9490d895aa6963acc216125f66',310167000,NULL,NULL,'2d0a69eb324f085f3b36317d169902be8d4c40707c8afe2ee5dc56c104020990','ecfa99daa3db074d70ba734b1beeee88335f4e6def4038a80e89f46305a7df9b','5dd7c7597b657b65326b616713b5d902859eed5b328d444d2d35dd9bb99a1767');
INSERT INTO blocks VALUES(310168,'a12b36a88c2b0ed41f1419a29cc118fae4ecd2f70003de77848bf4a9b2b72dc9',310168000,NULL,NULL,'9339de42b016d558c571ed1b4a907a337995380951d1652c36cf9685d6d063d7','9c67fb53da8388e2ab5bb61d15a4423e47713c3fd133e9a92b5b6af43f8a34c4','f8f52a5289bf3c625b7b34fcd54b64f71122d28eb775d91bbbb07ced0a50811e');
INSERT INTO blocks VALUES(310169,'204809a85ead8ba63f981fc1db8ae95afe92015f003eaebbec166021867421f3',310169000,NULL,NULL,'b0cc29ba6075a4519388aa13b2ed8ac13e779414c50a2b0a048794065eccdc80','fe288bd58115fbccd75cf60bc8b1ed9b76e635506c71ec70947d43ad5d021c68','a9cdc0c012ebe0b6d6e71776df91c6721f44804677134eec7e6e1df367a86807');
INSERT INTO blocks VALUES(310170,'b38b0345a20a367dfe854e455e5752f63ac2d9be8de33eab264a29e87f94d119',310170000,NULL,NULL,'d342b3a0badabc8a47a15d695f7c877b54287645fd8df0d560177a57c7f0db3d','1de1a592c69e645c21ddca96df82999051295cd97b59c387e72f51eeacb3699a','749dab3873b6b450c6ac9a630d80689b15f6302d643f4b170ad251ad118e835c');
INSERT INTO blocks VALUES(310171,'b8ba5ae8d97900ce37dd451e8c6d8b3a0e2664bb1c103bf697355bf3b1de2d2d',310171000,NULL,NULL,'c994a2733d12b3e28523f9ff8edc162f54f9218565c8ea5d4d100441f0477d02','3027e4fd28b22a438661d01aa047f7de4c82d53e8d723e95b9ba078d862aa3eb','c690d75bfb04a6d6c11f5eb0e2fb656bd9eaee3dba27be226cf04b170730044e');
INSERT INTO blocks VALUES(310172,'b17fda199c609ab4cc2d85194dd53fa51ba960212f3964a9d2fe2cfe0bb57055',310172000,NULL,NULL,'397248fb2a54f0570de5b24e9375263f3b54359727077a30227931c1052dd9b4','29432f7262550b6f87571b4bcf6915a8ad48ea31f62b198e707639d664830d5f','d6463b2f411027f8b36732372f0d9f70a797aed9ff65a65ef04b6c0d437d43a4');
INSERT INTO blocks VALUES(310173,'f2dcdc5ffc0aca2e71e6e0466391b388870229398a1f3c57dec646b806a65016',310173000,NULL,NULL,'66d5758c943c8332f1491005e13ee5a906a80e2af7ab8d37b236d309756def31','4731d616ed140ed8a0b7ab4c7b356c512969133dd314ed50e91dae778f14279b','33529b7f4eb807ff61df98ebe036c5175f2d0bc073973517664ed031d810b701');
INSERT INTO blocks VALUES(310174,'fa6f46af9e3664353a473f6fffce56fa295e07985018bface8141b4bf7924679',310174000,NULL,NULL,'f45eb0d49b4498017519bafb08cb7e31b5e633391b1c748866a443df5004f53d','184b137c1b43d02fe734d351219f2bac7f667add4c997e6a1afc491c8f98d6ae','b278f50dd45340d775697f9bf2cd3c69650c9e829b5283f8019cf05e37e332a8');
INSERT INTO blocks VALUES(310175,'f71e79fe5f03c3bc7f1360febc5d8f79fc2768ce0ff1872cf27a829b49017333',310175000,NULL,NULL,'5f9cd3d5d4d3d9dce35bd3e76f8530c7dc2992a97785149011a39f76dc9f3b88','8709205f623ff115e9a5e870132094a7b4c3ae596e5000e13d3c383b9080780a','109ed2dae8fcd896e30fab7cc84d5e85dc9726753a6f152c1b6d52117af2af2b');
INSERT INTO blocks VALUES(310176,'67cd1d81f2998f615602346065e37f9ceb8916abb74b5762ead317d5e26453c6',310176000,NULL,NULL,'34471b4af7737e7024fc3762d0e37a98bf12b619fdb0a4ce110bd2950e3d3bc9','f4ec8d67e9e87437de677cdae64f6554d2f1a1d132113e50fd3464cf1c059374','c8e1c8631266d0d5946f1d563e897fc813627be4e031a754d27409c78a9c5ee1');
INSERT INTO blocks VALUES(310177,'6856b1971121b91c907aaf7aed286648a6074f0bd1f66bd55da2b03116192a52',310177000,NULL,NULL,'e1352b09b865ad48fe35f2a71ac1d1c188bf0f4ad7aa4ae37fd06027e556b2ba','8ca8ef5337dac04787b4ba75c41cf9052526c03dadcff585ebac71c6f2a27ded','00fc60b8686bf769ab93acce7bc2a132b2e31cdeb578dc48c0606f1dd11130c3');
INSERT INTO blocks VALUES(310178,'8094fdc6e549c4fab18c62e4a9be5583990c4167721a7e72f46eaf1e4e04d816',310178000,NULL,NULL,'3b6ad6e8a04f803e70f6e366d16d30b2179d1624a93db041c33cf4c4d28dfcf6','3add916b5d4a8bb41a1a1b5e3358d3c29efc4695c02aa759c5442eed9b7612c4','7bcaf694098d1f4bc6ac79d3c808ba9cfbcd67c2f3926aed1f5803c06a75af1e');
INSERT INTO blocks VALUES(310179,'d1528027cd25a1530cdc32c4eaff3751a851c947ddc748d99a7d3026a5e581a7',310179000,NULL,NULL,'7f574d5c3d785d4070e92701956755101bd86949141b57fc4e585bd6bd2ad56d','90c3092cef7667494106d39b4a8df424891901dd55699bb70bda4571abb468d8','8573967eb72d79329d3edcbb747409389bcd03cd4fdcd6773e7a8152f71b6963');
INSERT INTO blocks VALUES(310180,'f2f401a5e3141a8387aaf9799e8fef92eb0fc68370dae1e27622893406d685c1',310180000,NULL,NULL,'9705d812c0cb4ca03e52ccb28a01522caef3cf41df45e7b52c32267a93517dae','eb5036ac63863e080ba8056ff495721062edd90336577e4f70e897fe50f7e8e8','10c916a3b380e168fd30c8eb1ec14889805c2e23d906fefc95a483a713c9fce8');
INSERT INTO blocks VALUES(310181,'bd59318cdba0e511487d1e4e093b146b0f362c875d35ab5251592b3d9fed7145',310181000,NULL,NULL,'808802d90ae3381feee9c5ed979e03970330135a60d9a270c719cecaf805764e','ee8d3a79c740b8b53feb63e5e7e47d88f0073723032cdc73e4c7fcecde93f8fa','be76267bcbd4824780336b473f900f4cbf71724e41d4a79fa1018f33be89beb8');
INSERT INTO blocks VALUES(310182,'a7e66b4671a11af2743889a10b19d4af09ec873e2b8eb36949d710d22e1d768f',310182000,NULL,NULL,'3e8246c907b75b7dbbf1a07b044e7c146c6d802c52792ba26b0085e399653932','b5d68713ac81ab3a8b13fff854215e9c54cc0488b44fecc075ab101a51c0728e','d434b684cb2cc47ed99aeb3f270da6f4014813c292c9015f8aa77271c6c75f5e');
INSERT INTO blocks VALUES(310183,'85318afb50dc77cf9edfef4d6192f7203415e93be43f19b15ca53e170b0477bb',310183000,NULL,NULL,'c830f4f39b35688655f8d3c3dd9314d1d8fe3a1aa2810ef4ec7cc51faac676b0','115ee5de685b3f5e40bc57a86fb77bd3d747adf5d5bf08201e8322f036f5f5e2','25efaac20125cd57b4559866a3be7cd484780a127be14143b50ce50a6c8ad67b');
INSERT INTO blocks VALUES(310184,'042a898e29c2ebf0fdbb4156d29d9ba1a5935e7ed707928cb21824c76dd53bfc',310184000,NULL,NULL,'499aa926aded967f6261ac213391b5498edb855c21ffadf25a0c5ff8378e9a91','23cff06675c1a86148212826d7d9112ef962ddcfce0b5a4aacdc60ab9c46cdd6','cae1f701e062fdf87b76d9ff0529d38597e7a20f6770dec0f2382dec438da269');
INSERT INTO blocks VALUES(310185,'bd78c092ae353c78798482830c007aac1be07e9bc8e52855f620a3d48f46811f',310185000,NULL,NULL,'22798fe864fc015e0bcaeb760823342dbc7a9756d153cc428929b8945c6e6fe5','7ab4b0e298a1e2d9d0fc3f838270d41e5a5919b9fce9c81f01b4588b55007f7e','d477fe1459a01898289066a9175a7d0a73c1d3ef1d300fb5f4f492c1d6a01f58');
INSERT INTO blocks VALUES(310186,'e30a3a92cc2e5ad0133e5cee1f789a1a28bea620974f9ab8fa663da53e5bf707',310186000,NULL,NULL,'6593028cdf86b5f3e65509b22955212d2b3a649741e439791c72b7e3c8734ad3','653ef8f078e27f392f939e69a45045be6a084ea4d8c2b630bc2b19a2448e19da','cbee2afebcfe0f0cf067379cf0788427a81667d7c5384048cdbfe111612d8b78');
INSERT INTO blocks VALUES(310187,'fc6402c86b66b6e953d23ed33d149faa0988fa90aa9f7434e2863e33da2f3414',310187000,NULL,NULL,'e49da111e3998fafb7929ce5f43fcb8de9b89aba6a06fab288ac8106e8c06c47','53e2e95f6a1703e527fbeacb8df0e474d6dba7505b1ba6e556958834442814c8','b5d8aaf389d849cd881f81370602e7453bb554c3b3bb8728e1a2a865712cb1e3');
INSERT INTO blocks VALUES(310188,'85694a80e534a53d921b5d2c6b789b747aa73bf5556b91eeed2df148e2ada917',310188000,NULL,NULL,'f36aab93a395bdb52168cca5be82b3d370073ac10a1eeda1e6769a2db96b8212','7f620b3c56d442bc6582d6ddbb230666b3cca6adeca56b9e70c860e026acd4e3','14050a9b5c65df2d39ba8c39c4d51e5ef2c5d2024ee8599fdec20700e6e9e60a');
INSERT INTO blocks VALUES(310189,'7c036dadf19348348edbe0abe84861f03370415ed2fec991b9374dbb0ca19a06',310189000,NULL,NULL,'caefec27a1031498981b5d4f0329dbc766eaad6f8c4230f4434dbc0440877109','b157173ecd10fe754097f14f7d8b4257361270780e0711d80f750e7d9afe7bd3','a81c57bda5c05fe30645361d0ba8ae8235132428933582ce332bef141a0b8e80');
INSERT INTO blocks VALUES(310190,'d6ef65299fb9dfc165284015ff2b23804ffef0b5c8baf6e5fa631211a2edbd8d',310190000,NULL,NULL,'df92ef8478fd68d4774b3e8cb83ed1a069fbc5e3d666a5e8fa462013f1b890b8','71db206e3ec9209a560a636404dd8004bbf7ef7bbafe9783acb47a468be03b61','0fc7724f260d8718ff7fcc3d77d3d93294885cd6000927cc7443ac8faacf85be');
INSERT INTO blocks VALUES(310191,'5987ffecb8d4a70887a7ce2b7acb9a326f176cca3ccf270f6040219590329139',310191000,NULL,NULL,'87cd3ba6903bb0a5afa07255e569534845b926e6e3a1eeae7043ef15f695a788','28388880d19667d688ff3995cc9041227e23e8502386470f72be553566706035','b9694b34b4f600f8b3e9d5d60e547a81b8cd20abfb504122eec2fb8ebea713a0');
INSERT INTO blocks VALUES(310192,'31b7be43784f8cc2ce7bc982d29a48ff93ef95ba18f82380881c901c50cd0caa',310192000,NULL,NULL,'93831212bdb388f4e2db36ca5d6ccda6fba1c401db7ed046f1cffe261569e3ee','f59be735c81a51c51cef5ab68883c4f99fcdbef3f85802583e54f02b757095ba','e8cfcf942c70eb3dfd21fe9e1f185d82410875fad987e539431694bf3943e7cc');
INSERT INTO blocks VALUES(310193,'ff3bb9c107f3a6e138440dee2d60c65e342dfbf216e1872c7cdb45f2a4d8852a',310193000,NULL,NULL,'299f6e3d677e12c0f6d02b242ef82dce4e3c75402ffbee4f891ba777e160091a','9a49258229ab59cad8f8f80c5547440760e27158ec917b8519abfc8fb8058d5c','fbb5202819a79d774b3f2f2438d9ef08498fd34b8bdcfe81cae76b766aef2a1c');
INSERT INTO blocks VALUES(310194,'d1d8f8c242a06005f59d3c4f85983f1fa5d5edcc65eb48e7b75ed7165558434a',310194000,NULL,NULL,'330c75c62d310d5214028311f19119b9aa3b413c1491067f8cf3567a1f37bae0','583579ba988351825802f9c22bbeb1b57bbd03f6c21a2fcfa6c5294c2d008de4','df1ab91b1060c74165ae431bc7c8b0eecb10c39ce2c5b7d0068823dbba08c6a7');
INSERT INTO blocks VALUES(310195,'0b2f1f57c9a7546faac835cbe43243473fa6533b6e4d8bf8d13b8e3c710faf53',310195000,NULL,NULL,'cb228e7c41f04f75bdb8a2a26e9848fd7f642176d4e3a6436bdeb61c102811be','6b0c2834a29a57569c090c655664010df3aa55cff8e5c8dae9a4c63d174b85a5','7dae01a7b56b449f89e88ac039fb8a1690d29d5877db5d140e878aeeedd7f2ac');
INSERT INTO blocks VALUES(310196,'280e7f4c9d1457e116b27f6fc2b806d3787002fe285826e468e07f4a0e3bd2e6',310196000,NULL,NULL,'d336a7f2e3bcbb067abca699119cb0b3a7d8e1cfb2081c6ac93d3ae1183474c0','eccaad6095cbb4acd17429c6fce8e7f0bf99b3c71ac4c0de54c96ea4f916fa3c','77599d8c2c956c220065336965c35a662acbac7f794560d40dfc9f5b180f1c07');
INSERT INTO blocks VALUES(310197,'68de4c7fd020395a407ef59ea267412bbd2f19b0a654f09c0dafbc7c9ada4467',310197000,NULL,NULL,'e1c14ab4ba11baa06f837c43575b058a38b7006c6ff272a0960f65d4232cd2ac','85b00d893e816a81f3efb248d9c579903dd63b35af195972da45c18f7fa3a0d4','6aa00d3aaad3caf1fb6720dae143033557519fbda71cec775bd20739e80a3402');
INSERT INTO blocks VALUES(310198,'30340d4b655879e82543773117d72017a546630ceac29f591d514f37dd5b1cc2',310198000,NULL,NULL,'03c1bbb6d2b19b199bc13c902541db2cfa8ae8c5198d8271d8699ae0a08bba0c','b80e95007cea0b295bae86af51ddea54983a9b0c2b53b30f029aafa65dc51a43','b03c24aa0602d7bbe21ccd657a36234b7feb91b1fd96350f04aae4b9191cca96');
INSERT INTO blocks VALUES(310199,'494ebe4ce57d53dc0f51e1281f7e335c7315a6a064e982c3852b7179052a4613',310199000,NULL,NULL,'7c998d1ebcd2fe1c91c9d8aa562bd934b67521b09abcb443b18e4bae4a3a5e93','b3b40fef6d4a91841fa4536c139baf0d95a584e403f5d38b549f8caac7653884','a86aebe4a1fb1d9db76f61c545beb53ade37ae48f4937a865c973959815fb139');
INSERT INTO blocks VALUES(310200,'d5169d7b23c44e02a5322e91039ccc7959b558608cf164328cd63dbaf9c81a03',310200000,NULL,NULL,'12aa1d3ede45cfb999d785d21a19b20a0be4d51cf8ca7d78ecce47ef31334ebe','1cd7a4c117e3375390b0777190d5b53acb4ef3395cb671cc2e9007e241e53b89','8efd110c6eee8dc4dfe6c42647af1f7c261ec8d9eec5c92438e79c9db5e7eac7');
INSERT INTO blocks VALUES(310201,'8842bf23ded504bb28765128c0097e1de47d135f01c5cf47680b3bcf5720ad95',310201000,NULL,NULL,'edb2ddade7ea48b2b5f57b57c8cdad714da2407c95e5776d080fd2af8e03214d','80228c5e9df0e89eda101bc978b034429eaa4a8b469caef51acba382687ccdfa','e8f7af460ee076d36ac0290bb23b62af68d9d9c89a69301a518b844ae934b0b7');
INSERT INTO blocks VALUES(310202,'95fa18eecbc0905377a70b3ccd48636528d5131ccfa0126ed4639bc60d0003d8',310202000,NULL,NULL,'2dfba901292506aad81b75494c6526cb388e21df3edfaa75062e42c3c96c9912','c259c7419bd8074812caedb282cabea7a93cae1a46dea8cc776b07f22fad3efd','258c2798dd5206f495a5b6f6bfaa80901c6498d006f8822c45fec19e9bd4cf4c');
INSERT INTO blocks VALUES(310203,'ab15c43e5ac0b9d4bd7da5a14b8030b55b83d5d1855d9174364adbebf42432f8',310203000,NULL,NULL,'f19076b8896c2e9f702909caaaea599d941e9399301691dd1c620c6b6c01e3c5','e968374a6773003317cbb716731b92734d0a1caec083361cee4139a42c76c927','912a38286dd0145ad9ba6d365aceba156aec11ee792ff26208026cbf784d0409');
INSERT INTO blocks VALUES(310204,'18996fb47d68e7f4ae140dc1eb80df3e5aba513a344a949fd7c3b4f7cd4d64cb',310204000,NULL,NULL,'c2b4b4672f3567833f7689ee4a4f950255e68a3e8368772ab864828419065176','a089e598a360f865e9e1b58b47b90a96db1ff258bcac760f6d7ada405970b8fc','0c7a425ed0b0c5a05c923e450a01f0523f0e366479e265f6a96533f0eca67515');
INSERT INTO blocks VALUES(310205,'5363526ff34a35e018d1a18544ad865352a9abf4c801c50aa55742e71630c13a',310205000,NULL,NULL,'43b5ca2b4bcbfebc564cf99067b351e4d324875416c1e21aea828756e543b7de','b45287fb40d342a13606bcdcda395b9bb5446e051a2af0e72a4083e8aacb00fa','fab24255bb98f05ea8ef710dff15cb6e0108df280acc1ebd1ae5bb222986a965');
INSERT INTO blocks VALUES(310206,'0615d9fca5bdf694dca2b255fb9e9256f316aa6b8a9fc700aa63e769189b0518',310206000,NULL,NULL,'d2e360af76dab6744571ae5f9ceb21d2aaad9b42d1c87ab5ee9549507233648f','4154adc1a5278698790a874b2435db29f7a0581f21888aa3ebe93b5d6a4d116b','485ee3d9ed6d0a8bc7d1fdfbe80c966950cfe097ef0ccc98974f2335f553c1a0');
INSERT INTO blocks VALUES(310207,'533b4ece95c58d080f958b3982cbd4d964e95f789d0beffe4dd3c67c50f62585',310207000,NULL,NULL,'754504d3ac03899761a0d042496768cef714711afab73c76115ee62458b9b44b','b8595219fd6ea94938348cba3f29e14323da5c46507f62e01091d491982cf756','f508276377ff80707a8ccef9ce0ed778ae3e9adddc3e3e6c5d8398681fd9a7d7');
INSERT INTO blocks VALUES(310208,'26c1535b00852aec245bac47ad0167b3fa76f6e661fc96534b1c5e7fdc752f44',310208000,NULL,NULL,'cf81663f37d9c353a124bb2a3e1cdf51c8eb0078aa511ada856c8b71b801cb9e','ea4ceb91914bd33f129470a03c2e0dd94b210d9e0ce5c2084fe40341918ff69f','6384e311e812537af4a858f6ddc97962f9a13515da8db1d74a4a89c2fad21aaf');
INSERT INTO blocks VALUES(310209,'23827b94762c64225d218fa3070a3ea1efce392e3a47a1663d894b8ff8a429bf',310209000,NULL,NULL,'c4200a6881e0ded18a9989140d29984c19d790527693a05be9c833318461cf42','13b393d0052c573a1c34a7a3be3c0871ed3236b97940fe6b48467d139f62c326','15a1270b20e176b9e41c2060a1074aaaf785a5888877265b2a0059d238f8f16c');
INSERT INTO blocks VALUES(310210,'70b24078df58ecc8f7370b73229d39e52bbadcf539814deccb98948ebd86ccc0',310210000,NULL,NULL,'4ba5e58a7fc651cbc58cd1390021b8d279a5153f114c4c518f1c3b363054046a','b9f24f922e622fabde4861e0f3aada5a67142af58588f9bbf74f5ddf14df5712','d43d427953b0d7764ac3fa2760fd70f9ee166b31f07dbff8a7b08d99409b072f');
INSERT INTO blocks VALUES(310211,'4acb44225e022e23c7fdea483db5b1f2e04069431a29c682604fe97d270c926d',310211000,NULL,NULL,'11b9e7cc6c428bbd840a8a3c2495b34a30067cbbc15589bf93eba016b477df36','7655ad4c309b5cebd161164b024eaf847c172ad1ad7c22830409e65d612e0abf','8df273c58b8b44de4f0f05deec836b2dbb8af7a7b31171b4453cdb493b4d0921');
INSERT INTO blocks VALUES(310212,'6ef5229ec6ea926e99bf4467b0ed49d444eedb652cc792d2b8968b1e9f3b0547',310212000,NULL,NULL,'6409a0f2555b872a92be674d1d4c09a9069350f649fa73e7db367d49fffe7347','97f5419ea7cf3d38ba1553548f480e054d1ade98237c442bd897eeefbd22bd3c','c3f43cd4a673e2a44458fe97366d53b967989b5c4a52711bd95c47d0593463e8');
INSERT INTO blocks VALUES(310213,'17673a8aeff01a8cdc80528df2bd87cdd4a748fcb36d44f3a6d221a6cbddcbe7',310213000,NULL,NULL,'a7323e7ff6b0b41c30092fef6a6d2844a7671c4880aa050afd92ee690eb5e52a','2c43f89fb6b8257a5c83967d2fda05285e8ad258e7f00171e3b07b6f3fbc2c1f','83a9a7f266814da188406272ebec9b02a61f6d4dc74e198257d08d77a7767636');
INSERT INTO blocks VALUES(310214,'4393b639990f6f7cd47b56da62c3470dcbb31ef37094b76f53829fc12d313454',310214000,NULL,NULL,'bb190b3cd299a892c05ec35beb187fd9ce925a84d9276f7da035d141c79cbfaf','65e2623bda762597529754f8579e910dffc2b7c7f7a5f28a13388f9b9600c136','d18ddc37e27448a45eaa2c127b0ed96792fcc92cd2b51db49887f9f1ae591b3b');
INSERT INTO blocks VALUES(310215,'c26253deaf7e8df5d62b158ea4290fc9e92a4a689dadc36915650679743a74c7',310215000,NULL,NULL,'fb51d7881a295005a571902d0ad0be52ac2a69b6f5dbf2fe09607775940005a3','4bed36a0cef5e6ecd20f766d0d8da3ce0b39407d63d0890e9d08ea89c5e6a704','ab4cad3c362eb3f5e047a8a0a435682903c1b8e07901927810cbb912e7c7122a');
INSERT INTO blocks VALUES(310216,'6b77673d16911635a36fe55575d26d58cda818916ef008415fa58076eb15b524',310216000,NULL,NULL,'b920515215c8384cf04fd0341dece933924f778bfad4fb52a414a4301747a9fd','af0af9c8ee65a4d49724213a09b10a5bc06a6c613bf0f8ab6d18486962440440','5ca8bc6fed73852a0f99b059a4a6e91465bc057d1574a573d0ce9ac5bbcfd673');
INSERT INTO blocks VALUES(310217,'0e09244f49225d1115a2a0382365b5728adbf04f997067ea17df89e84f9c13a8',310217000,NULL,NULL,'5de885656c86c1a534c5c8b2f03c05b1e1c61d43e67051b8827b80ae7638c7a2','7877462d39c0cdcfe306e3b6a909b40dbd3cd1e02ec8724835a3651e2b0527f7','902d7b68408c7cc0095ee389bc29678c8308c521e365df1a1ebf7a81278b8d9f');
INSERT INTO blocks VALUES(310218,'3eb26381d8c93399926bb83c146847bfe0b69024220cb145fe6601f6dda957d9',310218000,NULL,NULL,'bdde3cafcabd6ebcd8fa892b631919081e43c9f90a0f4b0517ba4a0094789346','c7fba792086a45df9cb0b47dd3e949698f461a3c5a10b65c01200db6f42e6f4f','7600c6e5da2a9c9eb991cf677ce0608a2d402d235ea9cd3f889e6056d532acf2');
INSERT INTO blocks VALUES(310219,'60da40e38967aadf08696641d44ee5372586b884929974e1cbd5c347dc5befbf',310219000,NULL,NULL,'cd639a6b8b43be7a7fa6ae603abe3bb8b0ed4a257daeaa27e38566f74ac6bbec','685af29023a4f87625f687dfbc9b3c7e025052b23f8ff8e37042d11f9fb421c6','292da7f0a7025cc63e52b6431f446c59c786422aae26dd2fe6618e068b872f98');
INSERT INTO blocks VALUES(310220,'d78c428ac4d622ab4b4554aa87aeee013d58f428422b35b0ba0f736d491392ef',310220000,NULL,NULL,'50a93f2a30dc4638ee1a2fec501c03be0ef2260dff4fffed32c460fb9331276c','35d1ac8a3bf5225682053ecb2156a07e9b61a87e84d26655c321c6634ca70e21','a03cf019b0ae030bb6cf1e2f528b1c4f554d8999c7ac4ebf041377213379734b');
INSERT INTO blocks VALUES(310221,'cf5263e382afd268e6059b28dc5862285632efe8d36ba218930765e633d48f2d',310221000,NULL,NULL,'6c62946096ecb97d62135b6d1703d318672d47a57d20f0b546cd475b1fbed4be','6c8697962cf11ac52bd95b6d484e6f1c8b7b0a367753f6ef17d59428d45962e3','95b9645a40ba9875022b3a02352ddc4380b2b900bc793b1773527005cbc59a42');
INSERT INTO blocks VALUES(310222,'1519f6ec801bf490282065f5299d631be6553af4b0883df344e7f7e5f49c4993',310222000,NULL,NULL,'0b55f261f42f9ed634acaf1a3fa54a84c8c2c53b0094aea83b8c6c47df41f808','4e0ff13c59c2f7a58859dab5967b6168ed091f9ca79818801c840aed144e047e','e38cf578df7d78695eb46ea6e8e834968a2c84d409d702586d7158e92b85658f');
INSERT INTO blocks VALUES(310223,'af208e2029fa49c19aa4770e582e32e0802d0baac463b00393a7a668fa2ea047',310223000,NULL,NULL,'db80e32a9fa70ac3bda0a68ca6aa70d0d945641c4dc8a974618bcc3bd2323e71','9abd3efdb6994f870ccb1fe8479b9c635eb09500a6314607627b1908ace349ac','ab045258f3457b4b8f01a9a5b00ecb5b8d756474cdb085cd8099a314f73e4bd0');
INSERT INTO blocks VALUES(310224,'5b57815583a5333b14beb50b4a35aeb108375492ee452feeeeb7c4a96cfd6e4c',310224000,NULL,NULL,'94251828d3eb2547f2ff3466d54dc779403540b3d295bb3a838c2c65dc47cbda','25f36bfa48be7433bc91251fc2e3c8c2a89a3211756f694bb0de801c1ddcc611','70b69051c1d34488ea1f25e9399a6899bffa59106fad6b6e9c40e3785765143c');
INSERT INTO blocks VALUES(310225,'0c2992fc10b2ce8d6d08e018397d366c94231d3a05953e79f2db00605c82e41c',310225000,NULL,NULL,'0fa47a3e0c6c7a10af36dc052316e1a33139a05baec4ece20eb1d7a3b702b6ca','a8833bc4f98e78a0ec2a89af550b8dcbc86a329c18e6bd122ec3d74c8ad61129','f04a022c219052a90965c248aa8f1a662133bcaaf33f470abeffaf237f48e50f');
INSERT INTO blocks VALUES(310226,'b3f6cd212aee8c17ae964536852e7a53c69433bef01e212425a5e99ec0b7e1cb',310226000,NULL,NULL,'c825070506d055275302ee19f98f69e7ebd58e4f3d297b1b56026cd81ca6bb71','b62c102ae6698c7dd1dcf5a1a08b54b5d681e4b8b0713a2c9bff3f1ddbf230e3','b502e86e011f42cfe19769fdcac1681f1c5ef2721b1453ea44cb87dcd54e813d');
INSERT INTO blocks VALUES(310227,'ea8386e130dd4e84669dc8b2ef5f4818e2f5f35403f2dc1696dba072af2bc552',310227000,NULL,NULL,'708f1b03edea6a7ba53b161c91d82c83e7fdaa39e28977cea342eb05395c9fba','82388425712cf1482976ddb11774356a121a54eef2e0a68280b030746f35ddc0','c1ee2c7a1732ef64372af96eca5c863ae33860100103739649858759ab732a8c');
INSERT INTO blocks VALUES(310228,'8ab465399d5feb5b7933f3e55539a2f53495277dd0780b7bf15f9338560efc7b',310228000,NULL,NULL,'26cd9f3486d1ab73536ad3237ad0b9ac550121ff6e9051d933b4c556394867ee','cf7115068bdc282896dce82193b037a43d31e4737bed8636c1ae12623b429e8d','9576b0dd741b26fb27223c2474db98684e958a055ba5bc175c613776831e5bde');
INSERT INTO blocks VALUES(310229,'d0ccca58f131c8a12ef375dc70951c3aa79c638b4c4d371c7f720c9c784f3297',310229000,NULL,NULL,'c4064516fdd94948922ebe20e834f3cad7fbcc44e8dd99b0c6ff1a80a41dd296','5f95a3e9c43885d09115801bc50f309b964bbde1b5f96816fb1ce4a85dc95262','7c905f6899b92af4ebea2b1c856957e9730592b5c5709acf2b9b223986beb82e');
INSERT INTO blocks VALUES(310230,'f126b9318ad8e2d5812d3703ce083a43e179775615b03bd379dae5db46362f35',310230000,NULL,NULL,'919f82a675cc2747b52d53feda9bc3db70df0a626cfc6db7734282145997424d','8ee31d2b9e5d1456ea0ed9c5f101a6f33964bcaeb3b573b987065a295535aeaf','189eab4c11ccaa5fde2d1ec25df6cc868445624a28cddf410b09f70ef7ed0d6e');
INSERT INTO blocks VALUES(310231,'8667a5b933b6a43dab53858e76e4b9f24c3ac83d3f10b97bb20fde902abd4ceb',310231000,NULL,NULL,'b585efdca8b230d5d0477e27e33c46bdae4d4d13a320f72d48553718c82619ab','cd7648a044a2e9fc6def2dcc8cc6f803aba5bdbf02dd448da09a1e5c3836d3d0','78868b0a737502cebe6f73ff9bc6c4869f2858018976a7bc74a69e0e4d1ea8c2');
INSERT INTO blocks VALUES(310232,'813813cec50fd01b6d28277785f9e0ae81f3f0ca4cdee9c4a4415d3719c294e8',310232000,NULL,NULL,'61ae8d3c6bc169cfdafbd3a16c6b09588e7862c0d967c637bf7a81971f549484','9797ac5eb25d7ff1bf1fd8551a85e897c1ca32b6f161c94242dd004f09c48788','51f5fbd1c63ea04419676ec816490e0a060a6d4c847586c8dc162605eae6e447');
INSERT INTO blocks VALUES(310233,'79a443f726c2a7464817deb2c737a264c10488cac02c001fd1a4d1a76de411d6',310233000,NULL,NULL,'ec03482b84af2c4e39d4ae39cb7eb08f2ff44bbee9ddfbae8526f28f619014c7','7c78a591dd625ca09924697eff067ed52cb79782e2a23e1063cb70e3975ade09','9c3ada8336c63f5068a817b44222c726517bed5a5837ad457682775349a3da8c');
INSERT INTO blocks VALUES(310234,'662e70a85ddc71d3feae92864315e63c2e1be0db715bb5d8432c21a0c14a63cd',310234000,NULL,NULL,'752d6e11a32e9773df8c8caf6c88dc976d1b2ee83bc7fe83ec92a13d906b3fb5','bcd31e726585f1cb2f404f26b678dca496939f4bf4a3d9618e6ded52c1c9ef50','d233cf5f962b0486d0b17611e976719bbe8528e810ba93030c0d9ea9338b22fb');
INSERT INTO blocks VALUES(310235,'66915fa9ef2878c38eaf21c50df95d87669f63b40da7bdf30e3c72c6b1fba38e',310235000,NULL,NULL,'2623f294c75796eb33bf3bd54dd60cd1f388df5e2a2bd611925e0b4b2ae54034','181b1e0259b272d4f4f17a031777f6dee483c8a91904050aef81fe4df0bd31b4','251f46fb974125423c2f459080a3dc284c6d6f3714c78b06aef32f11851fe572');
INSERT INTO blocks VALUES(310236,'d47fadd733c145ad1a3f4b00e03016697ad6e83b15bd6a781589a3a574de23e4',310236000,NULL,NULL,'4ab86ec570c3137acb69947799cff3e2b9ed259614988c414579eb2ba78db253','f14727e42120e9b38c1828310ef05a7f4a677902d8424b11461d95b3c34a4b6f','0f26f04e52b847a7ac13975b25287ee96f0899b82619aba2612ad4c8158fec39');
INSERT INTO blocks VALUES(310237,'2561400b16b93cfbb1eaba0f10dfaa1b06d70d9a4d560639d1bcc7759e012095',310237000,NULL,NULL,'b43837305599670c0351c467d42ee01dd2d4db9739e70956fb1e2c2ec29cae59','6ac8e8851fd59efe5fa652f1e93e0a757dfe259607dadd861e3fac2663a5df8f','d233359bc4790a555ef50307b84a1557a7f889d7d27e21c281dbb3f0599d7e83');
INSERT INTO blocks VALUES(310238,'43420903497d2735dc3077f4d4a2227c29e6fc2fa1c8fd5d55e7ba88782d3d55',310238000,NULL,NULL,'d6ac59104a8bb1c9bdeff28e3d79aa227b2e36452bb393b2010c07c49989bb3f','551bcaa131c9397da23e0fecc935165aa316da13d17160c4d148ddfee285aba3','7141a62efd278320ac79d1f3c7431184853a9c60c93022a5b04eec843799c627');
INSERT INTO blocks VALUES(310239,'065efefe89eadd92ef1d12b092fd891690da79eec79f96b969fbaa9166cd6ef1',310239000,NULL,NULL,'6d324be1402bcecec8636efe1d296abeaf180ca3945cafd4640588abfc2fb622','728bd955b603e7216bc5dfc6a95b833f016573123d9cb845b08786d0bdbe737f','538d8721327ff63f1bcfb3e5785b472d41eb15e92c2a112a89ad0563ead788b8');
INSERT INTO blocks VALUES(310240,'50aac88bb1fa76530134b6826a6cc0d056b0f4c784f86744aae3cfc487eeeb26',310240000,NULL,NULL,'3d9a97e083b433c84bf35926f985fb39392e99eaa987093b5558c6d51c0c3257','877308198119b2e9c2d156e228afd203eca52f3b8b81baf18747eb5f9d82fee8','27b0e6f97fd7e7069d15e827adfcfb9bfde647d9088c674589a300da254d63d2');
INSERT INTO blocks VALUES(310241,'792d50a3f8c22ddafe63fa3ba9a0a39dd0e358ba4e2ebcd853ca12941e85bee4',310241000,NULL,NULL,'744238a23bf617d1274d894e2d987ac2bd6554dff98ca81cd198928d918c3a4f','e6b3187a729376acd803faa60dd95240be2851ae7dac380d05b2e6498ea5fe56','4e2e9ca428defcf060e0a270b6ffe4ad3793381584a2854cc322081f14876e5d');
INSERT INTO blocks VALUES(310242,'85dda4f2d80069b72728c9e6af187e79f486254666604137533cbfe216c5ea93',310242000,NULL,NULL,'4a834e1435a3a530c130278639a452b963ed8ad682b7e4ba40bbef3c0884970f','da24995864fafa6b76e26ccb9ab9f0c95442c06c19703e5bde2849e8e5566414','7590733fb63d3b922b300bf2dfe4ce2040c71d97b59291005e4f6fcebc412ef6');
INSERT INTO blocks VALUES(310243,'a1f51c9370b0c1171b5be282b5b4892000d8e932d5d41963e28e5d55436ba1bd',310243000,NULL,NULL,'3c38948a1daaf2c44679c03c232d867524623c0af54c25c58ab80141629a3411','41d5eed1a206fb0b98856efb5e8c456765e801fd2116787daa11c5be925c0ec1','854f5f2150cf5268386ecb3a35eb131a663e97f09406c6cf90d7ffafba4ce740');
INSERT INTO blocks VALUES(310244,'46e98809a8af5158ede4dfaa5949f5be35578712d59a9f4f1de995a6342c58df',310244000,NULL,NULL,'40e163a4b75a64a4373d781d42af8acb0a7357208facab4f670cc80bbc352288','3863cdac6c8f7d4eb14f3069cb45112237aaf508bc5c4db3e85419f83010975c','ee4de5410fddb558949033dd4ea79062b09cd9fdd9583c8e47f8bfb29516e5df');
INSERT INTO blocks VALUES(310245,'59f634832088aced78462dd164efd7081148062a63fd5b669af422f4fb55b7ae',310245000,NULL,NULL,'a80e1a21f48ebe40e4d1181fb5779c2aebd334a7480455720d8dc91420adc48e','e26b43f99c2f53e0da29a51b4705859d5cad28a248496bccb8b50f01640ae4fc','bc155f4f22ecf553913f3974b3b81362292df8a704e344c8b916971af25ffb60');
INSERT INTO blocks VALUES(310246,'6f3d690448b1bd04aaf01cd2a8e7016d0618a61088f2b226b442360d02b2e4cd',310246000,NULL,NULL,'b3621966a7f1df8ba2e3150d9dc04e7c58784e05c09fbb47c0f94af6324d42d7','ac96a1ebf8f2d1422db23950d427840c3d43e885f92186e03e2377cb37098632','966167103a593ce8faf251fa81d4f390bf29b2979f4760905359f4d97a3e3356');
INSERT INTO blocks VALUES(310247,'fce808e867645071dc8c198bc9a3757536948b972292f743b1e14d2d8283ed66',310247000,NULL,NULL,'16c29dfb1ada9a941e4d65651e6ba662eaf0d32446390014494811af709daaae','900ec0d23326afdb622cae13cc7846ae0bd19992642baa4d8724e86c6e9d6ca7','f9998634b4f24c02b03736b8300dde4fbf8a5f99c6020e58f0b167c12b010fcf');
INSERT INTO blocks VALUES(310248,'26c05bbcfef8bcd00d0967e804903d340c337b9d9f3a3e3e5a9773363c3e9275',310248000,NULL,NULL,'46a1d502bb61030ab25f990e1d4776fc91074dd798fc6cbb86061fb5f0dc3279','1b7b770075f103dfeaa0f26c42d6bc22c6e7126f655a1ac0bf3b7f18f28c1145','f941ce624a887da3a26455b6518ae445a8995c3fc1b6ccc6154db246f390dfa1');
INSERT INTO blocks VALUES(310249,'93f5a32167b07030d75400af321ca5009a2cf9fce0e97ea763b92593b8133617',310249000,NULL,NULL,'bd30958dd32410059f89b5d1ed05dec1fa7d4a1ac5091a9c86d37438c1daaea3','541c238b77aa06a6a1bd1a0d600456ee0250301c52c94b417851ec78ced33d2f','b2146248e52f17dd5f05ebb4100b68676d05d69db64a1c2d7f2366c7cf6d4611');
INSERT INTO blocks VALUES(310250,'4364d780ef6a5e11c1bf2e36374e848dbbd8d041cde763f9a2f3b85f5bb017a2',310250000,NULL,NULL,'593844275ff962ef32ae358957dcd7c4578bc155bfd88cb6ba2cb6db7e4bdb73','43fd99a1ad012a268ec377937f7ed20ca178019873cc957bc37fc7a54b1cca64','e8d99ec803c6f48e6d9d35afb38ae77085ee2cccffb2dbcf0eff90ae77cf3514');
INSERT INTO blocks VALUES(310251,'63a3897d988330d59b8876ff13aa9eac968de3807f1800b343bd246571f0dca7',310251000,NULL,NULL,'00790d2383678d2627b583eda36f39bde92883829b93d2628c741cf469cbc337','d2780cc98e2922c14a40c99af32142b1acda54e1513d59456045c5aeaffbc4fe','2598643dccb2618a681d6835e2bba6eb5e9656de0bcdf4f132d1d0063ce1c024');
INSERT INTO blocks VALUES(310252,'768d65dfb67d6b976279cbfcf5927bb082fad08037bc0c72127fab0ebab7bc43',310252000,NULL,NULL,'51238eda52d2c02906de13b4f240b2560234e6733a78658c9c810f3b0da7f1fd','60f7746d56496095d977161abc3cc093ead7844fa0c6df7b1ecd03931f19eac6','cc5e80d767198640b45bbe4a646123d4be865bd78dba29276a016667e58deae0');
INSERT INTO blocks VALUES(310253,'bc167428ff6b39acf39fa56f5ca83db24493d8dd2ada59b02b45f59a176dbe9e',310253000,NULL,NULL,'78bb0b7368a4a11f6f6e82374640dff9a15212a34ab009842aa330557458412e','5ead06e0faa2dd4b162493e4aeb3b51438251f1f246be845d3e8f7b32b3f0b31','0c2ec74405dd1a44dadf86ce854b6579afef0b57318c5a932c3df2207b8b1066');
INSERT INTO blocks VALUES(310254,'ebda5a4932d24f6cf250ffbb9232913ae47af84d0f0317c12ae6506c05db26e0',310254000,NULL,NULL,'dd78d671bffc09ef422a2e78f8b86c09f9d857e9612b1012a4c1d34e9a904568','5283a046f9afcf5c2414c4c0c0542c0051ab1f4f897062d980c8e6e5a6aa0d3a','b03b89805bee418ffb25658f90db94cc9b575328586341c12eeacf184f2524d2');
INSERT INTO blocks VALUES(310255,'cf36803c1789a98e8524f7bcaff084101d4bc98593ef3c9b9ad1a75d2961f8f4',310255000,NULL,NULL,'5e234216c346a42fa291f82db4a4bbd4067a191c5943bad6d289119e04f1a457','c3a8b51e4a5b4cc7c2741001872305e0b070a4423cd1b125c26886e619d641b8','e68ffd58992a39a62af25364119edce8849d34830fb935527b13a61224e8cf8f');
INSERT INTO blocks VALUES(310256,'d0b4cf4e77cbbaee784767f3c75675ab1bf50e733db73fa337aa20edefdd5619',310256000,NULL,NULL,'fa2fd79c10830d09acf216e1d185848b6366f31bf61af06ca5ecf8983083404c','6d3a179ada71c33aceee3cfc7e81794a597555600808a3be3b9972b2a4cf9494','2a363a92254240bd041911d57fd939fce48c803ae292f179cc859f61c9e8788b');
INSERT INTO blocks VALUES(310257,'0f42e304acaa582130b496647aa41dcb6b76b5700f7c43dd74b8275c35565f34',310257000,NULL,NULL,'9fbe93ef51bf55fe68323af3338accd41728dfd4cdb1da3d6871d599fb5d27ef','43d25403a3163fb853572262efb78b9d492811cc5efefe05f29bb99c93e2196a','5526521b2560716772176684e7ad7abeecef12e74214c01b1db5e5ac7f86d144');
INSERT INTO blocks VALUES(310258,'3a0156dd7512738a0a7adba8eeac1815fac224f49312f75b19a36afb744c579f',310258000,NULL,NULL,'200d17131d04a058c75c7a85b97e42fdc695854ee8d077f7b27fb20ec1412cf8','e1a8640740e2ef61c74a9ac19b41841ddb0c7eb0ed6b9d5fa414216df9167514','1688afd3dbbd20061b3d83d02b68fd3499927560def6d427933660df0b6abcf9');
INSERT INTO blocks VALUES(310259,'e5ed3cdaaf637dd7aa2a7db134253afe716ffdf153e05672df3159b71f8538a9',310259000,NULL,NULL,'912c9422436d2169c0b7ff383b8bc523c5365bc3c1158d86e5ec7987ddcb0401','0dddd773e0a06be04785d3845cca5831f6f4f4db9c16ecf3f6fe52668949717b','5301c856926c52770fb3637ccd12e77147d549e8b704779307e0d5b4231af703');
INSERT INTO blocks VALUES(310260,'8717ddcc837032ad1dc0bb148ddc0f6a561ed0d483b81abb0c493c5c82ec33cd',310260000,NULL,NULL,'931d3214d64e7daff87f5d70ac9e0dc1daebc1afc2334efd0512fdbad18cc4e1','b188f636bc19ff8ae4c7cc6e999c3bf4629cb593cf040a24940fd13f82ebc89e','40580c3b192e9842fd72499061bbef4251a492919ed7d5957b2acec6ac888255');
INSERT INTO blocks VALUES(310261,'a2a9d8c28ea41df606e81bf99cddb84b593bf5ed1e68743d38d63a7b49a50232',310261000,NULL,NULL,'8fa1c2a7587e206c18066a671a64256e8fa9941c2faea46156cc0ff31a1646e1','9056bbe71c3b5ff47122a3f6641209a66a5888c10a0a5ed261235d71c22c8547','210cb0497a15f64ae1a44dfd567e7c7a1fb41c2922a17825e9d7f9a4d132c319');
INSERT INTO blocks VALUES(310262,'e8ebcee80fbf5afb735db18419a68d61a5ffdde1b3f189e51967155c559ee4ce',310262000,NULL,NULL,'32c294546290e27a2433cf5c90da5c92e846ac95fb82f309c776c7cd9b5edfb1','84833af84495db41e371b3fe23c68d8687a4ff7225a770e53aa7b21c61fb00f7','cf169152fa0a5dc2d3e42d7acd796f9047e80a33b4e160b7875be304fae508b8');
INSERT INTO blocks VALUES(310263,'f5a2d8d77ac9aac8f0c9218eecbb814e4dd0032ec764f15c11407072e037b3c2',310263000,NULL,NULL,'385ee6105c723c16f6e0f35f5d7bcff7cdd7241aefc05311f6c5a8ee6dc24cd7','7fe2305d70dfbe63bea666f2bbcc3b87c564d9dc3ad8e9b9938eabd3d14051fd','7fd4e9fc18167eb7a1ab920bb0923c7ca0ac778abbf91bbf52010f14d9480b29');
INSERT INTO blocks VALUES(310264,'ae968fb818cd631d3e3774d176c24ae6a035de4510b133f0a0dd135dc0ae7416',310264000,NULL,NULL,'6effff8293e1002bbc4459708c08cc1728a8e98632a89fd94553b015eb6094d7','a501e7c6edd73b1ac08d3389d2865c1ddf3e3ed5b74e2508d5bc12a2d2204d11','0ad340f8e997ca49fb1609ff7a4ae38d97be9995da9ec17861e3a7f7e8426d9c');
INSERT INTO blocks VALUES(310265,'41b50a1dfd10119afd4f288c89aad1257b22471a7d2177facb328157ed6346a1',310265000,NULL,NULL,'ee29f9e1b9dba3251a27b526f53d79d7e98890afe0b6978f33fd1c4f57344d0e','d3c81c63c73e083ac8e484669e3987a071e81f2108e24d1f51568f9744782d4b','8257a2260bf4f8d4ef6a2aa144a5297c87c69fb0dc4dba5eac81dd9d318d4190');
INSERT INTO blocks VALUES(310266,'1c7c8fa2dc51e8f3cecd776435e68c10d0da238032ebba29cbd4e18b6c299431',310266000,NULL,NULL,'b6044b3f0a9004c93506d02e75c4782bbe12b2c388efdcacd89c5760df42b557','870737d073f6aec8f4924a04c75b128b8949e4f97d79a9aebf44509323fe3078','98074c32817b4601b1b4712a6e5e9265dc6e702687784b789aef5ec16e4c5382');
INSERT INTO blocks VALUES(310267,'c0aa0f7d4b7bb6842bf9f86f1ff7f028831ee7e7e2d7e495cc85623e5ad39199',310267000,NULL,NULL,'fb3f26ce8bd4aac1a02ba09c764d35f9cb56dba75f709f92422b01fdd7a4f49d','ab8e7fbfa5bab7c4fed029fd5d8a20b361644e1329ef1e906657e61cbdcd7437','722b992a1d98781849e92f69d399cfa8c103edcf9f8501836e19f9a1a185008f');
INSERT INTO blocks VALUES(310268,'b476840cc1ce090f6cf61d31a01807864e0a18dc117d60793d34df4f748189af',310268000,NULL,NULL,'48f730944343ac8abfa3f7a852075232c50c1677dc1237428375b252a0c89afe','8c5dcd01a330019a2f9c0813158bd6ef2920e1232ea4d84e7e90ad4043d01714','964fd633f3360581c4a09f1a535b7671b519aba29229c48c757a925c0f37e863');
INSERT INTO blocks VALUES(310269,'37460a2ed5ecbad3303fd73e0d9a0b7ba1ab91b552a022d5f300b4da1b14e21e',310269000,NULL,NULL,'510ad44b41fc8021c0d1172b3dc6b2ced9018ed52f42f3d4956e988943b6e71d','c0ebc79e2f537d636a176c777d752529d351549a0bbd51259a30aaac7001252e','a4bdddeed7fafc5c9ac679f0b338f70e6d0c4e36a231af7dea36ba1cd04cbd87');
INSERT INTO blocks VALUES(310270,'a534f448972c42450ad7b7a7b91a084cf1e9ad08863107ef5abc2b2b4997395d',310270000,NULL,NULL,'31fdf38a3c5f9181bfd284d0d751093c1f41945fa8d7032575d934e2e2376fb1','6d33b077c2ee401cc74d16db783a48500b665f7ce472392ad787291c01a1151d','eb7b8fd74858aa3f0dc9c2cd3749d154fbe94fbb35c89ecfc56636bff6ff72be');
INSERT INTO blocks VALUES(310271,'67e6efb2226a2489d4c1d7fd5dd4c38531aca8e3d687062d2274aa5348363b0b',310271000,NULL,NULL,'6195bcbd82a2b229910e6c8bf33f047caaa43e1de6e2eced813bdcce81057bcf','699b0fc196f406ed31582040fa51a959235771eca62188d285b8271666565b28','7f31c754e0f47ee064d192f840cf258ef9db12d16842019d1b763eaf546d5d48');
INSERT INTO blocks VALUES(310272,'6015ede3e28e642cbcf60bc8d397d066316935adbce5d27673ea95e8c7b78eea',310272000,NULL,NULL,'1e9f54fa5b4811dbe7ef7855b95cc095c9763e866038c51f80a7593bfe9d2f01','765f05d63484d276c0a8551ff8031abf040185b2a00b0fe62b86a66dac81f17b','a2e2a11907d04ad0ca51bc9ce2a5bf107222cc833ba1cb8910ee5c3ff6e485e3');
INSERT INTO blocks VALUES(310273,'625dad04c47f3f1d7f0794fe98d80122c7621284d0c3cf4a110a2e4f2153c96a',310273000,NULL,NULL,'04108d79e2e448ee634fc931495319591d5083e2d5d026145f00b3b1853c97c9','1dfcdd0c4b24a3d64e7103dd4a621f92d5ae5f611484e404b2f273cb2dcef35f','c5d8bc27b8f9a09e1e2763fc7a6c92dfafa1d80d54c0952dfd9a8ec702621ce5');
INSERT INTO blocks VALUES(310274,'925266253df52bed8dc44148f22bbd85648840f83baee19a9c1ab0a4ce8003b6',310274000,NULL,NULL,'4ff9f4036369703d3b80fff33837fba9786c991a3a926619fc8bb7b3adc38a24','6502e6602af0ce480cba64d91841043b5f068c0e40519bfe5b94e3c4b01aba10','694cdf4432d38e0aed7eb4d77cd15b3c3dcfe86472003f5b3d6162942bf0fb44');
INSERT INTO blocks VALUES(310275,'85adc228e31fb99c910e291e36e3c6eafdfd7dcaebf5609a6e017269a6c705c9',310275000,NULL,NULL,'c613fccca1450f1868426b7c900452ca09b6c83589d72bf84c8afcc04b1fc0a2','827dee0c0330255b63c832aee32deced94ef4450e76a2e5a06fdb5e411192fd9','aa3ac62439f77e6c06393fa1b45f61be9fe4370c40f9a9dea025ab0a4fea2013');
INSERT INTO blocks VALUES(310276,'ba172f268e6d1a966075623814c8403796b4eab22ef9885345c7b59ab973cc77',310276000,NULL,NULL,'0964596a5bc5e655abcbf7b7070288223e6f51d324ab56e9335430c3a62b02a8','857cd031e3ce3daa756cc10dba68a77da257bafe4ad1b07c331d61ce2e0294d5','b6d4e802eb9ff05276f4229ed334c97be7152abb405930617695583db8176ee0');
INSERT INTO blocks VALUES(310277,'c74bd3d505a05204eb020119b72a291a2684f5a849682632e4f24b73e9524f93',310277000,NULL,NULL,'d8c6969dd1f2609ddaeca194440cf7ed142d896553ad51f6e474d141a402daa5','8449e0df70590e80ef4fc217aef3f7239310e8611b2600a3589760c5c9186e59','a72cc42ac4430b96ce15dec493296cf1337172ef39031c32e6c21d9542a576f8');
INSERT INTO blocks VALUES(310278,'7945512bca68961325e5e1054df4d02ee87a0bc60ac4e1306be3d95479bada05',310278000,NULL,NULL,'71a060d923b31d6031b826bce24c95312acc68cb17a0b8569797f2422dffaf32','bc56b964ca6dfaf71948fe0d2f7fc6edade55c2a7b66fb5c238510d1a7fc3eee','f72289f09ad9295af520d0f39b7d87306f25a9ced10df4206a05c95c1c6b3bbe');
INSERT INTO blocks VALUES(310279,'1a9417f9adc7551b82a8c9e1e79c0639476ed9329e0233e7f0d6499618d04b4f',310279000,NULL,NULL,'5491e20db3b734e3bcb83d89fba3d3cdbd23e04a617cb61e344f67f5caf37ed0','74d2bb7c2f415c20e6a91af440012f85fb96b1370b8b244bcac0a16f7122999d','6d45562cb7f2d5835cc35df88861cabf1b8b3b09f29bdeb5d63808acbc5e33e6');
INSERT INTO blocks VALUES(310280,'bf2195835108e32903e4b57c8dd7e25b4d15dd96b4b000d3dbb62f609f800142',310280000,NULL,NULL,'4dabdaca4e18c632095694a0dce232842e33c5464cac7c9fe1924cbebc270667','e443af3311354eec98c71e6ca6f413dda568d33a1fa1f214ef8c151d008c5882','75fbc1376a6c9a57d10cd350d7e3511f0ac8d205be0da566b6b00211834cd76d');
INSERT INTO blocks VALUES(310281,'4499b9f7e17fc1ecc7dc54c0c77e57f3dc2c9ea55593361acbea0e456be8830f',310281000,NULL,NULL,'dad6cea793dc8fd3d8c3ad04d054467e73b81603392729987c593f8ca67c3be2','0eb3241064a2817558d0c470422a80712c86527c88e74de3007f01daa1eb134f','7e5f90cdaddecb746514268e6488315f3602cd6ab3a8cdadbf622f5bcb433427');
INSERT INTO blocks VALUES(310282,'51a29336aa32e5b121b40d4eba0beb0fd337c9f622dacb50372990e5f5134e6f',310282000,NULL,NULL,'42b1f66568eab34aa3944b0eeebea5296d7475cc0748ae4926ddbab091de7903','70404d6d8ae5e2d2c595cbbaf15fde5f81a178e8fdfaeb4304df158302a6bebc','007ec9883774c7877c37c396f2b9d70d11bbbdcf410b5c1bfeb9b3ab7d46d2f5');
INSERT INTO blocks VALUES(310283,'df8565428e67e93a62147b440477386758da778364deb9fd0c81496e0321cf49',310283000,NULL,NULL,'edfae1059d89469e4d8c9285bafe05968e62c35504ce5d5f09bca4bd8ac0b698','2d55ac961dc85a6cc3afaedf15517417af5c8c315beb3e553e344a6851873b13','399ea11e10d41a3a4277bf5792d5c0ffeac6ed46593f321b42f399c4ee12fa20');
INSERT INTO blocks VALUES(310284,'f9d05d83d3fa7bb3f3c79b8c554301d20f12fbb953f82616ac4aad6e6cc0abe7',310284000,NULL,NULL,'2b9d8a4322352981f7033af84e111c94511ac9b87d7d2599cdf5f2814b45a42a','7a2fda07f6dbde9dc5108dee860a52357293688238aaff9a89dde2cc2a1e0abe','329bdbb89229bacc57c8c2c5006f6616b64c10566ef963893235b046dc7d0445');
INSERT INTO blocks VALUES(310285,'8cef48dbc69cd0a07a5acd4f4190aa199ebce996c47e24ecc44f17de5e3c285a',310285000,NULL,NULL,'63d6307a1f8d09526578c4b1776e51b40cfb5ad78d01dedd3e23d99f1efeda19','389507705d20e27fe69e83e881088ad3eaf194ecbb9e573fc2ca2610e573f841','ef552723f94a7b951ac4364aecdfad32f47bf5bf57e4cf864845b894d1639738');
INSERT INTO blocks VALUES(310286,'d4e01fb028cc6f37497f2231ebf6c00125b12e5353e65bdbf5b2ce40691d47d0',310286000,NULL,NULL,'a42dda85ec8530a307a1f9e7048d4384b229c2637305eee0368ab02957f5b31d','b4f132eb0e4e48e81048ca734d35f236b4d2664fabf4461742052420ffb8e6c4','75a98ce53eea6b9b20fcd0743dacaa33384d25863532194e1a486f470503b160');
INSERT INTO blocks VALUES(310287,'a78514aa15a5096e4d4af3755e090390727cfa628168f1d35e8ac1d179fb51f4',310287000,NULL,NULL,'96bdbe4268d82b3b82d776eab32019393f5de5ec5ea2302c0c2a9aaa068fc2a5','2c3f8efd84c55933f44c3367b9d790d3209acc86fe85f503b62b003794d0b5cd','ad9010211aecba46abc0419399baaa8a8e7b8b43098d050801d3e456454553a4');
INSERT INTO blocks VALUES(310288,'2a5c5b3406a944a9ae2615f97064de9af5da07b0258d58c1d6949e95501249e7',310288000,NULL,NULL,'0c96ab72568c907e27db628c30825012ea3ec633d3debe3256dbf4d3c95f81c5','e97fa7e32d27595eee6ddb3182f9a2bd6ecc9a310c3c9a08e40589d471dbdb94','70115c23d355ae0c494e831b5328cbf237ce35ef9cd77987579cb58458918fd1');
INSERT INTO blocks VALUES(310289,'dda3dc28762969f5b068768d52ddf73f04674ffeddb1cc4f6a684961ecca8f75',310289000,NULL,NULL,'921af39c1d31264ba86b6e6ca54b8dbf40bfbee574c1278d78d686b20159f99c','54dfdb1ccadaf529a90b9742acec786093408ae662d8162ea7591c1d5ab409d6','94426b0534b6bec5155d6fbb3e37f0eab68c9d2864ce6acf66359924def64a5f');
INSERT INTO blocks VALUES(310290,'fe962fe98ce9f3ee1ed1e71dbffce93735d8004e7a9b95804fb456f18501a370',310290000,NULL,NULL,'743e6499fe6b1b82914457c8bc49c54abc0dbae277eccc0b7fcc203e86f89f6e','fad0760c9546fa548693f362a0b85b575c0bc642a0bff88f9f48beacfe604cf1','e565c0dbf214ab60661bd1613f0a7eb125e758df5247d55d95da9b3ccc03b5e5');
INSERT INTO blocks VALUES(310291,'1eeb72097fd0bce4c2377160926b25bf8166dfd6e99402570bf506e153e25aa2',310291000,NULL,NULL,'194402bf041424fec8b63bd9b5851c5b0d04958b5851bc9fbcbcd9e683079e7a','c91bac7ff348d7cea480e89c29092a622d5889eb6c505f54df99e03dd52d8165','120128624819bdbb180c4a49c43e21d6a6956cad882e0b384624028c4cc1111e');
INSERT INTO blocks VALUES(310292,'9c87d12effe7e07dcaf3f71074c0a4f9f8a23c2ed49bf2634dc83e286ba3131d',310292000,NULL,NULL,'c8b7f8f3ef06df7a9c7eff346d2a9f0d1f1377c064c3b3c3bc2aebc845caee95','a5266917dfcc353fcfbdcc78dc8d8f54ab4f4184be544a259885a9be04499dab','92d954210804b820de17cce4e3e1d9faf507d1c18bd41d78a44c6dc94169c0ea');
INSERT INTO blocks VALUES(310293,'bc18127444c7aebf0cdc5d9d30a3108b25dd3f29bf28d904176c986fa5433712',310293000,NULL,NULL,'0c9c8a8558e14645d818621e4a97c66cc9bc67023141c5bd00830436e5760fba','331b3f49e04c3ed5fe55baff1dfda1ed488d42db0e5652356b4dcda520a9ca39','100d416ab4329bbb5515300f1c130943f1574adcc5ccca22131bd0476192a9d4');
INSERT INTO blocks VALUES(310294,'4d6ee08b06c8a11b88877b941282dc679e83712880591213fb51c2bf1838cd4d',310294000,NULL,NULL,'1cb04936a9ee72f465e4d6d4fd6f2ac99cacd74a510d74f017320dc7061c4b02','94edf41378e614d2bdbafa94d45b12d51ec5247149cf4649375523f7fbcf8be7','63c9a54c85be2dd28dd0255f270e4009574c564bf512ab7c60149263f22e469c');
INSERT INTO blocks VALUES(310295,'66b8b169b98858de4ceefcb4cbf3a89383e72180a86aeb2694d4f3467a654a53',310295000,NULL,NULL,'d7751796cf10b5a92ed9470cab6dc1d0e2a1853fd457fd913e58f5fd38771d2e','c215dc108e374597734080b9927c9a78b7062ff375317e55bc6955fb55772a14','e4ef2dbe8a9cd6a2e5ba4ba7d4307945771d1aa6e8536a85fe864bb425208af7');
INSERT INTO blocks VALUES(310296,'75ceb8b7377c650147612384601cf512e27db7b70503d816b392b941531b5916',310296000,NULL,NULL,'e23e480658f3c900b36af8fde0bd00255b960ba1b65dbce45a773b4ae813ebcf','913f68dea7a74d8ceefae0522b90b6556526adfb0dbb1e575e28182b2643752b','49c90fed2d200aa79000046941883b80b5d9383ea3d41bbbb7752dcaa2916d8d');
INSERT INTO blocks VALUES(310297,'d8ccb0c27b1ee885d882ab6314a294b2fb13068b877e35539a51caa46171b650',310297000,NULL,NULL,'802b11ed2d95f872d2fa557725a43b15fde5e7b550a3dbf229881090866ee577','621ccc9ff5389914560723f3a3f84229812d86e81e61e1a6551fe84ffbd255fb','ec15542b5fe3aa7832943fcd0fb197ba20a135fef276500fb086704c8b67f4d3');
INSERT INTO blocks VALUES(310298,'8ca08f7c45e9de5dfc053183c3ee5fadfb1a85c9e5ca2570e2480ef05175547a',310298000,NULL,NULL,'d8d94f75f311d053b6cb52ef8ae295423c99f533351d78145614b4fbc69f6742','3de9abe36a201df41d3bc0b472ca46f14b4668e327d8703fc562a899219dc388','2cb8b271e6813a19b5aa4a9522f943cec96bf06fc4f1cd6d92df38c2db4a00aa');
INSERT INTO blocks VALUES(310299,'a1cdac6a49a5b71bf5802df800a97310bbf964d53e6464563e5490a0b6fef5e9',310299000,NULL,NULL,'841a917e1aa259167a05c911d705a07bdcf980c9c5e831999923793a03a1d46c','15c70010a1ecceccf7fe005618d320e9d136afcb85cb1393dc6667d30404813b','3ec236ab7e22befebe556df8fe2fd05852d575d2df37b52a8a64d7621cc8ab59');
INSERT INTO blocks VALUES(310300,'395b0b4d289c02416af743d28fb7516486dea87844309ebef2663dc21b76dcb2',310300000,NULL,NULL,'3d74164b7ec33cbc0b3e372b21e025c79b35e99784a2d8ae359f2005972bd5d3','531532ac3013cb06cfe0f8a709479e1b88296904d15053d040ddfe769e729912','fd8235b4c1dcad55f41ce53350c9aa94730fda7577f159e4ad875265318099c1');
INSERT INTO blocks VALUES(310301,'52f13163068f40428b55ccb8496653d0e63e3217ce1dbea8deda8407b7810e8a',310301000,NULL,NULL,'1adacb3d5e4701b0f1bc158dd5164dd770852c5520e850d6d9b9e63fd1e7c37c','c092479add0a7a2a324d09f1b2506480c56ba1892ca5631e0515ead724e48207','22045bd15d2a68d7a683ac12379feb9b9f78b3a4ad23cf3a0455bc6ddc036565');
INSERT INTO blocks VALUES(310302,'ca03ebc1453dbb1b52c8cc1bc6b343d76ef4c1eaac321a0837c6028384b8d5aa',310302000,NULL,NULL,'587b7eb8bff455f2848380f870d20398ebae76e6a12acaafbac6e955d3c3380d','48abd72de20f9d4c127990994355616e3f8e9bdbcc4bba24134f5688e5745645','82b7a101471aed4d3848c9c46a1d9457754cfd15885ab765eaa84350916fef54');
INSERT INTO blocks VALUES(310303,'d4e6600c553f0f1e3c3af36dd9573352a25033920d7b1e9912e7daae3058dcca',310303000,NULL,NULL,'27120588c29741bbb4a802829d2b35d8b8b17e7b5cb49842faa0fefe05e99071','5a9c8aff6193529cb07875b560cf5801eb60c6927c94afb00ef05781678932d0','a7fad4a077beb5349d7b8452798270843da42f1732c5bb53e00b24617278bccb');
INSERT INTO blocks VALUES(310304,'b698b0c6cb64ca397b3616ce0c4297ca94b20a5332dcc2e2b85d43f5b69a4f1c',310304000,NULL,NULL,'4a1d23a03c47c00574d3423f328c48d794ceadd2655cede15c5901d830c87589','ae5e86e9e3bd360080744f2b458891924433cd80fa4212a51bae97cee3624c11','650ad73ed35919e5a3344691469b5389e720e92dff4981cf800fc6640f4601b6');
INSERT INTO blocks VALUES(310305,'cfba0521675f1e08aef4ecdbc2848fe031e47f8b41014bcd4b5934c1aa483c5b',310305000,NULL,NULL,'7aac15d414e5ebcfaf63a9ac3bc05d2dde5ffc610d9bafc8ff2a210020f6d5ef','1305df57b83594a1b0af5b09bf6563f1dd4d38406f754f3259d74c40199a5be5','78b7ae69d35133728bbfb9f192eb072f937cde0a01d8f9dd3f71304a8045d74c');
INSERT INTO blocks VALUES(310306,'a88a07c577a6f2f137f686036411a866cae27ff8af4e1dfb8290606780ec722a',310306000,NULL,NULL,'bc47cbbb42618bea636c422d824748d97d5bd4b4b75ab44d80ebeaa9b5fb309a','fd84cb59c4807cda9dc2d2eca17a54ef8fd72e65c9f6dbc6ea084650a9f06211','27ff051c90496d7a7cc24869e7db926ddea4aa9a7d9c82416b985a8e55b00ad3');
INSERT INTO blocks VALUES(310307,'bc5ccf771903eb94e336daf54b134459e1f9dd4465dec9eaa66a8ee0e76d426c',310307000,NULL,NULL,'02440bc84b5e8e1733d29e4524381c8ba25e38727d5f70d6246627761660f329','33fa791428d19ccc4a7a0549a6b9148662c76be915032257c13e672e790c7503','94d6f47eb5596aa6ee6f7396851b88d8c9444090f6d60c7a585999233f7618b0');
INSERT INTO blocks VALUES(310308,'2291ffd9650760ff861660a70403252d078c677bb037a38e9d4a506b10ee2a30',310308000,NULL,NULL,'44c5b13272847e19dd2cacf9a506145f9a1ac5792916eb98204bdb6772e7ab68','e3d430bcea4d2a92a5633ec1951d5cf92791fde977eb58a50975124873bf986e','27ae20fd0c7cad68085be23c903c0c31f51bd62c5a35ded15558fce8604bb2ec');
INSERT INTO blocks VALUES(310309,'ca3ca8819aa3e5fc4238d80e5f06f74ca0c0980adbbf5e2be0076243e7731737',310309000,NULL,NULL,'25ea894e3bb4f88ef9c8f86156a3980c0d638c20c69e8bc6365f913d1454c14b','50a7a00863d2e9d51ba39c90229dd28d741baacac19974687d1db5e7e4091f71','2627203bf8df54d26bb0529b3ecc65f0fb0513075a086814bdc155780cf06d57');
INSERT INTO blocks VALUES(310310,'07cd7252e3e172168e33a1265b396c3708ae43b761d02448add81e476b1bcb2c',310310000,NULL,NULL,'94d123e1ef62d5063e363065d8d44f9ab7f22c59eaa35a2ce38177c7b7a8eea5','d8090dbc48f87abbbea49e16bbd3bb78b764ad5f1e77a38cd4fa0b6aa87de1b0','994caa1e42f8107d146054c3c638104d55b7001a8525b4571c5623cbe7ea53c1');
INSERT INTO blocks VALUES(310311,'2842937eabfdd890e3f233d11c030bed6144b884d3a9029cd2252126221caf36',310311000,NULL,NULL,'3aa3b3f04dfcb85db112ec7f540a7f54b56ad7f749df3d0d1dc738ce25bc5728','2577388ffb2683f4e91e5c9aa92740d798f8d2250cc58b6f36e355629028c006','dfd014bb645d3669c124936598579860469f790ede66580eff5fc7a1b493ce31');
INSERT INTO blocks VALUES(310312,'8168511cdfdc0018672bf22f3c6808af709430dd0757609abe10fcd0c3aabfd7',310312000,NULL,NULL,'44991a8afb1cb85a381557bd653b1015160842edb02266164460559a4ea9e529','7104cd28d22c08fd5ddcf45ef2b0d802e88747abbdcf957d9b855c12eaa3812e','2b4b4d895aa1292468e7dafd1c93e8ef754e0d02b7c3ef0739397da7e70a5b1e');
INSERT INTO blocks VALUES(310313,'7c1b734c019c4f3e27e8d5cbee28e64aa6c66bb041d2a450e03537e3fac8e7e5',310313000,NULL,NULL,'d7b21c8000a09ce9f26037c43073e2d7a596c68c954c5416d22454d3e89c8b70','b2ba4c4a1479fa548fe5f1dbce5c10a2f6de7ed6d7214ea1f249bc735ba06cd1','be42b067d1989b9e42ff85e32264278fcf4e36951886a8e03f206e42f4d62c0d');
INSERT INTO blocks VALUES(310314,'1ce78314eee22e87ccae74ff129b1803115a953426a5b807f2c55fb10fb63dc8',310314000,NULL,NULL,'5c1ca6e4f014f1fa35870558ad52dd5252e6b54a02919546a03d4e6498370d44','0afb0936a67306063d5115c62aa00b814bb280941b53777fd7857f7142749880','face3b9c6872b5ae6d4994c2c9d9e0836d93191b0f5c043a4e66991b3482de86');
INSERT INTO blocks VALUES(310315,'bd356b1bce263f7933fb4b64cf8298d2f085ca1480975d6346a8f5dab0db72cb',310315000,NULL,NULL,'ba3b14271b4899094ad98e0535979eed35dc2aad617d7996155251ddcb4d0e4e','a1b2ab175fc3983e988d5277be5300bd0b4d6b80606c971c6adfd03a629a923e','8df0667edc9b75ef6effdb3ef21387c2d241ad8a748f890545638051cec67a0f');
INSERT INTO blocks VALUES(310316,'ea9e5e747996c8d8741877afdcf296413126e2b45c693f3abdb602a5dae3fa44',310316000,NULL,NULL,'b33797e21d7654e1ca5cc08bca4a6bda9ae95f23094d42b789530b6cbd584b4a','c30dfc2e22f22eaa937f66b9b4f50be62f2514820ff641eb6f4d7572b471e1e2','df893593114360e017d1081fb662bc9843975cc09c7e71fc5f1d9b545f342fea');
INSERT INTO blocks VALUES(310317,'aa8a533edd243f1484917951e45f0b7681446747cebcc54d43c78eda68134d63',310317000,NULL,NULL,'497a601664ea59cf1929096b129613ce3bbedc271ecfb33b364558e231d48649','2f09ff9eb35fa96b5a645ac8aaf941a3c9354a6975e3a8f658bd88a93a1866d3','c9c79b9b27bd210a39279d5ae282cc8208769c03b808e9e137af529590f88f79');
INSERT INTO blocks VALUES(310318,'c1be6c211fbad07a10b96ac7e6850a90c43ba2a38e05d53225d913cc2cf60b03',310318000,NULL,NULL,'760dabe4684acb6c8638c56ee1387e4d6710f99adcae4cd9721da0c7decfe2bb','68a3a498822552f1a49f2176f60e5f3bd6cf34b25b8813c73e4ef044d6703052','84e4865123e01871f55be4cd5cb17e5b1129068c64de51ee4f067589b697525f');
INSERT INTO blocks VALUES(310319,'f7fc6204a576c37295d0c65aac3d8202db94b6a4fa879fff63510d470dcefa71',310319000,NULL,NULL,'e43bbfd0e56daf582c84a2286079fbd8aa661c149cc3a14d40d139a45fd7a19c','4c6555a7ffddd839f7f97fb319a9339aef529ef05cf5dac5b9528f45e630612a','32b3eef724b58c9c0404f773983f1f0006154c3db256db961d183224fbfc0814');
INSERT INTO blocks VALUES(310320,'fd34ebe6ba298ba423d860a62c566c05372521438150e8341c430116824e7e0b',310320000,NULL,NULL,'7f95ee77cee4a1c0de27a0e69d909d0c2cb8d5a5d76d6d92e8bfac58c3f148bf','e2fa79acd2c66efa122d4a95085f0badedbb1e4d87a1d3a98391950cd159288f','729deeb85930061ff3a53f4242944901651bf60e1280be13179791681f328325');
INSERT INTO blocks VALUES(310321,'f74be89e9ceb0779f3c7f97c34fb97cd7c51942244cbc2018d17a3f423dd3ae5',310321000,NULL,NULL,'9e2bc1247466f28c92ff287e9d5825f81e6b8b4063c70db23aacfde92f627417','f50941bec7006a46a8d11750023993fb030abbc6be83d2022acd201103f272d5','e9b64ca5e0358e7ed2223489c36036fb0910132c22b530332980c12f5f4b6333');
INSERT INTO blocks VALUES(310322,'ce0b1afb355e6fd897e74b556a9441f202e3f2b524d1d88bc54e18f860b57668',310322000,NULL,NULL,'bca22d67b45b3bca60a0e4e1009d4ba86bbba96b0e37455e094eaf933f7d892d','6059b468846476a30aedc7c25e5879d1ea9bd5572aa315e869906f63c7ba0c1b','19c66bb2407e57374ca419ef21c290f48da7cdbf45d0dd3976b9eecbb529c4cf');
INSERT INTO blocks VALUES(310323,'df82040c0cbd905e7991a88786090b93606168a7248c8b099d6b9c166c7e80fd',310323000,NULL,NULL,'aa76c1d43196055cc6ae91e0afdb1105db0e5ea8b9f8d20298878900c07e8ec7','39ef470455659bb6647ab7513664089c55041b3f26b127f6492ce8d8aecdb24c','5260e0d1254c86e295377244dec7d1d95709ac84ed70a6389e0cc5b91dca521f');
INSERT INTO blocks VALUES(310324,'367d0ac107cbc7f93857d79e6fa96d47b1c98f88b3fdda97c51f9163e2366826',310324000,NULL,NULL,'dbdc8005f1f6c45dce8e0450740c37f2d21e6f325e1c2279bf78094aa1098ebe','46eb36e883df562f5733a6bcdb208faf89441281f274fe584a842145f9ae0dcc','308901cf21aeac194e66d7d4e99493c18a5d7ebf94ac598b5ebd27ce74b2988f');
INSERT INTO blocks VALUES(310325,'60d50997f57a876b2f9291e1ae19c776df95b2e46c14fe6574fb0e4ce8021eac',310325000,NULL,NULL,'021f052a73f177bce172f220d3a1ab9aea5f325e32b3d2635905a0c95b4c6efa','f46bf32deee097657902726f0472b148f80ca826ec490df7a63d2b21a5d163d6','fd654501179e6f718603a5cf0fc339497ce276f4476781bccf260a1ec20a0f50');
INSERT INTO blocks VALUES(310326,'d6f210a1617e1a8eb819fc0e9ef06bd135e15ae65af407e7413f0901f5996573',310326000,NULL,NULL,'f90a81326133a303229276b553796e2f9d186f98ce897f759cadb19e6728090f','3459ed17bf76b5ce9f9fc6505223fa6c57ed2344bf93831122299fb9782075d9','32638e7f5e99c145651aa8ba65803d07b39b8e69348fa05141cf228f91154aae');
INSERT INTO blocks VALUES(310327,'9fa4076881b482d234c2085a93526b057ead3c73a6e73c1ed1cdee1a59af8adc',310327000,NULL,NULL,'86aaa9593f09bb338fa1b0878f2522db223bf8262e491ae0b8e707f9796c5e05','a862d229044c3b2a8bbc297166df52737170533b03210ed4591516c525ed766e','a3ec1c7043157f6a64f147f9ade620e246810bb206ad83717f10bd4f3a804180');
INSERT INTO blocks VALUES(310328,'c7ffd388714d8d0fc77e92d05145e6845c72e6bfd32aeb61845515eca2fa2daf',310328000,NULL,NULL,'f4b59e29f0c89f18d045a800d098abfffbc9ad7ff200eeb47133605eb1a72b68','1172467febb4811df8babf3c85781674624faf027f6f21b7740f0141de92c270','4f1e4e87827f1a2351e624945ba0296c383ecdc6a26e82783e2bf6427d8dde28');
INSERT INTO blocks VALUES(310329,'67fb2e77f8d77924c877a58c1af13e1e16b9df425340ed30e9816a9553fd5a30',310329000,NULL,NULL,'dbd3510938ee45e99d8b7cac8b0d3e8a275dfc6b1c8e741e0320e4b2e4947fe5','a591f484c1797fdf55b944666904ec4275a636e0d10193306a7905a399ca0798','e800777a8f2d6d96e049bb45e5f19cf8700020de0c4e91ed77b9f797d54da645');
INSERT INTO blocks VALUES(310330,'b62c222ad5a41084eb4d779e36f635c922ff8fe275df41a9259f9a54b9adcc0c',310330000,NULL,NULL,'79f20326c0e49ea2b3c81e8d382754f311e3744b22b80140dc7ceed4da1fe09d','e839227695b2e5ffa02f1b80cf60c8f12895c6ff234a32206c373a7ce38ef10a','c45ae94b91387aa83dcaa2fce80b4177b3a5a61965d8f38e56715cb66391f8e7');
INSERT INTO blocks VALUES(310331,'52fb4d803a141f02b12a603244801e2e555a2dffb13a76c93f9ce13f9cf9b21e',310331000,NULL,NULL,'41d2d69965cde1e0f97b7c14c33acbad592a6bd4882eed6aeb57127ed4ddb69d','974ede3afd0fdc8138abbd18d28422d53ce0c1cd1ec9f2b1e2802a2f15a0065c','1f1429ea8bf39c60699a1774eec1fd86399f40e814e02171b6938ae1dd945afa');
INSERT INTO blocks VALUES(310332,'201086b0aab856c8b9c7b57d40762e907746fea722dbed8efb518f4bfd0dfdf2',310332000,NULL,NULL,'3def70343846a9776559707fb61437a53ffc5dac917f81ee3a12445ce69a9885','5cd59bbdad81617ad660a40de602e3509d1c6f262ea1c234a9f4cd74161abde8','4262a4784732085e9dbac26ab7029bb51c4340cc8592d9ae0dae9c44428ac61d');
INSERT INTO blocks VALUES(310333,'b7476114e72d4a38d0bebb0b388444619c6f1b62f97b598fed2e1ec7cd08ee82',310333000,NULL,NULL,'cc02e3e7327ddd3c192bdea2ee76728c0b0cb031fe130d5713c1ec9546ae5946','52e50b6883f252e85cbbffc567d8189acc96d3700d6e82d9200499586d7e41ab','64a4d9b971c6adc8c6730ee570230962a55b78d65b94f5f7e6ef7c3ce63e366a');
INSERT INTO blocks VALUES(310334,'a39eb839c62b127287ea01dd087b2fc3ad59107ef012decae298e40c1dec52cd',310334000,NULL,NULL,'8a449270a6bfb33206c1d7eb02ca363cb405118e52359a1ed015c5660fcec8a8','dc4f1a5238f02ba1efae2fd60c26b55eed40d0c2c27f1e10dca0fb30295dee4e','9f22d83e3aa25dc0f89ceb916e8648af7152c613e642ebbd4d32ffdaa4dbf1ab');
INSERT INTO blocks VALUES(310335,'23bd6092da66032357b13b95206e6527a8d22e6637a097d696d7a96c8858cc89',310335000,NULL,NULL,'942c5c5ff6c24ce2bb18e065b24c39d1906ec381bba55cb9d905376ac87d2bdb','2642ad328ae0ed192c78156708322262934066829f0cb9ecbaffa38202b90c13','2fa51cc1aba41abe11b92c7ac3f141a41c6a01e37fd8ce66cbc95e1bb3de9e53');
INSERT INTO blocks VALUES(310336,'ec4b8d0968dbae28789be96ffa5a7e27c3846064683acd7c3eb86f1f0cc58199',310336000,NULL,NULL,'68a947f2ae4507e143c9ac84826318d4b630845f81548490f7b0c00a2330e990','84acc59735cf2b09a6efd0595692efb944001948123f2e52259e3d51963ca0c1','cf630acca60bfb7b99a17823d5a79c68f66c7bb9c5880328c268477e456098fc');
INSERT INTO blocks VALUES(310337,'055247d24ba9860eb2eadf9ec7ea966b86794a0e3727e6ffbcba0af38f2bc34a',310337000,NULL,NULL,'4e1ca24a54f45b4cdc60be1348b3d5b81ee8acbd7c4f8cda86b8d2746694f17f','6957b850377a61fc418191974a16372dba94543351e0c067a793bac02e63ccf0','fb21ff7aed9abd9c9606465fdc9e3a148f39ff438ff22a094bcfbc4778efa6d7');
INSERT INTO blocks VALUES(310338,'97944272a7e86b716c6587d0da0d2094b6f7e29714daa00fec8677205a049bcd',310338000,NULL,NULL,'dafafbcf8cbefadc5596ba8b52bc6212f02f19de109f69dc412c2dbc569d5e8c','5bad4940f1552758e650574975d155d2703b283607fb33a87ce34a06afee150a','4f7c969c2c53d9d1d67133bba30090514560231b1f0cd690f7e792f3acb6e02b');
INSERT INTO blocks VALUES(310339,'99d59ea38842e00c8ba156276582ff67c5fc8c3d3c6929246623d8f51239a052',310339000,NULL,NULL,'e28e2a9c9f9476d0c23bba3c6d2e68f671aa20adf72199188a9c82160b0cbadb','fc908b8478e628a98fe07ada666325892f16d2ac9223efcb0edab756f326eff7','fdb6cb1abee7ef45e3f130e1fc684aa22f29b7b421e5dbc2c72f66e0638435b3');
INSERT INTO blocks VALUES(310340,'f7a193f14949aaae1167aebf7a6814c44712d2b19f6bf802e72be5f97dd7f5a0',310340000,NULL,NULL,'7171d5b8a9f07885a5fb6059e4ca31dc00863ebebcfc82836ed2af0deb39a48e','7a7e13d5dd75fa06623e6f47238281354267cd634a33df9ec78a6f5fb9052374','68e83e96a682d39e142d669f764a2e220b8d9e0b65436b2f289f2da987223b5b');
INSERT INTO blocks VALUES(310341,'6c468431e0169b7df175afd661bc21a66f6b4353160f7a6c9df513a6b1788a7f',310341000,NULL,NULL,'d350161fb4026c48acc21d9e66a2def972fbe543c46381a353de2d2fd8b6bcd4','bf428f672ec8546b9e1dd3e72a58b94df0837e8bc09b6e53ae84f35acb9f370c','b58794c4bd57332264aa9f3307e53f9ab2cec92ba18ee91f0a317b008cdab98f');
INSERT INTO blocks VALUES(310342,'48669c2cb8e6bf2ca7f8e4846816d35396cbc88c349a8d1318ded0598a30edf7',310342000,NULL,NULL,'6acbdd85b382016a93936385edf88ea1114706f2d326ca373ad508b653e5fd28','4c7f0605214ca176cbe68892c92e47bd80f671145af0755ff044b91051b0ab34','6c3f6b95633d40447cc362a2fbfe147a9d97712a85e35d37dca08e91b8a30b1c');
INSERT INTO blocks VALUES(310343,'41a1030c13ae11f5565e0045c73d15edc583a1ff6f3a8f5eac94ffcfaf759e11',310343000,NULL,NULL,'68e26f1c578576a74ba6b63cda11695176b48c7a919beaab5496db142b247cab','5fd63c5c2f45bf06e2b7f4219727fbf491619d688d2f54f83f783fa88c76c578','a16d7a04e389255c313ee00bb165191ca1fef39f17a33390c40bd7c45206f35c');
INSERT INTO blocks VALUES(310344,'97b74842207c7cd27160b23d74d7deb603882e4e5e61e2899c96a39b079b3977',310344000,NULL,NULL,'2531f6b71ce2390aeeab26cbc8095aec7a76dc46db73149868d8a6209133780f','dd17ae3753dd1746dd6646651987922f6f3890f054589cce7eea46bffa39b488','13dd7f4d95f36fa43a9e987598df609c81b24eb3382b7e8d96d1c23275ed78a2');
INSERT INTO blocks VALUES(310345,'0bda7b13d1bc2ba4c3c72e0f27157067677595264d6430038f0b227118de8c65',310345000,NULL,NULL,'ecf8e55d01bec5ec8fc302451bc3e0d3a76d5d413ce354ed43e36eeef274cc14','8fb988eb849f23578e7c6a5b7542d67f3707fd44f84e5c283077c45abf8c86a3','a9bf7475219405c77154a1afe07b9e818207244ca72f95ce6a5ca280a8f40408');
INSERT INTO blocks VALUES(310346,'0635503844de474dd694ecbcfb93e578268f77a80230a29986dfa7eeade15b16',310346000,NULL,NULL,'2149f9f24dd41e092555f29cf7ae1131cc53462e9f24de15720c0fd1a8a874f2','f076d855e078ead470268c826b5ff8ff2b49c826e510dc3242fc00132eb40153','4a883cd95dce2cf9efe01f59cc052d8db1e5490ef4edf8b4bfc49a6c7fd3f4aa');
INSERT INTO blocks VALUES(310347,'f3f6b7e7a27c8da4318f9f2f694f37aaa9255bbdad260cb46f319a4755a1a84d',310347000,NULL,NULL,'f19aa2d83d53f128264cf432c9c313d89d2d91f09af8f2365ffc4bb0911abc5c','8a0dbbcbc5b98fca7980cd8c1bd8f4a7559c8f7e30145462deddffe090e931d8','2a56573434919f1edba922734002d62c7f4edc6b437006b58bd136f1f3007c4c');
INSERT INTO blocks VALUES(310348,'c912af0d57982701bcda4293ad1ff3456299fd9e4a1da939d8d94bcb86634412',310348000,NULL,NULL,'5ac2d42a9f7cbe6fe7ff53879d4ac316e93c00b005543c1575c3a72471765118','dd634e450587fbb04df7b6d37f67daa33446c3fcd83642c8a276f3d6536ebf5a','c334749587ec427133cc15b2939426b59e6994538934813a01dde4810e441e4d');
INSERT INTO blocks VALUES(310349,'ca911c788add2e16726f4e194137f595823092482e48ff8dd3bdbe56c203523c',310349000,NULL,NULL,'ea77bb132fcbdef8652894fc3c80a862ac4fb0daaa444213b61388285904bed8','5418285f255c29eede23c7d525b90152968883143659f8b03a2027472937eebf','6f17a86b5606282350d34b3b522cddf794149037417d18f817e7e2cf72e213b3');
INSERT INTO blocks VALUES(310350,'c20d54368c4e558c44e2fbaa0765d3aecc8c9f01d456e3ff219508b5d06bd69d',310350000,NULL,NULL,'af48f18af140a67943df6ce781e858631a4e7841c7f44facb644c93641145237','a68b0e022d63912f16e63fd31ace28db6e5f861e0aa416a82791d1d84059734d','0cc5115254fac017d9aaf8798c83470bd805a550a7cd307fce0b87cdc32b9b59');
INSERT INTO blocks VALUES(310351,'656bd69a59329dbea94b8b22cfdaaec8de9ab50204868f006494d78e7f88e26f',310351000,NULL,NULL,'4ae931b01a138a0dd8e4d6479faac7961fe3148fd048c4daaa6720f907cbffb1','54c9963f89e03f5e6bc46b5c272fc380309a716434772074a41c75c910f6a6f8','6f3ab37b664dc84fbfde98cb64060283008e0ae6b331d3b044722b77f476047f');
INSERT INTO blocks VALUES(310352,'fb97d2f766a23acb9644fef833e0257fdb74546e50d9e2303cf88d2e82b71a50',310352000,NULL,NULL,'d75ce96ca15ea976fbb89c93da04a0a7c2146abc01517663f97ad0fd15adefc7','03c63640cc379bcc7a6c893efb1ee4051ebbb02c6e9fec4686027c7e1d6d5b6f','686c379d55fcdfd09f536bfb043c5ca867d5575a28fc2ab02889ba9ab704f80f');
INSERT INTO blocks VALUES(310353,'2d3e451f189fc2f29704b1b09820278dd1eeb347fef11352d7a680c9aecc13b8',310353000,NULL,NULL,'c0830c03df4b203d5e17a9274643e614fcf6e6fb7216067cb4f41f874436d217','e7639c05f74deaaedd7c6a49f80413a67a83a0e5d463e33687c152442db7ea3b','ba2667eba2e6d5a885a892bff1ef1af0f48adae196d660ef3d0b8ea11d6d9f03');
INSERT INTO blocks VALUES(310354,'437d9635e1702247e0d9330347cc6e339e3678be89a760ba9bf79dd2cd8803e0',310354000,NULL,NULL,'6f4d2524f4f976880e60e65aa631f8cdfa0b23fbeb3c41549c577b695b02fc34','1a269c5e7f273086659711d1bdc9aa865c6e13785ab686e4f031ede81df9628a','990a53bcc0a43455cc0efe99879035d6b19e9af5f2bb4d12b331513b67aa5e43');
INSERT INTO blocks VALUES(310355,'ea80897a4f9167bfc775e4e43840d9ea6f839f3571c7ab4433f1e082f4bbe37d',310355000,NULL,NULL,'dffc32456b12dd7dc4bbf95ab9f360d8abf4b2e705b2822728053709222f7e50','86c51472783a899ba9d1856d8bbab022fb3ddc806fd665d68f51c923a0ba1901','feaa89f5c038074cbb93d49df9c8812e34dc1689526a96ea18d35308ff3c2a9f');
INSERT INTO blocks VALUES(310356,'68088305f7eba74c1d50458e5e5ca5a849f0b4a4e9935709d8ee56877b1b55c4',310356000,NULL,NULL,'01c0a7d3388aaec2d2f713b930df5b716a899ccd25d3b7e3b4c21657be7923a8','1f556704a985e577b0bf398322a6d545a8aca5fc0e4bb2828cc99cb156ee612b','75d8322337218fafdaf33067dfd05620ff3008c98ea8b2ed387cc5196c8e64e6');
INSERT INTO blocks VALUES(310357,'4572f7f4ad467ef78212e9e08fa2ce3f01f2acc28c0b8ca9d1479380726bab1f',310357000,NULL,NULL,'4dd02f79c7ad6348031e564ead17921d1d112b6bf8c5f4308b52ef2511983683','c9e5ac66ae8a2a228ff1216694754e240ae9a644229d6750b0247b8993ea4833','c9e152d22b882f6a9f96412da987618a0fb4bb16df49a01f02dbf2cc55295766');
INSERT INTO blocks VALUES(310358,'d5eae5513f1264d00d8c83fe9271e984774526d89b03ecd78d62d4d95ec1dea6',310358000,NULL,NULL,'a2815a72842de9330b82b8901f18116f208c379657cf8610c3510dad19b64124','fb6ae67b90db2b07681df245810488b70167631f0313dd1e231a1056d531d73d','99d9e7b69c591f5ff5461dfed4b49052818fc7b733cc265ecf397bb092a27078');
INSERT INTO blocks VALUES(310359,'4fa301160e7e0be18a33065475b1511e859475f390133857a803de0692a9b74f',310359000,NULL,NULL,'23acd53757b9ce126a8817e2727a54a23b57246c92e6fda1f16fa4d5db378973','5667c02a8af530dfacc7cc911e38dc063759d30ffd74752ef4ab236df7ff73d6','c8a61e763ce5356135b51d752b418ee825ff18061ca044e6d8433c6faf0a72eb');
INSERT INTO blocks VALUES(310360,'cc852c3c20dbb58466f9a3c9f6df59ef1c3584f849272e100823a95b7a3c79f0',310360000,NULL,NULL,'9325c1235f22738cd4897884005d5763db8b792930a968c1c6f75300f087e484','0f2a55710b41882d645c69317d27b02e240a2c62b310ace880db3692f2e4f232','630d52652b40a605e80fb0ebe0a5aef8f481ed851f81a21de97c3eb3173c52f6');
INSERT INTO blocks VALUES(310361,'636110c0af5c76ada1a19fa5cd012e3ee796723f8a7b3a5457d8cb81d6c57019',310361000,NULL,NULL,'30f7ec0f50ae1e4d4dcfbbebc789dfea4669c2a21a4d251550fd6696bce94952','4af0936fd09fdf8965f47b988b58db3e9a5d70868103f6165f8a6c9787e3af46','4d11958ad512db361409f5c8b8f6da8b67a4c710c15fd376c34ae1860f021e06');
INSERT INTO blocks VALUES(310362,'6199591a598e9b2159adb828ab26d48c37c26b784f8467a6bb55d51d7b6390f2',310362000,NULL,NULL,'6fccf61f9c49986937cb13205f4ccdca952fba67c1af89d8c05da51b11ad98a4','ac0667986b1154c884735e53abd53b080f7baf6e9df4c19d27c748d982c680b2','84c1bcd75de7dabd971cb0618f3073575efd75048036c0cf7052d9ed1e10dd95');
INSERT INTO blocks VALUES(310363,'a31967b730f72da6ad20f563df18c081c13e3537ba7ea5ab5d01db40e02647e6',310363000,NULL,NULL,'74a243525a58bb5d1c051c10d1ddacfd307b69fdbb2da618e079322f3d317b61','6a90a55f3954ed1e79319fba1f10a355baf5575b69c9a11f840c9e32eef95374','60c307217194cb4ca39cf99bf2a9c4db63368f2136f96026efaf861ccec511eb');
INSERT INTO blocks VALUES(310364,'67025b6f69e33546f3309b229ea1ae22ed12b0544b48e202f5387e08d13be0c9',310364000,NULL,NULL,'5a0b10220431a5d6777ef9e49ba6333c7026f04ae450d48a7273732e8cd55ffa','ce81bfbbd2c4b60d4ade43e4f240b5beb98d04ba7bbdf83397d718ba09aa59f0','9af529c2b4ed9a4604c1aee4df1e90418fc1d72cacf09dd4ddd3a1029027550c');
INSERT INTO blocks VALUES(310365,'b65b578ed93a85ea5f5005ec957765e2d41e741480adde6968315fe09784c409',310365000,NULL,NULL,'50e97232160d4b608299961f420a6218588c5650a8e45295a08f789a49b25d20','24e3681da09f39a99c1d0a013f73dc7f8d651f8239108b3cbfad509232c26d4d','8d84c172306175c309d849d3a20828981fa14bc3ff983de3fa9999fb4078f02c');
INSERT INTO blocks VALUES(310366,'a7843440b110ab26327672e3d65125a1b9efd838671422b6ede6c85890352440',310366000,NULL,NULL,'4521f3e3fe9fc9254b0d66fb4cf24ac72c50808751791e5752195c0dfdb403fc','dbb590e84b6747ba725e4cc788617fa6c7681183af81fb72df8986ef9975df3b','28a801cf27d8f8efa53034527da94d093fc28e83d1d0c25c6482431de28a24e6');
INSERT INTO blocks VALUES(310367,'326c7e51165800a892b48909d105ff5ea572ff408d56d1623ad66d3dfeeb4f47',310367000,NULL,NULL,'9b89619d958dab0246a3f2c8b8f402bbeb3a59637f492b7119a9a84bd939b661','bce2d0ec89da3e4ea379c654023ee3c5c7291cdebf4d87711c2b3133e2ccdc7d','09fb9d9911ec5aeb30f048ae81aa334ec0fc2af386d9c99a5db76c1d46e7fc53');
INSERT INTO blocks VALUES(310368,'f7bfee2feb32c2bfd998dc0f6bff5e5994a3131808b912d692c3089528b4e006',310368000,NULL,NULL,'569a5946690bbc8251325d0569181b4c276eedbaee5885b816ebbef86d01e196','af57e7bf1e8cd598672b8515cd6b78385272a2d9a226f1cb3b6ef31d2d2bfe38','077202a3a287ee95048fc27cf35db485bab7577c86a70eb0c73e82835b5254b2');
INSERT INTO blocks VALUES(310369,'0f836b76eb06019a6bb01776e80bc10dac9fb77002262c80d6683fd42dbfc8da',310369000,NULL,NULL,'0ca340f24633d8884a88fbf3c7c9280c31460745dace8563b0b66ed382e0fa2f','4fd67866546e85141696f50af76b479dcc4c167b6036b9a38e72af1cdaa6cdea','a02507b0654250963be9717d4692cc9fa44ee44cfe9c73a657ea3a767be4938f');
INSERT INTO blocks VALUES(310370,'9eb8f1f6cc0ed3d2a77c5b2c66965150c8ceb26d357b9844e19674d8221fef67',310370000,NULL,NULL,'290093d9212196ee4c03b9eac0245803158dba2948f158e2c74f8dc10ac09329','3a54d08d6ee575a0f6e3aff8a85a0d129a98670cd80b0f06917d166e446c052e','0983fceea7efa22406e847cdc40e5f0b01e86900731df0a7da5c0e2a23f34027');
INSERT INTO blocks VALUES(310371,'7404cb31a39887a9841c2c27309d8c50b88748ed5fa8a3e5ba4cc3fc18310154',310371000,NULL,NULL,'fa6616279666c600602c38434c2b0fc9dfa1e551513e4144419efd45e0ee0462','9ac8d92949f0ff1ccaadad9871c4723f5ec0458df6c774a04f7a58c434542215','900b9167d101913f3fa440b54c2df1e4acf4cbba965e28d0b86e977cfc35ba60');
INSERT INTO blocks VALUES(310372,'d3a790f6f5f85e2662a9d5fcd94a38bfe9f318ffd695f4770b6ea0770e1ae18d',310372000,NULL,NULL,'25d0ad708dfe99367db6dea83491440f2c30421a5a7c4fb024d0ed79cf59b1aa','ca5f352b585dd5520ed06e1c558a7ce720c50f929920f5b3e677518b6b9571ba','c6d86399811a8478a37f62ebfffbe216ee0747e526ce9e33568ac3774ce70df5');
INSERT INTO blocks VALUES(310373,'c192bec419937220c2705ce8a260ba0922940af116e10a2bc9db94f7497cf9c0',310373000,NULL,NULL,'408be37b314e37b6192d85d81c706f9e25c0d7e5a5448a6ed6284d324f587054','c684abc2dd4654278ec31d987e58d5a4950340e60a88ca21db65f87c0f740bd1','9e9e188c5c009fb50d662d5218d8f66aeb0a4cd6561fb439b73c2d4e129d894a');
INSERT INTO blocks VALUES(310374,'f541273d293a084509916c10aec0de40092c7695888ec7510f23e0c7bb405f8e',310374000,NULL,NULL,'3153feb773ab5352e9380d3faedf2f32f427dd35b5de78b52293abe855c1091d','16667ba78aa10a9ed413f32ca0300066bd3f65218acd0926cfc0cda2b0612b7c','2e9e2adb26f0a8aa8623b79789c29f2bf930e3d17460eebb6f9ef0483c034ecd');
INSERT INTO blocks VALUES(310375,'da666e1886212e20c154aba9d6b617e471106ddc9b8c8a28e9860baf82a17458',310375000,NULL,NULL,'5364cf94d87ffdb49360513b1271c5f107a42830cc8ca70b4751045dbcf92eea','7a7c63bb2bbd7c722b8a5f86ac5ab703fb20207f31a2595890e7fa88a9b6a47f','f9bab3924bf924ab66e305a636c9fbf46f316f51b5ebc1373de7511918632b61');
INSERT INTO blocks VALUES(310376,'5dc483d7d1697eb823cba64bb8d6c0aded59d00ea37067de0caeebf3ea4ea7dc',310376000,NULL,NULL,'ad88937d28e8e5e24af4af424cb4004005d71b7d056d8d93b9f1eeddeeafe4f5','f2385bf7e0fe56f7c9b4ab67f9db04cc3148df77af257027b38f7fd756e1e2e5','34b83a55c1112fbfc158ab3ccb3e82c3aa5ca7a051e7c6a1583e781e696b66eb');
INSERT INTO blocks VALUES(310377,'f8d1cac1fef3fa6e7ad1c44ff6ae2c6920985bad74e77a6868612ee81f16b0b3',310377000,NULL,NULL,'0e30a4b710daab3563f7fb624dd4170e0026e60574742b57cb64cc03d621df15','8730df6220c931ecab843482b1cbf25b72320b2f9da5989ba475734d95e10c7c','664815caae9ddffdc3af15b0afc537799f2616bb45e1f27f32c51975d3f7e291');
INSERT INTO blocks VALUES(310378,'fec994dd24e213aa78f166ca315c90cb74ee871295a252723dd269c13fc614ce',310378000,NULL,NULL,'7fd86de094040b85e820255f840b863f0725c53738d32952fdfc58beae9c6589','3aa26b9e47bbb0582085b3b7e3919b85557f02d5780681897659d12b533334f8','31b08daceb389a29f66118d4aa378d2fd168eefb64fb5883f5a7169c221e29b6');
INSERT INTO blocks VALUES(310379,'d86cdb36616976eafb054477058de5670a02194f3ee27911df1822ff1c26f19c',310379000,NULL,NULL,'fd89c38a53a75eee1c46a3e29cfe1bdb4956cd9bf8de15b582f0bf0d90dfa13b','9282e78b2652e5241702c3f7721ba9ee7e39bed905fd68a5b3b147bf62f4cb7d','2a5941ab0b65e64466ec4e1cd95f1168b44b32c391e4c08c1579d8ce881bcbec');
INSERT INTO blocks VALUES(310380,'292dba1b887326f0719fe00caf9863afc613fc1643e041ba7678a325cf2b6aae',310380000,NULL,NULL,'2967d25d8d46df256d7bdd08a1f2dc77cb42af8adb2f53830d2d9abfb2981f99','25a15809901f4653cafba36ce3c0dd335a1198c6384770337e1a3af1edc0b22b','a7e180aaa0029275af1428d0455bae032e335ebf2ec28f556b3270cc004afc40');
INSERT INTO blocks VALUES(310381,'6726e0171d41e8b03e8c7a245ef69477b44506b651efe999e892e1e6d9d4cf38',310381000,NULL,NULL,'703a73971fe4f5d48ec8393c7e8dc8cc13374ab8a2d52c68988593c4de8817f2','9c8f89b9ef9397b1778f12a7580468b4cf90e12afb8c15a61ba38e7b7d702530','7bdc342f10a3f87b0dfd7f0345c682243e655917cf261396c330b7b69cc2c7a4');
INSERT INTO blocks VALUES(310382,'0be33004c34938cedd0901b03c95e55d91590aa2fec6c5f6e44aec5366a0e7d8',310382000,NULL,NULL,'198e36c164a6f40c76112501fa1c70327e3e005a042d1369faf0126f41d58d62','e4aeff2642de826dc91d5b09eae509403274a9ac072872176da74ed9496addbc','04a053dab15958f039f64fa5f4ab0e09cb271aef8e24d9dec09c97e2dea8161d');
INSERT INTO blocks VALUES(310383,'992ff9a3b2f4e303854514d4cad554ff333c1f3f84961aa5a6b570af44a74508',310383000,NULL,NULL,'591cf03f57957fedb0522af2ca5fe111c5828157054f51a1b3fd9cf72b429a28','bd44f5fce4e9c3c96d75dc761178fc3e0ac025e47160814063016a149f17b8b4','47135240d3b89d082b043b00183110c1a1eb8a02e2b217d60f94ae620d9849ab');
INSERT INTO blocks VALUES(310384,'d518c696796401d77956d878cbdc247e207f03198eabc2749d61ebeadee87e5e',310384000,NULL,NULL,'5c911e05c1670a675082c98b242b80bc5ad3ddd105ae4d4bdb2cb6601e172a29','9c8e952f89a94d865f200c3dfefd5462785ee73dd602119d2223b746fda91ce7','39731085b00fce81617bdc7df0f7343247baae7263adb282b2e45a13360691bd');
INSERT INTO blocks VALUES(310385,'2aa6a491a03a1a16adbc5f5e795c97ec338345cfdf10ff711ffb7ac3a0e26e28',310385000,NULL,NULL,'1944f881a1202cd4aad1cb089bd916386581b94c96002cdfa67a69d7b537324f','231f44652c6c859a279fc57fb0398b24b92d96d8ae5faa1b5096fc41ef528a2d','bbf5fb7a2fac9984dd544e8a84d6bf9e494d3d24007d7b033b3e50e7fc231e90');
INSERT INTO blocks VALUES(310386,'9d19a754b48a180fd5ebb0ae63e96fa9f4a67e475aeefa41f8f4f8420e677eda',310386000,NULL,NULL,'bf31cbeb8284aac77b6515ec7388d67e76e19ba79452b150a833c13c892c0ee8','913497785fcb4414f799bc802ef9e765775c860119092d1977ad201f70fd6d2c','14140f4fdf45df22e8f484223af4946885fca130fa0fa4327f89a76e6b0fb2fb');
INSERT INTO blocks VALUES(310387,'b4cac00f59c626206e193575b3ba9bfddd83bbfc374ebeb2838acd25e34a6c2b',310387000,NULL,NULL,'3f82211082a2d6981de51244bb0483eebfb3bcadfd48b80151fd1c89694e2b3b','615412429b5381826d54548f4034fcdf6482fdb7c9eac52d64de43b4bbf61e23','3271b37e9c66c01bddb2114bee641be40d5c6408683b973ab28a4d69b6e87a74');
INSERT INTO blocks VALUES(310388,'41a04637694ea47a57b76fb52d3e8cfe67ee28e3e8744218f652166abe833284',310388000,NULL,NULL,'59c3a3c5648f18274642df5050b117d8031f10c46be63b5864f30ecec69f0c09','741486afc7b71c294864850f8eff8d5595e10319543c1a8a571a14a48a34f8e1','04a410939ea20c68bca524b584eb85522449a494b50b72e926a1f73a6b481ba0');
INSERT INTO blocks VALUES(310389,'3ec95ae011161c6752f308d28bde892b2846e96a96de164e5f3394744d0aa607',310389000,NULL,NULL,'fbacb621beff1e0769d716ed51493afe97874941feb7787b5cc80916e3ed09ac','f4b53c2783711ee01ab7388fe74384b2e750fc590a90b9603a8ae33970b4bd2f','2b40b50c04bf179c6b5bd3056d2a7c96fa1f1e737bbef979fa72905dc3ad84cc');
INSERT INTO blocks VALUES(310390,'f05a916c6be28909fa19d176e0232f704d8108f73083dded5365d05b306ddf1a',310390000,NULL,NULL,'a2c398743a97092d8ea6875970fb1662470fb5918f09e50c132c29ee6fcc9b35','fad9cbc19f5a1f706c5d1040edacf8fff4092415e11076998b46c4a61d4d1c1f','31f9a628a1c3c8e62b54c8afa01e65e577c3a3426c0045e76c6fa53310ed8ee9');
INSERT INTO blocks VALUES(310391,'fc26112b7fdd8aaf333645607dabc9781eac067d4468d63bb46628623e122952',310391000,NULL,NULL,'cb3842fc91685c97b6db5ab71e1586259c83c619ecd57dd653a213b5c4a9f9a1','888028488108accd9656bdc1411c2974fe5a91d21b30e3c62577319e1e6b7193','0d5dd9a4e2a61449eab4802f81e285132db9856e00d469f3d0ae517330ffb716');
INSERT INTO blocks VALUES(310392,'f7022ecab2f2179c398580460f50c643b10d4b6869e5519db6ef5d5a27d84a1d',310392000,NULL,NULL,'780ea5e6adc1e9ae328efe2ea25af76ae2e228c98b475b6337ed84e5924e3b95','3d8c298b2c4865d8f4965112925bd186cb05476279a62f49dcd6e8cf1ddc6899','a2c8451b10e23017a945079c8461686029da4d7ef4ca94d221439a4bd6c146cb');
INSERT INTO blocks VALUES(310393,'e6aeef89ab079721e7eae02f7b197acfb37c2de587d35a5cf4dd1e3c54d68308',310393000,NULL,NULL,'6f61090175f1e398ae20dfcc41e5075327ccbd297c786c8a09a866a77836d429','4b6e372b5b57dd844d43ca6f2cbdd4c622f1748e766dccaebf54b1ad5cfdb152','450c72dd5a6eae81d770e4a35a7ffdad857f68395aa1be1b8af5ea2d339b17fe');
INSERT INTO blocks VALUES(310394,'2a944743c3beb3bf1b530bd6a210682a0a0e9b0e6a9ff938d9be856236779a6f',310394000,NULL,NULL,'8cdcec6732f3d4f2da04edc5a59cbe67fbb27ea069efdc23e4bc92f055fe4223','a971f2d6c2ee76613391f96123b7d69d53c9c0398496288b5844ae596360d836','fe24347c46978211878ff47de9e937fbf7a4952e100c318c760b7540fdbadde2');
INSERT INTO blocks VALUES(310395,'19eb891ce70b82db2f2745e1d60e0cf445363aaff4e96335f9014d92312d20e4',310395000,NULL,NULL,'291b2e82b5bf5ebee0ab534e53cc2a748429d7248ba1194a8f673552ff65cdea','9d0e1fb469eebc45b2f70a1469cabd2632c1804ca8a203e77fc5d07786972877','56426b668ba3ad72eec46f268ff6e3dd8d1793cdc29f9f585418c77337cfafae');
INSERT INTO blocks VALUES(310396,'aea407729ac8d8e9221efd9d70106d14df6aaf9f2f87dc6f490835a9caadf08e',310396000,NULL,NULL,'9698aa62d90bffb57f7b8b92e4275dd6df0b53d5e539dbe3440cc8f885881e65','111f95f76bba6f9bce5d2309de375b0f361a5563299cb0a99ff0b76c46949e4c','e6e2514719913d5faa03aef29cd8de036f72698635d21eef70573ef35dfd68dc');
INSERT INTO blocks VALUES(310397,'7c429e56a19e884a8a77a759b52334a4b79404081b976270114043ba94d7985c',310397000,NULL,NULL,'bcb427bbccd91cbce4402f5b9495d789a81e22fd80467f8023e33b98f487eda2','6a5eb3dc49929c1670891ad69cc7182626c72897987cd2bd1e4d01deaddb6d02','937f353580dbe9b1b8a7e52a2c0be3d6f3275548942c3a7512ba6af3b9d5d4df');
INSERT INTO blocks VALUES(310398,'55c046db86dee1d63c0e46e6df79b5b77dfd4ab2ff5da79e6360ce77dd98335e',310398000,NULL,NULL,'3833e3ac7b7b74948268b6588ecb6b6752ab22138e0d2f477e3dbef12adab776','b6340837585d1c35783c8618ac2a95fc019bb73b0fa1e36eb5df8f2abff88eee','c8b5dd5bcf807caf279cbcfb73033084ec43b418cd029f3e4b2fa86da396db4c');
INSERT INTO blocks VALUES(310399,'765abc449b3127d71ab971e0c2ae69c570284e0c5dacf4c3c07f2e4eca180e7a',310399000,NULL,NULL,'c15cf8452811e6df6f5438f8343f9a3421e75eb9aeed8e42eb0658e89c64dd51','73ebccb0634701914401ec95ad5418c1003588064d058602f6ec79ff796128e4','bb9a2480131f9ad189445fe64a610146e49ebc6422f49727ff303ea17060f9ab');
INSERT INTO blocks VALUES(310400,'925bc6f6f45fe2fb2d494e852aaf667d8623e5dae2e92fdffa80f15661f04218',310400000,NULL,NULL,'bd993e2a64b62f6c376e338e9beddaa0ac0501b39883506f2472e533bb19cbec','faf9220aff385c1f6640340f5c05d6940872fc9c258f3ba0fa90faf18a15cae8','8d2c0b4abcf73acfb9a20e1a33b6e79f680b5bd30120ccedfc0b932254a13b08');
INSERT INTO blocks VALUES(310401,'f7b9af2e2cd16c478eed4a34021f2009944dbc9b757bf8fe4fc03f9d900e0351',310401000,NULL,NULL,'e6dd67cdf805c23e353ec25468f2ea830da46e4104dbc537e9e15a5acc1b28fe','86cc6952c84e860cda1056e1fba945a8b868a43e15c8d95983d483c615925cbe','9016971581777647fb5d0750cb8be7c03782fcb8e789d42aa73c7a58872b61e7');
INSERT INTO blocks VALUES(310402,'1404f1826cd93e1861dd92ca3f3b05c65e8578b88626577a3cbad1e771b96e44',310402000,NULL,NULL,'6b19a39e68b8418c2eb1650bd1427438dfd65bf627bb6b50ae3a903c9169ff4f','d1b907c8368358b107a99c92c8a141774373d085fd14896680b226027ce73d10','0e82f47e5802302586fe3356f3fadbf8733a4624727a6627ca4e17e309724b79');
INSERT INTO blocks VALUES(310403,'f7426dbd4a0808148b5fc3eb66df4a8ad606c97888c175850f65099286c7581c',310403000,NULL,NULL,'bf22dd1b8b936a1eff32dea79c9cbffda251bc59ed2754f73c139155eeb2eae3','b744a91d6784f35d15dca4c821a8e0f2e9fbe68ab997e26e223eb9b29fe99f0e','77f72ebf75a046704a7b1a8e8a429fd604a9976869a752a93547aa8940d8c3bd');
INSERT INTO blocks VALUES(310404,'401c327424b39a6d908f1a2f2202208a7893a5bedc2b9aff8e7eda0b64040040',310404000,NULL,NULL,'2dff8ef48ea2026e72bb327368bff21d40eb321ef8c9ab5552c6b9f40dadcefe','e99eef081b3c25b64474b5d57cd2a3513184188d2d19a9c321dddabeb1bad098','9a268a2e017ea34fc1acf4bb1b69bdfb7bcb140678604e3cf7156d5309c3773c');
INSERT INTO blocks VALUES(310405,'4f6928561724e0f6aab2fc40719f591823ca7e57e42d1589a943f8c55400430a',310405000,NULL,NULL,'35b2f3fb27f707493d53ab0eb8eb239891be2a050a1f7ea9fffeacc1b6e6056c','6e98ec485f4720119dd51f7182cbd245ab078024854a43add647a21c12998469','8d1976a1626bd56b9bd84dd8934450f296cfc7d37d9bbe79af9d128ac3d758f8');
INSERT INTO blocks VALUES(310406,'6784365c24e32a1dd59043f89283c7f4ac8ceb3ef75310414ded9903a9967b97',310406000,NULL,NULL,'4a962a898f5795990de43cd3133a60b5b969ad366de6bca8d0b9fcb366759d1a','6a6f705febc71d655d5b000af7366bb91440e0c8a22394a447869370ee3f9479','698c7617ec3fcd5e443fcd58c8d944aef65d4287af0cecd499a58ff3d4c2237c');
INSERT INTO blocks VALUES(310407,'84396eb206e0ec366059d9e60aefdb381bca5082d58bffb3d2a7e7b6227fc01e',310407000,NULL,NULL,'18e8aad129099c20f268ef8a3664253f8d444a24e3c4942369bbeb80fb76c862','083e038efc87eefd1188c9347a133d178ded0531c772c2f48c5f648c08f45f51','195ca94e87c4069eed15c1c05d1b4b889065a99634cdf6d49f73e8aaaa89d88c');
INSERT INTO blocks VALUES(310408,'4827c178805e2abae5cb6625605623b3260622b364b7b6be455060deaaec2cda',310408000,NULL,NULL,'b694511530b99c6a6d405871f2fde7470baef8e0a2545b598adce5c3b9234765','c2d42accbc04edb51cc841e30d4beec90d284410531801bb5ad9a3cc730c64ee','34fa9e2865c94a264b4d2e4d3b877b62400c2ba22a4f508744a393c4ffe17053');
INSERT INTO blocks VALUES(310409,'01a719656ad1140e975b2bdc8eebb1e7395905fd814b30690ab0a7abd4f76bba',310409000,NULL,NULL,'cfc8dcee1ef668455b7c078698de8c164abcbfe7f6159fe206faeee7b0ec006a','6717547fe151c5c279444a4b31e595fbbcbe28c0af035646bf4f3eb466769c73','833c0615bd49c8a8843c314b91260e9971fc256a9042a2d7a863cf5d06dc8b24');
INSERT INTO blocks VALUES(310410,'247a0070ac1ab6a3bd3ec5e73f802d9fbdcfa7ee562eaeeb21193f487ec4d348',310410000,NULL,NULL,'52eeb77c0ba4767d59e4ba0e243032c44ae83abea1fb407c2079e58e869d6437','b980a0c212254bbf0d5430656dc2b1797318a964be71194edab48b0009b77afa','3042c36691ea1c46f2bf1967ec6d3d56da37c6b889f8bd3e6189d6a41e8522ba');
INSERT INTO blocks VALUES(310411,'26cae3289bb171773e9e876faa3e45f0ccc992380bb4d00c3a01d087ef537ae2',310411000,NULL,NULL,'10224812cf36a49d15040fb1a3ad3e580f4690e8309dda99713bade55f2299d4','3cc735d679fe7906ffb5e004f369e59b03284f4148fd767b7770a4b45d4bf05e','9117978ed1cb0d483d278df59fec68754501d8495312269d48e5472722f6c6c3');
INSERT INTO blocks VALUES(310412,'ab84ad5a3df5cfdce9f90b8d251eb6f68b55e6976a980de6de5bcda148b0cd20',310412000,NULL,NULL,'2e095263dab63461abb4210a78c96ba09181cdb55fe67113edf6badd5da8a386','b381801d878efbe7743e941bb292b91e3169d464046933187acde1bd03305281','5fe46084189431010be9f9ccf48a4cac29c5f42a1f3010572fc36520707534d9');
INSERT INTO blocks VALUES(310413,'21c33c9fd432343b549f0036c3620754565c3ad99f19f91f4e42344f10ec79bf',310413000,NULL,NULL,'5201dd7aaf4dd358441bbca3ec6785eb9f7bb36d25e9aca9e5cecf0e9391b7b3','d82eb68299d6e750d7b4ee725a2cc546c9975ccaba19e6bf1494c539f0179374','a980def5d6ae084687fa2d635733c51b89bbb84d5a06e01ce8ed559d6cf4c5ba');
INSERT INTO blocks VALUES(310414,'8cff03c07fd2a899c3bcf6ac93e05840e00de3133da14a413e9807304db854b6',310414000,NULL,NULL,'95de8fbba49b748c4fa28565b47230dd294ac6b02906d1dd7aeea73126db9513','d49408b5bdbf2dfc4df7dd62abe4190b6cc1f01ca4b282562595b9dcb0495bd9','9dd2af09aab331821d2b35532e7d0ffe96f94581ed1a28998e881c9ef10558b5');
INSERT INTO blocks VALUES(310415,'dd0facbd37cca09870f6054d95710d5d97528ed3d1faf2557914b61a1fc9c1cc',310415000,NULL,NULL,'53a7b4628a5273f5b893f64af2db6d66b5b9e4ffe5ae5076b274537245f53b6d','ca6e778e6361f385c51533dc7b16d386d56183c58a77d69a1c862c2d9534cf69','1683ddcd0e9fdf05b6d0b3f264298af82b416539a40f3f4a3b978f22a3858136');
INSERT INTO blocks VALUES(310416,'7302158055327843ded75203f7cf9320c8719b9d1a044207d2a97f09791a5b6b',310416000,NULL,NULL,'f38e62a046767b352776b03cc9103137061d2ebc1365a6589e8604affd29ea84','d67dc492b4e85dc3b02c825ffbe3ff1106bc3c9b85789096a7c8f8797b43d169','202635ac0e879bd264904745bc91e78ecd0b65e59f5f1e6e72c64afe68a28948');
INSERT INTO blocks VALUES(310417,'2fef6d72654cbd4ea08e0989c18c32f2fe22de70a4c2d863c1778086b0449002',310417000,NULL,NULL,'752734f6cb598502a13f567da58739e021aed45268f52c3a56aa94c77dbe4294','a5e525a2cf4ca4992ede73be444998db07fd796f06ab5787ba8d21df800d03fd','815f4190d8cb6adb1120aa3e625652231fc344439efb8c4d25d8ac2b4f29744f');
INSERT INTO blocks VALUES(310418,'fc27f87607fd57cb02ce54d83cec184cf7d196738f52a8eb9c91b1ea7d071509',310418000,NULL,NULL,'778a0c66fa9454d466fda8bf21ac02b03d80e18380cc79bff8b481d7832977af','b1d6661f7034fb1571ebfd0c6a28e923986888ff77f185609bd37abb494c6f0e','7e72ef531d362cc549f801d3a35bb18778a61b4a1df3c11f22c087bcb29a3fea');
INSERT INTO blocks VALUES(310419,'9df404f5ce813fe6eb0541203c108bc7a0a2bac341a69d607c6641c140e21c8e',310419000,NULL,NULL,'1dd204b4df4f865718b1cffb54a452885c04a524c4f9cd6be0e92bcc937f49db','f625d4413bce85c264b5bbf70a97b605d792267765e090bbea9aec505f0b61fc','947480de52ac030977c8a86bba3389e9841223f9b587bac1df8e2e3a30115dac');
INSERT INTO blocks VALUES(310420,'138b3f1773159c0dd265a2d32dd2141202d174c2e52a4aeac3588224a3558372',310420000,NULL,NULL,'3b77f802ef867f0fd92f1dfff4f7c5ad074ed51f0ed2b1a5d39f1f44e6aa7ae5','266c14c171e57adaa152531510f877c0fcdb12136d9be2514d60768c40b5e0ff','52da1ccfa2bb6634d01388c6f680adfc3d6be9e39f1015b9d8fc3b184d6e3c0a');
INSERT INTO blocks VALUES(310421,'71fe2b0e02c5cad8588636016483ddd97a4ef0737283b5fd4ab6ea5dc5c56b9a',310421000,NULL,NULL,'6d417941e380b66715edb4e74fb63026f35411ce7782afc0a6abd2f5d6193934','dfb44461cefdc61833c8d985d5f5b9e4e5138a5bb9e0ba6cc42e7ace8df7b938','f8aeda30d91d7897c52b4b3ee6e5fac7369a2cb3d4991e3952f5a1ac423711dd');
INSERT INTO blocks VALUES(310422,'cd40260541b9ed20abaac53b8f601d01cd972c34f28d91718854f1f3a4026158',310422000,NULL,NULL,'593383ba8869cf5afef0a8bd1212a9a87e69ed1f79d24423f3e268b22038d865','a58c1ccec1ee036c6ccff2d68fb68c3b7032c7a6987c348f5c325e4b856605c3','b891e2e1d5cfb4dd066081748f805dbb6d9f6957e463e3abde24156f5f337a34');
INSERT INTO blocks VALUES(310423,'6ca0d6d246108b2df3de62a4dd454ff940e1945f194ba72566089f98ad72f4db',310423000,NULL,NULL,'03ad9d534765ed15c02046dd7076f8d0f9332b987336f779a52ef7da5a63d2bc','7eb6457ae408cdb01b2f29f205f5eba791a38dfe97344df63d290f7b75a9acae','3e49356254c9dfdc9e7da4ab06d94f105e06c6a7f8bd39d70c3108ab696f3777');
INSERT INTO blocks VALUES(310424,'ed42fe6896e4ba9ded6ea352a1e7e02f3d786bfc9379780daba4e7aa049668ad',310424000,NULL,NULL,'028be1a76113906628e18a5ac0b00db7d8769e2450f145653c3b5f117cce2d1d','d972415076b9fd955a591ccfea1f4fb0fa674fada4acb8ff8f1003fffdcd2492','9171d3679f214fc5bba8d3d68613987bba70fc1b72396e49b5d6ccdc467b018d');
INSERT INTO blocks VALUES(310425,'73f4be91e41a2ccd1c4d836a5cea28aea906ac9ede7773d9cd51dff5936f1ba7',310425000,NULL,NULL,'83d4a7d8ffab3c5f6d2637ee98a2ed4bf9633f54a630a65c882190bab089bc2d','3dc020905f0ac1a591db79bf464ec5dc800387580611e2bb416b2522369f9df4','8fc9d8d2f7095cfecdef6a8706314f1bd6379d00aad2574adab60aa60df93771');
INSERT INTO blocks VALUES(310426,'9d28065325bb70b8e272f6bee3bc2cd5ea4ea4d36e293075096e204cb53dc415',310426000,NULL,NULL,'7642193a01f93b2511299f4a024138db83f9affa5e14145bd0a4ff0a12fe89b9','a8046eb6fe43bd8e89d271a43acc465d0f2ffd214398f4532f4584c248c98d74','548d4cb35e16abc81e012887149eb9554b05e3db3e069a07f2b349fb960c8139');
INSERT INTO blocks VALUES(310427,'d08e8bc7035bbf08ec91bf42839eccb3d7e489d68f85a0be426f95709a976a2a',310427000,NULL,NULL,'8e53bab070408894fa8b2b12a8628b2ae262567533f2a1c49dcb51e564d8baee','18b9dc981ac4c203a40fbc97c5ab738d72ee94b08e37684124732dafb3b3dee2','2a5aa69fa08216d9b3158c17eb906b42d0df24d7b5c651461ba3b1faa557da7a');
INSERT INTO blocks VALUES(310428,'2eef4e1784ee12bcb13628f2c0dc7c008db6aaf55930d5de09513425f55658a2',310428000,NULL,NULL,'f0af90a06b842c2d6646744b9c7e851e77cd73f27c1e97282aa3e774acb5206e','a3fa8eace1fa054545e1109be1567215c9d0fc4490fca25e4677b1d96ee6e05f','dd8f0c8fd4a38c430f01c370e13e90cf3760e3508d551207c25c14f811651721');
INSERT INTO blocks VALUES(310429,'086bfbba799c6d66a39d90a810b8dd6753f2904a48e2c01590845adda214cf8d',310429000,NULL,NULL,'d96b15c84b51ab0ac9e7250232ec744bfea32aaa46b3202182bb1ba30637530a','abeea2c4d5adbeabd124bf791fcd99d8cf7971c19f8668fa2c7393ab1704e35e','08177a974836868d1adc3341ff7997bc13915c61d34f42721cc737dcbba6819f');
INSERT INTO blocks VALUES(310430,'870cf1829f84d1f29c231190205fe2e961738240fc16477c7de24da037763048',310430000,NULL,NULL,'5877f31065e08853d538bb8ff2ab3204d2e7c46003afd715c7ab7e3eba36171e','4bfe6d6d4e7fa528cf0e2d2828856b30bf1e326bf73e5027663f37919e90fed4','82f59e8489adc54eee1622be9faf510bcc0332392eab7f8af77dbeedf1205f04');
INSERT INTO blocks VALUES(310431,'20b72324e40ffc43a49569b560d6245c679e638b9d20404fc1e3386992d63648',310431000,NULL,NULL,'c7693ebfe358dcb264ac98eb74f0d35b8102bc49a189d678c4aa83b792b92b01','f93f4a35fe5681ccb317d744406852319bf57f574c46ca88b481f881adb627fb','ed65c92b293f6086f98816614ca2e331ef3dbdf092e335623e7e70686dafe07e');
INSERT INTO blocks VALUES(310432,'c81811aca423aa2ccb3fd717b54a24a990611365c360667687dc723e9208ad93',310432000,NULL,NULL,'2e4118a5f40e5a2d4da07622568a61e52ecae05dacd3dd54364015666b9ddf0f','df2d9698319b110ce3ffe1ebce596ab1070bf0031923c0f15b574b2b2c03464e','2cce4d7f8783889b1622d75fb828509b01b709f8cab98d5fdc0192af5ac85da6');
INSERT INTO blocks VALUES(310433,'997e4a145d638ad3dcdb2865f8b8fd95242cbc4a4359407791f421f129b1d725',310433000,NULL,NULL,'4508c61899741ad3637f891664cd17e8d8dce2147ec22bbddd23d18be7d4f5d8','1225e6b5a8cf5c7ac1696ba1ffe23819e042f23fe8228078875d388921c98b16','10cf9c80e28d76679dd667f0733ce1431505bce52a6b3d7622cb3b3bcea7d6f7');
INSERT INTO blocks VALUES(310434,'61df9508e53a7fe477f063e0ff7e86fbb0aef80ff2ddedc556236a38f49ac4d8',310434000,NULL,NULL,'222a7017a5159405dfa7ca716a368f84df446612b2e969ec775a56297f67c445','5713ac117690e665b048447797d817e6f9555e2414a5a71c67f73bc5a5e1986b','01b6f653d0ed44b82d17081dc8104c7241a4395a640ff5dcee62b183554aa834');
INSERT INTO blocks VALUES(310435,'f24cf5e1296952a47556ac80a455a2c45da5c0dc2b388b51d235a3f741793d5f',310435000,NULL,NULL,'cf0f27b94a70b0dba7ee5391c51df323c154c767b21e7f18696cfb93e25e663e','59125c3bc693fd9a88f591c5112d72c14aa6b2cef4a73ef23d3b8e3774a1faf6','687b4bba32492b7a952e73f513053f1c4ccdeb4b31378b1ffb2867816b8a76ac');
INSERT INTO blocks VALUES(310436,'a5e341ba92bdf9b3938691cd3aab87731eba5428bb61a804cecf9178c8da0c19',310436000,NULL,NULL,'15455076d1eb6681233124bd7f4fd59586a22067bb008d8132e31c0019f3990d','fc3d5fb3ee06b7cc0c7d45742e4eb5d33b6c029870ec51c398983098b3a6ff4e','c4437b463aca5727a120c0331f126ba5d984241bf65b0476caa564f738d06524');
INSERT INTO blocks VALUES(310437,'9e18d0ffff2cb464c664cefc76e32d35752c9e639045542a73746f5ec2f3b002',310437000,NULL,NULL,'03e6c21526a9e7ad688f8ee47638b2519b2a1ff0c47332da366a1077a9d93dae','2c07246086d50d284c65531cd449e0ba1ff1d13a7fd778a07f05527d1e7a176b','d868b639a9005c3978379371966d3a0bc8f732618d444e2fc5286ae8731732a6');
INSERT INTO blocks VALUES(310438,'36be4b3470275ff5e23ed4be8f380d6e034eb827ebe9143218d6e4689ea5a9fc',310438000,NULL,NULL,'dca613e290eaea92a4bde4f759fca67923568f0af3ece38c4165fe66787f5a61','847496ee04c8dd5fd83fb6404e3af7a70edbb34042b7ecf66fc6f2d4f6d046f3','4e2b490b7772f67ccd3cb549666b2e3d261045b8cff6c8e11f27f26dd2ea94fb');
INSERT INTO blocks VALUES(310439,'4f2449fce22be0edb4d2aefac6f35ce5a47b871623d07c2a8c166363112b2877',310439000,NULL,NULL,'9da932c8c4c9a12d536db15649b8b89df52be294f3a3b16692618d2af421c1b7','5b1289b41db5b3ccb309f6bf5c0d5f1f2cdb492500456256215e9a0c60efc9e4','d2471b25674f3f51e007c57c8357c0ed3ed76dba616f0230ee412fdc57c5b56b');
INSERT INTO blocks VALUES(310440,'89d6bd4cdac1cae08c704490406c41fbc5e1efa6c2d7f161e9175149175ef12a',310440000,NULL,NULL,'ac9f1ff2a3adffd79ea3b2b13289ea060d2fa1ed9656a61057d1802531737221','96e368792cf7a5d7b04a9fb3a893d55bf899208c7490780343279e4ea7a4c1d8','59ad2f1e167ef3d514c12e21f38e87856635fcac0f622841b25b312c02e8bf0e');
INSERT INTO blocks VALUES(310441,'2df1dc53d6481a1ce3a6fee51ad4adcce95f702606fee7c43feda4965cf9ee15',310441000,NULL,NULL,'4513dbf40e2b572ccfdb857eb58d4008b82959d110c094961cc7587ca9672316','8dd995c43131ab65e61007e630898fc757f8a3b985f3343f1c5006fb4a5fc7a0','d725f48665f552a3f8f965564123637cfef872f790abeead359001458ee59401');
INSERT INTO blocks VALUES(310442,'50844c48722edb7681c5d0095c524113415106691e71db34acc44dbc6462bfec',310442000,NULL,NULL,'e806ef15930bf2104b63bde714b397312052322dd034f0df727b738e05e1c753','c76eee0afdf474fec9a2af87d8d84584b2fb6a1193509bd401849f2f24af1ac5','db191c9ab614235057ac27b0443e97ac434c283c488ed89a05959b0adf680b1c');
INSERT INTO blocks VALUES(310443,'edc940455632270b7deda409a3489b19b147be89c4d8f434c284e326b749c79a',310443000,NULL,NULL,'3f6cf11776817de3eeece3f754656bba718ed2d9fd52034f8c49b27ab12bae8a','e475c37a7d91ee573ec5c176277c167752233d7f259bd0203be6dc27d64c91c1','6a6f1f2748a313434264e158959c6cef1ad81e19ddc0f9e742a6cf199baf475f');
INSERT INTO blocks VALUES(310444,'68c9efab28e78e0ef8d316239612f918408ce66be09e8c03428049a6ee3d32e4',310444000,NULL,NULL,'da23b14ec6cc706fbeec8e796522dab412bc72b96833ebe9eb799e72623129b0','946fab18b5301eed284e1f981e7ce2475c6a083953d8b3decbb781b5f77a4e61','a63fd0faace02df5bd072e119b05108e35c0cc5d3f115769186eaa88d8717ea4');
INSERT INTO blocks VALUES(310445,'22a2e3896f1c56aefb2d27032a234ea38d93edf2b6331e72e7b4e3952f0234ef',310445000,NULL,NULL,'50e9c4330e9f1fc6c563bf924064999f3e8feee2fe107884a95c913df2008da4','8049c748abaa64c5b34db50f0692ac4ba8f3d6c60f1c0f956e31a96b7923b89e','2ec274eba333a228afe631ec78abb35f8810208cc590db15b0b9a731abac2bcd');
INSERT INTO blocks VALUES(310446,'e8b0856eff3efce5f5114d6378a4e5c9e69e972825bc55cc00c26954cd1c8837',310446000,NULL,NULL,'1b6f3d210ff3f0b1c0342419467a17c0d34ea1eea4e99ecb5ddf5e280818a983','a282aef5b39d6544d3acac71d28ace9359de4955c693b1ede51634e56c1ec427','c6d9b49fa2beb404d7060e8429c52bd622b81b64e423fa66f6d374935d064e7e');
INSERT INTO blocks VALUES(310447,'3f4bc894c0bc04ee24ed1e34849af9f719f55df50c8bc36dc059ec5fa0e1c8a8',310447000,NULL,NULL,'d5d10b1d7843d4070508a79192c7b1bb92876e64acef659c01ffce3c5ba5cfc5','561c32827e872ef9ab1cc795f4f0da6a89b8df0fcf3d77dd253f575cd0e0786f','1d784a088fb6f650c63e0559869f10c5e41617ccc55d137521aa0057d448358f');
INSERT INTO blocks VALUES(310448,'6a6c7c07ba5b579abd81a7e888bd36fc0e02a2bcfb69dbfa061b1b64bfa1bd10',310448000,NULL,NULL,'488c8a4a6aa3850d0ea6c0f12ecf4cc9bf400aae8c4b5e4cc5589152abe5a90b','38bcc43524f8548eee128acc9f6aa3e301af510c258320e20cd72fc0bf2a7dc5','b313711b4a98c876ddca906433b41d970b1c412cbfce72b6e337e03a6da3d46d');
INSERT INTO blocks VALUES(310449,'9e256a436ff8dae9ff77ed4cac4c3bfbbf026681548265a1b62c771d9d8e0779',310449000,NULL,NULL,'5f8b738744da401e84d1174587d7e2900278621f3497adb94115167218e3d68f','901012422883e971b3990b747e9746ac1bdbb3c8b6bd34345caffdcfb9eb64ad','b02277120ef3643e76bc01f01e1aa6f39a2f659557c47184ff1f70d0a7a5234e');
INSERT INTO blocks VALUES(310450,'2d9b2ccc3ad3a32910295d7f7f0d0e671b074494adc373fc49aa874d575e36a3',310450000,NULL,NULL,'185dba1b235227514d6ba11bd279b9fb05607714831edbc854c3dad8d17ee11c','c9f46894c58e2c27489e0c474aabc932c794585f1d954c9dc20b8474824f113d','1a6030b54e85d4781e50aea0b004310daf89b16095af92ad576a455aa864f2a9');
INSERT INTO blocks VALUES(310451,'55731a82b9b28b1aa82445a9e351c9df3a58420f1c2f6b1c9db1874483277296',310451000,NULL,NULL,'605cbe563d57fd6cc0d05d40e6217703ef899c9e61bdef381cf996403a782808','515db194b1dd442728bc8a9993ccc0964a65e5bcfb3a723911f1f1195f82e310','be187aed643bd583173729d38872cc2efcf501b595e7440e28caed921af39497');
INSERT INTO blocks VALUES(310452,'016abbaa1163348d8b6bc497cc487880d469f9300374a72ecb793a03d64572aa',310452000,NULL,NULL,'c3ccf7d83bde4f7b5777c902b809841ae0c4c2db098bcabdd1aff128ffc6fd5a','1bc6ada6cb02df4e773c4dd939f26ff90ac8a7d6c9223f267fa746cdb564e192','0813100be5893a9ec5eb1cac1bb37a01638fac73f1259d1de9378f67ae673be3');
INSERT INTO blocks VALUES(310453,'610be2f49623d3fe8c86eacf3620347ed1dc53194bf01e77393b83541ba5d776',310453000,NULL,NULL,'3dac0390da1c50e05051eaa60ad2aacb0112adc54e0f0041a00db0a519333ebb','c4e315fecccc44a220035461f8a773b0263515a41ecf1b1198e2f261abaaf716','b466c7e6b7dc02a315d90178b66f3ebd9c5912941046f588cc25885b4689f016');
INSERT INTO blocks VALUES(310454,'baea6ad71f16d05b37bb30ca881c73bc48fd931f4bf3ac908a28d7681e976ee9',310454000,NULL,NULL,'8fea87fc079398499692f207ae111d25a034576c0f2407383a20bf73ffe66d06','fd25f42d05ac1586626c919eb085eb716b5b5ca1305e0773cadf8ff6ba58456a','a1d212c6cee3999e6a9b05166a697d774137d66e439e4fafa73606ccf735a44e');
INSERT INTO blocks VALUES(310455,'31a375541362b0037245816d50628b0428a28255ff6eddd3dd92ef0262a0a744',310455000,NULL,NULL,'ce885b73d40cb2ddb6ec6474bd94ab4470515679f54fb47fc5bca7a87d1ca261','35cd7ea3c7a65ae60823cf23a54db5c6fe8c0e5df6980bf1ede64104e78be53e','e97c20992b56941d137f744205771736b6b9ad5d3edb323883e675ee4d4b33b8');
INSERT INTO blocks VALUES(310456,'5fee45c5019669a46a049142c0c4b6cf382e06127211e822f5f6f7320b6b50fa',310456000,NULL,NULL,'16693fd96eb42e01b5ccac8c4978a882a50ff534c33ef92d9eab923988be8093','fbd17fa3bc8c8e163c504b9a09bc6eaad76a601e8fcceadcc68e4ba046d8383a','af256fceef7805e1d428cefeb64a67a089ee418d92088e4780b63cbf6bccf956');
INSERT INTO blocks VALUES(310457,'9ce5a2673739be824552754ce60fd5098cf954729bb18be1078395f0c437cce9',310457000,NULL,NULL,'81c06ed2e28e3eb67497d2508ec8399558d4be177fdefc525b7cf8010546da82','9ede6fc4f64ae869eaeb5ab731a468efa85fc6574677e2e8d6647cead25b677e','f5ac8bd583d706a20c8d5e6f87373b86636206c8cbf21360a0420e697c47b46e');
INSERT INTO blocks VALUES(310458,'deca40ba154ebc8c6268668b69a447e35ad292db4504d196e8a91abdc5312aac',310458000,NULL,NULL,'bb906ce3def50a1573ded94e2ee8cd278375318479682145a72a3b9cd67f18ec','0d68a3fd95fb4f3860d29845056f63267c293e1d9d3ebae4e970bcb7a65f7c46','e6ddd58a822332648fde475df636a4971c2ed839f19bd5cfd2bc56156174dfee');
INSERT INTO blocks VALUES(310459,'839c15fa5eea10c91851e160a73a6a8ee273a31ab5385fe5bd71920cbc08b565',310459000,NULL,NULL,'874afd2de9bfa523ab45482e1d2ff2a9136af0bd5ade66d7943564c504ef944f','533368e8dfce39bc1fee8dd9dfdf35baa75ec9172d5d247d1e4f5774dcd83b04','2bd38226f2560434450b4da10d6d28a0b3821d11d8188015f859e62eca6c00f0');
INSERT INTO blocks VALUES(310460,'9b5f351a5c85aaaa737b6a55f20ebf04cafdf36013cdee73c4aaac376ad4562b',310460000,NULL,NULL,'890e72732c1d57443213ee7a7270b3e2a7e9087522f57189ac61cd6dc852abfa','dd1107f1c20032d979ce9bce46315777d8c8998ef8e47c9b572a77fdce8eb14d','66fea6059977fc812c03d8bcf16f121c517a44b6f29fd48e31e210fa808b41cd');
INSERT INTO blocks VALUES(310461,'8131c823f11c22066362517f8c80d93bfc4c3b0a12890bdd51a0e5a043d26b7b',310461000,NULL,NULL,'8627256f470d906d5c784ba257f4f7d29e0d81347c7566727aaa26afd0a9b251','635f4a5dafdcdc1d550f40ef9bf6ae94703316fa18d7d6c6dd97514ab22c968e','60fca06261c39a2aa1dc48241c5df366b34dd0fe2ea7bd9d6a22d06a7c3b103c');
INSERT INTO blocks VALUES(310462,'16f8fad8c21560b9d7f88c3b22293192c24f5264c964d2de303a0c742c27d146',310462000,NULL,NULL,'d1829d2db4718331aea74e59d3fcedc3f510aaab82f3f7f956087b32c040f63d','064892ddd5946e50828a80120e7356cad5c818a5cb01c60041a34cb544de636b','f4419ef31812b94d1c142d206d1f77535e16c7a38caa6602a4f31b41399f4f60');
INSERT INTO blocks VALUES(310463,'bf919937d8d1b5d5f421b9f59e5893ecb9e77861c6ab6ffe6d2722f52483bd94',310463000,NULL,NULL,'8b83bf9e263c69e8f731d90c9e6f92b66dd1652ea76390ceec58883f3ffe881e','5827cd4f59ed067bd220eb6cca6fdef04690be82a23d1910453f0892fd7459f0','baa0543c1bee234d7ad8b10cf23538e36b4f121091d18a0020f4fe0e839ffaf5');
INSERT INTO blocks VALUES(310464,'91f08dec994751a6057753945249e9c11964b98b654704e585d9239462bc6f60',310464000,NULL,NULL,'a93fbb5f298b41d3123312fe41ed8c5811410c32ac31062ff513c69a6ada8e53','c1d623253a9d5c5cc18a93e5f30fbb9288a0818fb0f3a30024e86c37a1572c36','debe91ddf339508e42ea03a0f9ac70927901d5f3803fb8b96b71a0d794c1611f');
INSERT INTO blocks VALUES(310465,'5686aaff2718a688b9a69411e237912869699f756c3eb7bf7c3cf2b9e3756b3d',310465000,NULL,NULL,'19ea9e27f997fcaa3c260bed12a628b55054b6f90d579ff3e41ab1cb29240778','0c33da18dbd901be1c766c3e2885f569697cf8cf8bd1d4512a1b3cf666e9c214','f971c17bdfbbe545fc16fb4ad827805fc0023242e495bf72a7bec3571a2574e0');
INSERT INTO blocks VALUES(310466,'8a68637850c014116da671bb544fb5deddda7682223055a58bdcf7b2e79501fc',310466000,NULL,NULL,'90c850f7cfe700fdea8d8d60fa03f080861414ec372a7d920ca6d09217f82fda','a440a77b4f177241e6b13290bf84eeaf99d7e6dafe0abb76ef1c15dfcca9318b','9f334e1e3932bd03f8926320591bb68f0eb9bbf6aec3ebd704da1b5fe2d6b4e7');
INSERT INTO blocks VALUES(310467,'d455a803e714bb6bd9e582edc34e624e7e3d80ee6c7b42f7207d763fff5c2bd3',310467000,NULL,NULL,'9f92428bfddcff24329af3b4c0b3200e8b4ae3065f9b6a8a6488e159abfe6854','637e5416401ee4058bdcfe146d4441688b90a26f4b8dc08c5e24e0ec34321864','bc7e4500cb71aab43d074b2b5b64e8bbb39c86d27449c26f24121fd9872b732b');
INSERT INTO blocks VALUES(310468,'d84dfd2fcf6d8005aeeac01e03b287af788c81955612375510e37a4ab5766891',310468000,NULL,NULL,'0cf6101033a96e6a90572ab21502314470c4b544bf21a902845861c413e1775f','9927b75cc4f1ef5101702b6d292e1027953ed948b25ee55f89582e8e03b84602','f6fcbd208058ee289e70c024575eda8b244774b21ff3e1193a7fc43e821d01d2');
INSERT INTO blocks VALUES(310469,'2fbbf2724f537d539b675acb6a479e530c7aac5f93b4045f4356ea4b0f8a8755',310469000,NULL,NULL,'93f157cc43a6dc2df588c7cbddca37e55eddf5a94fcac82ebeec2d8d252a515f','b8937a3d2e44c961dcbc3b0a427fbf1c5a15d4f9d7068651bb2f1755f981f519','550406a87efcb706ce823da327b3361d7c905f66789b0abb0084fac2fea996c1');
INSERT INTO blocks VALUES(310470,'ebb7c8e3fbe0b123a456d753b85b8c123ca3b315da14a00379ebd34784b28921',310470000,NULL,NULL,'d6ebcad8b1743d6dd898a522304594242eb063893c1d07baa893c076f6ccdc3e','9f8c852637a860261c2ff8eb4bed49c63bb8e7f8b6e97f7fe128fc673111161a','ef7620042ece1a24c3c5ecf84b9f35ad181b363e895fe2b9fd92ad100e18e0a4');
INSERT INTO blocks VALUES(310471,'fc6f8162c55ecffeaabb09f70f071fd0cb7a9ef1bccaafaf27fe9a936defb739',310471000,NULL,NULL,'e6003555728c70ecd67dc8de1248de291a2d3a5d9fed35d77fd0888b5c7a1997','e947f484168befdd5fe0891aaa4b6874631a29bfa2ad6083b98359beab2bdc12','182b018b1e7a68d9294b196096a70e5decd9ff48d882f3c254d829d4613eac96');
INSERT INTO blocks VALUES(310472,'57ee5dec5e95b3d9c65a21c407294a32ed538658a6910b16124f18020f16bdf7',310472000,NULL,NULL,'dd553bc627b16f15cd618dd0504cd0ec04724610ff6ed44515957c997385c826','ed3f6b799c71d1128fad12063bedc6fa16419156e7cbaca76d1c6914b934fc65','823628ccb15453ea0134061e06fed36296d218777c05a9cf71884e2dd5fcd506');
INSERT INTO blocks VALUES(310473,'33994c8f6d06134f886b47e14cb4b5af8fc0fd66e6bd60b3a71986622483e095',310473000,NULL,NULL,'9290c164b0b011d53eb80193285fcfd830e524183cce1be181a48f085601845e','0c6712342298b4cbf7b60c5080afddc0fd72c66bee4c76c738b012036820b580','091c4e65bbe28a700863502372facceab2cb9e7ecb5ac7f98d4057fcbf4c712f');
INSERT INTO blocks VALUES(310474,'312ee99e9526e9c240d76e3c3d1fe4c0a21f58156a15f2789605b3e7f7794a09',310474000,NULL,NULL,'7aba0609948218e622e3293760bfddaa1ac4669eeaac6ec897aef5ab1268774f','9e30ca697713a46724351293078ec27c043b3226f29429948c17f9bd71694ca1','3b1bcfc428beea701e160d531a9e57657112ca9e952df2570d7b8657d8211158');
INSERT INTO blocks VALUES(310475,'bb9289bcd79075962117aef1161b333dbc403efebd593d93fc315146a2f040eb',310475000,NULL,NULL,'bf95d8500066d276cc48546cc2c29398e26511097cc658b21d6a537c2d8876d7','6e7604b2599f77b197598300191a4a64eec546f4d65c7bcb08cee8cee00b8c1f','2dee1e621194106cab549ea8c9b2af9dd0d53df92e7b8858e04f450815a5c9b9');
INSERT INTO blocks VALUES(310476,'3712e1ebd195749e0dc92f32f7f451dd76f499bf16d709462309ce358a9370d0',310476000,NULL,NULL,'89d6256d5a7f5412a5eeb9b5551860b7ea26b096a2b8196b61d437ba7ee797f6','dfdf47b9acc73df5a9e402927855de77d5e5e3b6b2fcfb538603c1654af14606','38e3a944ceca60ee979483835a1651aae5599c6b15d9a2de82ef39cc5acf8b03');
INSERT INTO blocks VALUES(310477,'7381973c554ac2bbdc849e8ea8c4a0ecbb46e7967d322446d0d83c3f9deab918',310477000,NULL,NULL,'31e4ee682d84213876eb8d85cb92d32688c4dd9110a9a90d74cfa275b50b8bec','054886ab3ae15e2c679b74eaceda86feac58c67c8d3c6c691e0385861247e081','858a8841e4acc702cab19341fb97952b416ce15213b18766430c62439375ac50');
INSERT INTO blocks VALUES(310478,'c09ee871af7f2a611d43e6130aed171e301c23c5d1a29d183d40bf15898b4fa0',310478000,NULL,NULL,'941bcbb6d7a89a86859fdc1516c0e64a1473b356f42846d2e8a353b08967fd46','59200e8e0d41f4a80191a8f02d7a4cc863c341158f173a27e932f9665f9fd3d1','7ddef5c93710532b8e1fcb8848d28cd29b13630df2c531a23bebd24fac71ce68');
INSERT INTO blocks VALUES(310479,'f3d691ce35f62df56d142160b6e2cdcba19d4995c01f802da6ce30bfe8d30030',310479000,NULL,NULL,'8c271f55a292b69f95c50228be57e8a1a91b94998756abd8ce431e657fa4055c','3460731bb53c35c3291dd9c4ffa0a3b5d4e5559c78f799add20c8427d354a4c8','a3a1980e2882a3838a3e2982f25265d8745ac3e5262d3810b8c6a8e3ef5df71b');
INSERT INTO blocks VALUES(310480,'2694e89a62b3abd03a38dfd318c05eb5871f1be00a6e1bf06826fd54d142e681',310480000,NULL,NULL,'aa0c833f96cce186008d339452e92d054edd67397c538baac239b10df8f9bcbb','f05c7b21301ba03f9b9da4e25a53cf1060f28644ced4287f2d87f725229bb51b','a2c13bceb0c2acb44c682d959b41951791fa2002585ef2256041986ac84fbf34');
INSERT INTO blocks VALUES(310481,'db37d8f98630ebc61767736ae2c523e4e930095bf54259c01de4d36fd60b6f4a',310481000,NULL,NULL,'596ff1cd4069e7a0d62db64acfe1502ca4bfc6d3ac792794ad980c5f654f1a01','3ddd647114b96f74193bb2764c4f74a881d12424f3cd2f6fc3bce0cc5642636c','65e453b470a2541b400a81c3cdbe0b91cf20a79d8aec54d87786d0caab5bbd0c');
INSERT INTO blocks VALUES(310482,'2e27db87dfb6439c006637734e876cc662d1ca74c717756f90f0e535df0787d6',310482000,NULL,NULL,'bbc1ac936d3ea0f0ab911d79ec003e0ce0c20d6adf507dc5c94a773659b0b734','ffce57c06c0ab6e3e7d35df258de1a27b196dca0d9164bdda4d6f954e7f1c84a','a64b6000d4941bdb57ce344499a5351c17e5020682698dbb4313d499a9c54ba5');
INSERT INTO blocks VALUES(310483,'013bac61f8e33c8d8d0f60f5e6a4ec3de9b16696703dea9802f64a258601c460',310483000,NULL,NULL,'008c287f38d96307ee4a71ea6a8f2c42a35dd54c4a834515d7a44ced43204845','8f8bb7edee86523ae67e0bf153527bc641aa8481cff97a0f864660c515ac56f4','dfd170bbc87a7660bfb8fdac8786e05b01635f708712238ada56de92dd846ffd');
INSERT INTO blocks VALUES(310484,'7cac2b3630c31b592fa0497792bed58d3c41120c009471c348b16b5578b3aa2b',310484000,NULL,NULL,'d7f3ec5feb14b12b410fa72344620e930037d15cdb36295fc68aa0f4087eb631','d94f30d87b173d57ee08ce1702ef0600ca7718202ab5ee7a621a6abbe167e623','2001eae71414e3dfdc4c1d8b66893d3203da54511e4ddc9bf3a390b548bbec38');
INSERT INTO blocks VALUES(310485,'eab5febc9668cd438178496417b22da5f77ceaed5bb6e01fc0f04bef1f5b4478',310485000,NULL,NULL,'10856cb1b7625aa217ea3009f10aa1e772a627e302f4191eaba5d332b8daea32','41babdd44f0fe44d706e5a0d303700a7c617931b1dcc94aab2b1cc34e7f56a25','d7cc8d26b31251f1065061d74cd0726e97cbfe2dda75436cf51772144a2f449d');
INSERT INTO blocks VALUES(310486,'d4fbe610cc60987f2d1d35c7d8ad3ce32156ee5fe36ef8cc4f08b46836388862',310486000,NULL,NULL,'d4d08e6c5c0a9d491cd2c754047a78a566a86a0b4ef81c3037a9d438803a0fb6','e44d058914d606479038e22f4ea3dcdfc49f1656d9479284e2c72d55bbc6675a','247f1b7a4dc1f138870c5952d013cc12c401c352c6f7c51318786e408b28cc56');
INSERT INTO blocks VALUES(310487,'32aa1b132d0643350bbb62dbd5f38ae0c270d8f491a2012c83b99158d58e464f',310487000,NULL,NULL,'bca482be2e942516ffc60a62ea7ea7e44158e8f9b72bb6e5dbe61cd740d300bf','690d07e7ae0525eab4effa4d5f17f861cc128b25a6b07c5703a4fac02347e291','230641bcd85c304e0fef982fb9b48290cc51d1f58ce9746c42c1a1e5d34a325d');
INSERT INTO blocks VALUES(310488,'80b8dd5d7ce2e4886e6721095b892a39fb699980fe2bc1c17e747f822f4c4b1b',310488000,NULL,NULL,'fd124a3f80b354ca106cd653717837f460b565aa5b4b40dc23ecd56b3b97b28b','3c99dddb74f6f6a5ce625965363f42380b547ed085a42f210f6369d8c7263004','710fe98a34bacc9235d69d50954b5f91c64c560953732914c82ca13a2e856976');
INSERT INTO blocks VALUES(310489,'2efdb36f986b3e3ccc6cc9b0c1c3cdcb07429fb43cbc0cc3b6c87d1b33f258b6',310489000,NULL,NULL,'dc544e57a124565269bbb4b2d9ae2102e6ed177196b07e02d55a9ac99611b752','a96e46526c18014f54f302003b77ebaa57b48d03154179e5be8dce2a14fb6bbf','03e3ccecb22cbfa4e492f96cd8e42ae6f0fca29ef528f96c1974da7e4f9af9af');
INSERT INTO blocks VALUES(310490,'e2cb04b8a7368c95359c9d5ff33e64209200fb606de0d64b7c0f67bb1cb8d87c',310490000,NULL,NULL,'8165de494fbcaee2f48f0ed7b671d5a7164b4e4e6198b5e1cd8f88850af150d7','998fb5b68618f43443b66b2d0e7f12a3b9a04af6d254e68aae6ee38e840b2fc9','ef4dabb2916616aa4e97a3b44670c095291bf0b876d254ee2adf088d4cec630d');
INSERT INTO blocks VALUES(310491,'811abd7cf2b768cfdaa84ab44c63f4463c96a368ead52125bf149cf0c7447b16',310491000,NULL,NULL,'953105bd7e2e93c74ed3ed8b8717d7238d636a0cc4e50d152a1783aa5f320204','0c799c6b01926c002cfc5039f28c71463461e9a32d2d2f96f537bae6e925bbcd','780c52a2964193cde116fa0aae5db65bdd99f50a82d44223dc598984c547da2c');
INSERT INTO blocks VALUES(310492,'8a09b2faf0a7ad67eb4ab5c948b9769fc87eb2ec5e16108f2cde8bd9e6cf7607',310492000,NULL,NULL,'1fed308916a5912e8b0166d5a27ce74e23ddddcfd3f7b99ed77a01ff398142e1','d508c795314275a44e604f7dca8b4ffd5a55a6bfb9c1d4d47e86deba88bdee63','852b42ac376e2ade050305ce0ff5a2f37c174475b4d6bcf6ce905586cffcb77b');
INSERT INTO blocks VALUES(310493,'c19e2915b750279b2be4b52e57e5ce29f63dffb4e14d9aad30c9e820affc0cbf',310493000,NULL,NULL,'c0136baee1305a5e5a933fa78f2f93cb40d06adf04540c94dab3c085208e1d25','503bc43f26c6e70326a2b76e26994b0bc8547f2ea1aab4a561ea42c0cfa5db60','5f812fb0a7e37fd1f6e74c1aef22a6ab5c1bfbe483922e9578710e7c9bb151b1');
INSERT INTO blocks VALUES(310494,'7dda1d3e12785313d5651ee5314d0aecf17588196f9150b10c55695dbaebee5d',310494000,NULL,NULL,'7e6e5551f8eaa241d3289fcae360170937aa4a35f2926611ab50793b7cbf1b30','460c89d5eb772813b54a59d3dd43fef158a7794620130c06ad5cbfe2191f9c9a','05745343382bd516ea18c8065d979d95a00dfb914dadd2ef7cbd426d8e170604');
INSERT INTO blocks VALUES(310495,'4769aa7030f28a05a137a85ef4ee0c1765c37013773212b93ec90f1227168b67',310495000,NULL,NULL,'0b40890a253248a31cf00d2f75abcbc9871318364ec224ce94cd5c6d29b15621','8c474762b1402a9f7f29e76cab86c276ec68f0a1b9be4791300ff7dcd7b8a0b4','172e86c4850a311ff5b9eb02b50ae12adc71ef207738ae532686afaeb0e95a33');
INSERT INTO blocks VALUES(310496,'65884816927e8c566655e85c07bc2bc2c7ee26e625742f219939d43238fb31f8',310496000,NULL,NULL,'88aaf1b7f8cce768bb3744e68017b52fa82999dc6ababf7c0cab9621f9ab4160','45004f7db9d033739816338fc993a461a7ac32855c3a89ba6f2ed2e805a529e1','a6a4faa396beb4c78bcd90890d6760ea922e4771040f85e6a0af6e5a24f8f3ca');
INSERT INTO blocks VALUES(310497,'f1118591fe79b8bf52ccf0c5de9826bfd266b1fdc24b44676cf22bbcc76d464e',310497000,NULL,NULL,'416fde25c97124281ff88eff164a6ef67b5a32563c2481b5c44654c3e4662873','95a3cc4878874f93ffe0ebf8dee2d6c40ac96d4a464050df88958d2c44970a86','f0232804550799974b0e03dbea528b09140129831d0ad8c1a411dd682992b4ca');
INSERT INTO blocks VALUES(310498,'b7058b6d1ddc325a10bf33144937e06ce6025215b416518ae120da9440ae279e',310498000,NULL,NULL,'3d2840702d2c9ffe48974e565744e41a549c9a821857b39be3d6257517a96bc9','1a6b76f09800cdbc7ff9ff74d7e43cb38679c5f2f5614d70e1cead7f07d16073','ac202ab45c7c951649cf2d39c8b7496ae3b4d671772bea4202a1b44d38cd6318');
INSERT INTO blocks VALUES(310499,'1950e1a4d7fc820ed9603f6df6819c3c953c277c726340dec2a4253e261a1764',310499000,NULL,NULL,'a1394288c9651278a44d87a348d74e999645e8f7f2d4335df845dff30e11701b','cde85f6ba7597ee623e158378d9fe085d4d54aa0eb7007de73ae3adce7da7d33','c4ec175842776d34b4c11e974f7e087414b9e8b6a32d61d62a88b48d282e8549');
INSERT INTO blocks VALUES(310500,'54aeaf47d5387964e2d51617bf3af50520a0449410e0d096cf8c2aa9dad5550b',310500000,NULL,NULL,'19ec7324adaeaa81dd4f160040bebf7b9395458cb50e06a416f24229cb956245','1898026280da53b6dee5fc3de564995e8df23dcfe3951a2df45fca953901cf75','2de5d2f06a5c178c654547cdb1fb0b7de90b4d28f7899da252a80f15596d594b');
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
INSERT INTO broadcasts VALUES(112,'76161d0bf7f94e5291e45c4faba4da1efd01cd91c6513cdbf5fa9fd10184eea5',310111,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM',1388000000,-3.0,0,'INITVOTE TESTSCENARIOPOLL XCP 1000 OPTS TRUE FALSE',0,'valid');
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
INSERT INTO credits VALUES(310102,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','XCP',9,'bet settled','18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e');
INSERT INTO credits VALUES(310102,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',9,'bet settled','18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e');
INSERT INTO credits VALUES(310102,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','XCP',0,'feed fee','18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e');
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
INSERT INTO messages VALUES(55,310101,'insert','debits','{"action": "bet", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "XCP", "block_index": 310101, "event": "ba0ef1dfbbc87df94e1d198b0e9e3c06301710d4aab3d85116cbc8199954644a", "quantity": 10}',0);
INSERT INTO messages VALUES(56,310101,'insert','bets','{"bet_type": 3, "block_index": 310101, "counterwager_quantity": 10, "counterwager_remaining": 10, "deadline": 1388000200, "expiration": 1000, "expire_index": 311101, "fee_fraction_int": 5000000.0, "feed_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "leverage": 5040, "source": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "status": "open", "target_value": 0.0, "tx_hash": "ba0ef1dfbbc87df94e1d198b0e9e3c06301710d4aab3d85116cbc8199954644a", "tx_index": 102, "wager_quantity": 10, "wager_remaining": 10}',0);
INSERT INTO messages VALUES(57,310102,'insert','broadcasts','{"block_index": 310102, "fee_fraction_int": 5000000, "locked": false, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "text": "Unit Test", "timestamp": 1388000002, "tx_hash": "18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e", "tx_index": 103, "value": 1.0}',0);
INSERT INTO messages VALUES(58,310102,'insert','credits','{"action": "bet settled", "address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "asset": "XCP", "block_index": 310102, "event": "18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e", "quantity": 9}',0);
INSERT INTO messages VALUES(59,310102,'insert','credits','{"action": "bet settled", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310102, "event": "18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e", "quantity": 9}',0);
INSERT INTO messages VALUES(60,310102,'insert','credits','{"action": "feed fee", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310102, "event": "18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e", "quantity": 0}',0);
INSERT INTO messages VALUES(61,310102,'insert','bet_match_resolutions','{"bear_credit": 9, "bet_match_id": "be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "bet_match_type_id": 1, "block_index": 310102, "bull_credit": 9, "escrow_less_fee": null, "fee": 0, "settled": true, "winner": null}',0);
INSERT INTO messages VALUES(62,310102,'update','bet_matches','{"bet_match_id": "be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd_90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5", "status": "settled"}',0);
INSERT INTO messages VALUES(63,310103,'insert','credits','{"action": "burn", "address": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "asset": "XCP", "block_index": 310103, "event": "6e96414550ec512d2272497e3e2cbc908ec472cc1b871d82f51a9a66af3cf148", "quantity": 92999138821}',0);
INSERT INTO messages VALUES(64,310103,'insert','burns','{"block_index": 310103, "burned": 62000000, "earned": 92999138821, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "valid", "tx_hash": "6e96414550ec512d2272497e3e2cbc908ec472cc1b871d82f51a9a66af3cf148", "tx_index": 104}',0);
INSERT INTO messages VALUES(65,310104,'insert','credits','{"action": "burn", "address": "munimLLHjPhGeSU5rYB2HN79LJa8bRZr5b", "asset": "XCP", "block_index": 310104, "event": "1f4e8d91b61fff6132ee060b80008f7739e8215282a5bd7c57fe088c056d9f72", "quantity": 92999130460}',0);
INSERT INTO messages VALUES(66,310104,'insert','burns','{"block_index": 310104, "burned": 62000000, "earned": 92999130460, "source": "munimLLHjPhGeSU5rYB2HN79LJa8bRZr5b", "status": "valid", "tx_hash": "1f4e8d91b61fff6132ee060b80008f7739e8215282a5bd7c57fe088c056d9f72", "tx_index": 105}',0);
INSERT INTO messages VALUES(67,310105,'insert','credits','{"action": "burn", "address": "mwtPsLQxW9xpm7gdLmwWvJK5ABdPUVJm42", "asset": "XCP", "block_index": 310105, "event": "3152127f7b6645e8b066f6691aeed95fa38f404df85df1447c320b38a79240c6", "quantity": 92999122099}',0);
INSERT INTO messages VALUES(68,310105,'insert','burns','{"block_index": 310105, "burned": 62000000, "earned": 92999122099, "source": "mwtPsLQxW9xpm7gdLmwWvJK5ABdPUVJm42", "status": "valid", "tx_hash": "3152127f7b6645e8b066f6691aeed95fa38f404df85df1447c320b38a79240c6", "tx_index": 106}',0);
INSERT INTO messages VALUES(69,310106,'insert','credits','{"action": "burn", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "XCP", "block_index": 310106, "event": "bcf44f53dc42ae50f3f0f2dc36ff16e432ddbc298f70ec143806cb58e53d4403", "quantity": 46499556869}',0);
INSERT INTO messages VALUES(70,310106,'insert','burns','{"block_index": 310106, "burned": 31000000, "earned": 46499556869, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "valid", "tx_hash": "bcf44f53dc42ae50f3f0f2dc36ff16e432ddbc298f70ec143806cb58e53d4403", "tx_index": 107}',0);
INSERT INTO messages VALUES(71,310107,'insert','debits','{"action": "issuance fee", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "XCP", "block_index": 310107, "event": "63145ad2bcc7030aabcfec42a5cce5dfe6829a5694fc0b3566406bb2fd8b6444", "quantity": 50000000}',0);
INSERT INTO messages VALUES(72,310107,'insert','issuances','{"asset": "PAYTOSCRIPT", "block_index": 310107, "call_date": 0, "call_price": 0.0, "callable": false, "description": "PSH issued asset", "divisible": false, "fee_paid": 50000000, "issuer": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "locked": false, "quantity": 1000, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "valid", "transfer": false, "tx_hash": "63145ad2bcc7030aabcfec42a5cce5dfe6829a5694fc0b3566406bb2fd8b6444", "tx_index": 108}',0);
INSERT INTO messages VALUES(73,310107,'insert','credits','{"action": "issuance", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "PAYTOSCRIPT", "block_index": 310107, "event": "63145ad2bcc7030aabcfec42a5cce5dfe6829a5694fc0b3566406bb2fd8b6444", "quantity": 1000}',0);
INSERT INTO messages VALUES(74,310108,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "DIVISIBLE", "block_index": 310108, "event": "075b91828d0c7b0017f1b5876ef4909ba37db9bc2877588483d8a64bad2bd412", "quantity": 100000000}',0);
INSERT INTO messages VALUES(75,310108,'insert','credits','{"action": "send", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "DIVISIBLE", "block_index": 310108, "event": "075b91828d0c7b0017f1b5876ef4909ba37db9bc2877588483d8a64bad2bd412", "quantity": 100000000}',0);
INSERT INTO messages VALUES(76,310108,'insert','sends','{"asset": "DIVISIBLE", "block_index": 310108, "destination": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "quantity": 100000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "075b91828d0c7b0017f1b5876ef4909ba37db9bc2877588483d8a64bad2bd412", "tx_index": 109}',0);
INSERT INTO messages VALUES(77,310109,'insert','broadcasts','{"block_index": 310109, "fee_fraction_int": 5000000, "locked": false, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "valid", "text": "Unit Test", "timestamp": 1388000002, "tx_hash": "d858c6855038048b1d5e31a34ceae2069d7c7bc311ca49d189ccbf44cee58031", "tx_index": 110, "value": 1.0}',0);
INSERT INTO messages VALUES(78,310110,'insert','debits','{"action": "bet", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "XCP", "block_index": 310110, "event": "81f8ba670b22980b15c944dcd478a274723659d768b0de73b014d06d214e5b90", "quantity": 10}',0);
INSERT INTO messages VALUES(79,310110,'insert','bets','{"bet_type": 3, "block_index": 310110, "counterwager_quantity": 10, "counterwager_remaining": 10, "deadline": 1388000200, "expiration": 1000, "expire_index": 311110, "fee_fraction_int": 5000000.0, "feed_address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "leverage": 5040, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "open", "target_value": 0.0, "tx_hash": "81f8ba670b22980b15c944dcd478a274723659d768b0de73b014d06d214e5b90", "tx_index": 111, "wager_quantity": 10, "wager_remaining": 10}',0);
INSERT INTO messages VALUES(80,310111,'insert','broadcasts','{"block_index": 310111, "fee_fraction_int": 0, "locked": false, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "valid", "text": "INITVOTE TESTSCENARIOPOLL XCP 1000 OPTS TRUE FALSE", "timestamp": 1388000000, "tx_hash": "76161d0bf7f94e5291e45c4faba4da1efd01cd91c6513cdbf5fa9fd10184eea5", "tx_index": 112, "value": -3.0}',0);
INSERT INTO messages VALUES(81,310112,'insert','broadcasts','{"block_index": 310112, "fee_fraction_int": 0, "locked": false, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "valid", "text": "CASTVOTE TESTSCENARIOPOLL TRUE 70", "timestamp": 1388000001, "tx_hash": "22b9d1b536f079c1f0c435fdc33f41bcb21fa7bc4579944033fdbafc89a56c33", "tx_index": 113, "value": -3.0}',0);
INSERT INTO messages VALUES(82,310486,'insert','broadcasts','{"block_index": 310486, "fee_fraction_int": 5000000, "locked": false, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "valid", "text": "Unit Test", "timestamp": 1388000100, "tx_hash": "f847362f6669c558922032a575b57da93af5e367ab7ba3154b71587cbbb50551", "tx_index": 487, "value": 1.0}',0);
INSERT INTO messages VALUES(83,310487,'insert','debits','{"action": "bet", "address": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "asset": "XCP", "block_index": 310487, "event": "cadcc00884e64292c6f899b4abc29df7286d94093a258d0925e2fcc88af495b6", "quantity": 9}',0);
INSERT INTO messages VALUES(84,310487,'insert','bets','{"bet_type": 1, "block_index": 310487, "counterwager_quantity": 9, "counterwager_remaining": 9, "deadline": 1388000101, "expiration": 100, "expire_index": 310587, "fee_fraction_int": 5000000.0, "feed_address": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "leverage": 5040, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "open", "target_value": 0.0, "tx_hash": "cadcc00884e64292c6f899b4abc29df7286d94093a258d0925e2fcc88af495b6", "tx_index": 488, "wager_quantity": 9, "wager_remaining": 9}',0);
INSERT INTO messages VALUES(85,310488,'insert','broadcasts','{"block_index": 310488, "fee_fraction_int": null, "locked": true, "source": "myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM", "status": "valid", "text": null, "timestamp": 0, "tx_hash": "93ff662d6409f5a2b381e76fdd659a7dffee6fada7869574de201d29fa2b15b4", "tx_index": 489, "value": null}',0);
INSERT INTO messages VALUES(86,310491,'insert','debits','{"action": "open order", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310491, "event": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b", "quantity": 100000000}',0);
INSERT INTO messages VALUES(87,310491,'insert','orders','{"block_index": 310491, "expiration": 2000, "expire_index": 312491, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 900000, "fee_required_remaining": 900000, "get_asset": "BTC", "get_quantity": 800000, "get_remaining": 800000, "give_asset": "XCP", "give_quantity": 100000000, "give_remaining": 100000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "tx_hash": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b", "tx_index": 492}',0);
INSERT INTO messages VALUES(88,310492,'insert','orders','{"block_index": 310492, "expiration": 2000, "expire_index": 312492, "fee_provided": 1000000, "fee_provided_remaining": 1000000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 100000000, "get_remaining": 100000000, "give_asset": "BTC", "give_quantity": 800000, "give_remaining": 800000, "source": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "status": "open", "tx_hash": "14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0", "tx_index": 493}',0);
INSERT INTO messages VALUES(89,310492,'update','orders','{"fee_provided_remaining": 10000, "fee_required_remaining": 892800, "get_remaining": 0, "give_remaining": 0, "status": "open", "tx_hash": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b"}',0);
INSERT INTO messages VALUES(90,310492,'update','orders','{"fee_provided_remaining": 992800, "fee_required_remaining": 0, "get_remaining": 0, "give_remaining": 0, "status": "open", "tx_hash": "14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0"}',0);
INSERT INTO messages VALUES(91,310492,'insert','order_matches','{"backward_asset": "BTC", "backward_quantity": 800000, "block_index": 310492, "fee_paid": 7200, "forward_asset": "XCP", "forward_quantity": 100000000, "id": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b_14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0", "match_expire_index": 310512, "status": "pending", "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx0_block_index": 310491, "tx0_expiration": 2000, "tx0_hash": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b", "tx0_index": 492, "tx1_address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "tx1_block_index": 310492, "tx1_expiration": 2000, "tx1_hash": "14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0", "tx1_index": 493}',0);
INSERT INTO messages VALUES(92,310493,'insert','credits','{"action": "burn", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "XCP", "block_index": 310493, "event": "d6adfa92e20b6211ff5fabb2f7a1c8b037168797984c94734c28e82e92d3b1d6", "quantity": 92995878046}',0);
INSERT INTO messages VALUES(93,310493,'insert','burns','{"block_index": 310493, "burned": 62000000, "earned": 92995878046, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "tx_hash": "d6adfa92e20b6211ff5fabb2f7a1c8b037168797984c94734c28e82e92d3b1d6", "tx_index": 494}',0);
INSERT INTO messages VALUES(94,310494,'insert','debits','{"action": "issuance fee", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "XCP", "block_index": 310494, "event": "084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e", "quantity": 50000000}',0);
INSERT INTO messages VALUES(95,310494,'insert','issuances','{"asset": "DIVIDEND", "block_index": 310494, "call_date": 0, "call_price": 0.0, "callable": false, "description": "Test dividend", "divisible": true, "fee_paid": 50000000, "issuer": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "locked": false, "quantity": 100, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "transfer": false, "tx_hash": "084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e", "tx_index": 495}',0);
INSERT INTO messages VALUES(96,310494,'insert','credits','{"action": "issuance", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "DIVIDEND", "block_index": 310494, "event": "084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e", "quantity": 100}',0);
INSERT INTO messages VALUES(97,310495,'insert','debits','{"action": "send", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "DIVIDEND", "block_index": 310495, "event": "9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602", "quantity": 10}',0);
INSERT INTO messages VALUES(98,310495,'insert','credits','{"action": "send", "address": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "asset": "DIVIDEND", "block_index": 310495, "event": "9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602", "quantity": 10}',0);
INSERT INTO messages VALUES(99,310495,'insert','sends','{"asset": "DIVIDEND", "block_index": 310495, "destination": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "quantity": 10, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "tx_hash": "9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602", "tx_index": 496}',0);
INSERT INTO messages VALUES(100,310496,'insert','debits','{"action": "send", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "XCP", "block_index": 310496, "event": "54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef", "quantity": 92945878046}',0);
INSERT INTO messages VALUES(101,310496,'insert','credits','{"action": "send", "address": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "asset": "XCP", "block_index": 310496, "event": "54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef", "quantity": 92945878046}',0);
INSERT INTO messages VALUES(102,310496,'insert','sends','{"asset": "XCP", "block_index": 310496, "destination": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "quantity": 92945878046, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "tx_hash": "54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef", "tx_index": 497}',0);
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
INSERT INTO poll_votes VALUES(113,'22b9d1b536f079c1f0c435fdc33f41bcb21fa7bc4579944033fdbafc89a56c33',310112,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','TESTSCENARIOPOLL','TRUE',70);
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
                      duration INTEGER,
                      options TEXT,
                      FOREIGN KEY (tx_index, tx_hash, block_index) REFERENCES transactions(tx_index, tx_hash, block_index));
INSERT INTO polls VALUES(112,'76161d0bf7f94e5291e45c4faba4da1efd01cd91c6513cdbf5fa9fd10184eea5',310111,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','TESTSCENARIOPOLL',310111,'XCP',1000,'["TRUE", "FALSE"]');
-- Triggers and indices on  polls
CREATE TRIGGER _polls_delete BEFORE DELETE ON polls BEGIN
                            INSERT INTO undolog VALUES(NULL, 'INSERT INTO polls(rowid,tx_index,tx_hash,block_index,source,votename,stake_block_index,asset,duration,options) VALUES('||old.rowid||','||quote(old.tx_index)||','||quote(old.tx_hash)||','||quote(old.block_index)||','||quote(old.source)||','||quote(old.votename)||','||quote(old.stake_block_index)||','||quote(old.asset)||','||quote(old.duration)||','||quote(old.options)||')');
                            END;
CREATE TRIGGER _polls_insert AFTER INSERT ON polls BEGIN
                            INSERT INTO undolog VALUES(NULL, 'DELETE FROM polls WHERE rowid='||new.rowid);
                            END;
CREATE TRIGGER _polls_update AFTER UPDATE ON polls BEGIN
                            INSERT INTO undolog VALUES(NULL, 'UPDATE polls SET tx_index='||quote(old.tx_index)||',tx_hash='||quote(old.tx_hash)||',block_index='||quote(old.block_index)||',source='||quote(old.source)||',votename='||quote(old.votename)||',stake_block_index='||quote(old.stake_block_index)||',asset='||quote(old.asset)||',duration='||quote(old.duration)||',options='||quote(old.options)||' WHERE rowid='||old.rowid);
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
INSERT INTO transactions VALUES(1,'610b15f0c2d3845f124cc6026b6c212033de94218b25f89d5dbde47d11085a89',310000,'505d8d82c4ced7daddef7ed0b05ba12ecc664176887b938ef56c6af276f3b30c',310000000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,10000,X'',1);
INSERT INTO transactions VALUES(2,'82e357fac0f41bc8c0c01e781ce96f0871bd3d6aaf57a8e99255d5e9d9fba554',310001,'3c9f6a9c6cac46a9273bd3db39ad775acd5bc546378ec2fb0587e06e112cc78e',310001000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'00000014000000A25BE34B66000000174876E800010000000000000000000F446976697369626C65206173736574',1);
INSERT INTO transactions VALUES(3,'6ecaeb544ce2f8a4a24d8d497ecba6ef7b71082a3f1cfdabc48726d5bc90fdca',310002,'fbb60f1144e1f7d4dc036a4a158a10ea6dea2ba6283a723342a49b8eb5cc9964',310002000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'000000140006CAD8DC7F0B6600000000000003E800000000000000000000124E6F20646976697369626C65206173736574',1);
INSERT INTO transactions VALUES(4,'a36a2d510757def22f0aa0f1cd1b4cf5e9bb160b051b83df25a101d5bb048928',310003,'d50825dcb32bcf6f69994d616eba18de7718d3d859497e80751b2cb67e333e8a',310003000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001400000003C58E5C5600000000000003E8010000000000000000000E43616C6C61626C65206173736574',1);
INSERT INTO transactions VALUES(5,'044c9ac702136ee7839dc776cb7b43bbb9d5328415925a958679d801ac6c6b63',310004,'60cdc0ac0e3121ceaa2c3885f21f5789f49992ffef6e6ff99f7da80e36744615',310004000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001400000000082C82E300000000000003E8010000000000000000000C4C6F636B6564206173736574',1);
INSERT INTO transactions VALUES(6,'bd919f9a31982a6dbc6253e38bfba0a367e24fbd65cf79575648f799b98849b4',310005,'8005c2926b7ecc50376642bc661a49108b6dc62636463a5c492b123e2184cd9a',310005000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001400000000082C82E3000000000000000001000000000000000000044C4F434B',1);
INSERT INTO transactions VALUES(7,'074fa38a84a81c0ed7957484ebe73836104d3068f66b189e05a7cf0b95c737f3',310006,'bdad69d1669eace68b9f246de113161099d4f83322e2acf402c42defef3af2bb',310006000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000A25BE34B660000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(8,'d21d82d8298d545b91e4467c287322d2399d8eb08af15bee68f58c4bcfa9a5f9',310007,'10a642b96d60091d08234d17dfdecf3025eca41e4fc8e3bbe71a91c5a457cb4b',310007000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'00000000000000A25BE34B660000000005F5E100',1);
INSERT INTO transactions VALUES(9,'e64aac59d8759cde5785f3e1c4af448d95a152a30c76d97c114a3025e5ec118b',310008,'47d0e3acbdc6916aeae95e987f9cfa16209b3df1e67bb38143b3422b32322c33',310008000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'0000000000000000000000010000000005F5E100',1);
INSERT INTO transactions VALUES(10,'a9f78534e7f340ba0f0d2ac1851a11a011ca7aa1262349eeba71add8777b162b',310009,'4d474992b141620bf3753863db7ee5e8af26cadfbba27725911f44fa657bc1c0',310009000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000A25BE34B660000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(11,'b6db5c8412a58d9fa75bff41f8a7519353ffd4d359c7c8fa7ee1900bc05e4d9d',310010,'a58162dff81a32e6a29b075be759dbb9fa9b8b65303e69c78fb4d7b0acc37042',310010000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000000000000000000000000F424007D000000000000DBBA0',1);
INSERT INTO transactions VALUES(12,'8a63e7a516d36c17ac32999222ac282ab94fb9c5ea30637cd06660b3139510f6',310011,'8042cc2ef293fd73d050f283fbd075c79dd4c49fdcca054dc0714fc3a50dc1bb',310011000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,1000000,X'0000000A000000000000000000000000000A2C2B00000000000000010000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(13,'d4428cf4082bc5fe8fed72673f956d351f269a308cf0d0d0b87f76dd3b6165f4',310012,'cdba329019d93a67b31b79d05f76ce1b7791d430ea0d6c1c2168fe78d2f67677',310012000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'0000000000000000000000010000000011E1A300',1);
INSERT INTO transactions VALUES(14,'97aaf458fdbe3a8d7e57b4c238706419c001fc5810630c0c3cd2361821052a0d',310013,'0425e5e832e4286757dc0228cd505b8d572081007218abd3a0983a3bcd502a61',310013000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'00000000000000A25BE34B66000000003B9ACA00',1);
INSERT INTO transactions VALUES(15,'29cd663b5e5b0801717e46891bc57e1d050680da0a803944623f6021151d2592',310014,'85b28d413ebda2968ed82ae53643677338650151b997ed1e4656158005b9f65f',310014000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'000000000006CAD8DC7F0B660000000000000005',1);
INSERT INTO transactions VALUES(16,'b285ff2379716e92ab7b68ad4e68ba74a999dc9ca8c312c377231a89da7e9361',310015,'4cf77d688f18f0c68c077db882f62e49f31859dfa6144372457cd73b29223922',310015000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'000000000006CAD8DC7F0B66000000000000000A',1);
INSERT INTO transactions VALUES(17,'cd929bf57f5f26550a56ba40eecd258b684842777dfc434a46b65a86e924bf52',310016,'99dc7d2627efb4e5e618a53b9898b4ca39c70e98fe9bf39f68a6c980f5b64ef9',310016000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'000000140000000000033A3E7FFFFFFFFFFFFFFF01000000000000000000104D6178696D756D207175616E74697479',1);
INSERT INTO transactions VALUES(18,'9b70f9ad8c0d92ff27127d081169cebee68a776f4974e757de09a46e85682d66',310017,'8a4fedfbf734b91a5c5761a7bcb3908ea57169777a7018148c51ff611970e4a3',310017000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001E52BB33003FF0000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(19,'f6548d72d0726bd869fdfdcf44766871f7ab721efda6ed7bce0d4c88b43bf1cf',310018,'35c06f9e3de39e4e56ceb1d1a22008f52361c50dd0d251c0acbe2e3c2dba8ed3',310018000,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','',0,10000,X'0000001E4CC552003FF000000000000000000000046C6F636B',1);
INSERT INTO transactions VALUES(20,'be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd',310019,'114affa0c4f34b1ebf8e2778c9477641f60b5b9e8a69052158041d4c41893294',310019000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000152BB3301000000000000000900000000000000090000000000000000000013B000000064',1);
INSERT INTO transactions VALUES(21,'90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5',310020,'d93c79920e4a42164af74ecb5c6b903ff6055cdc007376c74dfa692c8d85ebc9',310020000,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000052BB3301000000000000000900000000000000090000000000000000000013B000000064',1);
INSERT INTO transactions VALUES(102,'ba0ef1dfbbc87df94e1d198b0e9e3c06301710d4aab3d85116cbc8199954644a',310101,'369472409995ca1a2ebecbad6bf9dab38c378ab1e67e1bdf13d4ce1346731cd6',310101000,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000352BB33C8000000000000000A000000000000000A0000000000000000000013B0000003E8',1);
INSERT INTO transactions VALUES(103,'18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e',310102,'11e25883fd0479b78ddb1953ef67e3c3d1ffc82bd1f9e918a75c2194f7137f99',310102000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001E52BB33023FF0000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(104,'6e96414550ec512d2272497e3e2cbc908ec472cc1b871d82f51a9a66af3cf148',310103,'559a208afea6dd27b8bfeb031f1bd8f57182dcab6cf55c4089a6c49fb4744f17',310103000,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,-99990000,X'',1);
INSERT INTO transactions VALUES(105,'1f4e8d91b61fff6132ee060b80008f7739e8215282a5bd7c57fe088c056d9f72',310104,'55b82e631b61d22a8524981ff3b5e3ab4ad7b732b7d1a06191064334b8f2dfd2',310104000,'munimLLHjPhGeSU5rYB2HN79LJa8bRZr5b','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,-99990000,X'',1);
INSERT INTO transactions VALUES(106,'3152127f7b6645e8b066f6691aeed95fa38f404df85df1447c320b38a79240c6',310105,'1d72cdf6c4a02a5f973e6eaa53c28e9e13014b4f5bb13f91621a911b27fe936a',310105000,'mwtPsLQxW9xpm7gdLmwWvJK5ABdPUVJm42','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,-99990000,X'',1);
INSERT INTO transactions VALUES(107,'bcf44f53dc42ae50f3f0f2dc36ff16e432ddbc298f70ec143806cb58e53d4403',310106,'9d39cbe8c8a5357fc56e5c2f95bf132382ddad14cbc8abd54e549d58248140ff',310106000,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','mvCounterpartyXXXXXXXXXXXXXXW24Hef',31000000,10000,X'',1);
INSERT INTO transactions VALUES(108,'63145ad2bcc7030aabcfec42a5cce5dfe6829a5694fc0b3566406bb2fd8b6444',310107,'51cc04005e49fa49e661946a0e147240b0e5aac174252c96481ab7ddd5487435',310107000,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','',0,10000,X'0000001400078A8FE2E5E44100000000000003E8000000000000000000001050534820697373756564206173736574',1);
INSERT INTO transactions VALUES(109,'075b91828d0c7b0017f1b5876ef4909ba37db9bc2877588483d8a64bad2bd412',310108,'8f2d3861aa42f8e75dc14a23d6046bd89feef0d81996b6e1adc2a2828fbc8b34',310108000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',5430,10000,X'00000000000000A25BE34B660000000005F5E100',1);
INSERT INTO transactions VALUES(110,'d858c6855038048b1d5e31a34ceae2069d7c7bc311ca49d189ccbf44cee58031',310109,'d23aaaae55e6a912eaaa8d20fe2a9ad4819fe9dc1ed58977265af58fad89d8f9',310109000,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','',0,10000,X'0000001E52BB33023FF0000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(111,'81f8ba670b22980b15c944dcd478a274723659d768b0de73b014d06d214e5b90',310110,'cecc8e4791bd3081995bd9fd67acb6b97415facfd2b68f926a70b22d9a258382',310110000,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',5430,10000,X'00000028000352BB33C8000000000000000A000000000000000A0000000000000000000013B0000003E8',1);
INSERT INTO transactions VALUES(112,'76161d0bf7f94e5291e45c4faba4da1efd01cd91c6513cdbf5fa9fd10184eea5',310111,'fde71b9756d5ba0b6d8b230ee885af01f9c4461a55dbde8678279166a21b20ae',310111000,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','',0,-99990000,X'0000001E52BB3300C0080000000000000000000032494E4954564F544520544553545343454E4152494F504F4C4C205843502031303030204F50545320545255452046414C5345',1);
INSERT INTO transactions VALUES(113,'22b9d1b536f079c1f0c435fdc33f41bcb21fa7bc4579944033fdbafc89a56c33',310112,'5b06f69bfdde1083785cf68ebc2211b464839033c30a099d3227b490bf3ab251',310112000,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','',0,-99990000,X'0000001E52BB3301C008000000000000000000002143415354564F544520544553545343454E4152494F504F4C4C2054525545203730',1);
INSERT INTO transactions VALUES(487,'f847362f6669c558922032a575b57da93af5e367ab7ba3154b71587cbbb50551',310486,'d4fbe610cc60987f2d1d35c7d8ad3ce32156ee5fe36ef8cc4f08b46836388862',310486000,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','',0,-99990000,X'0000001E52BB33643FF0000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(488,'cadcc00884e64292c6f899b4abc29df7286d94093a258d0925e2fcc88af495b6',310487,'32aa1b132d0643350bbb62dbd5f38ae0c270d8f491a2012c83b99158d58e464f',310487000,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM',5430,-99990000,X'00000028000152BB3365000000000000000900000000000000090000000000000000000013B000000064',1);
INSERT INTO transactions VALUES(489,'93ff662d6409f5a2b381e76fdd659a7dffee6fada7869574de201d29fa2b15b4',310488,'80b8dd5d7ce2e4886e6721095b892a39fb699980fe2bc1c17e747f822f4c4b1b',310488000,'myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM','',0,-99990000,X'0000001E52BB33663FF000000000000000000000046C6F636B',1);
INSERT INTO transactions VALUES(492,'9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b',310491,'811abd7cf2b768cfdaa84ab44c63f4463c96a368ead52125bf149cf0c7447b16',310491000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000000000000000000000000C350007D000000000000DBBA0',1);
INSERT INTO transactions VALUES(493,'14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0',310492,'8a09b2faf0a7ad67eb4ab5c948b9769fc87eb2ec5e16108f2cde8bd9e6cf7607',310492000,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','',0,1000000,X'0000000A000000000000000000000000000C350000000000000000010000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(494,'d6adfa92e20b6211ff5fabb2f7a1c8b037168797984c94734c28e82e92d3b1d6',310493,'c19e2915b750279b2be4b52e57e5ce29f63dffb4e14d9aad30c9e820affc0cbf',310493000,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,10000,X'',1);
INSERT INTO transactions VALUES(495,'084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e',310494,'7dda1d3e12785313d5651ee5314d0aecf17588196f9150b10c55695dbaebee5d',310494000,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','',0,10000,X'00000014000000063E985FFD0000000000000064010000000000000000000D54657374206469766964656E64',1);
INSERT INTO transactions VALUES(496,'9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602',310495,'4769aa7030f28a05a137a85ef4ee0c1765c37013773212b93ec90f1227168b67',310495000,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj',5430,10000,X'00000000000000063E985FFD000000000000000A',1);
INSERT INTO transactions VALUES(497,'54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef',310496,'65884816927e8c566655e85c07bc2bc2c7ee26e625742f219939d43238fb31f8',310496000,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj',5430,10000,X'00000000000000000000000100000015A4018C1E',1);
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
INSERT INTO undolog VALUES(135,'DELETE FROM broadcasts WHERE rowid=487');
INSERT INTO undolog VALUES(136,'UPDATE balances SET address=''myAtcJEHAsDLbTkai6ipWDZeeL7VkxXsiM'',asset=''XCP'',quantity=92999138821 WHERE rowid=13');
INSERT INTO undolog VALUES(137,'DELETE FROM debits WHERE rowid=22');
INSERT INTO undolog VALUES(138,'DELETE FROM bets WHERE rowid=5');
INSERT INTO undolog VALUES(139,'DELETE FROM broadcasts WHERE rowid=489');
INSERT INTO undolog VALUES(140,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92050000000 WHERE rowid=1');
INSERT INTO undolog VALUES(141,'DELETE FROM debits WHERE rowid=23');
INSERT INTO undolog VALUES(142,'DELETE FROM orders WHERE rowid=5');
INSERT INTO undolog VALUES(143,'DELETE FROM orders WHERE rowid=6');
INSERT INTO undolog VALUES(144,'UPDATE orders SET tx_index=492,tx_hash=''9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b'',block_index=310491,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',give_asset=''XCP'',give_quantity=100000000,give_remaining=100000000,get_asset=''BTC'',get_quantity=800000,get_remaining=800000,expiration=2000,expire_index=312491,fee_required=900000,fee_required_remaining=900000,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=5');
INSERT INTO undolog VALUES(145,'UPDATE orders SET tx_index=493,tx_hash=''14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0'',block_index=310492,source=''mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns'',give_asset=''BTC'',give_quantity=800000,give_remaining=800000,get_asset=''XCP'',get_quantity=100000000,get_remaining=100000000,expiration=2000,expire_index=312492,fee_required=0,fee_required_remaining=0,fee_provided=1000000,fee_provided_remaining=1000000,status=''open'' WHERE rowid=6');
INSERT INTO undolog VALUES(146,'DELETE FROM order_matches WHERE rowid=1');
INSERT INTO undolog VALUES(147,'DELETE FROM balances WHERE rowid=19');
INSERT INTO undolog VALUES(148,'DELETE FROM credits WHERE rowid=24');
INSERT INTO undolog VALUES(149,'DELETE FROM burns WHERE rowid=494');
INSERT INTO undolog VALUES(150,'UPDATE balances SET address=''mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH'',asset=''XCP'',quantity=92995878046 WHERE rowid=19');
INSERT INTO undolog VALUES(151,'DELETE FROM debits WHERE rowid=24');
INSERT INTO undolog VALUES(152,'DELETE FROM assets WHERE rowid=9');
INSERT INTO undolog VALUES(153,'DELETE FROM issuances WHERE rowid=495');
INSERT INTO undolog VALUES(154,'DELETE FROM balances WHERE rowid=20');
INSERT INTO undolog VALUES(155,'DELETE FROM credits WHERE rowid=25');
INSERT INTO undolog VALUES(156,'UPDATE balances SET address=''mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH'',asset=''DIVIDEND'',quantity=100 WHERE rowid=20');
INSERT INTO undolog VALUES(157,'DELETE FROM debits WHERE rowid=25');
INSERT INTO undolog VALUES(158,'DELETE FROM balances WHERE rowid=21');
INSERT INTO undolog VALUES(159,'DELETE FROM credits WHERE rowid=26');
INSERT INTO undolog VALUES(160,'DELETE FROM sends WHERE rowid=496');
INSERT INTO undolog VALUES(161,'UPDATE balances SET address=''mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH'',asset=''XCP'',quantity=92945878046 WHERE rowid=19');
INSERT INTO undolog VALUES(162,'DELETE FROM debits WHERE rowid=26');
INSERT INTO undolog VALUES(163,'DELETE FROM balances WHERE rowid=22');
INSERT INTO undolog VALUES(164,'DELETE FROM credits WHERE rowid=27');
INSERT INTO undolog VALUES(165,'DELETE FROM sends WHERE rowid=497');

-- Table  undolog_block
DROP TABLE IF EXISTS undolog_block;
CREATE TABLE undolog_block(
                        block_index INTEGER PRIMARY KEY,
                        first_undo_index INTEGER);
INSERT INTO undolog_block VALUES(310400,135);
INSERT INTO undolog_block VALUES(310401,135);
INSERT INTO undolog_block VALUES(310402,135);
INSERT INTO undolog_block VALUES(310403,135);
INSERT INTO undolog_block VALUES(310404,135);
INSERT INTO undolog_block VALUES(310405,135);
INSERT INTO undolog_block VALUES(310406,135);
INSERT INTO undolog_block VALUES(310407,135);
INSERT INTO undolog_block VALUES(310408,135);
INSERT INTO undolog_block VALUES(310409,135);
INSERT INTO undolog_block VALUES(310410,135);
INSERT INTO undolog_block VALUES(310411,135);
INSERT INTO undolog_block VALUES(310412,135);
INSERT INTO undolog_block VALUES(310413,135);
INSERT INTO undolog_block VALUES(310414,135);
INSERT INTO undolog_block VALUES(310415,135);
INSERT INTO undolog_block VALUES(310416,135);
INSERT INTO undolog_block VALUES(310417,135);
INSERT INTO undolog_block VALUES(310418,135);
INSERT INTO undolog_block VALUES(310419,135);
INSERT INTO undolog_block VALUES(310420,135);
INSERT INTO undolog_block VALUES(310421,135);
INSERT INTO undolog_block VALUES(310422,135);
INSERT INTO undolog_block VALUES(310423,135);
INSERT INTO undolog_block VALUES(310424,135);
INSERT INTO undolog_block VALUES(310425,135);
INSERT INTO undolog_block VALUES(310426,135);
INSERT INTO undolog_block VALUES(310427,135);
INSERT INTO undolog_block VALUES(310428,135);
INSERT INTO undolog_block VALUES(310429,135);
INSERT INTO undolog_block VALUES(310430,135);
INSERT INTO undolog_block VALUES(310431,135);
INSERT INTO undolog_block VALUES(310432,135);
INSERT INTO undolog_block VALUES(310433,135);
INSERT INTO undolog_block VALUES(310434,135);
INSERT INTO undolog_block VALUES(310435,135);
INSERT INTO undolog_block VALUES(310436,135);
INSERT INTO undolog_block VALUES(310437,135);
INSERT INTO undolog_block VALUES(310438,135);
INSERT INTO undolog_block VALUES(310439,135);
INSERT INTO undolog_block VALUES(310440,135);
INSERT INTO undolog_block VALUES(310441,135);
INSERT INTO undolog_block VALUES(310442,135);
INSERT INTO undolog_block VALUES(310443,135);
INSERT INTO undolog_block VALUES(310444,135);
INSERT INTO undolog_block VALUES(310445,135);
INSERT INTO undolog_block VALUES(310446,135);
INSERT INTO undolog_block VALUES(310447,135);
INSERT INTO undolog_block VALUES(310448,135);
INSERT INTO undolog_block VALUES(310449,135);
INSERT INTO undolog_block VALUES(310450,135);
INSERT INTO undolog_block VALUES(310451,135);
INSERT INTO undolog_block VALUES(310452,135);
INSERT INTO undolog_block VALUES(310453,135);
INSERT INTO undolog_block VALUES(310454,135);
INSERT INTO undolog_block VALUES(310455,135);
INSERT INTO undolog_block VALUES(310456,135);
INSERT INTO undolog_block VALUES(310457,135);
INSERT INTO undolog_block VALUES(310458,135);
INSERT INTO undolog_block VALUES(310459,135);
INSERT INTO undolog_block VALUES(310460,135);
INSERT INTO undolog_block VALUES(310461,135);
INSERT INTO undolog_block VALUES(310462,135);
INSERT INTO undolog_block VALUES(310463,135);
INSERT INTO undolog_block VALUES(310464,135);
INSERT INTO undolog_block VALUES(310465,135);
INSERT INTO undolog_block VALUES(310466,135);
INSERT INTO undolog_block VALUES(310467,135);
INSERT INTO undolog_block VALUES(310468,135);
INSERT INTO undolog_block VALUES(310469,135);
INSERT INTO undolog_block VALUES(310470,135);
INSERT INTO undolog_block VALUES(310471,135);
INSERT INTO undolog_block VALUES(310472,135);
INSERT INTO undolog_block VALUES(310473,135);
INSERT INTO undolog_block VALUES(310474,135);
INSERT INTO undolog_block VALUES(310475,135);
INSERT INTO undolog_block VALUES(310476,135);
INSERT INTO undolog_block VALUES(310477,135);
INSERT INTO undolog_block VALUES(310478,135);
INSERT INTO undolog_block VALUES(310479,135);
INSERT INTO undolog_block VALUES(310480,135);
INSERT INTO undolog_block VALUES(310481,135);
INSERT INTO undolog_block VALUES(310482,135);
INSERT INTO undolog_block VALUES(310483,135);
INSERT INTO undolog_block VALUES(310484,135);
INSERT INTO undolog_block VALUES(310485,135);
INSERT INTO undolog_block VALUES(310486,135);
INSERT INTO undolog_block VALUES(310487,136);
INSERT INTO undolog_block VALUES(310488,139);
INSERT INTO undolog_block VALUES(310489,140);
INSERT INTO undolog_block VALUES(310490,140);
INSERT INTO undolog_block VALUES(310491,140);
INSERT INTO undolog_block VALUES(310492,143);
INSERT INTO undolog_block VALUES(310493,147);
INSERT INTO undolog_block VALUES(310494,150);
INSERT INTO undolog_block VALUES(310495,156);
INSERT INTO undolog_block VALUES(310496,161);
INSERT INTO undolog_block VALUES(310497,166);
INSERT INTO undolog_block VALUES(310498,166);
INSERT INTO undolog_block VALUES(310499,166);
INSERT INTO undolog_block VALUES(310500,166);

-- For primary key autoincrements the next id to use is stored in
-- sqlite_sequence
DELETE FROM main.sqlite_sequence WHERE name='undolog';
INSERT INTO main.sqlite_sequence VALUES ('undolog', 165);

COMMIT TRANSACTION;
