const express = require("express");
const orderController = require("../controllers/order-controller");
const { protect, adminOrSuperAdmin } = require("../middleware/auth-middleware");
const router = express.Router();

// Route to transfer selected items to checkout
router.post(
  "/checkout/transfer-selected",
  protect,
  orderController.transferSelectedItemsToCheckout
);

//route to fetch selected items in checkout
router.get(
  "/checkout/selected-items",
  protect,
  orderController.getSelectedItemsInCheckout
);

// Route to remove items from checkout
router.post(
  "/checkout/remove-items-from-checkout/:selectedCartItemId",
  protect,
  orderController.removeItemsFromCheckout
);

module.exports = router;
