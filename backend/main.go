package main

import (
	"smsbackends/handler"


	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()

	// Routes
	app.Post("/register", handler.Register)
	app.Post("/login", handler.Login)

	// Start server
	app.Listen(":3000")
}
