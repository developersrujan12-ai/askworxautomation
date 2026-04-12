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

	// Monday 9:00 AM Broadcast
	_, err := c.AddFunc("0 9 * * 1", func() {
		log.Println("Starting Monday morning broadcast...")
		phones, err := db.GetAllPhoneNumbers()
		if err != nil {
			log.Println("Error fetching phones for broadcast:", err)
			return
		}

		msg := "🌟 Good Monday from ASKworX!\n━━━━━━━━━━━━━━━━━━━━━━━━\nStart your week with smarter automation!\n\n💡 Industry Insight:\nCompanies using IIoT solutions see up to 30% reduction in unplanned downtime and 25% energy savings.\n\n🏭 Is your plant ready for Industry 4.0?\n\nType SERVICES to explore our solutions.\n📞 +91 9030108949\n🌐 www.askworx.in"
		for _, p := range phones {
			sendTextMessage(p, msg)
		}
	})
	if err != nil {
		log.Println("Error scheduling broadcast:", err)
	}

	// Daily check for new leads older than 24h
	_, err = c.AddFunc("0 10 * * *", func() {
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
