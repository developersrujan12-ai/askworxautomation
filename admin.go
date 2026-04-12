package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	"askworx-whatsapp-bot/db"
	"github.com/go-chi/chi/v5"
)

func AdminRoutes() chi.Router {
	r := chi.NewRouter()

	r.Get("/stats", func(w http.ResponseWriter, r *http.Request) {
		contacts, err1 := db.GetAllContacts()
		leads, err2 := db.GetAllLeads()
		callbacks, err3 := db.GetAllCallbacks()
		messages, err4 := db.GetAllMessages()

		if err1 != nil || err2 != nil || err3 != nil || err4 != nil {
			fmt.Printf("Error fetching stats: %v %v %v %v\n", err1, err2, err3, err4)
		}

		stats := map[string]int{
			"total_contacts":    len(contacts),
			"total_leads":       len(leads),
			"pending_callbacks": 0,
			"new_leads":         0,
			"total_messages":    len(messages),
		}

		for _, l := range leads {
			if l.Status == "new" {
				stats["new_leads"]++
			}
		}
		for _, c := range callbacks {
			if c.Status == "pending" {
				stats["pending_callbacks"]++
			}
		}

		json.NewEncoder(w).Encode(stats)
	})

	r.Get("/leads", func(w http.ResponseWriter, r *http.Request) {
		leads, err := db.GetAllLeads()
		if err != nil {
			fmt.Printf("Error fetching leads: %v\n", err)
		}
		json.NewEncoder(w).Encode(leads)
	})

	r.Post("/leads/update-status", func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			ID     int    `json:"id"`
			Status string `json:"status"`
		}
		json.NewDecoder(r.Body).Decode(&body)
		db.UpdateLeadStatus(body.ID, body.Status)
		w.WriteHeader(http.StatusOK)
	})

	r.Get("/callbacks", func(w http.ResponseWriter, r *http.Request) {
		callbacks, _ := db.GetAllCallbacks()
		json.NewEncoder(w).Encode(callbacks)
	})

	r.Post("/callbacks/mark-done", func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			ID int `json:"id"`
		}
		json.NewDecoder(r.Body).Decode(&body)
		db.MarkCallbackDone(body.ID)
		w.WriteHeader(http.StatusOK)
	})

	r.Get("/contacts", func(w http.ResponseWriter, r *http.Request) {
		contacts, _ := db.GetAllContacts()
		json.NewEncoder(w).Encode(contacts)
	})

	r.Get("/messages", func(w http.ResponseWriter, r *http.Request) {
		messages, _ := db.GetAllMessages()
		json.NewEncoder(w).Encode(messages)
	})

	r.Get("/messages/{phone}", func(w http.ResponseWriter, r *http.Request) {
		phone := chi.URLParam(r, "phone")
		messages, _ := db.GetMessagesByPhone(phone)
		json.NewEncoder(w).Encode(messages)
	})

	r.Post("/send-message", func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			Phone   string `json:"phone"`
			Message string `json:"message"`
		}
		json.NewDecoder(r.Body).Decode(&body)
		sendTextMessage(body.Phone, body.Message)
		w.WriteHeader(http.StatusOK)
	})

	return r
}

func AuthHandler(w http.ResponseWriter, r *http.Request) {
	var body struct {
		Password string `json:"password"`
	}
	json.NewDecoder(r.Body).Decode(&body)

	if body.Password == os.Getenv("ADMIN_PASSWORD") {
		json.NewEncoder(w).Encode(map[string]string{"token": "dummy-token-askworx"})
	} else {
		w.WriteHeader(http.StatusUnauthorized)
	}
}
