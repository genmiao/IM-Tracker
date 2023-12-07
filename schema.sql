CREATE TABLE 'users' (
    'user_id' int unsigned NOT NULL AUTO_INCREMENT,
    'user_username' varchar(200) NOT NULL DEFAULT '',
    'user_password' varchar(200) NOT NULL DEFAULT '',
    PRIMARY KEY ('user_id')
)   ENGINE=InnoDB;

CREATE TABLE 'categories' (
    'cat_id' int unsigned NOT NULL AUTO_INCREMENT,
    'cat_username' varchar(200) NOT NULL DEFAULT '',
    PRIMARY KEY ('cat_id')
)   ENGINE=InnoDB;

CREATE TABLE 'transactions' (
    'trans_id' int unsigned NOT NULL AUTO_INCREMENT,
    'user_id' INT REFERENCES users(user_id) ON DELETE CASCADE,
    'cat_id' INT REFERENCES categories(cat_id) ON DELETE SET NULL,
    'amount' DECIMAL(10, 2) NOT NULL,
    'description' VARCHAR(255),
    'trans_date' DATE NOT NULL,
    'created_at' TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    PRIMARY KEY ('trans_id')
)   ENGINE=InnoDB;

-- Creating a VIEW for transactions
CREATE VIEW get_transactions AS
SELECT
    t.trans_id,
    t.user_id,
    u.user_username AS user_username,
    t.cat_id,
    c.cat_username AS cat_username,
    t.amount,
    t.description,
    t.trans_date,
    t.created_at
FROM transactions t
INNER JOIN users u ON t.user_id = u.user_id
LEFT JOIN categories c ON t.cat_id = c.cat_id;

-- Creating a PROCEDURE for creating transactions
DELIMITER $$
CREATE PROCEDURE create_transaction(
    IN p_user_id INT,
    IN p_cat_id INT,
    IN p_amount DECIMAL(10, 2),
    IN p_description VARCHAR(255),
    IN p_trans_date DATE
)
BEGIN
    INSERT INTO transactions(user_id, cat_id, amount, description, trans_date) 
    VALUES (p_user_id, p_cat_id, p_amount, p_description, p_trans_date);
    SELECT LAST_INSERT_ID() AS trans_id;
END$$
DELIMITER ;

-- Creating a PROCEDURE for updating transactions
DELIMITER $$
CREATE PROCEDURE update_transaction(
    IN p_trans_id INT,
    IN p_user_id INT,
    IN p_cat_id INT,
    IN p_amount DECIMAL(10, 2),
    IN p_description VARCHAR(255),
    IN p_trans_date DATE
)
BEGIN
    UPDATE transactions 
    SET user_id = p_user_id,
        cat_id = p_cat_id,
        amount = p_amount,
        description = p_description,
        trans_date = p_trans_date
    WHERE trans_id = p_trans_id;
    SELECT p_trans_id AS trans_id;
END$$
DELIMITER ;

-- Creating a PROCEDURE for deleting transactions
DELIMITER $$
CREATE PROCEDURE delete_transaction(IN p_trans_id INT)
BEGIN
    DELETE FROM transactions WHERE trans_id = p_trans_id;
    SELECT p_trans_id AS trans_id;
END$$
DELIMITER ;


