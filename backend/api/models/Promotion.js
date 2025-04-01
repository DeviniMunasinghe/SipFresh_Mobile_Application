const db = require("../../config/db");

class Promotion {
  // Create a new promotion with associated rules
  static async create(promotionData, rules) {
    const {
      title,
      promotion_description,
      promotion_image,
      start_date,
      end_date,
      categories,
    } = promotionData;

    const connection = await db.getConnection();

    try {
      await connection.beginTransaction();

      const [result] = await connection.execute(
        "INSERT INTO promotion (title, promotion_description, promotion_image, start_date, end_date,categories) VALUES (?, ?, ?, ?, ?, ?)",
        [
          title,
          promotion_description,
          promotion_image,
          start_date,
          end_date,
          categories,
        ]
      );

      const promotion_id = result.insertId;

      // Insert associated rules
      if (rules && rules.length > 0) {
        for (const rule of rules) {
          console.log(
            "Inserting rule:",
            rule,
            "for promotion_id:",
            promotion_id
          );
          await connection.execute(
            `INSERT INTO promotion_rule (promotion_id, min_price, discount_percentage) 
            VALUES (?, ?, ?)`,
            [promotion_id, rule.min_price, rule.discount_percentage]
          );
        }
      } else {
        console.log("No rules to insert");
      }

      await connection.commit();

      return {
        promotion_id,
        title,
        promotion_description,
        promotion_image,
        start_date,
        end_date,
        categories,
        rules,
      };
    } catch (error) {
      await connection.rollback();
      throw new Error("Error creating promotion: " + error.message);
    } finally {
      connection.release();
    }
  }
}

module.exports = Promotion;
