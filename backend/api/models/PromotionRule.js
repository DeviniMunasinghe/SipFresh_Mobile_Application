const db = require("../../config/db");

class PromotionRule {
  // Add a rule for a specific promotion
  static async addRule(promotionId, ruleData) {
    const { min_price, discount_percentage } = ruleData;

    try {
      const [result] = await db.execute(
        "INSERT INTO promotion_rule (promotion_id, min_price, discount_percentage) VALUES (?, ?, ?)",
        [promotionId, min_price, discount_percentage]
      );
      return {
        rule_id: result.insertId,
        promotion_id: promotionId,
        ...ruleData,
      };
    } catch (error) {
      throw new Error("Error adding promotion rule: " + error.message);
    }
  }
}

module.exports = PromotionRule;
