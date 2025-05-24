-- Insert Users
INSERT INTO users (name, email, password_hash, role) VALUES
('Alice Admin', 'alice@example.com', 'hashed_pwd_1', 'admin'),
('Bob Builder', 'bob@example.com', 'hashed_pwd_2', 'member');

-- Insert Organization
INSERT INTO organizations (name) VALUES
('Tech Corp');

-- Insert Team
INSERT INTO teams (name, organization_id) VALUES
('Dev Team', 1);

-- Insert Team Memberships
INSERT INTO team_memberships (team_id, user_id, role) VALUES
(1, 1, 'admin'),
(1, 2, 'member');

-- Insert Services
INSERT INTO services (organization_id, name, description, current_status) VALUES
(1, 'Website', 'Main company website', 'Operational'),
(1, 'API', 'Backend API for mobile apps', 'Degraded Performance'),
(1, 'Database', 'PostgreSQL DB server', 'Operational');

-- Insert Incidents
INSERT INTO incidents (title, description, organization_id, status, is_scheduled_maintenance, start_time, end_time, created_by_user_id)
VALUES 
('API Latency Issue', 'Users are experiencing high latency with the API.', 1, 'Open', FALSE, NOW(), NULL, 1),
('Scheduled Database Maintenance', 'Routine maintenance for the DB.', 1, 'Open', TRUE, NOW(), NOW() + INTERVAL '2 hours', 1);

-- Link Incidents to Services
INSERT INTO incident_service_links (incident_id, service_id) VALUES
(1, 2),
(2, 3);

-- Add Updates to Incidents
INSERT INTO incident_updates (incident_id, message, status, updated_by_user_id) VALUES
(1, 'Issue identified, working on a fix.', 'Degraded Performance', 1),
(2, 'Maintenance started.', 'Partial Outage', 1);

-- Public Status Page
INSERT INTO public_status_pages (organization_id, custom_domain, is_enabled)
VALUES (1, 'status.techcorp.com', TRUE);
