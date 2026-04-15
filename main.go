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
		AllowedHeaders:   []string{"*"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300,
	}))

	// Routes
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/html")
		w.Write([]byte("<h1>🚀 ASKworX Bot is running!</h1><p>API is healthy at <a href='/api/leads'>/api/leads</a></p>"))
	})

	r.HandleFunc("/webhook", WebhookHandler)
	r.Post("/api/login", AuthHandler)
	r.Mount("/api", AdminRoutes())

	// Serve Frontend
	fs := http.FileServer(http.Dir("./admin-frontend/dist"))
	r.Handle("/*", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// If the file exists, serve it, otherwise serve index.html (for React Router)
		path := r.URL.Path
		if _, err := os.Stat("admin-frontend/dist" + path); os.IsNotExist(err) {
			http.ServeFile(w, r, "admin-frontend/dist/index.html")
			return
		}
		fs.ServeHTTP(w, r)
	}))

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	log.Printf("🚀 ASKworX Premium Bot starting on port %s...", port)
	log.Fatal(http.ListenAndServe(":"+port, r))
}
