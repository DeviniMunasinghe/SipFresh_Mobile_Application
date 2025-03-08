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
