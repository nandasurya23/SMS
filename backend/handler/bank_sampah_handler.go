package handler

import (
	"context"
	"database/sql"
	"net/http"
	"smsbackends/db"
	"smsbackends/models"

	"github.com/gofiber/fiber/v2"
)

func CreateTransaction(c *fiber.Ctx) error {
	var transaction models.Transaction
	if err := c.BodyParser(&transaction); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{
			"message": "Failed to parse request body",
		})
	}

	// Open a new database connection
	dbConn, err := db.ConnectDB()
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to connect to database",
		})
	}
	defer dbConn.Close()

	// Insert transaction into database
	_, err = dbConn.ExecContext(context.Background(), "INSERT INTO transactions (username, plastik, kertas, botol, notes) VALUES (?, ?, ?, ?, ?)",
		transaction.Username, transaction.Plastik, transaction.Kertas, transaction.Botol, transaction.Notes)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to save transaction",
		})
	}

	// Retrieve and update total transactions for the user
	var totalTransactions int
	err = dbConn.QueryRowContext(context.Background(), "SELECT total_transactions FROM users WHERE username = ?", transaction.Username).Scan(&totalTransactions)
	if err != nil {
		if err == sql.ErrNoRows {
			return c.Status(http.StatusNotFound).JSON(fiber.Map{
				"message": "User not found",
			})
		}
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to retrieve user data",
		})
	}

	newTotal := totalTransactions + transaction.Plastik + transaction.Kertas + transaction.Botol
	_, err = dbConn.ExecContext(context.Background(), "UPDATE users SET total_transactions = ? WHERE username = ?", newTotal, transaction.Username)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to update total transactions",
		})
	}

	return c.Status(http.StatusOK).JSON(fiber.Map{"message": "Transaction created and user total updated successfully"})
}

func GetTotalTransactions(c *fiber.Ctx) error {
	username := c.Params("username")

	// Open a new database connection
	dbConn, err := db.ConnectDB()
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to connect to database",
		})
	}
	defer dbConn.Close()

	var totalTransactions int
	err = dbConn.QueryRowContext(context.Background(), "SELECT total_transactions FROM users WHERE username = ?", username).Scan(&totalTransactions)
	if err != nil {
		if err == sql.ErrNoRows {
			return c.Status(http.StatusNotFound).JSON(fiber.Map{
				"message": "User not found",
			})
		}
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to retrieve total transactions",
		})
	}

	return c.Status(http.StatusOK).JSON(fiber.Map{"totalTransactions": totalTransactions})
}
