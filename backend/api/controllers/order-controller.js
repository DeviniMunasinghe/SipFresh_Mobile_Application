const db = require("../../config/db");

exports.transferSelectedItemsToCheckout = async (req, res) => {
  const { selectedCartItemIds } = req.body;
  const userId = req.user.user_id;

  console.log("Incoming request body:", req.body);
  console.log("User ID:", userId);

  if (!Array.isArray(selectedCartItemIds) || selectedCartItemIds.length === 0) {
    return res.status(400).json({ error: "No items selected for checkout" });
  }

  console.log("Selected Cart Item IDs:", selectedCartItemIds);

  try {
    const placeholders = selectedCartItemIds.map(() => "?").join(",");
    const query = `
  UPDATE cart_items
  SET selected = 1
  WHERE cart_item_id IN (${placeholders})
  AND cart_id IN (SELECT cart_id FROM cart WHERE user_id = ?)
`;
    console.log("Executing query to update selected items:", query, [
      ...selectedCartItemIds,
      userId,
    ]);
    await db.execute(query, [...selectedCartItemIds, userId]);

    // Fetch selected items
    const [selectedItems] = await db.execute(
      `SELECT ci.cart_item_id, ci.quantity, itm.item_id, itm.item_name, itm.item_price
       FROM cart_items ci 
       JOIN cart c ON ci.cart_id = c.cart_id 
       JOIN item itm ON ci.item_id = itm.item_id 
       WHERE ci.selected = 1  AND c.user_id = ? AND ci.is_deleted = 0`,
      [userId]
    );

    console.log("Selected Items Retrieved:", selectedItems);

    if (selectedItems.length === 0) {
      console.log("No items found for the provided IDs.");
      return res.status(404).json({
        error: "Selected items not found in the cart or have been deleted.",
      });
    }

    return res.status(200).json({ items: selectedItems });
  } catch (error) {
    console.error(
      "Error while transferring selected items to checkout:",
      error
    );
    return res
      .status(500)
      .json({ error: "Failed to transfer selected items to checkout" });
  }
};

// Fetch selected items in checkout
exports.getSelectedItemsInCheckout = async (req, res) => {
  const userId = req.user.user_id;
  try {
    const [selectedItems] = await db.execute(
      `SELECT ci.*, itm.item_name, itm.item_price, itm.item_image 
       FROM cart_items ci 
       JOIN cart c ON ci.cart_id = c.cart_id 
       JOIN item itm ON ci.item_id = itm.item_id 
       WHERE c.user_id = ? AND ci.is_deleted = 0 AND ci.selected = 1`,
      [userId]
    );

    if (selectedItems.length === 0) {
      return res
        .status(404)
        .json({ error: "No selected items found in checkout." });
    }

    res.json({ items: selectedItems });
  } catch (error) {
    console.error("Error fetching selected items in checkout:", error);
    res.status(500).json({ error: "Failed to fetch selected items." });
  }
};

// Remove selected items from checkout and return them to the cart as unselected
exports.removeItemsFromCheckout = async (req, res) => {
  const selectedCartItemId = req.params.selectedCartItemId;

  const userId = req.user.user_id;

  // Validate input
  if (!selectedCartItemId) {
    return res
      .status(400)
      .json({ message: "No item provided for removal from checkout." });
  }

  try {
    console.log(
      "Removing item from checkout:",
      selectedCartItemId,
      "for user ID:",
      userId
    );

    // Update the `selected` status of the items to `0` (unselected)
    const query = `
      UPDATE cart_items
      SET selected = 0
      WHERE cart_item_id =?
        AND cart_id IN (SELECT cart_id FROM cart WHERE user_id = ?)
        AND selected = 1
    `;

    const [result] = await db.execute(query, [selectedCartItemId, userId]);

    // Check if any rows were affected (i.e., items were actually updated)
    if (result.affectedRows === 0) {
      return res
        .status(404)
        .json({ message: "No selected items found for removal." });
    }

    // Respond with a success message
    console.log("Item removed from checkout and marked as unselected.");
    res.status(200).json({
      message:
        "Items successfully removed from checkout and marked as unselected.",
    });
  } catch (error) {
    console.error("Error while removing items from checkout:", error.message);
    res.status(500).json({
      message: "Failed to remove items from checkout.",
      error: error.message,
    });
  }
};

// Calculate order summary for selected items in the cart
exports.calculateOrderSummary = async (selectedCartItemIds) => {
  if (
    !selectedCartItemIds ||
    !Array.isArray(selectedCartItemIds) ||
    selectedCartItemIds.length === 0
  ) {
    throw new Error("Invalid or missing 'selectedCartItemIds'");
  }

  if (!Array.isArray(selectedCartItemIds) || selectedCartItemIds.length === 0) {
    console.log("No items selected condition triggered.");
    return res.status(400).json({ error: "No items selected" });
  }

  try {
    const placeholders = selectedCartItemIds.map(() => "?").join(",");
    const [selectedItems] = await db.execute(
      `SELECT ci.quantity, itm.item_price, itm.item_name
       FROM cart_items ci
       JOIN item itm ON ci.item_id = itm.item_id
       WHERE ci.cart_item_id IN (${placeholders}) AND ci.is_deleted = 0`,
      selectedCartItemIds
    );

    console.log("Selected items from database:", selectedItems);

    if (selectedItems.length === 0) {
      return res
        .status(404)
        .json({ error: "Selected items not found or already deleted" });
    }

    // Check for an active promotion
    const [promotion] = await db.execute(
      `SELECT pr.discount_percentage 
       FROM promotion p
       JOIN promotion_rule pr ON p.promotion_id = pr.promotion_id
       WHERE CURDATE() BETWEEN p.start_date AND p.end_date 
       LIMIT 1`
    );
    const discountPercentage = promotion.length
      ? promotion[0].discount_percentage
      : 0;

    let totalAmount = 0;
    let totalQuantity = 0;

    selectedItems.forEach((item) => {
      const quantity = item.quantity ?? 1; // Default to 1 if quantity is null
      const { item_price } = item;
      totalAmount += quantity * item_price;
      totalQuantity += quantity;
    });

    const discountAmount = (totalAmount * discountPercentage) / 100;
    const finalAmount = totalAmount - discountAmount;

    console.log("Calculated Order Summary:", {
      totalAmount,
      discountAmount,
      finalAmount,
    });

    return { totalAmount, discountAmount, finalAmount };
  } catch (err) {
    console.error("Error while calculating order summary:", err);
    res.status(500).json({ error: "Failed to calculate order summary" });
  }
};

// Get order summary for selected items (GET method)
exports.getOrderSummary = async (req, res) => {
  const { selectedCartItemIds } = req.query;
  console.log("Received selectedCartItemIds:", selectedCartItemIds);

  if (
    !selectedCartItemIds ||
    !Array.isArray(JSON.parse(selectedCartItemIds)) ||
    JSON.parse(selectedCartItemIds).length === 0
  ) {
    console.log("No items selected condition triggered.");
    return res.status(400).json({ error: "No items selected" });
  }

  try {
    const cartItemIds = JSON.parse(selectedCartItemIds);

    const placeholders = cartItemIds.map(() => "?").join(",");

    // Fetch selected items from the cart_items table, including item details from the items table
    const [selectedItems] = await db.execute(
      `SELECT ci.cart_item_id, ci.quantity, itm.item_price, itm.item_name
       FROM cart_items ci
       JOIN item itm ON ci.item_id = itm.item_id
       WHERE ci.cart_item_id IN (${placeholders}) AND ci.is_deleted = 0`,
      cartItemIds
    );

    console.log("Selected items from database:", selectedItems);

    if (selectedItems.length === 0) {
      return res
        .status(404)
        .json({ error: "Selected items not found or already deleted" });
    }

    // Check for any active promotion
    const [promotion] = await db.execute(
      `SELECT pr.discount_percentage 
       FROM promotion p
       JOIN promotion_rule pr ON p.promotion_id = pr.promotion_id
       WHERE CURDATE() BETWEEN p.start_date AND p.end_date 
       LIMIT 1`
    );

    // Set discount percentage (0 if no promotion is found)
    const discountPercentage = promotion.length
      ? promotion[0].discount_percentage
      : 0;

    let totalAmount = 0;
    let totalQuantity = 0;

    // Calculate the total amount, total quantity, and total discount
    selectedItems.forEach((item) => {
      const quantity = item.quantity ?? 1; // Default to 1 if quantity is null
      const { item_price } = item;
      totalAmount += quantity * item_price;
      totalQuantity += quantity;
    });

    // Calculate discount amount based on the totalAmount
    const discountAmount = (totalAmount * discountPercentage) / 100;
    const finalAmount = totalAmount - discountAmount;

    console.log("Calculated Order Summary:", {
      totalAmount,
      discountAmount,
      finalAmount,
    });

    // Send the calculated order summary as a response
    return res.json({
      totalAmount,
      discountAmount,
      finalAmount,
      totalQuantity,
    });
  } catch (err) {
    console.error("Error while calculating order summary:", err);
    return res.status(500).json({ error: "Failed to calculate order summary" });
  }
};
