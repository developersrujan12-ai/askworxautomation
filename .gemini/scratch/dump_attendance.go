package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/jackc/pgx/v4/pgxpool"
)

func main() {
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		log.Fatal("DATABASE_URL is not set")
	}

	pool, err := pgxpool.Connect(context.Background(), dbURL)
	if err != nil {
		log.Fatal("Unable to connect to database:", err)
	}
	defer pool.Close()

	rows, err := pool.Query(context.Background(), "SELECT id, phone, check_in, check_out, date FROM attendance ORDER BY id DESC")
	if err != nil {
		log.Fatal("Query failed:", err)
	}
	defer rows.Close()

	fmt.Println("--- ATTENDANCE TABLE DUMP ---")
	fmt.Printf("%-5s | %-15s | %-20s | %-20s | %-10s\n", "ID", "Phone", "Check-In", "Check-Out", "Date")
	fmt.Println(string(make([]byte, 80, '-')))

	for rows.Next() {
		var id int
		var phone string
		var checkIn, checkOut *time.Time
		var date time.Time
		err := rows.Scan(&id, &phone, &checkIn, &checkOut, &date)
		if err != nil {
			log.Println("Row scan error:", err)
			continue
		}

		inStr := "None"
		if checkIn != nil {
			inStr = checkIn.Format("15:04:05")
		}
		outStr := "None"
		if checkOut != nil {
			outStr = checkOut.Format("15:04:05")
		}

		fmt.Printf("%-5d | %-15s | %-20s | %-20s | %-10s\n", id, phone, inStr, outStr, date.Format("2006-01-02"))
	}
}
