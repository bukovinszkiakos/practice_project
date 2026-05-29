const express = require("express");
const router = express.Router();
const pool = require("../db");

router.get("/", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM messages ORDER BY id DESC"
    );

    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Failed to fetch messages",
    });
  }
});

router.post("/", async (req, res) => {
  try {
    const { text } = req.body;

    const result = await pool.query(
      "INSERT INTO messages (text) VALUES ($1) RETURNING *",
      [text]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Failed to create message",
    });
  }
});

module.exports = router;