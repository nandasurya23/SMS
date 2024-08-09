package handler

import (
	"context"
	"crypto/sha256"
	"database/sql"
	"encoding/hex"
	"net/http"
	"smsbackends/db"
	"smsbackends/models"

	"github.com/gofiber/fiber/v2"
)

func Register(c *fiber.Ctx) error {
	var user models.User
	if err := c.BodyParser(&user); err != nil {
		return err
	}

	hashedPassword := hashPassword(user.Password)

	db, err := db.ConnectDB()
	if err != nil {
		return err
	}
	defer db.Close()

	_, err = db.ExecContext(context.Background(), "INSERT INTO users (username, phone_number, password) VALUES (?, ?, ?)", user.Username, user.PhoneNumber, hashedPassword)
	if err != nil {
		return err
	}

	return c.Status(http.StatusCreated).JSON(fiber.Map{
		"message": "User registered successfully",
	})
}

// Function to hash password using SHA-256
func hashPassword(password string) string {
	hasher := sha256.New()
	hasher.Write([]byte(password))
	hashedPassword := hex.EncodeToString(hasher.Sum(nil))
	return hashedPassword
}

func Login(c *fiber.Ctx) error {
	var user models.User
	if err := c.BodyParser(&user); err != nil {
		return err
	}

	hashedPassword := hashPassword(user.Password)

	db, err := db.ConnectDB()
	if err != nil {
		return err
	}
	defer db.Close()

	row := db.QueryRowContext(context.Background(), "SELECT id, username FROM users WHERE phone_number = ? AND password = ?", user.PhoneNumber, hashedPassword)

	var id int
	var username string
	err = row.Scan(&id, &username)
	if err != nil {
		if err == sql.ErrNoRows {
			return c.Status(http.StatusUnauthorized).JSON(fiber.Map{
				"message": "Invalid phone number or password",
			})
		}
		return err
	}

	return c.Status(http.StatusOK).JSON(fiber.Map{
		"message": "Login successful",
		"user":    fiber.Map{"id": id, "username": username},
	})
}
