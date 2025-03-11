const db = require("../../config/db");
const { sendEmail } = require("../../utils/email-utils");

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
