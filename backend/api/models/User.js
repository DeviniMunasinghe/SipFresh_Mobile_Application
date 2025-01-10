const db = require("../../config/db");

class User {
  // Find user by email
  static async findByEmail(email) {
    try {
      const [result] = await db.execute("SELECT * FROM user WHERE email = ?", [
        email,
      ]);
      return result[0];
    } catch (error) {
      throw new Error("Error finding user by email: " + error.message);
    }
  }

  // Create a new user
  static async create(userData) {
    const { username, email, password, role } = userData;

    console.log("User data:", { username, email, password, role });
    try {
      await db.execute(
        //send the sql queries to the database
        "INSERT INTO user (username, email, password, role) VALUES (?, ?, ?, ?)",
        [username || null, email || null, password || null, role || "user"]
      );
    } catch (error) {
      throw new Error("Error creating user: " + error.message);
    }
  }
}

module.exports = User;
