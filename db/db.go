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

	return Pool.Ping(context.Background())
}
