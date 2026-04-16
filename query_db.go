package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v4/pgxpool"
	"github.com/joho/godotenv"
)

func main() {
	godotenv.Load(".env")
	dbURL := os.Getenv("DATABASE_URL")
	pool, err := pgxpool.Connect(context.Background(), dbURL)
	if err != nil {
		log.Fatal(err)
	}
	defer pool.Close()

	rows, _ := pool.Query(context.Background(), "SELECT id, employee_phone, description, due_at, status FROM reminders ORDER BY id DESC LIMIT 5")
	for rows.Next() {
		var id int
		var phone, desc, status string
		var due time.Time
		rows.Scan(&id, &phone, &desc, &due, &status)
		fmt.Printf("Reminder %d: Phone=%s, Due=%s, Status=%s\n", id, phone, due, status)
	}
}
