package main

import (
	"log"
	"smsbackends/handler"

	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()

	// Routes
	app.Post("/register", handler.Register)
	app.Post("/login", handler.Login)
	app.Post("/transactions", handler.CreateTransaction)
	app.Get("/total_transactions", handler.GetTotalTransactions) 
	
	// Start server
	if err := app.Listen(":3000"); err != nil {
		log.Fatalf("Error starting server: %v", err)
	}
}
