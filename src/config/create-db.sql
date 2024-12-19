DROP DATABASE IF EXISTS ecommerce;

CREATE DATABASE ecommerce;

USE ecommerce;

CREATE TABLE User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50),
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    province VARCHAR(100),
    district VARCHAR(100),
    commune VARCHAR(100),
    address TEXT,
    housing_type VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50),
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE Category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image TEXT
);

CREATE TABLE Brand (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE Product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    model VARCHAR(100),
    brand_id INT,
    sex VARCHAR(10),
    original_price DECIMAL(10, 2),
    discount_percentage DECIMAL(5, 2),
    quantity INT,
    FOREIGN KEY (category_id) REFERENCES Category (id),
    FOREIGN KEY (brand_id) REFERENCES Brand (id)
);

CREATE TABLE Color (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    color VARCHAR(50),
    FOREIGN KEY (product_id) REFERENCES Product (id)
);

CREATE TABLE Size (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    size INT,
    FOREIGN KEY (product_id) REFERENCES Product (id)
);

CREATE TABLE Store (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    province VARCHAR(100),
    district VARCHAR(100),
    commune VARCHAR(100),
    address TEXT
);

CREATE TABLE Has (
    product_id INT NOT NULL,
    store_id INT NOT NULL,
    PRIMARY KEY (product_id, store_id),
    FOREIGN KEY (product_id) REFERENCES Product (id),
    FOREIGN KEY (store_id) REFERENCES Store (id)
);

CREATE TABLE ShippingAddress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    province VARCHAR(100),
    district VARCHAR(100),
    commune VARCHAR(100),
    address TEXT
);

CREATE TABLE `Order` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    status VARCHAR(50),
    shipping_fee DECIMAL(10, 2),
    total_price DECIMAL(10, 2),
    coupon VARCHAR(50),
    payment_method VARCHAR(50),
    shipping_address_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    canceled_at DATETIME,
    completed_at DATETIME,
    delivery_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES User (id),
    FOREIGN KEY (shipping_address_id) REFERENCES ShippingAddress (id)
);

CREATE TABLE OrderItem (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES `Order` (id),
    FOREIGN KEY (product_id) REFERENCES Product (id)
);

-- Add data into tables
INSERT INTO
    User (
        password,
        role,
        name,
        email,
        phone,
        province,
        district,
        commune,
        address,
        housing_type
    )
VALUES (
        'password123',
        'user',
        'John Doe',
        'john@example.com',
        '1234567890',
        'California',
        'Los Angeles',
        'Downtown',
        '123 Main St',
        'Công ty'
    ),
    (
        'password456',
        'user',
        'Jane Smith',
        'jane@example.com',
        '0987654321',
        'New York',
        'Manhattan',
        'Midtown',
        '456 Broadway St',
        'Nhà riêng'
    ),
    (
        'password789',
        'user',
        'assessment',
        'gu@gmail.com',
        '328355333',
        'Bắc Kạn',
        'Ba Bể',
        'Phúc Lộc',
        '73 tân hoà 2',
        'Nhà riêng'
    );

INSERT INTO
    Admin (password, role, name, email)
VALUES (
        'adminpass123',
        'admin',
        'Alice Admin',
        'admin@example.com'
    );

INSERT INTO
    Category (name, description, image)
VALUES (
        'Electronics',
        'Devices and gadgets',
        'electronics.jpg'
    ),
    (
        'Clothing',
        'Apparel for men and women',
        'clothing.jpg'
    ),
    (
        'Sneaker',
        'Sneaker for men and women',
        'sneaker.png'
    );

INSERT INTO
    Brand (name, description)
VALUES (
        'Apple',
        'High-quality electronics'
    ),
    (
        'Nike',
        'Leading sportswear brand'
    );

INSERT INTO
    Product (
        category_id,
        name,
        description,
        model,
        brand_id,
        sex,
        original_price,
        discount_percentage,
        quantity
    )
VALUES (
        1,
        'iPhone 14',
        'Latest smartphone by Apple',
        'A2890',
        1,
        'Unisex',
        999.99,
        10.0,
        50
    ),
    (
        2,
        'Nike Air Max',
        'Comfortable running shoes',
        'N120',
        2,
        'Male',
        199.99,
        15.0,
        100
    ),
    (
        2,
        "KAPPA Women's Sneakers",
        'Comfortable running shoes for women',
        'K120',
        '2',
        'Female',
        980000,
        0.0,
        100
    );

INSERT INTO
    Color (product_id, color)
VALUES (1, 'Black'),
    (1, 'White'),
    (2, 'Red'),
    (2, 'Blue'),
    (3, 'Yellow');

INSERT INTO
    Size (product_id, size)
VALUES (2, 38),
    (2, 37),
    (3, 36);

INSERT INTO
    Store (
        name,
        province,
        district,
        commune,
        address
    )
VALUES (
        'TechStore',
        'California',
        'Los Angeles',
        'Downtown',
        '789 Market St'
    ),
    (
        'SportsShop',
        'New York',
        'Manhattan',
        'Midtown',
        '101 Park Ave'
    );

INSERT INTO Has (product_id, store_id) VALUES (1, 1), (2, 2);

INSERT INTO
    ShippingAddress (
        province,
        district,
        commune,
        address
    )
VALUES (
        'California',
        'Los Angeles',
        'Downtown',
        '123 Main St'
    ),
    (
        'New York',
        'Manhattan',
        'Midtown',
        '456 Broadway St'
    );

INSERT INTO
    `Order` (
        user_id,
        status,
        shipping_fee,
        total_price,
        coupon,
        payment_method,
        shipping_address_id,
        created_at
    )
VALUES (
        1,
        'Pending',
        5.99,
        1005.98,
        'DISCOUNT10',
        'Credit Card',
        1,
        NOW()
    ),
    (
        2,
        'Completed',
        0.00,
        199.99,
        NULL,
        'PayPal',
        2,
        NOW()
    ),
    (
        1,
        'Completed',
        5.99,
        1050.00,
        'SUMMER21',
        'Credit Card',
        1,
        DATE_SUB(CURDATE(), INTERVAL 9 MONTH)
    ),
    (
        2,
        'Completed',
        3.50,
        500.00,
        NULL,
        'PayPal',
        2,
        DATE_SUB(CURDATE(), INTERVAL 10 MONTH)
    ),
    (
        3,
        'Completed',
        4.99,
        300.00,
        'WELCOME',
        'Cash',
        1,
        DATE_SUB(CURDATE(), INTERVAL 11 MONTH)
    ),
    (
        1,
        'Completed',
        5.99,
        999.99,
        'DISCOUNT20',
        'Credit Card',
        1,
        DATE_SUB(CURDATE(), INTERVAL 2 MONTH)
    ),
    (
        3,
        'Completed',
        3.99,
        199.99,
        NULL,
        'Cash',
        1,
        DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    );

INSERT INTO
    OrderItem (
        order_id,
        product_id,
        quantity,
        price
    )
VALUES (1, 1, 1, 999.99),
    (1, 2, 1, 199.99),
    (2, 2, 1, 199.99);