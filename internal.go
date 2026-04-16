package main

import (
	"askworx-whatsapp-bot/db"
	"strings"
)

const (
	TEST_MODE_NUMBER = "918310029635"
	MODE_TEST        = "TEST"
)

// Main dispatcher for Internal System
func tryInternalSystem(phone, input, inputType string) bool {
	// STEP 2 & 3: Strict Access Control
	if phone != TEST_MODE_NUMBER {
		return false
	}

	text := strings.ToLower(strings.TrimSpace(input))

	// Catch button clicks
	if input == "checkin" {
		handleCheckInClick(phone)
		return true
	}
	if input == "checkout" {
		handleCheckOutClick(phone)
		return true
	}
	if input == "leave_casual" || input == "leave_sick" || input == "leave_other" {
		sessions[phone+"_leave_type"] = SessionState(input)
		sendInternalLeaveDatePrompt(phone)
		return true
	}

	// Commands
	if text == "leave" {
		sendInternalLeaveTypePrompt(phone)
		return true
	}

	// State-based handling
	state := sessions[phone]
	switch state {
	case StateInternalWorkPlan:
		handleWorkPlanSubmit(phone, input)
		return true
	case StateInternalEODReport:
		handleEODReportSubmit(phone, input)
		return true
	case StateInternalLeaveDate:
		sessions[phone+"_leave_date"] = SessionState(input)
		sendInternalLeaveReasonPrompt(phone)
		return true
	case StateInternalLeaveReason:
		handleLeaveSubmit(phone, input)
		return true
	}

	return false
}

// --- Attendance Flows ---

func sendMorningCheckIn(phone string) {
	msg := "☀️ *Rise & Shine, ASKworX Champion!* 🚀\n\n\"The strength of the team is each individual member. The strength of each member is the team.\"\n\nWe're thrilled to build the future of automation with you today. Ready to make an impact?\n\nPlease mark your attendance to get started."
	buttons := []Button{
		{ID: "checkin", Title: "🚀 Let's Go (Check-In)"},
	}
	sendInteractiveButtons(phone, msg, buttons)
}

func handleCheckInClick(phone string) {
	db.MarkCheckIn(phone)
	msg := "✅ Check-in recorded.\n\n📝 What are your key tasks for today?"
	sessions[phone] = StateInternalWorkPlan
	sendTextMessage(phone, msg)
}

func handleWorkPlanSubmit(phone, plan string) {
	db.UpdateWorkPlan(phone, plan)
	msg := "🏆 *Mission Accepted!* \n\nYour focus for today is locked in. Let's deliver excellence. Have a productive day ahead!"
	sessions[phone] = StateMain
	sendTextMessage(phone, msg)
}

func sendEveningCheckOut(phone string) {
	msg := "🌅 *Great Work Today!* \n\n\"Success is the sum of small efforts, repeated day in and day out.\"\n\nYou've moved the needle today. Time to recharge and celebrate your wins."
	buttons := []Button{
		{ID: "checkout", Title: "🌙 Finish Day (Check-Out)"},
	}
	sendInteractiveButtons(phone, msg, buttons)
}

func handleCheckOutClick(phone string) {
	db.MarkCheckOut(phone)
	msg := "📊 What did you complete today?"
	sessions[phone] = StateInternalEODReport
	sendTextMessage(phone, msg)
}

func handleEODReportSubmit(phone, report string) {
	db.UpdateEODReport(phone, report)
	msg := "✨ *EOD Accomplished!* \n\nYour contributions today were vital. Rest well, recharge, and we’ll see you at the top tomorrow! 🌙"
	sessions[phone] = StateMain
	sendTextMessage(phone, msg)
}

// --- Leave System Flows ---

func sendInternalLeaveTypePrompt(phone string) {
	msg := "📅 Select leave type:"
	buttons := []Button{
		{ID: "leave_casual", Title: "🏖️ Casual Leave"},
		{ID: "leave_sick", Title: "🤒 Sick Leave"},
		{ID: "leave_other", Title: "📌 Other"},
	}
	sendInteractiveButtons(phone, msg, buttons)
}

func sendInternalLeaveDatePrompt(phone string) {
	sessions[phone] = StateInternalLeaveDate
	sendTextMessage(phone, "Please enter the leave date (e.g., 20th Oct):")
}

func sendInternalLeaveReasonPrompt(phone string) {
	sessions[phone] = StateInternalLeaveReason
	sendTextMessage(phone, "Please provide the reason for leave:")
}

func handleLeaveSubmit(phone, reason string) {
	lType := sessions[phone+"_leave_type"]
	lDate := sessions[phone+"_leave_date"]
	db.SubmitLeave(phone, string(lType), string(lDate), reason)
	
	msg := "📩 Leave request submitted."
	sessions[phone] = StateMain
	delete(sessions, phone+"_leave_type")
	delete(sessions, phone+"_leave_date")
	sendTextMessage(phone, msg)
}
