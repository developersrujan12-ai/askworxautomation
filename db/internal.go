package db

import (
	"context"
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

func GetAllEmployees() ([]Employee, error) {
	rows, err := Pool.Query(context.Background(), `SELECT id, name, phone, role FROM employees`)
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

type AttendanceRecord struct {
	ID           int        `json:"id"`
	EmployeeName string     `json:"employee_name"`
	Date         time.Time  `json:"date"`
	CheckIn      *time.Time `json:"check_in"`
	CheckOut     *time.Time `json:"check_out"`
	WorkPlan     string     `json:"work_plan"`
	EODReport    string     `json:"eod_report"`
}

func GetDetailedAttendance() ([]AttendanceRecord, error) {
	rows, err := Pool.Query(context.Background(), `
		SELECT a.id, COALESCE(e.name, 'Unregistered Staff'), a.date, a.check_in, a.check_out, a.work_plan, a.eod_report
		FROM attendance a
		LEFT JOIN employees e ON RIGHT(a.phone, 10) = RIGHT(e.phone, 10)
		ORDER BY a.date DESC, a.check_in DESC
	`)
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

type LeaveRequest struct {
	ID            int    `json:"id"`
	EmployeeName  string `json:"employee_name"`
	EmployeePhone string `json:"employee_phone"`
	LeaveType     string `json:"leave_type"`
	LeaveDate     string `json:"leave_date"`
	Reason        string `json:"reason"`
	Status        string `json:"status"`
}

func GetLeaveRequests() ([]LeaveRequest, error) {
	rows, err := Pool.Query(context.Background(), `
		SELECT l.id, COALESCE(e.name, 'Unregistered Staff'), l.phone, l.leave_type, l.leave_date, l.reason, l.status
		FROM leave_requests l
		LEFT JOIN employees e ON RIGHT(l.phone, 10) = RIGHT(e.phone, 10)
		ORDER BY l.id DESC
	`)
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
		INSERT INTO reminders (employee_phone, description, due_at) VALUES ($1, $2, $3)
	`, phone, desc, due)
	return err
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
