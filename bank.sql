drop database bank;
CREATE DATABASE bank;
CREATE TABLE bank.roles
                (
                role_id  INT NOT NULL,
                role_description VARCHAR(45) NOT NULL,
                PRIMARY KEY(role_id)
                ) ENGINE=INNODB;
                
insert into bank.roles values(1,'Regular Employee');  
insert into bank.roles values(2,'System Manager');  
insert into bank.roles values(3,'Administrator');  
insert into bank.roles values(4,'Individual User');  
insert into bank.roles values(5,'Merchant');

CREATE TABLE bank.status_definition
(
		status_id INT PRIMARY KEY,
		name VARCHAR(20)
) ENGINE=INNODB;

insert into bank.status_definition values(1,'APPROVED');
insert into bank.status_definition values(2,'PENDING');
insert into bank.status_definition values(3,'DECLINED');
insert into bank.status_definition values(4,'LOCKED');

CREATE TABLE bank.users 
                 ( 
                              user_id   INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
                              username  VARCHAR(45) NOT NULL, 
                              password  VARCHAR(45) NOT NULL, 
                              firstname VARCHAR(45) NOT NULL, 
                              lastname  VARCHAR(45) NULL, 
                              email     VARCHAR(45) UNIQUE NOT NULL, 
                              address   VARCHAR(45) NOT NULL, 
                              phone     LONG NULL, 
			                  Role_id   INT NOT NULL,
							  NO_OF_ATTEMPTS  INT DEFAULT 0,
			                  user_status INT DEFAULT 1 REFERENCES status_definition(status_id),
                              FOREIGN KEY (Role_id) REFERENCES bank.roles(role_id)
                 ) ENGINE=INNODB;

insert into bank.users values(11348,'ap','288e818589f6a8846af619f44c2f39b11691ce57','ap','ap','406095865@qq.com','Tempe',44444444,1,0,1);
##  288e818589f6a8846af619f44c2f39b11691ce57   == "Zz123456"

CREATE TABLE bank.sec_questions
                (
                q_id  INT NOT NULL,
                question VARCHAR(200) NOT NULL,
                PRIMARY KEY(q_id)
                ) ENGINE=INNODB; 
                
insert into bank.sec_questions values('1','What was your childhood nickname?');  
insert into bank.sec_questions values('2','What is the name of your favorite childhood friend?');  
insert into bank.sec_questions values('3','What school did you attend for sixth grade?');  
insert into bank.sec_questions values('4','What was your favorite food as a child?');  
insert into bank.sec_questions values('5','What is your favorite team?');     
insert into bank.sec_questions values('6','What was the name of the hospital where you were born?');

CREATE TABLE bank.user_ques_mapping 
                 ( 
							   user_id  INT NOT NULL, 
                               q_id  INT NOT NULL, 
                               q_ans VARCHAR(100) NOT NULL,
                               PRIMARY KEY(user_id,q_id),
                               FOREIGN KEY (user_id) REFERENCES bank.users(user_id) ON DELETE CASCADE,
                               FOREIGN KEY (q_id) REFERENCES bank.sec_questions(q_id)
                 ) ENGINE=INNODB;
                 
CREATE TABLE bank.account_type
                (
				        type_id INT NOT NULL,
                account_desc VARCHAR(45) NOT NULL,
                PRIMARY KEY(type_id)
                ) ENGINE=INNODB;
                
insert into  	bank.account_type values(1,"Savings");
insert into  	bank.account_type values(2,"Checkings");
insert into  	bank.account_type values(3,"Credit");
                 
CREATE TABLE bank.account
                (
				        account_id INT NOT NULL AUTO_INCREMENT,
				        user_id INT NOT NULL,
                amount INT NOT NULL,
				        type_id INT NOT NULL,
				        account_status INT NOT NULL,
                PRIMARY KEY(account_id),
                FOREIGN KEY (user_id) REFERENCES bank.users(user_id) ON DELETE CASCADE,
				        FOREIGN KEY (type_id) REFERENCES bank.account_type(type_id),
				        FOREIGN KEY (account_status) REFERENCES bank.status_definition(status_id)
                ) ENGINE=INNODB;

CREATE TABLE bank.edituseraccountapprovals(
	owner_id INT REFERENCES users(user_id),
	user_id INT REFERENCES users(user_id),
	approval_status INT NOT NULL,
	approval_stage INT NOT NULL,
	PRIMARY KEY(owner_id,user_id),
	FOREIGN KEY (approval_status) REFERENCES status_definition(status_id)
)ENGINE=INNODB;

CREATE TABLE bank.transaction_types
(
		type_id INT PRIMARY KEY,
		name VARCHAR(20)
) ENGINE=INNODB;

insert into bank.transaction_types values(1,'Credit');
insert into bank.transaction_types values(2,'Debit');
insert into bank.transaction_types values(3,'Transfer');
insert into bank.transaction_types values(4,'Payment');
insert into bank.transaction_types values(5,'Credit Card');

CREATE TABLE bank.transaction_status
(
		status_id INT PRIMARY KEY,
		name VARCHAR(40)
) ENGINE=INNODB;

insert into bank.transaction_status values(1,'Need To Specify Account');
insert into bank.transaction_status values(2,'Need Receiver Approval');
insert into bank.transaction_status values(3,'Need Internal User Approval');
insert into bank.transaction_status values(4,'DECLINED By Receiver');
insert into bank.transaction_status values(5,'DECLINED By Internal User');
insert into bank.transaction_status values(6,'Not Sufficient Funds');
insert into bank.transaction_status values(7,'Approved');
insert into bank.transaction_status values(8,'Avail Credit Payment');
insert into bank.transaction_status values(9,'Make Credit Payment');

CREATE TABLE bank.transactions
                 ( 
                              transaction_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
                              accountFrom  INT NULL REFERENCES account(account_id), 
                              accountTo  INT NULL REFERENCES account(account_id),
                              amount INT NOT NULL,
                              receiver_id INT NULL,
                              type_id INT NOT NULL,
			                  status_id INT NOT NULL,
                              FOREIGN KEY (type_id) REFERENCES bank.transaction_types(type_id),
                              FOREIGN KEY (status_id) REFERENCES bank.transaction_status(status_id)
                 ) ENGINE=INNODB;

CREATE TABLE bank.credit_card
(
	card_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	cvv INT NOT NULL,
	exp_date BIGINT NOT NULL,
	credit_limit INT NOT NULL,
	account_id INT UNIQUE,
	FOREIGN KEY(account_id) REFERENCES account(account_id) ON DELETE CASCADE
)ENGINE=INNODB;