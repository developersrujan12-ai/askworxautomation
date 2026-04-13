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
