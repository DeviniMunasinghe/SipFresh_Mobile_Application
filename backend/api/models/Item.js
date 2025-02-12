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
}

module.exports = Item;
