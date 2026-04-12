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

	fmt.Println("--- REPAIRING SCHEMA ---")
	pool.Exec(context.Background(), "ALTER TABLE leads ADD COLUMN IF NOT EXISTS contact_phone VARCHAR")
	pool.Exec(context.Background(), "ALTER TABLE leads ADD COLUMN IF NOT EXISTS notes TEXT")

	fmt.Println("--- SCHEMA CHECK ---")
	cols, _ := pool.Query(context.Background(), "SELECT column_name FROM information_schema.columns WHERE table_name = 'leads'")
	for cols.Next() {
		var cn string
		cols.Scan(&cn)
		fmt.Println("Col:", cn)
	}
	cols.Close()

	var contacts, leads, messages, callbacks int
	
	pool.QueryRow(context.Background(), "SELECT COUNT(*) FROM contacts").Scan(&contacts)
	pool.QueryRow(context.Background(), "SELECT COUNT(*) FROM leads").Scan(&leads)
	pool.QueryRow(context.Background(), "SELECT COUNT(*) FROM messages_log").Scan(&messages)
	pool.QueryRow(context.Background(), "SELECT COUNT(*) FROM callbacks").Scan(&callbacks)

	fmt.Println("--- DATABASE DIAGNOSTIC ---")
	fmt.Printf("Contacts: %d\n", contacts)
	fmt.Printf("Leads:    %d\n", leads)
	fmt.Printf("Messages: %d\n", messages)
	fmt.Printf("Callbacks: %d\n", callbacks)
	fmt.Println("---------------------------")

	if leads > 0 {
		fmt.Println("\n--- LEADS DATA ---")
		rows, _ := pool.Query(context.Background(), "SELECT id, name, company, status FROM leads")
		defer rows.Close()
		for rows.Next() {
			var id int
			var name, company, status string
			err := rows.Scan(&id, &name, &company, &status)
			if err != nil {
				fmt.Printf("SCAN ERROR on ID %d: %v\n", id, err)
			} else {
				fmt.Printf("ID %d: %s (%s) - Status: %s\n", id, name, company, status)
			}
		}
	}
}
