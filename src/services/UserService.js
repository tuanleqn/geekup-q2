const db = require('../config/db.js');

class UserService {
    getAllCategories = async () => {
        try {
            const [rows] = await db.query('SELECT * FROM Category');
            return rows;
        } catch (error) {
            throw error;
        }
    };
    getAllProducts = async (categoryId) => {
        try {
            const [rows] = await db.query('SELECT * FROM Product WHERE category_id = ?', [categoryId]);
            return rows;
        } catch (error) {
            throw error;
        }
    };
    searchProducts = async (filters) => {
        try {
            const {
                searchTerm,
                categoryId,
                brandId,
                priceMin,
                priceMax,
                size,
                color,
                sex,
                sortBy = 'name',
                order = 'asc',
            } = filters;

            let query = `
            SELECT 
              p.id, p.name, p.description, 
              (p.original_price * (1 - p.discount_percentage / 100)) AS price, 
              c.name AS category, b.name AS brand, 
              GROUP_CONCAT(DISTINCT col.color) AS colors,
              GROUP_CONCAT(DISTINCT s.size) AS sizes,
              p.sex 
            FROM Product p
            LEFT JOIN Category c ON p.category_id = c.id
            LEFT JOIN Brand b ON p.brand_id = b.id
            LEFT JOIN Color col ON p.id = col.product_id
            LEFT JOIN Size s ON p.id = s.product_id
            WHERE 1=1
          `;

            const params = [];

            if (searchTerm) {
                query += ' AND (p.name LIKE ? OR p.description LIKE ?)';
                params.push(`%${searchTerm}%`, `%${searchTerm}%`);
            }
            if (categoryId) {
                query += ' AND p.category_id = ?';
                params.push(categoryId);
            }
            if (brandId) {
                query += ' AND p.brand_id = ?';
                params.push(brandId);
            }
            if (priceMin) {
                query += ' AND (p.original_price * (1 - p.discount_percentage / 100)) >= ?';
                params.push(priceMin);
            }
            if (priceMax) {
                query += ' AND (p.original_price * (1 - p.discount_percentage / 100)) <= ?';
                params.push(priceMax);
            }
            if (size) {
                query += ' AND s.size = ?';
                params.push(size);
            }
            if (color) {
                query += ' AND col.color = ?';
                params.push(color);
            }
            if (sex) {
                query += ' AND p.sex = ?';
                params.push(sex);
            }

            query += ` GROUP BY p.id ORDER BY ${db.escapeId(sortBy)} ${order === 'desc' ? 'DESC' : 'ASC'}`;

            const [results] = await db.query(query, params);
            return results;
        } catch (error) {
            throw error;
        }
    };

    createOrder = async (orderData) => {
        const { userId, items, shippingAddress, paymentMethod } = orderData;

        if (!userId || !items || !items.length || !shippingAddress || !paymentMethod) {
            return { success: false, message: 'Invalid order data' };
        }

        try {
            await db.beginTransaction();

            const [addressResult] = await db.query(
                `INSERT INTO ShippingAddress (province, district, commune, address) VALUES (?, ?, ?, ?)`,
                [shippingAddress.province, shippingAddress.district, shippingAddress.commune, shippingAddress.address],
            );
            const shippingAddressId = addressResult.insertId;

            const [orderResult] = await db.query(
                `INSERT INTO \`Order\` (user_id, status, shipping_fee, total_price, payment_method, shipping_address_id) VALUES (?, ?, ?, ?, ?, ?)`,
                [userId, 'Pending', 5.99, 0, paymentMethod, shippingAddressId],
            );
            const orderId = orderResult.insertId;

            let totalPrice = 0;
            for (const item of items) {
                const { productId, quantity } = item;

                const [[product]] = await db.query(
                    `SELECT (original_price * (1 - discount_percentage / 100)) AS price FROM Product WHERE id = ?`,
                    [productId],
                );

                if (!product) {
                    throw new Error(`Product with ID ${productId} not found`);
                }

                const itemPrice = product.price * quantity;
                totalPrice += itemPrice;

                await db.query(`INSERT INTO OrderItem (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)`, [
                    orderId,
                    productId,
                    quantity,
                    itemPrice,
                ]);
            }
            await db.commit();

            return { success: true, orderId };
        } catch (error) {
            await db.rollback();
            return { success: false, message: error.message };
        }
    };
    sendEmail = async (emailData) => {
        return { success: true };
    };
}

module.exports = new UserService();
