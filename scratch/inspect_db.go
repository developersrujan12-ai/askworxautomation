package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/joho/godotenv"
)

func main() {
	godotenv.Load()
	dbURL := os.Getenv("DATABASE_URL")
	pool, err := pgxpool.New(context.Background(), dbURL)
	if err != nil {
		log.Fatal(err)
	}
	defer pool.Close()

	fmt.Println("--- CONTACTS ---")
	rows, _ := pool.Query(context.Background(), "SELECT phone, name FROM contacts")
	for rows.Next() {
		var p string
		var n *string
		rows.Scan(&p, &n)
		name := "NULL"
		if n != nil {
			name = *n
		}
		fmt.Printf("Phone: %s | Name: %s\n", p, name)
	}

	fmt.Println("\n--- LEADS ---")
	rows, _ = pool.Query(context.Background(), "SELECT phone, name FROM leads")
	for rows.Next() {
		var p string
		var n *string
		rows.Scan(&p, &n)
		name := "NULL"
		if n != nil {
			name = *n
		}
		fmt.Printf("Phone: %s | Name: %s\n", p, name)
	}
}
