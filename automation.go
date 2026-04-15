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

	// ── Priority 2: Active Quiz (New attempt) ─────────────────────────────────
	quiz, err := db.GetActiveQuiz()
	if err != nil {
		log.Printf("[Quiz] DB error: %v", err)
	}
	if quiz != nil {
		answered, _ := db.HasUserResponded(quiz.ID, phone)
		if !answered {
			log.Printf("[Quiz] Checking input '%s' against active quiz #%d", upper, quiz.ID)
			isA := (upper == "A" || strings.Contains(upper, "OPTION A") || upper == "1")
			isB := (upper == "B" || strings.Contains(upper, "OPTION B") || upper == "2")
			isC := (upper == "C" || strings.Contains(upper, "OPTION C") || upper == "3")

			if isA || isB || isC {
				ans := "A"
				if isB { ans = "B" }
				if isC { ans = "C" }
				log.Printf("[Quiz] Match found! User: %s, Answer: %s", phone, ans)
				handleQuizResponse(phone, ans, quiz)
				return true
			}
			// Active quiz present but invalid reply
			sendTextMessage(phone, "Please *tap one of the buttons* above or reply with *A*, *B*, or *C* to participate in the quiz! 🎯")
			return true
		}
	}

	// ── Priority 3: FAQ (high-confidence match) ──────────────────────────────
	if reply, ok := tryFAQMatch(rawInput); ok {
		sendTextMessage(phone, reply)
		return true
	}

	// ── Priority 4: Query category selection (ongoing Module 2 session) ──────
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
		msg = "🎉 *Awesome! That’s correct!*\n\nDo you want the explanation? Reply *YES* or *NO*"
	} else {
		msg = "❌ *Oops! That’s not correct.*\n\nDo you want the right answer? Reply *YES* or *NO*"
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

// StartQueryFlow initiates Module 2 — called when no quiz/FAQ matched.
func StartQueryFlow(phone, originalMessage string) {
	log.Printf("[Module2] Starting query flow for %s", phone)

	ack := "Thank you for reaching out to *ASKworX*. 🙏\nWe have received your query and our team will get back to you shortly."
	sendTextMessage(phone, ack)

	body := "Please select your query type below to help us direct you to the right expert:"
	buttons := []Button{
		{ID: "1", Title: "Service Request"},
		{ID: "2", Title: "Get Quotation"},
		{ID: "3", Title: "Product Query"},
	}
	sendInteractiveButtons(phone, body, buttons)

	sessions[phone] = StateQueryCategory
	pendingMessages[phone] = originalMessage
}

// ─── MODULE 2: QUERY CATEGORY HANDLER ────────────────────────────────────────

var categoryLabels = map[string]string{
	"1": "Service / Maintenance Request",
	"2": "Quotation Request",
	"3": "Product / Technical Query",
	"4": "General Inquiry",
}

func handleQueryCategoryReply(phone, upper, rawInput string) {
	label, valid := categoryLabels[upper]
	if !valid {
		sendTextMessage(phone, "Please reply *1*, *2*, *3*, or *4* to select your query type.")
		return
	}

	originalMsg := pendingMessages[phone]
	if err := db.SaveCustomerQuery(phone, "", label, originalMsg); err != nil {
		log.Printf("[Module2] Save query error: %v", err)
	}

	notifyTeam(phone, label, originalMsg)

	sessions[phone] = StateMain
	delete(pendingMessages, phone)

	sendTextMessage(phone, fmt.Sprintf(
		"✅ *Query Received!*\n\n📂 Category: *%s*\n\nOur team will get back to you shortly. Type *MENU* anytime to explore our services. 🙏",
		label,
	))
}

func notifyTeam(phone, category, message string) {
	teamNumber := os.Getenv("TEAM_WHATSAPP_NUMBER")
	if teamNumber == "" {
		log.Println("[Module2] TEAM_WHATSAPP_NUMBER not set — skipping notification")
		return
	}
	msg := fmt.Sprintf(
		"📩 *New Customer Query*\n\n📞 Number: +%s\n📂 Category: %s\n💬 Message: %s",
		phone, category, message,
	)
	sendTextMessage(teamNumber, msg)
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
	for _, entry := range faqKnowledgeBase {
		for _, kw := range entry.keywords {
			if strings.Contains(lower, kw) {
				return entry.answer, true
			}
		}
	}
	return "", false
}
