const Category = require("../models/Category");
const Item = require("../models/Item");

//Add a new item (admin only)
exports.addItem = async (req, res) => {
  console.log("Add item request received");

  const { item_name, item_description, item_price, category_name } = req.body;
  const item_image = `/images/menu/${req.file.filename}`;

  try {
    //Find category by name
    const category = await Category.findByName(category_name);

    if (!category) {
      return res.status(400).json({
        message: "Invalid category",
      });
    }

    //Create item
    await Item.create({
      item_name,
      item_image,
      item_description,
      item_price,
      category_id: category.category_id,
    });

    res.status(200).json({
      message: "Item added successfully",
    });
  } catch (error) {
    console.error("Error adding item:", error);
    res.status(500).json({
      message: "Server error:",
      error: error.message,
    });
  }
};


