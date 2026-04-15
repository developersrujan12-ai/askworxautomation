package main

import (
	"askworx-whatsapp-bot/db"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/robfig/cron/v3"
)

func InitScheduler() {
	c := cron.New()

	// Daily 9:00 AM IST Greeting
	_, err := c.AddFunc("CRON_TZ=Asia/Kolkata 0 9 * * *", func() {
		log.Println("Starting daily IST 9:00 AM greeting...")
		phones, err := db.GetAllPhoneNumbers()
		if err != nil {
			log.Println("Error fetching phones for broadcast:", err)
			return
		}

		msg := "🏭 Good Morning from ASKworX! ☀️\n━━━━━━━━━━━━━━━━━━━━━━━━\n\"Built on experience. Delivered with innovation.\"\n\nWe hope you have a productive day ahead. How can we help automate your growth today?\n\nType MENU for services.\n🌐 www.askworx.in"
		for _, p := range phones {
			sendTextMessage(p, msg)
		}
	})
	if err != nil {
		log.Println("Error scheduling broadcast:", err)
	}

	// Daily check for new leads older than 24h (IST 10 AM)
	_, err = c.AddFunc("CRON_TZ=Asia/Kolkata 0 10 * * *", func() {
		log.Println("Starting daily lead follow-up check...")
		count, err := db.GetNewLeadsCount()
		if err != nil {
			log.Println("Error checking lead count:", err)
			return
		}

		if count > 0 {
			adminPhone := os.Getenv("ADMIN_PHONE")
			msg := fmt.Sprintf("⚠️ ASKworX Alert!\nYou have [%d] new leads pending follow-up.\nLogin to dashboard to view details.", count)
			sendTextMessage(adminPhone, msg)
		}
	})
	if err != nil {
		log.Println("Error scheduling lead check:", err)
	}

	// ── Every minute: check for due campaigns and broadcast ──────────────────
	_, err = c.AddFunc("* * * * *", func() {
		campaigns, err := db.GetDueCampaigns()
		if err != nil {
			log.Println("[Scheduler] Error fetching due campaigns:", err)
			return
		}
		if len(campaigns) == 0 {
			return
		}

		phones, err := db.GetAllPhoneNumbers()
		if err != nil || len(phones) == 0 {
			log.Println("[Scheduler] No contacts to broadcast to")
			return
		}

		for _, camp := range campaigns {
			log.Printf("[Scheduler] Broadcasting campaign #%d (%s) to %d contacts", camp.ID, camp.Type, len(phones))

			switch strings.ToLower(camp.Type) {
			case "quiz":
				broadcastQuiz(camp, phones)
			case "poster":
				broadcastPoster(camp, phones)
			}

			db.MarkCampaignSent(camp.ID, len(phones))
		}
	})
	if err != nil {
		log.Println("Error scheduling campaign broadcaster:", err)
	}

	c.Start()
}

func broadcastQuiz(camp db.Campaign, phones []string) {
	quizBody := fmt.Sprintf(
		"🌟 *ASKworX Industrial Insight* 🌟\n\n"+
			"*WEEKLY KNOWLEDGE CHALLENGE*\n\n"+
			"❓ *QUESTION:*\n%s?\n\n"+
			"📍 *OPTIONS:*\n"+
			"🅰️ %s\n"+
			"🅱️ %s\n"+
			"©️ %s\n\n"+
			"👉 *Tap your answer below to participate!*",
		camp.Question, camp.OptionA, camp.OptionB, camp.OptionC,
	)

	buttons := []Button{
		{ID: "A", Title: "Option A"},
		{ID: "B", Title: "Option B"},
		{ID: "C", Title: "Option C"},
	}

	// Deactivate any previous quiz first
	db.DeactivateAllQuizzes()

	// Create quiz entry from campaign
	quizID, err := db.CreateQuizFromCampaign(camp)
	if err != nil {
		log.Printf("[Scheduler] Failed to create quiz entry: %v", err)
		return
	}
	log.Printf("[Scheduler] Activated quiz #%d", quizID)

	for _, phone := range phones {
		sendInteractiveButtons(phone, quizBody, buttons)

		// Nudge strategy: Wait 10 minutes to see if they answer the quiz
		go func(p string, qID int) {
			time.Sleep(10 * time.Minute)
			answered, err := db.HasUserResponded(qID, p)
			if err != nil {
				return
			}
			if !answered {
				log.Printf("[Scheduler] User %s didn't answer quiz, sending nudge", p)
				sendEngagementNudge(p)
			}
		}(phone, quizID)
	}
}

func broadcastPoster(camp db.Campaign, phones []string) {
	publicURL := os.Getenv("PUBLIC_URL")
	actualImageURL := camp.ImageURL

	// If the image is stored locally, we MUST use the public ngrok URL for Meta to reach it
	if strings.Contains(actualImageURL, "localhost") || strings.HasPrefix(actualImageURL, "/uploads") {
		filename := filepath.Base(actualImageURL)
		actualImageURL = fmt.Sprintf("%s/uploads/%s", publicURL, filename)
		log.Printf("[Scheduler] Local image detected. Rewriting to public: %s", actualImageURL)
	}

	premiumCaption := fmt.Sprintf(
		"📢 *ASKworX Industrial Update* 📢\n"+
			"──────────────────⬡\n\n"+
			"%s\n\n"+
			"──────────────────⬡\n"+
			"🌐 *Visit us:* www.askworx.in\n"+
			"📧 *Support:* contact@askworx.in",
		camp.Caption,
	)

	buttons := []Button{
		{ID: "expert", Title: "Talk to Expert 📞"},
		{ID: "menu", Title: "Main Menu 🏠"},
	}

	for _, phone := range phones {
		sendImageWithButtons(phone, actualImageURL, premiumCaption, buttons)
	}
}
