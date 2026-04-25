package main

import (
	"context"
	"fmt"
	"log"

	"askworx-whatsapp-bot/db"
	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("Error loading .env file from root")
	}

	// Initialize Database connection
	err = db.InitDB()
	if err != nil {
		log.Fatalf("Could not connect to database: %v", err)
	}
	defer db.Pool.Close()

	fmt.Println("🧹 Clearing database tables...")

	// List of tables to drop
	tables := []string{
		"quiz_responses",
		"quizzes",
		"campaign_stats", // Just in case it exists
		"campaigns",
		"customer_queries",
		"messages_log",
		"callbacks",
		"leads",
		"contacts",
		"attendance",
		"leave_requests",
		"employees",
		"reminders",
		"settings",
	}

	for _, table := range tables {
		_, err := db.Pool.Exec(context.Background(), fmt.Sprintf("DROP TABLE IF EXISTS %s CASCADE", table))
		if err != nil {
			fmt.Printf("⚠️ Warning: Could not drop table %s: %v\n", table, err)
		} else {
			fmt.Printf("✅ Dropped table %s\n", table)
		}
	}

	fmt.Println("\n🛠️ Re-initializing database structure...")

	// Re-run the standard initialization
	err = db.InitDB()
	if err != nil {
		log.Fatalf("Error re-initializing DB: %v", err)
	}

	db.CreateInternalTables()

	fmt.Println("\n✨ Database cleared and reset successfully!")
}
