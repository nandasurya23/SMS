package handler

import (
	"context"
	"database/sql"
	"net/http"
	"smsbackends/db"
	"smsbackends/models"

	"golang.org/x/crypto/bcrypt"

	"github.com/gofiber/fiber/v2"
)

func Register(c *fiber.Ctx) error {
	var user models.User
	if err := c.BodyParser(&user); err != nil {
		return err
	}
 
	hashedPassword, err := hashPassword(string(user.Password))
	if err != nil {
		return err
	}

	db, err := db.ConnectDB()
	if err != nil {
		return err
	}
	defer db.Close()

	_, err = db.ExecContext(context.Background(), "INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)", user.Username, user.Email, hashedPassword)
	if err != nil {
		return err
	}

	return c.Status(http.StatusCreated).JSON(fiber.Map{
		"message": "User registered successfully",
	})
}

func Login(c *fiber.Ctx) error {
	var user models.User
	if err := c.BodyParser(&user); err != nil {
		return err
	}

	db, err := db.ConnectDB()
	if err != nil {
		return err
	}
	defer db.Close()

	row := db.QueryRowContext(context.Background(), "SELECT id, username, password_hash FROM users WHERE username = ?", user.Username)

	var id int
	var username string
	var passwordHash string
	err = row.Scan(&id, &username, &passwordHash)
	if err != nil {
		if err == sql.ErrNoRows {
			return c.Status(http.StatusUnauthorized).JSON(fiber.Map{
				"message": "Invalid username or password",
			})
		}
		return err
	}

	if !verifyPassword(string(user.Password), passwordHash) {
		return c.Status(http.StatusUnauthorized).JSON(fiber.Map{
			"message": "Invalid username or password",
		})
	}

	return c.Status(http.StatusOK).JSON(fiber.Map{
		"message": "Login successful",
		"user":    fiber.Map{"id": id, "username": username},
	})
}

func hashPassword(password string) (string, error) {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(hashedPassword), nil
}

func verifyPassword(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}
