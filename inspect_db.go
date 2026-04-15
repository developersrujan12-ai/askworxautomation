package main

import (
	"context"
	"fmt"
	"github.com/jackc/pgx/v5/pgxpool"
)

func main() {
	dbURL := "postgresql://postgres:WpnexKIOGhvdbouuLXFAsXdIAmOrQpXl@mainline.proxy.rlwy.net:32103/railway"
	pool, err := pgxpool.New(context.Background(), dbURL)
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		return
	}
	defer pool.Close()

	fmt.Println("--- Sample from quiz_responses ---")
	rows, _ := pool.Query(context.Background(), "SELECT phone FROM quiz_responses LIMIT 5")
	for rows.Next() {
		var p string
		rows.Scan(&p)
		fmt.Printf("Phone in quiz_responses: [%s]\n", p)
	}
	rows.Close()

	fmt.Println("\n--- Sample from contacts ---")
	rows, _ = pool.Query(context.Background(), "SELECT phone, name FROM contacts LIMIT 5")
	for rows.Next() {
		var p string
		var n *string
		rows.Scan(&p, &n)
		name := "NULL"
		if n != nil { name = *n }
		fmt.Printf("Phone in contacts: [%s], Name: [%s]\n", p, name)
	}
	rows.Close()

	fmt.Println("\n--- Sample from leads ---")
	rows, _ = pool.Query(context.Background(), "SELECT phone, name FROM leads LIMIT 5")
	for rows.Next() {
		var p, n string
		rows.Scan(&p, &n)
		fmt.Printf("Phone in leads: [%s], Name: [%s]\n", p, n)
	}
	rows.Close()
}
