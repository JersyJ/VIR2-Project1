#!/bin/bash

if [ -f .env ]; then
    # Source the .env file to load the variables
    export $(grep -v '^#' .env | xargs)
else
    echo ".env file not found!"
    exit 1
fi

DB_CONTAINER=pg-0
DB_USER=${POSTGRESQL_USERNAME}
DB_PASSWORD=${POSTGRESQL_PASSWORD}
DB_NAME=${POSTGRESQL_DATABASE}

SQL="
-- Create products table if it doesn't exist
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL NOT NULL
);

-- Insert sample data into products table
INSERT INTO products (name, price) VALUES 
('Product1', 19.99),
('Product2', 29.99),
('Product3', 39.99),
('Product4', 49.99);
"

docker compose exec -it $DB_CONTAINER psql postgresql://${DB_USER}:${DB_PASSWORD}@127.0.0.1:5432/${DB_NAME} -c "$SQL"
