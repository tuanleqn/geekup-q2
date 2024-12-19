-- b) Insert Query for "Assessment" Purchase

INSERT INTO
    ShippingAddress (
        province,
        district,
        commune,
        address
    )
VALUES (
        'Bắc Kạn',
        'Ba Bể',
        'Phúc Lộc',
        '73 tân hoà 2'
    );

SET @shipping_address_id = LAST_INSERT_ID();

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
        (
            SELECT id
            FROM User
            WHERE
                name = 'assessment'
        ),
        'Completed',
        0.00,
        (
            SELECT original_price * (1 - discount_percentage / 100)
            FROM Product
            WHERE
                name = "KAPPA Women's Sneakers"
        ),
        NULL,
        'Credit Card',
        @shipping_address_id,
        NOW()
    );

SET @order_id = LAST_INSERT_ID();

INSERT INTO
    OrderItem (
        order_id,
        product_id,
        quantity,
        price
    )
VALUES (
        @order_id,
        (
            SELECT id
            FROM Product
            WHERE
                name = "KAPPA Women's Sneakers"
        ),
        1,
        (
            SELECT original_price * (1 - discount_percentage / 100)
            FROM Product
            WHERE
                name = "KAPPA Women's Sneakers"
        )
    );

SET SQL_SAFE_UPDATES = 0;

UPDATE Product
SET
    quantity = quantity - 1
WHERE
    name = "KAPPA Women's Sneakers";

SET SQL_SAFE_UPDATES = 1;

-- c) Query to Calculate Average Order Value Per Month

SELECT
    MONTH(created_at) AS order_month,
    AVG(total_price) AS average_order_value
FROM `Order`
WHERE
    YEAR(created_at) = YEAR(CURDATE())
GROUP BY
    MONTH(created_at)
ORDER BY order_month;

-- d) Query to Calculate Customer Churn Rate

WITH
    PurchasesLast6Months AS (
        SELECT DISTINCT
            user_id
        FROM `Order`
        WHERE
            created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    ),
    Purchases6To12MonthsAgo AS (
        SELECT DISTINCT
            user_id
        FROM `Order`
        WHERE
            created_at BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 MONTH) AND DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    )
SELECT (
        COUNT(
            DISTINCT Purchases6To12MonthsAgo.user_id
        ) - COUNT(
            DISTINCT PurchasesLast6Months.user_id
        )
    ) * 100.0 / COUNT(
        DISTINCT Purchases6To12MonthsAgo.user_id
    ) AS churn_rate
FROM
    Purchases6To12MonthsAgo
    LEFT JOIN PurchasesLast6Months ON Purchases6To12MonthsAgo.user_id = PurchasesLast6Months.user_id;