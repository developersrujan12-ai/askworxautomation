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

func SyncNamesFromLeads() error {
	_, err := Pool.Exec(context.Background(), `
		UPDATE contacts 
		SET name = leads.name, company = leads.company
		FROM leads 
		WHERE contacts.phone = leads.phone 
		AND (contacts.name IS NULL OR contacts.name = '')
	`)
	return err
}

func GetAllContacts() ([]Contact, error) {
	// Sync names before fetching
	SyncNamesFromLeads()
	
	query := `
		SELECT c.id, c.phone, c.name, c.company, c.joined_at
		FROM contacts c
		LEFT JOIN (
			SELECT phone, MAX(sent_at) as last_msg
			FROM messages_log
			GROUP BY phone
		) m ON c.phone = m.phone
		ORDER BY COALESCE(m.last_msg, c.joined_at) DESC
	`
	rows, err := Pool.Query(context.Background(), query)
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
