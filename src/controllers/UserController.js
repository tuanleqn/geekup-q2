const UserService = require('../services/UserService');
const path = require('path');
const fs = require('fs');

class UserController {
    getAllCategories = async (req, res) => {
        try {
            const categories = await UserService.getAllCategories();
            res.status(200).json(categories);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    };
    getAllProducts = async (req, res) => {
        try {
            const { categoryId } = req.params;
            const products = await UserService.getAllProducts(categoryId);
            res.status(200).json(products);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    };

    getProductsBySearch = async (req, res) => {
        try {
            const { filters } = req.query;
            const products = await UserService.searchProducts(filters);
            res.status(200).json(products);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    };
    createOrder = async (req, res) => {
        try {
            const order = await UserService.createOrder(req.body);
            res.status(201).json(order);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    };
    sendEmail = async (req, res) => {
        try {
            const email = await UserService.sendEmail(req.body);
            res.status(200).json(email);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    };
}

module.exports = new UserController();
