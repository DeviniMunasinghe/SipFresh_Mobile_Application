const db = require("../../config/db");

class Item {
  //Add a new item(Admin's feature)
  static async create(itemData) {
    const { item_name, item_description, item_price, item_image, category_id } =
      itemData;

    try {
      await db.execute(
        "INSERT INTO item(item_name,item_description,item_price,item_image,category_id ) VALUES(?,?,?,?,?)",
        [item_name, item_description, item_price, item_image, category_id]
      );
    } catch (error) {
      throw new Error("Error adding new item:" + error.message);
    }
  }

  //Find item by category
  static async findByCategory(category_id) {
    try {
      const [result] = await db.execute(
        "SELECT*FROM item WHERE category_id=? AND is_deleted = 0",
        [category_id]
      );
      return result;
    } catch (error) {
      throw new Error("Error finding items" + error.message);
    }
  }

  // Get all items (excluding soft deleted ones)
  static async findAll() {
    try {
      const [results] = await db.execute(
        "SELECT itm.item_id, itm.item_name, itm.item_description, itm.item_price, itm.item_image, c.category_name FROM item itm JOIN category c ON itm.category_id = c.category_id WHERE itm.is_deleted = 0 "
      );
      return results;
    } catch (error) {
      throw new Error("Error fetching items: " + error.message);
    }
  }

  // Fetch a single item by its ID(excluding soft deleted items)
  static async findById(item_id) {
    try {
      const [result] = await db.execute(
        "SELECT * FROM item WHERE item_id = ? AND is_deleted = 0",
        [item_id]
      );
      return result.length > 0 ? result[0] : null; // Return the item or null if not found
    } catch (error) {
      throw new Error("Error fetching item: " + error.message);
    }
  }
}

module.exports = Item;
