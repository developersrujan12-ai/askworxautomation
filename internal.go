package main

import (
	"askworx-whatsapp-bot/db"
	"fmt"
	"os"
	"strings"
)

// Helpers to bridge sessions map in handler.go
func updateSession(phone, state string) {
	sessions[phone] = SessionState(state)
	s := getSession(phone)
	s["state"] = state
	saveSession(phone, s)
}

func clearSession(phone string) {
	delete(sessions, phone)
	delete(internalSessions, phone)
}

// Internal storage for complex employee states
var internalSessions = map[string]map[string]interface{}{}

func getSession(phone string) map[string]interface{} {
	if internalSessions[phone] == nil {
		internalSessions[phone] = make(map[string]interface{})
	}
	return internalSessions[phone]
}

func saveSession(phone string, s map[string]interface{}) {
	internalSessions[phone] = s
}

// Bridge to sendInteractiveButtons
func sendButtons(phone, text string, btns []map[string]string) {
	var buttons []Button
	for _, b := range btns {
		buttons = append(buttons, Button{ID: b["id"], Title: b["title"]})
	}
	sendInteractiveButtons(phone, text, buttons)
}

const (
	MODE_TEST        = "TEST"
)

// Main dispatcher for Internal System
func tryInternalSystem(phone, input, state string, lat, lng float64) bool {
	// ── 1. ACCESS CONTROL ──────────────────────────────────────────────────
	allowed, _ := db.IsEmployee(phone)
	if !allowed {
		return false
	}

	// ── 2. MENU TRIGGER ────────────────────────────────────────────────────
	lower := strings.ToLower(input)
	if lower == "hi" || lower == "hey" || lower == "hello" || lower == "menu" || lower == "help" {
		sendEmployeeDashboard(phone)
		updateSession(phone, "internal_menu")
		return true
	}

	// ── 3. STATE HANDLING & DIRECT ACTIONS ─────────────────────────────────
	// Check for location data for attendance
	if input == "LOCATION_DATA" {
		if state == "expect_location_checkin" {
			db.MarkCheckIn(phone, lat, lng)
			sendTextMessage(phone, "📍 *Location Captured & Verified!*\n\nYour site attendance has been recorded successfully. 🚀\n\n*What is your primary focus for today?*\n(Please list your main tasks below)")
			updateSession(phone, "submit_workplan")
			return true
		}
		if state == "expect_location_checkout" {
			db.MarkCheckOut(phone, lat, lng)
			sendTextMessage(phone, "📍 *Location Captured & Departure Verified!*\n\nGreat job today! 🎉\n\n*Please submit your EOD Accomplishments below:*")
			updateSession(phone, "submit_eod")
			return true
		}
	}

	// Check for direct button triggers first (high priority)
	if handleInternalMenu(phone, input) {
		return true
	}

	// Then handle complex flows based on state
	switch {
	case strings.HasPrefix(state, "leave_request"):
		return handleLeaveRequest(phone, input)
	case state == "submit_workplan":
		return handleWorkPlanSubmission(phone, input)
	case state == "submit_eod":
		return handleEODSubmission(phone, input)
	}

	return false
}

func sendEmployeeDashboard(phone string) {
	msg := fmt.Sprintf("*%s INTERNAL HUB*\n\n" +
			"Welcome back, *Champion*! 🏆\n\n" +
			"At %s, we aren't just building automation; we are *pioneering the future* of industrial intelligence. 🏭✨\n\n" +
			"Your expertise today moves the needle for industries worldwide. From Ground to Cloud, let's deliver excellence and show why %s is the leader in Smart Automation. 🚀\n\n" +
			"Ready to make an impact? Select an action below: 👇", os.Getenv("COMPANY_NAME"), os.Getenv("COMPANY_NAME"), os.Getenv("COMPANY_NAME"))

	btnStart := db.GetSetting("btn_start_day")
	if btnStart == "" {
		btnStart = " 🏢 START DAY"
	}
	btnEnd := db.GetSetting("btn_end_day")
	if btnEnd == "" {
		btnEnd = "🏢 END DAY"
	}
	btnLeave := db.GetSetting("btn_apply_leave")
	if btnLeave == "" {
		btnLeave = "🏝️ APPLY LEAVE"
	}

	buttons := []map[string]string{
		{"id": "checkin", "title": btnStart},
		{"id": "checkout", "title": btnEnd},
		{"id": "leave_init", "title": btnLeave},
	}

	db.SaveMessageHistory(phone, msg, "outbound")
	sendButtons(phone, msg, buttons)
}

func handleInternalMenu(phone, input string) bool {
	// Handle both ID and formatted titles with emojis
	cleanInput := strings.ToLower(strings.TrimSpace(input))

	isCheckIn := cleanInput == "checkin" || strings.Contains(cleanInput, "start day")
	isCheckOut := cleanInput == "checkout" || strings.Contains(cleanInput, "end day")
	isLeave := cleanInput == "leave_init" || strings.Contains(cleanInput, "apply leave")

	switch {
	case isCheckIn:
		alreadyChecked, _ := db.HasCheckedInToday(phone)
		if alreadyChecked {
			sendTextMessage(phone, "👋 *Champion, you've already checked in for today!* 🏆\n\nYou're already on the clock and moving the needle. Keep up the great work! 🚀")
			return true
		}
		sendTextMessage(phone, "🏢 *VERIFICATION REQUIRED* 🏢\n\nTo ensure precision in our operations, please share your **Live Location** 📍 via WhatsApp to record your arrival at the project site.")
		updateSession(phone, "expect_location_checkin")
		return true

	case isCheckOut:
		alreadyOut, _ := db.HasCheckedOutToday(phone)
		if alreadyOut {
			sendTextMessage(phone, "🌙 *Champion, you've already wrapped up your day!* ✨\n\nYour EOD reports are filed and missions accomplished. Time to recharge! See you at the top tomorrow. 🚀")
			return true
		}
		sendTextMessage(phone, "🏢 *VERIFICATION REQUIRED* 🏢\n\nPlease share your **Live Location** 📍 to record your departure coordinates and verify your mission wrap-up.")
		updateSession(phone, "expect_location_checkout")
		return true

	case isLeave:
		msg := "🏝️ *LEAVE REQUEST INITIATED*\n\nPlease select the type of leave you require:"
		buttons := []map[string]string{
			{"id": "leave_casual", "title": "🛋️ CASUAL"},
			{"id": "leave_sick", "title": "🤒 SICK LEAVE"},
			{"id": "leave_emergency", "title": "🚨 EMERGENCY"},
		}
		sendButtons(phone, msg, buttons)
		updateSession(phone, "leave_request_type")
		return true
	}
	return false
}

func handleLeaveRequest(phone, input string) bool {
	session := getSession(phone)
	state := session["state"].(string)

	switch state {
	case "leave_request_type":
		if strings.HasPrefix(input, "leave_") {
			session["leave_type"] = input
			session["state"] = "leave_request_date"
			saveSession(phone, session)
			sendTextMessage(phone, "📅 *What is the date for this leave?*\n(e.g., 20th Oct)")
			return true
		}
	case "leave_request_date":
		session["leave_date"] = input
		session["state"] = "leave_request_reason"
		saveSession(phone, session)
		sendTextMessage(phone, "📝 *Please provide a brief reason:*")
		return true
	case "leave_request_reason":
		lType := fmt.Sprintf("%v", session["leave_type"])
		lDate := fmt.Sprintf("%v", session["leave_date"])

		db.SubmitLeave(phone, lType, lDate, input)

		msg := "🚀 *REQUEST SUBMITTED*\n───────────────────\n\nYour leave request has been sent to management for approval. You will receive a notification once verified.\n\n*Rest up & Recharge!* ⚡"
		sendFAQAnswer(phone, msg)
		clearSession(phone)
		return true
	}

	return false
}

func handleWorkPlanSubmission(phone, input string) bool {
	db.UpdateWorkPlan(phone, input)
	msg := "🏆 *PLAN ARCHIVED*\n\nYour objectives are locked in. Now, let's make it happen!\n\n_Have a productive day, Champion!_ 🔥"
	sendFAQAnswer(phone, msg)
	clearSession(phone)
	return true
}

func handleEODSubmission(phone, input string) bool {
	db.UpdateEODReport(phone, input)
	msg := "✨ *WRAP UP COMPLETE*\n\nExcellent work today! Your EOD report has been filed.\n\n_Enjoy your evening, you've earned it!_ 🌙"
	sendFAQAnswer(phone, msg)
	clearSession(phone)
	return true
}

// Legacy flows removed.
