-- migration.sql
CREATE TABLE IF NOT EXISTS contacts (
    id SERIAL PRIMARY KEY, 
    phone VARCHAR UNIQUE, 
    name VARCHAR, 
    company VARCHAR, 
    joined_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS leads (
    id SERIAL PRIMARY KEY, 
    phone VARCHAR, 
    name VARCHAR, 
    company VARCHAR, 
    requirement TEXT, 
    contact_phone VARCHAR, 
    status VARCHAR DEFAULT 'new', 
    notes TEXT, 
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS callbacks (
    id SERIAL PRIMARY KEY, 
    phone VARCHAR, 
    name VARCHAR, 
    preferred_time VARCHAR, 
    status VARCHAR DEFAULT 'pending', 
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS messages_log (
    id SERIAL PRIMARY KEY, 
    phone VARCHAR, 
    direction VARCHAR, 
    message TEXT, 
    wa_msg_id VARCHAR UNIQUE, 
    sent_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS quizzes (
    id SERIAL PRIMARY KEY,
    campaign_id INT REFERENCES campaigns(id),
    question TEXT NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    correct_answer CHAR(1) NOT NULL,
    explanation TEXT,
    youtube_link VARCHAR(255),
    is_active BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS quiz_responses (
    id SERIAL PRIMARY KEY,
    quiz_id INT REFERENCES quizzes(id),
    phone VARCHAR NOT NULL,
    answer CHAR(1) NOT NULL,
    is_correct BOOLEAN NOT NULL,
    responded_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(quiz_id, phone)
);

CREATE TABLE IF NOT EXISTS customer_queries (
    id SERIAL PRIMARY KEY,
    phone VARCHAR,
    name VARCHAR,
    category VARCHAR,
    original_message TEXT,
    status VARCHAR DEFAULT 'open',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS campaigns (
    id SERIAL PRIMARY KEY,
    type VARCHAR NOT NULL,           -- 'quiz' or 'poster'
    -- Quiz fields
    question TEXT,
    option_a VARCHAR(255),
    option_b VARCHAR(255),
    option_c VARCHAR(255),
    correct_answer CHAR(1),
    explanation TEXT,
    youtube_link VARCHAR(255),
    -- Poster fields
    image_url VARCHAR(255),
    caption TEXT,
    -- Scheduling & state
    scheduled_at TIMESTAMP NOT NULL,
    status VARCHAR DEFAULT 'scheduled', -- scheduled | sent | cancelled
    total_sent INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);
