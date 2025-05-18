-- Insertar datos en PUBLISHERS
INSERT INTO PUBLISHERS (name, address, city, country, contact_email, contact_phone) VALUES
('Editorial Planeta', 'Av. Insurgentes 123', 'Ciudad de México', 'México', 'contacto@planeta.mx', '+52 55 1234 5678'),
('Penguin Books', '123 Book St', 'New York', 'USA', 'info@penguin.com', '+1 212 555 0101'),
('Ediciones SM', 'Calle Mayor 45', 'Madrid', 'España', 'editorial@sm.es', '+34 91 123 4567');

-- Insertar datos en AUTHORS
INSERT INTO AUTHORS (first_name, last_name, birth_date, nationality, biography) VALUES
('Gabriel', 'García Márquez', '1927-03-06', 'Colombiano', 'Escritor y periodista, ganador del Premio Nobel de Literatura en 1982.'),
('Jane', 'Austen', '1775-12-16', 'Británica', 'Novelista conocida por sus obras sobre la sociedad inglesa del siglo XIX.'),
('Isabel', 'Allende', '1942-08-02', 'Chilena', 'Escritora de renombre internacional, conocida por su novela La Casa de los Espíritus.');

-- Insertar datos en CATEGORIES
INSERT INTO CATEGORIES (name, parent_category_id, description) VALUES
('Ficción', NULL, 'Obras de narrativa imaginaria.'),
('Novela', 1, 'Subgénero de la ficción, centrado en historias extensas.'),
('Realismo Mágico', 2, 'Novelas que combinan elementos realistas con mágicos.'),
('Clásicos', NULL, 'Obras literarias de valor perdurable.');

-- Insertar datos en BOOKS
INSERT INTO BOOKS (title, genre, publication_date, publisher_id, available_copies, location_code, summary) VALUES
('Cien Años de Soledad', 'Realismo Mágico', '1967-05-30', 1, 3, 'A1-001', 'Historia de la familia Buendía a lo largo de siete generaciones.'),
('Orgullo y Prejuicio', 'Clásico', '1813-01-28', 2, 2, 'B2-002', 'Una novela romántica que explora el amor y las clases sociales.'),
('La Casa de los Espíritus', 'Realismo Mágico', '1982-10-01', 3, 1, 'A1-003', 'Crónica de una familia chilena a lo largo de varias generaciones.');

-- Insertar datos en BOOK_AUTHORS
INSERT INTO BOOK_AUTHORS (book_id, author_id) VALUES
(1, 1), -- Cien Años de Soledad - Gabriel García Márquez
(2, 2), -- Orgullo y Prejuicio - Jane Austen
(3, 3); -- La Casa de los Espíritus - Isabel Allende

-- Insertar datos en BOOK_CATEGORIES
INSERT INTO BOOK_CATEGORIES (book_id, category_id, extension_count) VALUES
(1, 3, 0), -- Cien Años de Soledad - Realismo Mágico
(2, 4, 0), -- Orgullo y Prejuicio - Clásicos
(3, 3, 0); -- La Casa de los Espíritus - Realismo Mágico

-- Insertar datos en MEMBERS
INSERT INTO MEMBERS (first_name, last_name, email, phone, address, join_date, membership_end_date, membership_type, max_loans, status) VALUES
('Juan', 'Pérez', 'juan.perez@email.com', '+52 55 9876 5432', 'Calle Luna 12, Ciudad de México', '2024-01-15', '2025-01-15', 'Standard', 3, 'Active'),
('María', 'González', 'maria.gonzalez@email.com', '+52 55 1234 9876', 'Av. Sol 45, Guadalajara', '2024-03-10', '2025-03-10', 'Premium', 5, 'Active'),
('Carlos', 'Ramírez', 'carlos.ramirez@email.com', '+52 55 4567 8901', 'Calle Estrella 78, Monterrey', '2024-06-20', '2025-06-20', 'Standard', 3, 'Inactive');

-- Insertar datos en LOANS
INSERT INTO LOANS (book_id, member_id, loan_date, due_date, return_date) VALUES
(1, 1, '2025-05-01', '2025-05-15', NULL), -- Juan presta Cien Años de Soledad
(2, 2, '2025-05-05', '2025-05-19', '2025-05-17'), -- María presta Orgullo y Prejuicio y lo devuelve
(3, 1, '2025-05-10', '2025-05-24', NULL); -- Juan presta La Casa de los Espíritus

-- Insertar datos en FINES
INSERT INTO FINES (loan_id, amount, reason, issue_date, payment_date, status) VALUES
(2, 50.00, 'Devolución tardía', '2025-05-20', NULL, 'Pending'); -- Multa a María por devolución tardía

-- Insertar datos en RESERVATIONS
INSERT INTO RESERVATIONS (book_id, member_id, reservation_date, expiry_date, status) VALUES
(1, 3, '2025-05-12', '2025-05-19', 'Active'), -- Carlos reserva Cien Años de Soledad
(2, 3, '2025-05-15', '2025-05-22', 'Cancelled'); -- Carlos reserva Orgullo y Prejuicio pero cancela

-- Insertar datos en STAFF
INSERT INTO STAFF (username, password_hash, first_name, last_name, email, role, status) VALUES
('admin1', 'hashed_password_1', 'Ana', 'López', 'ana.lopez@library.com', 'Admin', 'Active'),
('librarian1', 'hashed_password_2', 'Pedro', 'Martínez', 'pedro.martinez@library.com', 'Librarian', 'Active');

-- Insertar datos en AUDIT_TRAIL
INSERT INTO AUDIT_TRAIL (table_name, record_id, action, changed_by, changed_at, old_values, new_values) VALUES
('BOOKS', 1, 'UPDATE', 'admin1', '2025-05-17 10:00:00', '{"available_copies": 3}', '{"available_copies": 2}'),
('MEMBERS', 3, 'UPDATE', 'librarian1', '2025-05-17 11:30:00', '{"status": "Active"}', '{"status": "Inactive"}');
