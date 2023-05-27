-- User
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`User` (
  `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(50) NOT NULL,
  `Fname` VARCHAR(45) NOT NULL,
  `Lname` VARCHAR(45) NULL DEFAULT '\\N',
  `role`  ENUM('Customer','Seller','Admin') NOT NULL DEFAULT 'Customer',
  `birth_date` DATE NOT NULL,
  `balance` DECIMAL(65,2) NULL DEFAULT 0.00,
  `user_type` ENUM('Local','Non-Local') NOT NULL DEFAULT 'Local',
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  PRIMARY KEY (`user_id`)
)
ENGINE = InnoDB;

-- Local user
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Local` (
  `user_id` INT UNSIGNED NOT NULL,
  `password` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  CONSTRAINT `local_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `PurchaseoDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Non_local user
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Non_local` (
  `user_id` INT UNSIGNED NOT NULL,
  `social_type` VARCHAR(45) NOT NULL,
  `social_id` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  CONSTRAINT `non_local_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `PurchaseoDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Admin
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Admin` (
  `admin_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE INDEX `admin_id_UNIQUE` (`admin_id` ASC) VISIBLE,
  CONSTRAINT `admin_id`
    FOREIGN KEY (`admin_id`)
    REFERENCES `PurchaseoDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Permission
CREATE TABLE `PurchaseoDB`.`Permission` (
  `admin_id` INT UNSIGNED NOT NULL,
  `permission` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`admin_id`,`permission`),
  CONSTRAINT `admin_permission`
    FOREIGN KEY (`admin_id`)
    REFERENCES `purchaseodb`.`admin` (`admin_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Administrator
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`administrator` (
  `administrator_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`administrator_id`),
  UNIQUE INDEX `administrator_id_UNIQUE` (`administrator_id` ASC) VISIBLE,
  CONSTRAINT `adminstrator_admin`
    FOREIGN KEY (`administrator_id`)
    REFERENCES `PurchaseoDB`.`Admin` (`admin_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Customer
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Customer` (
  `customer_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE INDEX `customer_id_UNIQUE` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `PurchaseoDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Seller
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Seller` (
  `seller_id` INT UNSIGNED NOT NULL,
  `national_id` VARCHAR(50) NOT NULL,
  `expire_month` INT(2) NOT NULL,
  `expire_year` INT(4) NOT NULL,
  `business_location` VARCHAR(50) NOT NULL,
  `country_of_issue` VARCHAR(50) NOT NULL,
  `country_of_citizenship` VARCHAR(50) NOT NULL,
  `country_of_birth` VARCHAR(50) NOT NULL,
  `business_name` VARCHAR(50) NOT NULL,
  `business_type` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`seller_id`),
  UNIQUE INDEX `seller_id_UNIQUE` (`seller_id` ASC) VISIBLE,
  UNIQUE INDEX `national_id_UNIQUE` (`national_id` ASC) VISIBLE,
  CONSTRAINT `seller_user`
    FOREIGN KEY (`seller_id`)
    REFERENCES `PurchaseoDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Product
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Product` (
  `product_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `approved_by` INT UNSIGNED NULL,
  `added_by` INT UNSIGNED NOT NULL,
  `price` DECIMAL(65,2)  NOT NULL DEFAULT 0,
  `description` VARCHAR(255) NULL DEFAULT '\\N',
  `rating` DOUBLE  NULL DEFAULT 0.0,
  `approval_status` ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
  `product_name` VARCHAR(255) NOT NULL,
  `discount` DOUBLE NULL DEFAULT 0,
  `inventory` INT  NULL DEFAULT 0,
  `brand` VARCHAR(255) NULL DEFAULT '\\N',
  `approve_date` DATETIME NULL,
  PRIMARY KEY (`product_id`),
  UNIQUE INDEX `product_id_UNIQUE` (`product_id` ASC) VISIBLE,
  INDEX `product_idx1` (`added_by` ASC) VISIBLE,
  INDEX `admin_product_idx` (`approved_by` ASC) VISIBLE,
  CONSTRAINT `seller_product`
    FOREIGN KEY (`added_by`)
    REFERENCES `PurchaseoDB`.`Seller` (`seller_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `admin_product`
    FOREIGN KEY (`approved_by`)
    REFERENCES `PurchaseoDB`.`administrator` (`administrator_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Image
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Image` (
  `image_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NULL,
  `file_path` VARCHAR(255) NOT NULL,
  `user_id` INT UNSIGNED NULL ,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`image_id`),
  UNIQUE INDEX `file_path_UNIQUE` (`file_path` ASC) VISIBLE,
  INDEX `product_image_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `product_image`
    FOREIGN KEY (`product_id`)
    REFERENCES `PurchaseoDB`.`Product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `image_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `PurchaseoDB`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = InnoDB;



-- Wish
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Wish` (
  `customer_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`customer_id`, `product_id`),
  INDEX `product_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `customer_wish`
    FOREIGN KEY (`customer_id`)
    REFERENCES `PurchaseoDB`.`Customer` (`customer_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `product_wish`
    FOREIGN KEY (`product_id`)
    REFERENCES `PurchaseoDB`.`Product` (`product_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Cart
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Cart` (
  `customer_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `quantity` INT UNSIGNED NULL DEFAULT 1,
  PRIMARY KEY (`customer_id`, `product_id`),
  INDEX `product_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `customer_cart`
    FOREIGN KEY (`customer_id`)
    REFERENCES `PurchaseoDB`.`Customer` (`customer_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `product`
    FOREIGN KEY (`product_id`)
    REFERENCES `PurchaseoDB`.`Product` (`product_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;



-- Review
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Review` (
  `product_id` INT UNSIGNED NOT NULL,
  `customer_id` INT UNSIGNED NOT NULL,
  `body` VARCHAR(225) NULL DEFAULT '\\N',
  `rate` DOUBLE  NULL,
  `date` DATETIME NOT NULL,
  PRIMARY KEY (`product_id`, `customer_id`),
  INDEX `product_idx` (`product_id` ASC) VISIBLE,
  INDEX `customer_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `product_review`
    FOREIGN KEY (`product_id`)
    REFERENCES `PurchaseoDB`.`Product` (`product_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `customer_review`
    FOREIGN KEY (`customer_id`)
    REFERENCES `PurchaseoDB`.`Customer` (`customer_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Address
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Address` (
  `user_id` INT UNSIGNED NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `apartment` INT UNSIGNED NOT NULL,
  `country` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `zip_code` INT UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`user_id`, `street`, `apartment`),
  CONSTRAINT `address`
    FOREIGN KEY (`user_id`)
    REFERENCES `PurchaseoDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Basket
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Basket` (
  `product_id` INT UNSIGNED NOT NULL,
  `seller_id` INT UNSIGNED NOT NULL,
  `quantity` INT UNSIGNED NULL DEFAULT 0,
  `sold_quantity` INT UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`product_id`),
  UNIQUE INDEX `product_id_UNIQUE` (`product_id` ASC) VISIBLE,
  INDEX `basket_seller_idx` (`seller_id` ASC) VISIBLE,
  CONSTRAINT `basket_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `PurchaseoDB`.`Product` (`product_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `basket_seller`
    FOREIGN KEY (`seller_id`)
    REFERENCES `PurchaseoDB`.`Seller` (`seller_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Category
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Category` (
  `category_name` VARCHAR(30) NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`category_name`, `product_id`),
  INDEX `product_category_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `product_category`
    FOREIGN KEY (`product_id`)
    REFERENCES `PurchaseoDB`.`Product` (`product_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Company
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Company` (
  `company_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(50) NULL DEFAULT '\\N',
  `name` VARCHAR(50) NOT NULL,
  `website` VARCHAR(50) NULL DEFAULT '\\N',
  `contact_person` VARCHAR(45) NOT NULL,
  `phone_number` VARCHAR(15) NOT NULL,
  `country` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `street` VARCHAR(45) NULL DEFAULT '\\N',
  `zip_code` INT UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`company_id`),
  UNIQUE INDEX `company_id_UNIQUE` (`company_id` ASC) VISIBLE)
ENGINE = InnoDB;

-- Shipping
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Shipping` (
  `shipping_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`shipping_id`),
  UNIQUE INDEX `shipping_id_UNIQUE` (`shipping_id` ASC) VISIBLE,
  CONSTRAINT `shipping_company`
    FOREIGN KEY (`shipping_id`)
    REFERENCES `PurchaseoDB`.`Company` (`company_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Consumer
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Consumer` (
  `consumer_id` INT UNSIGNED NOT NULL,
  `balance` DECIMAL(65,2) NULL DEFAULT 0.00,
  PRIMARY KEY (`consumer_id`),
  UNIQUE INDEX `consumer_id_UNIQUE` (`consumer_id` ASC) VISIBLE,
  CONSTRAINT `consumer_company`
    FOREIGN KEY (`consumer_id`)
    REFERENCES `PurchaseoDB`.`Company` (`company_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Contract
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Contract` (
  `contract_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `consumer_id` INT UNSIGNED UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `contract_end_date` DATETIME NOT NULL,
  `contract_start_date` DATETIME NOT NULL,
  `deal_quantity` INT UNSIGNED NOT NULL,
  `deal_price` DECIMAL(65,2) NOT NULL,
  `contract_type` VARCHAR(45) NULL DEFAULT '\\N',
  `renew_status` ENUM('Renewed', 'Not Renewed') NOT NULL DEFAULT 'Not Renewed',
  `renew_date` DATETIME NULL,
  PRIMARY KEY (`contract_id`),
  UNIQUE INDEX `contract_id_UNIQUE` (`contract_id` ASC) VISIBLE,
  INDEX `consumer_contract_idx` (`consumer_id` ASC) VISIBLE,
  INDEX `product_contract_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `consumer_contract`
    FOREIGN KEY (`consumer_id`)
    REFERENCES `PurchaseoDB`.`Consumer` (`consumer_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `product_contract`
    FOREIGN KEY (`product_id`)
    REFERENCES `PurchaseoDB`.`Product` (`product_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
--   CONSTRAINT `contract_end_date_check`
--     CHECK (`contract_end_date` < NOW())
)
ENGINE = InnoDB;

-- Company_order
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`company_order` (
  `order_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `consumer_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `time` DATETIME NOT NULL,
  `quantity` INT UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`order_id`),
  UNIQUE INDEX `order_id_UNIQUE` (`order_id` ASC) VISIBLE,
  INDEX `consumer_order_idx` (`consumer_id` ASC) VISIBLE,
  INDEX `product_order_company_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `consumer_order`
    FOREIGN KEY (`consumer_id`)
    REFERENCES `PurchaseoDB`.`Consumer` (`consumer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `product_order_company`
    FOREIGN KEY (`product_id`)
    REFERENCES `PurchaseoDB`.`Product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Payment_card
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Payment_card` (
  `card_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` INT UNSIGNED NOT NULL,
  `card_holder_name` VARCHAR(45) NULL DEFAULT '\\N',
  `cvc` INT(3) UNSIGNED NULL DEFAULT 0,
  `year` INT(4) NOT NULL,
  `month` INT(2) NOT NULL,
  PRIMARY KEY (`card_id`),
  INDEX `customer_card_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `customer_card`
    FOREIGN KEY (`customer_id`)
    REFERENCES `PurchaseoDB`.`Customer` (`customer_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Customer_order
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Customer_order` (
  `order_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` INT UNSIGNED NOT NULL,
  `done_by_card` INT UNSIGNED NOT NULL,
  `total_price` DECIMAL(65,2) NULL DEFAULT 0.00,
  PRIMARY KEY (`order_id`),
  UNIQUE INDEX `order_id_UNIQUE` (`order_id` ASC) VISIBLE,
  INDEX `cusomer_oder_idx` (`customer_id` ASC) VISIBLE,
  INDEX `card_order_idx` (`done_by_card` ASC) VISIBLE,
  CONSTRAINT `cusomer_oder`
    FOREIGN KEY (`customer_id`)
    REFERENCES `PurchaseoDB`.`Customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `card_order`
    FOREIGN KEY (`done_by_card`)
    REFERENCES `PurchaseoDB`.`Payment_card` (`card_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Deliver
CREATE TABLE IF NOT EXISTS `PurchaseoDB`.`Deliver` (
  `order_id` INT UNSIGNED NOT NULL,
  `shipping_id` INT UNSIGNED NOT NULL,
  `received_date` DATETIME NULL,
  `delivered_date` DATETIME NULL,
  `deliver_status` ENUM('pending', 'shipped', 'delivered', 'returned', 'cancelled') NULL DEFAULT 'pending',
  PRIMARY KEY (`order_id`),
  INDEX `shipping_deliver_idx` (`shipping_id` ASC) VISIBLE,
  CONSTRAINT `shipping_deliver`
    FOREIGN KEY (`shipping_id`)
    REFERENCES `PurchaseoDB`.`Shipping` (`shipping_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;