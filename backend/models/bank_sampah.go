package models

import "time"

type Transaction struct {
	ID        int       `json:"id"`
	Username  string    `json:"username"`
	Plastik   int       `json:"plastik"`
	Kertas    int       `json:"kertas"`
	Botol     int       `json:"botol"`
	Notes     string    `json:"notes"`
	TotalKg   int       `json:"total_kg"` // Ini adalah field yang dihitung secara otomatis dalam database
	CreatedAt time.Time `json:"created_at"`
}
