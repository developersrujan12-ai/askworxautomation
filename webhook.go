package main

import (
	"askworx-whatsapp-bot/db"
	"encoding/json"
	"net/http"
	"os"
)

type WebhookRequest struct {
	Entry []struct {
		Changes []struct {
			Value struct {
				Contacts []struct {
					Profile struct {
						Name string `json:"name"`
					} `json:"profile"`
					WaID string `json:"wa_id"`
				} `json:"contacts"`
				Messages []struct {
					ID   string `json:"id"`
					From string `json:"from"`
					Text *struct {
						Body string `json:"body"`
					} `json:"text,omitempty"`
					Interactive *struct {
						ButtonReply struct {
							ID    string `json:"id"`
							Title string `json:"title"`
						} `json:"button_reply"`
					} `json:"interactive,omitempty"`
				} `json:"messages"`
			} `json:"value"`
		} `json:"changes"`
	} `json:"entry"`
}

func WebhookHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodGet {
		verifyToken := os.Getenv("VERIFY_TOKEN")
		mode := r.URL.Query().Get("hub.mode")
		token := r.URL.Query().Get("hub.verify_token")
		challenge := r.URL.Query().Get("hub.challenge")

		if mode == "subscribe" && token == verifyToken {
			w.WriteHeader(http.StatusOK)
			w.Write([]byte(challenge))
			return
		}
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if r.Method == http.MethodPost {
		var req WebhookRequest
		err := json.NewDecoder(r.Body).Decode(&req)
		if err != nil {
			w.WriteHeader(http.StatusOK) // Always return 200
			return
		}

		for _, entry := range req.Entry {
			for _, change := range entry.Changes {
				// 1. Save contact names from profile
				for _, contact := range change.Value.Contacts {
					db.SaveContact(contact.WaID)
					db.UpdateContactName(contact.WaID, contact.Profile.Name)
				}

				// 2. Process messages
				for _, msg := range change.Value.Messages {
					phone := msg.From
					text := ""
					if msg.Text != nil {
						text = msg.Text.Body
					} else if msg.Interactive != nil {
						text = msg.Interactive.ButtonReply.ID
					}

					if text != "" {
						db.LogMessage(phone, "incoming", text, msg.ID)
						go handleMessage(phone, text)
					}
				}
			}
		}

		w.WriteHeader(http.StatusOK)
		return
	}
}
