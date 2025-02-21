const db = require("../../config/db");

class CartItem {
  //Add a new item to the cart
  static async addItem(cartId, itemId) {
    try {
      const [result] = await db.execute(
        "INSERT INTO cart_items (cart_id,item_id) VALUES (?,?)",
        [cartId, itemId]
      );
      return result.insertId; //Return the new cart_item's ID
    } catch (error) {
      throw new Error("Error adding item to cart:" + error.message);
    }
  }
}

module.exports = CartItem;
