const express = require('express');
const router = express.Router();
const UserController = require('../controllers/UserController');

router.get('/categories', UserController.getAllCategories);
router.get('/categories/:categoryId/products', UserController.getAllProducts);
router.get('/products/search', UserController.getProductsBySearch);
router.post('/order/new', UserController.createOrder);
router.get('/email', UserController.sendEmail);

module.exports = router;
