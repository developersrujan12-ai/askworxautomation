package db

import (
	"context"
	"fmt"
	"time"
)

func CreateLead(phone, name, company, requirement, contactPhone string) error {
	_, err := Pool.Exec(context.Background(), 
		"INSERT INTO leads (phone, name, company, requirement, contact_phone) VALUES ($1, $2, $3, $4, $5)", 
		phone, name, company, requirement, contactPhone)
	if err != nil {
		fmt.Printf("ERROR creating lead: %v\n", err)
	}
	return err
}

type Lead struct {
	ID           int       `json:"id"`
	Phone        string    `json:"phone"`
	Name         *string   `json:"name"`
	Company      *string   `json:"company"`
	Requirement  *string   `json:"requirement"`
	ContactPhone *string   `json:"contact_phone"`
	Status       string    `json:"status"`
	CreatedAt    time.Time `json:"created_at"`
}

func GetAllLeads() ([]Lead, error) {
	rows, err := Pool.Query(context.Background(), "SELECT id, phone, name, company, requirement, contact_phone, status, created_at FROM leads ORDER BY created_at DESC")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	leads := []Lead{}
	for rows.Next() {
		var l Lead
		err := rows.Scan(&l.ID, &l.Phone, &l.Name, &l.Company, &l.Requirement, &l.ContactPhone, &l.Status, &l.CreatedAt)
		if err != nil {
			fmt.Printf("Error scanning lead row: %v\n", err)
			continue
		}
		leads = append(leads, l)
	}
	return leads, nil
}

func UpdateLeadStatus(id int, status string) error {
	_, err := Pool.Exec(context.Background(), "UPDATE leads SET status = $1 WHERE id = $2", status, id)
	return err
}

func GetNewLeadsCount() (int, error) {
	var count int
	err := Pool.QueryRow(context.Background(), "SELECT COUNT(*) FROM leads WHERE status = 'new'").Scan(&count)
	return count, err
}
