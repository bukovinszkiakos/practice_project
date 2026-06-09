require("dotenv").config();

const express = require("express");
const cors = require("cors");
const pool = require("./db");

const messagesRoutes = require("./routes/messages");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "OK",
  });
});

app.use("/api/messages", messagesRoutes);

const startServer = async () => {
  let retries = 10;

  while (retries) {
    try {
      await pool.query(`
        CREATE TABLE IF NOT EXISTS messages (
          id SERIAL PRIMARY KEY,
          text TEXT NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);

      console.log("Database connected");

      app.listen(process.env.PORT, "0.0.0.0", () => {
        console.log(`Server running on port ${process.env.PORT}`);
      });

      
      break;
    } catch (error) {
      console.log("Waiting for database...");
      console.log(error.message);

      retries--;

      await new Promise((resolve) =>
        setTimeout(resolve, 5000)
      );
    }
  }

  if (!retries) {
    console.error("Could not connect to database");
  }
};

startServer();