DROP DATABASE IF EXISTS cash_register;

CREATE DATABASE cash_register;

USE cash_register;

DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS invoice_status;
DROP TABLE IF EXISTS paid_status;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS invoice_has_product;

CREATE TABLE user_role (
    id INT NOT NULL AUTO_INCREMENT,
    role_name VARCHAR(32) UNIQUE,
    PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE user (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(128) UNIQUE,
    password VARCHAR(128) UNIQUE,
    email VARCHAR(48) NOT NULL DEFAULT '',
    phone VARCHAR(32) NOT NULL DEFAULT '',
    address VARCHAR(128) NOT NULL DEFAULT '',
    role_id INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    FOREIGN KEY (role_id) REFERENCES user_role (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE product (
    id INT NOT NULL AUTO_INCREMENT,
    vendor_code VARCHAR(12) NOT NULL UNIQUE,
    is_available BIT(1) NOT NULL DEFAULT FALSE,
    name VARCHAR(128),
    description VARCHAR(255),
    price DOUBLE NOT NULL DEFAULT 0,
    amount INT NOT NULL DEFAULT 0,
    product_quantity DOUBLE NOT NULL DEFAULT 0,
    product_uom VARCHAR(32) NOT NULL,
    product_notes VARCHAR(255),
    PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE invoice_status (
    id INT NOT NULL AUTO_INCREMENT,
    status_description VARCHAR(32) UNIQUE,
    PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE paid_status (
    id INT NOT NULL AUTO_INCREMENT,
    paid_value VARCHAR(32) UNIQUE,
    PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE invoice (
    id INT NOT NULL AUTO_INCREMENT,
    invoice_code BIGINT UNIQUE NOT NULL,
    user_name VARCHAR(128),
    paid_id INT NOT NULL DEFAULT 0,
    status_id INT NOT NULL,
    invoice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    invoice_notes VARCHAR(255),
    PRIMARY KEY (id),
    FOREIGN KEY (user_name) REFERENCES user (name)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    FOREIGN KEY (paid_id) REFERENCES paid_status(id),
    FOREIGN KEY (status_id) REFERENCES invoice_status(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE payment (
    id INT NOT NULL AUTO_INCREMENT,
    invoice_code BIGINT NOT NULL,
    payment_value DOUBLE NOT NULL DEFAULT 0,
    status_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (invoice_code) REFERENCES invoice(invoice_code)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (status_id) REFERENCES invoice(status_id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE invoice_has_product (
    invoice_id INT NOT NULL,
    product_id INT NOT NULL,
    vendor_code VARCHAR(12) NOT NULL,
    amount INT NOT NULL DEFAULT 0,
    quantity DOUBLE NOT NULL DEFAULT 0,
    PRIMARY KEY (invoice_id, product_id),
    FOREIGN KEY (invoice_id) REFERENCES invoice(id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (product_id) REFERENCES product (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (vendor_code) REFERENCES product(vendor_code)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;