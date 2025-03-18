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

  //Get all orders with item names and final prices
  static async getAllOrders() {
    const [results] = await db.execute(
      "SELECT ord.order_id, GROUP_CONCAT(itm.item_name SEPARATOR ', ') AS item_names, ord.final_amount AS final_price, ord.order_status FROM `order` ord JOIN order_items orderItem ON ord.order_id = orderItem.order_id JOIN item itm ON orderItem.item_id = itm.item_id GROUP BY ord.order_id"
    );
    return results;
  }

  //Get all orders for a user
  static async getOrderByUser(userId) {
    return db.execute(
      `SELECT * FROM \`order\` WHERE user_id = ? ORDER BY order_date DESC`,
      [userId]
    );
  }
}

module.exports = Order;
