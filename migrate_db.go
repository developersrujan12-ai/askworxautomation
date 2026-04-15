package main

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

func main() {
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		fmt.Println("DATABASE_URL is empty")
		return
	}
	
	pool, err := pgxpool.New(context.Background(), dbURL)
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		return
	}
	defer pool.Close()

	// Check if contact_phone exists
	var exists bool
	err = pool.QueryRow(context.Background(), `
		SELECT EXISTS (
			SELECT 1 FROM information_schema.columns 
			WHERE table_name='leads' AND column_name='contact_phone'
		)`).Scan(&exists)
	
	if err != nil {
		fmt.Printf("Error checking schema: %v\n", err)
		return
	}

	if !exists {
		fmt.Println("Migrating: Adding contact_phone to leads table...")
		_, err = pool.Exec(context.Background(), "ALTER TABLE leads ADD COLUMN contact_phone TEXT")
		if err != nil {
			fmt.Printf("Migration failed: %v\n", err)
			return
		}
		fmt.Println("Migration successful!")
	} else {
		fmt.Println("Schema check: contact_phone column already exists.")
	}
}
