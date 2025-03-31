const Promotion = require("../models/Promotion");

// Add a new promotion
exports.addPromotion = async (req, res) => {
  const {
    title,
    promotion_description,
    start_date,
    end_date,
    categories,
    rules,
  } = req.body;
  const promotion_image = req.file
    ? `/images/promotion/${req.file.filename}`
    : null;

  try {
    const promotionData = {
      title: title || null,
      promotion_description: promotion_description || null,
      promotion_image,
      start_date: start_date || null,
      end_date: end_date || null,
      categories: categories || null,
    };
    const parsedRules = rules ? JSON.parse(rules) : [];

    const formattedRules = parsedRules.map((rule) => ({
      min_price: rule.min_price || 0,
      discount_percentage: rule.discount_percentage || 0,
    }));

    const promotion = await Promotion.create(promotionData, formattedRules);

    res
      .status(201)
      .json({ message: "Promotion added successfully", promotion });
  } catch (error) {
    console.error("Error adding promotion:", error);
    res
      .status(500)
      .json({ message: "Error adding promotion", error: error.message });
  }
};

