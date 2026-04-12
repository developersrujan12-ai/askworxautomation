# ASKworX Premium WhatsApp Bot 🚀

Ultra-premium world-class B2B sales and support bot for ASKworX Smart Automation LLP.

## Tech Stack
- **Language**: Go (Golang)
- **Database**: PostgreSQL (via pgx/v5)
- **Router**: Chi v5
- **Task Scheduling**: robfig/cron/v3
- **Communication**: Meta WhatsApp Cloud API

## Key Features
- **Premium Industrial Aesthetic**: Uses curated high-resolution industrial imagery.
- **Image-First Flow**: Sends engaging visuals before detailed text descriptions.
- **Interactive Buttons**: Max 20-character titles for perfect mobile display.
- **Smart Routing**: Slug-based button IDs for reliable state transitions.
- **Multi-Step Leads**: Conversational data collection for high-conversion quoting.
- **Automated Scheduling**: Monday morning broadcasts and daily lead alerts for admins.

## Prerequisites
- Go 1.21+
- PostgreSQL
- Meta Developer Account (WhatsApp Cloud API)
- ngrok (for local testing)

## Setup Instructions

1. **Clone the repository**
2. **Setup Database**
   ```bash
   psql -U your_user -d your_db -f migration.sql
   ```
3. **Configure Environment**
   Open `.env` and fill in your credentials from Meta and Postgres.
4. **Install Dependencies**
   ```bash
   go mod tidy
   ```
5. **Run the Application**
   ```bash
   go run .
   ```

## Deployment
This application is designed to be lightweight and container-ready. 
- Build binary: `go build -o askworx-bot`
- Set `ENV` variables on your server.
- Run using a process manager like `pm2` or as a `systemd` service.

## Environment Variables
- `PHONE_NUMBER_ID`: Your Meta WhatsApp phone ID.
- `ACCESS_TOKEN`: Permanent access token from Meta.
- `VERIFY_TOKEN`: Your secret string for webhook verification.
- `DATABASE_URL`: Postgres DSN string.
- `ADMIN_PHONE`: Admin number for lead alerts.
- `ADMIN_PASSWORD`: For dashboard access.

---
Built by Antigravity for ASKworX Smart Automation LLP.
"Built on experience. Delivered with innovation."
