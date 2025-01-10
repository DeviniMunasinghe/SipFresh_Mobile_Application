const bcrypt = require("bcrypt");
const User = require("../models/User");

// Register a new user (only user can register via form)
exports.register = async (req, res) => {
  //exported asynchronous function to be used as the handler for the registration route
  const { username, email, password, confirmPassword } = req.body;

  if (password !== confirmPassword) {
    return res.status(400).json({ message: "Passwords do not match" });
  }
  // To Ensure all required fields are properly passed
  if (!username || !email || !password) {
    return res.status(400).json({ message: "Missing required fields" });
  }

  try {
    // Check if the user is already registered
    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      return res.status(400).json({ message: "User already exists" });
    }

    // Hash Password+
    const hashedPassword = await bcrypt.hash(password, 8);

    // Create user (role is 'user' by default)

    await User.create({
      username: username || null,
      email: email || null,
      password: hashedPassword || null,
      role: "user",
    });

    res.status(201).json({ message: "User registered successfully" });
  } catch (error) {
    console.error("Registration error:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

