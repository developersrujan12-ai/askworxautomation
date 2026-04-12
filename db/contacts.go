package db

import (
	"context"
	"time"
)

func SaveContact(phone string) error {
	_, err := Pool.Exec(context.Background(), 
		"INSERT INTO contacts (phone) VALUES ($1) ON CONFLICT (phone) DO NOTHING", 
		phone)
	return err
}

func UpdateContactName(phone, name string) error {
	_, err := Pool.Exec(context.Background(), 
		"UPDATE contacts SET name = $1 WHERE phone = $2", 
		name, phone)
	return err
}

func UpdateContactCompany(phone, company string) error {
	_, err := Pool.Exec(context.Background(), 
		"UPDATE contacts SET company = $1 WHERE phone = $2", 
		company, phone)
	return err
}

type Contact struct {
	ID        int       `json:"id"`
	Phone     string    `json:"phone"`
	Name      *string   `json:"name"`
	Company   *string   `json:"company"`
	JoinedAt  time.Time `json:"joined_at"`
}

func GetAllContacts() ([]Contact, error) {
	rows, err := Pool.Query(context.Background(), "SELECT id, phone, name, company, joined_at FROM contacts ORDER BY joined_at DESC")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	contacts := []Contact{}
	for rows.Next() {
		var c Contact
		err := rows.Scan(&c.ID, &c.Phone, &c.Name, &c.Company, &c.JoinedAt)
		if err != nil {
			continue
		}
		contacts = append(contacts, c)
	}
	return contacts, nil
}
