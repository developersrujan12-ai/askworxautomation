package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"askworx-whatsapp-bot/db"

	"github.com/go-chi/chi/v5"
)

func AdminRoutes() chi.Router {
	r := chi.NewRouter()

	// ── STATIC FILE SERVING FOR UPLOADS ──────────────────────────────────────
	uploadDir := "./uploads"
	if _, err := os.Stat(uploadDir); os.IsNotExist(err) {
		os.Mkdir(uploadDir, 0755)
	}
	r.Handle("/uploads/*", http.StripPrefix("/uploads/", http.FileServer(http.Dir(uploadDir))))

	r.Post("/api/upload", func(w http.ResponseWriter, r *http.Request) {
		r.ParseMultipartForm(10 << 20) // 10MB max
		file, handler, err := r.FormFile("file")
		if err != nil {
			http.Error(w, "error retrieving file", http.StatusBadRequest)
			return
		}
		defer file.Close()

		safeFilename := strings.ReplaceAll(handler.Filename, " ", "_")
		filename := fmt.Sprintf("%d_%s", time.Now().UnixNano(), filepath.Base(safeFilename))
		dst, err := os.Create(filepath.Join(uploadDir, filename))
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer dst.Close()

		if _, err := io.Copy(dst, file); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]string{"url": "/uploads/" + filename})
	})

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

	// ── Campaign Management ─────────────────────────────────────────────────

	r.Get("/campaigns", func(w http.ResponseWriter, r *http.Request) {
		campaigns, err := db.GetAllCampaigns()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		if campaigns == nil {
			campaigns = []db.Campaign{}
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(campaigns)
	})

	r.Post("/campaigns", func(w http.ResponseWriter, r *http.Request) {
		var c db.Campaign
		if err := json.NewDecoder(r.Body).Decode(&c); err != nil {
			http.Error(w, "invalid request body", http.StatusBadRequest)
			return
		}
		// Validation
		if c.Type != "quiz" && c.Type != "poster" {
			http.Error(w, "type must be 'quiz' or 'poster'", http.StatusBadRequest)
			return
		}
		if c.Type == "quiz" {
			if c.Question == "" || c.OptionA == "" || c.OptionB == "" || c.OptionC == "" || c.Explanation == "" {
				http.Error(w, "all quiz fields are required", http.StatusBadRequest)
				return
			}
			c.CorrectAnswer = strings.ToUpper(c.CorrectAnswer)
			if c.CorrectAnswer != "A" && c.CorrectAnswer != "B" && c.CorrectAnswer != "C" {
				http.Error(w, "correct_answer must be A, B, or C", http.StatusBadRequest)
				return
			}
			if len([]rune(c.Explanation)) > 300 {
				http.Error(w, "explanation must not exceed 300 characters", http.StatusBadRequest)
				return
			}
		}
		if c.Type == "poster" && c.ImageURL == "" {
			http.Error(w, "image_url is required for posters", http.StatusBadRequest)
			return
		}
		if c.ScheduledAt.IsZero() {
			http.Error(w, "scheduled_at is required", http.StatusBadRequest)
			return
		}

		id, err := db.CreateCampaign(c)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]int{"id": id})
	})

	r.Delete("/campaigns/{id}", func(w http.ResponseWriter, r *http.Request) {
		idStr := chi.URLParam(r, "id")
		var id int
		fmt.Sscanf(idStr, "%d", &id)
		if err := db.CancelCampaign(id); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		w.WriteHeader(http.StatusOK)
	})

	r.Get("/campaigns/{id}/analytics", func(w http.ResponseWriter, r *http.Request) {
		idStr := chi.URLParam(r, "id")
		var id int
		fmt.Sscanf(idStr, "%d", &id)
		analytics, err := db.GetCampaignAnalytics(id)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(analytics)
	})

	// ── Employee Management ─────────────────────────────────────────────────

	r.Get("/employees", func(w http.ResponseWriter, r *http.Request) {
		employees, err := db.GetAllEmployees()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		json.NewEncoder(w).Encode(employees)
	})

	r.Post("/employees", func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			Name  string `json:"name"`
			Phone string `json:"phone"`
		}
		json.NewDecoder(r.Body).Decode(&body)
		if err := db.AddEmployee(body.Name, body.Phone); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		w.WriteHeader(http.StatusOK)
	})

	r.Delete("/employees/{id}", func(w http.ResponseWriter, r *http.Request) {
		idStr := chi.URLParam(r, "id")
		var id int
		fmt.Sscanf(idStr, "%d", &id)
		db.DeleteEmployee(id)
		w.WriteHeader(http.StatusOK)
	})

	r.Get("/attendance", func(w http.ResponseWriter, r *http.Request) {
		records, err := db.GetDetailedAttendance()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		json.NewEncoder(w).Encode(records)
	})

	r.Get("/leave-requests", func(w http.ResponseWriter, r *http.Request) {
		requests, err := db.GetLeaveRequests()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		json.NewEncoder(w).Encode(requests)
	})

	r.Post("/leave-requests/update-status", func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			ID     int    `json:"id"`
			Status string `json:"status"`
		}
		json.NewDecoder(r.Body).Decode(&body)
		phone, err := db.UpdateLeaveStatus(body.ID, body.Status)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		// Notify employee via WhatsApp
		msg := fmt.Sprintf("📢 *Leave Request Update*\n\nYour leave request has been *%s* by the management.", body.Status)
		sendFAQAnswer(phone, msg) // Use the one with Main Menu button

		w.WriteHeader(http.StatusOK)
	})

	r.Post("/reminders", func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			Phone string    `json:"phone"`
			Desc  string    `json:"desc"`
			Due   time.Time `json:"due"`
		}
		json.NewDecoder(r.Body).Decode(&body)
		db.CreateReminder(body.Phone, body.Desc, body.Due)
		w.WriteHeader(http.StatusOK)
	})

	r.Post("/announcements", func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			Message string   `json:"message"`
			Phones  []string `json:"phones"` // Empty means all
		}
		json.NewDecoder(r.Body).Decode(&body)

		targets := body.Phones
		if len(targets) == 0 {
			emps, _ := db.GetAllEmployees()
			for _, e := range emps {
				targets = append(targets, e.Phone)
			}
		}

		go func() {
			fullMsg := "📢 *OFFICIAL ANNOUNCEMENT*\n────────────────────\n\n" + body.Message
			for _, p := range targets {
				sendFAQAnswer(p, fullMsg)
				time.Sleep(500 * time.Millisecond) // Rate limit
			}
		}()

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
