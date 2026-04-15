package db

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

var Pool *pgxpool.Pool

func InitDB() error {
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		return fmt.Errorf("DATABASE_URL not set")
	}

	config, err := pgxpool.ParseConfig(dbURL)
	if err != nil {
		return err
	}

	Pool, err = pgxpool.NewWithConfig(context.Background(), config)
	if err != nil {
		return err
	}

	// Run migration
	migration, err := os.ReadFile("migration.sql")
	if err == nil {
		_, err = Pool.Exec(context.Background(), string(migration))
		if err != nil {
			fmt.Printf("Migration warning: %v\n", err)
		}
	}

	// Hot-fix: Ensure campaign_id exists in quizzes
	Pool.Exec(context.Background(), `ALTER TABLE quizzes ADD COLUMN IF NOT EXISTS campaign_id INTEGER REFERENCES campaigns(id)`)

	// Hot-fix: Create customer_queries table
	Pool.Exec(context.Background(), `
		CREATE TABLE IF NOT EXISTS customer_queries (
			id SERIAL PRIMARY KEY,
			phone_number TEXT NOT NULL,
			user_name TEXT,
			category TEXT,
			original_message TEXT,
			status TEXT DEFAULT 'pending',
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		)
	`)

	return Pool.Ping(context.Background())
}
