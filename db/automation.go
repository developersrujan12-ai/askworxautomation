package db

import (
	"context"
	"database/sql"
)

type Quiz struct {
	ID            int
	Question      string
	OptionA       string
	OptionB       string
	OptionC       string
	CorrectAnswer string
	Explanation   string
	YouTubeLink   string
}

// GetActiveQuiz returns the currently active quiz, or nil if none.
func GetActiveQuiz() (*Quiz, error) {
	query := `SELECT id, question, option_a, option_b, option_c, correct_answer, explanation, youtube_link
	          FROM quizzes WHERE is_active = true LIMIT 1`
	row := Pool.QueryRow(context.Background(), query)

	var q Quiz
	err := row.Scan(&q.ID, &q.Question, &q.OptionA, &q.OptionB, &q.OptionC, &q.CorrectAnswer, &q.Explanation, &q.YouTubeLink)
	if err != nil {
		if err.Error() == "no rows in result set" {
			return nil, nil
		}
		return nil, err
	}
	return &q, nil
}

// HasUserResponded checks if a user has already answered this quiz.
func HasUserResponded(quizID int, phone string) (bool, error) {
	query := `SELECT EXISTS(SELECT 1 FROM quiz_responses WHERE quiz_id = $1 AND phone = $2)`
	var exists bool
	err := Pool.QueryRow(context.Background(), query, quizID, phone).Scan(&exists)
	return exists, err
}

// SaveQuizResponse records a user's quiz answer.
func SaveQuizResponse(quizID int, phone, answer string, isCorrect bool) error {
	query := `INSERT INTO quiz_responses (quiz_id, phone, answer, is_correct)
	          VALUES ($1, $2, $3, $4)
	          ON CONFLICT (quiz_id, phone) DO NOTHING`
	_, err := Pool.Exec(context.Background(), query, quizID, phone, answer, isCorrect)
	return err
}

// SaveCustomerQuery stores a Module 2 query in the database.
func SaveCustomerQuery(phone, name, category, message string) error {
	query := `INSERT INTO customer_queries (phone, name, category, original_message) VALUES ($1, $2, $3, $4)`
	_, err := Pool.Exec(context.Background(), query, phone, nullableString(name), category, message)
	return err
}

// nullableString returns sql.NullString for optional fields.
func nullableString(s string) sql.NullString {
	if s == "" {
		return sql.NullString{Valid: false}
	}
	return sql.NullString{String: s, Valid: true}
}
