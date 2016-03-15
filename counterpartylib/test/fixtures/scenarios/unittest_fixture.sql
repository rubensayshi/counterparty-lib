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
INSERT INTO assets VALUES('2122675428648001','PAYTOSCRIPT',310104);
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
INSERT INTO balances VALUES('2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','XCP',46449569401);
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
INSERT INTO bets VALUES(108,'3afada35d5012c10348d88ff03c7813e8ed7f06b2b259b4be6c847358b3b0a4a',310107,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',3,1388000200,10,10,10,10,0.0,5040,1000,311107,5000000,'open');
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
INSERT INTO blocks VALUES(309999,'4b5b541fe4ea8e9f9470af202bb6597a368e47cb82afe6f5cee42d8324f667640c580cb69dce4808dfb530b8d698db315d190792647c83be6a7446511950834a',309999000,NULL,NULL,NULL,NULL,NULL);
INSERT INTO blocks VALUES(310000,'2ee5123266f21fb8f65495c281a368e1b9f93b6c411986e06efc895a8d82467683e6ea5d863714b23582c1c59576650d07c405a8d9bf0d088ee65621178b259d',310000000,NULL,NULL,'f3e1d432b546670845393fae1465975aa99602a7648e0da125e6b8f4d55cbcac','0fc8b9a115ba49c78879c5d75b92bdccd2f5e398e8e8042cc9d0e4568cea9f53','88838f2cfc1eef675714adf7cfef07e7934a12ae60cfa75ca571888ef3d47b5c');
INSERT INTO blocks VALUES(310001,'03a9a24e190a996364217761558e380b94ae9792b8b4dcaa92b6c58d80b9f8f7fcf9a34037be4cd6ad5e0c039b511cccc40c3438a5067822e3cd309f06519612',310001000,NULL,NULL,'6a91073b35d1151c0b9b93f7916d25e6650b82fe4a1b006851d69b1112cd2954','490572196d4b3d303697f55cc9bf8fe29a4ae659dfc51f63a6af37cb5593413b','0e5a1d103303445b9834b0a01d1179e522ff3389a861f0517b2ee061a9bc1c57');
INSERT INTO blocks VALUES(310002,'d574e4fee71454532c0207f27b9c46f07c5c2e20f43829ddeee8f798053413ac6e0d1b9ad2259a0370fe08581fab3e950ce629db5fadd823251254bf606a05bd',310002000,NULL,NULL,'88eac1faa671a7ebc61f63782c4b74d42c813c19e410e240843440f4d4dbaa35','e944f6127f7d13409ace137a670d1503a5412488942fdf7e858fcd99b70e4c2a','d5e23e344547beb15ed6eb88f54504d2f4a8062279e0053a2c9c679655e1870c');
INSERT INTO blocks VALUES(310003,'44392d9d661459ba31140c59e7d8bcd16b071c864c59f65e2edd9e3c16d598e81aaba40f11019a379bfc6d7811e0265fbb8b276d99cdea7f739fb736f433052a',310003000,NULL,NULL,'93d430c0d7a680aad6fb162af200e95e177ba5d604df1e3cb0e086d3959538c3','d9ba1ab8640ac01642eacf28d3f618a222cc40377db418b1313d880ecb88bce8','c3371ad121359321f66af210da3f7d35b83d45074720a18cb305508ad5a60229');
INSERT INTO blocks VALUES(310004,'58c6f6fbf77a64a5e0df123b1258ae6c3e6d4e21901cc942aeb67b1332422c71e1e7e996c5d4f403159ce5ca3863b7ec7ef8281bbbce5960e258492872055fb5',310004000,NULL,NULL,'e85e5d82a20fe2e060a7c1f79dc182d3b2da28903b04302e6abe4a3f935ea373','acc9a12b365f51aa9efbe5612f812bf926ef8e5e3bf057c42877aeea1049ee49','ca4856a25799772f900671b7965ecdc36a09744654a1cd697f18969e22850b8a');
INSERT INTO blocks VALUES(310005,'348a1b690661597ee6e950446e7a1deb8bef7906c0e98a78ab4d0fe799fac5f3007dcd648ff0c61da35b19cf99f16f3028e10ba206968475d741fa8a86c4a7ae',310005000,NULL,NULL,'c6c0f780ffa18de5a5e5afdf4fba5b6a17dce8d767d4b7a9fbbae2ad53ff4718','e9410f15a3b9c93d8416d57295d3a8e03d6313eb73fd2f00678d2f3a8f774e03','db34d651874da19cf2a4fcf50c44f4be7c6e40bc5a0574a46716f10c235b9c43');
INSERT INTO blocks VALUES(310006,'9d31b774b633c35635b71669c07880b521880cee9298b6aba44752ec1734cd2aa26b3bed95409d874e68685636a31a038b784d3e085525ab8c26f7e3b7ba3676',310006000,NULL,NULL,'91458f37f5293fca71cddc6f14874670584e750aa68fbe577b22eac357c5f336','ed50224a1ca02397047900e5770da64a9eb6cb62b6b5b4e57f12d08c5b57ab93','c909c99a5218c152196071f4df6c3dfa2cfdaa70af26e3fc6a490a270ff29339');
INSERT INTO blocks VALUES(310007,'41007a4ed39e7df941059c3db6b24b74c1913b80e0fd38d0073a5b121880fd0f7e98989d8d70766957919371fdaf4e5b44125f9f7c449c3b6bea298253075fe3',310007000,NULL,NULL,'a8f0f81aebdf77ee1945c2199142696f2c74518f2bc1a45dcfd3cebcabec510c','1635973c36f5d7efc3becc95a2667c1bb808edc692ff28eaa5f5849b7cdb4286','fb670f2509a3384f1c75cfa89770da9f9315cbda733fd6cdb1db89e7bbc80608');
INSERT INTO blocks VALUES(310008,'aa28e5948d1158f318393846b4ef67e53ca4c4b047ed8b06eb861db29914e9f1dfe11a8b73aa2225519843661a61e9038cb347015be916c5a44222ed71b8b604',310008000,NULL,NULL,'df7cae2ef1885eb5916f821be0bb11c24c9cabdc6ccdc84866d60de6af972b94','e7dde4bb0a7aeab7df2cd3f8a39af3d64dd98ef64efbc253e4e6e05c0767f585','4e11197b5662b57b1e8b21d196f1d0bae927e36c4b4634539dd63b1df8b7aa99');
INSERT INTO blocks VALUES(310009,'550d7d84590c6e4e7caed4e722151f7e110dc39bf3f54f719babfe89775095abb2d2454014b4cb01fb1e0a7e91639559ce17e096be5178b5c2ca5b22ad41b33a',310009000,NULL,NULL,'1d8caac58a9e5a656a6631fe88be72dfb45dbc25c64d92558db268be01da6024','74b7425efb6832f9cd6ffea0ae5814f192bb6d00c36603700af7a240f878da95','fc53cd08e684798b74bb5b282b72ea18166a7ae83a64ff9b802ae3e3ea6c1d13');
INSERT INTO blocks VALUES(310010,'477c4a3445e32cd0c8ef67c808ac6a6362ebc953c396e2d5c0d7e4f185becd15fa99bd7635358dbb3b5a92e9f03b7fa2dda8d4714e181ec4552b279df3ba81f0',310010000,NULL,NULL,'ab78a209c465104945458dba209c03409f839d4882a1bf416c504d26fd8b9c80','d4bdc625dead1b87056b74aa843ae9b47a1b61bb63aafc32a04137d5022d67e4','2398b32d34b43c20a0965532863ed3ddd21ee095268ba7d8933f31e417a3689e');
INSERT INTO blocks VALUES(310011,'05f81b5c1b067b647894014cea65558826be42cca20a6cccb8623d80059182b77da00922539c59a0a7b63f6f011ca0f564fada0451e891644728b874c65267b9',310011000,NULL,NULL,'5528fec20bfacc31dd43d7284bf1df33e033ec0ac12b14ed813a9dfea4f67741','205fad5e739d6736a483dde222d3fdfc0014a5af1fa1981e652a0fe948d883b3','3f9d7e91b4cfc760c5fa6805975002c258a48e2bc0a9e754bcc69be8e0cb74e5');
INSERT INTO blocks VALUES(310012,'e9d898aae43fc103110e4935cabf01b6016571b1af82e27af04b57c12302b05eab217f075ac3344b0a422e76b8c762c119cb290c867bb6eed432994ec28af027',310012000,NULL,NULL,'fa66dc025cbb75b67a7d4c496141eb5f6f0cc42134433276c8a294c983453926','ff933c5dfc4364dc6fa3faa2d5da4096bd1261cc53f74a20af9e55a4dda2d08b','1993f3234c4025eab5bb95ac516594b99c4068b1352652f0327f4fa6c8684d17');
INSERT INTO blocks VALUES(310013,'2251b497007459321f72cda82681d07d131dd81cc29137b18c534bbb09271678f4497d0316ffac262f021f901078926dee11c791a3524ad850ee948474abd3b5',310013000,NULL,NULL,'442621791a488568ee9dee5d9131db3ce2f17d9d87b4f45dc8079606874823f8','337f673aa1457d390abc97512fbaa5590e4f5e06d663e82627f70fd23c558655','dbe86ee55a221aa0541367039bb0f51ccac45530dd78b0a9b0292b175cef6e56');
INSERT INTO blocks VALUES(310014,'f98fb331e66361507190a1cb1df81b814d24517e7f219029c068b649c9b8a75703770369ebafd864d104225d6fe1fbf13705d1a37a819b04fb151ed390d7bcf8',310014000,NULL,NULL,'8551367f346e50b15c6e0cca116d1697d3301725b73562f62d8e4c53581e7bd0','f1f9d937b2f6f2221055c9f967207accd58a388a33677fd7572c882ce2e65b0e','9e054d7d63e96da38b2bb4715a627e3f4f322b8d86a8ad569a9e2e780c036f46');
INSERT INTO blocks VALUES(310015,'7c25469d6b4fed0e8bb9e4325994c4de1737570fece605b4ca388be6921406b64a395dc519b33c0dff4f93930b32737a941bbb850e31f2ebcd2caba520bc2820',310015000,NULL,NULL,'29de016d6301c2c9be33c98d3ca3e5f2dd25d52fd344426d40e3b0126dea019a','e0051523f6891110c18a2250db797d39d6ffd917aeb446906f8059b293e20be6','98ac9ef994c9b058395d5726fb29303fb90ae1cb4130535c9a9525e61dda0702');
INSERT INTO blocks VALUES(310016,'9f1c56677b369099f059cc145b98f2e3f8895631cdf0f72b7fe76fd953ab68c202329848dfb53f8146552876eba37f50ed02da34f23447f518449bf0ac0cc29e',310016000,NULL,NULL,'32ffd4bdf9b1f8506a25b4d2affe792d1eccf322a9ab832ec71a934fea136db9','0c90d5431f84b4fd0739bfe750ddd2b65f1bfee26f3b576f2df5dc77537389ab','8588b5ccadd1f93f8bce990c723efb6118b90d4491cc7ada4cda296469f5a635');
INSERT INTO blocks VALUES(310017,'4c02945de20ccdc874ae21bf56aea2f40a029c17b81fcf602b367bdbc286f9ec0cacab35fc07ac60aefa4a96a586aed20129ad66d45ab87697704d731e06b40d',310017000,NULL,NULL,'64aa58f7e48dfa10bb48ecf48571d832bb94027c7ac07be0d23d5379452ce03b','ee2aa8e8b5c16ff20dc4a37c5483c7b1b9498b3f77cab630c910e29540c3a4f9','a5b974e881ec4e947974f2441f5af722673d08e55dc3daa5d5e0a717080962bf');
INSERT INTO blocks VALUES(310018,'6a26d120314af1710052c8f8f78453f944a146039679c781e04ddbb5a2d010927726fa6f81d3e01fc1fcc3363c06e8e1a81a35636684c4dbcd51edf561a9c0fc',310018000,NULL,NULL,'8d8f404bdc2fb6178286b2581cf8a23e6028d5d285091fa0e67e96e6da91f54e','be9eab485a9d7cba91072ae17389b123dc865fd84b70750f225c76dcdaac1f27','65f30e31bc64ea4f4a2cb6db890a5769b97b32e0bf3a992302b619bfac0af60e');
INSERT INTO blocks VALUES(310019,'592e775a9259b1a5a7b0d7c2e028ff320783e7b49243ed6a20ece89a72964f3af4ed129698c4a143ad682a1493f982c5f8193d3b0e36b3df43964520409beb7a',310019000,NULL,NULL,'945a8fd2f57cfd5ddab542291fb2e2813762806b806a3e65e688321fefe1986d','7f518d7dec7a31e52840d975a26c5d96d3a202d30d4977205fc14cf76b93dcf2','da444b5d4accf056c6fade57c38869d51a3d9ca102df5c937675398b4b6060b0');
INSERT INTO blocks VALUES(310020,'87fac74eef20e6121d9a66c90481f801a10d636976a6a6e7cf42fc38cc104a470e1b4cab3f9670be86c93ec1a407a1b464599121df6c8109ec7247b25c7efc62',310020000,NULL,NULL,'3393abc111ee337132103ca04b4f8745952cd03ddbd6efff58a589e00a48fa21','50cc106fcf8581a7d1ea0ccdc6c5251b6f36b6a64f12581ab77ab339bb112ec4','ee59a8bb5eafdaf12ad7c8e55a19060451a959b03a9fe0b23a5628f680b04b6e');
INSERT INTO blocks VALUES(310021,'68a4f307918e2f39fb393e5ad6a7e2fb2e35ab5043402ce37e984de670579682af5c7ef98637478bc0efeb579dc9aaca7f199116b390c452ceedca420909355d',310021000,NULL,NULL,'d05fe9705db7b30e6ea6b18e9ae92ba794dd72f25b4e33daf4d46b3b609a02de','648f5633ea84b04f3c82873eb245f1632b00e61112a79632e4608be8915d80f9','1dfc96f94d02b90f20c16923937b21a5701ab03699f647bb08e0d1ae0258171b');
INSERT INTO blocks VALUES(310022,'5052fbeb009f77f5629fb701a2e4a379ef6c5591a87ab4d2315c8b79fc8821301b21f146150b2af542eddd82e8e94bc021dd1a9ef8e837891248ab68f4afa7d0',310022000,NULL,NULL,'c2b2b2c3bdd895c74f3ea22db3d9c66301578436b6fa9175ce0b242c4bfaccc5','26bf7bb14922abb270a25ae77abb45a09271deb901c22dc304b019d610f06f3d','5538c6d7b34b2b2e0c08106feeeea791542e1740ab8dd6fdd8be9cf4dfc17d83');
INSERT INTO blocks VALUES(310023,'1aab02bbb1a7450d612af368e571d955812f9a376e9f7f80c8eb8296ec40ebfa964f5c9b5e56d4e0cc2d584b38c3280c2b8b2ac272ac00f4d0bffd5348006b4c',310023000,NULL,NULL,'fad5b61545d8ef317918f07df063554d4f321c0ebf462f759513212960bdf523','cb647a71c09e5bf06576afbd426ddf13e2151e819b07efb2929db444769e4531','9e420592fcb4ba1bb1fc537ef50f118992964090e525d62c6f47abbf65fd6329');
INSERT INTO blocks VALUES(310024,'232fc55d72da13e22bb39e10cf9bdc29a634f1c6d13c598f8a1886fc6adde9f0db1ec92afc8f2e7e099ad1d225277067c9beebb14116168bcc961d43cc0a5b88',310024000,NULL,NULL,'61a71d0ac67eba15c63a531f797e6d68c83613489730bc2b4e4054094f63105a','b3990893e9f8f00cefb139c043815e301e951cb919c59e58644034b33551b480','1aa35c67d550dd3e39d6b1e99cee07decd694edba633db9295c72207d793cdc7');
INSERT INTO blocks VALUES(310025,'39e5551cc35f579114d5a36f841b8aa487e8277ede3b03bfe73f31b16ffc92d8a9535c485518839f3a1f5789222f234e3ac59e67f949ebb2f86044e72296a4fe',310025000,NULL,NULL,'f7d41404c3d1e57bbc390af958d1596212112068e4986954d11ff8abd13bc8e4','540d181af55b17757869eb48ef4050732f4bb8d7bb4667793e05770f33dd7f4a','23ddec44887f0d9d638316bcf4524e4a107f7b8f1c2739ebbd3dc160196d0524');
INSERT INTO blocks VALUES(310026,'dd6f9e911867c1680a777ed34699914cae82576da2f3fe064cec0f77af56f3af2b9309a9e56195f3a63897446e7cc37ebfa8257aa4758e81fcf70d9b12d77bbe',310026000,NULL,NULL,'31530d7febb577d7588e12d10629fd82966df48a93a613a480879531d5dbd374','26a5ce353f383d9bf732d119bf947380fbf7cb7c10d9b65711da6d08f940b692','55fa2a20ec89af2c4cc82aba44c0028fbaf0f166f0cd2dc5c9d02d9e6f4b657f');
INSERT INTO blocks VALUES(310027,'9adde4402993118c8963435b66b5cd74676459f5aec1f4098ded4e99592879c8072b1603611ccb10fa2f1e7e88e087f812553796839664f2a3ed510c4aed9337',310027000,NULL,NULL,'f54085346ae4608c57c55d321a413a00ffeb85499138559d7d05245f57cc0da3','21eb7db4dff69979f960b34b3d8632d417be2d9087399beaf50cf3a945c101e9','19d6fcff51a87f131362e8bd7f8bbd800e985cd54321ba8a233e3341bff64d11');
INSERT INTO blocks VALUES(310028,'158e01a36be6070d70d4f5723fca07d5a49fa057b32c651893df7bf1c5752a41444ddb9499d11fdfdaa7b5a63070f9294a55e1a6a4e751ed154b5330dc10111e',310028000,NULL,NULL,'a841b7f634fc24553d1c8cb2d66fc3103293dcfd297cb5bf241b0c5da84bd376','d8f78dad14405cbd461ccfcacbfdc544ca5e603df3d3021b58d5393560e0d56f','4359591ae7f06509856433c765a1ac49724211e941408c17f3cf28853758a13d');
INSERT INTO blocks VALUES(310029,'fcd8b3ff5ebaa56426855b262003f15cc0602e452db1ec6c9bc475388553d4766503fc6cde9290903fff1dd94652676b826a229031ee7cb56f69a6d633895fac',310029000,NULL,NULL,'69d40c69b4989f7a59da99b56577b0651887d9422757e38d5410379f95fda641','ba57b2e4eb9132feaa3380491358c8706c44204f7f7a4f7f0060a3ff8a640b97','243c7e0f8a44221eeb8a0e448d7ba8bd8372e6c3a76a6e9b36ddada846d9e43e');
INSERT INTO blocks VALUES(310030,'b49587ccb88b99aa75b91045c596f731a16ce7523207ae0cfd2b2400898576943ae0969a28c5500d20d72a33c9a79b5fc3f5840bd550846d272462cd66fcc259',310030000,NULL,NULL,'192fe51d3a7af659670a8899582c29aedf3a5608ca906b274ce986751dad2d7a','29663f45b5eae8b77bb8ec5351e0012efdf03a17fa5d132dd8da0f432acaf9e0','91193c1f216574251bed7b42946b450587bd765a4b5f4138924dde66e3fd9297');
INSERT INTO blocks VALUES(310031,'7a898e085dea5f59d75df0d4b5dd1a8b12c269d1eaef4e8c78938294abef4813e858c6e6f7bba2e5918a853f71decb610ce80fe3da936587396c44086eed86c8',310031000,NULL,NULL,'125784cdeba1e433b3411c368cdf676efb33021f51c26a8b2bd6ec00fe4f767d','fe36b2450774dfc7db346c45833fbd401d8a234ce87544cd9b373cbc4b79b61a','267edd0d998a1957ac14462b1a5af7055297ed1034e995123512c0d17654e6b7');
INSERT INTO blocks VALUES(310032,'d5778cdb9b17207d9caffc0190842356895364e0c5e6247f02c2fb91d4dcde85becbc7958f07b9c99a9833f45599a0c175a8a3b026ec879467142eff3e3c1457',310032000,NULL,NULL,'fa7832080a2b6ae8829794d70603351755fa4816f15a6e92716f83265daa59a4','258bea96c9e1d774eb0fedc7fe99a328b62ee26f557426d036147d1eea033e04','17d2cb78af47a0cb58a0191eacdce2b7c3f27d4ddc342fb11f619ecebc42ae94');
INSERT INTO blocks VALUES(310033,'ecc0f5ba6c110a32e76689e934d9101617db692d61600ebfe32b500fecd78dcf75bd5712de67e59b99d5b16d9eaaa8378a46a73a35fb10f8821bf75a173507b0',310033000,NULL,NULL,'7b86f430bc44ad5d81a43b5a8ea118b458d995e3832d88bb74bc62429194e45c','ce67ed4dddf1582ac85c4825c5f9d059e6c64542e5d0fa6f489858008948a989','b3834107703858d2f18470e6d6f939d756c9e6a6407a40a78cec8636832749a2');
INSERT INTO blocks VALUES(310034,'75ece066b260c4843383467558849588e5ce1f1634da9bea7c9c0e1821150a386baf940a2624b4c0c3fc4bc4996bf97f545fa61a4ec90c57ca5127c1ccdbec84',310034000,NULL,NULL,'1f2c5ac4375f77fb79612d343dd5fc4489cf94ff983fc05ba2009a9e390d6c06','4e7e92c9296993b9469c9388ba23e9a5696070ee7e42b09116e45c6078746d00','0ff41ea30f20b7bf90c66003f29d41bf7bd7c526881db0b645bc1a76911afb63');
INSERT INTO blocks VALUES(310035,'0c8e6a86abf191a1bad2897dcc7aad3e5a5c1439799c55c95f435eb6fb9e50ac892d58d1a9c9424009d0730fd59ecb202de2e1c155d5fc70a8da9868946caa51',310035000,NULL,NULL,'81cdae9b978935ad40a1032e7f22ddd7117b9c7580d6d7e4b7e20d1c875f5e63','98919ef5963b86630a60e75cef8b95f24508d65d29c534811a92ed5016cc14dd','7bf7cdcf88fde6747b8ad3477bb1ea645cfb95ff7d6cfeeab33c87eee54cf744');
INSERT INTO blocks VALUES(310036,'4011ea78ccc04ca2ee8d6bf0b14eef82bfa9456869415a8126f2bee5a1bf961c8436571c00fe20e82c78bee44159e0a3523736123c641b871d271642e8f7ef1b',310036000,NULL,NULL,'ff02952dce15c249501d8485decad0ad9fe02fda766b7b83720806f726d02ee4','ef9adfbd23bebd3c047db6d82d7d0ca0479bd14fcfeb95b9a4ef6963d7294b99','623dd05dbd17d04175b720d8b1d37b9137f1ea83ddfb4c98ba2c91dfa5f4df46');
INSERT INTO blocks VALUES(310037,'7f94ef56feec97124f1e6f04b862fed49ae7c179ee143701cf0eec922b5d39932831274f5528d8d9b0e8e115236cfca7f2d78da21db5596565314e625300ef49',310037000,NULL,NULL,'760e5a00feb6c8c4baf4421ad07be2af962bfcac7705b773484b449356d6c230','51cbb75a27acf3a67b54f6b64a4f4b86d511fe3d6fe29526fe26238e44a3bd4b','a8dfa56a89e1475996abb64ba1b4ccc878c44540b31bbdfd937b61db889d4dce');
INSERT INTO blocks VALUES(310038,'e7c42cc00226117b58f818813df49a64af8ca6352a8490a2894676aba647c1bc8d4ae58bb883b710348233879c841da83eda54d35c5ec279f8a2e1ccba8a4264',310038000,NULL,NULL,'c79381c51fa93cc320d8bf19c943f98232a99446ac098ff66823cf691e0fa01c','cd45648e95377f9c8503ba747cd2a7312ac0c9108316eb5a77a06fb9fd0df474','7f15dd0f7c34494fc4c0a1fab509d3de57867acb7277a4e505cbdd0486457330');
INSERT INTO blocks VALUES(310039,'1efd67747830ff43e4cb5f2837d40789a0a781a79c5de4a7966ef64101c39169c28b7eb78481c4b92d14d997be3bbc7f5c6a6a8af8c729825c0e6a07fc6fbeea',310039000,NULL,NULL,'7382f007315783c9a6ffd29bc0eaa62282c6ec72c5fff09322d6dea6b0ee3a96','ffe0bc6eeace43428a31476e259bf5dfe33c33f70c18001504f158d4be026b5c','cec197d33ac2efeb87943aa58e10272cf7bd662984a64929e18530e4c839f73b');
INSERT INTO blocks VALUES(310040,'0afea7365138d9d478c1a57003d66b1998e462cfe57a9a3a1a9360f5e305e9e639387f6849770c33995e1126cefa8ed66faf8a8af03e5c0853191091978d04b1',310040000,NULL,NULL,'38d3b548be554a0ae92504244a88930b989ea6fefc9bc59c69b68ed560afee9a','3a96f2cea7c289afdd0b6c987bc0081a8726d08eb19bfe3eb9b518442324fe16','f972ad30b7564a70a05264cabff7dbdc6f43fcf97cc2c253031d7df804622135');
INSERT INTO blocks VALUES(310041,'a332959f882f2a2846237e5ce8874beddc8e28c551f7d5be885c79b1d4650c5ff3c9855069302643e9315390e2dc1e7e072e7f90afecd5fe4f3f14b31f38caf3',310041000,NULL,NULL,'0c1c7aa19c015a67da214bf8a6ae3d77979a09de6a63621e320a28ceebdbf333','9f35a2e8a94c8a81ddedfc9b0178d7a07f42fee1221b6eca038edc16b4f32495','d98a7e2b0a03a6fe91fc8a5a51412d00b9130f0b1906238085fa917536998212');
INSERT INTO blocks VALUES(310042,'ee6c4eafabbae31087db301639be2c8d82b31a3004ed19a30a3c6faafdef5c0a363ae91e97c4cc88254bfb0d16213816e610da28233ee3775969dbeba213ea2e',310042000,NULL,NULL,'9d20f77d4afff9179cffe46574f1b2dd23d2987142c943de05e411baee2dbf05','9ba21b4c3e4696a8558752ae8f24a407f19827a2973c34cc38289693ea8fe011','5b9e3fda69ff3d175c5871d2c26513b82479e30c3612bef95b03b4d9a64cf33b');
INSERT INTO blocks VALUES(310043,'1fd0b3a1241e5435a39f816d44b6a009780a37e2a131fa7be8423875f81defa4b571a0c9b89cc335c2698dbd66f55fa333bb80e20fa2ed03d9c3e8c95276d05c',310043000,NULL,NULL,'d818e5a1a5cb6c59771b63997a8737cdb041c3579de1ecd808a269f5d72a3abf','ea9ae316a3d419d8d383d8cd5879757e67825eaba0f0f22455bdee39be6b3986','16d9fdbb509f0abe6ad2824a85e059a01d733ecdbb3d02d3dc5f2172020b348a');
INSERT INTO blocks VALUES(310044,'8074ad14f920e3bcdfe75f606c3a261e14275b3ec48d8678841492f633feb1a25c48c729e10d192e59d52b1ed5bc10185b2d0636835b05b3962e4be08b06f194',310044000,NULL,NULL,'9de166ff18c5eec97b838292ae894ce18e5a890e8a841a294b2d14894c60a0d7','5ed66185648c567cd211fa03b6d887f21854c231743ad20885a83073bf68b1e2','597f45d7ce19813ff9473721f0897baac61e97d11608d1d6e209efddaa67dadd');
INSERT INTO blocks VALUES(310045,'edbfe164803ccbc044c2d602e6ee85546a00d478e5ec3a9475a487cfcd7deef64155b201530367be15262f05ae77a8270ac8dfed18355302a01bc37d0d1d98ea',310045000,NULL,NULL,'bb3c0a260dc082534c95e894751e38e80de117b091bc0e34c66134d374b8db2d','638e948d625f063dfd65ebc57bb7d87ecfb5b99322ee3a1ab4fa0acb704f581f','c2c57a8b58f7b19acec45896093fff26c73994bb7b2a849e42a38d50ff7c8610');
INSERT INTO blocks VALUES(310046,'c1d7a9dc0c93554dacedb41e6f4e7d97b7cf23a9706e6052b7c583233632b4f3cb8596e5b59b6957413ea1da603c2fe125eacf6b2257fb2ae48de3652893eb22',310046000,NULL,NULL,'b4605c50ee3e5e2958c908e099563cf997e20932cc2370109ab50049e43723cf','8e4ef49f870af7dde396a108f4c1d5c4286a302a573c1bb1b6a45c423dc7cd2b','4dbab042d742d2548ce81853ae36a362faa304090b2fd8686793fae0e3090cf5');
INSERT INTO blocks VALUES(310047,'86c6061e10d6032dd6051842afb28b6121ba443e4ace7ebcc213258fbd8aa86136ea03f5c3eafe13e560b9589871011f786bf204cc8ac6a419c263f138ddf72c',310047000,NULL,NULL,'b840a7af6301c798c9a6670308a2684051ff8f3fb2e69bddaafa82cfd3d83186','1e61e70016a9c18765c2332d9b3e7a64e119a7dbf533256fc1b88f36c2404055','c1100a1111baa1ad9f7fb39c146b78b65c427741e91617fc1f1637a16bf62380');
INSERT INTO blocks VALUES(310048,'41f80924d6d10e6ff29f9926dcc1bc644a30d87657975c22165d4c54f8c30938b9bec93e24e7033bff0ad7e6540bec0ae0c3333c7f54499c7809c450cdf91451',310048000,NULL,NULL,'6bd591d3336ea112789ad6675a9b1d8e1578fe42e44ca7f7be5557089d374c3f','ad6559d820513781cb3bd412c74bfd5575595078e42007573a0da9f208bf5aea','70dd3957cb5dc4ea2623bf5e1d474475d525e13159cff152b77bd7cce325e00e');
INSERT INTO blocks VALUES(310049,'51e01a7614ad99af02c4171df920803ed9a88ff9a47254f0d0faf521f5f806b840bf88a311c54a08edbb9fc2f152214bb930f1b8368245c8cd263473b79f808b',310049000,NULL,NULL,'04fe1e6631d503a9ee646584cda33857fac6eeca11fa60d442e09b2ed1380e5c','f14c6718b43729126cd3b7fe5b8b4dd27dcec04f379a30f69500f2f0b2f36715','dd5b8edb0019ca4157a3fea69f3c25d2c69b3eab62aa693e8972598a0022e9da');
INSERT INTO blocks VALUES(310050,'c719b9e1f31934a3bf53ed8f8a4f59ad22f3d0481008f4a7116f31cbfcd2b71ebf296f8a6890f522c72303d63c6f6b76b802f5b93808620f3b6ff515155ea73f',310050000,NULL,NULL,'dc73bfb66386f237f127f607a4522c0a8c650b6d0f76a87e30632938cf905155','2a118b6fc1b1c64b790e81895f58bca39a4ec73825f9c40a6e674b14da49e410','027181bdf4ce697b5ba2ad5fb2da0c7760ccc44805f7313fa32a6bcfc65bba56');
INSERT INTO blocks VALUES(310051,'e88246311bb74b66ad0f97fe2f5734e0c68d0329f05a389c35ef8a8575e8c078b92b401bccdf84f2950fd884cf0c22e2079594050292b01ffc69c8e779150ac6',310051000,NULL,NULL,'e4eea2d144c8f9c6dfe731efee419056de42f53108f83ebee503c9114b8e4192','a910be4cd65598d4b1031a0afb11644daf91338b7d5714ae5f0619ed1c02aa35','a1ae010bdf7178d602fdda887c947933af3e57f2bcb89b9a859f009468a3aee5');
INSERT INTO blocks VALUES(310052,'1c7e09c9d97f26b1be51752c372a88ff5b5da358c76002a42647916b5e27d8e0f75effc92c15f034a75cab7ca8d8a9ec34c64f1fbfe8690c585cafc553add37d',310052000,NULL,NULL,'8d12b561e7cf87b0aabe000a93a57e5f31db75510b1e9feb19b4f557cc0e6604','736cf75895c6b0a0899baca213f46b5f1043ae6e774fd85c4e965363c58ad76d','f1af0e8b196a6f47d1b61cd550615b3d4bce1af8667a7668036851916da25b33');
INSERT INTO blocks VALUES(310053,'60ed831a77cedc82909d871edc4e6525de5669cc238f7b9010336b4f5c80f4eb29fc8f8f05cb9a41db4e1311f437015c8bb02b214b69cf04f909e14868ccb66f',310053000,NULL,NULL,'f47b81b3dfc522d9b601d1776fa2deef8543ca077cb0743556cd970bb119d640','b6176107f5ed5d22352b9fc00d444c4d62c177147018e9a3123a5ddf86113a92','9def6bd964910651ad1148c9e070b677df998e5fe2d89e0f7526f4b306e88036');
INSERT INTO blocks VALUES(310054,'0871d6f27552c73bda0f3a9f2557d87b89a0589ed5da70ed84a42dd89456a877d24e0e439953fff2123f110100aaf350755afe5ba6ccbe4f01b1965528e1b39f',310054000,NULL,NULL,'df191ed877eb1856d6780a717c04d6925246cdee7dd6df74216ea983560d5a2b','22ed22ae4cabc3bf271243f79c3a4d2c42e5fe86978a9f860659b2037e69ea0b','f182aa045d7baaf72eb3a28f9488bc3d0adfcccb270f5a825e7ff72cb6895c34');
INSERT INTO blocks VALUES(310055,'3edee52236cc6d3fcf0c9e108ca28515924cbfa3b9ab8d6f2ce59b1f234558ba3d50c88381fc53f0d607e67dfa8cf497f45f32def36c5a444233a0edaa649987',310055000,NULL,NULL,'4b0ab72111202b1f9a5add4bf9a812df203cb6761a8d16b5f7a8b9ed6f2b2476','fd10402625c50698b9db78754941b5f3961f19557c5cbdae9321e73a59da85af','f36a4fb85c64a4959a940ba247d5c945e33f41009ca6bbd776fe6c847b65f5f6');
INSERT INTO blocks VALUES(310056,'bd46235733652f0ae9e77cd97e22a371fb6778c023c98e49684616eee72b64696b1376ebfcc8e897ceb18d8415b08d5d8b27bb788bb1f6de3b8baf985e2f5c0b',310056000,NULL,NULL,'8e76b5be6a94e1b50ba16fe265965d4cba01b792216485c54360052e78788f20','9137c235b9218da6194b0224675ac200ce37e57a280682875b64b614d998f1cd','735e35e38481317f7c6b8b948297ad669c422747f40e865601d38da6ed971d89');
INSERT INTO blocks VALUES(310057,'91e818ef3f1425e86d13808bcb5cb4125205d61f8d063f21cd37a445269ad14f96bdc18283a12ddde8d6775bc55b2ff91c7910fd7d512ee242dde68d8d4f1520',310057000,NULL,NULL,'e14dde2bfbe4f9076b7ba548aad37269752858361af094b4be8b956c0a28b9c5','dae4bad204dcb46ea70311d316ad02fa49d9643608dd443861402705ffe7f7db','e7c7f03c38f40e3556a5baa91db4a738cdec7e564de52b39d82990b2d5fb98bb');
INSERT INTO blocks VALUES(310058,'ab68270f350c7c11d62cfe38e0b20c6763c770f9d9dbbfaa16cff8ab3d746a9b71047d4fde90c7705688b7f36ed3479a9718fb1a455cdedb5bf97309e3344e3a',310058000,NULL,NULL,'b986e5f6486ceac7f1af41b1da968e453cc19376d588d8e884439b51313d6e30','8dcaccbcaef1b98d192f0b8d62f5b371043d676401c2120be4eda65786fc68c7','ea8bae443c8df855e40e8bcff3dcfe618b1d46a1ec783b106c31e6424b10bfac');
INSERT INTO blocks VALUES(310059,'d08b01ec4f2055eed65363e748f638470b4e989c815ba93395c139de56eb925e577bf05c46a1cf2051a238a2ce1c62bb137583d12d9b5a30e3d1fe2118e50009',310059000,NULL,NULL,'da978ee5b06812ee42cda43e1d9943c4e34e9e940cb0461f0ed463b9299402d8','96de4dc34f8de9a895d1a45bfb1d72e887ac3c168f2759e9a27a892eb398d63b','81c4338c8e7197c802f1ad8716aedc5a359a50460d08ad29991f4be832ea68c3');
INSERT INTO blocks VALUES(310060,'76cc352a0973bd5cee8255c511eff6cc34a554d636ef61ab3ef6621dd0eaab17b3032e5ade33c8712b1d45960ba779974e79998b0b7738b6815ac93d2eb8181d',310060000,NULL,NULL,'09ccea87988cc385b9d2580613581b90157f1366d27cd3dc1a4385e104430d15','0595e85b26408a75ce220d7afb0111085b2e90aff588a1c828ff389b4c256b4c','589d6d7e670f0c96db995c4acf20385ed3f14e078bc7ac7e8a36663be49602b9');
INSERT INTO blocks VALUES(310061,'80a038ba3f297cfc699d7be560b9be58d8a88f4b127468e22d5d633b6b3e359430d738c20f7c5182a435bcc1a49a056e84ce705ccc504405bb70700030f86260',310061000,NULL,NULL,'4caebeb5ab6468e116cc0cf137977649a15dd30d9b214a5081057a551174ec48','5e3a2cfbf7e322f28a3254c2af408baae0578e333ed178a80cf416580d5425c7','ce4a967dfa5f4db7c546fe6b75f8fc29dc823944788587ebb63b79bd03fcd086');
INSERT INTO blocks VALUES(310062,'9fb37033c32405d7e00ff9b69272079af198e9960fbddb8dbba542b7b6911ceb833868bad3759566a7a2736b9d719ca82690627d83491ed40467e6b18830a711',310062000,NULL,NULL,'51cb3f1005127e3240721c47805d67a123afdc40084692a9cc2b3215cec99dc3','a8a4c0baa06a4304469c6b9fdeb4ba167e1b795226bf03b655ff759f0b7be9e5','0184f70bf24b7b95fe1eadab1b35cfd5971bafe03044204dd2726339d413ac34');
INSERT INTO blocks VALUES(310063,'807f83f652635dd041b0e46222d9a136099f478a5159c501735eb3a64b32d664250ec44f4668df72b1f2b8ce34ff2e1c260b6fcd87febebcc44e99faa098cd7c',310063000,NULL,NULL,'e12864a0f955320278c215897cf4f65e5c378e534294b0bb90ebd7e4b5efd4f7','d777885ff67ef99793a8cd4f4d159580efa194a505eeed1f46a7b003d74d3818','c8f710d147f338a3288556f9eebdd109a796daa60ef1ec60e53bfaa7ccbc79e0');
INSERT INTO blocks VALUES(310064,'cdfd286ed7373f1a2b525d37a903df4ac53788422414fa5fa5b408dc04d11991b3bb3c7dc7be3bc98d65c31265c01abd59f6c9f4cf6cb25c8da4a28fcc74f576',310064000,NULL,NULL,'ee27c3b46aa890d18be950006879874a094ecddd086db195e032fb4fe12559f5','e6a5b1e0c2bdf548abd1826994529d5ec68310fd8a74e05ec5dde281de52ff9c','22cad399931fbb4c620c887b3dd0f0e5284e1ab45f74900b7c4706868ca2c936');
INSERT INTO blocks VALUES(310065,'e971d529b30e42e87f399558d975181220fadc9b160b37dc5fe82752be193de9c7022dc509061f99158c7e585799f336ea3dd8fe63d55b57772af676e91108c8',310065000,NULL,NULL,'d40dbc4b5faaf8918f9cae54e5a247e3904dc65994ce0f04f417c1a595404464','7ce3ffe967f502ba033d3d51165e754b77e6c4a28cc4e569f81cf0a817c1536d','e930bfd4b6eac1822485cfa3953c550525ad1d1a6ba5177677e481fcf24edfe6');
INSERT INTO blocks VALUES(310066,'0758bfcf08b5a8eb40e4937fd84fc69458338483a8471865b38fa252d8644be6c22962996b80aa3fb37db97f2e2a213049c9cb356d8564d26fb1ad5de14ccef8',310066000,NULL,NULL,'19f2b00477a6fae0e10f4693d949cb409b1ed74ad20dbd9aa4a7f1f17cb813ac','2da61818fd2c6fc3a15d998ba79482cb48c49f5a9f195ae4ddba291cac9b416d','e6de9d8f4d9c0a5ec3a51ab0f886f4fd35fd9cd8d1bb6afb2b615b58996bb26a');
INSERT INTO blocks VALUES(310067,'359caeb095b44b88cb86676c4a94ac830211c31e25c326c9c75e3ac60c5f28c1ee7387fc46ac6ba2946a6ce41a067637047ac4effb32777dd9f694ef1aa88ef2',310067000,NULL,NULL,'d72891c22fcea6c51496fc1777fa736ef5aba378320a1f718d597f8f9fea3c7d','72cb3676cfd73767e4499bb405f6e07ec421a39239754d75afd8c08cdb49ae45','2e750809d79b40966d2533d7d726cff2b802cc2678244d3e235508750ca838da');
INSERT INTO blocks VALUES(310068,'2f1264342a2fd66c9493f2fa062cb8477ef86f72c532149ffd45353fca250a9985c027d7ccee2e646c96533196f6dd60ef9bcb12b3f156dbe71edbd088418487',310068000,NULL,NULL,'5793e10b8329d3ac71aed6347dfcf61fc7b74ca162ad99918f5c20065f8d0746','07a593978e6f669c9b378ffd115c951da48fad08b55a7d5adb7ae96bef306061','1ed832c547e29ffa2cb45660129f32f56613d2fcc0d36dbaf3872ab47e77f582');
INSERT INTO blocks VALUES(310069,'b08114be39f1ba70cbf72cf9ac4b008d8582dce4d4d7c789e7da57eb264fab24fdeceae387dbb23d5dc0c73f8faa013c5a499ee8d2761b959128c9694802230e',310069000,NULL,NULL,'61040e7c1a58f41d708785347f4985c1fb522b6f947d3e14dacd91157e153ab7','4822a18f5a177a8a22f1b234c181389614489a33ebf3944b1107acdce0528bb3','6de08d8b4df6538298c2599a166548d12175ffa9a7db682df4111e03107bfd22');
INSERT INTO blocks VALUES(310070,'5f1384e1063f3c21946d063c75dcb43a6ddc4642eac6f79eee0a80ea99320bf8b26ecf86b1e79889e1c733cd278219e76315130a30b440d84cd288be58bf3853',310070000,NULL,NULL,'ce115625fbda90a0f261b2c524108a7393078cb4c3f861d6d7846501c7960008','54364047ce52153883e68adef9b681266dd725f8e45af89b1dcff3c9edd525e3','5f53766a278e20f6eb70bf3b8786d4b3191a0f76358a97ad89a2dc901cb3ac16');
INSERT INTO blocks VALUES(310071,'c80b492818257e806e4fbe093c89c7965275aa8e36d1bb888d1f79a059e95dadc40273e59de99eb8d80c5e8e1445509d8baee4c733d2c470598620f3048cfafd',310071000,NULL,NULL,'3c2d4d81e90a42a0c18e9c02b8a59f99e13f2a084ee66b4b1bd410077adc383d','08991b69e486f1032749e530eee24ffd2d849b1f46aa6ef2f2d5a5202fe06e97','be328287331db13c6a631277a635da9c87768946ac8380ae14fc2fbd5aec6303');
INSERT INTO blocks VALUES(310072,'64a311227b25fe4606729312295546a9ade70637e896cdd8321257c0b173e38701be1e5bfefbdd2cf1eb908d5076f2b464c8664281cca6a9d9bfd715ca085a93',310072000,NULL,NULL,'8a28e33306582346f1d965a0393621b4aa307f6614c84369064465f95a6c727e','e0cd2ae87966825b5f8ebd21c7629fec5ea6ae0f0964ed137f0776d2a1130696','85c6c68b477ddb33e954a67c3116e75da8012443888ca1638f471481de4c899f');
INSERT INTO blocks VALUES(310073,'acc6dfdc3cf0651092a08818eed4eeaf9abfd322f1e46bec97e6a8ce96317612d4f3873e194310f1335da4ac225ed92b1a59237cde4fe1d2049be6a2b66c1f1d',310073000,NULL,NULL,'e6c5b393a21df54479c4cd8e991b37d877794166c19b9f61ad7e47eb34f63bdc','4b2ece53331a483fef54d87f0da7e6f712148c0f35388439b73f2aecedc57a12','994a079c0bb105d73fc0464453adef90844be7be0426ebc47bbad7bef29fed83');
INSERT INTO blocks VALUES(310074,'a00f647aa4b5d9142500fdc7da95b47c60c0affa3275cab56a875b1e082fa8037b3c32e6a002f92010c2d8bc1abaad10c2373fbd246b59e69af1e97df5c3a3f2',310074000,NULL,NULL,'b2db452daf280f1cc5f02668d0cbd33732a2fe9f04307d9c072eba97c95acf5c','28a44c85c432e94d1e15ad9675d2927a983bcde0ad0cbfe47a7d87da00df9f66','252b3e5ce81eddfd53c6086a2aaf6630aa2fe15f3c55b364c4b8f586f4228eb0');
INSERT INTO blocks VALUES(310075,'53035b827f91f83e75adef2f62607377fcffcd185902cb742a72d751e4d57e0432562fe92b0cc6f7221ecbe53ced6aea685ba2383dd9e2a78fce462778b75010',310075000,NULL,NULL,'09998443cf1cd79e193a7b09681ae07ea9a835458151a7f8c7d80a00c5d8e99a','398cf0362d19717ca11dd2a5f022a1ec94122f7bcfba0c4f25a793826b1a0892','6a6f7117e0c8814d4b6a7245b8e9719dbf727738c6efc5cd81aa7071dd50de53');
INSERT INTO blocks VALUES(310076,'98867155f362ec51c5d01c1ee81fec7c0fd5bf08892df7e78140ca21c443c084876793d528480ef54ea1e185fe435869dd7dd284119b92f4a3f63d05173a6580',310076000,NULL,NULL,'a0be1e88f10b5214f7c12dd32d0742537072d5eb3e54f9abf57a8577f7756d7e','5a17953bd90e4ad629cc7c24098e50a5ea86e84a5796b5db5959c807e0f9eba6','f3bcb0d573f3e7505220ce606a9c6896ee1a32e71fcc6d138b4c86c7e5095a8f');
INSERT INTO blocks VALUES(310077,'2f9ac5c43c034f11cf28d62fb787f8c109662e4187b8af0d7dbd81b524f474ba9f4ab6bb6a36ce44003839ba82f7018065499543c9e3b4b1be0e96b9d56cd9d7',310077000,NULL,NULL,'d41e39038756ee538d9438228512e31b4a524bbd05bc9b9034d603fd20e00f05','0491cd1f3f3c8a4b73d26a83aa18067ec31f868df96ed4667f8d4824a768a4d3','81928269ae8abf6fec03eb3775ba5b2292de5f14a0b75f780e705c973b88871f');
INSERT INTO blocks VALUES(310078,'5e535d532426974fe1c45ebc463ec7a93fc3625a5da33119975481c4c98ec8ad81ab13fcb7e8943ae4fb26b41aeaa7ca0f50fa22d16c7d18e5deb3820e96df1e',310078000,NULL,NULL,'996092432a2d94df1db34533aa7033e672fac73de5193a696c05ae7c30d75247','ebe0a3e1269a54e03ae9b7b8ad5f00a1e88b4bdbf2c7485ac1188eac31c0a4b1','ea1514429815a58d3b87a8358d2f7171db18db6a308b31a22c5dcfbcc36fff92');
INSERT INTO blocks VALUES(310079,'e41a51db594c3e7919b4aac63e6100a092461b81518721da953a476986f5bf8e29085cfe6a08ec452fa547b704c4c4eca957ae193c27281dfa7f113a0f6df941',310079000,NULL,NULL,'e3f536e930e39b421e3a0566eba6b8f5f781ad1ff48530a5671752fd3eaf35ac','8dca0f21abeff518ea5c6a0fff3f3c89e0d6b263a72adfd36cbf911a306080f1','70b5ccd472fe0afab81fd3cfd7a51a2f384e7c8bb03bf0b7e8b598c999893e42');
INSERT INTO blocks VALUES(310080,'fa67febda99884d857fb9bba17476225a600f76535a9431d21c261662434b85b9b4d4ce3cb591d043f80ebe0adaf9263e0a368d949d291e14778b46d07dabe91',310080000,NULL,NULL,'57122dc41d7de2bdc65002905617c357496432fa4d80af48f4ca69ba1332e634','0ebd79095ee1e751b4b694c04d31fe2246db4558ee9763504c9802c2a342e817','f8c3dcf3dc7daad074cc82a00eff3086bb6ef8cbe063245446d096b20dfce677');
INSERT INTO blocks VALUES(310081,'98a5ce8fe941cef091735620c3119d97a382b9c80cc1764d1d30c94300037d0e519063378746b7edbfc60aa506fc04ebd539ada353534b7a5b3d621dec791da9',310081000,NULL,NULL,'3a0fc7b2f0396d257a0a5c5a313910cb4073e4c79ef8cf0d3cd12f494e563105','2eec4afed90d334123b8299d50c192db4b6b7ea0f4868734ea435e5f2cd7c901','4cc5061efa8f9165f844f5ce14b6dd0602f15027dfd64dff653f3785659e434e');
INSERT INTO blocks VALUES(310082,'7702f9604bf3efed6578761f4c52de99779c7c42d7543774d425a4c3537befbd2e7181355f8a1130d3d8ad9ff3bbeaaca4e26cfaefff15e575ac4b2eb19b7051',310082000,NULL,NULL,'e876c406f682ed6f0dbd6e4c97bac13409cd400b59e894eebeb3252be306494a','91c5071bbab5368e2338657982adb58c861546c0c0ba9fe9abd6b8b781e415ec','11d09e0d0361dedfb42e1c7a15bdb6a190967a5d59e833605bd6c4a145f6fceb');
INSERT INTO blocks VALUES(310083,'f190eca1a75147eeec93cf96f106e346b908fc47e6a363093d5b229901bd58fb34fc8db82a8feb2d3dcbeac0c901ce98378f7e1dec0ff7aea7235c6d822a62b0',310083000,NULL,NULL,'533fc3eea80caa46cf8fd62745c5d21d09f32b18eaca70283a4bd72924c2100a','bf0da4a320545ab08a86a86a81d5702f7d493e6c3173344dc19941c8a527f4c6','735ab4d3b9692aab21e75948c17a197d1395bb1ec579e450b7be53b389b3e7a1');
INSERT INTO blocks VALUES(310084,'d15e3c53c8bad6d8a4dcbb870b622505e4dabe8b3d3b7ffac8aa4976cdcefc91fc13c1c1a1700d7417e829310f9826fbc82307636fc3f95bcce561a8dd8f7ea0',310084000,NULL,NULL,'e3fd22f2e1470246ca99c569d187934f4b7bbb1eedb9626696cbaf9e2b46253b','ebd03846d979ea8af53d9853c2b9ed94bc4a89c1d554cd5d5a2557bec8a127c4','a44994aad22375af3e1c2742179fb71538aa8401e478ada17328580f9675612e');
INSERT INTO blocks VALUES(310085,'464aeb24455523d820981afe0f284487ec0a36b1388182f88388370811c394bc18686bfe2b8429f7d37569070f13e95952e877b7a84000c6c0e769e5e76cf437',310085000,NULL,NULL,'bf04750fe13f663adb12afd3a166636a4511bf94684a77217de1bd7ef9077d94','00e86699ae5a8450e0ebec24deb4932b27686e436c2cae3eca6428a7229edda4','99b298ffc6ac4a1d80fb65e89584a98987abf2b108051e48a233300a0ef90b32');
INSERT INTO blocks VALUES(310086,'0c1d3e5b62d04ec82124010d58d052a0a2f9dfb71684580d0c5a8d37e286768f5eb4ce31dd4a677bbbf199d47ee843ec864deae51f4b2ca29d765015748b5742',310086000,NULL,NULL,'a0e8403085ba63ba72432f27ce8125921ef24742f988ab7f85dd8e4309f27a2c','8db72da41c05d03d36307441dc8751f1907da2a60e209cb7ff47e99d7b22e88e','2e57b42191dda49cebd61f4146e0a5d47dafc75da5441e6db9fa43ca024dcefd');
INSERT INTO blocks VALUES(310087,'799dd8fedf7036eca0b8298ac48c295690d12f9c71aa98727c927a6cb0224c62433ab878dff483f6d2754bde36f06fce594bdb06559c1d1a0a51848bfb395419',310087000,NULL,NULL,'0861b02e980ad5958bd23ac02603b132efd72ee2a70dbb0415fa5d39cc524681','9c9e3ae63fbf9180a1d17a19f47f77817eacc0aec0c031bb13046accdde03799','d5eda98454ed499fb8a7f49c09d28f60ae20c2868f519af70303206e191f44f1');
INSERT INTO blocks VALUES(310088,'8e1e809b86f3fbde2cabe6510052084ec68d7857c34f8dd334c99e8aeecf32ac1669f2789aa41acf3f33119c5d0aeafed03d8288765c178174a8db27887c22aa',310088000,NULL,NULL,'d52cdaa449f63f6d3abc79080378855206f91a5db865dfaf37a5a2529ea6eb9a','0ea167598525f3a88c6ab4c8f5138a41ddd7fc8e13338fa24706b9a30337f223','255847fef16d7e0a5cb78205cbcdaa9734ef64485b395f3a661230d0d23436fe');
INSERT INTO blocks VALUES(310089,'9803c2ce201e643165ba86a8a739ec73a05f29d23237d8d2de56f46f417be665785871d0d36cd3146f999d0252635b9ae8a3dd86f597b1cb59cf6879e116b5be',310089000,NULL,NULL,'d15a7a60b8bf8618667863b3e31eaf6202664e5aebc16d1f7a337b857ac31f90','8257d7e04e5813b7e184ec5b9bdbaad39c779cadbaa31907a8b52ad8371b5d09','5bdf07ac766cc4bdbca99d449e6758d77a9e4c3b680ea0460967298c49091836');
INSERT INTO blocks VALUES(310090,'1ea5f2b04b763909ad541951a0d21078be9d08e6bd7a23499ea69fa4ee8a67f02791404da26f6b64ed5bfc0bed66c28e4e98b703d7466f96311c5c838ab6d9c2',310090000,NULL,NULL,'68475dcfe8252c18501fd1fef2afa2a91d20b92cacbabb542c12f43403e66ea3','dacabdd06a6ad7c50a6789bde4cbfbf5cf3d85a1e3b5d3621e0e93cf743ccdf7','265c44182c4b94a6a94f00defb701b72151830dcdc39c105039f1b86735559cf');
INSERT INTO blocks VALUES(310091,'09f4ee2e18880732c0ac4f58e012ff8fe9223899aeae5e051c9796439d98570637670e0cf50c0727e3017287f268466368c550fdbd3bd210387615af76c0a515',310091000,NULL,NULL,'5d584f255e5bbebc32c78a30fa816e1203fe7d3454611bef9222cdfc91dfcb63','1b382e2152f884268b32811171913ac28e7a1d40b6eeb6423b6a807ff417052b','be4ed062b28aa5e249dac7823e60344b07fbe187121386d061dc244a8406343c');
INSERT INTO blocks VALUES(310092,'ae270aca6bf2998680fd12abfdbd158ee5bfb8131fddbe54f5466c6f7a7ff114517a253f8756e13c2bde73e9b851ad2b24ce06bac2086ce3e240331bae518a2c',310092000,NULL,NULL,'ef992ad033b047b7f6ab038604736f444da55be187834f8152b173cf535c68eb','d3a42c8de911e63c540c541aca141f057a06852f519e89491e25cda63480c442','3b63f70bc2d208d99717e630c93b508806b85d84c0b389c29226503e443d40ce');
INSERT INTO blocks VALUES(310093,'2c950816e8a2e9c29fac064891a58465f30a62197864d549f856157c223a1f78f1e39f753e792f64b48c500d77e47602093941df590450d21da55758f81a659d',310093000,NULL,NULL,'9cdee996d0e67ac3f9f283151b428ac5f223b72590965f41f93adcece6b88f2a','5e36c495f7310dc1815a73ab767f53eb04fe517eecc36d8ac9eedc2c1dcf117e','b9be6b071b8a2626675a0b18e8d0b1024af4bf3ec19706c1176c17f87e3e9445');
INSERT INTO blocks VALUES(310094,'c7eda9512bcac5c3b73e17923afdce541011780a51f2f59338bd91f539b223655a64a2680972f32e340a268ee6dca4caf0ea6ed8ad02a3840e5ca7075c6cc69b',310094000,NULL,NULL,'fa25dc3f15fb28718d788f85373555966251f54bc6ed1f4dd2244b438d27b281','296aeb138c815e74a0f41e87ff2f463ac32dc01dd3d24da6fbcdf47542319e6b','adefbc319f56c50c4afcb1fbe42d5dd3bef88531c07aa522509c090504498c79');
INSERT INTO blocks VALUES(310095,'4ff3aa594932ca9e13370bd1a9fcaf0d07dcd6c28949afda5fff201a876e77331c483f93c8fc7295d3c8eb0d4ed3d4f53d062e17e87789392db93bec453cf1d2',310095000,NULL,NULL,'1ba8cd971f9a169d43b6de1a136cb8e6153649fde1f7a8e7fb2f7de926fdf8b2','17b1f9d5c3426a4edb4734657cba1713f9a56991bd1b78669142ace96327d357','373887ae39db4493a059faf7901de9504168045b7f83c9911a5446bcd0e35b3c');
INSERT INTO blocks VALUES(310096,'7f6ebf5b7e09d78febea9dce370ca98e1a00cd911b6ee8b4c1f46c3ee5e54754040ae2e5443d5e53ff2af3b615b08063111b4876e034ef31c9ec0f5e75695772',310096000,NULL,NULL,'42c36df2c53d762b9b132e622f52b2fca99bc0370978463acd22cdf6469587a8','6d05d09010684842a6048d4a70e1b08e22515caf58bb41cdf4be8b0643e6a788','3a3601a55329b1175dc55d3c85574553dd2a3349602bccc97d8b36b0ac1e661e');
INSERT INTO blocks VALUES(310097,'e44698e52e70ebb58d3d004f8eb4943aada1835e5ae673ae54f5a62231df0f0fc3a68ece57823e624b4f365ce199d50e35ec15619e508f8cbf71134d82facefb',310097000,NULL,NULL,'d96af5cf3f431535689653555c29f268c931f9fb271447aed050303d364f92a8','e713310f3b49ad5f4a7a33edeede88ebff816f891ad3b75a971d402c470adf92','1734705bf30b95def63d9eb7ba430ce2f3a09b64414db512cd88dd06c1c078fa');
INSERT INTO blocks VALUES(310098,'031441b70e39a3d6dcf5a532eddb405d5abd8d723029ca8be3cfe400f0e4fb012a63d859e610eb48c7e41c4e80768e877321e92f8ff406e700d8c161e8a3f4d2',310098000,NULL,NULL,'153c9ce12e8d9f9d10c4005fc9af158613480d38b2c6551fc49bc57380c229de','1300dfb9b2c5511a312714c5679e956df96f6556b217245a5af1696300b1183c','22e30bdadf26a27de152119217e8e34efb9551f8db1fb77b02d62cb0c741c351');
INSERT INTO blocks VALUES(310099,'2456675ed07aaa79602718040e1f29e546938bec8a15b26492dbfd58d5388ea21ff3440ff29138f4e2cfb47662ea3e4e50476f7280c0e58b51b53bc08c014fc2',310099000,NULL,NULL,'49f33b269d717b56a399843cf4627449010133b47079134b9e299ac5386468ee','f8c5bf3169d6c75d82c17e0567207db18fa4326b173fa441f574cdd4910e41ab','c5ea44442beb863638bc18a58c4010a6d58a944ba347d989b24277a11bb79617');
INSERT INTO blocks VALUES(310100,'b9b9a79de83063df4410925030cc3710aad6999f8ca9955305b477dda2e3777293c7ddd7c4eb6e9c3f2aec2e23e2415d0037dfcaf61a52b351ca564f2cf1556d',310100000,NULL,NULL,'c9e72f7db2950f0b0e6e8fa3bc47d37a0d643da6ec61b236f7224b63ac60467e','42c7cdc636cbd0905f3bc4479d1a9ef6e0a5905732ce78e6f3cd63ddb2c5f971','7f3efc399d7278404aaa1293c002c06eb242145e5c2615a96d3014e666c7e7f6');
INSERT INTO blocks VALUES(310101,'e8a8ebd85a460cf5987683360a1c77e6728b4e59027220f8eceda05c720bc38c91f6193bc43739da026cd28f340e1a10b9900bfa3eed11f88339147c61b65504',310101000,NULL,NULL,'a4387c8c785a8407f2dda176a7e182617904e7ce00c695ea8aa2f9d0429d9e74','a30a1c534bb5a7fafd3f28af05d1655e9d2fa4a966e420716ca16f05cef355e2','840c0c140e7dc809919a4b6bd3b993bf5cd3973ad1f8894b8f92d41199ae6879');
INSERT INTO blocks VALUES(310102,'767209a2b49c4e2aef6ef3fae88ff8bb450266a5dc303bbaf1c8bfb6b86cf835053b6a4906ae343265125f8d3b773c5bd4111451410b18954ad76c8a9aff2046',310102000,NULL,NULL,'fc81f97474f7b35ef92ba93de82d38650a28afd140d3320e6f6b62337cfd1e94','7166828ceb34a1c252e97efb04195e3e7713ae81eda55adf1a2b4b694ab05aed','a8fff4b3df42c88663463a3c9ef10879dfe5ed2762fafb257326f5ea5402d2b9');
INSERT INTO blocks VALUES(310103,'e9041ceed8f1db239510cc8d28e5abc3f2c781097b184faae934b577b78c54435a4205ee895ccabd5c5e06ff3b19c17a0a6f5f124a95d34b3d06d1444afb996a',310103000,NULL,NULL,'621d7bc1c1a88fd5b06428f5013d0c1b9308c53c88b67095b988d62bfba5f2f9','23291b093146a51131451dc8a7867451010b49be165d6e940d4da8542e4ec6cf','012d9234ce1212a7c5619812f9749e35b95658bc4547870c4448ce8c2e52e858');
INSERT INTO blocks VALUES(310104,'04faacf3df57c1af43f1211679d90f0cb6a3de4620323226a87e134392d4b8f7fc5d15f4342bee5bff0f206a64183c706d751bdace2b68c0107e237d77bb0ebb',310104000,NULL,NULL,'299301866401fec722f69818e30eab4f462756d88fa31b7a1467d714e4000c5b','50e01fd928ab9950973b3591807a08382cf3fde39d85e015ca8750017ce4da35','6938b0786f763c6059fe6ccccfc45b3f3942ec5b2af8a81d7e1d9cecf364706f');
INSERT INTO blocks VALUES(310105,'673579ef7bc7828b4427a7144355901327f4cd6e14a8ee356caa1a556eb15f88d6f8f599556590f9f00979dc4d4cde4ff5ea7e2ae683e2a14706fc03aed8ecbc',310105000,NULL,NULL,'e7473b510b226b987d0c4986052fb2d9df049ee28b14b2f2a1ff8d74d7754bce','ad940e1096ab5a8b39d44e7c248cfb25b0459c48a6e02aec6c912a5d636c3af3','7395fc1295853a7d380a6358b918df680519422f912d52097a27a1d0e01a78a2');
INSERT INTO blocks VALUES(310106,'8dc95e1d0fbe11694812b71d390ec5ca5058fb64d34e2805273d5d71286865371dd1ec0584e6ba1fc0b9b09f1d43f9529ac67f134fe30685f1962abeb88fcfa1',310106000,NULL,NULL,'89404f13df834d0ebca9d36d66195d2fc92a88854ebe2009eb9248624f85dd35','101b971ddec5fd1fb3e90aea02af572ba9b6b2dded13c1fa62f86aa2a9caa288','c5fdb2b249affc85d47e22deb7279f645508b4ed89c643c34d66646d2387687c');
INSERT INTO blocks VALUES(310107,'535b56c056428600fa79bd68d4476504453f02fda130fe45b3f7994298801cf0791cb1a858c3d3b90780941a64e5e788e828032268e3e94134a7fc05fc5b7c8a',310107000,NULL,NULL,'6ae2984b5a9fb814fdcd539c260f675b9186dc2a1c2b37463ea7dbf20fc161c6','eeef5c003d69b8765d11c88ebdff2a417010b1aaaeca4a227d5ba865de249b28','8c3e0bd6a1e9a26aa3bff04fc00739c7832833dfb3498677d0b812526762b293');
INSERT INTO blocks VALUES(310108,'ede71647f0714fceb0edf6ccf71302ab49c3f2ef88e6729bf71a158515213aa97a5226eda7cc90763b5e8a876107f5e2db0ba2897d384acf830068ac0d7db43d',310108000,NULL,NULL,'a4e6f59d87a069a3411bcf503453dc756a6ed3d55cc936395410c47aeb2a3dbd','5996127287a7efcdef37fc76f4ec8744e71a09f9dc0b4e26eee208ec6f71b61b','b313d754d90161f23f6b2ef9d352d43ffb5513cd6ba1d91bc46dbdf826a2fcc2');
INSERT INTO blocks VALUES(310109,'fc403195b5fbfe288fa26dcb56442157451584ea556d0897f9d29abf3f94542d6f6604e48e2f647c56c5fec222b037e0f4589851935c106ae167982189f37459',310109000,NULL,NULL,'ef7c2d079e1aea977c4215eb2e0511cd254a1465abf83175c85b6ae264889793','fe511436f99389a1036f46efdb3cbb6dc541e8009701eff0bddae5f55a349450','123b469ab975660a17fc9d18f61f4f2c1ffe90f5ffa48d0753ecf168e6e60774');
INSERT INTO blocks VALUES(310110,'707c243a03e691b170b6838183e2a5a710b77c30db606babf8e347454e99452eb50e0798723a5ae3ae1c87e7e417cd1b8a5d6478905add9dfd1e2358f33160ae',310110000,NULL,NULL,'1f3f601074854826d177b65665d580cee3685d1b4c41cba21d5c6a3acc1ccc7a','a302cd506162c1b7cfe5a747913e591041e456bbc686fe8a9c45672eec7febb1','8ae6199e4bf642fdbcdbf34be435203b270dc87ac8e2dc3f6594acf49e559554');
INSERT INTO blocks VALUES(310111,'b423715bbc02048a92a2621b4edcabc2570780739d4f7e9ec1f584cae4ba76b945e4cf094542dae1699dd411a4e1d5eacee9506eb91e04fdaa98404c8e4a2b8d',310111000,NULL,NULL,'0e2c4b38e8bbdd425d7242122e6906c3653a3067d17ec581ffa61f33f8aecc3c','8565e9b0d7e2d0a2f8e7c72d90b6641e563fc43600cc694a1e8ea95f6b18aa8b','95dc96e7f518108ddf66e7d5a2717e71803d6e8a18176cff9f1f749600fe2c21');
INSERT INTO blocks VALUES(310112,'6760a191b0e17b1bd256baec1b67d9f140c7c27a69bfd942fc2afab8f48ec22b4df69f90a71d10d1788b0ccc4899ad9a63e469f8f53f59cb62cb6a16139acdc3',310112000,NULL,NULL,'7c235073ec219e97420908715f08bd86da9b1591020a8807eaca36924090b079','7b302dcf3377ebaafa6e5cbc4b4537436b3623332b8a0d8148e1471dced8c1ae','d0eea2185f0149810516f3a5cc2bf535c5c90dcceb8a662b563cb7019575ef36');
INSERT INTO blocks VALUES(310113,'cf77b91f1337ff1dc93d7aaf73d7ef331dc2535be1de5658976dde55c9a94ab0feac585aef5e3ac026d2e6c5549f559506c2fcb2ae21ff5449606680288aa497',310113000,NULL,NULL,'0b86a761cc35af35677bafad039b914ff1fac4da823640e0ad2534e868f6e03b','c7b395c12fa972a9b04183f702e5882e56502295a788497b167b844c6db501cd','c572135ee6ed8fd94842c1ca0d03b16fd160dcbb4e560f7381f02869d482c54e');
INSERT INTO blocks VALUES(310114,'8c68200b083c884df430e76d42c61d47dac48bca18654ccd47b038a8d7d9e33b2f441b1999ac8d1ac682f20b87fa9b8755baf5a4db166fdced6a3fce0fe789b9',310114000,NULL,NULL,'afbf9898bcbbdd6c5bd68cc796e9baffd90794c4a1491bd84205f221a3a2715b','c33d23b5dd12c5718d7195d2d830482662ff411030b3df1f93a4af2a29594b4e','a0e8ebcecf22834f32f8e497f7a4ebf4e06926fd1ae2ec5a74e2389ea2850741');
INSERT INTO blocks VALUES(310115,'2370375d3fec89376c52e133138e9841c075ae5eaf3fcd794ae1499f7d72e1f93bae1858173de978c00f98610c442a7704686d38e9db4ede80b3f6fee2df4f43',310115000,NULL,NULL,'c97ddbd7ee02ecabc35d8327cb55dd803e0b1c44080ea3c20be52337eb4d76e1','6b14f488c5a63294b37f5ee2b860d6e9d67e39c0933dc99bd366d21658bf72f1','f3280bf94f3b28db7d7a181eabc0a560db01fb5feada706dc4a2021c9b041af3');
INSERT INTO blocks VALUES(310116,'cfce2e6c2f8b60cc702ed60cf97c9b7d98098d114b4d752152746015d19232e8f11bf72d7cdaa8cc243ed6121324c11867efdcb46bed4751e3cf9310a39c7b3f',310116000,NULL,NULL,'0b056d00dede32db49d018035f141eac6f9130af47dd464417c228b13134d77d','e4c0e9665b87889122f0b3effc9649281418eb04ec7e8dddb7be9ffd601bd6f1','5e329aa99e22f6a7ca3354cd0ee7e320579de20e753f4b8fb70962fa76bb9860');
INSERT INTO blocks VALUES(310117,'3d1a44b687914daf4356fcf281d86d03750fa8f6a8a2a6141361c5eab4ef4bbfc2346edc1f2fba57a9a41470a0b27886e476538cf32f189ade32b865f42a47dd',310117000,NULL,NULL,'0bf995218c8b8f4a29b8140bdefdc81928eeb2ede693e3c480240fa78d397a9b','b557f93169969623c38c0be39eb1a26ab2c3b5050827157a2e10301ceefed07b','8d034e432a1f7adeaf58dbf8aaadbe88960a1055a4cf337292c09c9bebe062cb');
INSERT INTO blocks VALUES(310118,'8c5d5deb80a1636d08cfe600073fb827c7bdb08b8482b0a44efb9b281a4a6936abb870788de2684eb33eb2ea2b815b16ad2231294785b3022da6d410f7b52bac',310118000,NULL,NULL,'9df5ea46301700ec03d454d49fdad1f614ad36647f137010062287e40357fc20','6bfef4b5085289d3fdc4bc1a30624c75fffb073ec9f316f30c162517f4e00113','10226974f00327f70d93b8829b7084015b0702076da090522d3e14b0255130d8');
INSERT INTO blocks VALUES(310119,'8b21c9a1e6ab073acbe81e671626b89a7695ebc08a3e78c52a151794b5fc11f4803fea6423656acee2f39f6bb57626658448c7ab20058c526b6925e551ecab29',310119000,NULL,NULL,'9f5fe219e24f0e2c606607b08ddfe6ff318cf92b7c8e2daefba69ec5fda17dc1','16699da5b74f4cfc1f85fa1bf75c77e7875ce332305242ce1c7cf8360fd8acc6','4200a883e46442d7e9300eb5da3166048f47fff1a43b28da529fb640c97ffc40');
INSERT INTO blocks VALUES(310120,'661cf8375cf1935d65ec4ea62279c9e22a7ac258698618736f533570c82e54a84f5f287081a9659b3dd37355c836b2ab1b7e6a53b489f908218cf04ffc8e487c',310120000,NULL,NULL,'e8db0e75fc80eabe77c742ec32e8710627840c3a5e6182d598a832b1f60f3d8c','d51985441418e86580d208a82f657023221356d8b67d7d7cfc2b64339c5244f4','388025e4aa1bf719c7a3ba6efec16fb5ce62dc0879419194694f1927b1eed760');
INSERT INTO blocks VALUES(310121,'8e1e3aabb4996360c54be971cc22407124cac14d9790ae67a9b970c1ad8ba878c985f44e0c97f5a768a6b2b60a683aeeac9912da0f8331be3fa8376b75da2389',310121000,NULL,NULL,'7b6ab78d3cf5f6b80e3d57d9c228f42edcebac3b6f9488b374f976d80f59e417','90430c153454995d83002627c9b049a7fa289223004d8a2c8ab82c50c3a8fa95','5dc53c44991d2c3e397ac009fbb8dfba5c5dc6f6ef5f91d34610fc68a433a934');
INSERT INTO blocks VALUES(310122,'dc61724d1d78c8d74afe0303fe265a53d006f5d13359866a24fc3118981f7b1640b74f095962a18e06b52a0c42f06607a967c279445797b0d3cf98e8bdeab57c',310122000,NULL,NULL,'2333ee1f62da984edf9558abacec104d0846c7a714606e9ff1c226f68ce8f406','f459eb4a56c0ecde9ce4ca8d8a7e093c8d2ac9becca71b03300807de1eb66c1b','859aff02db53be3467ee10c16b133259f4ad099c882cb2c04bb346f382f8c3da');
INSERT INTO blocks VALUES(310123,'90ff89086d736fa73eef455380343e90a24de73f6a83e2c4c348f15cc716c213b17d056f04618dee8bd817abc0f796fb1b491f7e662ea8245b13c7246c492d14',310123000,NULL,NULL,'1b2c38fc309b465fab50775e9a2e1c6752ae97da032681e637d4e3e799218d8a','bd62cd49d49d2622b3f653a1d6e2ae3f0c39993388ca5517fc7664c3e1933ba4','206489865cb0aa03242e0fa3865f1c1d2425ba26c9abaf7415783614fbe78949');
INSERT INTO blocks VALUES(310124,'066a44937852001930b432e453c19ca9f2cd5f4264c012ddd83b99a4c48a55458ab7468c4531268cd61333ded71de3a022f9bcdcc60360db650aa84b2ada07b9',310124000,NULL,NULL,'37d766669b0f3b213a88b741001502f8a758ea982994a9b7b7d27e2ef3e6e73b','06d9c420cc6a6f8194360aca310f05039161c6394281cf13a1682938b29549c2','52f5a863c140aed9b5b0a4f1732a8b3a83d4199ffae82ff444e96bcc11de6cab');
INSERT INTO blocks VALUES(310125,'8685a21db54d31658faa3da162af3f2b55ce57ed8ef63986a481b6ea81d0ae7754a9f5d85f08c84dc15039fbb0d3e8e9384304ac72f45be96ddc6963da53918c',310125000,NULL,NULL,'deb642fdda69158ac536f4a940a34e9fe6ca8fa6190eafc34baf6e061a45d8bd','4cf18a5272292415e93b05badc3de8655737a37be3b2c7573bfeb5b8f20026f8','e188b3b0aa51574709ae2fcf2ee14651c91aa13d73cf613fd09646438b618df0');
INSERT INTO blocks VALUES(310126,'00c5864e2defa283e09b07f5a58f3821372fb58c704506931b8674d45e4d00d5c216404ad13c5bd08c76f1fe1755300246a9edf5aba309cc23f410529c2dd6a9',310126000,NULL,NULL,'5a2adee93bc1e259210960a2d77678828166e4bb4d9dbf3c5bb717f43db9ab47','db85a6054de34583d8e0d3794f4b1ac00c3b7a456109c33992869f4b3cdee5a2','f151ebea016543c4f15bb79dbee1708ad1d342c5fe7863fda39a030fd3698d57');
INSERT INTO blocks VALUES(310127,'05c44407d5900c1193f814ac29f41fd240da577ef0fafee0cedef102651997d3339530f754f24b9abddd1fdc4e315852b4c2b67cfe59332dc0fb35304940fd43',310127000,NULL,NULL,'26475ac0a210cdfde4f4305c2f55ffa526b5dfff67eb2cf0b8ade77d4d690588','b09738b660255c1d1b70d7f1eee7f054ec44d813b5c6ba4001a153ec8b191928','13b2c80dec5d845611a41a7f360cd618114d1afdf3472903ad44aef2c45553f2');
INSERT INTO blocks VALUES(310128,'e1b24508763706d437cfb5ba878b8feb327e652a34d32fde7dee5c161d03db781ef69ba700eca3daf4c9ecaf2ec3070c63dc80fe86e8897193582f6dddd6be66',310128000,NULL,NULL,'2eb8251c9bf18958d9ee7768fb024674211484ca771196453dad23cb219328c0','f18839aba1af8531b3ca9a30aba0264614d67ec4c9afc9e534b0ea28935af57a','cc16a6c8436db88e9beb70eaf6fa4fa3c901a442ffe9effd6a1c83be466a3580');
INSERT INTO blocks VALUES(310129,'2bb7be63310fb6325779d84abfc2f37441503fa24bb46096d9a47a9c987f6ebd1f140eb9e870d7c12f67dd6ccec90658f0e06b117219817d98827ede56e626b5',310129000,NULL,NULL,'700ac310a6fd70945304579035ccf689c0dcec99df6291526f807399034b72e1','daa5ae2f514514ffb5c37d4b646c681ffe0cf7567a6163f4d361b2b8262f394d','402335616a3aa50e3e5e90715aebfc394459979008e13c6f39477e1df3277f5b');
INSERT INTO blocks VALUES(310130,'a869a7a7316f58d3fb10b828072264388b4d7ad2f71891370154c5161ac20a5e8abf36c675ae7ca8b6ea139f55cf1c0aa026d27ab5d262df8e487765a0a9f3c9',310130000,NULL,NULL,'dd1907473d3598111c7b4499e117403d623c94aff59129d95617d130ad06b8fe','697fc936de1b329ce250e57e9c0306ec7cde64a5cd9c14a4967ba302ba7a208c','0deb2e58eac972cb64e2884464bf46680128ae00cae8d4009e51e251c67b747f');
INSERT INTO blocks VALUES(310131,'d919955cfb962b787fb3c77c95afc59a746425655e7b01ea346f29096d0cca2c3f26c25e638495bdbf1e8bb8c97be42ad7ce100dad91c95d83d332ec35502002',310131000,NULL,NULL,'5421bb143c197ccec5a43363117127433bbcaaa8dd40b1a98e376d7ad462baa3','efced61080f8018a3dac3c82098e93b2c2fa6a661e9fb7aec795eb44b044334b','e3bae8f2743b268120184df0d1f9da41b15c11c688f86424b25c6e11ddba354c');
INSERT INTO blocks VALUES(310132,'de02d99d9e7bcf88968650db048896e433675d9cc53954763f706077efd5d21e70c9eec6eaea72b1fb65aae5a678753591bb7f27d12155d69485596a3acc8f3b',310132000,NULL,NULL,'c7cbe67810fdcb2b36fcd9a57897688b851db3bc9c868458cc94996f72300677','78452da59137a6b79426d065b5c2174e77fcd1418c3fea9ac4dc1f7ecd934ac2','3165c9f82e696dccb626266876c143fdcb1a00fb144ffe40231f6ec09c7e1b10');
INSERT INTO blocks VALUES(310133,'2498bdecb642839b80d981a4467fc36e80b2643d046120c4cc58c2bcca6b9238ce44f47a053840bf2e58d59cf228e7220d5c13e3a59215dfc2e2e1910c112a4c',310133000,NULL,NULL,'10fe985213247a99739556b4d61450c25ddbafe01d42b19ad0ae3d0a4a9c92d7','83be34400820bd2ea79796f5246a4403aa42845dd13c15d92bd6b1ee9163307c','2b3ebc9e1d4ad921ad99c03efc9798c55d2c729acda46962d535f337d1c7cfbc');
INSERT INTO blocks VALUES(310134,'ea78c1a509f2bde4e35d71fb8527ef51011c0eefbc9c4908f05aedfc3d2ac01b325c008fc91d17950b0a63da9caf78acb4a4a4c13130257eedd1ae2c34e690d9',310134000,NULL,NULL,'bfd2c0853f85195cd9fb995f755498d2b429ff60cc1a5ab96c31de071d308e77','da5a5d1c8731bc5aab407151811b11ff1c80360b2d9f989086264a5dd5f48bde','7f505e0aecbf33df33d2bba7b0198ab01e11a1bb6c0b01e28f241ffbfe0d3986');
INSERT INTO blocks VALUES(310135,'1dbf8ea76d2e70177df10b87e84e32e76fced9ffbbb38af8f732802206b9b02efc05992ba59c9bc1e811a5179bb865711c32870751098de5c99d274bf47e949f',310135000,NULL,NULL,'d8205bcf13d68e40296393ecb857af62219d3dbba9213eb7c132e55ba30c51f2','85aa7c0b8b07b97cb271ee17fcf96dc97566678c7a7ed8e0492b2e931d86b6ed','e7185ff9f8cc75ea69febd79a6ed5beb88486858a49197f1b8711aa63eadfad6');
INSERT INTO blocks VALUES(310136,'96ea9a0098329dd191730a435fd65931bc05837f39cb646faa7a2e04dce0d1f0850fad36f3ed2d706dcaf00c5093cf7379e04d7d5670b0d6c50f1e2529acc361',310136000,NULL,NULL,'4311148e1148236b690f4e2220c69b389120e1fd62c4db3ba5d37b8461f2bd04','4560c08832d21a2fc211264d262f2ed60a5815d64f26f7904e9b344ec7243a6c','5dc696427c59ddde4a8d2a967d9ecce58f5c42986f8fc10ea729b807063841f8');
INSERT INTO blocks VALUES(310137,'54f0ef3b50020802da23000635c8a238227d56227a80133a3fa1b345c8e08e28591d762359291a535c07dae86e9f35ad5d0176288368443200d598163290a93e',310137000,NULL,NULL,'43714b1fd253f463365e3f8eee39fb94cc8260238e6ad5cce8f74862ae597995','dc8d01992c3831175dfa865a96b20fc2b6e5a7110421b230733bad1875dd2974','e26e7f95814881787d9aab3606aa288600c01a2be9206b669c52fb72fb151610');
INSERT INTO blocks VALUES(310138,'f464f647b3f7071ec8a09c53de3a37a001350341ee5d8740cb7596dc2c8d792dc85f7c03bf812a55fe37af26941c43f58d2bab04ae9a50c23c87d570978f355b',310138000,NULL,NULL,'d48c2b162cb55af40faf4a7515ab7efcf39159bf1fb64235f203f98e2b4bd007','7d0641aadb9206bffd0849ba0d4f217315c5508588224d4060dc1fb09b3c8dea','9b70d7a27789cf317f08eb83dca1f33995c0e10be921a3eeb0bfdd99e4bfe245');
INSERT INTO blocks VALUES(310139,'1d5937ceeeaa617ef90100a4401df06f217fec6eb52d11656d14ece57f5849aa88485ee1131ea0ea31843d74f87ec219bbea3f848c16e44d974c816f8345c499',310139000,NULL,NULL,'dd9f5a12e1c714d1d8aace4141370028f0ae1dfd71dd818c19770cb2834ce732','5083830c6d257375ebbd8aade9cbb3f9cbc2316f6d3fc95441fadb02824c3f9a','0751b805fe63f54b7fa440cc88fbc4e6709ed492d5392f64e221ff9029ed730e');
INSERT INTO blocks VALUES(310140,'5bf90aa9395f3e9fd7af5843c775588acb46d9965c5257fe26090d065a52097c06d7600b583e692bbbe178424ef535c32cffba0736834cbc51c5baf6465e9d40',310140000,NULL,NULL,'b390883a0687331fa4ae2c14b7e993d255e7425ff7b99667b5d034dda438cb20','35000c22d1f660711eebbe8a981b5be12ab7c94a22a46b0ff0e2a009696ac20d','0c91093d7ea835a1adea704a9f4c93559e4a43d654e2e7dfb833946f0f37095c');
INSERT INTO blocks VALUES(310141,'303f84dcdeda12d009bd30efc4217571aa5ccf1367e49227d7c2819deb5ebcfc0d83c663f57af992b272950b055cb3ba7373249974fc38ed4e59d83777e9d8ac',310141000,NULL,NULL,'e09e4b7467fd5b11bce21a141b168fa4e2d2499021d94deee4a029834c375b18','96e9c161f5193bec79ede0fa7b0e6da877e2c9bcc87379cc0d11754ac62d6424','bd4349ba5e865d428c2e03e056016c0c8f89e78976ac5d79d9795e27c33d342f');
INSERT INTO blocks VALUES(310142,'6eef8799c1dd3c4f156a6dfcf70855a2c10a6b3c16344430dd06b67e6051932878df8b2a16fcdcb60090e2c190fc7d6c8b1081fac1878aa98f1db892827053e0',310142000,NULL,NULL,'e9dc0dea872a80592aa7dc545bf7b01b0c53b6e39e63ebb69b1055775d44164c','04d267a0f7fa42496714fc7bfa55c625bf8e203ce7f7e547c7ec0476cec64085','bb69521afa4821adc6101645f3722df507e63271dee5433d94e70799d108cdc6');
INSERT INTO blocks VALUES(310143,'3eaba6739208d14d04cfabaf5361374f0bac8d5deb773a4aa50011469774738874043a1da8942ec4f48e1b3536092fe1327fa9402ec36a217711e1bb7b50d689',310143000,NULL,NULL,'22e6dd3a97d5c1df22d3808585008acf89c829bc599d9f07a2d772ff9db3789e','ae8cb5c706893cb3d32ad573323191a5c73104d54118db529f430a20a33d6379','78504af62b9a79784bd68b57fa9785f008a8b26a18af3d594e68055815c52fd8');
INSERT INTO blocks VALUES(310144,'f8fe4cedec10f1cfa4424aa5cb722754f2b6f21adbfea88043599c29ab8eef0f1f52da1fa4b407351b1e95409f1c50111779ce2a01f150e85090d446f630dd51',310144000,NULL,NULL,'9a686c9ebcef909476b844ddb93f0913d76925b76ba5a80302ead4b5841efd35','e1e92828deebcdba995852a98b8137444ac2d93b6a94ffade58cfd11e0748a0e','b3e18b4cbfb852bd9d0995cf9efc85ef648705ae12347b42b0bbf3574f15de44');
INSERT INTO blocks VALUES(310145,'60f5c7eb2cdecd1e75424bddafaeca4c15ae395e768077553912205fb74a377152bca81c3d292f8e2c8e5abff910a191732a25c718fef277de5f7fd0a59e6744',310145000,NULL,NULL,'4088b33c6a436403d92014920b8b5753331f22e7afc1a0df9cab9b3edeb0731f','8c7e0c835ae5219ed6be9bded07e13b74fe231cde77fef4eda891c78be2fb4a2','02e5a0269d3de228c37726d70f90db2d726278f74e81acad599fd39dab17213e');
INSERT INTO blocks VALUES(310146,'708e9415393bdc3fca510385f3ea35724dff9d7012b29098dcdbc214b9dcf4fc0b6bb7a14672ebc11277db95c551b100f8f162c7ac9050154732df38fba5240d',310146000,NULL,NULL,'4bf28515e81843253e46c938dbacb3a768dd4fcd6e058485a0cb06b1df6a2783','6b97dc915661fa79d6ef02e42a4681986c743474177c87be930964aefe6e6fd7','0095a8bbcf1943e4a7f579e94c13b0ea406ac90694d089eb27b4fe970c5ac412');
INSERT INTO blocks VALUES(310147,'322084a62e15e0aadb94fc07c01e5252a974294af9f523ed94c5d9afbfd8770d5b800c7ca0a6aa5b277da934bd1a3386bbded20fe1a085c0ae91d67e8e9b64bb',310147000,NULL,NULL,'bcb7b51658225e529d7366f5af6f118487e920f6d42442fe4cc2a1cd09272ac2','61c92df0c2137219072ce5390d785ac1878c86cbcf8a93bb09e449272f840b4a','30416f61202e2c2c1445122cb81e5b519fd6fd72ee16bed4b1e51cc8504830d8');
INSERT INTO blocks VALUES(310148,'a03009d380ee9920791b73e265b1652a69eafe3b08602add482a98e92ebb131c0f4937f60f18d1c493d3c45414d233bc6fb4e5e458cb336618152009138e31a2',310148000,NULL,NULL,'0b56a90d73aea85e54a3c5cde1ed374db2576e2fea94e1bb34ab9ac8192150ec','7d8f99399e212a9d4bdb4102ea3a09b627a2799a6fc5bef29a4a50894d2c5aef','34ad37958463ea60f1db85a42b38ef29dd2d5adade864c78c1d2123726354265');
INSERT INTO blocks VALUES(310149,'0ba00c363d56bdc60ed508e68b824b6bb6eb0f86d78a045322c7c0abad9446a2201a0a59bd4ceeb40938327338ca7cc3522f3368afe0bd229c53d4e60f18a6a5',310149000,NULL,NULL,'3d38f21634176a5ebd21f71cb0ddead27ba38797f14b6aee708799c4928e0a21','f8b7e23ed6d7d6a50a6ffcf82815a6bf814347e03d6abdd2a7302a1a5908c9c5','dab769174b4f84c669aafeb31b4d7e385ffb337aed0723ba3cd5a674cb66e7fd');
INSERT INTO blocks VALUES(310150,'9e97e9550e3e69eac03e376dca3f8faed4b5df2f357d3aa76700c53a8ff5d8b3c965285530ed791673ff7e266408c810b2497665615f43fcc472d01835d9f042',310150000,NULL,NULL,'569635757b8fd83e900e1afb787d011b0697a7b1a22f0e74242de7cbf09b624a','8b1b69594544cefcd67f17a7f704209140415c7b883febe5d130097f740102a2','9a4d091542a320dd4562b4739fd945943a8346cadf5ef915d84152eae4c1eaf7');
INSERT INTO blocks VALUES(310151,'e9da3fce9845e6ee5ef6ca0648122f1e7267df82cf4f0a4476e65c4abd718ba753f3198b9bb1f38e70b57f6c7144a6f0eb0eb56fcbce8c2ed35fab312bb505a3',310151000,NULL,NULL,'85f3c489e0578722cc5f485df1dd057a1e33a143223f3b8caa5175a253df1d66','5fa1b00a137dff5998a9dc48b30efb1fdf7281f9e97a62ca32b509c04f7b8565','1e20cb960cb605b32bb5cb3ddc6c90608bcf24f9f043ecbf2318100cf2901b55');
INSERT INTO blocks VALUES(310152,'87d5946810235203ee616481806c302b6d72c5674348930060210486b39197b607b847e39e6ccaefb5bc302852570dd87bdecc9541b4c7377e6895197baeea13',310152000,NULL,NULL,'78611cc8d80d12994d7e8a8c240287eb4d4dc69fef934aa28ef52a332ba905a4','dc8279630048d2af5a9d22088a8ee3293c361ced86a94c79b5ea66e99462cf17','b6cc7d23ccb07bf6a4961489d2e80111f1c528fa3253fa89671e7711221c0ba7');
INSERT INTO blocks VALUES(310153,'bd1637edbe45b12514c3594f115b698a8976d61d258684a456d86705ca73b667b6bc4a5cc9a371ef339d673c6fa794d6fdae5fba232019dcdf0c140baf4a9bf3',310153000,NULL,NULL,'160df5f7e72cf680855d64292ad0469b33f14b8b201b7180324bf97393eeccb8','0bb9eb3a3edb83473a6dac5b8dd59936cb007cb01d2d636ec693178a82c29c12','183928c0a218f8fb2000b33bb985ea7379a84863aa4d277a9987575b350776af');
INSERT INTO blocks VALUES(310154,'3686d7e3810f1c46e94c53edad82e1fe6ed5eaed7b9f7da557e32afe8f81c7056910a279a054eeabf2b94dfb571b829eed22fbcacc011e75f601e2027aff698f',310154000,NULL,NULL,'cc35941bf5d980a12bbafcafba08f64202f173081333b63145fab6d51d1ea892','c4713936895815cca71390ed983a01aad9860ab0e116759152d2d5026bfb2a89','f2bcfdd718d3f3bcdcd0172cc0b1d0a3571e041353ba47c99bd58d62a1694466');
INSERT INTO blocks VALUES(310155,'59ca58cb030c16691117086d2c4e4f2424516e6d870b7d0f105934be4ddb150b19fd0fe4a721d6097ea1fe0859c9f497cfe1ea4db2ec5956604e0b7f8b4a7468',310155000,NULL,NULL,'7f4ab37f5ac99d528b1f5402b5fbecdb0641509da23058992d03353c603ad6ff','5e1829cc7c628a0c0017f9e280af3a4358ea989c3456b244a30a92dca78f18e0','49e9b0c8aa5ec2655816e014a10cbf33149693dbad3d02bf1c635e3ae44ca464');
INSERT INTO blocks VALUES(310156,'4e5da453a9a40861e30fc696c06d9aa3860f4c6d45111335c7d1aa392987474dee457afee82b4a2e365f288e0731fc1428eecfae945d2ac68a357dae20768d34',310156000,NULL,NULL,'6c727c0ced271824ddd68f72eeb70f4e02001296e47ca08e957ba6df48665b00','2cfe200fff32b579a2f7049df57f87c27add479cce08780bc76e979869957a7d','926580bf54d381d30f5b95ef51d91169f38f72906ec3d9f6ac5ad593b396a448');
INSERT INTO blocks VALUES(310157,'758237bef754b704930978e24052d286e2af5d029fb19f84be5a5277b7ed4f9b6d281021567807955237e3629a0e44d7524eb5a998c598191f8ab61d4b5bce9c',310157000,NULL,NULL,'d67deefdef4040ce90650fb7292b65fb5c2eedac901db8bd59895e3d58221139','273853b28b540d4f16151abacc0bfc3f14ba51a1bca2cf087bde062c023423e3','35a4345f1bb457cfc17358e666c6df4a7689f608598958d5c5419050f9b638f9');
INSERT INTO blocks VALUES(310158,'8fd95962fc5e96c28e590cc4abb6070abd4e041d9dbd1670626de27de3fe6a85cc38919065f6f99bbd46335bea510029f68b8a0ac6ed5377beb469b7e5788c72',310158000,NULL,NULL,'07bf26101a8453519fb9fa06227a177ff96974280deafab1fb2039e11dfbb2df','bef49a98eddc9b7c6399150aaa17ad33c37889a52b2d7cbe09f1d16347dfb293','2189b1ed22ed48b2b1ade7a514f74c53ba5365e7b33d5b718d0edaa3e72baf02');
INSERT INTO blocks VALUES(310159,'2f2a14b6bcba2e16e8ef9eedc73c48d5f0b1cbf5754aefe2da5e0c973b884a79054a127eaf78da9e4588b4e7437ba37ffc41ccac22752f00e9d36fbae929ab70',310159000,NULL,NULL,'81262a56282c6b97d601695a698c715bfe9c7d3ca8054de215d4bacfb6f56256','04c8b302b6408a8eab126a4c625a8695a6bedfd0dd5b15a853a09e28ef82a686','dcdf95442402f7948087f4c66877840e124be7fc5c7e1523c252bec6888c8243');
INSERT INTO blocks VALUES(310160,'4425734ddb4e0c8c9d8a90a46888a460dae3fa6583cba2f1347c40c349afb8fe47029517fb885ade0257342e04cedacd75f38dcb93aa19e3f0b33253b1a98543',310160000,NULL,NULL,'a54e906b1363570d574bf9d9d8a1903ddb25c4d472a3135f5955d94b7d048e2c','8264d7aea38b3b45266de29cff0b613a9f4b1c455a1ab0ba9afa2c798cbabeff','bc33518530825d455b6fc1f57dd56f8dd8966988134d7b3c0336b250f347b9e3');
INSERT INTO blocks VALUES(310161,'cc122bcb43f2fcafe55d479da7ab9df488491c6568c97478f93df352d46559675da2d7f627d17d9401d84ba83fd10a8a3f14129aeb1f4a1d2958f1b5a7859a4f',310161000,NULL,NULL,'0c9ac3c9f4b08078947dd7be73132b6c0375612e5d6bbca04195d1817901ae1c','7f63938600781413d62ed0090f683f26f160b889ea97415404ba18c06e555ed5','9db6f94abe4d47ddffa00b67d30b974dcedfc58a452a788826254060a71bca4d');
INSERT INTO blocks VALUES(310162,'0fceec7b98ba84ed354d29cf23599eeb4036fbeab3cd9bbd840b5967acde98a1d7f0c36399d289713f46ca01e3ba06b5972fa120ed41ea427e24658d134ab69f',310162000,NULL,NULL,'3be439d4811476d3e97bdef9dd02612d2191dbc583a28b2edbf51673f035cd25','d8e1ed22631288fa0d432f41f6f9d6fa988ad2b049bdc6a0e9a81dc39a049d52','8bc3f06afce435b88bafb2d59c962968163a18ba3bf3d208d9580c4a47abb2c6');
INSERT INTO blocks VALUES(310163,'7f7ef65a3fa9aba6073617be75c6a9f1373f12c43cb0c73902c6f3a4fe9754ad9d85afaa2bf6aade7db1b485dcb615b6e6ad0d45ba57cf1efce4efaf185b2b82',310163000,NULL,NULL,'acc0a72bd1dab7fb96109e6aba0b29f18de8ffdd874cf1373d54ada65de36d88','255d9abcdec0009614c20889965a9cbf44c516338fec83572db9d08e3eb89471','632de695746196aafaa83fde10b2c8767fa1e7a0f46b1c858c69478bfcba04c6');
INSERT INTO blocks VALUES(310164,'e20bc6e0d1d487b51b568a76a700ad4859e049359ba7ba0fab39fd4a9a5410b2f15e810078d6fa29e1b0a5ed78ac02d01c7d6bead371b15bf4f05b63646a4a80',310164000,NULL,NULL,'f4319dd67ae4395a5bc6ef82f8c59ed7283843dc24ef5d17b9224c8a5d5dbf73','487eba5335d53e396cb1bbeeb129ff90ea59cf1c15b3ab7d4c2342504d31fa94','223ef4e9aff5540349183fcbecf403d7c6f2de2ff09c8bf31b6c526f0903d71b');
INSERT INTO blocks VALUES(310165,'23aa93aa7a33542c0bbc31111aaf1e00dd180d41130030d1b288579285cc2dd5b27458a82d5da4c1dc9a4a5705fb7592c9d790977dd15c8b884e2bd09d9255e0',310165000,NULL,NULL,'f57cf58af560db375237c83528e9a7017470a5fb1b4b524f60dccc9e9b9b0792','b3e86e94d70e1f716a438c4d875c411b6f8e56c9dead25f93b40b014bf500a31','865d68525263fe98a4d41cf1579f81e0587b0ab214209e61d236a39de387ba52');
INSERT INTO blocks VALUES(310166,'b58b320bb57889504edd100b9ca9cbef6f4723f0c4ac8aab2641f9fcdf7a6f1638ec7f1c96b0b83f2f0b5873a229f7e41ccaac6c3e61055ca5022c0f0308f239',310166000,NULL,NULL,'39a6304bf1bd199e519358b847d23554ff21ba6510a75d87de5c502fcf392d39','4e1c6d1fe4e080f5730efc922002a61a773a3b4424c2f0f4a53ecbc4b892e81e','29d91d4034b0713ca940c6e072c51cdf48016215618b9ac730e4c579a3ae75c2');
INSERT INTO blocks VALUES(310167,'9736af165bd0226d12623876d64ba05717572dd0a895fd2d2dff80653fdbe7c54b7c6fccbd40f771170786e3567b4646b3ce4e89e3432ec00762ec0d939c82e3',310167000,NULL,NULL,'635cbfd382b53a235a50280710d180659cdce8ef68e51b3acd175a64c0ba97a8','cde4aebc2ffa9ce18cb2e77fc56d60983f9d6ffd63b85ec29b7dae2e35a4553d','ad02018b12081309c94620aa1ae031b9dc10b206c1824fa9e86b2f92e963d978');
INSERT INTO blocks VALUES(310168,'d76456c23e4128704d18f4889bf93c185ede9e8794df8d0d97c37cd31e4b60dcf67e9af24bda5fb90dc7c435ecf4d8f546f8b4e4821dd9484e1c0a133e9b301c',310168000,NULL,NULL,'a141b92c43a719165d94439b1b5ead4290777185717d9fe8b0c0dab31c40776b','2f8809ed2f0143725d335d23a6e259023eeb82aa1c9794853c325c9ca95d8646','a552c5fde8023bec69fba5dbf2c13f9880fa85b820b20e41811d7a02bc8704fa');
INSERT INTO blocks VALUES(310169,'2935a3409924b7776310bf9ea8f4a1afd7d9e4a372f01853711897fbb13a9681309ec0b9e957c9b812db31f0c85fbb82d833fc019fe14aa3e9bbe4883d37d4a5',310169000,NULL,NULL,'11ffd36828f88749796485c9e95bfc6d618f0d138994061f69bc691eb60e14fc','240dade54b5bc4a6b3c2565f0c484e6a8834414ccb89416fe88a3435032a809a','85be68c0be79a9997ff98f78974054b62c2454df66b068f5b91b5bc3ef175126');
INSERT INTO blocks VALUES(310170,'6bbfba4a0f9dc4b64562d47756dd77cb1c0594b5b174a30c7878ddd04f86647ac3d5818de71c4872a5d49495ebb48ed322f10f6af147d8193b803b9a3c8e2fec',310170000,NULL,NULL,'16d91c30baffffe518350ac41a0ce1686ba08052a10c898d67506574f99b8f8d','a685600ab3d385deaec3427ca3d1976750b71b2fa9b50b65f9a639342fd91034','e8dc5448a55097186603eb8aaf6b113eecc696f6cfe6a7fec0625f6dce671d23');
INSERT INTO blocks VALUES(310171,'45fa574fa3aa1e16abf5453bd88b82630b4b5f4429d56d74c8f93d292dc2f0c9ff20a05f820ddc4e3f985e31af5dbea95d5f829a6d4386e98323923d8c72d30d',310171000,NULL,NULL,'ff67eba126d1a7bc09fc24aca626e4bd02c6b20ac6e777bcd54f959518e76099','72f44fd08864a008cf0924d0a2b5365397cbd1e295d3cd799bc164d7d98916a9','8cc6ce89a318d3fbaf5072b9d33853174025797243c0df1d635386ca556bfb4d');
INSERT INTO blocks VALUES(310172,'a6831f67f7dc90ec04e6fd9c89f50b90d4c9648a6f33e2b1af610ca7cc1ad53899915f340301add4be3c1f7e732b8dc4018ef64110fb78dee317e44830cc6db9',310172000,NULL,NULL,'212f8deac0c3d695ae36d9691f06bc69e6353b9879804396dd861d751fa462d8','940017a535c3c6283092483622c289e8b220093fe39f6bfdf93c8485e8627bfb','377b2c18809f056e1494ffbd2d09412438d7169fe7671eb3ae019dd1f4a4ce0d');
INSERT INTO blocks VALUES(310173,'ed8b2adfe3f5416001083066381ef1360b0365feaa824d2f59138c361c452ef71c9b9af88f333585b1b8ccd1324260025e1df26cafd5bfe9f89c257ce80b8ddf',310173000,NULL,NULL,'19784cf92573926e681a2877f13de545debee37df72fb9aa9eeff6baa6e26c6c','ede1ff8e57065796c8cfbda33437009b8633708907ce858b5dffb00471c8c8d1','fae6343205bf8b74486434bc444941ca782750096a570a1d8b9ec4112463fa10');
INSERT INTO blocks VALUES(310174,'74155b1ccb11f56e2ca34161456ac38512fdc720445ebcf3458cc77abbd13c63e32517e2f13be3d6896d9c33c747941cc587f41bdc07d2b0d76117e390d001d9',310174000,NULL,NULL,'5cb37a6134a24d71c6184e838cb119ff2bd4767dce09751493c37d1f39f105f9','597d4db578636c123338bc1c118b2fa2e0332699650bc22a177d9509c245a20f','1ea82ef38e98d7e0482cf9e42a42d8ac996da518e83550bb26d7e5f695a580c7');
INSERT INTO blocks VALUES(310175,'8e8da7a1e5dcb00385f5297e3c0b624a42d44caefaa48b3a643794e280589ab0ac46ea723912ee8aaadf061441a4c467b2ff82ca6ddeb623fe49e0acb60bc9fd',310175000,NULL,NULL,'47d2b2c217da24612831b09acab9ba38a0b00ea9c7d7aa36e57586858a4d3961','348fb55d5f231319f23691f6efcb79c72390584456b6576c45e0de77bbd33a49','e8165eebced0468f855aac6eabf85fa176d82e3eb1cdf55e841f1b19e541c8be');
INSERT INTO blocks VALUES(310176,'d1cd1ca90ba240b81ef4db29767adc7b58e62c5c06c5dea7a34fa6756c46f1a95e93b405137bf4f058c1281c3ef236a3fa9ae9446b74a25a1a23e16f6b2cbcf5',310176000,NULL,NULL,'53b7787ad65b28a33795f7a814acf86452c7ea6ebdfbd0377b13c7b6c930c5e0','2377591e47ae12445ae96aab9a07c3780a2601e2d7fd31a71db82bfcc0d41949','7b4c17448bd8685f6873ee7fd312880444d6cefbb8f040577019cedc474c6a6a');
INSERT INTO blocks VALUES(310177,'9bc86b3392ce570794748043c352bb9c2d60e1b6f29c464c4f1bebab322fe2cb5f686edb5e19951b1ba1ff9a81a15de45bf8a8a898a7557f7d45802daef0ff14',310177000,NULL,NULL,'fc055685a7741133c915d6fb9520434c891bb12eba3de65dc9e5d38cc84a39a3','c43072c2c2f20dde8d64c9894357a4a7face002b3cf14c2b0e2fd0e24e10b6e0','e2e5421e29b5e493450977397edea763c72bfc530f75ebf4de63f623b79dbfef');
INSERT INTO blocks VALUES(310178,'3d807be2f0841df7dadc78f0d9cafbacf474a7566c97923b854b2d55e877d3794653595ea2694cfffd99f2a7625d595fba7b6ed9b364b2a5c65e2759f6bbea19',310178000,NULL,NULL,'3c047375c053dd793353a73b484c052d7f5b008545b67598d7a0d408b2433a3e','97a4f6b91850b527e22ffa5725138128c3cb0fdb1c6de1b85cf8ea6c00517c26','520d1c7228614863683a3aafd3fcb145c0d43641edf30792a4fe7b963b44b72d');
INSERT INTO blocks VALUES(310179,'de1875d9f78a6a73d5952eebddfb453ef5c3cc84424f94c3e159cc6978f5e616f4e34f172f5721848689dd7dae71610cc4b116163689a03638899e015ee573ef',310179000,NULL,NULL,'a8b911f72ad705a09284ae4d46ae88937c6dd140b7dddf371c2e49f740f3ef6f','7c521d1614e2e2b1587df812088edf3108653f5afb7d3c2934181fe5111607c7','24a62dbd631b8516c158e798cfb04db6cb04c8d44cac59aa72c12be858569be4');
INSERT INTO blocks VALUES(310180,'8d0c1e2d34d331834a636d883d3fed640c169ded8b81a25bedaec7dd57247f0ce5ea81016d704c7350d38736193ec92f21ad70f6bdc24ffcfabd9a5da9392ec1',310180000,NULL,NULL,'a68b8b74c24ca92750d685f083609531d8089e5a115cac7a2f2eba7ef0d7564b','41e3b9d965d47e044bfcbe45d07996ce13c8d7f50697932e39219f7400ce4c9d','fff50a9aef8c9e8a2469dfb5100ebc79fc33038eb54c022f46aaf4cbb605dbdc');
INSERT INTO blocks VALUES(310181,'5772e61ad3e5a11ced755cc9b7f7f9221800766eab5aa3c8611c213b88d6dcb5ab678a09d5c1ac3a247e5bd5e6645ce7c83a961485d65241c54f12e69160ecf5',310181000,NULL,NULL,'d74bf5c223ccf017b0922479de53518481514a20ef1afca0e54df070aaccfb28','1ed02891b63529393761f4e5d97354733398ecf8ba8b389b14dfe33ebcda3e45','23f8ab38c3082c1fc3724371252df8afb7eb2b0b2b098f76cee059477efbadcc');
INSERT INTO blocks VALUES(310182,'cf5773ed1716c6e92f4c53464cb77ee2c77484f34599905d74f9fccbd4069f5cd7038a6fb2b8d3cb1eac5812e09d69ff0c5fb96fc2c788b3d855d334e9545523',310182000,NULL,NULL,'8e0054f24b28d5adab9cce449150267a7257cdeedce710479c0fb1c0dc2660b7','1d4a02a2047c3c6fb89c466575a055864e08f3956bf0765469d6b3bcbc286dbd','021ce2f07cab8ba4bdda084d2b5104ee0846cce52448bad338a0097ac677bd9a');
INSERT INTO blocks VALUES(310183,'37b17271fcd06d1dc0d93746d05e8db21fd43a056680aadc0a2c5503d8abb328f749c0ce126e8733eb1c1dd1be1c33afc8da39e3249560b0ead9ff05736c4dc6',310183000,NULL,NULL,'30daac78b2a63e5c644009582958f45993ae566d27140e7b41eebc9579034296','39e789d8a91e7ed48b292b242ca2f0b22aa27949fdba2031ce82f26b03a39ca0','136f2a2cfa591d870e72896b2d4b13dc3e23207b0f11e8cd08f2c813dd5463e6');
INSERT INTO blocks VALUES(310184,'561300bad5e3a41a6b280f608000b1895e85f229eb80f8d945f56198af5f89ce4c675fb82048e90881610ef9ba76de64ef4cabb599dd8013a2b9fe805573670c',310184000,NULL,NULL,'41d58635c06d3f5462bc70604c820cb4e61cc2c8dfb497ac298527935a9f776d','54ddf98775143b8e005ae673e7dc37d91626cb2f39cc9d08e4aee6710c5761b8','a9e85f5d3401add0c5f0b4602fd8fe7e467fbbfc279ac143fa441b837ea27093');
INSERT INTO blocks VALUES(310185,'b5c464b7c4fe640907ddbba48d37e07fcd09d7e0d3c51649886c8fe5592378745c0f7584a188fa042be11731e3acf542058a5ffc9527dd2f278e025383779035',310185000,NULL,NULL,'7b6f4360edd11cbf2bd90a6cba763c4c3104b575d30dd1f02e7932fcdc788dfb','5453827ca22144af136f6238c70b7c0b05c63311f09fa47dea1d49f62a08093b','eebc58572cb70e7f00dd1f2d4c025b3adf68a2192d95f612521437badafeabd4');
INSERT INTO blocks VALUES(310186,'22ebef88212b43581eb11c01293fe45dd576db2eafd53c6cfc0cb85271745415bd04b38f528428b736d2ef9b9d1714e3fb495fcc4334a1699d481c3b1d380ab2',310186000,NULL,NULL,'4ea8bc207cb97431965a87090179c895500269c0715d5e62e302d9c070f67769','6c1404de867eaff518413980a0378c0c054573685f9d8088088fecd53112eac3','b899663b483b8884eff981de4bd097cc89973991f65972a99806373111b7b9e0');
INSERT INTO blocks VALUES(310187,'94a43b55b4565483540f7802db450c22fc0ba45951629d69d47eced2d49661881ee5fc1a5b756bf9d8e38fd0029fa6c830827793cd9b41bf05da2a8105b54a13',310187000,NULL,NULL,'573fd403441ac854eaa039ecdefc9a76f8c3ab20768220dce8f6c2e1d7a635af','96a7bc0ce77f308c77bcaf4c097e42cd8474b2e13df00fb63b9ee373c1b622b4','9d5fc6cd91b46460caee1bc71553f1692968d8f810a0aeb2fa26049c45893b08');
INSERT INTO blocks VALUES(310188,'1f09285262e790ece05ee3e305d5e5a8e6ed5c7a5b37a31769d0fa554184601b67d853fdca17d08f54ef2708695eace84225d184162ca1d9375ecfb9fc01433b',310188000,NULL,NULL,'60ea0a36c592b6a94f88c52d3d8ef77265e5ba85882287f9dc2b74313c854685','410c53a4362f412151ac23a676106bedb20942fcb7f516ca3f45a15dbdc09a6a','f0ab5646bc8367bcc7ef13272be560e6ec0b900a0a30e2c11bb2cb9dc317e6ca');
INSERT INTO blocks VALUES(310189,'bb30ef3877932419706f2479fb7ffe9ef0e01f5159ac70cc783bb06755c1d81dafb8fa0ca98bbdd89fee9747146e91df626f0102a0882dba413e4356da7c4999',310189000,NULL,NULL,'175799d4d4357d3819406fdc8dacb4f7e7b0b890bb42e70b251841548285369a','f3561c43ac7d68ea19b581b930eaa4b74adab44c24bcd9d22f20ae05abd2b70b','973713c13cb6760546a7892d289eee2ebd88a9f88fd84998c0761697d4f15ab8');
INSERT INTO blocks VALUES(310190,'31407bb2cee22fe9724e3eb9a56d6c8f0162384875df882f1d72e3d008882893ad1d596f45b7cc76949b72fed973f1a5652bbd2910f95d729699929fa05bc637',310190000,NULL,NULL,'04d8298f8ac9e75d3c9b8f4560428ccfaa6afca396f34e73edf57817a7d38d10','ff49aea9004e2956ca1c669cd4b93c276cf41f85b0f9c7dd174c585a5da20d4e','d549e2c305c6207adadf5b00051be27bc46e9c7e030823624469277be538434a');
INSERT INTO blocks VALUES(310191,'2dcb942dadda125ae31f3cf53a162393136b761f95879d359956b38bd9126b93885d43a4099b4039000ed8aa633c2398463b3a40cfddd0c51600a10a3e100a41',310191000,NULL,NULL,'5f8d42390a994a8b3e49e4d3287d1d589e13adfb49a677f5dc61f5fd4e266e38','301bd778d87a837eb00e300e9a0847553cd4bd7bb3d53503e63ed69d1ea3efc6','3b254e45f0086efebb436da9eb8eb071bfe95a820f6f37018e8598358f1e2baa');
INSERT INTO blocks VALUES(310192,'7c16e6fe516ac5ad6f1c65dd08411e0bd33d20b892d65e95e118c4b8241e8e478735a55a29f20fc7ee8ee1c27ba709243bdda8dfc00d1021f7e4a0a0cca3d3d3',310192000,NULL,NULL,'174494cb8af8108a673cdfb09eea8b187853a38f93187aba0e544ee749627751','8900df43afd71464cc07916a32c5649ab4c31d33a900a2c4f1d7b4fa623ad607','7f6d36d08dd48e1c487a3fd427c8ed9f9c75edddde5f93bb09364e9430ee9f11');
INSERT INTO blocks VALUES(310193,'b129b90017dfa34a36d8251cb731ba1fbc1067ed7e7d1da6aa6090637a4192ce5132b3eaf929b6df4b080e1db431f14af30ad86aa659e227f78c49dbc2c0183e',310193000,NULL,NULL,'4548894d0e2c9ee75f6b8d0c17f3670c7c2c53c299f7af9234ffea4981429743','8d6befc1df3eb4e34677ba092c67717afacb61dc8dc18af0c3ddd9f0ebb21c68','d040c4a80a858a4725f39f61ac2567dac5e1f6c4574ae87b6411ce912954f4c5');
INSERT INTO blocks VALUES(310194,'fe365596112e833d1febe8dfb7e043186c77b7d46ede329406b728c70bcbdcd69307667b52ada5786ddeab4ac4abdf2124f8b44a7f89b2bbc47d48f437d2ec9e',310194000,NULL,NULL,'247a8fba049a65c62165eb87354c658fadbd966c9189ec7282fb1da03a73eafe','7a6cbd46c35f60db602d0d00259e98f94dab1ddac1d1332f3bc0eee74e559190','730c00fb1947f8bcddece9aabd7d9ae1a77acd58822e4421af7064994098ff63');
INSERT INTO blocks VALUES(310195,'ce0238d5868d08018c8c7e2a60ed09e62bf43d68e3c93270ec0764a8d545795b2fddd0f65d1ae65148f40a0719e70870b2260e44e6d6b34651d9462f6cc22a9c',310195000,NULL,NULL,'43f0936db780f381faf9160d0b9c3b6432c5d6a6994c6e21645f9dd3207063d8','0483d23952ab7433f8e213614eb0f9429e6d0f218f3de79ff066212280102e18','2c81a4bd221cfc83288329e47237b9aad3e8c55000ddae0b864eb2ce4c9bafa8');
INSERT INTO blocks VALUES(310196,'2cac341fa2f3168c883fbb847491f27137e1dd57c6954ab1ca8987439b8a380ddeed89f0ec48c72b50388b32fb9949cdd7f91b5cf1699a079411b5853dcdc21e',310196000,NULL,NULL,'05ff72145d2965a98793c4cf233049761dad53ca13fd3adad7a4bc2a2078fbf5','574f2d1e7eb37bb706a276b129aa21786ed61495c776826c85113d2feaf2e376','04d7cfd1e8495be326abcf0638af87fceb2f0eca838987ee006077ff64b22324');
INSERT INTO blocks VALUES(310197,'76baa8066e0367c896c42ca413351ede2d01956cf2928e8db2b49532e883cf33f001aa407ba509d207ce1e10b04a89238ccfa34a96aabf8ef5769e7124d9d5e1',310197000,NULL,NULL,'f9d8f6df069d726b91e3c1ee3d7ea76f7f11b586b30c5cd4dae4bb9a335fbba5','e3e29b128a79e0093aadf844a4b04e4f9e7c5b2642274c7a3a398479d3f530c0','b41d36e142016e3f39a55eafa801388ab8aff3adb7f7d53b9d3814e7f123cf3b');
INSERT INTO blocks VALUES(310198,'5954538999fc757ad73102fc86f4abfd466561da28e2954d9d0d740b2d0120280541676fdb318d5b9523df9817ecac15825159d08094df9e067f34febba96025',310198000,NULL,NULL,'b2d0503ac01048bf73967360e2773fcae65d4732a733b34a4dfd529050ad459e','f8dde330443d81f4f45d89aeb190310700f4f6b8667720f63d5c5d2e4b6771b3','af45168b7f6930e44ee96e61da871421c84b7e646db112f11ae29d8bac81fecb');
INSERT INTO blocks VALUES(310199,'8bb67d60026078805a12980af74fd68b56a904ad1bc2b808341140be6d4159f2d9e682ff7a07265512b5f93db0596a54711c968f371389c8905a195badd4729a',310199000,NULL,NULL,'c5c777a68fdfd27379dea35fef722baf928938bc96ddda32ae0211caf91a2f3e','40e7217d52a3eaf6ae0b8a45ff2c0dadd4b808d2aa36161401a69a6753718adc','35d0e3f9d177aba1b2eca421553d127c7a5aa6cb943ea231c632366bf7fea98e');
INSERT INTO blocks VALUES(310200,'b4d68ee6ff2024e7ffe45cafb9273412e2a3f94ea97edd856830540e1b14e87dfe6888ca25328ffb7cce4652099f86519cd872f1c11c7ae937c4594b24b65643',310200000,NULL,NULL,'a62c63ccd7e9713d628a5f156317f3ac6274ca5de1bc682c76b470061fc86b6e','06986591efc29ef3191365fdd1a84387e11e01c1adcca26bdf87be5aacf062f1','d4eb2ba8c104c09daba5a64eacfd392150fb8a3ffac09607ad88eac9f1dde446');
INSERT INTO blocks VALUES(310201,'22d1f267fdbac9449388f06214fa56a8f066f503a54b3debc0c05337acfce63eff64d70fb57485f2d4f0de22151eb723512ba94b527dccca3163be3660289388',310201000,NULL,NULL,'4e4b4604b7255ed677f40205df6f2fa9d79ba1f363f2a5ea6b3d379caf854535','eca5596be7270c1a5f786363d88df5d12b614f1428ab57b5495e18862a42ef34','b6dcc5bec7b3f2071f4d47b91f834d6b8b8c5e33f4248bfb1192f1c52d6b63a7');
INSERT INTO blocks VALUES(310202,'47c65196973497b90b18e79b5d56de56cf05955204b5d1c793b10749c2200c3a32251201fde07de08f41c5ddc50d94807a41fd21d8c843b06f3ef4fb7f8a0694',310202000,NULL,NULL,'6290b5a5c9dba023bf664589e3219f93d9b9f4f29a9727211887c6504916d42f','b7c186801435fbd7593025308210c9cf890ff0a4d0aa0952761cfe858dbaa4ef','e598be7631a5326f0d85bbe25d0a633a00af905d97c4a5461eb3c01eca14c152');
INSERT INTO blocks VALUES(310203,'4e4a1b5ece42b2d9f736ca168fab5e748bd25bf04a6befe529195596435df3bf5c79f3d007a342e396216ceefccee86fcd8f2c6fc6220ffe05faeb5bb799533c',310203000,NULL,NULL,'082f2e5b2227af01551b782ed4bda4a80f27970e2049d5ee22bd6d4f951b1075','d72d2aa407e8efa3df7ed9fa5592174b94e8f3f89fc3a9eeed32110ef9b2a406','0266ba61ba14eb281343cf984d3f00e61e46d27429a240311d1f2f48a497d8e2');
INSERT INTO blocks VALUES(310204,'a24b71e73847bb71fa295126b7a5469a4edd3666e1b8ae7aa116b176e0aa6d3e0f1cd802a4223e21484c76e258d310964f772609f02b368ff86eab0dc75ef249',310204000,NULL,NULL,'a9c5ac743bf466ac8ec1370ad3d77f0037f7109887bd7fd5e4ec1c40ef6e63f1','c6cbf2a7bb30dd242f038397b630669dac1f6a200327f161ca9a3d83233699a7','4006ef4ed2abd7c5458dec5640567fe2e797e7f129f414a741ad5b352467c846');
INSERT INTO blocks VALUES(310205,'a72464e94281917ed2ab5a9d6b4a2c2aecf7f75c6ff2f0b99965920ffb131d8cc0950f7c555dca580cda03c39d5ef2db92159bf755c7589ddc639395774d92ea',310205000,NULL,NULL,'ea0d2b6b1b839de5e20679bced3aa24bbdeafe75966ebd0e6cb23f2ea8e52a0a','6e2bc010932b63c28da495984ac33454a67fa7a764bdbe180697463ab9c647d6','08c164a8308c72ef1679a55fe5746f366377cfec350018342bc7019d5c1584ac');
INSERT INTO blocks VALUES(310206,'01cede99fdc8e82a0e368b2da8b68fb55ac1eb73e38a2bd2a6e307bf60f2bd48689a9b1beb995ba2807bcbc40d68cf99233d7c02da0e63e12dbe2920bcee5a32',310206000,NULL,NULL,'0c920a9ac12cfc76c8b0cfecb5a84a34fabac5d60966179ee278191ffd094496','762f071bcfb9789bf8a9b9a467d8637458d4cff601a7530e295f961df19b3ace','c5435714e4da6dbe2ed635e9b810a8efa800aa1be95b93f85a4cfad4240b5190');
INSERT INTO blocks VALUES(310207,'88d4ff20997e03629ccaced0196caa97ab4b77184c74017ceaeb6fb389042b988dc9a699b4fa2f34834eb7f944f712ddee8f9a8b2d1d2c06f0d8c168c68807bb',310207000,NULL,NULL,'70d37ec7a5b1f8127dff7784a30fe5503676d116df56e9cdcf192a5a76bd6941','be5f9a12581e4cb70c84768a71920e44eda0f217811fc751af4e7e7722cfa5c5','374f694ae246d5db3ce49acc5cb41a6fa61e633abbc427d7c230ab6cb7df5727');
INSERT INTO blocks VALUES(310208,'d0df3a97325c0945024e56247937403a623b103da35b0ea2ccea010874723c8dbc9d84472bf71d8d0508875dffdc02037ee49b7aa66e827fe67e5f1d0986bcae',310208000,NULL,NULL,'87e229c764dc94d3afc8517c6d3ee38500cac418b830aab2c0cc7fe0ffe36d99','a06d55b32f2d29f0adc525f7fbb64de897bcd5a6059bfd30fc1a229535c85597','4d580cadfa0a886ee44ffdf3cfae67cbe5b353d5a3da4ea63ddba26c3afebc3f');
INSERT INTO blocks VALUES(310209,'27ab1588eb066b1dd2f7e3e7fb063a9c9aa1f619dc2de468655477924c0efb98ba887527b103a5f684c7a00ccf8e1f47a3dff2442b6dde641344c29118771dd1',310209000,NULL,NULL,'905e908429c6f679c1bd06963c08372b2f2e8038ec413f1595dd9ae9dc8421ed','528f3f498878e990ba1569c50e0f010d9ad835299b5461587f04a85bddc39848','54b1c440e9c7812c141fa298fb5554dcdb943b90ebb505764208ac4117283072');
INSERT INTO blocks VALUES(310210,'83f1b51b0533b378caccf1c10c24d28f73b337f2565adf1b98be45ad0a41791c54423366af21e62be4b7c162bf00f520272e1d8d9f1ef559796cf77f12cb972d',310210000,NULL,NULL,'1a5c70d2f83977d2b07c1653b29ee8ffce49655a7ebd6ebe08f6486837a3da68','3457437ee8fe0d755a59d0857996dee9b2d7c179c63a51f0b243161935ecae58','734bcf05841dacdb531345a9f658a9a2e5091140dc95be1b606987a314f7a289');
INSERT INTO blocks VALUES(310211,'3a9056c07772171c06ec205a69c4b9d696237a31df08da36b0ae6450c572b51cab86c482f5438adf5f6ed205f25b85b5cf917251992126a1f3bb45c5a46dae53',310211000,NULL,NULL,'33a0b59e12bec4a83326cbc41c347ecbc60d6158818f102b8664d4246f01e4d2','7889ce41a6303a42f7d0f0f0d9e98fd45ce5663b20de520a43682ff1fbafdd94','f563936df7c7b498a3eb99a7f8cd220a88fa1fe96cf6b1ef9694e0d40afc0373');
INSERT INTO blocks VALUES(310212,'33d04a1b268568ad87bc3b1eefcec805e49ad6422687372c8df9573167be5a59ff175390db4e4be3b70ebc3aa80b0d97ece4ff231544e8eb2b851c29c5453256',310212000,NULL,NULL,'855c78bb2d1d367978bec1caea8ae83b2127732c9443a4f83dd345c3d006039c','a738b39dbfdce84da73d6e8b169ab9be4995c4ec336da8a43aa290a1ee08ba11','c2d9d316d799ba38c713891f9c5d2315c8b33cdbe9a07d1ec9c121a603b1f19b');
INSERT INTO blocks VALUES(310213,'3c11510c4b3889cc5ec632b1a35bfbc6c926dbc2e1192fc35e6a1086bd1843833efa11e8a3e01e2b52b5a4f605d56c493c26096453b3b55ce624b998835cf3d2',310213000,NULL,NULL,'8853091228852c2597e0186dd6fbd40399ae71f32604c323813810023c61ecbb','ddcd5ce4e56fafa75730840548c92c499e7b77930380ffa5a9d68b259749e7eb','c9ace55bbc6539079bf7e5086b05ed59de2c09e81998064bb3a75f1e974fe06d');
INSERT INTO blocks VALUES(310214,'6b6498938c5b75c479219197b56bbfcd0bcdafe8c53f44c9253ae6ba7c1cdf32fa787f59b631066a6f64f4d581af1fd28e4a5bfea96f914b95c1512f979ff029',310214000,NULL,NULL,'9f461aa35f9729fbc1b4424d32a50c5c4894d571d900b362aeaf9ac5ebb44c8f','734772c7c1313394f8700dc8222dc3ee1f9229a39d514d5ab920fdc6ce65bca2','f4115750f18fdcfffa8356e2e36188a022b0d58e21eedd5e613793521be788a8');
INSERT INTO blocks VALUES(310215,'72bfe8c51a45f0653315cf109218374fbbe1b58f9a8939c9a9547ba629993f78d0ab8fddf2ff5bb4b3ac5b02e6b12a73dacddfa5a6c226157ccd2c5c63bc07d6',310215000,NULL,NULL,'b5782899948f5062ccdeeed0652d6e341671d1e6b9b07ecaf798db49060222f6','ef739ec6fc155559d2abcec462dc0be7f571e62a583b28b366469187869aa34f','d61c59d438ea650838d5c57e4a930cfc47caa617a96b77cef4f826fec7951e07');
INSERT INTO blocks VALUES(310216,'bb5034d8b3bbf63b4ba38cd0df331a67b6a2a4acf7c3b1f308525fa77507e1934f248e0c14f4121f29d34513093ea93d2ab1a0ad69f816683401042512f24112',310216000,NULL,NULL,'b3a4fc5b2ce92b7586965c362450b383fc39e8ed93e36306b9e619068e91e7e6','92febbd10b94894b8f8561bc44866afc663fbc8fd12f45168d26825912818f99','43810f40e1819fb9e6d93664a550304f3b97c11b0117a1e31f0d8d16214f06a0');
INSERT INTO blocks VALUES(310217,'aeedfa4625369164f54f43fab4fa144340162fa576556f9273817d9f6fcf1c19f649027e7761685b677e604fb80439fec1febe92a87320737e20358ab33b1266',310217000,NULL,NULL,'0d11338790c8d596cb497bf48af577f7c00ab99f765c49347d6fc21c4807d1d7','544f56034f74eeb0e7280639202026c8c441a4157da38f5d7b36f1babbe5a99e','1826572a34c16f9aa2426d105a32e83247e7a6471d743ba83f95eb0b5a55d287');
INSERT INTO blocks VALUES(310218,'3c7eb28c3fed2eb7213917ece79fca110f658ac69589355d0af33263f8717033ed4e3d20fab5e3819354b546a7c2fca5e91c1073a642094d6379ce02e46ca1e1',310218000,NULL,NULL,'7c6fa86ba25812f8e7c01835deaaf226a6b6ba06b744173ffbdc2abc524a89d3','926ca43c1f4854da03f5a5332b816747610092c094a12c7f500c2cc16db57c73','d09291549dfe7a9e5aab5ceb52268784a1f4adb3c6edc317cab4763e5d8eb53d');
INSERT INTO blocks VALUES(310219,'17cbc2da6b36886d537c8ed24a713f490784aabe27e5657d0204768cc54e63db12d85ceb7050e080200ad014d4150abe7c5c74142f3c1c21d53bd774b5343e08',310219000,NULL,NULL,'51953efa153d60715d02a656ff3bfaf4b47f75b897d97f02382de92f7fb14fdf','aec1dbe2e9543a1ae4e9b95c685cc2c92fad84c7eb1572db96e56db8e784bf6d','8b5384ee7e453d2454d90a37501874544aba1a010138878df299669f7924c494');
INSERT INTO blocks VALUES(310220,'7b20b32736c01aac271311bcc87f09166ddda5a2e639f159ec939d015d0d6331114aa2af76dad0c088ca917d4ee689d3a6b151e9aca0039cfd5798e65cf59123',310220000,NULL,NULL,'9f3043d867ce0d1ea2c709859ed6c1baed0a044957b1ee165489298f1f032283','d45a1719f3efef7101b684c8f842976cb253a273c56674ffd6f8fc3abd1bd6ee','9b924a87b50fc7443e4f07714b54f08057f8f6e1ad0903de8cbdc94cab474bd1');
INSERT INTO blocks VALUES(310221,'2372d0adb62b755932693ea604b85e2ef86965ef740f1bbf6e226a1f2a9d03589d478f5309e1dea13de5265852f42bcaf2a532052bfb8ad8d34c85816da56983',310221000,NULL,NULL,'e1fbb3a13fa6f219a602fe8f83e0d3a9e19631b11452670d615075550c1a56c4','214488d228cd0f182a47cabd9bd55d66a851eeed303e790261c357fe609e7687','802a302cf411c21d80a29c8dae5bd80c7a282da85795ceafac5f6fe901378f7d');
INSERT INTO blocks VALUES(310222,'f95edc9fe371af69326b4c9307e979e09e75c50e64133e32609675c711b28d2ac8ceeba2a0d0a9add615add1dae229610e0ce330c240d502f1daa10a5830f664',310222000,NULL,NULL,'ace259629de7d5b52d1fd3924bcea9123edc0e115f5ef26c437abb49a56faab6','d6724265240321a020643b885d342a26b2d4365eeb81157a621f1bdf83960078','eaaf0599211ed27c3839be5d6d88b6466d215b379c316d8d9df409640e1699c3');
INSERT INTO blocks VALUES(310223,'f3738a31552dae2252726d3a3bb654720752b8c9a73450104e25ad9f37a78cde5e570969863b7e026fcdbbc19ab731ce3627ae1bd5942aebda24f751bf53838c',310223000,NULL,NULL,'0c151d884f7c12ce9e043d2908e7352bd304bb205480aaca14d8a9dc818448ca','ca9440b6710421c6dfd0d174ac7d9f05e75072032accff9d58e322365996ed73','3870527382d9a9c3e85ef1c7f5febcb52c6fb8bc74a451573010e6af544d0ce8');
INSERT INTO blocks VALUES(310224,'2df029abfe5ae4e19763b54a85b6a30afdf4d81e6a851c9092b5ad39228d63c43da52f494361beefaa89ea263715886150e387c2785c8bffac01b50c794394e5',310224000,NULL,NULL,'6d46c878afe4941282334e158f7e8da9b7bf069d33b5b8c79b7de91db7ec7462','4b86d6b26c60ce25edebe3c098e07a106a712fbcf274b9d4f638961df6bf97c0','66dd2ab22d80cbf307089ab6f74f614f080c80b60eb9ef2820e914ae2fed3cbb');
INSERT INTO blocks VALUES(310225,'2f1d3b02f51273ebb3b1f978cedf12171e60b68b4467c8a782e1812c836ff78f387aa5cc60f18c17fe69cf5acc8ecbd6f858a3de1ba0ba3f22bba112bbd512de',310225000,NULL,NULL,'254b830d49e738d1606db293a0b4d6f581925e11f4281ef317978815718aaa91','df5cfc63233c6d91d65547e398c2668a0788f83ebc5d1043308ed2eb929a58d2','849ad6244b564d93ece8203f7f7140cdf438c068c58a15bfa75d6d369e29d373');
INSERT INTO blocks VALUES(310226,'1bd7bf5cdd75ff504e27576a94d0a60349c6d536fc9907e2b9d93878818c51f5d3966b50963933477c04003946df7bc38d9907ac077f11516133648d9b513f1c',310226000,NULL,NULL,'e1efe8916c38c537e8b375d9ec141609f0242e0f6171e2181b7879542bf2cfc5','383f924bb3658b30c79a972a2a1d978de8772ccfa42b890d7ba0dcdf6f25d904','439a783b5848f62070d211f1ce2ee0ee6fd5c84117a9bdc21d54a3ad424e1ab4');
INSERT INTO blocks VALUES(310227,'182587860a17a44392b7071876cf5f0d722ff68b97fc67529dba4c4cdc00ce27efab52dd90da13c988e94c97abca5086703f27a349a4a5270229ba522d6813b8',310227000,NULL,NULL,'e3fc954d5ffe6fba83f886651aafaa356372e577ec72dc9294af81e8d5460e54','591e823e257572a8897b697d9c6a87769a9ee9e05ed2a5c7333a7183a4b10042','518b5be06a1958b7765095f6179b52f89df49643fa6b99d8d6e9807c8ad63fee');
INSERT INTO blocks VALUES(310228,'ab47961393a0c8b3f86793e9a25f879f5200ab75f6fad587065e4f0b8ef3a51fd16f42dde4bbae0c250c967db4040a8470606404bea230c3d1f6dba4588af861',310228000,NULL,NULL,'4d2f7d6c64318888999a0572409fc3f745c345a1eb4a7a1157baf551140f11a5','aa14ab93a31bc2220784329b3958a0b973ec3f99c7d6a7dfdc35a1f6ce8feaa0','61f81f57b003ee83b52037802bae324a3516b561f4bf5621516ef242fca07620');
INSERT INTO blocks VALUES(310229,'922ddf34d83b9f4acc670e0b1c9cc2561950f20c3d5654e43198fbd11c86407fc41c934216e8714b519d2692f32b79c89c8be85c637f0136b8a462bd4f728ac1',310229000,NULL,NULL,'e3bd27995330b886f0125db66d3120c7b0e2563b27d3b69409ac9f691074db4e','6bea18f1e35da20594910300e84a7c22f534688e2c861553711f4e51ce411547','3fecde51a6afbbada0b32a461b408acfdd8a5368ba356ac5b2ab44c0baf9d30a');
INSERT INTO blocks VALUES(310230,'08a1b604821ee7cbe963abc42c1dc8ce9273af94501537e7ef19e90cf504b61a80a99ec7952db4db85fd7832129d593126a1bc52b8ef30e6a52591b37e9413a0',310230000,NULL,NULL,'73d922df9d4a533350581598784217b200b01389b09c169700b4bf89c08a4346','a600120e3ceb8784be21c6c50908f130368f45297eadb5e06c2a1a890016b3f5','0726f7f92124f5b70513d74a582afe0b7f350f8334c7a06ae934de0430b76003');
INSERT INTO blocks VALUES(310231,'67ebe4bc3acab4936f1ced7bc5191928fe87d0713c27c58c56880368bf3efd48374eb223eef7d2f91fcc6a135a0a817185c464604d50780cf8c4a80f7a18d927',310231000,NULL,NULL,'cadde0070517006ee5aae1e8a76c5b878722a581c4aa7c6eb52bf27373e6bdfa','636f24f96ccd45b8a7f6ba8a16870941f37a19416dea46b899049a57e3cdbff0','b0949c55a8e46f104ce18cd9eed6c1ebd7fc9e86a1d69131d5e13d48640677ca');
INSERT INTO blocks VALUES(310232,'4b5c090aca519eb1296c14a778e317e464b49299241547340dcb808f0129e239cfb6469efab40c60a9c7eeb9aa02c341b953b69b324eb9d60ac0b6fbf1958000',310232000,NULL,NULL,'a1eab53b70d861a6b1d3a86d716f6ea623eab3b94fcd45f3efb5a3f111677dfb','cbf1839a3fbad13c328fd1fb844fa95e130981e2f97e881cf2423a863452132c','62e5011868461560083977337c86407592a23caf116c1208552bb005e52e1df6');
INSERT INTO blocks VALUES(310233,'bf2d86cfad06136613e4257547021208ae35e8d2613b9ecbfc5ad079f63a983f47d09741327180168cd1dc30dbc42c073df223786aee9d9fd1f2a158b83b696b',310233000,NULL,NULL,'2b8cdbaa97864d9f1fc064d0584e2d8ac4ba7d429c0979119e6f45d375ef710f','5b347bd6664a551d8125c7890436f780eeaf40a484f68ed5a982e59967b73750','abe49b9a042a70434592e3572ee464115643ffa16bf020e0af40fc11b9775433');
INSERT INTO blocks VALUES(310234,'f136ca58bf14198246cbda783a439b2dd2524d51baf195630902a7b783be0286da4aebaab9c7073ee2b700b0fea21740a2d9842731a2018b357473190ac49969',310234000,NULL,NULL,'9235e90da801b553871ec18fc42e9f70075f091561aa9cde7a372938d62c73c2','2c80654880c679af78560d73d86a9d2b6e61feac3f4895564ab40430b0e25597','4c0605ed774292fe39b1002790754f2ecec4148e234f3c90155a02da24229467');
INSERT INTO blocks VALUES(310235,'74bcaf9b0288fd96e527194252a8ff070351fc002b732ce00f7f09b37e7a93792e257bf847d4df70a61d43dd7d577d0140d121c0e088d1bf92fa4d4c79180a41',310235000,NULL,NULL,'6fd4a1bd15a2400485415d40609eb760331a21ded1b5ece02e1d7cb13a818417','86939dcb297be72c10f03ca1b617defb956e7322cebef2926870dc9c1f9f3201','d26109846de6142c099fde425177116dd67fa5dfcf5434de3bfad9663f3f17ae');
INSERT INTO blocks VALUES(310236,'d53cd57cca5e8d747b0c6a5d45eac66aaad1da1c9b3a93b12ac39d356ba2675c70fb00cd3c0e927fa08950c3d77034175daf5a550171a1ace7b3adb798e6c0ab',310236000,NULL,NULL,'698322a84e1f5f80fc71e765d78764fe716943e3c1d32ce1612f86ad8b6780e4','f87f193ada88dbf9c90d7150ff265cfc538d5e5a9b430b2ba44dcf93ae6682a1','274fc75614faa14b0fc8f7cd330fb88380600e72bb743996132b257befcde127');
INSERT INTO blocks VALUES(310237,'4ed36172ec27d2c496e9eb816c65eb6846f87683b5fb444543f6ffafaf29a37ce441644c4e7f1a2bca673cfdf3df4581c88f1d7a140fba4bb6700cd4407f2aa8',310237000,NULL,NULL,'f8179bd33d52e6bf57f23870ff381a9a9b4703e38ed01a04fdf22321b44cc0a6','e66ae727f43c3744e28a4d76bc61962f12cbd535205660a260eb139681adbb79','768d92c6efcd3b9b37c61cf9ec49b7678790d7757abb2d8593879eca1a9e281f');
INSERT INTO blocks VALUES(310238,'55f9a7790e1576c56242c2559cdb867260fca89c3b82fdd5ef239095be1b7756dfb09e47054f5ff561415377936f93b2f65ec6d4a70fea51a39b4a8e7268ab09',310238000,NULL,NULL,'3c4d4b03fd7655ed2d31eb3a00267e1ea9cfcb6e80ad10270ddf8c77824a8637','e8b1e1615605eebef0dff11aba8c035fb04b564b895646fdf5a47381df0f8352','24bad10e09b30d30beeec3cff0569346e2faaf812461d98fc754a68a270bf9fb');
INSERT INTO blocks VALUES(310239,'6f3b9c52fe2462522690bf39312a5fe8a459c249cb3b843a752b252a96315f3523659ed40a96032137f599357f94d209a244debe80bdaaccab844225a134ef68',310239000,NULL,NULL,'d45e44594814857439bcf4ec974377fc4d4ccb7c5aed98798b561c531933f850','88774b1934192cd4f080adc01763ae8fd5597cd3090eee0d0a1969c11d5b2674','34829cf6ee8a7b3d6c95f3550ee47ce952e81b8bc70634454be1d965680e3cf5');
INSERT INTO blocks VALUES(310240,'6bbe056f8f605bd968aab01d94b6e2be82b2f7cc15e13a251bc9a82950bac50e709311e178b7535a8b35f8fb070fd2f1b62dd61c374e3760b1a12798ab7b4b43',310240000,NULL,NULL,'b2e72bea68456824bfd133c9b4a0f59efae3146c71d738149c9397f938393d16','ab7c68c2f6750ca90bfd69bfa408939afa4415ba69309f5bc7bc414bb256d3b8','dd9c0eb0052cbee669f2ab99ad6b7ebd347006a8270850578dc7987c4eecc402');
INSERT INTO blocks VALUES(310241,'bc3487d59c2e60184d7ec9f0725d8feaef0be333fafbbf57ffe11246dd2a93941904c81982223aabff1ef880c9b3df069080d4d2d1d2752c87c91ec12731f607',310241000,NULL,NULL,'0a670fab5b3abf8b92c133d464c7d648452ed388e397a3caf05ae354855a9c7f','ba55e22aaac5df5702275738a2744b7130a0ade8defd149129a1b0aa52d83ce2','cff80c8cacbd2467df1a25ad58c7ae59239653a1c6ed1ffeb08be27f0c2b3c68');
INSERT INTO blocks VALUES(310242,'f0ba89baf895b948dd31fa699904e3892581b8bb76a707fb966d42d51414f9a0a2ef6911d27c1ce923518f2d2a9f11818c311ea491ea840f0e8af5d7477f2bde',310242000,NULL,NULL,'e914b2b1c12c49fad4a72c60fff9e86fb7ac73d030b28cff66edc21c0fdf26f4','8671904b49fcee0f5b0a1d566ba1159dfde44db8a9e89959c97b345880580daa','10bb82cb5c693b84368b72d5f0f012bd981abc8ca1c47ad99924c1bd43e38fa0');
INSERT INTO blocks VALUES(310243,'955811a1c33ac336f66727d94915d47d1c4d41b719336803209603ad7b710f15150e4b03cac6d615a10006e98e31040e7aba63f1c738fd334d991f49863e3227',310243000,NULL,NULL,'dfd87e01999501f8a0f15ea11e62540f585b1c7ecee78007e4f3f8a178362b3f','720db9d9db2cf21d268b7dd5708b346386fd9a659edd8f48b26e75a0359ac4f0','af7a33df45264a071b7abdbc5c551268a133c7618ab0b9c05f565e6c65d7540d');
INSERT INTO blocks VALUES(310244,'6cc52646a6c05bc90de8289a26c4c7c66f5eb60a5f779df14710fe40ccc4d2b1e862e2a340b5cff39774313fe31005f374e6cf061671a846d490a344db6e7b2c',310244000,NULL,NULL,'9211fdd56a57da80e2d9f2d9dcc8e629fa698012b51561547e1f5c7aea4a12ce','c81eace860d8b6f4a0dcd72555f454238766a686cc8e6197a75279319f64a010','019630f91a57574d7c8a660da580c9798ee5ebdf2a30d9d5c4ae3c8887751795');
INSERT INTO blocks VALUES(310245,'8ea22989a2a25de3c02b6bbbc3f91dc33d1736f54bd863e142fd9d6014947cba0c6b359c26fb2ab2fc74b5ea3c9cd7b1726784496cfe84eeb7bca76f49afa55e',310245000,NULL,NULL,'4d39dc382b60046016ea2c5fff17c56f7eebf86a617aff8f2866cd8a2390c20a','134a7e5fa3a5234f54abcaf6beb57ed747e55437331778b1cf071c5baea3f579','6c7c40ca731e843060d9c79e7e4b500b2be0432c15471f5eb4a144de43030efa');
INSERT INTO blocks VALUES(310246,'b0a724456a7dd399f9bed9381bd98e97b547b7a87bee766b4c357fc492f576213dec71320d67e12ae7fa36f9ffceefb8ac86ceb491a5ce60db97b85de9149e05',310246000,NULL,NULL,'420c0dde892e45dee61f60cad2b7666ad98e29ed96ee0475dee0f8e41b8591bd','542fec4156db66745083e3ec698528cea9b423dba159a204f1918be920c9e01f','72c82b27b9daea64b553ccec76aa137b57ea96eb44e0fcd10eee97814a26d84e');
INSERT INTO blocks VALUES(310247,'26ae1dd58e1cf9ad6c79c6bc68f274fac5674d3747e027187d805f0e44276fd4f35fe820b02e1bd134fe614bbf7cba80c52df87349c1bf580cb45c75f6f0591f',310247000,NULL,NULL,'71bc23ccce8aebbf3984cc90c2479d73359abd5a3daa77c1632ba0eade2fdbfe','16b7b19c96380fe0a155e6e4fdf2b7bbaa6321e20444a4a73b3c4fcb203f40f0','761c3ae85306337d76e22818b43be46e627b7ae243ed9b1181ad7e8ebb1fd5d0');
INSERT INTO blocks VALUES(310248,'9e5b5d0e1037fa3a3200cc7f5f0e271d838b475098df768cd25c944a400543762f8302fc0f1c88c67293c6836c394a9b6f32508d6f18c9f01dd7404fe5cb32af',310248000,NULL,NULL,'0604f06f88f88d1a01e676b4e1290b94d86d7fd33478055729858084d79efa6e','a42727bb8dc8d57f385cce80309b7e2696d98f09f93f89f19e8ada50e6162def','194891cbbed70479fd94e495a14ae97942d72d1e1fcd7c78197d051f71bf16df');
INSERT INTO blocks VALUES(310249,'d97148dcc24a8c83c7421819c5606b86e3c44447a1be95dd476bf7eea92407d77e61700961d3d7c807f433264d2494294db860ac6cf5488bc91e35807fb7804a',310249000,NULL,NULL,'a26af8bd0a37738e60c9caf6d5d02aebef6fe062d64ede17f033c6f0c5e3965c','a77b3a2e66df63b61b0683d2f5c16e7c65068530dd3dba86d9660dfc480ccade','fc4fab89a69a71efc062bbd00f6a1991f8c340f032861be37a5c2120a21efef5');
INSERT INTO blocks VALUES(310250,'3218c6bfa75b8c8df54b58e4c0553a4bea06879676a057d7b6504460a8cb2b4edc9847f39a039ce5d0f66fabd057ecffe8d64232e4e8eb9a57f75363d5b0a7df',310250000,NULL,NULL,'dee153276b08cb0bee3a0e5f540ac38de8f63be18e025c28b71e0eb5b4b144d4','6c3344422491d0df8fd64ebf13a63326e0304c1745594a7be5261ba6d8ca5f53','a0e67ab3eb7d6f68ae887d1bd85a07fde10a34839ea7b9e37a2a9aab9fa37021');
INSERT INTO blocks VALUES(310251,'46010924ea340c67922d408342cd922d8094a24c6ab72179dfe1bc23fe8ad68faca91a05aed2d511757928fac92c2f30149d4469e6624a9ba7dfac76c9df2239',310251000,NULL,NULL,'e2d81f9f186c95b417353ec20e646debc13cc349128137a275706a3e838edc11','26a09967ccc4db7e2a834f447ec2e09e1f2150681f893889f9d4f1bd0fe27fd0','0efe4015bbf16156abdc12023813b47496811749c52e08ea2474f72154f23f34');
INSERT INTO blocks VALUES(310252,'88c50d377c25aa2ea34c0c3245777abf590ac77cd651210d8f31f2b30262918852f37c97b41c9168e397f1ea3e7162f506b5186c03f715fde36a9c2218bec173',310252000,NULL,NULL,'7200da548861065a6473b20ca1cb51d90c2cdd510cf098be3fc99a67aef3e9b2','cbef3af74690aa95d0643de117b3f86d309185b2fc33efb5b4d1dcba4944c0de','bfbb06087f18d87473c6ae56a67340f204f0bf4842d8324d39634360d4b0ea67');
INSERT INTO blocks VALUES(310253,'73b2496752d1bb6b927cc2069ef7d9004440fc9492012ecb8b71a50b58e43b92b6d3994a2e9d726292b62e43eaea092b023fd4b770f3fa59afb3187c85c131d9',310253000,NULL,NULL,'1021215711301ccf7c09643558a1c0749cbcc5e4030ac93ab70ffb9263e46e15','082326d16d62a037489ba4ebfb515391edcc3c9ff8b0e9c8c0104048f10588eb','32963a089c578980fb3379027f2da4ee85c870781b0e86ff07cd89c41bf290b8');
INSERT INTO blocks VALUES(310254,'270bd129114e55c6c6b601c2451ce5a7747e1f3039223580a32190a5fd95badb75b25f619791d084d9c8a2efa80e4247cdf3dcc9caa19f2b3dc761d73436e83d',310254000,NULL,NULL,'a2ca5553d132c971ae3e91d5c594d16111d4a6aede5bdb8d5321d929108ea15c','29f0369755688aa17f3175a7ad9c02d512de9081721b794ec2963bfe472cd0a1','556d739d8ccdfb70653f3e9c6e7109b3547a1e979444f2dabbc007876876fa7c');
INSERT INTO blocks VALUES(310255,'a15afb7fdcb15cbf453184be9cc3190be765ac149f6ad7ac967ba60cc21ba09df24cac96ae343361b262fe7b9a39cd76fffaba7a2c08bae7a7bd15d501ec225d',310255000,NULL,NULL,'3e7762920f8441257eb34a08410479f9c49f89e2ead44ada40417f22c85f9f80','8654005bd2d7e5f7d092280a0a3b1e85af01093a3b3b48bcaa404b3a24866b28','89ba3c1067d8ea2cc6390bd0b33e689bf3c5aa6a1d9686174995f1c3224880c6');
INSERT INTO blocks VALUES(310256,'7bcf35ff91943eb983e9f7f65ad5de5b6c07959e3858617b79cb791658f0acb13c0c29fc29d333e6094c0c1cbaf73ad32ecd5fa85602e4e25ab8ad785473ba83',310256000,NULL,NULL,'4c5682e589464e9f49d959d257e0286a4810a9ed9b83818efc8fd1906adec23d','cbe4c52245a5033756b14bcdc931a4eeb1e721002d8ab777f215ac886a4babf5','e9a8958257fa58027599498f235bf51f7395cc0733ce180294806e9558311f24');
INSERT INTO blocks VALUES(310257,'f5e3467145f08e361d51dcc095569f28e189ee9be38b5eb0bf200b28a833e455a3de484211dc2517a17853399e5c471279cbbbddf75d2d28ab952ba3ce71d882',310257000,NULL,NULL,'385ecd84cecea99b5540e28e3c8b9057b8a8122c3e01aa6d304144eb287830a8','2fba199fb1c22a007955a73877fd86c31404278ff05bf5071171528a4f2ac9f2','e0d4c6081af60143e616c76434da4d804fcefc9aad3ed8e8aa60b861df109d84');
INSERT INTO blocks VALUES(310258,'818e2679cf7bee8ea493eb9d043f9b169f99648b23731ecd362ac7aacccb1da8614c1e031f24389139ec174d7d6258a9f0334b0d17c1e2bcc9a46eda665b7267',310258000,NULL,NULL,'068f4e620d70018dc1f0a23b5b3b8be67cdb76fc6f3ab52b4c3975e622a1b642','58da99fc9de97e99b33e4220485c7788206ff76a35ba923aae2ebe4d70e80588','80bfbdb46a1a7b12fd3aeefebc0485a3d4e717cb9b19ba5f6b7b4fbdc92f9c83');
INSERT INTO blocks VALUES(310259,'8fc5d3af60bd9fb172f605d0c03ccfb5c154abca814f7dc2f0b594f5f418c110e525d3392c1d59104988c377e3e92c3d0a2ddb67f6cd06de5d78050889a63595',310259000,NULL,NULL,'4f9b2751f7f1ad366abe34039015b77268bb97a047defffb6fe5b1654694668c','dc583286bfc1c68ef9948889935e3d3b96ad3b65327846c2fcd321af82a06fb9','e22874d8eeb87c27b837488a65ebfde7a0f57cbc6d9bc49651e146a9dabccd5a');
INSERT INTO blocks VALUES(310260,'bbacf422d763e74663cddea4aef9cf7bdbb74d456961182e04814e76dd6c57d768c12fb65b8decb364d2463aeefae9f8afb87b99b99b8c076dda14a5a5e7e7b7',310260000,NULL,NULL,'15a97b10772e9ebc0d411c4ac9df31bb32464e08e3ee8e79adb97336093e5993','8242a200fb1c6ebde4ada5793b69f4f770307d175f1cfa4b2dc11e58a6171403','90851cd589f14f8611f3838e09f9bb358289e4fbae97c20a056cfa2b1643bc28');
INSERT INTO blocks VALUES(310261,'b38e530ac6aada95885f3bb1aab84dbf151173d2194af388db751975f4e9ee4c7c3da2677a8dcfb98eab4da72760785ae5c404a6a6c1f61ab8e759b9ca6dd12a',310261000,NULL,NULL,'ed15c3a4c44dd4fbcf4210edb6b20bb3fa859cbfcd193aa75bc6fc8a619e9146','fc056a62ad20bb9be2ca0c21efce1de4f0ca80bfb0b40739520293168446d46a','00a18409064bef5de972d24af3de5c9584b19082235e509460e6d442fdc298a8');
INSERT INTO blocks VALUES(310262,'329a9a235bb3084b2f8899d39a12e3a1916faed8aa28a2df7b7aca72c89903d3a8d697a58ed6488ae5a2f029d650acef7ab0f091095d62ce1cfb6b4b32aa23d4',310262000,NULL,NULL,'6a346420adaa7fa13378a61297f2fab6dfc17a79fe1f867c35e038f86ee9b210','260dcdd64458bdd58310934c58bbad6550a4f11896b38a488fddbd80e62d9e57','6a86b257619f5dd689db04909bc4f8e543ce85ebc446eb8c44a178c8d82a29ca');
INSERT INTO blocks VALUES(310263,'43cee48f0e0d9852ee3b828eac3f6bc14428cb57fbb8348db963c21b7427eb03aeac1462650a80c97eeb74654e9773c9b789ad9a12b88f62da06a77821410174',310263000,NULL,NULL,'ac6ce8a6b3698a6b43443428fb6497f35f4a6b9ccdc2a4312a97b0e70cdeba17','035b15e44aa45c2935beadd908c590a0697686050e900db87889227af428cff4','3310aab6b2dfb1ac1c07662081f20cbcdbdf6acdd2f4d40f0403f703210acaf3');
INSERT INTO blocks VALUES(310264,'be354373852f06ac45faa0e3650eb6f9afaa836c224c7737d81bcf5f79786dd3eb775bf8980078b89ad81003dc9b261afdf0c2152e6d8de4e285c2962b384cb0',310264000,NULL,NULL,'4c5dda7edc6fb8ffff11080679e460594b8c1bc229f25e55da1ce8f392c0c634','65328f3fc8075d2a70452ba99936e3433bcbe6fac37f3e142b9ba3e4f1b36918','d08ad314eda4a5b9705f8afc5c4ac33496c1e349b895225eef52d1c56808976c');
INSERT INTO blocks VALUES(310265,'6d967f14cb8425c0396d58de9aaf681a337fdbd4ace6a33a32f9c5523360c119962a868832e264f24ffbed3cf8172982f876abebb2908faeb46352b9263f97cf',310265000,NULL,NULL,'5f4a9dd2d1bacaa41710d9f751ff824c49aa002af481307d7d1a9c2596b295e5','2917bda109e66b607893d97dfb4126c07e44ea72fb82add6f47f3dae9ce56c72','5db41372fb9f50c5aa3b42efc076f8cee127ea4d646e7c54e461332281de27fc');
INSERT INTO blocks VALUES(310266,'4e350363a67c4de925636f42e82623183e13432dd41a0169a0a48f3e5ec330a809a75d6e6bba3b5468d3fbefd1636815e6ee37086770d0a317acec3498c99213',310266000,NULL,NULL,'4e2c779e878465c7dd72ec2f02d0c23c9e01aa38f73d4f0681f54f240df11244','bd5685eede4bac54020e7cead2e0636b51aedccb90f20998d20e30ca21db9608','48690aae93402b4f702ddfd3dd684efb7366f9e93ccb26bb9d6fa86a8cf38d79');
INSERT INTO blocks VALUES(310267,'578d02e8840ddd4cb36a8e7e32fe9424e7dfb027a8320b63d2ef57b682368af5748cf901aa2f5b0f4c2ea5981bbfa8fe1ea7dc2865590256af92f20da7a14d9f',310267000,NULL,NULL,'2819f7afb87f4941e2c555473475a8ac3ae1dabd95ff23d2112b673c5bdf982e','cb7b90e5a77528abf7214b5021f32d629b2f68118014846b7a94db2a78c07f07','91436d95bf51c9a278182cb0bce93cf13f1eb375a92be669efa13228d7e28635');
INSERT INTO blocks VALUES(310268,'ac55ff8b1c52daf132aad739c9ba8171cb224f0f97db6e449d13a40e59e7c99fef6451ab6fb88994024cfa8d12038eb60ec026f26e470b72d8988e3d7e82c0ca',310268000,NULL,NULL,'6dafdde7a5ce67d50641c07c6d84e4bd09ca3501d9ca819c77451e30a1f278df','8216c572bf3982d4d1efaa0fd01ae707a50b4b6717efd16964a3b3ad6fd748c4','691a5bdde354961782fdedb000afe95aeb80dc881e3e9f7c9670b114adf1fbc8');
INSERT INTO blocks VALUES(310269,'b6bbcfdd4921a7996cbb23215ea7b7ab4a9a2e113d764ccbe918c7fab37993328304f5ec154b98f2d82f6d310ab48227143dc4e81c50802c02e0f34f97b425e6',310269000,NULL,NULL,'817d2c40587a55194cba8a82e906f82b926743838e6bb1a7d7358a54014e256e','7670b9f6202bb9021f34004e6b8ffb175ea6fc8a546e75fd0c4326831aca12fc','a6eeea659d48aacca5f677a7ddf392331d3df93479c06cd3facb91eec1c37426');
INSERT INTO blocks VALUES(310270,'0b120e8e68a0636ce794708b4d5196869c8d3da2635731d97c79bd5a5eb4badbac8348cbe34941a424b923cecc0a493d1e69002e75724a700a82a9e93af7526a',310270000,NULL,NULL,'6939d12bf02621cbdb67608b6967748ca57e403dabc287290f15632a77188878','c6bf1e4196e62188395e2c670d79757b91bc788bd4ccdef4eb9ab207f527adf8','e9eb13929cf10aea8eb2fc3b6dbedf243dad55128be44eb3786b5a324b2e4225');
INSERT INTO blocks VALUES(310271,'d77c39d4ed0f1859bd78d5edec895dc30421471d55f306a1e98ba5d05e1e4b9182e0b5ab3cc3b398763d92051664ef21c542548e6d7adf5cfba4d5778ade6d45',310271000,NULL,NULL,'eea5e36a3f860cc606142b3d577319801a0d6bb1cd51f55b1379ef5e6ecb04d7','70f7f87b1313f454b751f70da1082a0f2ddecd2a92aa759292c538efcafb7272','114969191de5bfdffa8500d05011b48359378fc0733e1a0d285ab12cb2872ea1');
INSERT INTO blocks VALUES(310272,'054faab4b88bad25e7e1fea77551755a598b487ccc231a81a0ad9336fe09501c2f6424bccfb7c3247157d580fb7ff00fc484ec4c2688e377a1c20c99652ec677',310272000,NULL,NULL,'d0a97a83c92fbad38f605227e79b8dd666a6a314ef2f912ff5d33b9c4ed320d7','20d4ade39024825a56ee42ae6744c25b053f9a810d026b31f630c1080020e8d2','50e8b7a6e9ce7f576ef03a53d24074116029a0768d7ac585ac44433ab384b0d6');
INSERT INTO blocks VALUES(310273,'a171bb8d6586c3aef696cfe9fd9e48ddcbc658744a8097edeffbef5f40f98d8298d7edb2f70cc47adb3b6e492babdad1ea4dea67a717e8817a3c37c8ca0461a2',310273000,NULL,NULL,'d0b1518c3b38aee546f1f7dbadc1304357789a24f0d09cd4e7ff7e0f5f4afa16','4ee5f1aa9c538b1f1a7caafdc031efe72b6f001c68c9fba80abef38e8b35b0f6','0de84ff6bbf456ba6136c2cfaf7e87f4da3aca6fcb817a5646cd79c0abe7eec2');
INSERT INTO blocks VALUES(310274,'73b557dca209f386ea939ac0a9d98e0b876980773a7444be789fda03ae6c3ef9c50acc34639639ed6acdcf37e9cc1056d074edcdf058823338191c8ceab4ea21',310274000,NULL,NULL,'b41634c1116b16d32addf284799bed22aeb5170594afbc964486749cac9b9fdf','1472a1ca42f3de04f7fc516942ae3eccf7b0934a3618a6300344926d88e109ae','366f007271b003ac16e3290cbe78727292274e95ff055be916b4744ac0da3f7b');
INSERT INTO blocks VALUES(310275,'86cfd8be8a981a153d5ba5cf3558b28dfc3f9d260d9a652bc5a07c7588d33af90c6bca26c708de6d66da96f758d948e7c218418a323dcf12c50f2ae30ffddeeb',310275000,NULL,NULL,'d535a99e0bafde18a45cfd8c40542e50f579e9bb48f2004a68564149ea3e3ceb','6c4086ac1646e2c932418916a7ee3080528feff629b4089b61f713dd386d9324','6b0da6e0046a9a6a2785892e6f00c749d0429d013fefcf47e2a84175340910ab');
INSERT INTO blocks VALUES(310276,'826cce42a9d98206e34cb23fd88de3a762e4efb646bfc2b3a6b4a65083dc3ccf3048311bd14f82cb41135c6c3201355e402d6f900ca2e8074e74c1bf0fad626e',310276000,NULL,NULL,'3593ee26c9526dc20cb10cacddc3825ca4c63099b88cdcbdb0d7a7f87189a58c','5423eef3e5d50ff4994ac4c3f9d45200c71fe58829e7929d604a4c9f36524cc3','4915b8604a34e223cc62d27cbe0e5441b5d7d3459f413a554595a48993f9fee0');
INSERT INTO blocks VALUES(310277,'02add916255878e70769652c6484317acfa5821ab020b71919b0d8ec04fcedd8a1c63b9e8db069eee33865d88d39ad312d100f6d923cbe8cd73bc512a3725491',310277000,NULL,NULL,'b93ad16ab4f0ed55fa53864ee1e6a56fab2d0759a83f8b3a2336a45c99bf3bc4','6bd7dd14f726a29f04898489edc01f3b2fda33bb5e5b0b0b72753e0ea7b6b6dc','09fca659c08f9daa398aa977f4d7ce067f9bcb0e3dcb680099f04fef63171432');
INSERT INTO blocks VALUES(310278,'467e9bcdcb93dc76a0aaee92ff7fd9a9a490acb90fa3b2e6b92183dd2d7880e8375b6d1114d96677642b6c7787f1fd6987a71fc2607c0b1e86b3a9d3f32bb761',310278000,NULL,NULL,'ca689e8d5669941fe1d883fd7800616a7d3d774d55f96ca3d5ea927db8222e20','5fb38e3d92b3753d7dbd8c79fdeb70f6007df1508163d5006b8cb1d00b9a6a89','c3dfb1c68c4ef583563c94a07abf9fba06ad49a25c3c19a1884343529b74defa');
INSERT INTO blocks VALUES(310279,'220b0e071375f422d443725458be76bf1d2547e07b70dad68ce98f16654ff5c0cc28da1101aab72203df390ed67bb63599df1b730190f58258fd5f172236e36e',310279000,NULL,NULL,'fd1074bb359aaa67c25714a58d7e98b217a9e5230ace571ce5870bd9fd008e9d','092e76c981bd3eaf4d378c2fbe451b7af6392f6e5bf8e13777a4d71a0f99265c','f9588d3b00cba5f9c51507bc855bcd1fc525a8a811cf43a38ae6ad89af62ab5b');
INSERT INTO blocks VALUES(310280,'afea20e259ff60c16506213fa23f6a5847006ee596a36631e6ef71ed53bb226002822ea5e284ffc526b25f51dedcdd62e645aa9d19e59c7644cd996c50c0764c',310280000,NULL,NULL,'7a060cee25d32ee69b14bcca067b1f11823afb47d194e91e2f57542c4d74fafd','8be3e884555a76e33afa60f2612a01c57e666346c43ca6eca7e38c6f7d04198e','a0d71d3acebfbe8ccff9d0c9fa86be7d7dba474787b9087b2c663e7879f35d51');
INSERT INTO blocks VALUES(310281,'5566dd842f5804cd5ab2449032bbd1957a8faca05005ce257a1b4faf9065d9aeaaee29245f2689ecb521801b316959b0ec164ed36cd61c368ddaa8f906bafc42',310281000,NULL,NULL,'7a9f36df0ff433815328ba3d785d15df8f8e3d4a90b7c289319d1fc7d9fc14c1','9f945a9ae46347f879a12ec7c7450c04d778ebbc36a113b61887e1d8cef4f898','eb246f7b210599de8e4be5f40717519657a5841f3bfb93c8c8f7b71a51f78ef7');
INSERT INTO blocks VALUES(310282,'c7db06d41663e0575d55683a2209f9682a97f4a089393581821cd7a986667a30675162782c61c731b611facfdce51d7dc561d0d0e486932560f0e2a799f8d411',310282000,NULL,NULL,'ee99e14eae9a9bff42ccf5b7c28cb674ba5496c82b456e3f4a6f477788ee0755','503a7743e098a4b1c8c77543edad9db8e9410f1409db104d00fffca1dbf30d20','ca5fb548bd795aec971fd023cadf0b50bd7d92a749ef0bc764fdce6c5e85134b');
INSERT INTO blocks VALUES(310283,'6e856dfa84f3539d85735c94ae99b764db91b44b6999503b42819e40b25bcffcc6c9985999618af8c55ee1589ac50030830abf8a65bba9642d0637813a5ec7bd',310283000,NULL,NULL,'1fc9a9182847124c4688afa45f5d2e1d8b40882016d21c9f749ecf49efe2df08','de72650988a836fa46468e8f25ffcc60ab40ee5740f37508fe8543695e173005','aaa9c9c3a6cd3010c2029dba1be238b1cdc0a2636e4719381a993291a23a4be5');
INSERT INTO blocks VALUES(310284,'fe98f7af8ab0181da5d10499189d8757c75c69736169729972d061022656a03b79df21666abd106a6b62a52c96f061a49eaacc2b15f7ec7ba392e2e1d46742be',310284000,NULL,NULL,'a240d324307e549ede7d87432464c8282bf41cd961a76af5299795e91bc28278','819e5e9e13896fce5630f8680d5d312c118a9b33a6c0f54df8248ae577a84677','015c48c17ca75f3493ed5d0c0f365c5e5387039f362ff44780280b2d72ef1aa3');
INSERT INTO blocks VALUES(310285,'7a9695623926cff36e00a90465d0c727c155d3cd7c8bc28ab4b5930bdc841743c9a8e9e5e36ba0f0bf915b5722306b9d7ff53a93720bde94efeb8ae2ef42593e',310285000,NULL,NULL,'4ee6f0a5ae12a19296e88ff19aee6c8c111700f99938f8bc6611322bc8ee68ab','dbe0a6c961142ba1f19104a5fe9bf142bdd94cb0c45a87ba4804dd20170538aa','f1ba94cbf7e8ae35c04641edebf0b509cfbe41f8778207db118d6e7038eac399');
INSERT INTO blocks VALUES(310286,'2624ae522f1100520fb3dc295edfcae32e82f3e6b9db20d37949f26eba5d78bc94cd8d13624a0a87e045e963415aa2c7db7e243cf1f7beaa4a998501b02fab21',310286000,NULL,NULL,'193c6064357e22f87ac574de5932502996a7671aad4c938bd59c02053b6774dd','5496956c2c7f0e6e7ff10551667be2387c7acfb07e4db062d7ee4a84eae17157','6a8e9fcb2a076a69b53dd8f138f190eebdb96d6134ed05da8e5236c8b8a08f51');
INSERT INTO blocks VALUES(310287,'9214a0d94987dadff791b0558d5c16b9c9165d9bde2954d6e8d235ba3069726be601283d34061f818f130f46e94fa786c4d422a83a539c811d915220fad3dafa',310287000,NULL,NULL,'1006882ae3a0f90197d15f477938e8ea9d94523a94bd2c7ae901534757a0b854','0dbfc510841411c29003c1a4edd7a1460eb074d5696a5eb6826c60f6ca821c61','d6c5ca14eba93e6ab00ca9c0e8f5e0b3a2cefd1c90248a011b5f26661306422c');
INSERT INTO blocks VALUES(310288,'a4d7a0e721a4a7ab788f26845026d5de724d036ef9023745415f8b93214c7bcb47562d18a7bad38e121513093675fe36673d156293f3fc5627af25a70c69d161',310288000,NULL,NULL,'f07fb54607f1948a002a7e07f9af30315190b367dd9d10760fd9531119e9d6ea','baa9d79f910959dcdad31b10ba3893928ce66a9231a65cd0818dc136b795b8b3','c6229eb9e8bc47e7166669dee231d373ad4c58b0be44c2bc5ee9489a998a9d2b');
INSERT INTO blocks VALUES(310289,'6f959963ac7d132fa919eda3c2e485b9447723b048675bd38e0107ab57295a5a0af1d97c1310d4f527690a5919e77d4bedc3ea45ed51974ca7072a31d5166610',310289000,NULL,NULL,'c5bfc9bf97874643a70d9de992549db8045affcfdc4cdfdd23d863118775cc3b','1452e67be7937ec857473056905bdc8f22818753fced5f8c741781e8324e1a38','cf50321825246871315033cf5b99506ef93068d06516f64872e8e202466d6ba4');
INSERT INTO blocks VALUES(310290,'6a3ba0d21e789f852b724811d69a5d89024ec6854b7b75cbbb7c6dd9ea2c4fbc5a3437fb76a01b4d20545bcdd4ad06a2285ba1bfa5099aa6fd0a877a413dedb8',310290000,NULL,NULL,'59e24eaf7c881b7b3d665b24996770a81e44f181211865c495c5a2d376b58c29','065e9bf766021e3e642e670c6ac7e208a38a01147e211d87119f4abf7b40b8cf','d2695597801ef7b0bae7d5840099511a49e9b5452832d548a69c3bf2bf3c4412');
INSERT INTO blocks VALUES(310291,'1ce62e1e518527fdd1b698ac4b42cc6712d539c55a748b2d37b1f942c013b90077abc059f6b78650e3834ce9ffb14cfe9a3e6f42ccfe1eff6f170390940c925d',310291000,NULL,NULL,'af5831005b4584f4f4b324c5ae579458876b93eab87ab9b346c451ac6b076d8e','b475e5a6d2ffe2b58a8c4ea81b7fb2629eb9a0a700c55da2c728027b83746500','a9eb54e8d6034bc4af504f6dfb209a1dc4dbd551db28051d6601bc0987852548');
INSERT INTO blocks VALUES(310292,'4073408de52fea7571ff4d12b63503805d67cf130f794659fbed6342b0dd8f53c2822e320db58fc45dc54bf0e8010c9dd24c62d38052c2cf8cf8c2411e86177b',310292000,NULL,NULL,'1b790bfb4c4ed41df93be2b4b07f03605db002df487b21143f08835151630d99','f4a65aced8dd72e1f5476ee46fdb1ae73bdd78a429d6ee0de992e78b5b8b1821','2c6a61d0815444ecdd13a04daa9669f9418eb6cf550121c04e02534e7b0191b4');
INSERT INTO blocks VALUES(310293,'003486f9100cfb991b673a59380125d9536c5242eecaa36dd1ff339e96c26d4856c8acd845e478c7fc1139c9f177baffd6502ed7247000d944ccd05ab6048811',310293000,NULL,NULL,'8b8ae6c5693ac4f16f79a71c3e29287f5e3fc556f5c7370719a16c332674aec4','b740c9ca06fcc830040ea730f0fcb2ac663af806662972a1d5e328dc45faf34d','d98a475035ce38aa740ccc347fcdf838d23bf8570e5201e629c3351b43552bb6');
INSERT INTO blocks VALUES(310294,'b2b303fa6d9a561c08511745e8a0c1d31b7774d93d9f79773622c40ecb0b8617e55bd9fcf663c21c598567597327b4bb7af66b4de6bc924d5b168777e4f7c626',310294000,NULL,NULL,'1a71ec342c956800df0c104d6d779a1b632c5fe6dfc8d0f1ef0329526e8b2aad','0b37a87c9dc3ac1e953f66ea1d90ce4461e1096d2f3e2ef283fa840e3e78207e','238d12a3a1efbc1a769d0a5ad25202a2b8f2d9f1d6bb952612fef434e7a88a82');
INSERT INTO blocks VALUES(310295,'4f8623f4cbdd3d19c8c104468f4446b9a2740e2edd8ca76b824eed95bcb98037a4d2b8b10dd46b57e4c0ab4e6f463d8a2c21d51b87096ddcbee70413eabe6c23',310295000,NULL,NULL,'1ff2098ce6f956e2b4d02edb8a74d9e4409c9408ddb04dd582042a7fbc6d08f5','c44660f50d9f49513c02cb221e06e3e6dbc0ee731aec3e02815b66ab69108db4','95d77623ca1ce8947ddc34336a555347df42c2d8f44a4f177cdf993557aeb09b');
INSERT INTO blocks VALUES(310296,'6dd021fe0c238c4a9cbad9f27b1fe6f24239c9857542d4d4829d6658a472d0066b622ed36e5bcf85a50eb028805cdea878797633bc89434080e974b370d2515d',310296000,NULL,NULL,'c1b8d85a1b89790dcd5efbbc67d4280d03198c9882c82c9e271162250524ab2d','574cc42e40f32171110a065d84b957c7a11736ce17df0220ea4594862746e69d','3f0d89e55e904e84bdd1a7641f957d8fe0e67de892d9d5ab476bbe4842098b64');
INSERT INTO blocks VALUES(310297,'3925f11e402b0e127d943c5703b3db99bf2c1ca4e7877fe578f42c38b92a13ec115f911b732ee5edc5ae9d80c7690e4ec9b254468e3a2d438c722dfee4bca75e',310297000,NULL,NULL,'0f61b36962780b58f9ed822e9b1184651c1e6d95fa86fa2be475835a0ad69b5f','e7ef3bf8586246d9489b48eff3597d09f21a0289a9958c55cff6a21e230b6562','e288faa4cf46f2734b7abfe774c0ed3da53b03fda4780e27e5d8076aa83e34e4');
INSERT INTO blocks VALUES(310298,'5d32d690b68831edc24bcff96f1b6129a22b3b977a1fc4775cfd038a76a812bc0b0d41ec58be6f7df61043128d0346179004b11a0e5b4b979efc5babf699e102',310298000,NULL,NULL,'2e2def02c505a63301c68bf61b60430844537eefbb963f76f6340b4201a8aa8c','d0c5e15b128b90a655ace793d2a8f27e296a4da395faced50bbea70f19c6eb52','5e08f321c07641456f99ff5de0c8f7cd259efac2c2bfe0d8e0a44738fe5f42cd');
INSERT INTO blocks VALUES(310299,'1f5018a44c7217b036e1f5efa7c12fb3145989bf61c9b0b0cf0ac8141ac676d2f1c5b8c2c40578c90cd5a6ea218c55a71775e8c52b81d98786606754fd4a130e',310299000,NULL,NULL,'4211ee0446e575c7c10cce4f686399c0435c3b76d14cba2ca1163e123fff69ce','5ed507e3c79e2e85524a938f2c393ec88d6850a756cf1f946030c5ae5a939750','19e9814b4445fd11bdfe4ee1c693b2138dda33777a5a26d65be2d252bd7f5a39');
INSERT INTO blocks VALUES(310300,'bbb7d684bb01cf40cf1bd412676278f0fb99c2d85b89de148e8958513a121519f54ded1b032190176324cfc89e4a59723c94ddecd8cf12c8a0480a49a2461f99',310300000,NULL,NULL,'6b3104a8b944a5028f7f83e889065e32d3b22396c0c718a32911fbbab75d74bc','0abb1eccb125610fe7159fce3a6e86e5294886e170d10c9f825aa1b223828cbb','0acb23329b1aab87f620393c703c93bbd0f33b59b671ee8e9e9fbfc3ab5100b0');
INSERT INTO blocks VALUES(310301,'92a853ea11ef50c188fa6009d019f8cea56d19f636c9118fcf8b24b98f9aef68fbe37a1ee00e39b3ae20204fd189180e1227279847925edd736de60d1cc44310',310301000,NULL,NULL,'258c101910a2e32bfdf363e755f292c4eee8e4b5bf52e84eabae01f73dd4100a','95134cc54f57fdef2371c5c6c227629f6d68dcf07cdd397a5731d35300cad968','6df0fe447b0912c0d80d9982572ea61cf7e7d14ead194fdb149bd8b1febdcca9');
INSERT INTO blocks VALUES(310302,'87a23b0e57a3eb9cb2e2dae0c2215756b7e59d3e845a95d58ab216b3feb01d7474a3258dedffdfba55b84fd4c7a686879f24a99a24cf981fe14a0bf5571d63a6',310302000,NULL,NULL,'189f5a0b6e29c51297fdd56dab6a763d2d996a948c4c77cbd05e1fa647850a45','bfa14f167b832cfd70e516199cbf7083ea4fe8ef1f1ceee7afda0d8787bf0cc8','9547ccaf974009dfb33b9c3ec91544bf707dbd1d73c7806a3e6c6369a352a92e');
INSERT INTO blocks VALUES(310303,'0a2826fddd606c82bb20943be515f94e78f75fd316b78daeeb0ce17f4fe8459dc4e191ebdb2ecf6367f64f07f8f9ddb1390198f5233203df06225767151834a4',310303000,NULL,NULL,'08d07cfaf06ecfd5496580cc231f68968eec63d7b0a517f3ea117e25d9e04965','ac415da89b9115b67e4621beab7e7c9e3a267d3122d269fd39de35e60e4edefe','a419d68eb8bd5a8cd66b2f60e0c09a4e9b94cd5d9ba593296e111a8c1cab347a');
INSERT INTO blocks VALUES(310304,'21dafb9130b529fd2ba53c761f1636bf89a97dfddfd333e60260062e5112bc0e326f015e6a82e2d7cdc743752349bfa2cc5fafd914a65c09c74451ec79b17ad1',310304000,NULL,NULL,'67565d3291aaea19e5a3009caf73c979c2b841c89db39880ab5a11514737c897','752634e68c53166019ccf8bdecbfa07827773f51c85d56fd96d048f4ec6a46b9','5763470135d7d73a374707a25caa36e14271a0385b11eab453e382f51e3642ba');
INSERT INTO blocks VALUES(310305,'d9cb2851ce7293829a5c4461a4c1fcd4bbab46012b449224f21e10d64fc7bde8d8f09847c236f2edcc7d8054e8b0672727de121fcfec1022eb1cac832a252f26',310305000,NULL,NULL,'5da0fe493e1dd01ad51600cc54fd702f42689db84f197f1dd620f733b4996844','f020afa7edc1f77efb5330ff3ea17d7efca9d54c924137f01b80e4f2467c6f30','913c857ce165d8bfb85874aaf94d29a7e3fe3724b9740312f94a9d7d2fb0f4ac');
INSERT INTO blocks VALUES(310306,'58cd7308a7f9938dee45f72fb9a559fb9c6b1a4937d08df694dceff41b2ff2eaa3a1d58677a1c000002f13e4e9842233ff99d035e1bd2d11b986923ec70e96f1',310306000,NULL,NULL,'6f5ba33fc95c1c4bc5f246a05b2d82cda4260ff4d5d9fa71aa23da359a64302d','b425d9bd9dc0f4dc083443e664e489980b37cdbb286c0eeee2c52b8bcac644ab','ab96fa8935b74dfb9f9a06eff192327d008882d2c1e7f178421967c366bc2486');
INSERT INTO blocks VALUES(310307,'962e842a8722d72b9a24eb689ffd9740bad6a522c214e3b007775321459e9f1164a7323868bf7a8444413510dafa902769d3a5b209434ca1dd4d4f557bda14cc',310307000,NULL,NULL,'26576a7c3422d501d90096a8253aaff5c083faca1aa31fe2e9277be64966ecdd','d1ad13bce812f61d88bfc3da6ac35e642f239564068ebb7972dc407bf7598e6b','6950c20a35c9dfcaba91a116c3aadcec50fb0772b8d0c2b579fe7cb7ba5e2077');
INSERT INTO blocks VALUES(310308,'cab1dadfbd7dd20cb6d6856929efd60afa460eab4fb1901a04578553494871800c7573a406ce1551cfd51a4511506bdc0e1666470a39df282180776820419d7c',310308000,NULL,NULL,'b57420578d1498b901fe2c80623be07f40c8ff582bb12b94d49184c584fa1b0b','041ed1953b0f76a23e6383d06f7be0e587a1a555d96529b6c0ff86ad39a7f528','81c5b069f0b7d893f0fa791cbc9523af9a7118beff4ff3954f5365c03f59bde9');
INSERT INTO blocks VALUES(310309,'026906f0aef4615af04b5f9752676e4e478b571b0b80066fa5d949e5b9341a8e693afce2c1ee50d244024de6e73d06372d26a1b370b7d4f8b2049481cb9f40db',310309000,NULL,NULL,'f279530890b17efa9aa39d4565f307f43c9f0df320aedab6c57c62079fd7ee38','b1559322d218e282921385ccaf949d45bd2802b7f7a61d5a663bc83e6022af76','ab3a665a7c65ffb8a21f512a17562759fb1f5d3655ee3b266690ca0518b99ea6');
INSERT INTO blocks VALUES(310310,'64a3783438a14dc900c87edbf5a67e8b6ea58772ed60a90b580b602be8765ce5e22255c582c485c82e530d4bc2c0d085a1a468981d6dce03e85bf1db50c03517',310310000,NULL,NULL,'9f94c38607e29930e50389af22dedc43c7bab192cfd4be3f4afb523149290774','c487876291479f107827e2c21f749b5fda84dfb911aef3baecc5fd0c3f4b77f9','4fde69e8adfab8e610308b6c22db8213a41d511a9704e3553945db934f232889');
INSERT INTO blocks VALUES(310311,'9d6787ec7e78e5ef1da4e0c01cefc94476d6d94105537cc3632a07ea60645397968292f7d2cfbabc12abd299d61b9a4b25bb88fa55850a94e123e6ad2fd2d7c2',310311000,NULL,NULL,'1bced45aa5b7c20b857fcba897f3ca0fe6fe3fd78ce848bde1605b008a89acea','64781b179922b573a66654d614344e951b31eb3885dbc7fcfd8aa83825faca91','9069fa1f1a85ebb7e994c34ea227e6c4797f71a9dca062844a13955df4bf693d');
INSERT INTO blocks VALUES(310312,'c699c622fa8fd4d10cc80fd2db029660fa6d9d65e00e5ef2023bd5f9f377d2dcdfd7f474601c202380f2fbcdcfa39f0e238a4db516ca470ab112bde1614a10e0',310312000,NULL,NULL,'700dd796a10c9d83e532a2d24b999a17680c68f7769dc9e28bd2be16aa649744','fbe7597e647abbed9f0b5bfb2cc61a5da9d073f80ff4aef771e36188a43f25ed','9ad6a51e726b27ef93b2c3aeaf780c3e55bec2b3c66f8f2f796c2877c36a5e48');
INSERT INTO blocks VALUES(310313,'67b5753aeacc18b7d7f08ed314ea0a8c85f4f2c53d1c632d4320c5e55f493ab6491f3b023a779cb214bc52b49d8899a0060f2bf9a0c9ca242d69715e1f80838a',310313000,NULL,NULL,'b4bc3a7076cfdc64968e3d359279cc793dfca8d5f9a5fab820e25ef1a82095d9','d46654be36131c3d3f8f07f418b82a5c55877bafbf65256c4259f1f68f7927e2','8037c8904b1146df246018a8b1df475734c5799a018447ab5560a7bfa9dd8666');
INSERT INTO blocks VALUES(310314,'8c7e3bcdfb8b5468c68460626322ef21ccb05d5b4fccfa63fbba41ecc0988abf5672a884378abb8ce7bb35e6cccdd63765a9d052a575d30ada5b3fec51a61aba',310314000,NULL,NULL,'7af44ed5fec7c5e6b6cee8a968dfad313ee7833f44d2892581e8772b5a4e9ce3','48814ea5b4ba8b177205c4416b1279feb2b870bdc276777e2f96a51d849bf8cf','c2a62c1a256da348ca15930cf12096824b4d8adc5c3093becb51f4046c72eb8d');
INSERT INTO blocks VALUES(310315,'2859914ed7ee244fb079ef25ee5a7eb922d41e085a8b53b9c604a84946252f7c2c5d3bfccde6001f6fa94acdb4512cad4fd80d5042553ee8d5bb939412fc04a9',310315000,NULL,NULL,'8c6abb22f47aca526d9cbec09b700eabf7531232be2f847f540b45544ae8f5d1','86070bdc8c1d35b90c08bf6c1b3e02dd178dd85366db35dc3b2005896f5b3057','0e02886ced426adf46fd70a79ace68fd1a415757af29d42a20e5da23cd748749');
INSERT INTO blocks VALUES(310316,'04cbbb66c280fb3043cf43031476502548e11ded92f8b076220b3190a33ca0ed88faecdeb31be0f6859138cfd0b7acd750ee9632eeaa0ee66772232b397fcbd1',310316000,NULL,NULL,'90a9beca5983eb23437dfb6df0f3f40d29ad0bef4a1ad9051bb32b0102abe297','313e1fae911af801f8a5e1b8e2ea8c9fd5fd7da290a0cd7842be3080cb02c627','cd3044d4d3c92ff45e033e0a42d03c3b1637bd008a107af6faefa72139fb4e2a');
INSERT INTO blocks VALUES(310317,'b44e94194c4cbc3b2c49d5232d8a2f52a09abd88c80f731ac4c36da0e02e8cdb8859db0324c9e7ae52c0c209bda99e4fbbf5d584cb50353073eb27f655d83511',310317000,NULL,NULL,'a6a0f05709d6f97b17948cbbedacffbfd1ce0b8fa2c5ed4b364e59617d2bc34e','77af9661424fc2bd4bb8ec9bb688a3246ecde450c7cf9b66037ce75c50aa29ad','e913f0859fa6cd60f0ed09376a1f5e765b0ff1aad729db3bb4ed9402f0adc14d');
INSERT INTO blocks VALUES(310318,'aeb7f90cd47f67a38e54cf219fdf6ba2d345f8f1b1c24f0b0eec974f5568c071f55558640702d14c8e5594ec964708b2bdb0557864e3966dddc47f13501a9ef9',310318000,NULL,NULL,'0baa6700cce5a64bdbaec552c2dc9f93f870f5f8016e7c154e220cc8c96a2cfa','edc8d0f5339b315b0733cc2620c672b367802f763d89d64d5775960672a0646a','aeff0cdd273849e4ece96d04ada2f100fe0cbce887e6f764b93accf95ca39ae2');
INSERT INTO blocks VALUES(310319,'c7cfc236341db1e9ae171105bcd69f4bed9e104c677fccd496c10351aab2e2dfe4b930e552237aed674615320d33fa4dfac209aa63411ae03fb9392fbe0b7fcc',310319000,NULL,NULL,'983dffd1c2867278af959a9d6b40ac8ac2585f5d658552d4897381f16208dd09','a344c2eae35a43bad899282294b3b2bf67595e6266c76032369b57815296e899','2b647cad0b41801cbfc8dc0ba0273256a20ea22eb8ebac7960b8185d0d182914');
INSERT INTO blocks VALUES(310320,'c107f8fdb811b81a405891e79ab4f409c122f706c254e161cccb95db3e2aba5f5c7e8c11b1ff055578710b0209a311a1b011b9761ffcaea53e3756ce3d994ccf',310320000,NULL,NULL,'aae1b550a78f0c267a5207cf4ff94b396443ff068b7cb46c890e4e160fc3ab7d','bb54d598a32129a483abab4aafed30d486935dbee34f11b39e8098af45871f0a','d70514a074bf91e4383ab7534001f0f3a6df05a923a8b13cb22585e66819ae59');
INSERT INTO blocks VALUES(310321,'75ed1256404389d1f448b33b47ce03e5e8fd7c62f1284a1ee841018937d9f20286875901aaee85775af6139d65ce8aff852702e3ff050e1552d4f53a1e265d7f',310321000,NULL,NULL,'f33364c4456f5228c9c3c60d6c9a78e137a45205795e0e2ec278608dc68cdca8','98616b0689fe91e038df10b1e63f0af7f13e12ed5ed5aa4e223556e195e661f3','9026dc202bbcf663669f175b825fad34d5911cf9ffb05f6c778f7ac236bb82f2');
INSERT INTO blocks VALUES(310322,'aca61058dc56a84d01999d58a29ec73c0f3fe5ef815ffb02c8acb69b24bacc7a729e3fa56734d7f8ced53f8891f78cc6e411f79814cb03648eaa04cd30b9098e',310322000,NULL,NULL,'5992b40fc610fcfc937ff3a18a70c688c0238509af43f4752aacb8488720fb69','66c2738821c5fe4d85a54f38f8f16b9841f4e4c13ff6ae6878d48eda2992760b','3c3c50f8a43f634a2c97fe0f35dfa8e6b98214484b75a629ba52548135810995');
INSERT INTO blocks VALUES(310323,'d5c93c1a33425cb40d77f511da1da7d18b4f8378cd491003054734b03ea0d82ac185d356ba05d2bdcab6cf073b8fb53ead8abda263cdd1e6f4c0ae3d2c1f2012',310323000,NULL,NULL,'7e5416ef309a5961968dacbaf5ca3a3f69fee5993e729bf70ee19c2ed6d8dfa4','8e095fb76f9efa5e678e2e1945eaa836206e8dffae98e2f05584854533ddc1b9','62dc3a4ff70bbecf7bd7539582a73e469315ae9577eb15a2c6b104989af4cfe6');
INSERT INTO blocks VALUES(310324,'629cf11346e7c18b683776a3856fe13f6059b62d646eb51a4a7716d28291b0f85834c00cb06e9e9714aa3c4cfc0ac69480b3e28a1fabc87071947dc96a3d7336',310324000,NULL,NULL,'be9b8a9091afe9ea0f17ea351804229e6c36b72085662cf117c6786eea4a8e32','685106f50a068d8f222f05ef652788fdff3cf9c8e4df3c46d037b798700b853b','858ebcdd445994d21a12d344548b75be1287fd5cfb9aed0fe1e7600443f31897');
INSERT INTO blocks VALUES(310325,'a85d6412e13acaf7f4b673c9f7b1b1ac0dd5d7db9f2b0293082bbb6e9afd5b7ccafe219d7bbac7b6080819225bf85a8e92090f256f93d2a02c50a2b397366f52',310325000,NULL,NULL,'f17add22aa8097c175d7d96f1c86fa8e99e7c0083e34735ef0b1f4457200948f','7fa4fa68d2c94f9dc54367644d6dc143580f63eef2a3a03e4fddeb8d254eeda0','89b6416365bff0332302968ba9b1653a94a7b620a9b6942dbb8fc993dabcf33a');
INSERT INTO blocks VALUES(310326,'8322e11f2c93306a455b7c03ed9e39d4516d22e3c23360e9cf3ee9ad88b4d3e8c2090aeaf74101e98ede9b037a63b252bf60eeda20649a6b92b4ff2723701289',310326000,NULL,NULL,'6daabbab453772c1d7382f5969ab646f2f708499ee91a8c32135b48f1f8072ae','d0815490497ab3fc59f15158f3d0077c3a70dc789f19a121639ee762140ad4b5','b6fda9d9ca6510fed4f2526330e00ff5f3f7d20811f75902fd236e81e16e6dd9');
INSERT INTO blocks VALUES(310327,'b664bf99ef0dfc4305aaf124f26c8551a9e30a7919e77153e31e9ea27fee6b151388db1ab1473ed2adfb01d861ae7e2441fc40683f0fbf271ba41bb3f46dab64',310327000,NULL,NULL,'20bed2916404277ad43c8fdcb1bbcb82b7dcaf3749c1efeb534cb0c40778f56e','3d3d3bb0ce483923d1803913d0a9df98b77878d2f3da766bbdad6340e77212c7','a5e09c2762538c09b9f1c4077cc5ec61859492ad9c664826897e247427e0c5cf');
INSERT INTO blocks VALUES(310328,'e3ab8f0999cd157c21828ed63db6b223ea237afee4bdfc7f7b3a5e4e8c75309278e40be942a2e24f123304c95a176721dbc6cb9e7e8b2d07503e81f1d7a9c179',310328000,NULL,NULL,'b005d9704e461e2ec95232687a2a1fa9f734ff3f021c74e9d73bee9bf445d704','49f6d7a15ac9b21fcf13476d6c70d249c700bc1894303aef6c5ad5973a0cea83','17b8ce2c30e174ecee15c0548dcabc0008f5ee8bbe1a3a8a0c2e4eb306af578e');
INSERT INTO blocks VALUES(310329,'69963cf15f2fe78c41c2b9c7970bf203a201abb695cfba9f35c69288dc7b19e4f5045012cd004c47f03243fef05fc96d759b0cb82bae76af051372415f660e7e',310329000,NULL,NULL,'7d3c45821b506566a0e82ca0ff8c429f31c9680304319d0bbf4279bbacbe9d62','fccdf91857c392a69148e0837db0b07bb150cdc2c4f56a92cdd9d679aba5bf87','37616691e55923526e971a53aa2cbaecdb3646f488f4bf448d7ae2a657590890');
INSERT INTO blocks VALUES(310330,'b746a968e4cb45f34bd4638d6ec4fa211ee9cbf08db6fcecaa45c66910ff46c73f43b73bf038792e9311f3ba37e1557d66744c2549e3aa95544dbebe2eb726d5',310330000,NULL,NULL,'02deda01fe4602d9a50d5a24a1ffc6bbff9f2e44108c4bf52c4f0e9a9b07b2b9','8b1775c22afdfb5ab01e19514b462269b7604b2edddb6eb7659cd49eda733a2a','d4749c62b13268a35d1d81571e036522443a657bb12e812f430123601372c0c6');
INSERT INTO blocks VALUES(310331,'d384a46aa6d7163491bc05d8faf83de0fb77c8fd5258f5e31a25c8d798344dce82274998b0696d71a062854fd1fb12afac38f3e53ba2c65ab15834998478419f',310331000,NULL,NULL,'3498ac747159cf14e75c869420d3bdfc5c64a97f0fc8ffb3987bb297547f614d','4052c9f53f03c55d58fc2db2e3c45810e31dbb041ffead24ba3f3d2b574fb7bd','0e2719a0b7ee0d0e91f0d749d279dc9816e5d51ed3e5126c8cc2c02df6c710bb');
INSERT INTO blocks VALUES(310332,'260d20c3df6ebc9f43279fc0e67ca125b56111870e24366018d3917e2ef9f3301a14506edb8503d12e5f149802a26cf4faa279ed967208c0c7e87fa5b10948ab',310332000,NULL,NULL,'58633ba027fdf3149a0502a3c2c49a8025e66f726ab6d0ce13818c711b505f72','2309b8b48ebf9883ea7e38b4048795a4bdb2f36fa84643457bc983d87459ab42','8863e2c5d4c508131848c2ea25fe6cf726e0066542fa798f7b5da3c746d8e682');
INSERT INTO blocks VALUES(310333,'7e32479c3a014b1ff8531f8184a88b172bafc495fffa7ab00b3de68c6d93bd58389ea3d2ec185a1e12d79ce8f9e2fb15c46041eed58514566827466913b7faf2',310333000,NULL,NULL,'dfe017ce3f1fc043f2769ff89804f0f5071f3f7c8d3bc12094332db3236ab0b1','003bbd5998f05dd7b72cda19f9dd5d67da4dfeee993c03257b6f19ee5105dfc0','95dd6159c0855a0a73fb868905122c521459b751f77ce6fd908766fb57032bb8');
INSERT INTO blocks VALUES(310334,'c142261b2b8d7991e382268b545f65bf5cdc0894fa205b53c5db06f0120930b8edd76cbe4cb0f4a2209daba3877d1d5803c2f8a8a48b53e0835cee2e840a78d6',310334000,NULL,NULL,'23337785c8935ccd68af025d5f838a63c665e93047b9af4f7df7c0d656e7d779','44ad175c3fdb52dae242a348d28d3fd1f258defc8dd3f7d3f1c2c319325926e1','e4cff78d765116c2a25542f3c0d2feeaa127ac4ccfb87360413615931566afdb');
INSERT INTO blocks VALUES(310335,'7dbb2ae1f0cbba1408f32b46a7815776ad7d03b41dd81be92bca10df442a97f9a0dd68044d30bdaba363e3b0404ed2d17fafdb733ea49a5838980f8d9b3a8083',310335000,NULL,NULL,'21ad6b0d34617fc63348262c00823399b74d0528cba8f9adad2d9971ab538c7f','5c4da88e967e61d6826ef5d03673a7a3eb77b173c1b53fd5e7075966b30162d1','bfdd7015aecfa2a86eb6d27dea3db8d179c96698df9f3c8ff7f42b637abe44a4');
INSERT INTO blocks VALUES(310336,'d911d0bfba2d67c5642f7f178a11b48e38450f623d5eb6d7141396a61b16df08ec1904fd1c90ef869b11e5949b1b7140f97927523b8f4b3dad3bf5ad873eb74e',310336000,NULL,NULL,'c1b112fd5ea481c8dfdfc85cfcc467a7be613bdbd111853bdf0721563f2e9aae','834e9b086ad86f7111aadc00f1e7cb150adaf58df1e2b8c9ff5d3e543f07cb49','891f2cfe6239ce66d419af18629d4e3ea1149bffa82c7bfa0bf4934c2ab004df');
INSERT INTO blocks VALUES(310337,'364654dc81278c0924a693cea958e57a39dc62d998d4c954ef104deb7928d82ef87e39e3ace43f19d6781486b2968e2edefecdddab42e40166cd3cf79444e6d9',310337000,NULL,NULL,'de31161e89269d97238d64e4ecc60edef6a8aebbe63f41f4afacde8aa7c23bc3','715bf5e3598254b89e8ccf15b2ea1bd641cbfe5fc9cce5b959a929639ca73069','f1f0914dfd1b0275af184429b009214add94458aa3bdd978822cbb524be62d5f');
INSERT INTO blocks VALUES(310338,'46bd830f13fd29e0cb8b06b4f0f2f54ff732f84dabda71def256133400c0b5910383634d66033673385b6c46bcfb3760251cb5e23d376d339639d1ecdb492f28',310338000,NULL,NULL,'99454c2cd802b9f6697ab73f1f48560ecd2acc9dacc1c9b0070ac0e5e97b9481','7be17196350be0549253c1210d4ec6ff246091a98f984b6822f3d312bd10998b','df4467d112d8826d19e2725a1d8a69cad472c2900fe0758a15fe320d6d231c7a');
INSERT INTO blocks VALUES(310339,'3edeff265209629eea69034cd577f087edd41c0f539a7c4f6a9ff46ef029420e5fe7da23e6e0b8938dee3f29335cad78f158d1f6ad23d4c72f7032ed99ad047f',310339000,NULL,NULL,'3a0001ca334b89a9097c3e8413fec7a9032841a108b00780fd0f0eee7069ab4d','f267f1ed2e6ffa748d38448bbe565c371e943ec9ba560f9c151b5b93cb49b541','23c9d9f644f4256bc8440826edb307b6e04a3276e4f2f474db411cefc56b30ab');
INSERT INTO blocks VALUES(310340,'3c71c95332c52d5c9ce2c097fd8a61639827320d899ee9dddcf9f5a7d420c73fc920a639e858ed4a3bdcf778f10978eaa3b4d6ba7e4825520c4af8da026cfa51',310340000,NULL,NULL,'f5dc44c15cb94a6acb031c2a31d0d71c9e763d9ec7486f05a57107fe9c1678df','d865e1c798edc7881e69b7fa40357b74a7e59dcdfa2c5413fa96e07d9b2e1378','dbb92f2b30648e312814bf2785786d926270f6276839b3ee4fdb56e7da81852a');
INSERT INTO blocks VALUES(310341,'ada94808b0a11f385f968331b6917b1afd7d34bf30ca89e3ecb23e0352df87afe5f60467146afca1077b13fe85020ee3734277f7df8681fb9c774cc6882d2bb0',310341000,NULL,NULL,'0c82a0570844ac419bc562ceb11b06b15bbcaa3ab96af25bb20b705fd8f9139a','6024ed28b1e73a0c5a0cf4fa3dd54fa57c8dbf2815700586ab1e77f5195c5701','875cf30690b576a2a492554e823797e39c9735915092ab3a3434c1c5a6a65b46');
INSERT INTO blocks VALUES(310342,'833c612be8daa3b6e7d9d73b9d9297916a89f358d6f4afa82697e66ba54fed08a4a2fd154919bf5541a89d18d0dac651f86f04e889a44ae9517e6d7dd763ab80',310342000,NULL,NULL,'4dfe1796e2dcd2799d203dfbbac77e099a79cb8c4668720e509f7d00bab60f17','3efb629e56a5c1be49ef0ef5301e5126586aa71e1ed9045295d2f04cfd8abe1a','8f4d2f1daec429287aaf19e32a5e7eb55ea2ccac542665247682ab27a46f1cee');
INSERT INTO blocks VALUES(310343,'1208824c70f96ddf20e9b71a941817095224228cbb455c44acd57ada445c407632a764bb2101c732faf95d7feab818bcce1c52b58e300e6112f54e20841ff0ef',310343000,NULL,NULL,'97cdec03397fee25e9e5a84cabd3fff62eae43e56293f531ff9a89841e1caab0','06e3c3adb0660771d97bb1c4d5d18b9b3f381e64f2dba09cb69d7a2f3e22da75','fc5ed3558e21976a020e2942b2fa0575e595c4df3116ac942001fffa877a767e');
INSERT INTO blocks VALUES(310344,'19cb4aa3aae81fb95f3239ef756551b2828163bc6072cb866826914a71cd9ec17ca8a9802d99e4f3c17ae7407426eb92a0c91440905bc98522ef0eb04a2ed117',310344000,NULL,NULL,'21c6efc88072b07eb3dca5fa6b8114f0d51e79254467282af9f9455900c43eb8','f1d804c3d56818aed6cc848881a23f086fc0e9695113e71fdfec83b5614d2776','dcc05b58f27948806b3987c403745dea7e593b9f756cb24f4aa83017e93a980b');
INSERT INTO blocks VALUES(310345,'47ad8225454f301c2c8321674c74da1f6e4a9de85e62c58154b12e19242119933fdbc0508d273afa328be196d338b8c49c70346e8df9b16ecb1f41b420370e54',310345000,NULL,NULL,'a64014df9eab6b53fbfca581417695843f0ce50c6740413a9a19a5a89f18e00b','340f6867afb39188cda82111b31a7d1a4dcd2918691afea2a9bea5806032389b','b61d0c5545b27dfffc5085c3924c108403d3ec502ad0f7e73bbb4809bd817ca8');
INSERT INTO blocks VALUES(310346,'5e8941c8d243d0de80626f1c45d7bdc8aa9fb785f9befb89b650f391ba377bed233041eba3149a1aa4803199e6113b52ab77484991e59c7bc4861a148f1cf757',310346000,NULL,NULL,'9e98e7d369f5acc3c50d91c1d7dc0946cebba20813c8c94a985dc172c8671f22','ef06e4f0cc73eac92031a172dacdfbd77fafb89627e1b75e839a3b747adfb6d6','417e40845b9f2aa5aa0745deeb3006ec6f178d9d008d9f734c3370ed69b614c3');
INSERT INTO blocks VALUES(310347,'24b6e5a724028b8a70724e34a1481c7015f0868acd440b495e1c9c82c794d9800c92ff333e5fb95cbd2eba89046ad3e4d88ee4076f76dc6c88d173699d1e24c1',310347000,NULL,NULL,'0fc963bda40f3591ce8ad431226f69d32ee7e6a42c19531fae3a8fc782620922','06eeab0262ca90dbff923c672525a6c1bed614768bd524038919f4d9e93f97aa','dfeed21e56dd1c0459a58fa964aa22e52d5920ec1dfe6d49c80b6ecc2c6c503b');
INSERT INTO blocks VALUES(310348,'9e08f4bc97dd6b16dd5c3da853e32f669015248dc1e4648e8b85bdd548692de814f409a44830a70b9eebe66650b424b900f722cea1043b0cd2ba99373d7181f5',310348000,NULL,NULL,'943e0a8493d3791a603bfad70fdb93809a85be1a0361bfdebffcfb6f36288b1c','f464ee513e58f63b9212c88ee530094c669c3c089296e0495d51538b38c88bde','3abf816cb5bd36313ed8ae60c131188fcc9861363dda0a6ed04cda1cbdb717ab');
INSERT INTO blocks VALUES(310349,'448b9ed8b0a0dd53b3c0b8604e87660339c5a0a731eeb4e80e35823890a7b90a2e273292fdfc2e83101079afa51931a21c643b3d7254c00eabd1142e3cd29631',310349000,NULL,NULL,'18d967b9febe4c17215f01050c07621040c2b2386e8e290253ede872b34efd4f','7aff7212a28b99599232bd8ffd0360a2db110b382d7ec3a030be12f6ded3207c','76af7f8313208bae77777707dcfa9f4d996f0389d7788c7feff57fc7f88f872d');
INSERT INTO blocks VALUES(310350,'9f226e675f14d9b6785e7414ba517a9d7771788a31622caa87331aafe444e8792b4f63767e2175b1e32be8cd6efe8060c4182fd08f9a7adb149b15f18e07ec1b',310350000,NULL,NULL,'128fdc86a616eb970361d1a82aaa5bd4721764693ca96477240fe655f77f2226','77d05ccec4e1a09c5a659f981e7727743cf99f819098bd3a9081b783f8458e91','74c867871a7acf209159a6f4c35ff5167db18584ec5ec6339f3b6f196c69ba9e');
INSERT INTO blocks VALUES(310351,'7317ea5af2ca4c8fdf5ef475c806a5304e852cd3569f816eac95bc8376673cfe3cb2afb701ad27fcd14e4dd448fb82697e48ceb8b3534d62b5a94b636b37653f',310351000,NULL,NULL,'a679ff84514a13622bab1fa41ae8aef8782a3ef04ece2316fb597bcf39575cbf','d699ff97fe0bcd123f6e3c9e6cac3496426f178309ca768aa8d542d3bbf36bf3','fdb390ca50bb3c3cdf2f05aedb410bf4319bdc591c9b62dac084d86b749d3151');
INSERT INTO blocks VALUES(310352,'dfc4070624c84471fc34914f4872491490f3c2a64e65de043d0cd1aba28a3deab42dde9a9df8ce1aa134c5c2f17f03ad25f8c876eb8a98e576e8f6f230adc1ed',310352000,NULL,NULL,'49917a257726a85dcef780fecd9c2922cce7f53d77caa177fd25c1c239e2c34b','1d937ce9f20ec34f129cb06038e292761c2a465e6b049f16bc143a3808e615e2','144e2076c9f3ac98cffa4edadfedbb12ed78ff4ef63d91d964730ffd2467c9c4');
INSERT INTO blocks VALUES(310353,'5313469980e89dfbe92fd25f59bd9bad29ab5891d25b9cc35addc939979865e059a8746d97db3ab028cf0438ae4cd0bb78d68f1c9cf0e49fb979bace604be536',310353000,NULL,NULL,'061817795fa73acf1e02fd47a2b9de5eab19c08c81257f645b7d2d3adfb737f0','141a0647791bebb7839041ea296f78d25337f7052d9d10c258824b69da3b0b17','608a5573da3e220c875cbd8efeedbbbac14a1b9e5098c3d9c0c159aae9015687');
INSERT INTO blocks VALUES(310354,'c226d792f6687bb7024364b57f526c531337ad302b0e64dba5eed4406a197f61fa1ac86b5750d82363623f41c10d73ce4e68efe32a95026b17467b69a384ad5c',310354000,NULL,NULL,'349ff15a803449a0177fefed8e7f6ee1c77477ac1f5634af02458fbe919f102f','76975cbf1ef88bdf8d506a5733ebfae2733a4710a7d11b83df53e9c7a026c41a','c91d55d655ad033d6ab2d80e8a2db9d5fdad031e3c84b40d62d012ea0bd35508');
INSERT INTO blocks VALUES(310355,'47d20eaeeaaa017276b343a2410e0219882f00d3f37a2cde895ed6533c76e270b5d1baed267bed633341a9f151ea1926b11c12c98e8b4f3ffb82855fed4587e8',310355000,NULL,NULL,'11f21e8e738527be75524c75440157d1fa8d3f6072b78ac43ca6a519e58dd7c9','c7bd5eb3cf38fc6fa836093737001fb965ef41cc86b897753e755dbfdbf56824','66d246ee84a1c3209b97b84415276a8bba728de2a7dc7d62955327ed3b1924a3');
INSERT INTO blocks VALUES(310356,'ec372a0c5286fd32359a4b230b2591c5a042a6b8198f50e48a9f7cbee29a94133c63e998c9cbd761a16e310c61cff3d7d6c3fdb31c0017952d9c9f0e0b227634',310356000,NULL,NULL,'aaf39437c836f50127d5ef36bf8323dda0782c586300f07c55b29755444fc950','86bd98545444d0151370371ff024d03f8f57ecf698fc93a8ff2a620f4a08b837','6c7d5aff4725ba5254d44b39677497e3f1fcc1c3c23d925b713b8b60d862ca99');
INSERT INTO blocks VALUES(310357,'77521e4246cef326f9225905a2f0ec39d9ca03010ffab5e2069d09fdd429bb46397434401ca205a3dd1fd2551f7b51509e4175a4ec99f050a23fae87aee444db',310357000,NULL,NULL,'264fa946868213f67d97288615da961a685c795db4442bc434c5d67a6ea4f6a0','f185328de0bac0fa201aaee8710ce1754146958f3091e1b48700ee32a7e61cf9','c3fbe4302ba5a15a022b01df2a4d71d5dfaf0a178b88737921e6de260e93b180');
INSERT INTO blocks VALUES(310358,'11cf33c1a299fb202ee558810c60435613199de51d6ee5a0bd950df50a2d2aeb2b56c338f06f53cb242ab71633f783f3f77a2485cc8d0bb0dd25e213e3b19237',310358000,NULL,NULL,'bfd984a0c82e6307ce80baa2083211a6abc512e3895c38d9e8e037d77de414ae','f5c0aee4711750ff7f1a3d17bec2d923c92fb65eed1e2a3d2f435fd7a76418ff','989aef7e70fc2bcf405ca22954e9267556fb55172d3ae9014107a95cf019877b');
INSERT INTO blocks VALUES(310359,'c2f314e6b8bfe22b3fc958f311a3ad60bd65973ff0afd65aff5b4656b112601642db654c8e520ca7ea9d020a1321045e0366ace5475aeda8a09ac2c1f7e46062',310359000,NULL,NULL,'261109a57fc049b6b295396ebb5bd2591e84000a135bccab3d91c5046bd2eab5','0ce6e4168b43867f6581a2653a994c8333e15692177dbec98c9f52350e7fca9a','7e42a10245a734b8de6b8137067147462a11d8f3331d4fcdc3ab18ee11469da5');
INSERT INTO blocks VALUES(310360,'bda2c508410f604760a474c0829ddebd39f7e1a3bf642483d0850dd66fa3142a8cbbf6e6d1812808b07edf4f179709fd321b0967b88830e2ba3f474bd5d04867',310360000,NULL,NULL,'55dcdb6f6b6973e37a9017f2bd00c4a9e49242999527a70946cef3a0d759f3c7','47786e8643435a368360fbcf3264233b954776be2d792b65c11bfc81fc9c357c','99b53498e53381e5f736729bca2555ca30a80f693b6a5c7657e0bc1f9b9947f7');
INSERT INTO blocks VALUES(310361,'0e8aa5e61551f54429774c27dda7665ac746e04ffad7ea7fc30d0c10eb914325c98fa6b09398d9ac0137862787182fb1f8f45d2e840ecd7ec53634ad8c6afa37',310361000,NULL,NULL,'05f49654bcac0eb003dfe869db2ba698927ed77c15242f3832ea7a2d24ad452c','f134ccc8175d61c193bced40c21a000c8deeeabdf7bd5710d119d06f427c37bf','1d6b79f245331fa8067b7cb7e414b197aa3659c297bf73fac12fc093b5fc05bd');
INSERT INTO blocks VALUES(310362,'4cccd2754c6eaade8dd5a60a0b1a0a39d80e5348cbff18dea4e2b66ab5c20af9c59a7b737d7ee7ac3b01e0c94e18f797ed9976ed0aa97b3a312f345a02a05b9b',310362000,NULL,NULL,'6d213279de78656593585838c005ebfa0d71a9b3cb64a528dcb1355a362cf633','f120c8db8e74171097f47760cfabf800b7bd9e1f7548812f60ccdf0be6abee69','25864531889dd0c5e30d3e18144d5823c42871c4451ee6e574ed20a420cb8c42');
INSERT INTO blocks VALUES(310363,'12389822986bf132977ffb72385c92c151bc3e8655b89e33126ffad603486885c7d6395e34bc49f75fd8b6f91994c4af72124fb0ade2b7cf578848bae9767bb6',310363000,NULL,NULL,'af815ae88bc2dd10a7b64d751833d025bc82eac09c40dda196ecb5b3ed71e80a','e1152770cc22b59fc940d10a24355322821c6b5f41a4827105f55d6b09f07172','33702c4d610e82fdf5379a12ed1dfbe6abc31b01e5e3f72bdfcc4a37c85141ea');
INSERT INTO blocks VALUES(310364,'7edbf5c584ea6177755aa9440b6c2c2f3b651f089fff837a61f853813343c7c7b585eb49f0131e2ed98ffd64a41f0df345d8a3e814070f5cf02dab28b38bacc1',310364000,NULL,NULL,'c98ed65c46403ed40694753452be649fd280edebc64eeaad0735b55f9ce24099','8fa78c9a82901d3d25cf772142d1b6a406b3a38f6ae52523de35683689c8b359','dcc3ef51ec17d1040be25bab4349154641bf18fa4920abf11aec076a3f7193a4');
INSERT INTO blocks VALUES(310365,'240660b1ade55a1d5f64e0e9d4f14c751cd2aba9afa64877b03c192bb4a487e91e009180f1e904302adafadb196377114de3fa3b9f207efdcd0c279118e60dfa',310365000,NULL,NULL,'30b4bb14f253f3d5001e0017c8f13b95e9db45d4e34333c19e8f1d885aa7364d','952af1b3b41124a204ba8dea523d4ea0255b8996e35c7a4ab621925bbe9ad591','f104ebdb14ae9aa050bb65c691fe795ac139193bb37dc6a809ca702932c38289');
INSERT INTO blocks VALUES(310366,'499cdd62e3fef786e15aa7c87b27b2325c98a845c1b31e41c4246c98280be4202b05d41f3463bd972ba855da9f05c7a2a308c3a614b6d088a5ca40b27e50e3ab',310366000,NULL,NULL,'7940967f8f1405c578e678560438f25d13bff0a8a6a6be964b3c36849e5b3970','2ecbc59dd6b6ad34f0dfd7bc8c970a3f3b3c3fd4fd7547472f33feb5fc77e351','a6bda673ffca4fbf2070bd6973eac537eb2c3efa25b8cb4aeb3f38a34caeadb5');
INSERT INTO blocks VALUES(310367,'78b3a4e982e90a6e977e7d6044c6de1ae6e5c7a4116b912fd2923006380767e842c73dfa45f63144fc3e368b9979c7dcf71e34db2438fb18126eeaa71495baaf',310367000,NULL,NULL,'939afb69dcab9a36b207b1ae185d8b7d6399cc14b9d90ac98ebdccb87f0a9965','fcb8e2a83f3a4bc46fb068b0955d010f84fedd8b4494426a0d1d962bb05ed344','f532e8cf6eb5dee042b69497fb3b433bb9a782a9c6ba806d7989c68fad7dd898');
INSERT INTO blocks VALUES(310368,'6d09a2f66be5a338d44a8905a5eee901d359f6c8a0fa4b8a2369e0db591fa87b7920b99c438310657a40c40f3cf8d5f04ade22c935b78f65ce3bd06a7675443a',310368000,NULL,NULL,'b917a50f7a538d9613fc7b6bd23f98a608feaa892db9f7a061f1eaac6e7773db','b94b68f8601fb2444d4f9338f1a2f1024566995c8cda01cc1f660938bf450ff8','dcea5786fcabe7e20cfb0ea8919b1b12992fcbab34fe605f1d7de19bf93a6a1f');
INSERT INTO blocks VALUES(310369,'d0d27d889910164f21902561ccbcb5e5b1e585a98b2a45f773a6c63249c7708eda6c755aaf2733245d0d388abde416485f7cfc028358258c65b07756831133d8',310369000,NULL,NULL,'1b8297655ac2822e8704ca6fd10e55f9509728839b97d3444dfaf6e8845bcac2','8d99a918ee2f10b8746c981584ee0fc7b62ba1c9516d226a0d11d05e4aa9de05','1517563171d11ed7f45fed57baecb5ab52191722d5ab9b56f6197c40528ad70a');
INSERT INTO blocks VALUES(310370,'33ceb941d59a7c205b7eba6c6f66bfce2beaba82f919e2917805e0ef41187095b21d7f44f30ed35c410663de6b2424be9bdd061be9435a79f163876364d51d43',310370000,NULL,NULL,'520b333e90a41a48f63cbeb32080198fd73bb83332421e014c5b8cec3058ef3c','f7b71616b4d1e296ced5120845782310c0e3f13f6d461f92522b6edac832f739','a238246ca38733bf2b83090a94cd4792deee5bf4390a547b133b99ba60a3d973');
INSERT INTO blocks VALUES(310371,'74dbadcf2a24eff2d8f91b2e897d8a3cb9917dfb0b91ee9e1f998cb5516e8b53acf934a6629d71953f2adeda6162d62c66321b513539d355ccd51c3b574f77aa',310371000,NULL,NULL,'54410bc95a6675fd9fc34ffcfcd5b2197221018ef7553395f676c2754f52b31f','c02c555643a8600306d50864e2a2cc2e7cd0b19024acf8e325d8e57672d56899','2d5d616fdb91119e77a43603953e5c29b6179206c273438c9b25ad4fc2ef3a6b');
INSERT INTO blocks VALUES(310372,'96f13cdece65d8f565b8da23404826730a46f2c1dfc80dc0a91c90e151538a274994efa7748572ce780eadf6494b6be935b84bad037b6f6c8e3e4dda7162d22d',310372000,NULL,NULL,'1d7dec951f039ed02fabcd0a44200010594a1b6e07a4d62bdedae4364c6626e5','91a5217838dd3255ae3b186df4ce64c2cd360635ed59ea079b98491c93f4ed38','a78394b2a1aef5b4b0dd657935f4a03f5bb0dec1f3734122746d6a5781873845');
INSERT INTO blocks VALUES(310373,'a217d3e988ccd8860da329ef66cac433b4d4a2ad2f4e142a5c181c2f413f6a7c9fe66296deaa6dade5afc5b450c9f4ab885f03632691f4a7de3dadfb5d294cbf',310373000,NULL,NULL,'44ee66f264f20b5254a1a8c53a53917d3bc8026ab676753b4cd96383733c0820','3d0693904a3875719aa138594cbc33aa37f3ca9f2f083e80ae4bdaec97c2bc95','5e711bc78f98c52176a4286ae5e64999ad1268b1bb8b579639a5511df3bcd2f1');
INSERT INTO blocks VALUES(310374,'b9758db7828f0545cadde8e918d2e433810d8b1320d8f955b370dc81be6c1064eda35126895a5ebc47c153b5416b6eaa6f24e670d7b4f9d0f4ad8022393db3e7',310374000,NULL,NULL,'987b9a5db8c931d9e1ff1d9c0e050b94eeba3f890fe935f2929b117aa9967e61','393535a124f3ff5baa6ad427aab9cc9a915acf169e0023da61e7ff75797c97e2','c0e640fe6e124f5194d936a91edff6ed86ddd7c367f1e50cf09ecf3f79c77c27');
INSERT INTO blocks VALUES(310375,'3fe27307afbf4fc82b05404d5a6e22fbc18a6572c65b45bd302630312e0f645003efc695e15b8422a05ed551e56ba1485bfc6901db8b6bbf067832cae2f1a2af',310375000,NULL,NULL,'4b0fc3480fcbef9fae2e419b7e987d7eaceac07b54f961d25dce0528f30fa400','97601861854a0f322a09c88623ef1baffc9e9d6aaaa348fccf720148a95f3338','71a8dc78c37c59b64732a6b4bf281df4a836e90482771ed8cbe63b8c2ec9eb16');
INSERT INTO blocks VALUES(310376,'d913919e375a0eb085b0adf68fa926f8bda220a4237259a95da4bcf9a67c7aebe1e09ae23874d4cd3463a2248677d46ed0deb5127d328a2ecdc99b21dbf95e6e',310376000,NULL,NULL,'b2144298e954429ae615cc69b4b0124ca92692508497d3e884e97aadfdfe657f','0e8637158b6f430abd426324ad7fda7776eba4bb128168b067764375a3ca306f','1cd65580f47f29963746b29524ef85e62ed9c71cf4b7939e7d86613f336fed23');
INSERT INTO blocks VALUES(310377,'701c2380f56df14a7f6c7133f3e094b23c3ff653bd2adc6265577fe0c3493b051a93fbea95235d29dff8b66a9dd6851e75c022d3f02b879b84771604091e7e37',310377000,NULL,NULL,'c77094913aa3e748515fb40b6ebdd02158a788abac56b0c5b5b4283738d34260','85e737af6899785f33d0f1252a517d6f554702d9535e86baf2b534cb0076c60a','711e6385049cb5d93d7dc96d7aa7f76d977d600d934648658884c960e10cec31');
INSERT INTO blocks VALUES(310378,'d7fece17c659c0ec86f31fedbd029944708556d47bcdf9913193bfd90906edba5a925bcc8b03f4df67310f778a80167c2ce8ba8fb7959d3af6d17f5bff608e27',310378000,NULL,NULL,'c029831bf11acc3456f487406f4612417086e3dc9064445beebc8d31fde2c85a','f14dcf7de5c6fd9eae046f9ec47ec022b45ac5bd8283fdc59698890f05b1092d','14eb3fb0e3a1743b9311cbdd0da8d7d67defa00034103ff17812f63f152222e9');
INSERT INTO blocks VALUES(310379,'e35a25ecb6f50f9f4009ebdd87f9e76f40fbab78c5417aa0a11ac765bb4adb614eea926ff7558cc5fb6194c075dfd95eaf2ee35f543dce4ccf72273a016c1084',310379000,NULL,NULL,'bb981d1bfc9570718d6ed4d5357cdd75cfa62a18df69710c537c6820d541a3ba','f26fd9034e92ce7ccde586fdfafc034c2757c7cd3f60263eca681c311d842cb8','6a9f5303bbf6d99faa34afd0f420d5523abc5faf5888a1fb641bc163063087fb');
INSERT INTO blocks VALUES(310380,'3e1a363381091400bb31dffe611e251598a7c7d0c5f8c14a06c8487b2cc0cc31a111112c3fabf2e23c705425f531cc91f21ff7baf4e7e015ce5ad884bc3556ff',310380000,NULL,NULL,'006ef4ce0c155d5e4a6782d866ef5ada51093b11f3fb2283f2dca9781769c542','4a94c97def5d8032d604a4df57e25f87b330365d56dbf82219f0dcd4177b04c5','9b54cd07e39e2462bbb962591cf19f3ebbecfde45e42bd46965aa8249d8bb908');
INSERT INTO blocks VALUES(310381,'7c09b5350b292b8ec7a9492e50647a0fac1a1c9daaaf76c7c2f588d17058333598422a6b09f6b43e65ce1c274741c970e76f2367cd7341f31fe5df3aea6fffee',310381000,NULL,NULL,'ddd8116bf1855ae63474e1e3d7da818609f35d2f3557eca443db0dcaf02b65b5','4a293b36e50a32c74344f0d2151bd5c7921f8b44b6e36b714020341b595b7651','0a3d59bfb0484a3ecb71a45313a1911a17251d3e33379b932ba8174b8a77c6f2');
INSERT INTO blocks VALUES(310382,'c0f7e693943d7ef303f8a8f0b82b42c05d16bac9a51ee748d7356fe2495756f4c8b83fe9848ed65d6063d79ba5180c9a0635e9dd1e09f2978c7015d688a71bb0',310382000,NULL,NULL,'74e4aea6e398c02b2c71b0970e99150aee9d4fba81e990093a2ae510ed736cb6','0c6bd93d6e564ce860a478e7ce093b9209bab987471570428e6d35ad1ce092ca','db1dbeee45172b0da7f0135bafe8eb68468db01710d6404ca22cf0c1e00e1b16');
INSERT INTO blocks VALUES(310383,'024f27890e9c28b78b0a9f57c36057f9a3a6878d7d1312b71d0e6dd97b2acba0c171ec3da6da1a7564b182764000f4ce0e1368abd82796730f5fab763897558b',310383000,NULL,NULL,'928d7a675217a3679b73f86a79c451d5b570b0ebdacb0f82f2a045e0f6cb411a','8b6db3ee6b0959a67456297fae5f29c22eea2f5fc132f8bcf44c0811c520e971','fff3f3910b3c2970afc2b14a4aeb7e5343fc54d8d834203fd10af8e0782917b5');
INSERT INTO blocks VALUES(310384,'ef45b046e85b9aa1ae2e5108421d2f77cd2a167d45c8239307666e23b00042f09057c840be9f0802c4a1971fc6d33dc072e8fdd552802859902c94ba9a0616f7',310384000,NULL,NULL,'6da15b47fc9126fa08f184189d07bed2a37a3a8115e2160f8ef8cb5b9a84a1c7','8eb62e04e63064380de40e113765fc6ccf5e23af9ca246e5c15422a33c027e0d','5f62d587f524ececb1f0f5c6819ab3d2775915b3a5e371100e52a32d19734182');
INSERT INTO blocks VALUES(310385,'e6e3f4b7435f96e5972f807fbcbdef20e46045572a235c1a653c97d33a88fc31e0169e491070619cfcf98e28614148f6b880481535710829131251018343f477',310385000,NULL,NULL,'b38d4999a904ba8eee4bfec76a09272794fcffb22a277fdd1a009bf2ff600311','89a83d3d7a988196929e0bdf952ef88d23bbac2d77125c8d49d94baef92127c1','475c6be9bf3dd9b8f6b5dff5ce909fcb457cab6dbcd8731f695941b3bd1f494e');
INSERT INTO blocks VALUES(310386,'f1bcfb020a9b17722d2a304089806f267ee67561f5c33f8c932d0d2430faedcd7504d98db47e5f996834fac46935c47bbdba8eadf178d52ba8d5c828c08aa000',310386000,NULL,NULL,'875468aa8e7dc091f0bd87bc04fd6a22b00c0c1ce90bf5514d4e821b97c8ad69','2682f5c7e96e34e98d3646781f212ce7f5edaee3290b832d68d18ba84923fd05','ec0729bad4f4ea047628febda4c0eb08e1c62550f5b2e4e90a9aef1e3fed1a05');
INSERT INTO blocks VALUES(310387,'97324080fe0f8ab79d717f3348bdd82add208d261f2d04e78a43818122d08ae8d2eca18b16b26e9b5862c0272beb751a62898048caab736438408c3fce109fe7',310387000,NULL,NULL,'f5dd2bcac2d6efd797fc7f4d8685bb284da95d51ad7b8e2040101f6890fe1530','1ea21e0b9a12b3b6e8fbb7307c0fd28ee5b3fd96551afef7ba5909900d4440b2','3e2f043afa92e9264fa8f90188ac40651737fe7cc5fc7b944bb49b9d0848dd55');
INSERT INTO blocks VALUES(310388,'bafb9f69a8253e308e91876d280a71ada97cd903ca04f14adbc32163d166632a19c3fb3773c9b126faad96b21675ea8c216ab7930146a532da10269286b3f675',310388000,NULL,NULL,'83005a8e518b32bb4dee01cb35665064a408b976a80e9b73a5ac73e47116e4fa','897904e960b432a2411d5f4ada11660ab929d42035bd00ec786ebb1141d69010','d715a9bf9a381c9133bfc3a6f49040399bd64eb7dbe7c90fdbfad1af35da0e8c');
INSERT INTO blocks VALUES(310389,'48b9a51e1dadc6af9cbd9ef618681c97471cabe25207b174f93a749b3d42db15446ca78b489a92eda8596bd5a237fe2765aa0e747bd062714b0e84b5d9fef4ee',310389000,NULL,NULL,'5571e2dc9c2a681bc4268fa2fb6ee9192b6f0e57bd66aca471568a3667d8a74c','46a3e58613a1ed1ab1b76ec01e35e4679f9309da65ef87218b565413ca133278','b1912254e0ebe6806680311f7c0a37f899244c44c3a4ad70179805caf717ec49');
INSERT INTO blocks VALUES(310390,'a4c7793a1ec95d4bdef82e29bb92d1068d46bf9fc542c67b0e8eab9e7795fdb0041d38f6c14517f2dd8ef0f1afcb51658215e08fc8a4261cc3a8f0ebccba7f28',310390000,NULL,NULL,'3473d359fb674fb841e551feb36233d3d7fcd16ddaac77b6208445428d129cfd','a92bca77196665238eee139e63779c69801d859cfe29839cb1325fb42c70efcf','a74170babf6a896cad5cbfa136c548e472da741652387bc363453d3d28966350');
INSERT INTO blocks VALUES(310391,'0cdc2a768515be5cec8f1ac0bf90f1cbe328f112654363b53adc4a3c71d4ef4a24fe76e911a38327ce9476ff1739d3a0cfeb87650878eb50d7756a335dcbc0f1',310391000,NULL,NULL,'29d34b45b6f794a8b6c9b5d6412b6cd82dc552bfe4114337bf4c9bb1c53a37e8','a647b0526fadf2a1b0a0ea44132f01eda4389e01577728091722a4a346e4d9f0','f333a5dd77cfeeba5c5715ad4164628d3c64eba87091e0b855c6ca8753f45de5');
INSERT INTO blocks VALUES(310392,'8d3026550633fb3c192d35fe9eb34a336a375b702d24814232f5fd9a306aca9c5c88b62844eb6de4ed9070b938ef959d7c06c5b57e09c1028a130de8a66b73d0',310392000,NULL,NULL,'0e46efad10ea853a9e790068e049a852d3bc3cba5222e08f7879d817d4f0d1f1','50de8feddce66c47ad38ed027d19f339668b5f8bf3374eced420562ab586e884','8bed476ad913a5dc418c4e67ce69297f6b15c7142c733af5c8fb8da5bdab97ce');
INSERT INTO blocks VALUES(310393,'ce1565e85d22327c9167ebe6340ff3455dfbe588df356612bcf064083ad551ada2013ff7855f738d50d788338e8fae7beb9be34a87496e2e113084b16cdd3a60',310393000,NULL,NULL,'c81a0e93e50d0dea8baa61ab2f9df9227054495e8db352c6d14490edf250496f','602782ec057231bd4f417155c325e69ff407b4b1ec2db8688ad180926a511c5c','20e98bf57e62c552851f0c4d0dbd08bf6d8cff5eb8088efe2728392212534dfb');
INSERT INTO blocks VALUES(310394,'ecfcdafd1924ac35b2a8a2cd794d4a7118107f8481c3efc2c3128eea5b5016f16c19354323fe2830b49972b947156199319a440f0fe1d2646cc9d2be6d160e32',310394000,NULL,NULL,'446d3e49c4c03a5337467feb1514e8e3fdd82d572b0d07a5d3fe2fb98f27fee4','f5520e9ce9159df2f3fc91655de9fdcd3cea288a1d79de733e83b1f6a23db225','9b89def26e48d4f4be1f3336ec847ebeb8416e01a1042c1bba8a8bd85632ce5d');
INSERT INTO blocks VALUES(310395,'49f82bb1b6373d11807a41b870bf863d023b02aa9290fa89af227a2ecd7f68692753260cd95fdbfc3a215886f72a59433c48b98e0e63c67072e7978128b8ed60',310395000,NULL,NULL,'8a708320177bf1f261ecc2227e82bb36bb7bdc29cbc82309f1ac458d1a95d2e9','a3a2ebda9774eab3a3eb5bcdfe53de607fa741684bc203cf2acef94ab5b35c93','4ee08e3db27aaf161336017160451f49c41696c2ad471a87084e9f36c1481c5f');
INSERT INTO blocks VALUES(310396,'78130540890de0b675b37bde2aee28c8fd4ea1678de7afd80b1149be1f25b7cd8b8a43a7f5529136708b6345dfef6f2068edf5fc84636ab2445c2f3a7191e7ba',310396000,NULL,NULL,'af7520da586e2166d9b5c81b93b4efe5bfda3291c1efc52eca5af4df9e7c840b','9e56207db3b0c9138be09e36a55a5df3b909452e5f43dd2d5160eba8640b3910','6d36c7e7385a1907fb85b80c87cf41ddda1d525999cc0d8cd072f707416e8399');
INSERT INTO blocks VALUES(310397,'d93c2331ebc27c05ef1edf7f5283ba6b936271da24894dd753ab8b9a5866276a075eb5daeaf707869e9422339730bdffe04c702b964eae6df7fa92b161743ec9',310397000,NULL,NULL,'aa34ff9e9408402a76e9b0ad8b6f03a941454bb7a4183d657e5f7b2ebee2b809','71c3bc39fa80645579b16dfa712c059cab40f99093bbd99e84f1e352a71377b6','5767ab57be1cd06b14f57c4a3370aa63a235c7d54859bfda3509e872c8f58c75');
INSERT INTO blocks VALUES(310398,'3cf66db0bf703924efa0b1a509c51545ce0cb71bb75be55899a5e866392de3cb79fdc3bdcaaf9984a9d4f2e790d4c2d3f326dcd80075e321b34f90def7467014',310398000,NULL,NULL,'8d8b9199b3e54a6af7e51d8d5dcaa94d7ce867e406ebc761d6c34ee8bf2dc0c0','aa28528514d13fdd7e283e33f758e9e53f60cd3732c5376195f48401d0546109','69aa42e633b6736cf89038261b9135866e35dfc15681e59d1a2e846e98d7a09f');
INSERT INTO blocks VALUES(310399,'a85d0e1aad11babf4868b07ae9af70e31ddf4759b4678a714aa0cab6d42c6e27fbe10c7b7126eeb9b4a67e499dc48905c487c96f89fb1ae81783c7293c783d3f',310399000,NULL,NULL,'f7b6c0f79ffaa22c216b5009bc5f30ed5dd7ffee18e983e5e8af5fd9d16a6876','f501d50324afa9365acea4d49f4e8aa4c840827eb8fec6eeb614f24f0a669e26','f3f5cff768075a468def933b37c9d817726a15f2e4ff48944181b41f307e144f');
INSERT INTO blocks VALUES(310400,'174d8e6c08617f64c726d4ceadc20b3465efe775c3dfeac4cfa0cc4216168ee9e3c3d7da993c9c5c71073c7c5b51a4df17f9ece110bc7edd55dd5c8ca756ce7a',310400000,NULL,NULL,'32e5752dfe62b8445c6e31bcf3a226769b0df47ebffdb7858c791d4b035c5c4c','71fa8a55f31672a4ec99e02f6c6e1a38b0f527f98a0e24176f8da3a82b349f2e','1f2f02cddfeab66adc5d4fbb7b46d1d75df56195c5d6f7ce9bb418aa7d8a1edc');
INSERT INTO blocks VALUES(310401,'f0590b3f199a1db947a38a4955992e6e263cff84cec984ff1a980317815d855fecfdc4eed6969fea08825a28b49a9f84946b617b33b75745c2576729c467ed5a',310401000,NULL,NULL,'0297e534d291cd0f4f83e5d28b71cac0ee24008854a0e76f835e10ae7e38e687','109e2a7cde411dcf919c259c4a75140f6ef6527141614c22c18d6606d0736309','4f8011736da086a66855e9c6400fa2c6cd3e2e46b6771309d2dff72198b298c0');
INSERT INTO blocks VALUES(310402,'6709c9d903466d14d29ff6940f2a9778027cd368520f4ef2d457d9e5d5c52af845a3312acc25fb92176f0e4902d8985f5419b22da23f2120de3f684f483b7c83',310402000,NULL,NULL,'58c0dde5ad1b10cc948179a29a59b7561cbb08a5a5865d1d2921f8b44dc8dfb0','2614fdb2ebc7cc69b7579140f2ec037c691f30e22fa33f52acd2405c2da5a01f','e5b056dc22caecc7d90aa52cf5e8f5c90c92c17a835b0c44b9cbeaeb9d3f6856');
INSERT INTO blocks VALUES(310403,'ed36a12306f191a5f796e3604e814618396ee773e41bd534eba4534fabb9632f3db522fe0422aca404792181c62df1b596ba445eb7ae414441d4fbe2c04b62c4',310403000,NULL,NULL,'601a5feb1eaa6474bb45b905c1313ea2af298cfb0785790294fc20f920a8b14d','b53f6021ca5962212090ba21ac7e9dbe5637352405372b600d4a865550c9c1ad','e78e6c2a97f991382576e14118fceb0c7a415e4dc3bb03e6a1a668b4455a9327');
INSERT INTO blocks VALUES(310404,'6bebdb83a225957a55b436775844eb69c0dd529bfc5c2ebb9088a784886c8abc1abcca7c49518bb5a6a9eceeacec2a28c9b89d41f4a7725e3caa325a773e0288',310404000,NULL,NULL,'611967b24f4b404056b36f26f466235d580e6c235cd2056789777108e1e59b7d','f4d8480c9eb9336a005d1e0b44014c6cd957dc3ae2c5bd37d7584a73b9542337','9f0c0d1e42b9ca03ab41b7dd45363ec6770f8c08ef5500857af2c345b06a0a45');
INSERT INTO blocks VALUES(310405,'6b015ebd2c2986f6df13a8feef2427d8b03a4bf8bb197eb2053d5c21370096e8ea57256008961472d8ad195d56f7adfa8b5b295d4916bb45562a853104334e34',310405000,NULL,NULL,'c6eeaf18467089d57276af6b2445c44d30eb8274dd17f762348980e049ff8a58','dc71fdd16d551a00ecc2152a14650c1b1b090a0bfc55ec3f52f1e3f67961e6dd','e2603cdba5a1f92e2b4c4ea5af2c97a06130f36f0ee88b0b953dc9bebf5ec907');
INSERT INTO blocks VALUES(310406,'87467554696f2c8af1366cfb993410b81e17e5551e963483f7c2922d7805d1732cf141cc42ec0e5e0042a82e37512e24786f6e39274f2c8d096ba95d55bf2bb3',310406000,NULL,NULL,'59730990f17c9f06c561f35d6cd8698e33c3be9be85e6ece2382d80e90803621','e365d283cea2ff759d525bf3dff15c6aa55f9dbda1a239f5ab388d2c24ec2b69','dfdf71e144c26ab86bd8b56e47bc55c9d74d7a1c771a45105fbf0b5c19c963c4');
INSERT INTO blocks VALUES(310407,'b3ffb46bb9ea5e1203b393bbee2f84bccbbca85bafec4a8df1626e75f66b65f612c1d53fe71d73b961e157c7b3e3e78e25a312286ee529da6c8820ec1112b5aa',310407000,NULL,NULL,'12a820772b22482ab5d6ff9eca03bbade4fe9ba254faf45bb19893aa8ab48fca','0350e3fcef48d5e8c9a75b6093b908f443d3bfaae8ff48050f78687478b2796a','fd487ccd2813edaa102864661434fb3976f23c1177250e575d8f9b92916e0b64');
INSERT INTO blocks VALUES(310408,'7bbff3b39407329f9994849099b89a9624fdbbf5711e1eb83e508aab11416b35f759e1dfb640ccf4f59f1bf9d2e8eeec393db74c0b82e46673eb002fb0901019',310408000,NULL,NULL,'62dcbcb5531624b3c30f4fb7ce1414fbba2eb4e4e4aa570b0b28d722a5e628d7','115916e67eda239394d1fb8589ecfae96dd843034567af206310082ab2bab68c','805d541c25b1668b8dcdddf563911cd5f460921cb34cbc701bcadc22034aba5f');
INSERT INTO blocks VALUES(310409,'1e0cba7207f81d1fd5b5ba2791e53db73a0b410f43b8a767e6b89277f95519ebe776705ba0debe97ce2b447c6685832664eb0a695c157a668a9e03ec34ead8ba',310409000,NULL,NULL,'c9ee17e62f1cac6c039ac7649e37a016084be2d8ae772804fe51deeeb86abd93','db1daf5cf8ab0264f31bb271987db68c5e44f183b2786d163fe71a7e9ddb2a15','f5217b8e6e3408c29310a76f86fef74fdb90f9c7521234af80b2a0cca4d68099');
INSERT INTO blocks VALUES(310410,'43da7d9f0a402caeff43c5f43f4dbddd28a0a4df6180fb3bedd96eb471df18896096e0b602a18e513991549337b525325ce4b3b3a5dd22168a14a1208b700a73',310410000,NULL,NULL,'d4bab8c8f9330eab1531c491d09bedb82d6248de4645821dbe11da7f5bd47b9a','2cfe4d05e0ca8131025de69a6a6572b85f0be290a29d180d23f08d8cc5e88795','ace80aec25b11f73b062385bd25ea076c3dee30f1ae004081664d38e7dc35a18');
INSERT INTO blocks VALUES(310411,'b687c747443e2b9ae6fbc145dd896cbe0047b557a8fc205286d463ede5c585b20f7f5fae438d7fad4a9914d233f554ecf586dc772ad9ab96fd8b1232415b885b',310411000,NULL,NULL,'56ce985df9eb14f53bbef99b9a1ff77cec43d4b95c3321b17b8f946ad7677ecf','a669271601f1c8b99ecf3bc86b5b50698531935a408facf3891b030addec881e','885271344a317dcac19b182e750a2cd6e6aca0a072cb52e27455104b6fe4873a');
INSERT INTO blocks VALUES(310412,'22f5f22b1a3655a4a8356c614875b24e57afed7b81f448b0f082b1007c67a75afe7c84a6662bfd407167edafd4fb90fc68c2898af9bc9faf9b2a2f7823366fc6',310412000,NULL,NULL,'2d93d12fae801ee58d8b191c339c20e0934a79e36fc92ac28488cea633935c6d','bd1e335e3cc0bd83c56673237325840907503159784e1b94d15ec8f57bbaffc3','12bad079e1830b015272d8a65061cf3e068bad0e87f8c16443241da450c9c34d');
INSERT INTO blocks VALUES(310413,'9d334a498eca94282d6630fcd88d18a2392888a0f8029c1216602e345116b7cfdeca4362115fc8e2f01acb8c961eddb12cf4b090a956e06d6a04ac0233989811',310413000,NULL,NULL,'10ad51b645d728f9d4b60b73c911f6ac8c9e740c558517e60460593a1268c526','fdab4b5741448731b8fdf0a90d664f29be9cabefe15fe14c6d745523888372e5','c85c72e675f1290cd0832d0ed9e5df2a3d8baa6d3effd0c027b4d6980746bf4b');
INSERT INTO blocks VALUES(310414,'7782b386cd92d0fcf9f4179e6486e38cb938cbb300a7b1d11689a91dc36a682e9e17318c50c5759d3f14599c2454211de6b8e119759dbfd779340cf0e012b4ec',310414000,NULL,NULL,'39fb53264ac40b68cabd00f8f3bc24d4e78e1afd1d54ed12f9e9e9c25cd657c6','00c2c5dd2c73d410b87e1200c96772d7359c141862a3f2b00a50df010be640a5','e29963d2d970f83cb58b5f1e14aac75c306cb2344dfdc23dd1945859ea7e4e52');
INSERT INTO blocks VALUES(310415,'9a13274c2d5cfd7a99cb883ff2138300747e82f5bc26511651a46bb2b973864ae9dca8bd40a7187604b935bd5607909c3aa18568609bd3042f95a9315004ade3',310415000,NULL,NULL,'1feeb2afeb9fe99d3433a12aebb38cb8e4bb0d2876abc52db6619da42414d73f','edb81720a9c9e1a752c4172c2d546e0c3a3a162555a6dfb8d0d008b8231579f5','b64d2d950fbb7716ed6e9a0b0d6f3b3e9a3e676f0065e9de7ca8fae0256b2399');
INSERT INTO blocks VALUES(310416,'6c58b891a05d796a69a56b0be77df4174809ea3ca82d1ffa40b95dfdbcbf8f06afa8e9c75b744bfa1dfebad0a3bbedb842c959757b2e884d72533942de971de1',310416000,NULL,NULL,'829c304ad8799c3b7daa288917e3fa362ad37be2522c879de32d633316680d4e','04736e7f7c9286b394b865d3f042b11ac34726770197d7b5d00d493f200a74f4','c50443628b45f023426125f3ef53dadfffb5722be772ac1713acd4e340f20c0a');
INSERT INTO blocks VALUES(310417,'da307e407cb38d53bc7e9a8ed9ff477ab9addc5a029e4e024d8975f2a705f0b3872e102a92cb7d183154229306f72cf58156093ffa339f404c67f8be3d988ed2',310417000,NULL,NULL,'dc2a5fbe0ab40ec991c67c046b42476c6abab2f46467647b449f1b863000468a','7c8c60fd56befe558004c3f176f4df93c6017954de99c8167fa89f4298dbaaaf','0586ffa417baa19cd91f01ed25c61c86c0300b48687775d4e572041d70064d38');
INSERT INTO blocks VALUES(310418,'576bceb5b89ae12f7e493f50906cfb4e6773008474b2cbbb9cb94d90a2de8638ef1d5504e010913a886d75a4cea1c7d4c1f494227a2856d9f4d0ecd3125c06f8',310418000,NULL,NULL,'226ea367bbadb90c85fb6566a13964e18bc1fa566ad0c2663c6b698dbe99272a','3f839454cd951666b1b13ebf14cda1529a776893acc86b82bd79f6c94ddbbca9','9eca5356801d9dfc67ccb2c96d6ab29e8c3441636e61110cf3d7d17317d6ae15');
INSERT INTO blocks VALUES(310419,'0e82af01444fea6b8429d63eae0feda27f0504b8f5632e1121e17ef42d24dba60ef17efda48308beffd5f6d6b70a58abe10fa6b85b8e10db8a17e8572d6ff5df',310419000,NULL,NULL,'793c71aa65939b050667ad6cb574fed2eda017a57353137f07889882d38b35a7','a18746e038e466b156a4ac8643df8fd0839c7e5e09000757291488dfa95b411f','e2918b110501f1c906da0f7f5059524d27654d76bb2ecd0f4824445ce06ca3e1');
INSERT INTO blocks VALUES(310420,'1056f8418f3ee73e2e3ae70f039789eaa32ddde1df728715e6e8698551d857aa309b7be1b26534e8954a398cfc7321716083e89826ffb41897bccf5f943055d7',310420000,NULL,NULL,'1e1b526b41d82ac75f9614aab9d3c69e32478a1c2e647aa5206cb37df6066690','c4617f8b15a9fd2c16959d63e8c0e8f6d5d0567815211eef8c18c1a2a9f1cefc','9580e6facdf0010fa323074cf87f2d84cd9b03a2b7f2a77fbba0a8edc4815fed');
INSERT INTO blocks VALUES(310421,'15ec5f098545ce28a31d2a6b57f63d3674675576e44995f98d0183f47e4abf84a7f5047ab912521e81f4e1d3e7ca8cb97139742879c505ae40c6cd561709ce94',310421000,NULL,NULL,'1ca99c86124f7ecd943546ab7b12b6fd57c1a05bb888fb27bb5754695b68877d','a4cff9f583e94d170949d44e88dc31d4adc1d49a1727cd84c9ea37ada771fea7','89b54ed3b92f13b3b325de3815a8d9cafe485ad2c2670fdb75bd61b38f4dff90');
INSERT INTO blocks VALUES(310422,'ffe47629dec44292e515f6fe62761595ca13bdbedbb2d9d53f43c200de013ef8816f333a3506b827148da7634365a335e408b6fc559df2bc658ad13d90cc9ed7',310422000,NULL,NULL,'118798f3b75cdf75fe31d5e49c4e47b3067669f8a70a221e01683d64ba7bff30','705a89bcb46971ecfe3f962c3986f9758a3b86a8044c6ecb3280f4288c6bca16','f14bece6ad561c03349d4eb70abd68f0c16137d8a04d029e21ec61cc1bfd1514');
INSERT INTO blocks VALUES(310423,'34cf9b59257fce62659ae3f5ff57a6f3f5a3d4e34429cdb856ea1cc7b587ae115523ffa33df176f41b3e224c218aabc3af8176e0d25c73eebe1bb0f3cb3ce60c',310423000,NULL,NULL,'71730e3e6da74b638523398115ddf2371b3ad58237b8960844bbafb9ced84f5b','8bbfb8b7d5455e38f390ae3aa37586689e7348015ee146bcdb302d5891ce820e','e05a1150c3c156233c75844176fee73961e3bee9ff96a794e4ec3353afc3d0f7');
INSERT INTO blocks VALUES(310424,'cdd558c1a30cbf860697d8bffe867e38fbacb89a587e565a0c05b99ed90fa4871bb63c19241693f10955187fc9d30e798bb7734307bea6435196ccc79a1c3134',310424000,NULL,NULL,'8bf002291e47281ffcf91af9a6575c2327f441bb6ef7f7a2a7ec8afa504273b3','678805cc2db47d60de5f2227f59125de1764eff35cde7e6c391adc3c2cbac0c6','00a798e9e29c57853be2d78ac1c3ae48c23345c3ea28aae1a4301523e8d07668');
INSERT INTO blocks VALUES(310425,'7d291169b734dcb983bb98080ddd3c0b47698a4820ef8d6cb86152a7858412459623407abe935b3e362af8b5ccfc9fcd91628d48ea2032d11222b115385ec1ec',310425000,NULL,NULL,'40605b1143c4c20494c0f7eaf29617f95df6747bf7ded5ecfb0577e2ee1962be','94c29558473208108e4c78dbf9f44cd734f7939d0347e88c544eacaaee73a60f','be1093ab5e21ac467f2e2ae216eac817bc41c3d5ebab06fea0d8de864ebbbf2f');
INSERT INTO blocks VALUES(310426,'e260192e2d708287d5642aae40af7ea517546d0cf9856c8b83abd61005bfa2f4a89d8d335c33c59a5c53160c195053f2b9126e78a185914316c2787301dc484a',310426000,NULL,NULL,'e1fdf7bb504bbedfbd62ef98c22a0adfc387be0b8a0b2a168f345c81641fffc9','334804ad55e911c09d5e6abcacad8b86b9711d4e2b48c177cb28b18fdb570d82','2fdfdbd00567aaee58bc133e4d2cf2a6813bfcbdbe879942d533af7d6c631d21');
INSERT INTO blocks VALUES(310427,'5fea24eab54b2be6ab3c00b04d11b3d0873aef4ad9f6b5828dd7d2879b24d1cc5ef8e8cc0b9642d08862584c2b0cae6ae5eb38eb6aef38f1035618b0146ea076',310427000,NULL,NULL,'f5c7bc2837ea77abd40d0cb11ad073eebaae4d25b7eb55012dcec4a9db2b54bf','c2c380fe81388cd8ee1ed7996e1ac18a33865e43b0b57c1870466ab6eb959a93','f131999b4d5c2cb7ed2862496da102f2d1cf18f3521aaaedeb1037ca8905c32b');
INSERT INTO blocks VALUES(310428,'a18394d49c5f7bd594255e8d051544740139a07319dba9daa6b2753eeac8a5803e12f401e01a822b27959797b4c28434d0cd632c193d37d894ef940165859a47',310428000,NULL,NULL,'83240d7944ff0d651fafd95262b9ed235d0d7433e76b1b3252c530f2bacd4e75','b33ebe3ae2dde95f6d223447199a987ac6f1d2d9767d1fd5c8164598461d44e4','5b6de370a8c6df0fc597214edf8654d68b27802a514f4d540e7cca9882677917');
INSERT INTO blocks VALUES(310429,'1b101a7ab8ad7d785f703bf1731c53bc2b4e4860ce5fa9cb0bb32b35d263a0614a31585bb4ef3c57e8ed8e9d58747928a7919d60a982cff97ce6e127322795e1',310429000,NULL,NULL,'189bbc509afabe68c6d3cdf85968065007fbe6c77323ad95e3ca0792fa85c390','0f765d25473ed2ea673cd6d312216fd7d7119c1f6ef929198f9dd90431363cce','d9b18ed77a03a6d3455f48f8fbc02cf1a90faa4916cb74c4fd596d0d35676266');
INSERT INTO blocks VALUES(310430,'441f2780e43d35c8abd6e36384c9ee1104e9c64a98efba58016a439a3165c9e67d7f8dab3cb8b7a58803103a5433fc6a1f416c1de00ead3de354acc818d832cc',310430000,NULL,NULL,'3cb4874bc65d5038155bdd2f36b202065fbd0f385df10af1d95c2a2234552989','7220078b240fff8c10ce0a04607a763fbd2941575e397d83493ddf6188949d10','29f88915e4fc13c3a26bad042f3a4773f6258b271a2f2433fd6f3ce4baafaa40');
INSERT INTO blocks VALUES(310431,'70797615910255131a48c8f57dd0187ea1985d7de08546d96fa4b4202e127a0e8195aa76ce7cf2370b1b40ed5f576262b785a4f5b2b117cd5bd22c32ab670cdf',310431000,NULL,NULL,'8dae160bf9bf756df9ad801876d94f7925b01ba8ad47a747a8706605fcc0f2bc','625ee46c06e26531f9b6a6a2e3b91437b0059d78baa16944e3f0d8b2d4537659','1391567b96dd99aa2780cbdacbaecb834af4c8c49d53f98a66d10d1a2dc09153');
INSERT INTO blocks VALUES(310432,'d1d2d773866ee4381232e8393f4fdbace8d8c0119436cbb9275b895d6bfd6756dc19d2aef78bbc1464ebfb681ec3d893638b869d8c0cf23a75162ca3c837ba8f',310432000,NULL,NULL,'685cf31c99264794084208a68381f5ada5fff23a9a0f7aa0e2db78aed778ae38','67899497a3fd6bcd9c1b646a623631e70527e2ff9d9fca952268bafd6a002ce5','e30c336316aa585a8c08f5c66a2eaf332b71fe906dd4ce9165d40d82df921ea4');
INSERT INTO blocks VALUES(310433,'67984d7f40300c9747a2efbdbb0e1447d4642eb42865562f27ec3d3db786e18f4a496cbb14ad8ffb039f655733b56cc3705c23425f584dfcaa81c91c36514d75',310433000,NULL,NULL,'aa565be3079dbd89bcaec8e8e6c7268f5025dc78968f25428ece645512649b07','6c920ca562f618b58320e3571bf16b7a57c54ed67a004218f2891f2573f4e806','e0f7434db328baeb677496a78feb1c9e2408ee9d4e55e5d203d45b991d50e23e');
INSERT INTO blocks VALUES(310434,'6f30d7a69d792655279266c10f45dc984fcc907d91475f2e6b8321220eb78f9a7a8e4ae2b9fc8d8c5e3f25abd144ef1338e12eeab4b9901f11812f15a64fbde2',310434000,NULL,NULL,'e95ff0701e30639f252df48770dc84569adcf7c5b721b1153d10aa77ec2e97f9','27f571189b705663113c2f3880e0b1d1971e3d5f69103375b824993c91eab697','3f14429476f0ec209999167ea63d65180e12aaf39bb984ef537d712779777c81');
INSERT INTO blocks VALUES(310435,'a9a0b163b028a20dca6bb5564eff523668f42b46c1eea48175cbda13315093ffe6e6445979c05fd90814a65ee8e01ce509c5242e09d957278ad7b81d25797a38',310435000,NULL,NULL,'1752b60931a46d0bc2424554732881290344ffb8123257f2628e059438215768','b2526e0fbb2e70a5cec0d7d91b32d41003eb67f5ed9fbdba2597a505c180fde6','190432a766b200f2789cf96f4de84473c828a420e47fd8d9d2f2ed7668443492');
INSERT INTO blocks VALUES(310436,'c8ed150b76f2b615232a6fba7b0d9ae5fb28b33c300dac84fb7bf2ad0755a26fd8b2a911df2d329a47a0c488e13df0cccc7ef8ecf48aae995ba0c03f08b1c068',310436000,NULL,NULL,'5490f11061041b467822b937ac38cf3b9a3d6455d30eee6ed5ba433b21147c1d','652631b2c030402b3913e650e4e23d4c8b50147323dc94e1a7c4769804f2c3a6','4989466be8a42cf1c15a012f9ffb1de8c993a8a61e3ad9d66b2dd4e9157c91fb');
INSERT INTO blocks VALUES(310437,'f6d7615d1e012db1bcc2eea1b80f39f8ba569e8d0f8840118795f8c2de1a91a2fde2731cfe29ff8c779ad1b40809bbb80372befd54327b5ffeb60ad67437f77e',310437000,NULL,NULL,'01fa278cc38b1db510ad80a5b540ce8c5f14eb52f2216df716eec90585e1c623','e772f8ed3b015c9625dd1c56b02f1406c06e113f7e134f2339d4309bc5816dd9','77d8349b7a5870283550f3194e504c4d19985182069c3e7e80fd656e16bbf943');
INSERT INTO blocks VALUES(310438,'ff7dc5d5837d765686f0f08fa01425a3525d6077761240cdd5cc3f31ba43d0c96c99e5550b7b0af2129a0dbf8d9bcf06e34de16fe9b95450ec08dfb365ec4e1d',310438000,NULL,NULL,'50f5ed3fcdd7160f3c8c55f804fd88f0c4f7d334f69b3cf670e127d43e9ed0e7','99515a60cbcf0bba25be1c360df61432f97e062ef8081a70ccf68d6a377b1652','e4d7bdd0d7b97ce013d5d3982373c14ee816b876c5e5c0f14911188fd430a735');
INSERT INTO blocks VALUES(310439,'53a29572310a9beb0a93920f4f53ecc518a39318947ab914bbacd10f8eb3f34ddc9744006c487cb9a3a4db8afede9c8555719bde20be8decdd97dd32917c7fc0',310439000,NULL,NULL,'5d0c97275489de11c88f1b017f666f544cea2ef69828421f28d5c77cf94265ed','d4e6e1c602081fcca734dde5b8dd4d7d58b48b88e6325969a000e02f6f5aa1ef','10b1ee84fe7b25eca6346a24580e8383f47f017bf7a3ebbc43eea8f570e523e5');
INSERT INTO blocks VALUES(310440,'27be90ecbfdd8f865e1641a461a898e84e83515ac047622edfe7ead4a02fe0eb5e10f8fefeccfb0b5858e1b3fc9a963da9a08ba90793c7925f0889608727375f',310440000,NULL,NULL,'595d49f626afc5d75c95924cadc5abf6f8a6614c1f86b3a6ffdd8f615c868ef1','5e0f34afe6919cfff0af621f3829dd3a7bf6d71c8229475466e73c65425d14c1','a3695b356a32e4a5ca2e1daafea8dee5feaf1af516b2ed7d65f8f9bf2698449d');
INSERT INTO blocks VALUES(310441,'c90612bc5b434c515ee28b0e4fa24a21fa8f52e4a4e9b0b5bdebb70cdc8a0b8a9b71f4387fd0c06b92b9015486a46dd7a655676dc177efcfb18a5eb7e78f8101',310441000,NULL,NULL,'8bb16001a0d283d67b77c58c6d9c9fdae49bd73f79f05db55b1d59ef22cd587f','168f87807e9e09bc7a85fdb38f018d8abcd17c01d889b1de93b63023713ce0d3','0abf6e97290924200c5ed319d38fb14137d3e6f11810aeda8dd063d04e3fec81');
INSERT INTO blocks VALUES(310442,'67765b8cbc19080cf9c5c7585c1445f338cc0f5c9fc9b99607b28326811e589e065db8b0e13af320f2287384f26902db67461992fb2777ba9d56f6c84037ce2a',310442000,NULL,NULL,'87d20ab7be7bf1338cb945c1a034875df44fd68479e73a4b19155f5a4ede3e72','d72d33da9863f4185b6b1794c5e2d34ccf8a84160900a2b9b8ed7559e1346c3e','3a90af3b270a3191cd4dcefcc054e1997e7e15ad44cbc53a87c014146a9626bc');
INSERT INTO blocks VALUES(310443,'a8f6260ac5bffff343cc564ba7408a59f2ca854cd9789e9c267279df5fab33950c077e3a7e7f0c3c15f6a81e88314a149a0338555b67de2487d61b4d41d0d58d',310443000,NULL,NULL,'5368e6241ce727f632518d670d7e3611804ab1960705a925b4858cfda3f1d32f','afa243230e006e6b0a2e4a347eca5cd7691756c48fafc43ff8d871dfcc2d2ca0','d1fe7fcc5723253d8bc3bc733d6481116daade778b2c3b0a0a919d27e58c3fdf');
INSERT INTO blocks VALUES(310444,'95ea73d35c08423022903aa5c07d1f3f3b09395b278fd389ba9863f3072bc50dcc0c23b0b294688a4e6d7a17abcb41d2da63fe35b94aba0578c3cf36b14a358b',310444000,NULL,NULL,'94945d6abea2d34b524dcfe775ef8c6372721e2af58020c11a5d50a467a76171','be80d0b611e43b731c940f034810532590057ecb5f5a48cd815ce8612fbd51f5','5e9174ed713514da3f016a815a9bbc7a7ae15cb9891c93bee2f89f8a8a2d58d2');
INSERT INTO blocks VALUES(310445,'1c98890928c4de0b4dc1c6e0cccf01d0c921dd5203e45e0dc2f1cf3e6ea7a339629d8a8f67552723db1913a7e7fd2aa4c78bdba4faf0f32c161fd852d9246eb2',310445000,NULL,NULL,'77090dc40559fc0e11c325c9d52df9b154268e8e2c78c1ccc17bebab770f460e','46ee109b7df623860ced2bdac4dd35a1fbd98b5fafe7903c7c38b318754c96ea','f8dccb0d1d9b8389f404ce0a2061b04d0855f4d48591b576645f599ae2e880de');
INSERT INTO blocks VALUES(310446,'8e3e0565eb0ce9d14227549ba219124d0f7a4f03288b84fa0ff808ee3f3099275ab84c7aec8afbb0b192c090a9f0507aa36a1e5145a05c82cf01dcb496b7a702',310446000,NULL,NULL,'19c3c7cbe2b8849b7a77b929e54a71b508e1b71488d2ad8bf45e0a4c8d165302','b858fe2aafbc9355987649521bd431db610f70e6c37af6d92cdba94938dc85cd','f86a2efb06ba796ceeab7f6368b8b1a437e27568f22b7bb2c32ac0a0a774b50f');
INSERT INTO blocks VALUES(310447,'ce5557423db4ee33640d2c3d8b937fce3b13be6bb52ed271e861abd1ab330891b581f2969c3f8e1e485d426682ad90f6101913302a51e87eaca308e27983653f',310447000,NULL,NULL,'06ce8e9abafa9e039674daa796d715456c2bbe991c1cc69cb423588df23dd6b3','1f5a593caefc98799da3e0776a889bcdbe5543a6620dbd786a09d2c4e7e93c1c','3a44995990f9cfa07c78161b82bc2b0553ec5fdc8a6c4f2ae60422a343d411fc');
INSERT INTO blocks VALUES(310448,'bea6b820378cedea8f9b80e03060bb3b27fff3e03d39e246a69bf742d39d85a676a1e2cf9c1af8ffffd2fc8b514948673620a12a17fdefc4dbae372c0fdf1fc7',310448000,NULL,NULL,'e1529128d638dd16f0a573f3e0a6f000a827578a46f09182c8ec291b4af058d9','8ae454b13994d1c83d9854bb3d8324501c6c1d8fb6dda380cef1ee16fa84ecbe','257a71116f9af20c1dc212f5ec7d1ae10cb8076aad52bf9afe6d8c117602f952');
INSERT INTO blocks VALUES(310449,'827f02554733bd9cc66150beb2971a093599e471766c8df7e795c2feb4c6805d7078b6ddfc71c2007f190130297bb4771d0cb5acc95e79ea17fe9323f6fc3f1e',310449000,NULL,NULL,'b3a9027030c5e5f8042c766338d74ed7b6fbfa5eac4bc4d3c20bb2880a96b00c','ca05a0420ed803b582e6d2c2664897594123310642d299940a055534e10a2d44','110c36b279fead15d5ec093a5bff3aefe57b1e9033ba51c2ccc8a7d635a43d3f');
INSERT INTO blocks VALUES(310450,'d2eaeff1ed36dfb25526165d84bb408dc3e3c78656da7949def5f5820fe952fab17658863002e5bcf2b3f0453754a32cc9795beaa4a4ce515a68ec567db75c9b',310450000,NULL,NULL,'5d8dc9363c0554398e07b9930fc9be8b9b79e48ff084f88602944d8228ffdaf9','0aa032640e141259340ad335206d8362b04173cae934ebeb25a752343762034a','1072814b8c7309cbdc2954d2e415d85c8e5f16d43730f9f081860e37180876aa');
INSERT INTO blocks VALUES(310451,'b99ae820d877b82d457cad56ecc061a8b380d027e4bbb40399ac6bbd9ee5f3b7490ca94c6ef64eaaa21ebc3c65f9bdfa681d9ebf734146e4b8500af3c35923cc',310451000,NULL,NULL,'749b7a3009a90db215e314971c0b526c9bc1d67b3cef6e75fbf36b175b49b305','f54afa34e3093443bffcc969c2e4ac9e8473c40909a878fa9e8131d95d2de7b9','efd4cfdb440c0f36463273c9a52d71fb25e55df876c13e11f4408b9207207ccc');
INSERT INTO blocks VALUES(310452,'87af378fcd50ee3e6fbdfe41d32b18062b04794d3849ef6d89292e1a9f4edfb9faedc966b8bc84004c50190aed5e2a7062315bf2a3e473dd1dae8f1745419c9c',310452000,NULL,NULL,'339768dc4e5f7abf99d1c7f60a934427ede057ff7e631220689fa3ab4f614eff','5026b150859ff2dad5ee869d79c84fed8251ab2861d0969b1ab156c33aaeb9e9','289160da552e6401ff5f738688e01eb01c027523d2a4ff2c095698706f575bfe');
INSERT INTO blocks VALUES(310453,'39d3266caf86330e14d8098e7cf3a250c141ef2155d6e076119dd569bcd3cfbd30c1b54ec23adc7539d667699fc183e63dac64f43db02821c641633270e30bee',310453000,NULL,NULL,'0ddf4d027ce23430c57ce8cfeb54c7d54159acc76ca3f863bcbff60bf39aedff','e9e483c85db45d9a1781877d3c8118c26fc08da5d3de79e6585619b7e1e526bd','c9ccf5d9a2e1143d0315bf2b6a9a1bd084c9f53e3b4af96d9509d19bf4f9a896');
INSERT INTO blocks VALUES(310454,'453655d834123bf3701e7fbededaefc369536e4ab68476aa860b25f91cacedc740643bf23a411f66ddff983507e388085ec4d12e92071f9e7affc68d05f0f207',310454000,NULL,NULL,'ea103b07f155a5a2fe679f53486a41015908aaeacbc69c01ed9d709ea3d2c679','cda837f70a93d1454438f865a530c7fd29ea3385a0f6d9c88ae009a4337a950c','26f522acb5a3495531b4a7a20d55e7aa8e5b259588efdaea19a5ed1386353db4');
INSERT INTO blocks VALUES(310455,'8cf0d0c5cc245c62c93d65f012207110f0599d5101c030c339286d1b1ee47d6ac62cdda6e594b812af3a6499ac6bed676e6e9b5cc78f6fa6fd454b078882fede',310455000,NULL,NULL,'6f8e29110aa447c6587d06a015398442c099d517e2b2c405403c03ddd24a2aca','099a09a6ce450500dbdf126e3f712706f6f2d2eafbff630fdf32af8ef7596c94','3965b1563bc5642a955e19cf29793d6fba8d90016e544f9ae987cf8cfd418003');
INSERT INTO blocks VALUES(310456,'e9c44fc9b8b02cc15bbd278ed2eebe4b0a5d8acd4e5ade20114f6bf7c98b759c1cf8b4bd82a9768edbc84804d4852890e13cf68b51409ece90b7173517566d37',310456000,NULL,NULL,'a554ff37cf38f58b872e538d4bd9dbe6ded9a9518587fd19e659b4474ca2d712','e2f89e6e8dc664e0529e20dbb69fa15dad5b54564611c8d7b205321d051fbbe6','d4d74a540fa335f2f6667b0f255a8eb0c7d8d9a671552acbd8fbc84975033f44');
INSERT INTO blocks VALUES(310457,'227e805c488c604445dbd1ac0b23441119d9111cfb891a9d4e4b5e6b3aee8df51c502976dd53831b0dda68ba51f0762987253ee9752dc2f504c0ac8858bde665',310457000,NULL,NULL,'8d85f03d5913f2ee20d76dd8965d52195d3b8d533dd1e84dc2df710e5f72a770','7c4c7333407d03228762a6b9460deda9af6bb12e03ac71c70c4841471af5e5f1','1843b10cfbcddf7a9d9b7f7c1b03ac8fe4ba184b682e4785f4f185039816fa0e');
INSERT INTO blocks VALUES(310458,'564b0e3c71938bae220b18c82d7efbd2b9cc4d04b8afbdddbff3a9786d998ec875eabc22fa71ce7b5ea9556da9ae415db6925b1dab816d6667efdac1ea9b6fd3',310458000,NULL,NULL,'23d9505389cb09ec946af067a9eb03323539336391a41ede49f0f69ede82c11e','f1088098de72f10f4bb0cc51aa7803855a7e6dc3e2249fae72e21f562de20d95','d0a179307bdbfd070f776fd313506e46de78fd205110c9916ab45a06d699e607');
INSERT INTO blocks VALUES(310459,'255c3bb3d2c5102cccd491053a3cb801fa30f6d19e14f6d1dad787e6c8f6493a98437be8bb18b64190dcfe20fbd6131231e1f1a33c299b28c8bb78dcd8dc28e4',310459000,NULL,NULL,'c1975c54d0bd6a1a1697c264ba7f726e9e4985b078db4116f26af51e7f74a833','b360b63c5cf86078552a87193b0dc67493843de75f9134f13666fa96cb0ec313','7fd89329654e1ed4b54e6b1427c6d1d24490bc0ddb40905018a3e5a69b18dc51');
INSERT INTO blocks VALUES(310460,'526dee0281cffcffb609a0512950269f7561bef8195041a2f1a901304e106f76e621f6c11fa5b8dcb8e3395b3133687e716f18f31f5a79747a649c067287cd2e',310460000,NULL,NULL,'ddc4abc79595fca48b784d2f40751d723d05ab2c22559e9b60680c2a6cbd3ecf','91220878cb2cf002c5bf79e2d84bd65399cc8286a1d10d87b1cdc6406eecd2f8','f00769ebbfa3e4b3ddbf230feb62a57623e2ab1332cdf05aa6e62d514a5a79f3');
INSERT INTO blocks VALUES(310461,'6d8efaf9519038da95dea69cfa10b80dfd70374253d830ae26f403a5af772b6b97db546b8ed1cba7306b5a9711bff65ad96b306ca441e6e8c7ec9ecc5b1fcb6b',310461000,NULL,NULL,'dd5ff28166f746ee6b90e55033274e7bd2b5706d8d82995d0d94e7d9ffd7c6bb','0776f9b1b9cc85bafadb86ddb5850ec4ba4245f03effd7b64262c98d11835dce','14c335108a693ce991489e45a7799c712fdbef69dc7fc0f883ddd073d3b9b3be');
INSERT INTO blocks VALUES(310462,'499256a2d3fcf5f55cf6c5cef4019977dd3363e0b3d4e2b720c4074d54774d3152843833b43ebbb95d524ef1d650ea0993e5835e24ae9879256438604af93dea',310462000,NULL,NULL,'ee7683f33c6eb85bdd1a6ae21b6cdb549eef6b4d65f28f1148db4a8f076bf528','423b966582ef2398e9aaa85446aab485db4f483e1bcd8fa850638402589a6d03','339da97dd9ec4179926f7aa186566f947e706732d18e704e6a6ff821ac649d94');
INSERT INTO blocks VALUES(310463,'9acd0066d56a388ad521a8e3f04226009a47653eed7ad34ef5eb37a43398deba496f6e451e35829d2d51860b8cb0b2b3f8e74c7849f416a5fda39adfc4de75cf',310463000,NULL,NULL,'be6410ae92739413489046c24e43c3ea3cbc7af4841ad0bdcce5c46744099ede','332b1420d916577cc59137ff9433e5d38dfb79f4bb03f85a60ce9f106b0a6174','dbe5c64a306b110870d840b21618a834e22bfaa578e5792faa1363d7ee70d794');
INSERT INTO blocks VALUES(310464,'5790232ef73149532b55970e89ec58b781c7673a0faf7d972a45a2c4caa8f05ed6aad51cff4c33b9e5ae4a54355770d9d02421fdae0ed5da66a99f0d2ac8ed09',310464000,NULL,NULL,'52108cd8c669317f55a82cea55c3267702d8401622961106d0f9206fd5d49d02','743b395450b9c698e6a969e16fb1b4d82cf5dcb4a7de30e3395d428920ba0028','13ea246a926ef113ce9dfcbf56f84bd2963ae661824819e518c8dae660ab990a');
INSERT INTO blocks VALUES(310465,'9bcb8cc611f27f7576503f00d8839c784c4fcb95d0ad30282ff7e6c5aa27b0641c43369211043aa2fd8664922d5c226718478803120a06e2ea171a1a5b0663bb',310465000,NULL,NULL,'ef9f39aa39c913ddaadd82cb1bb96016e68a65095fb017b3af7664642f060425','774f215f38fe21b7fc1a8b3b243469d8b28df5dae10e0da7188b8d5a2c034370','ece4e277ac68b359ee263d9d9c8dce2f5865a871dbb5fe3d4e287a7774bba85b');
INSERT INTO blocks VALUES(310466,'0acabdaaac52332db83e63d5d7202a9f94d6e9184c693a4dc3c20f297142faeb634fef2f8b8c4fb29997fb7e0760a16f63c08aefb0bebcd7c4e0cb533331a6e3',310466000,NULL,NULL,'5d9f168dcfc1e9bbe488b305cdc370d575cd7ece642b00f5eb284b2ae30fffa5','a05d6f3feaee4e548574454a9694c7788e92cc6b054d4554c8d3f6ade517c146','0b337a8a6fe1e2dbfc8deba54a267e46f619343d29cc2b3c952bde79ff9e1646');
INSERT INTO blocks VALUES(310467,'bd5e4e06e5b188c11dd3f4ad36e34d8029c3fdb9e91d83ccbe312e9f0a904fda44fe0f594b3498bb8165b0d7c3ec7616a8deab38b9e3c183d1750a81133813c7',310467000,NULL,NULL,'5531cef9d3a2b8b8b14ff642418d34d600069dadbe373d079dd03704e8bdf8eb','405c9b69886ed1f9a2b25668f5b7ad88c127aa4bed975845674aa2dd3315550a','ff5d0238972051744d2e10e2b09a798af64f4dd2806fa3d28d1f68a319132734');
INSERT INTO blocks VALUES(310468,'0a6013242d3cc444bde42c36b753210897e5f23a8faf9d920e178b1158454af0028148ad673f3b03f330fc7f9611966cd9f60c404967756f1d1558866c58ac17',310468000,NULL,NULL,'823b3bc4c10af481b5f72d081b0d1248fb2180ad637d79c3ba855eb1d00465a1','39beadbe14297eadcbf1ee7327422950955b23c7855057d8661c6fe6866532e3','3228f741dec9cba2ae7c615c61831ada38afcc48cd9fb4917a5f83f6b3170a04');
INSERT INTO blocks VALUES(310469,'63d6779e475713b55fcaebda8335a2e4705e53b30a432061b489fd5b02a6a5c32d1591ae0416f5baa886aa3ee407dd9e79b6fd8032f90e895714964bd5bef2f5',310469000,NULL,NULL,'efe8777058382cf5068ad166f49e27e1bfa5c01df45d1038f64a1bf8faf75aed','a38071d47032e240e5cd0006458757cee803908d65b7f0f0fd0ec175dcf95d0b','ef159e7796942c07f1cf19881452c8bf0a596e4b0c43a84091c374430580dd52');
INSERT INTO blocks VALUES(310470,'34d879d68d928ef3a0be963de412685a9742b45df51ea6ffc8d5e64d892514a845501e0296911467adda8afbe053372952c17017198f579049b914126594a19c',310470000,NULL,NULL,'c2e983654bf07c526700d3459c9162cbd28c0ac96d141c5747f7578f9bb208d0','b5fe1c8b12102b26fc190cb57835aa51b889b2ba2be5128e675511da6d8fbb04','bd58373d9059cdb982e3b16da6cd7ba48da243e368c00700d347516524cc6f75');
INSERT INTO blocks VALUES(310471,'933f3f1c5f0817256b05cb1d94b8f4bca9690446feb3b7e5ca11ceb44531a7d9f8b259bdff3406ded3844c5d30381b6bf346de7f2384a59a49982634e23d31eb',310471000,NULL,NULL,'b565151b25d23f8220e5b0c34397444f52465e59d9a95d65a54c4bf2ef586f46','ccd4f933796a271f4864c04b1142525f290aa9193dcaeb7d8ba995712aac3eec','b7307a77d6e7ba291fe3b378897fe3729679abe2f9d80728cae7751173c0f97f');
INSERT INTO blocks VALUES(310472,'56e16b8298be638e21122615b2343d7c67de861523db614331e27e3753c8db24b9edd51ad26f58d44747737cd1635d1341ca680c0e60c0bd8aacaf50acd18a3e',310472000,NULL,NULL,'b64feb750c4403f77a1a2661ac2689b1b5bfb7c0f369b747a3199c0297788565','89e2efa95cede09805516ac56a812797ed02ae4cf1f04021d58358bf748388c7','36a8931c6ea373ea90d2f148e58469b2ffa23946ff978e7916013fa25d600f0d');
INSERT INTO blocks VALUES(310473,'c9958774653eb8e2dc39d119c69b4c5a0cd833ca3833a8314c63625e05ff48d15ff72f0b0445e5e2b3db087e6020dbd0caf4efe3c48414b8d3c7d3b1136755c2',310473000,NULL,NULL,'52e826ae28c2087973eab898c7aa9ce826f99201b6eb2de16ae8196c38427440','431c7274d35852190914444719ed85ef6fd6cff15b4e8d6fb9044de67d91e1c5','cd3fc0e84b1aa7d6acd5bdf8f5e79641b6161f3c3bc56a354fb8a7cd9a023734');
INSERT INTO blocks VALUES(310474,'cf5e7afa76b87d266035e00ec6d8332d006e3804ccaf8e6d8bdf601fbcb0db2e8e74c831b2cc6efa649e19814dbbda8b84245a4bc5a3cb781215b856b3b3d850',310474000,NULL,NULL,'8194434efc71937757a322cd1be2a60f0d2fbf33dda49705d84310fe2b738d3a','2c6333179abb2129168b4b2d870d707eda1e41eec19f1f7ab5f5517b82e94862','4b0faafeacd32e57908d991199d09ff61a89c08aab42508b279fbc99a2a15889');
INSERT INTO blocks VALUES(310475,'0269ce6005cc2f9bbbc0df2558bf402e967e36b929f687210d0cdd41b56c7e83b624d5f1dc31312ae8d9cd15e979f6445ec13ddf2b736d19396a4bd1a8b3069a',310475000,NULL,NULL,'05e76eca3b2f912a9a09db46266d08e65027ebc0bfbb9275e4014152408f8055','bea67aeaf641098f543ea62fb7e13357c5a044be77d469aaec6fca315534bec8','ee5d6b62376bb70942cd1121b1a3bff1273fbd09b3a7623e74fa0fd7fca116e0');
INSERT INTO blocks VALUES(310476,'36ca5650ada15ea2d14ffdc6aebe9895b41205978a5332c52e32653cec6041a3a9ae573ce9e4b712d15130000fc2d934cb5dab39900586b9da08424c3188e4e9',310476000,NULL,NULL,'ffab5bde54c7a79dcbcc0d29e18256e9b1eccd5a62311b47238f2e64b850d03d','bd1785ae6e6f47de4f3ee72027409550d9f137638428ff7f183640dde1a2b382','d175a3fd10fd84a26505af12711ffcf2f0ce2b86409959e36c1c333accafefb4');
INSERT INTO blocks VALUES(310477,'02b67d7d7112074f51820057ba6231bdca7e4fb3da334078f1bc810286e37bf132ad723509e7ede6ab836a2527939fe8149fe61d6483fc71220c06758a81106f',310477000,NULL,NULL,'3ddf08b8fb9f644d4d498f0f4266b73ee72ed4beebde772afeff8074c26260d5','dc965f4a0acfca9a98b77003c263bc2f4a79464210feea901163d765f53f2074','505587df41ca556054c11bed4c822348de5473b74ce3a7b79820f005a3b5f909');
INSERT INTO blocks VALUES(310478,'4e715719b479407cd8cf4cbf7b68c158fb0a4741bfdf8925acdab8014501e9cb0a9591f459106339877fbb67ef54a0414d5ed71666cbbdd4211333a2cb5a9139',310478000,NULL,NULL,'9b65a231886b5f416d55fde846454b8b87429690671be2f721cf22b64dabda3f','636fc97ee19d038187070fb10bb7f74932a2b8ce012bc264a1038b3548dc12b5','a23bfc8d0d702f2e114b209780f82988eb031b7e63d0686b3144d9ee46a21a8e');
INSERT INTO blocks VALUES(310479,'17fb547b6100f5fa1a23d938e869dc6bd0bbc11f363ed67b27166ec682a8128a5ef646753e01df6b043577bc03fd233d1d2122b3cfd320c97ebd238fc26ac295',310479000,NULL,NULL,'b285242da4082293553d309562d214f0cfc7b2228361e7c63d7a96b02e310642','0749b70ecffc46ef32ae7b044283854eee990c55f47e7f35394a298b8a41fc5e','30ace51322926e372e9b8f5f0b0b88eabd224d42e9079e1c33e6f0eba450b5ca');
INSERT INTO blocks VALUES(310480,'4fb45d941467e6bce88e2aca15c620291c255d12f9395aa03c507e270d3c85c4f6686eccc2f2ec53183bf4956b5c754428d6bf30b15298c5e9fd1a6609961522',310480000,NULL,NULL,'ad1c18fd78047deb1b4ece4378538acfc86193f89718d9c6c01ce0f53574c984','bf558216e80621d08cb92a287026f88004d6e3c08334ab05a99863b70a59f370','fcb1881b9ef4fab9013cec03271bd53707965c53043798074c7e2381dc8b2a36');
INSERT INTO blocks VALUES(310481,'8a8d4a92453604438c38fbfe49b8f36a2bfef0e05c01a7fd4703a4ac24a49ebe8ed3545572560067056532f56ceafe4c8fcd3843b0e02933d03f3ae217a612b1',310481000,NULL,NULL,'abda1740571996e1fd867164a6b6caff7c4a172a49c2139963ceafdcf31d79b2','7cc850f1a0f27737a9441dcbef19d34b94d0a6897bf9b6799a608f6fa7aa21f3','b30589cf14bf9ac2cbf0e44cd6a7d6ea9235b105f7c026861cfc96a12fa32bb1');
INSERT INTO blocks VALUES(310482,'c69b79ac29c827a95204e93894e31ba1a2bea5ec36b803d66ce5918e8c3675aa3afecc015249f65863f71bcfe30d14103017f323b7229f1c74d5979bd1b5b075',310482000,NULL,NULL,'9abc20763f6ce8ff75b42d35f328d0d2ed7bda5669933c1ead79402da2eca89f','98c5c0ada82fb958bd630bbb9d8a1ba7d5094cefbb9d70dbf0afa9ef79730459','a3d35f08a53370cf9e3709b4699c5baa3c00ff3936a94c638c19c2fe88d827b4');
INSERT INTO blocks VALUES(310483,'ff2fb1f86c4c126187292c27c8c5cc16c8192b5118302840de294c26708571c4ca647ce3a58a15641f9f26996a6c42103f1fad72ce7c6d6432eb5978bfb2941d',310483000,NULL,NULL,'dd2447d490bcfa411e8d6a1ad03be420c092999c9da171e153f562f8a91ac8e0','9d1038bc6c890634e59bbf1bce94554aab06c7fcfba0c4b6eb39c8e195140ecb','f5f6dde65a3b89bb8101f646b035e2279d3da10ebcf60539063995c0fba2bc7e');
INSERT INTO blocks VALUES(310484,'72ff0b152e7a8e3b03d43a6d2eb6c25c2b55c67acec1950af50bec882dcb28456d60ca80772d4f5293efc2dbbbd3f8d4eff5437318bbbaaff86aca00c74f369e',310484000,NULL,NULL,'076636ba658c139c7eda24dc9522a9a3c816780d72546174fd10ec8398217b2c','ed1f0cd7e00452822acd9b98d72a7099cde8efec1028c0b253a0c0480ae3c8ee','0c9c1e6772d5697033de136dd6e8d9384e4524093dfbf5f8a0ab2787e22b9a71');
INSERT INTO blocks VALUES(310485,'c18768c9be05414ede83933b6914e92ec4db3f9cd6dcf5934d6e515d01bb8da3e6eecfa9ce139b8b8126d0164405ff3b94ee23561581f6ab5e2be848d36ec552',310485000,NULL,NULL,'fd5f9d12b1252bc6b6e560643f813fe2e5afff7b637745fef969495c454ed31b','046241ca2a4d3db2cd12168cd9e635c1501b0ddbaba55deba9f96186d1c00dd7','51f901ac69eb3d7b55e0a1e916a9a4c7da59a4626465fe8b21c4aadc8c0c3ae0');
INSERT INTO blocks VALUES(310486,'438e29ae1f2dd687adf04bcba05256db1ff5053c16db174837a5abd79394572cd73fff18b5a474d00d25d07a4b9bab4407d9a79a5f8cf7e60f8cb96e8a2c3c3c',310486000,NULL,NULL,'a705334b612d27035bb3687e992969a979c36cf0cfcc484031d3bae5919cfb22','912cdd0c0837f3313040af2d8e4b3ecf47501cf549dd8f22006483185d2c8b25','3bc9e70d967197ddbfe79116b09ff7e82523c7ad1ec9cb6d50115dcdba5ab292');
INSERT INTO blocks VALUES(310487,'7a36971ca18df8dabd367528c3d6d1773de803fd7a22754876ecc70e9350e61a2af1f0bd1ccf00715e8c4613a6f2919dcb3382fb0988c236d484f9c5386991b1',310487000,NULL,NULL,'c206a27b466687339bbd72283cf17ef4cba3bd381d60fb76e2252cbc2b50c83b','071c54d3b60974f45bf5c00179faff3e95ce7ea3d9c9a5582388805ba65d1960','1edf71c021c524cccf136fc70dffaf83e67c333ee500f54c50a2cb024910afdb');
INSERT INTO blocks VALUES(310488,'4ed375b4cb5a66ada5db18a0b55c27a494a91475fbe911a1615ef66f0ef0b4e349f8ee6a1ae2ef9a55a7d9e5d136635e589481833901513825e4f27af16cfeaa',310488000,NULL,NULL,'8302fd63ec24b6706018fc5d769a9f61ed913a517fb5fa2163bdc41ee47783de','7952c46145eef748f099ccc64daca9f61fe109ea23a5ac8d55572e7a8bc7a91d','e35578a1cb3569acdc628d6fa44ae5e4327b106cddecac095365e9930f476062');
INSERT INTO blocks VALUES(310489,'b294daac549dc33a5a26a1ec076d0484b9b73a0623bef8d14980520b5520bca0bed4d95896f29ba77ad6f5212e5ea7ff49a892564cbf5a351b4e4d771cc3ead1',310489000,NULL,NULL,'a78afa7cfecc6968e226f47eacba10483f0ceffd9346541460eb09be4013ebe2','09563f2818614c6a0abaf0a94ca314db12a4d19c46ecc0c81cede986f31423ac','3b9992bf2f98fb365104c4316ea4b915f0dc9dfb66890a02a758ecf61cd74ae4');
INSERT INTO blocks VALUES(310490,'fc18260b36da30e7f7bef925d04c3fa86a8f390f11a64eb6e9731a1aedca69258e0a4cf5bf5e0bfd9876e8118e4711f36183c346397635c0af770c6abdcfe2e1',310490000,NULL,NULL,'98c35bd27dbedee483225726049bca0ca9cc53926304eb6ae59788c2b6b0a123','c84a5ad148a88be7549a386981d7cff1e4f2e41598996b73dd920a0a412feee6','830cd452ceec7178ddbadd7c9b9de0fdaedb83f299a639e4d09af6c923096360');
INSERT INTO blocks VALUES(310491,'bf454daa85f5aa7766a92d2740421d2a69af7dde2a5209852e318ff4c5a2f48409a6c1df9fa33d2bdbef9ddc3c77118f6982b4fe00bf99f4fecbf767ef33fc71',310491000,NULL,NULL,'0ab30b5f8e91e8e98988471281e0fc78c6cf692cd6f0df7ff044972b80729c30','23f01b75ab5e9a39e6723e0a77c303a50f6fcec2701ba6b2f80c89ce00ae9c6e','130cb3a1fe186a8f2aa0e82c5bafe7a602a866c3e218d182afe431b93c098f6a');
INSERT INTO blocks VALUES(310492,'7a5dd1618ae6b4bb553d4edc16af2447313c443aa6e31d15a2ae7322bfce7d88160f825ff99dd8429d5fbcf5f2f904e2d486e8fdc2753ba8f6f058390afad447',310492000,NULL,NULL,'e6de2a4f359c2da8ec9ac22bcbc3f1d005abc56ea1e222f9ed05cde452248ab7','415b60a4237359c4339eefea15193eec370e597e3322c10ca5e49cd497ee2cd6','04e26c28a711aaf82cac7fe4e445c57b0285c0007045bc4dcda1ee7c301d03c6');
INSERT INTO blocks VALUES(310493,'e5695fcf012cfc974506f8b9c6b97f3d2aca71dcaf89a5191fd69d56459a7c7d4fde0f50ca105fe249b13e40556aa98d9fbc4f56c98dabbca3ff9dbc45df2521',310493000,NULL,NULL,'33d3c117ca8e340ce385c3b5ced05fef8ac166f083837381935ff3c5275ca387','ba224e60e50e3c94225aa9e3c44df7819c71f59f3ab6c831fe8f41fcc4de30c4','3739fadc764bec3a334e997615dc463c211a1c5e1a1f70e09b96105919873f56');
INSERT INTO blocks VALUES(310494,'5ea4dd62da28162e1829870fbfab1dc6028d01cac7e541bffa6696059705e33e27d266855fa60ace8ffa9c7bc6612dee1b0e4612e4d78575c847c91b2d3b217c',310494000,NULL,NULL,'e9c22909019600ae489f48e257c68c5045d8a6f4d67e29eb7a2a12cdf44a40a5','bdfa2878ac03371fcfea270e3f81fb43f2c89538dad67914399f4124461363c1','39e897f047db224dc3839e3b6fbc5edc997a284cbb73bda73f42dfdea6bc3f39');
INSERT INTO blocks VALUES(310495,'14a4d161b11a33ae7890e835206e0bab161693bea0c4647d59ead2d2c437157f3b0178db71a244c0fbc8c7d56de89bd825aa36d1e8b3b62f972e1867b9160a20',310495000,NULL,NULL,'cf667b3a6a119f43b87f5d42b7601fc827e0f57e0cbbddae2d1dd8544304e74c','e355fb2c8095ecabfb1da961ec9883171b368b302deed969f942b34ad01e3735','d466fead6326577bc5baed3b8cf03651556bdb504e740090d671c4c99cff46b9');
INSERT INTO blocks VALUES(310496,'54967ea8d512b2b886a8e5106016df7f323169118a410af02dcdf9352e97b75ca8041441fd4b6af5ea09fff163f0d0e6d2f7a07518da27e6c367216110f316a6',310496000,NULL,NULL,'688af75884d986cc4f9603a71cb9a5ec617896ec3702eeb99403dd37afe7805f','67b4ff7b83c57b29ddb185abdde526d3123966784da322705aac62e2d556f0c0','e9376ac65d852ae18827f35b24cdf7de0e348ab6921803d917a93b1b25e13b1f');
INSERT INTO blocks VALUES(310497,'366924d489bc84a6b70b134ca2c613cd30e4fbea73f4995249c115938fe49d508e34d463f5a7c26f169be6c013575ff05aa1896a6286611f2f17811fc297eb67',310497000,NULL,NULL,'e416f221b10f10d3466bbb4ea84f93a64fcaf8568a002cf8293aad1e0494f653','0de509998d62a3a694dccafe97e6a73982ce8b17dd779ace62f8e45f5e6ff553','4ff51cf2993d31df3cef6521a6e4cb80859555caad5f6d152e5c10f2a6dbc545');
INSERT INTO blocks VALUES(310498,'5a09832472a10eae9b36467b9c39991a47a88f8167e9f51d5a8c227fd226f1ef17c8052852c09cb4fb1899bade89510f5e20abe94e972e5f94d8feeaa5d3b291',310498000,NULL,NULL,'7b092939d48a648ca136d0c5401aa0b3b13e6b9b9f0f9ee5050d19986237c02c','25a07f6906922afb1cb3952b32c002f69529eac1efb6e52358be47d64741f98e','1a83250f819c8ddd8d1c8b618fbcb728b356b14f49a00dee15c9c63de460dd75');
INSERT INTO blocks VALUES(310499,'dce6fcf2b12dc112411e1a4a526d0ad34b23b8b2db7c9be729bc9ee152c95717a9f48808df0bc5224f99f50089c8c1201d33bce505d8eb90a17260c71b4b2f73',310499000,NULL,NULL,'8810c27dc497269fc8e61cc83ec8f8a838c271c673a2c436ab28dfd8d595f2ed','b8d1d322181ea60a0a60356b4addc0cdf9b35db9a775bd99b080b1139416419e','72e8cb9f9594367cb0568bfb6a193eddadef2c4ccb25b2f87416396d9856737a');
INSERT INTO blocks VALUES(310500,'59092152cea93e29cdd1c2c7f54730cd2c609871a5083ebc50d59b368f90b25ef2586608da40f790e23c0ee53d8a5b1e13af627b3946c1a7fbb39ab617d5afc9',310500000,NULL,NULL,'8c2188fb8d1fc47ed38d2008ab36a63d395f0c68374bc2542c8e14ddfe470950','bbcec2a11f4b5f662a012cbd71e9edb9f29795f2092524164508e8d75af418a4','8a3e3726fdb7ef4e0ba37aaa856399eb91f4da2e23e30d9095bf4a1833d95b8d');
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
INSERT INTO broadcasts VALUES(107,'a2511b980cb24e21a49ff8ac749f8c2b3d274942a1c877b80d155133434d9ff1',310106,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',1388000002,1.0,5000000,'Unit Test',0,'valid');
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
INSERT INTO burns VALUES(104,'0be2e513458ff04fca47d921eef581820b95b88f1d8307943b14bfc6ea5154a2',310103,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',31000000,46499569411,'valid');
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
INSERT INTO credits VALUES(310103,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','XCP',46499569411,'burn','0be2e513458ff04fca47d921eef581820b95b88f1d8307943b14bfc6ea5154a2');
INSERT INTO credits VALUES(310104,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','PAYTOSCRIPT',1000,'issuance','5911288ff7622adc01580adfe723445ca916889a5a51f9d1617f90e6e5c35751');
INSERT INTO credits VALUES(310105,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','DIVISIBLE',100000000,'send','ef51a0e6f6e45fb04919181de0c6454434a922854d093c5e4e8082961cc3cb12');
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
INSERT INTO debits VALUES(310104,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','XCP',50000000,'issuance fee','5911288ff7622adc01580adfe723445ca916889a5a51f9d1617f90e6e5c35751');
INSERT INTO debits VALUES(310105,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','DIVISIBLE',100000000,'send','ef51a0e6f6e45fb04919181de0c6454434a922854d093c5e4e8082961cc3cb12');
INSERT INTO debits VALUES(310107,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','XCP',10,'bet','3afada35d5012c10348d88ff03c7813e8ed7f06b2b259b4be6c847358b3b0a4a');
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
INSERT INTO issuances VALUES(105,'5911288ff7622adc01580adfe723445ca916889a5a51f9d1617f90e6e5c35751',310104,'PAYTOSCRIPT',1000,0,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',0,0,0,0.0,'PSH issued asset',50000000,0,'valid');
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
INSERT INTO messages VALUES(63,310103,'insert','credits','{"action": "burn", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "XCP", "block_index": 310103, "event": "0be2e513458ff04fca47d921eef581820b95b88f1d8307943b14bfc6ea5154a2", "quantity": 46499569411}',0);
INSERT INTO messages VALUES(64,310103,'insert','burns','{"block_index": 310103, "burned": 31000000, "earned": 46499569411, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "valid", "tx_hash": "0be2e513458ff04fca47d921eef581820b95b88f1d8307943b14bfc6ea5154a2", "tx_index": 104}',0);
INSERT INTO messages VALUES(65,310104,'insert','debits','{"action": "issuance fee", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "XCP", "block_index": 310104, "event": "5911288ff7622adc01580adfe723445ca916889a5a51f9d1617f90e6e5c35751", "quantity": 50000000}',0);
INSERT INTO messages VALUES(66,310104,'insert','issuances','{"asset": "PAYTOSCRIPT", "block_index": 310104, "call_date": 0, "call_price": 0.0, "callable": false, "description": "PSH issued asset", "divisible": false, "fee_paid": 50000000, "issuer": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "locked": false, "quantity": 1000, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "valid", "transfer": false, "tx_hash": "5911288ff7622adc01580adfe723445ca916889a5a51f9d1617f90e6e5c35751", "tx_index": 105}',0);
INSERT INTO messages VALUES(67,310104,'insert','credits','{"action": "issuance", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "PAYTOSCRIPT", "block_index": 310104, "event": "5911288ff7622adc01580adfe723445ca916889a5a51f9d1617f90e6e5c35751", "quantity": 1000}',0);
INSERT INTO messages VALUES(68,310105,'insert','debits','{"action": "send", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "DIVISIBLE", "block_index": 310105, "event": "ef51a0e6f6e45fb04919181de0c6454434a922854d093c5e4e8082961cc3cb12", "quantity": 100000000}',0);
INSERT INTO messages VALUES(69,310105,'insert','credits','{"action": "send", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "DIVISIBLE", "block_index": 310105, "event": "ef51a0e6f6e45fb04919181de0c6454434a922854d093c5e4e8082961cc3cb12", "quantity": 100000000}',0);
INSERT INTO messages VALUES(70,310105,'insert','sends','{"asset": "DIVISIBLE", "block_index": 310105, "destination": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "quantity": 100000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "valid", "tx_hash": "ef51a0e6f6e45fb04919181de0c6454434a922854d093c5e4e8082961cc3cb12", "tx_index": 106}',0);
INSERT INTO messages VALUES(71,310106,'insert','broadcasts','{"block_index": 310106, "fee_fraction_int": 5000000, "locked": false, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "valid", "text": "Unit Test", "timestamp": 1388000002, "tx_hash": "a2511b980cb24e21a49ff8ac749f8c2b3d274942a1c877b80d155133434d9ff1", "tx_index": 107, "value": 1.0}',0);
INSERT INTO messages VALUES(72,310107,'insert','debits','{"action": "bet", "address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "asset": "XCP", "block_index": 310107, "event": "3afada35d5012c10348d88ff03c7813e8ed7f06b2b259b4be6c847358b3b0a4a", "quantity": 10}',0);
INSERT INTO messages VALUES(73,310107,'insert','bets','{"bet_type": 3, "block_index": 310107, "counterwager_quantity": 10, "counterwager_remaining": 10, "deadline": 1388000200, "expiration": 1000, "expire_index": 311107, "fee_fraction_int": 5000000.0, "feed_address": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "leverage": 5040, "source": "2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy", "status": "open", "target_value": 0.0, "tx_hash": "3afada35d5012c10348d88ff03c7813e8ed7f06b2b259b4be6c847358b3b0a4a", "tx_index": 108, "wager_quantity": 10, "wager_remaining": 10}',0);
INSERT INTO messages VALUES(74,310491,'insert','debits','{"action": "open order", "address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "asset": "XCP", "block_index": 310491, "event": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b", "quantity": 100000000}',0);
INSERT INTO messages VALUES(75,310491,'insert','orders','{"block_index": 310491, "expiration": 2000, "expire_index": 312491, "fee_provided": 10000, "fee_provided_remaining": 10000, "fee_required": 900000, "fee_required_remaining": 900000, "get_asset": "BTC", "get_quantity": 800000, "get_remaining": 800000, "give_asset": "XCP", "give_quantity": 100000000, "give_remaining": 100000000, "source": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "status": "open", "tx_hash": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b", "tx_index": 492}',0);
INSERT INTO messages VALUES(76,310492,'insert','orders','{"block_index": 310492, "expiration": 2000, "expire_index": 312492, "fee_provided": 1000000, "fee_provided_remaining": 1000000, "fee_required": 0, "fee_required_remaining": 0, "get_asset": "XCP", "get_quantity": 100000000, "get_remaining": 100000000, "give_asset": "BTC", "give_quantity": 800000, "give_remaining": 800000, "source": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "status": "open", "tx_hash": "14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0", "tx_index": 493}',0);
INSERT INTO messages VALUES(77,310492,'update','orders','{"fee_provided_remaining": 10000, "fee_required_remaining": 892800, "get_remaining": 0, "give_remaining": 0, "status": "open", "tx_hash": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b"}',0);
INSERT INTO messages VALUES(78,310492,'update','orders','{"fee_provided_remaining": 992800, "fee_required_remaining": 0, "get_remaining": 0, "give_remaining": 0, "status": "open", "tx_hash": "14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0"}',0);
INSERT INTO messages VALUES(79,310492,'insert','order_matches','{"backward_asset": "BTC", "backward_quantity": 800000, "block_index": 310492, "fee_paid": 7200, "forward_asset": "XCP", "forward_quantity": 100000000, "id": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b_14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0", "match_expire_index": 310512, "status": "pending", "tx0_address": "mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc", "tx0_block_index": 310491, "tx0_expiration": 2000, "tx0_hash": "9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b", "tx0_index": 492, "tx1_address": "mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns", "tx1_block_index": 310492, "tx1_expiration": 2000, "tx1_hash": "14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0", "tx1_index": 493}',0);
INSERT INTO messages VALUES(80,310493,'insert','credits','{"action": "burn", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "XCP", "block_index": 310493, "event": "d6adfa92e20b6211ff5fabb2f7a1c8b037168797984c94734c28e82e92d3b1d6", "quantity": 92995878046}',0);
INSERT INTO messages VALUES(81,310493,'insert','burns','{"block_index": 310493, "burned": 62000000, "earned": 92995878046, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "tx_hash": "d6adfa92e20b6211ff5fabb2f7a1c8b037168797984c94734c28e82e92d3b1d6", "tx_index": 494}',0);
INSERT INTO messages VALUES(82,310494,'insert','debits','{"action": "issuance fee", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "XCP", "block_index": 310494, "event": "084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e", "quantity": 50000000}',0);
INSERT INTO messages VALUES(83,310494,'insert','issuances','{"asset": "DIVIDEND", "block_index": 310494, "call_date": 0, "call_price": 0.0, "callable": false, "description": "Test dividend", "divisible": true, "fee_paid": 50000000, "issuer": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "locked": false, "quantity": 100, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "transfer": false, "tx_hash": "084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e", "tx_index": 495}',0);
INSERT INTO messages VALUES(84,310494,'insert','credits','{"action": "issuance", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "DIVIDEND", "block_index": 310494, "event": "084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e", "quantity": 100}',0);
INSERT INTO messages VALUES(85,310495,'insert','debits','{"action": "send", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "DIVIDEND", "block_index": 310495, "event": "9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602", "quantity": 10}',0);
INSERT INTO messages VALUES(86,310495,'insert','credits','{"action": "send", "address": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "asset": "DIVIDEND", "block_index": 310495, "event": "9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602", "quantity": 10}',0);
INSERT INTO messages VALUES(87,310495,'insert','sends','{"asset": "DIVIDEND", "block_index": 310495, "destination": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "quantity": 10, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "tx_hash": "9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602", "tx_index": 496}',0);
INSERT INTO messages VALUES(88,310496,'insert','debits','{"action": "send", "address": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "asset": "XCP", "block_index": 310496, "event": "54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef", "quantity": 92945878046}',0);
INSERT INTO messages VALUES(89,310496,'insert','credits','{"action": "send", "address": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "asset": "XCP", "block_index": 310496, "event": "54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef", "quantity": 92945878046}',0);
INSERT INTO messages VALUES(90,310496,'insert','sends','{"asset": "XCP", "block_index": 310496, "destination": "mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj", "quantity": 92945878046, "source": "mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH", "status": "valid", "tx_hash": "54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef", "tx_index": 497}',0);
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
INSERT INTO sends VALUES(106,'ef51a0e6f6e45fb04919181de0c6454434a922854d093c5e4e8082961cc3cb12',310105,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','DIVISIBLE',100000000,'valid');
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
INSERT INTO transactions VALUES(1,'610b15f0c2d3845f124cc6026b6c212033de94218b25f89d5dbde47d11085a89',310000,'2ee5123266f21fb8f65495c281a368e1b9f93b6c411986e06efc895a8d82467683e6ea5d863714b23582c1c59576650d07c405a8d9bf0d088ee65621178b259d',310000000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,10000,X'',1);
INSERT INTO transactions VALUES(2,'82e357fac0f41bc8c0c01e781ce96f0871bd3d6aaf57a8e99255d5e9d9fba554',310001,'03a9a24e190a996364217761558e380b94ae9792b8b4dcaa92b6c58d80b9f8f7fcf9a34037be4cd6ad5e0c039b511cccc40c3438a5067822e3cd309f06519612',310001000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'00000014000000A25BE34B66000000174876E800010000000000000000000F446976697369626C65206173736574',1);
INSERT INTO transactions VALUES(3,'6ecaeb544ce2f8a4a24d8d497ecba6ef7b71082a3f1cfdabc48726d5bc90fdca',310002,'d574e4fee71454532c0207f27b9c46f07c5c2e20f43829ddeee8f798053413ac6e0d1b9ad2259a0370fe08581fab3e950ce629db5fadd823251254bf606a05bd',310002000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'000000140006CAD8DC7F0B6600000000000003E800000000000000000000124E6F20646976697369626C65206173736574',1);
INSERT INTO transactions VALUES(4,'a36a2d510757def22f0aa0f1cd1b4cf5e9bb160b051b83df25a101d5bb048928',310003,'44392d9d661459ba31140c59e7d8bcd16b071c864c59f65e2edd9e3c16d598e81aaba40f11019a379bfc6d7811e0265fbb8b276d99cdea7f739fb736f433052a',310003000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001400000003C58E5C5600000000000003E8010000000000000000000E43616C6C61626C65206173736574',1);
INSERT INTO transactions VALUES(5,'044c9ac702136ee7839dc776cb7b43bbb9d5328415925a958679d801ac6c6b63',310004,'58c6f6fbf77a64a5e0df123b1258ae6c3e6d4e21901cc942aeb67b1332422c71e1e7e996c5d4f403159ce5ca3863b7ec7ef8281bbbce5960e258492872055fb5',310004000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001400000000082C82E300000000000003E8010000000000000000000C4C6F636B6564206173736574',1);
INSERT INTO transactions VALUES(6,'bd919f9a31982a6dbc6253e38bfba0a367e24fbd65cf79575648f799b98849b4',310005,'348a1b690661597ee6e950446e7a1deb8bef7906c0e98a78ab4d0fe799fac5f3007dcd648ff0c61da35b19cf99f16f3028e10ba206968475d741fa8a86c4a7ae',310005000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001400000000082C82E3000000000000000001000000000000000000044C4F434B',1);
INSERT INTO transactions VALUES(7,'074fa38a84a81c0ed7957484ebe73836104d3068f66b189e05a7cf0b95c737f3',310006,'9d31b774b633c35635b71669c07880b521880cee9298b6aba44752ec1734cd2aa26b3bed95409d874e68685636a31a038b784d3e085525ab8c26f7e3b7ba3676',310006000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000A25BE34B660000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(8,'d21d82d8298d545b91e4467c287322d2399d8eb08af15bee68f58c4bcfa9a5f9',310007,'41007a4ed39e7df941059c3db6b24b74c1913b80e0fd38d0073a5b121880fd0f7e98989d8d70766957919371fdaf4e5b44125f9f7c449c3b6bea298253075fe3',310007000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'00000000000000A25BE34B660000000005F5E100',1);
INSERT INTO transactions VALUES(9,'e64aac59d8759cde5785f3e1c4af448d95a152a30c76d97c114a3025e5ec118b',310008,'aa28e5948d1158f318393846b4ef67e53ca4c4b047ed8b06eb861db29914e9f1dfe11a8b73aa2225519843661a61e9038cb347015be916c5a44222ed71b8b604',310008000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'0000000000000000000000010000000005F5E100',1);
INSERT INTO transactions VALUES(10,'a9f78534e7f340ba0f0d2ac1851a11a011ca7aa1262349eeba71add8777b162b',310009,'550d7d84590c6e4e7caed4e722151f7e110dc39bf3f54f719babfe89775095abb2d2454014b4cb01fb1e0a7e91639559ce17e096be5178b5c2ca5b22ad41b33a',310009000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000A25BE34B660000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(11,'b6db5c8412a58d9fa75bff41f8a7519353ffd4d359c7c8fa7ee1900bc05e4d9d',310010,'477c4a3445e32cd0c8ef67c808ac6a6362ebc953c396e2d5c0d7e4f185becd15fa99bd7635358dbb3b5a92e9f03b7fa2dda8d4714e181ec4552b279df3ba81f0',310010000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000000000000000000000000F424007D000000000000DBBA0',1);
INSERT INTO transactions VALUES(12,'8a63e7a516d36c17ac32999222ac282ab94fb9c5ea30637cd06660b3139510f6',310011,'05f81b5c1b067b647894014cea65558826be42cca20a6cccb8623d80059182b77da00922539c59a0a7b63f6f011ca0f564fada0451e891644728b874c65267b9',310011000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,1000000,X'0000000A000000000000000000000000000A2C2B00000000000000010000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(13,'d4428cf4082bc5fe8fed72673f956d351f269a308cf0d0d0b87f76dd3b6165f4',310012,'e9d898aae43fc103110e4935cabf01b6016571b1af82e27af04b57c12302b05eab217f075ac3344b0a422e76b8c762c119cb290c867bb6eed432994ec28af027',310012000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'0000000000000000000000010000000011E1A300',1);
INSERT INTO transactions VALUES(14,'97aaf458fdbe3a8d7e57b4c238706419c001fc5810630c0c3cd2361821052a0d',310013,'2251b497007459321f72cda82681d07d131dd81cc29137b18c534bbb09271678f4497d0316ffac262f021f901078926dee11c791a3524ad850ee948474abd3b5',310013000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'00000000000000A25BE34B66000000003B9ACA00',1);
INSERT INTO transactions VALUES(15,'29cd663b5e5b0801717e46891bc57e1d050680da0a803944623f6021151d2592',310014,'f98fb331e66361507190a1cb1df81b814d24517e7f219029c068b649c9b8a75703770369ebafd864d104225d6fe1fbf13705d1a37a819b04fb151ed390d7bcf8',310014000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns',5430,10000,X'000000000006CAD8DC7F0B660000000000000005',1);
INSERT INTO transactions VALUES(16,'b285ff2379716e92ab7b68ad4e68ba74a999dc9ca8c312c377231a89da7e9361',310015,'7c25469d6b4fed0e8bb9e4325994c4de1737570fece605b4ca388be6921406b64a395dc519b33c0dff4f93930b32737a941bbb850e31f2ebcd2caba520bc2820',310015000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','1_mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc_mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns_2',7800,10000,X'000000000006CAD8DC7F0B66000000000000000A',1);
INSERT INTO transactions VALUES(17,'cd929bf57f5f26550a56ba40eecd258b684842777dfc434a46b65a86e924bf52',310016,'9f1c56677b369099f059cc145b98f2e3f8895631cdf0f72b7fe76fd953ab68c202329848dfb53f8146552876eba37f50ed02da34f23447f518449bf0ac0cc29e',310016000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'000000140000000000033A3E7FFFFFFFFFFFFFFF01000000000000000000104D6178696D756D207175616E74697479',1);
INSERT INTO transactions VALUES(18,'9b70f9ad8c0d92ff27127d081169cebee68a776f4974e757de09a46e85682d66',310017,'4c02945de20ccdc874ae21bf56aea2f40a029c17b81fcf602b367bdbc286f9ec0cacab35fc07ac60aefa4a96a586aed20129ad66d45ab87697704d731e06b40d',310017000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001E52BB33003FF0000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(19,'f6548d72d0726bd869fdfdcf44766871f7ab721efda6ed7bce0d4c88b43bf1cf',310018,'6a26d120314af1710052c8f8f78453f944a146039679c781e04ddbb5a2d010927726fa6f81d3e01fc1fcc3363c06e8e1a81a35636684c4dbcd51edf561a9c0fc',310018000,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','',0,10000,X'0000001E4CC552003FF000000000000000000000046C6F636B',1);
INSERT INTO transactions VALUES(20,'be15d34c959fde8f2baff8577d73d28c864e7684cc76ecba33e5d6d79ca6d6bd',310019,'592e775a9259b1a5a7b0d7c2e028ff320783e7b49243ed6a20ece89a72964f3af4ed129698c4a143ad682a1493f982c5f8193d3b0e36b3df43964520409beb7a',310019000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000152BB3301000000000000000900000000000000090000000000000000000013B000000064',1);
INSERT INTO transactions VALUES(21,'90c1314847b1fe9b4520a3610dc98c71d39a1cb4b96edb9b02b6fed844a4b1e5',310020,'87fac74eef20e6121d9a66c90481f801a10d636976a6a6e7cf42fc38cc104a470e1b4cab3f9670be86c93ec1a407a1b464599121df6c8109ec7247b25c7efc62',310020000,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000052BB3301000000000000000900000000000000090000000000000000000013B000000064',1);
INSERT INTO transactions VALUES(102,'ba0ef1dfbbc87df94e1d198b0e9e3c06301710d4aab3d85116cbc8199954644a',310101,'e8a8ebd85a460cf5987683360a1c77e6728b4e59027220f8eceda05c720bc38c91f6193bc43739da026cd28f340e1a10b9900bfa3eed11f88339147c61b65504',310101000,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc',5430,10000,X'00000028000352BB33C8000000000000000A000000000000000A0000000000000000000013B0000003E8',1);
INSERT INTO transactions VALUES(103,'18cbfca6cd776158c13245977b4eead061e6bdcea8118faa6996fb6d01b51d4e',310102,'767209a2b49c4e2aef6ef3fae88ff8bb450266a5dc303bbaf1c8bfb6b86cf835053b6a4906ae343265125f8d3b773c5bd4111451410b18954ad76c8a9aff2046',310102000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000001E52BB33023FF0000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(104,'0be2e513458ff04fca47d921eef581820b95b88f1d8307943b14bfc6ea5154a2',310103,'e9041ceed8f1db239510cc8d28e5abc3f2c781097b184faae934b577b78c54435a4205ee895ccabd5c5e06ff3b19c17a0a6f5f124a95d34b3d06d1444afb996a',310103000,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','mvCounterpartyXXXXXXXXXXXXXXW24Hef',31000000,10000,X'',1);
INSERT INTO transactions VALUES(105,'5911288ff7622adc01580adfe723445ca916889a5a51f9d1617f90e6e5c35751',310104,'04faacf3df57c1af43f1211679d90f0cb6a3de4620323226a87e134392d4b8f7fc5d15f4342bee5bff0f206a64183c706d751bdace2b68c0107e237d77bb0ebb',310104000,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','',0,10000,X'0000001400078A8FE2E5E44100000000000003E8000000000000000000001050534820697373756564206173736574',1);
INSERT INTO transactions VALUES(106,'ef51a0e6f6e45fb04919181de0c6454434a922854d093c5e4e8082961cc3cb12',310105,'673579ef7bc7828b4427a7144355901327f4cd6e14a8ee356caa1a556eb15f88d6f8f599556590f9f00979dc4d4cde4ff5ea7e2ae683e2a14706fc03aed8ecbc',310105000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',5430,10000,X'00000000000000A25BE34B660000000005F5E100',1);
INSERT INTO transactions VALUES(107,'a2511b980cb24e21a49ff8ac749f8c2b3d274942a1c877b80d155133434d9ff1',310106,'8dc95e1d0fbe11694812b71d390ec5ca5058fb64d34e2805273d5d71286865371dd1ec0584e6ba1fc0b9b09f1d43f9529ac67f134fe30685f1962abeb88fcfa1',310106000,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','',0,10000,X'0000001E52BB33023FF0000000000000004C4B4009556E69742054657374',1);
INSERT INTO transactions VALUES(108,'3afada35d5012c10348d88ff03c7813e8ed7f06b2b259b4be6c847358b3b0a4a',310107,'535b56c056428600fa79bd68d4476504453f02fda130fe45b3f7994298801cf0791cb1a858c3d3b90780941a64e5e788e828032268e3e94134a7fc05fc5b7c8a',310107000,'2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy','2MyJHMUenMWonC35Yi6PHC7i2tkS7PuomCy',5430,10000,X'00000028000352BB33C8000000000000000A000000000000000A0000000000000000000013B0000003E8',1);
INSERT INTO transactions VALUES(492,'9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b',310491,'bf454daa85f5aa7766a92d2740421d2a69af7dde2a5209852e318ff4c5a2f48409a6c1df9fa33d2bdbef9ddc3c77118f6982b4fe00bf99f4fecbf767ef33fc71',310491000,'mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc','',0,10000,X'0000000A00000000000000010000000005F5E100000000000000000000000000000C350007D000000000000DBBA0',1);
INSERT INTO transactions VALUES(493,'14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0',310492,'7a5dd1618ae6b4bb553d4edc16af2447313c443aa6e31d15a2ae7322bfce7d88160f825ff99dd8429d5fbcf5f2f904e2d486e8fdc2753ba8f6f058390afad447',310492000,'mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns','',0,1000000,X'0000000A000000000000000000000000000C350000000000000000010000000005F5E10007D00000000000000000',1);
INSERT INTO transactions VALUES(494,'d6adfa92e20b6211ff5fabb2f7a1c8b037168797984c94734c28e82e92d3b1d6',310493,'e5695fcf012cfc974506f8b9c6b97f3d2aca71dcaf89a5191fd69d56459a7c7d4fde0f50ca105fe249b13e40556aa98d9fbc4f56c98dabbca3ff9dbc45df2521',310493000,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mvCounterpartyXXXXXXXXXXXXXXW24Hef',62000000,10000,X'',1);
INSERT INTO transactions VALUES(495,'084102fa0722f5520481f34eabc9f92232e4d1647b329b3fa58bffc8f91c5e4e',310494,'5ea4dd62da28162e1829870fbfab1dc6028d01cac7e541bffa6696059705e33e27d266855fa60ace8ffa9c7bc6612dee1b0e4612e4d78575c847c91b2d3b217c',310494000,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','',0,10000,X'00000014000000063E985FFD0000000000000064010000000000000000000D54657374206469766964656E64',1);
INSERT INTO transactions VALUES(496,'9d3391348171201de9b5eb70ca80896b0ae166fd51237c843a90c1b4ccf8c602',310495,'14a4d161b11a33ae7890e835206e0bab161693bea0c4647d59ead2d2c437157f3b0178db71a244c0fbc8c7d56de89bd825aa36d1e8b3b62f972e1867b9160a20',310495000,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj',5430,10000,X'00000000000000063E985FFD000000000000000A',1);
INSERT INTO transactions VALUES(497,'54f4c7b383ea19147e62d2be9f3e7f70b6c379baac15e8b4cf43f7c21578c1ef',310496,'54967ea8d512b2b886a8e5106016df7f323169118a410af02dcdf9352e97b75ca8041441fd4b6af5ea09fff163f0d0e6d2f7a07518da27e6c367216110f316a6',310496000,'mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH','mqPCfvqTfYctXMUfmniXeG2nyaN8w6tPmj',5430,10000,X'00000000000000000000000100000015A4018C1E',1);
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
INSERT INTO undolog VALUES(122,'UPDATE balances SET address=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',asset=''XCP'',quantity=92050000000 WHERE rowid=1');
INSERT INTO undolog VALUES(123,'DELETE FROM debits WHERE rowid=22');
INSERT INTO undolog VALUES(124,'DELETE FROM orders WHERE rowid=5');
INSERT INTO undolog VALUES(125,'DELETE FROM orders WHERE rowid=6');
INSERT INTO undolog VALUES(126,'UPDATE orders SET tx_index=492,tx_hash=''9093cfde7b0d970844f7619ec07dc9313df4bf8e0fe42e7db8e17c022023360b'',block_index=310491,source=''mn6q3dS2EnDUx3bmyWc6D4szJNVGtaR7zc'',give_asset=''XCP'',give_quantity=100000000,give_remaining=100000000,get_asset=''BTC'',get_quantity=800000,get_remaining=800000,expiration=2000,expire_index=312491,fee_required=900000,fee_required_remaining=900000,fee_provided=10000,fee_provided_remaining=10000,status=''open'' WHERE rowid=5');
INSERT INTO undolog VALUES(127,'UPDATE orders SET tx_index=493,tx_hash=''14cc265394e160335493215c3276712da0cb1d77cd8ed9f284441641795fc7c0'',block_index=310492,source=''mtQheFaSfWELRB2MyMBaiWjdDm6ux9Ezns'',give_asset=''BTC'',give_quantity=800000,give_remaining=800000,get_asset=''XCP'',get_quantity=100000000,get_remaining=100000000,expiration=2000,expire_index=312492,fee_required=0,fee_required_remaining=0,fee_provided=1000000,fee_provided_remaining=1000000,status=''open'' WHERE rowid=6');
INSERT INTO undolog VALUES(128,'DELETE FROM order_matches WHERE rowid=1');
INSERT INTO undolog VALUES(129,'DELETE FROM balances WHERE rowid=16');
INSERT INTO undolog VALUES(130,'DELETE FROM credits WHERE rowid=21');
INSERT INTO undolog VALUES(131,'DELETE FROM burns WHERE rowid=494');
INSERT INTO undolog VALUES(132,'UPDATE balances SET address=''mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH'',asset=''XCP'',quantity=92995878046 WHERE rowid=16');
INSERT INTO undolog VALUES(133,'DELETE FROM debits WHERE rowid=23');
INSERT INTO undolog VALUES(134,'DELETE FROM assets WHERE rowid=9');
INSERT INTO undolog VALUES(135,'DELETE FROM issuances WHERE rowid=495');
INSERT INTO undolog VALUES(136,'DELETE FROM balances WHERE rowid=17');
INSERT INTO undolog VALUES(137,'DELETE FROM credits WHERE rowid=22');
INSERT INTO undolog VALUES(138,'UPDATE balances SET address=''mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH'',asset=''DIVIDEND'',quantity=100 WHERE rowid=17');
INSERT INTO undolog VALUES(139,'DELETE FROM debits WHERE rowid=24');
INSERT INTO undolog VALUES(140,'DELETE FROM balances WHERE rowid=18');
INSERT INTO undolog VALUES(141,'DELETE FROM credits WHERE rowid=23');
INSERT INTO undolog VALUES(142,'DELETE FROM sends WHERE rowid=496');
INSERT INTO undolog VALUES(143,'UPDATE balances SET address=''mnfAHmddVibnZNSkh8DvKaQoiEfNsxjXzH'',asset=''XCP'',quantity=92945878046 WHERE rowid=16');
INSERT INTO undolog VALUES(144,'DELETE FROM debits WHERE rowid=25');
INSERT INTO undolog VALUES(145,'DELETE FROM balances WHERE rowid=19');
INSERT INTO undolog VALUES(146,'DELETE FROM credits WHERE rowid=24');
INSERT INTO undolog VALUES(147,'DELETE FROM sends WHERE rowid=497');

-- Table  undolog_block
DROP TABLE IF EXISTS undolog_block;
CREATE TABLE undolog_block(
                        block_index INTEGER PRIMARY KEY,
                        first_undo_index INTEGER);
INSERT INTO undolog_block VALUES(310400,122);
INSERT INTO undolog_block VALUES(310401,122);
INSERT INTO undolog_block VALUES(310402,122);
INSERT INTO undolog_block VALUES(310403,122);
INSERT INTO undolog_block VALUES(310404,122);
INSERT INTO undolog_block VALUES(310405,122);
INSERT INTO undolog_block VALUES(310406,122);
INSERT INTO undolog_block VALUES(310407,122);
INSERT INTO undolog_block VALUES(310408,122);
INSERT INTO undolog_block VALUES(310409,122);
INSERT INTO undolog_block VALUES(310410,122);
INSERT INTO undolog_block VALUES(310411,122);
INSERT INTO undolog_block VALUES(310412,122);
INSERT INTO undolog_block VALUES(310413,122);
INSERT INTO undolog_block VALUES(310414,122);
INSERT INTO undolog_block VALUES(310415,122);
INSERT INTO undolog_block VALUES(310416,122);
INSERT INTO undolog_block VALUES(310417,122);
INSERT INTO undolog_block VALUES(310418,122);
INSERT INTO undolog_block VALUES(310419,122);
INSERT INTO undolog_block VALUES(310420,122);
INSERT INTO undolog_block VALUES(310421,122);
INSERT INTO undolog_block VALUES(310422,122);
INSERT INTO undolog_block VALUES(310423,122);
INSERT INTO undolog_block VALUES(310424,122);
INSERT INTO undolog_block VALUES(310425,122);
INSERT INTO undolog_block VALUES(310426,122);
INSERT INTO undolog_block VALUES(310427,122);
INSERT INTO undolog_block VALUES(310428,122);
INSERT INTO undolog_block VALUES(310429,122);
INSERT INTO undolog_block VALUES(310430,122);
INSERT INTO undolog_block VALUES(310431,122);
INSERT INTO undolog_block VALUES(310432,122);
INSERT INTO undolog_block VALUES(310433,122);
INSERT INTO undolog_block VALUES(310434,122);
INSERT INTO undolog_block VALUES(310435,122);
INSERT INTO undolog_block VALUES(310436,122);
INSERT INTO undolog_block VALUES(310437,122);
INSERT INTO undolog_block VALUES(310438,122);
INSERT INTO undolog_block VALUES(310439,122);
INSERT INTO undolog_block VALUES(310440,122);
INSERT INTO undolog_block VALUES(310441,122);
INSERT INTO undolog_block VALUES(310442,122);
INSERT INTO undolog_block VALUES(310443,122);
INSERT INTO undolog_block VALUES(310444,122);
INSERT INTO undolog_block VALUES(310445,122);
INSERT INTO undolog_block VALUES(310446,122);
INSERT INTO undolog_block VALUES(310447,122);
INSERT INTO undolog_block VALUES(310448,122);
INSERT INTO undolog_block VALUES(310449,122);
INSERT INTO undolog_block VALUES(310450,122);
INSERT INTO undolog_block VALUES(310451,122);
INSERT INTO undolog_block VALUES(310452,122);
INSERT INTO undolog_block VALUES(310453,122);
INSERT INTO undolog_block VALUES(310454,122);
INSERT INTO undolog_block VALUES(310455,122);
INSERT INTO undolog_block VALUES(310456,122);
INSERT INTO undolog_block VALUES(310457,122);
INSERT INTO undolog_block VALUES(310458,122);
INSERT INTO undolog_block VALUES(310459,122);
INSERT INTO undolog_block VALUES(310460,122);
INSERT INTO undolog_block VALUES(310461,122);
INSERT INTO undolog_block VALUES(310462,122);
INSERT INTO undolog_block VALUES(310463,122);
INSERT INTO undolog_block VALUES(310464,122);
INSERT INTO undolog_block VALUES(310465,122);
INSERT INTO undolog_block VALUES(310466,122);
INSERT INTO undolog_block VALUES(310467,122);
INSERT INTO undolog_block VALUES(310468,122);
INSERT INTO undolog_block VALUES(310469,122);
INSERT INTO undolog_block VALUES(310470,122);
INSERT INTO undolog_block VALUES(310471,122);
INSERT INTO undolog_block VALUES(310472,122);
INSERT INTO undolog_block VALUES(310473,122);
INSERT INTO undolog_block VALUES(310474,122);
INSERT INTO undolog_block VALUES(310475,122);
INSERT INTO undolog_block VALUES(310476,122);
INSERT INTO undolog_block VALUES(310477,122);
INSERT INTO undolog_block VALUES(310478,122);
INSERT INTO undolog_block VALUES(310479,122);
INSERT INTO undolog_block VALUES(310480,122);
INSERT INTO undolog_block VALUES(310481,122);
INSERT INTO undolog_block VALUES(310482,122);
INSERT INTO undolog_block VALUES(310483,122);
INSERT INTO undolog_block VALUES(310484,122);
INSERT INTO undolog_block VALUES(310485,122);
INSERT INTO undolog_block VALUES(310486,122);
INSERT INTO undolog_block VALUES(310487,122);
INSERT INTO undolog_block VALUES(310488,122);
INSERT INTO undolog_block VALUES(310489,122);
INSERT INTO undolog_block VALUES(310490,122);
INSERT INTO undolog_block VALUES(310491,122);
INSERT INTO undolog_block VALUES(310492,125);
INSERT INTO undolog_block VALUES(310493,129);
INSERT INTO undolog_block VALUES(310494,132);
INSERT INTO undolog_block VALUES(310495,138);
INSERT INTO undolog_block VALUES(310496,143);
INSERT INTO undolog_block VALUES(310497,148);
INSERT INTO undolog_block VALUES(310498,148);
INSERT INTO undolog_block VALUES(310499,148);
INSERT INTO undolog_block VALUES(310500,148);

-- For primary key autoincrements the next id to use is stored in
-- sqlite_sequence
DELETE FROM main.sqlite_sequence WHERE name='undolog';
INSERT INTO main.sqlite_sequence VALUES ('undolog', 147);

COMMIT TRANSACTION;
