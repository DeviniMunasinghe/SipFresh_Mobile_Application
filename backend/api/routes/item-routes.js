const express = require("express");
const itemController = require("../controllers/item-controller");
const { protect, adminOrSuperAdmin } = require("../middleware/auth-middleware");
const multer = require("multer");
const path = require("path");
const router = express.Router();

const menuPath = path.resolve(__dirname, "../../images/menu");
console.log("Saving to:", menuPath);

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, menuPath);
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + "-" + file.originalname);
  },
});

const upload = multer({ storage: storage });

router.use("/images/menu", express.static(menuPath));

router.post("/add-item", upload.single("item_image"), itemController.addItem);

//Fetch items by category
router.get("/category/:category_name", itemController.getItemsByCategory);

module.exports = router;
