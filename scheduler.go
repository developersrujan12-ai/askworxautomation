package main

import (
	"fmt"
	"log"
	"os"

	"askworx-whatsapp-bot/db"
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

	c.Start()
}
