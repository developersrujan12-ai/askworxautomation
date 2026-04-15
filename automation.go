package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	"askworx-whatsapp-bot/db"
)

// ─── SESSION STATES FOR AUTOMATION ───────────────────────────────────────────

const (
	StateQueryCategory   SessionState = "query_category"
	StateQuizExplanation SessionState = "quiz_explanation"
)

// pendingMessages stores the user's original message while they select a category
var pendingMessages = map[string]string{}

// quizSessionStore stores which quiz the user is currently interacting with in the conversational flow
var quizSessionStore = map[string]*db.Quiz{}

// ─── PRIORITY DISPATCHER ──────────────────────────────────────────────────────
func tryAutomationModules(phone, rawInput string) bool {
	upper := strings.ToUpper(strings.TrimSpace(rawInput))

	// ── Priority 1: Quiz Explanation Flow (Ongoing conversational state) ─────
	if sessions[phone] == StateQuizExplanation {
		handleQuizExplanationReply(phone, upper)
		return true
	}

	// ── Priority 2: Active Quiz — ONLY handle if they type A, B, or C ────────
	quiz, err := db.GetActiveQuiz()
	if err != nil {
		log.Printf("[Quiz] DB error: %v", err)
	}
	if quiz != nil {
		answered, _ := db.HasUserResponded(quiz.ID, phone)
		if !answered {
			isA := (upper == "A" || strings.Contains(upper, "OPTION A") || upper == "1")
			isB := (upper == "B" || strings.Contains(upper, "OPTION B") || upper == "2")
			isC := (upper == "C" || strings.Contains(upper, "OPTION C") || upper == "3")

			if isA || isB || isC {
				ans := "A"
				if isB { ans = "B" }
				if isC { ans = "C" }
				handleQuizResponse(phone, ans, quiz)
				return true
			}
			// Important: If it's NOT A, B, or C, we just return false 
			// so the main handler can show the Menu. No more "Selection Force".
		}
	}

	// FAQ REMOVED: No more FAQ hijacking as requested.

	// ── Priority 3: Query category selection (ongoing Module 2 session) ──────
	if sessions[phone] == StateQueryCategory {
		handleQueryCategoryReply(phone, upper, rawInput)
		return true
	}

	return false
}

// ─── MODULE 1: QUIZ FLOW ──────────────────────────────────────────────────────

func handleQuizResponse(phone, answer string, quiz *db.Quiz) {
	isCorrect := answer == strings.ToUpper(quiz.CorrectAnswer)

	if err := db.SaveQuizResponse(quiz.ID, phone, answer, isCorrect); err != nil {
		log.Printf("[Quiz] Save error: %v", err)
	}

	var msg string
	if isCorrect {
		msg = "🎉 *Thank you for participating in the ASKworX Weekly Knowledge Challenge!*\n\n✅ *Awesome! That's the correct answer.*\n\nWould you like to see the detailed explanation? Tap below! 👇"
	} else {
		msg = "🎉 *Thank you for participating in the ASKworX Weekly Knowledge Challenge!*\n\n❌ *Oops! That was a tricky one, but it's not quite correct.*\n\nWould you like to see the right answer and explanation? Tap below! 👇"
	}

	// Store quiz and update state
	quizSessionStore[phone] = quiz
	sessions[phone] = StateQuizExplanation

	// Send as buttons for even easier interaction
	buttons := []Button{
		{ID: "YES", Title: "Yes, Explain"},
		{ID: "NO", Title: "No, Later"},
	}
	sendInteractiveButtons(phone, msg, buttons)
}

func handleQuizExplanationReply(phone, upper string) {
	quiz := quizSessionStore[phone]
	if quiz == nil {
		sessions[phone] = StateMain
		return
	}

	if upper == "YES" {
		msg := fmt.Sprintf(
			"🎯 *The Correct Answer is: %s*\n\n%s\n\n🎥 Watch video: %s",
			strings.ToUpper(quiz.CorrectAnswer),
			quiz.Explanation,
			quiz.YouTubeLink,
		)
		sendTextMessage(phone, msg)
	} else if upper == "NO" {
		sendTextMessage(phone, "👍 No problem! Stay tuned for next week's quiz.")
	} else {
		// Invalid response while in this state
		sendTextMessage(phone, "Please reply *YES* or *NO* to see the quiz explanation.")
		return
	}

	// Reset state
	sessions[phone] = StateMain
	delete(quizSessionStore, phone)
}

// StartQueryFlow initiates the support assistant flow — called when no quiz/FAQ matched.
func StartQueryFlow(phone, originalMessage string) {
	log.Printf("[Support] Starting assistant flow for %s", phone)

	// Step 2: Auto Response
	greeting := "Hi! 👋 Thanks for reaching out to *ASKworX*.\n\nWe've received your message and our team will assist you shortly."
	sendTextMessage(phone, greeting)

	// Step 3: Send Button Menu
	body := "Please select your query type:"
	buttons := []Button{
		{ID: "service", Title: "🔧 Service Request"},
		{ID: "quotation", Title: "💰 Get Quote"},
		{ID: "product", Title: "🛠️ Product Query"},
		{ID: "general", Title: "💬 General Inquiry"},
	}
	sendInteractiveButtons(phone, body, buttons)

	sessions[phone] = StateQueryCategory
	pendingMessages[phone] = originalMessage
}

// ─── MODULE 2: PREMIUM SUPPORT HANDLER ────────────────────────────────────────

var CategoryLabels = map[string]string{
	"service":   "Service Request",
	"quotation": "Request Quotation",
	"technical": "Technical Query",
	"general":   "General Inquiry",
}

func handleQueryCategoryReply(phone, upper, rawInput string) {
	// Match against the ID (lowercase rawInput from buttons)
	label, valid := CategoryLabels[strings.ToLower(rawInput)]
	if !valid {
		// Edge case: Remind user to use buttons
		sendTextMessage(phone, "Please select one of the options above 👆")
		return
	}

	originalMsg := pendingMessages[phone]
	
	// Step 5: Store Query
	db.SaveCustomerQuery(db.CustomerQuery{
		PhoneNumber:     phone,
		UserName:        "Customer", 
		OriginalMessage: originalMsg,
	})
	
	// Get the ID of the query to update category
	q, _ := db.GetLatestPendingQuery(phone)
	if q.ID != 0 {
		db.UpdateQueryCategory(q.ID, label)
	}

	// Step 7: Notify Internal Team
	NotifyTeam(phone, label, originalMsg)

	// Step 6: Confirm to User
	sendTextMessage(phone, "✅ Got it! Our team will contact you shortly regarding your request.")

	// Step 8: Reset State
	sessions[phone] = StateMain
	delete(pendingMessages, phone)
}

func NotifyTeam(phone, category, message string) {
	teamNumber := os.Getenv("TEAM_WHATSAPP_NUMBER")
	if teamNumber == "" {
		log.Println("[Support] TEAM_WHATSAPP_NUMBER not set — skipping notification")
		return
	}
	
	notification := fmt.Sprintf(
		"📩 *New Customer Query*\n\n👤 *Number:* +%s\n📂 *Category:* %s\n💬 *Message:* %s",
		phone, category, message,
	)
	sendTextMessage(teamNumber, notification)
}

// ─── MODULE 3: FAQ KNOWLEDGE BASE ────────────────────────────────────────────

type faqEntry struct {
	keywords []string
	answer   string
}

var faqKnowledgeBase = []faqEntry{
	{
		keywords: []string{"what do you do", "what is askworx", "who are you", "about askworx"},
		answer:   "ASKworX Smart Automation LLP provides end-to-end industrial automation — PLC & SCADA engineering, IIoT, cloud analytics, robotics, and digital software. 🏭\n\n🌐 www.askworx.in | 📞 +91 9187458714",
	},
	{
		keywords: []string{"plc", "programmable logic controller"},
		answer:   "We design & commission complete PLC systems — Micro PLCs, Motion Controllers, VFDs, Safety PLCs, and AC Servo Drives for Automotive, Pharma, Food & Beverage, and more. ⚡\n\nType *MENU* to request a free quote.",
	},
	{
		keywords: []string{"scada", "hmi", "supervisory control"},
		answer:   "We develop full SCADA & HMI systems with real-time monitoring, alarming, historical trending, and multi-site remote access using platforms like MC Works64. 🖥️\n\nType *MENU* to request a free quote.",
	},
	{
		keywords: []string{"robot", "robotics", "cobot", "collaborative robot"},
		answer:   "We integrate industrial robots and cobots for welding, assembly, pick & place, and palletizing with full commissioning & after-sales support. 🤖\n\nType *MENU* to request a free quote.",
	},
	{
		keywords: []string{"iiot", "industrial iot", "iot gateway", "mqtt", "opc-ua", "modbus"},
		answer:   "Our IIoT solutions connect your machines to the cloud via OPC-UA, Modbus, and MQTT with secure edge computing and real-time dashboards. ☁️\n\nType *MENU* to request a free quote.",
	},
	{
		keywords: []string{"atex", "hazardous area", "explosion proof"},
		answer:   "We supply and support ATEX-certified instruments for hazardous area classifications. Contact our team for specific product recommendations. 🔒\n\n📞 +91 9187458714",
	},
	{
		keywords: []string{"price", "pricing", "cost", "how much", "quote", "quotation"},
		answer:   "Our pricing is tailored to your project scope. We deliver a detailed proposal within 24 hours. 💬\n\nType *MENU* → *Get Free Quote* to get started.",
	},
	{
		keywords: []string{"contact", "phone number", "email", "address", "office", "location"},
		answer:   "📞 +91 9187458714\n📧 contact@askworx.in\n🌐 www.askworx.in\n📍 1381, 6th Main Road, RR Nagar, Bangalore — 560098",
	},
	{
		keywords: []string{"whatsapp bot", "chatbot", "wa bot", "automation bot"},
		answer:   "We build AI-powered WhatsApp Business bots with CRM integration, lead capture, broadcast scheduling, and a multi-agent admin dashboard. 📱\n\nType *MENU* to request a free quote.",
	},
	{
		keywords: []string{"website", "web app", "mobile app", "app development", "flutter", "react"},
		answer:   "We build Progressive Web Apps, mobile apps (Flutter/React Native), corporate sites, and enterprise ERP/MES software. 🌐\n\nType *MENU* to request a free quote.",
	},
	{
		keywords: []string{"seo", "digital marketing", "google ads", "linkedin", "social media"},
		answer:   "We offer data-driven SEO, Google Ads (PPC), LinkedIn B2B lead generation, and social media branding to drive high-intent traffic and paying customers. 📈\n\nType *MENU* to request a free quote.",
	},
}

// tryFAQMatch returns (answer, isConfident)
func tryFAQMatch(input string) (string, bool) {
	lower := strings.ToLower(input)

	// Skip button IDs — they contain underscores and should not be matched by FAQ
	if strings.Contains(lower, "_") {
		return "", false
	}

	for _, entry := range faqKnowledgeBase {
		for _, kw := range entry.keywords {
			if strings.Contains(lower, kw) {
				return entry.answer, true
			}
		}
	}
	return "", false
}

// sendEngagementNudge sends a professional business introduction to convert
// quiz interest into service inquiries.
func sendEngagementNudge(phone string) {
	greeting := "👋 Welcome to ASKworX.\n\n" +
		"We are a Ground-to-Cloud automation company helping businesses with industrial automation, digital transformation, and smart engineering solutions.\n\n" +
		"From PLC, SCADA, and IIoT systems to software development, CRM solutions, and digital marketing — we provide complete end-to-end solutions.\n\n" +
		"How can we assist you today?"

	buttons := []Button{
		{ID: "flow_service", Title: "🔧 Service Request"},
		{ID: "flow_quotation", Title: "💰 Get a Quote"},
		{ID: "flow_callback", Title: "📞 Book Callback"},
	}

	sendInteractiveButtons(phone, greeting, buttons)
}
