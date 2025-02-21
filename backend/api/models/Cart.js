const db = require("../../config/db");

class Cart {
  // Create a new cart for a user
  static async createCart(userId) {
    try {
      const [result] = await db.execute(
        "INSERT INTO cart (user_id) VALUES (?)",
        [userId]
      );
      return result.insertId; // Return the new cart's ID
    } catch (error) {
      throw new Error("Error creating cart: " + error.message);
    }
  }
}

module.exports = Cart;
