const db = require("../../config");

class Order {
  //Create a new order
  static async createOrder(userId, totalAmount, cartId) {
    const [result] = await db.execute(
      `INSERT INTO \`order\` (user_id, total_amount, order_status, cart_id) 
             VALUES (?, ?, 'Pending', ?)`,
      [userId, , totalAmount, cartId]
    );
    //return the new orderId
    return result.insertId;
  }
}

module.exports = Order;
