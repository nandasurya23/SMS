package handler

import (
	"context"
	"database/sql"
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

    db, err := db.ConnectDB()
    if err != nil {
        return err
    }
    defer db.Close()

    _, err = db.ExecContext(context.Background(), "INSERT INTO users (username, password) VALUES (?, ?)", user.Username, user.Password)
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

    row := db.QueryRowContext(context.Background(), "SELECT id, username FROM users WHERE username = ? AND password = ?", user.Username, user.Password)

    var id int
    var username string
    err = row.Scan(&id, &username)
    if err != nil {
        if err == sql.ErrNoRows {
            return c.Status(http.StatusUnauthorized).JSON(fiber.Map{
                "message": "Invalid username or password",
            })
        }
        return err
    }

    return c.Status(http.StatusOK).JSON(fiber.Map{
        "message": "Login successful",
        "user":    fiber.Map{"id": id, "username": username},
    })
}
