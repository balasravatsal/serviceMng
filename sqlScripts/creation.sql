-- Create ENUM types
CREATE TYPE service_status AS ENUM ('Operational', 'Degraded Performance', 'Partial Outage', 'Major Outage');
CREATE TYPE incident_status AS ENUM ('Open', 'Resolved', 'In Progress');


CREATE TABLE IF NOT EXISTS public.users
(
    id character varying(50) COLLATE pg_catalog."default" NOT NULL,
    firstname character varying(100) COLLATE pg_catalog."default" NOT NULL,
    lastname character varying(100) COLLATE pg_catalog."default" NOT NULL,
    email character varying(100) COLLATE pg_catalog."default" NOT NULL,
    role character varying(50) COLLATE pg_catalog."default" NOT NULL DEFAULT 'member'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    organization_id integer,
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_email_key UNIQUE (email),
    CONSTRAINT fk_users_organization FOREIGN KEY (organization_id)
        REFERENCES public.organizations (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
);




-- Organizations Table
CREATE TABLE organizations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Teams Table
CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    organization_id INT REFERENCES organizations(id)
);

-- Team Membership Table
CREATE TABLE team_memberships (
    id SERIAL PRIMARY KEY,
    team_id INT REFERENCES teams(id) ON DELETE CASCADE,
    user_id VARCHAR(50) REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(50) DEFAULT 'member',
    membership_status BOOLEAN DEFAULT FALSE
);


-- Services Table
CREATE TABLE services (
    id SERIAL PRIMARY KEY,
    team_id INT REFERENCES teams(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    current_status service_status DEFAULT 'Operational'
);

-- Incidents Table
CREATE TABLE incidents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    organization_id INT REFERENCES organizations(id) ON DELETE CASCADE,
    status incident_status DEFAULT 'Open',
    is_scheduled_maintenance BOOLEAN DEFAULT FALSE,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    created_by_user_id VARCHAR(50)
);


-- Incident-Service Link Table
CREATE TABLE incident_service_links (
    id SERIAL PRIMARY KEY,
    incident_id INT REFERENCES incidents(id) ON DELETE CASCADE,
    service_id INT REFERENCES services(id) ON DELETE CASCADE
);

-- Incident Updates Table
CREATE TABLE incident_updates (
    id SERIAL PRIMARY KEY,
    incident_id INT REFERENCES incidents(id) ON DELETE CASCADE,
    message TEXT, -- made nullable by removing NOT NULL
    status incident_status NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Public Status Page Table
CREATE TABLE public_status_pages (
    id SERIAL PRIMARY KEY,
    organization_id INT REFERENCES organizations(id) ON DELETE CASCADE,
    custom_domain VARCHAR(255),
    is_enabled BOOLEAN DEFAULT TRUE
);


CREATE TABLE user_organizations (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(50) REFERENCES users(id) ON DELETE CASCADE,
    organization_id INT REFERENCES organizations(id) ON DELETE CASCADE,
    role VARCHAR(50) DEFAULT 'member',
    UNIQUE(user_id, organization_id)
);


CREATE TABLE subscriptions (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_id INTEGER NOT NULL REFERENCES services(id) ON DELETE CASCADE
);

CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id character varying(50) NOT NULL,
    message VARCHAR NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
