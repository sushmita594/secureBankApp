

DROP DATABASE bank;
CREATE DATABASE bank;

DROP TABLE IF EXISTS bank.user;
CREATE TABLE bank.user (
  user_id int(11) unsigned NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  gender varchar(2) NOT NULL,
  dob date NOT NULL,
  contact varchar(12) NOT NULL unique ,
  email_id varchar(255) NOT NULL unique ,
  address varchar(255) NOT NULL,
  user_type int(2) NOT NULL,
  created timestamp DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE bank.user AUTO_INCREMENT=1000;

DROP TABLE IF EXISTS bank.account;
CREATE TABLE bank.account (
  account_no int(11) unsigned NOT NULL AUTO_INCREMENT,
  user_id int(11) unsigned NOT NULL,
  balance decimal(10,2) NOT NULL,
  routing_no int(11) NOT NULL,
  account_type int(2) NOT NULL,
  interest decimal(5,2),
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (account_no),
  FOREIGN KEY (user_id) REFERENCES bank.user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE bank.account AUTO_INCREMENT=1000000;

DROP TABLE IF EXISTS  bank.transaction_request;
CREATE TABLE bank.transaction_request (
  request_id int(11) NOT NULL AUTO_INCREMENT,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP(),
  status_id int(11) NOT NULL,
  created_by varchar(255) NOT NULL,
  approved_by varchar(255),
  approved_at timestamp null,
  from_account int(11) unsigned NOT NULL,
  to_account int(11) unsigned,
  description varchar(255),
  type int(2) NOT NULL,
  transaction_amount decimal(10,2) NOT NULL,
  critical int(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (request_id),
  FOREIGN KEY (from_account) REFERENCES bank.account(account_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS bank.transaction;
CREATE TABLE bank.transaction (
  transaction_id int(11) unsigned NOT NULL AUTO_INCREMENT,
  transaction_amount decimal(10,2) NOT NULL,
  transaction_timestamp timestamp DEFAULT CURRENT_TIMESTAMP(),
  transaction_type int(1) NOT NULL,
  description varchar(255),
  status int(1),
  account_no int(11) unsigned NOT NULL,
  balance decimal(10,2),
  request_id int(11),
  PRIMARY KEY (transaction_id),
  FOREIGN KEY (account_no) REFERENCES bank.account(account_no),
  FOREIGN KEY (request_id) REFERENCES bank.transaction_request(request_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS bank.auth_role;
CREATE TABLE bank.auth_role (
  auth_role_id int(2) NOT NULL AUTO_INCREMENT,
  role_name varchar(255) DEFAULT NULL,
  role_desc varchar(255) DEFAULT NULL,
  PRIMARY KEY (auth_role_id)
);

INSERT INTO bank.auth_role VALUES (1,'ADMIN','Administrator');
INSERT INTO bank.auth_role VALUES (2,'TIER1','Tier 1 Employee');
INSERT INTO bank.auth_role VALUES (3,'TIER2','Tier 2 Employee');
INSERT INTO bank.auth_role VALUES (4,'USER','Bank User');
INSERT INTO bank.auth_role VALUES (5,'MERCHANT','Merchant customers');


DROP TABLE IF EXISTS bank.auth_user;
CREATE TABLE bank.auth_user (
  auth_user_id int(11) NOT NULL AUTO_INCREMENT,
  first_name varchar(255) NOT NULL,
  last_name varchar(255) NOT NULL,
  email varchar(255) NOT NULL unique ,
  password varchar(255) NOT NULL,
  status varchar(255),
  otp int(11),
  expiry timestamp,
  PRIMARY KEY (auth_user_id),
  
);


DROP TABLE IF EXISTS bank.admin_log;
CREATE TABLE bank.admin_log (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  log_timestamp timestamp ,
  related_user_id varchar(255) NOT NULL,
  message varchar(255),
  updated_time timestamp,
  transaction_id int(11) NOT NULL,
  request_id int(11) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (transaction_id) REFERENCES bank.transaction(transaction_id),
  FOREIGN KEY (request_id) REFERENCES bank.transaction_request(request_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS bank.cards;
CREATE TABLE bank.cards (
  card_id int(11) unsigned NOT NULL AUTO_INCREMENT,
  account_no int(11) unsigned NOT NULL,
  balance decimal(10,2) NOT NULL,
  credit_limit decimal(10,2) NOT NULL,
  type int(2) NOT NULL,
  created timestamp DEFAULT CURRENT_TIMESTAMP(),
  updated timestamp DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (card_id),
  FOREIGN KEY (account_no) REFERENCES bank.account(account_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE bank.cards AUTO_INCREMENT=8000000;


DROP TABLE IF EXISTS bank.checks;
CREATE TABLE bank.checks (
  check_id int(11) unsigned NOT NULL AUTO_INCREMENT,
  account_no int(11) unsigned NOT NULL,
  amount decimal(10,2) NOT NULL,
  issued_at timestamp DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (check_id),
  FOREIGN KEY (account_no) REFERENCES bank.account(account_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS  bank.account_request;
CREATE TABLE bank.account_request (
  request_id int(11) NOT NULL AUTO_INCREMENT,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP(),
  status_id int(11) NOT NULL,
  created_by varchar(255) NOT NULL,
  approved_by varchar(255),
  approved_at timestamp null,
  description varchar(255),
  type int(2) NOT NULL,
  account VARCHAR(1024),
  client int(11),
  employee int(11),
  role int(2) NOT NULL,
  PRIMARY KEY (request_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS bank.help_page;
CREATE TABLE bank.help_page (
  help_id int(11) unsigned NOT NULL AUTO_INCREMENT,
  auth_user_id int(11),
  mobile varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  title varchar(255) NOT NULL,
  shortdescription varchar(255) NOT NULL,
  PRIMARY KEY (help_id),
  FOREIGN KEY (auth_user_id) REFERENCES bank.auth_user(auth_user_id)
);


DROP TRIGGER IF EXISTS  bank.account_trigger;
delimiter //
CREATE TRIGGER bank.account_trigger BEFORE DELETE ON bank.account
FOR EACH ROW
BEGIN
DELETE FROM bank.transaction_request where from_account = OLD.account_no;
DELETE FROM bank.transaction_request where request_id in
(SELECT request_id from bank.transaction where account_no = OLD.account_no);
DELETE FROM bank.transaction where account_no = OLD.account_no;
DELETE FROM bank.cards where account_no = OLD.account_no;
DELETE FROM bank.checks where account_no = OLD.account_no;
END;//
delimiter ;


