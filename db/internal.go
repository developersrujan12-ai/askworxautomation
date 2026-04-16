package db

import (
	"context"
	"fmt"
	"log"
	"time"
)

// Internal System Tables
func CreateInternalTables() {
	// Attendance table
	_, err := Pool.Exec(context.Background(), `
		CREATE TABLE IF NOT EXISTS attendance (
			id SERIAL PRIMARY KEY,
			phone TEXT NOT NULL,
			check_in TIMESTAMP,
			check_out TIMESTAMP,
			work_plan TEXT,
			eod_report TEXT,
			date DATE DEFAULT CURRENT_DATE,
			UNIQUE(phone, date)
		)
	`)
	if err != nil {
		log.Fatal("Error creating attendance table:", err)
	}

	// Leaves table
	_, err = Pool.Exec(context.Background(), `
		CREATE TABLE IF NOT EXISTS leave_requests (
			id SERIAL PRIMARY KEY,
			phone TEXT NOT NULL,
			leave_type TEXT,
			leave_date TEXT,
			reason TEXT,
			status TEXT DEFAULT 'Pending'
		)
	`)
	if err != nil {
		log.Fatal("Error creating leave_requests table:", err)
	}

	// Employees table
	_, err = Pool.Exec(context.Background(), `
		CREATE TABLE IF NOT EXISTS employees (
			id SERIAL PRIMARY KEY,
			name TEXT NOT NULL,
			phone TEXT NOT NULL UNIQUE,
			role TEXT DEFAULT 'employee'
		)
	`)
	if err != nil {
		log.Fatal("Error creating employees table:", err)
	}

	// Reminders table
	_, err = Pool.Exec(context.Background(), `
		CREATE TABLE IF NOT EXISTS reminders (
			id SERIAL PRIMARY KEY,
			employee_phone TEXT NOT NULL,
			description TEXT NOT NULL,
			due_at TIMESTAMP NOT NULL,
			status TEXT DEFAULT 'Pending'
		)
	`)
	if err != nil {
		log.Fatal("Error creating reminders table:", err)
	}
}

func AddEmployee(name, phone string) error {
	_, err := Pool.Exec(context.Background(), `
		INSERT INTO employees (name, phone) VALUES ($1, $2)
		ON CONFLICT (phone) DO UPDATE SET name = EXCLUDED.name
	`, name, phone)
	return err
}

func DeleteEmployee(id int) error {
	_, err := Pool.Exec(context.Background(), `DELETE FROM employees WHERE id = $1`, id)
	return err
}

type Employee struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Phone string `json:"phone"`
	Role  string `json:"role"`
}

func GetEmployeesPaginated(limit, offset int) ([]Employee, error) {
	rows, err := Pool.Query(context.Background(), `SELECT id, name, phone, role FROM employees ORDER BY id DESC LIMIT $1 OFFSET $2`, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var employees []Employee
	for rows.Next() {
		var e Employee
		if err := rows.Scan(&e.ID, &e.Name, &e.Phone, &e.Role); err != nil {
			return nil, err
		}
		employees = append(employees, e)
	}
	return employees, nil
}

func GetTotalEmployeesCount() (int, error) {
	var count int
	err := Pool.QueryRow(context.Background(), `SELECT COUNT(*) FROM employees`).Scan(&count)
	return count, err
}

type AttendanceRecord struct {
	ID           int        `json:"id"`
	EmployeeName string     `json:"employee_name"`
	Date         time.Time  `json:"date"`
	CheckIn      *time.Time `json:"check_in"`
	CheckOut     *time.Time `json:"check_out"`
	WorkPlan     *string    `json:"work_plan"`
	EODReport    *string    `json:"eod_report"`
}

func GetAllEmployees() ([]Employee, error) {
	rows, err := Pool.Query(context.Background(), `SELECT id, name, phone, role FROM employees ORDER BY name ASC`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var employees []Employee
	for rows.Next() {
		var e Employee
		if err := rows.Scan(&e.ID, &e.Name, &e.Phone, &e.Role); err != nil {
			return nil, err
		}
		employees = append(employees, e)
	}
	return employees, nil
}

func GetAttendancePaginated(limit, offset int, start, end string) ([]AttendanceRecord, error) {
	query := `
		SELECT a.id, COALESCE(e.name, 'Unregistered Staff'), a.date, a.check_in, a.check_out, a.work_plan, a.eod_report
		FROM attendance a
		LEFT JOIN employees e ON RIGHT(a.phone, 10) = RIGHT(e.phone, 10)
		WHERE 1=1
	`
	args := []interface{}{}
	argID := 1

	if start != "" {
		query += fmt.Sprintf(" AND a.date >= $%d", argID)
		args = append(args, start)
		argID++
	}
	if end != "" {
		query += fmt.Sprintf(" AND a.date <= $%d", argID)
		args = append(args, end)
		argID++
	}

	query += fmt.Sprintf(" ORDER BY a.date DESC, a.check_in DESC LIMIT $%d OFFSET $%d", argID, argID+1)
	args = append(args, limit, offset)

	rows, err := Pool.Query(context.Background(), query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var records []AttendanceRecord
	for rows.Next() {
		var r AttendanceRecord
		if err := rows.Scan(&r.ID, &r.EmployeeName, &r.Date, &r.CheckIn, &r.CheckOut, &r.WorkPlan, &r.EODReport); err != nil {
			return nil, err
		}
		records = append(records, r)
	}
	return records, nil
}

func GetTotalAttendanceCount(start, end string) (int, error) {
	query := `SELECT COUNT(*) FROM attendance WHERE 1=1`
	args := []interface{}{}
	argID := 1

	if start != "" {
		query += fmt.Sprintf(" AND date >= $%d", argID)
		args = append(args, start)
		argID++
	}
	if end != "" {
		query += fmt.Sprintf(" AND date <= $%d", argID)
		args = append(args, end)
		argID++
	}

	var count int
	err := Pool.QueryRow(context.Background(), query, args...).Scan(&count)
	return count, err
}

type LeaveRequest struct {
	ID            int    `json:"id"`
	EmployeeName  string `json:"employee_name"`
	EmployeePhone string `json:"employee_phone"`
	LeaveType     string `json:"leave_type"`
	LeaveDate     string `json:"leave_date"`
	Reason        string `json:"reason"`
	Status        string `json:"status"`
}

func GetLeaveRequestsPaginated(limit, offset int, start, end string) ([]LeaveRequest, error) {
	query := `
		SELECT l.id, COALESCE(e.name, 'Unregistered Staff'), l.phone, l.leave_type, l.leave_date, l.reason, l.status
		FROM leave_requests l
		LEFT JOIN employees e ON RIGHT(l.phone, 10) = RIGHT(e.phone, 10)
		WHERE 1=1
	`
	args := []interface{}{}
	argID := 1

	if start != "" {
		query += fmt.Sprintf(" AND l.leave_date >= $%d", argID)
		args = append(args, start)
		argID++
	}
	if end != "" {
		query += fmt.Sprintf(" AND l.leave_date <= $%d", argID)
		args = append(args, end)
		argID++
	}

	query += fmt.Sprintf(" ORDER BY l.id DESC LIMIT $%d OFFSET $%d", argID, argID+1)
	args = append(args, limit, offset)

	rows, err := Pool.Query(context.Background(), query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var requests []LeaveRequest
	for rows.Next() {
		var r LeaveRequest
		if err := rows.Scan(&r.ID, &r.EmployeeName, &r.EmployeePhone, &r.LeaveType, &r.LeaveDate, &r.Reason, &r.Status); err != nil {
			return nil, err
		}
		requests = append(requests, r)
	}
	return requests, nil
}

func GetTotalLeaveRequestsCount(start, end string) (int, error) {
	query := `SELECT COUNT(*) FROM leave_requests WHERE 1=1`
	args := []interface{}{}
	argID := 1

	if start != "" {
		query += fmt.Sprintf(" AND leave_date >= $%d", argID)
		args = append(args, start)
		argID++
	}
	if end != "" {
		query += fmt.Sprintf(" AND leave_date <= $%d", argID)
		args = append(args, end)
		argID++
	}

	var count int
	err := Pool.QueryRow(context.Background(), query, args...).Scan(&count)
	return count, err
}

func UpdateLeaveStatus(id int, status string) (string, error) {
	var phone string
	err := Pool.QueryRow(context.Background(), `
		UPDATE leave_requests SET status = $1 WHERE id = $2
		RETURNING phone
	`, status, id).Scan(&phone)
	return phone, err
}

func CreateReminder(phone, desc string, due time.Time) error {
	_, err := Pool.Exec(context.Background(), `
		INSERT INTO reminders (employee_phone, description, due_at, status) VALUES ($1, $2, $3, 'scheduled')
	`, phone, desc, due)
	return err
}

func GetDueReminders() ([]struct {
	ID    int
	Phone string
	Desc  string
}, error) {
	rows, err := Pool.Query(context.Background(), `
		SELECT id, employee_phone, description FROM reminders 
		WHERE status = 'scheduled' AND due_at <= $1
	`, time.Now())
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var res []struct {
		ID    int
		Phone string
		Desc  string
	}
	for rows.Next() {
		var r struct {
			ID    int
			Phone string
			Desc  string
		}
		if err := rows.Scan(&r.ID, &r.Phone, &r.Desc); err != nil {
			return nil, err
		}
		res = append(res, r)
	}
	return res, nil
}

func MarkReminderSent(id int) error {
	_, err := Pool.Exec(context.Background(), `UPDATE reminders SET status = 'sent' WHERE id = $1`, id)
	return err
}

type ReminderRecord struct {
	ID    int       `json:"id"`
	Phone string    `json:"phone"`
	Name  string    `json:"name"`
	Desc  string    `json:"description"`
	DueAt time.Time `json:"due_at"`
	Status string    `json:"status"`
}

func GetReminders(limit, offset int, start, end string) ([]ReminderRecord, error) {
	query := `
		SELECT r.id, r.employee_phone, COALESCE(e.name, 'Staff'), r.description, r.due_at, r.status
		FROM reminders r
		LEFT JOIN employees e ON r.employee_phone = e.phone
		WHERE 1=1
	`
	args := []interface{}{}
	argID := 1

	if start != "" {
		query += fmt.Sprintf(" AND r.due_at >= $%d", argID)
		args = append(args, start)
		argID++
	}
	if end != "" {
		query += fmt.Sprintf(" AND r.due_at <= $%d", argID)
		args = append(args, end)
		argID++
	}

	query += fmt.Sprintf(" ORDER BY r.due_at DESC LIMIT $%d OFFSET $%d", argID, argID+1)
	args = append(args, limit, offset)

	rows, err := Pool.Query(context.Background(), query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var reminders []ReminderRecord
	for rows.Next() {
		var r ReminderRecord
		if err := rows.Scan(&r.ID, &r.Phone, &r.Name, &r.Desc, &r.DueAt, &r.Status); err != nil {
			return nil, err
		}
		reminders = append(reminders, r)
	}
	return reminders, nil
}

func GetTotalRemindersCount(start, end string) (int, error) {
	query := `SELECT COUNT(*) FROM reminders WHERE 1=1`
	args := []interface{}{}
	argID := 1

	if start != "" {
		query += fmt.Sprintf(" AND due_at >= $%d", argID)
		args = append(args, start)
		argID++
	}
	if end != "" {
		query += fmt.Sprintf(" AND due_at <= $%d", argID)
		args = append(args, end)
		argID++
	}

	var count int
	err := Pool.QueryRow(context.Background(), query, args...).Scan(&count)
	return count, err
}

func HasCheckedInToday(phone string) (bool, error) {
	var exists bool
	err := Pool.QueryRow(context.Background(), `
		SELECT EXISTS(SELECT 1 FROM attendance WHERE phone = $1 AND date = CURRENT_DATE AND check_in IS NOT NULL)
	`, phone).Scan(&exists)
	return exists, err
}

func HasCheckedOutToday(phone string) (bool, error) {
	var exists bool
	err := Pool.QueryRow(context.Background(), `
		SELECT EXISTS(SELECT 1 FROM attendance WHERE phone = $1 AND date = CURRENT_DATE AND check_out IS NOT NULL)
	`, phone).Scan(&exists)
	return exists, err
}

func MarkCheckIn(phone string) error {
	_, err := Pool.Exec(context.Background(), `
		INSERT INTO attendance (phone, check_in) 
		VALUES ($1, $2)
		ON CONFLICT (phone, date) DO UPDATE 
		SET check_in = EXCLUDED.check_in 
		WHERE attendance.check_in IS NULL
	`, phone, time.Now())
	return err
}

func UpdateWorkPlan(phone, plan string) error {
	_, err := Pool.Exec(context.Background(), `
		UPDATE attendance SET work_plan = $1 
		WHERE phone = $2 AND date = CURRENT_DATE
	`, plan, phone)
	return err
}

func MarkCheckOut(phone string) error {
	_, err := Pool.Exec(context.Background(), `
		UPDATE attendance SET check_out = $1 
		WHERE phone = $2 AND date = CURRENT_DATE
	`, time.Now(), phone)
	return err
}

func UpdateEODReport(phone, report string) error {
	_, err := Pool.Exec(context.Background(), `
		UPDATE attendance SET eod_report = $1 
		WHERE phone = $2 AND date = CURRENT_DATE
	`, report, phone)
	return err
}

func SubmitLeave(phone, lType, date, reason string) error {
	_, err := Pool.Exec(context.Background(), `
		INSERT INTO leave_requests (phone, leave_type, leave_date, reason) 
		VALUES ($1, $2, $3, $4)
	`, phone, lType, date, reason)
	return err
}

// CreateAnnouncementRecord stores a broadcast in the reminders table as 'sent' for history tracking
func CreateAnnouncementRecord(phone, message string, sentAt time.Time) error {
	_, err := Pool.Exec(context.Background(), `
		INSERT INTO reminders (employee_phone, description, due_at, status) VALUES ($1, $2, $3, 'sent')
	`, phone, message, sentAt)
	return err
}
