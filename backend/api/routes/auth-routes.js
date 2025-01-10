const express = require("express");
const authController = require("../controllers/auth-controller");

const router = express.Router(); 

//User registration
router.post("/register", authController.register);

module.exports = router;
