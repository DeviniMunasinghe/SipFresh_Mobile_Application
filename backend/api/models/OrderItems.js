const db = require("../../config/db");

class OrderItems {
  // Transfer selected items from cart to order
  static async transferSelectedItemsToOrder(
    selectedCartItemIds,
    orderId,
    userId
  ) {
    try {
      const [items] = await db.execute(
        `SELECT ci.item_id, ci.quantity, itm.item_price 
       FROM cart_items ci 
       JOIN cart c ON ci.cart_id = c.cart_id 
       JOIN item itm ON ci.item_id = itm.item_id 
       WHERE ci.cart_item_id IN (?) 
         AND c.user_id = ? 
         AND ci.is_deleted = 0 AND ci.selected = 1`,
        [selectedCartItemIds, userId]
      );

      if (items.length === 0) {
        throw new Error("No valid items found for transfer.");
      }

      for (const item of items) {
        await this.addItemToOrder(
          orderId,
          item.item_id,
          item.quantity,
          item.item_price
        );
      }

      return { message: "Selected items transferred successfully." };
    } catch (error) {
      throw new Error("Error transferring items to order: " + error.message);
    }
  }
}

module.exports = OrderItems;
