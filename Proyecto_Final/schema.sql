-- Crear la tabla PUBLISHERS primero, ya que es referenciada por BOOKS
CREATE TABLE PUBLISHERS (
    publisher_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20)
);

-- Crear la tabla AUTHORS
CREATE TABLE AUTHORS (
    author_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE,
    death_date DATE,
    nationality VARCHAR(50),
    biography TEXT
);

-- Crear la tabla CATEGORIES (auto-referenciada para categorías jerárquicas)
CREATE TABLE CATEGORIES (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    parent_category_id INTEGER,
    description TEXT,
    FOREIGN KEY (parent_category_id) REFERENCES CATEGORIES(category_id)
);

-- Crear la tabla BOOKS
CREATE TABLE BOOKS (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    genre VARCHAR(50),
    publication_date DATE,
    publisher_id INTEGER,
    available_copies INTEGER,
    location_code VARCHAR(50),
    summary TEXT,
    FOREIGN KEY (publisher_id) REFERENCES PUBLISHERS(publisher_id)
);

-- Crear la tabla BOOK_AUTHORS para la relación muchos-a-muchos entre BOOKS y AUTHORS
CREATE TABLE BOOK_AUTHORS (
    book_id INTEGER,
    author_id INTEGER,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES BOOKS(book_id),
    FOREIGN KEY (author_id) REFERENCES AUTHORS(author_id)
);

-- Crear la tabla BOOK_CATEGORIES para la relación muchos-a-muchos entre BOOKS y CATEGORIES
CREATE TABLE BOOK_CATEGORIES (
    book_id INTEGER,
    category_id INTEGER,
    extension_count INTEGER,
    PRIMARY KEY (book_id, category_id),
    FOREIGN KEY (book_id) REFERENCES BOOKS(book_id),
    FOREIGN KEY (category_id) REFERENCES CATEGORIES(category_id)
);

-- Crear la tabla MEMBERS
CREATE TABLE MEMBERS (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    join_date DATE,
    membership_end_date DATE,
    membership_type VARCHAR(20),
    max_loans INTEGER,
    status VARCHAR(20)
);

-- Crear la tabla LOANS
CREATE TABLE LOANS (
    loan_id SERIAL PRIMARY KEY,
    book_id INTEGER,
    member_id INTEGER,
    loan_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES BOOKS(book_id),
    FOREIGN KEY (member_id) REFERENCES MEMBERS(member_id)
);

-- Crear la tabla FINES
CREATE TABLE FINES (
    fine_id SERIAL PRIMARY KEY,
    loan_id INTEGER,
    amount DECIMAL(10,2),
    reason VARCHAR(255),
    issue_date DATE,
    payment_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (loan_id) REFERENCES LOANS(loan_id)
);

-- Crear la tabla RESERVATIONS
CREATE TABLE RESERVATIONS (
    reservation_id SERIAL PRIMARY KEY,
    book_id INTEGER,
    member_id INTEGER,
    reservation_date DATE,
    expiry_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (book_id) REFERENCES BOOKS(book_id),
    FOREIGN KEY (member_id) REFERENCES MEMBERS(member_id)
);

-- Crear la tabla STAFF
CREATE TABLE STAFF (
    staff_id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    password_hash VARCHAR(255),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    role VARCHAR(20),
    status VARCHAR(20)
);

-- Crear la tabla AUDIT_TRAIL
CREATE TABLE AUDIT_TRAIL (
    audit_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    record_id INTEGER,
    action VARCHAR(20),
    changed_by VARCHAR(50),
    changed_at TIMESTAMP,
    old_values JSONB,
    new_values JSONB
);
