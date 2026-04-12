package main

import (
	"log"
	"net/http"
	"os"

	"askworx-whatsapp-bot/db"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables
	godotenv.Load()

	// Initialize Database
	err := db.InitDB()
	if err != nil {
		log.Fatalf("Critical: Could not initialize database: %v", err)
	}
	defer db.Pool.Close()

	// Initialize Scheduler
	InitScheduler()

	// Setup Router
	r := chi.NewRouter()

	// Middleware
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300,
	}))

	// Routes
	r.HandleFunc("/webhook", WebhookHandler)
	r.Post("/api/login", AuthHandler)
	r.Mount("/api", AdminRoutes())

	// Static Files Frontend (Optional)
	// r.Handle("/*", http.FileServer(http.Dir("./admin-frontend/dist")))

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	log.Printf("🚀 ASKworX Premium Bot starting on port %s...", port)
	log.Fatal(http.ListenAndServe(":"+port, r))
}
