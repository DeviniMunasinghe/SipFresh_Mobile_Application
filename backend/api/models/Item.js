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
}

module.exports = Item;
