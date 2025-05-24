--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

-- Started on 2025-05-24 22:57:41

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 866 (class 1247 OID 25000)
-- Name: incident_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.incident_status AS ENUM (
    'Open',
    'Resolved',
    'In Progress'
);


ALTER TYPE public.incident_status OWNER TO postgres;

--
-- TOC entry 863 (class 1247 OID 24991)
-- Name: service_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.service_status AS ENUM (
    'Operational',
    'Degraded Performance',
    'Partial Outage',
    'Major Outage'
);


ALTER TYPE public.service_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 25094)
-- Name: incident_service_links; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incident_service_links (
    id integer NOT NULL,
    incident_id integer,
    service_id integer
);


ALTER TABLE public.incident_service_links OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25093)
-- Name: incident_service_links_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incident_service_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.incident_service_links_id_seq OWNER TO postgres;

--
-- TOC entry 3472 (class 0 OID 0)
-- Dependencies: 217
-- Name: incident_service_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incident_service_links_id_seq OWNED BY public.incident_service_links.id;


--
-- TOC entry 233 (class 1259 OID 25289)
-- Name: incident_updates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incident_updates (
    id integer NOT NULL,
    incident_id integer,
    message text,
    status public.incident_status NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.incident_updates OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 25288)
-- Name: incident_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incident_updates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.incident_updates_id_seq OWNER TO postgres;

--
-- TOC entry 3473 (class 0 OID 0)
-- Dependencies: 232
-- Name: incident_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incident_updates_id_seq OWNED BY public.incident_updates.id;


--
-- TOC entry 229 (class 1259 OID 25238)
-- Name: incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidents (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    organization_id integer,
    status public.incident_status DEFAULT 'Open'::public.incident_status,
    is_scheduled_maintenance boolean DEFAULT false,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    created_by_user_id character varying(50)
);


ALTER TABLE public.incidents OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 25237)
-- Name: incidents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incidents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.incidents_id_seq OWNER TO postgres;

--
-- TOC entry 3474 (class 0 OID 0)
-- Dependencies: 228
-- Name: incidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incidents_id_seq OWNED BY public.incidents.id;


--
-- TOC entry 237 (class 1259 OID 25341)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id character varying(50) NOT NULL,
    message character varying NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    service_name character varying(100) NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 25340)
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO postgres;

--
-- TOC entry 3475 (class 0 OID 0)
-- Dependencies: 236
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- TOC entry 216 (class 1259 OID 25019)
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 25018)
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organizations_id_seq OWNER TO postgres;

--
-- TOC entry 3476 (class 0 OID 0)
-- Dependencies: 215
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- TOC entry 214 (class 1259 OID 24985)
-- Name: persons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persons (
    personid integer,
    lastname character varying(255),
    firstname character varying(255),
    address character varying(255),
    city character varying(255)
);


ALTER TABLE public.persons OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 25131)
-- Name: public_status_pages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.public_status_pages (
    id integer NOT NULL,
    organization_id integer,
    custom_domain character varying(255),
    is_enabled boolean DEFAULT true
);


ALTER TABLE public.public_status_pages OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25130)
-- Name: public_status_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.public_status_pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.public_status_pages_id_seq OWNER TO postgres;

--
-- TOC entry 3477 (class 0 OID 0)
-- Dependencies: 219
-- Name: public_status_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.public_status_pages_id_seq OWNED BY public.public_status_pages.id;


--
-- TOC entry 231 (class 1259 OID 25254)
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id integer NOT NULL,
    team_id integer,
    name character varying(100) NOT NULL,
    description text,
    current_status public.service_status DEFAULT 'Operational'::public.service_status
);


ALTER TABLE public.services OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 25253)
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.services_id_seq OWNER TO postgres;

--
-- TOC entry 3478 (class 0 OID 0)
-- Dependencies: 230
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- TOC entry 235 (class 1259 OID 25304)
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    user_id character varying(50) NOT NULL,
    service_id integer NOT NULL
);


ALTER TABLE public.subscriptions OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 25303)
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscriptions_id_seq OWNER TO postgres;

--
-- TOC entry 3479 (class 0 OID 0)
-- Dependencies: 234
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- TOC entry 225 (class 1259 OID 25178)
-- Name: team_memberships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_memberships (
    id integer NOT NULL,
    team_id integer,
    user_id character varying(50),
    role character varying(50) DEFAULT 'member'::character varying,
    membership_status boolean DEFAULT false
);


ALTER TABLE public.team_memberships OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25177)
-- Name: team_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.team_memberships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_memberships_id_seq OWNER TO postgres;

--
-- TOC entry 3480 (class 0 OID 0)
-- Dependencies: 224
-- Name: team_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.team_memberships_id_seq OWNED BY public.team_memberships.id;


--
-- TOC entry 223 (class 1259 OID 25166)
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    organization_id integer
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25165)
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_id_seq OWNER TO postgres;

--
-- TOC entry 3481 (class 0 OID 0)
-- Dependencies: 222
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- TOC entry 227 (class 1259 OID 25196)
-- Name: user_organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_organizations (
    id integer NOT NULL,
    user_id character varying(50),
    organization_id integer,
    role character varying(50) DEFAULT 'member'::character varying
);


ALTER TABLE public.user_organizations OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 25195)
-- Name: user_organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_organizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_organizations_id_seq OWNER TO postgres;

--
-- TOC entry 3482 (class 0 OID 0)
-- Dependencies: 226
-- Name: user_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_organizations_id_seq OWNED BY public.user_organizations.id;


--
-- TOC entry 221 (class 1259 OID 25154)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id character varying(50) NOT NULL,
    firstname character varying(100) NOT NULL,
    lastname character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    role character varying(50) DEFAULT 'member'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    organization_id integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 3239 (class 2604 OID 25097)
-- Name: incident_service_links id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_service_links ALTER COLUMN id SET DEFAULT nextval('public.incident_service_links_id_seq'::regclass);


--
-- TOC entry 3255 (class 2604 OID 25292)
-- Name: incident_updates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_updates ALTER COLUMN id SET DEFAULT nextval('public.incident_updates_id_seq'::regclass);


--
-- TOC entry 3250 (class 2604 OID 25241)
-- Name: incidents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents ALTER COLUMN id SET DEFAULT nextval('public.incidents_id_seq'::regclass);


--
-- TOC entry 3258 (class 2604 OID 25344)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 3237 (class 2604 OID 25022)
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- TOC entry 3240 (class 2604 OID 25134)
-- Name: public_status_pages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_status_pages ALTER COLUMN id SET DEFAULT nextval('public.public_status_pages_id_seq'::regclass);


--
-- TOC entry 3253 (class 2604 OID 25257)
-- Name: services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- TOC entry 3257 (class 2604 OID 25307)
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- TOC entry 3245 (class 2604 OID 25181)
-- Name: team_memberships id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_memberships ALTER COLUMN id SET DEFAULT nextval('public.team_memberships_id_seq'::regclass);


--
-- TOC entry 3244 (class 2604 OID 25236)
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- TOC entry 3248 (class 2604 OID 25199)
-- Name: user_organizations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_organizations ALTER COLUMN id SET DEFAULT nextval('public.user_organizations_id_seq'::regclass);


--
-- TOC entry 3447 (class 0 OID 25094)
-- Dependencies: 218
-- Data for Name: incident_service_links; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident_service_links (id, incident_id, service_id) FROM stdin;
11	13	1
12	14	2
13	15	1
14	16	1
15	17	3
16	18	3
17	19	2
18	20	2
19	21	1
20	22	6
21	23	7
22	24	6
23	25	1
24	26	1
25	27	5
26	28	1
27	29	1
28	30	2
29	31	2
30	32	2
31	33	8
32	34	8
33	35	8
34	36	2
\.


--
-- TOC entry 3462 (class 0 OID 25289)
-- Dependencies: 233
-- Data for Name: incident_updates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident_updates (id, incident_id, message, status, "timestamp") FROM stdin;
1	20	no message	Open	2025-05-24 10:03:54.451812
2	16	blah blah blah	In Progress	2025-05-24 15:38:28.230781
3	18		In Progress	2025-05-24 15:38:45.759969
4	21	omg 2nd incident	Open	2025-05-24 15:57:39.31354
5	21	omg 2nd incident	In Progress	2025-05-24 15:58:17.800551
6	21	omg 2nd incident	Resolved	2025-05-24 15:58:48.57116
7	22		Open	2025-05-24 18:27:34.593755
8	23		Open	2025-05-24 18:28:57.400051
9	24		In Progress	2025-05-24 19:12:28.876088
10	25		Open	2025-05-24 19:30:16.016873
11	26		Open	2025-05-24 19:32:26.028713
12	27		In Progress	2025-05-24 19:36:20.237021
13	28		Open	2025-05-24 20:31:37.198245
14	29		Open	2025-05-24 20:43:13.745557
15	30		Open	2025-05-24 20:45:08.843612
16	31		Open	2025-05-24 20:45:56.76823
17	32		Open	2025-05-24 20:47:07.869573
18	26		Open	2025-05-24 20:51:43.300815
19	33		Open	2025-05-24 20:54:01.485357
20	34		Open	2025-05-24 20:54:41.886068
21	35		Open	2025-05-24 20:57:22.770311
22	36	nd	Open	2025-05-24 21:55:53.523242
\.


--
-- TOC entry 3458 (class 0 OID 25238)
-- Dependencies: 229
-- Data for Name: incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incidents (id, title, description, organization_id, status, is_scheduled_maintenance, start_time, end_time, created_by_user_id) FROM stdin;
13	check incident		1	Resolved	t	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
14	jnsd nsl		1	Open	t	2025-05-14 14:52:00	2025-05-21 14:52:00	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
15	hello check bye		1	In Progress	f	\N	2025-05-18 14:55:00	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
17	wanna check	wanna check	1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
19	k3	k3	1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
20	l1		1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
16	wanna get update	blah blah blah	1	In Progress	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
18	k2		1	In Progress	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
21	2nd incident	omg 2nd incident	1	Resolved	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
22	wwerkf		16	Open	f	\N	\N	user_2xXefPx0rwxJbKvgay0L9ThRdpL
23	badi probelm		16	Open	f	\N	\N	user_2xXefPx0rwxJbKvgay0L9ThRdpL
24	somthing		16	In Progress	f	\N	\N	user_2xXefPx0rwxJbKvgay0L9ThRdpL
25	web socket		1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
26	checkkkk		1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
27	heabby damage		1	In Progress	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
28	sucker		1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
29	full make in indea		1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
30	snapchat		1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
31	chattttt		1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
32	sc		1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
33	chalja bhai dinner chahiye		1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
34	i want dinner		1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
35	wanna eat		1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
36	sona hai	nd	1	Open	f	\N	\N	user_2xSkiTJLqXV1lE6uM7fjE50tpGw
\.


--
-- TOC entry 3466 (class 0 OID 25341)
-- Dependencies: 237
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, message, "timestamp", service_name) FROM stdin;
1	user_2xXefPx0rwxJbKvgay0L9ThRdpL	New incident: wanna eat	2025-05-24 20:57:22.772966	dinner
2	user_2xSkiTJLqXV1lE6uM7fjE50tpGw	New incident: sona hai	2025-05-24 21:55:53.526806	by member
\.


--
-- TOC entry 3445 (class 0 OID 25019)
-- Dependencies: 216
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (id, name, created_at) FROM stdin;
1	Tech Corp	2025-05-22 21:53:04.098399
16	ashby	2025-05-24 18:25:08.690096
\.


--
-- TOC entry 3443 (class 0 OID 24985)
-- Dependencies: 214
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persons (personid, lastname, firstname, address, city) FROM stdin;
\.


--
-- TOC entry 3449 (class 0 OID 25131)
-- Dependencies: 220
-- Data for Name: public_status_pages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.public_status_pages (id, organization_id, custom_domain, is_enabled) FROM stdin;
1	1	status.techcorp.com	t
\.


--
-- TOC entry 3460 (class 0 OID 25254)
-- Dependencies: 231
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, team_id, name, description, current_status) FROM stdin;
1	2	check hello bye	checking	Degraded Performance
2	8	by member		Major Outage
3	8	w	hefbwjkkmeldnje	Partial Outage
6	15	winter	ww	Degraded Performance
7	15	kmm	kmm	Operational
5	1	d		Partial Outage
4	1	chal ja meri jaan	wdwa	Partial Outage
8	8	dinner	dinner	Degraded Performance
\.


--
-- TOC entry 3464 (class 0 OID 25304)
-- Dependencies: 235
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriptions (id, user_id, service_id) FROM stdin;
2	user_2xSkiTJLqXV1lE6uM7fjE50tpGw	6
5	user_2xXefPx0rwxJbKvgay0L9ThRdpL	6
6	user_2xXefPx0rwxJbKvgay0L9ThRdpL	6
7	user_2xXefPx0rwxJbKvgay0L9ThRdpL	6
8	user_2xXefPx0rwxJbKvgay0L9ThRdpL	6
9	user_2xXefPx0rwxJbKvgay0L9ThRdpL	6
10	user_2xXefPx0rwxJbKvgay0L9ThRdpL	6
11	user_2xXefPx0rwxJbKvgay0L9ThRdpL	3
12	user_2xXefPx0rwxJbKvgay0L9ThRdpL	7
13	user_2xXefPx0rwxJbKvgay0L9ThRdpL	1
14	user_2xXefPx0rwxJbKvgay0L9ThRdpL	5
15	user_2xXefPx0rwxJbKvgay0L9ThRdpL	4
16	user_2xXefPx0rwxJbKvgay0L9ThRdpL	1
17	user_2xXefPx0rwxJbKvgay0L9ThRdpL	1
18	user_2xXefPx0rwxJbKvgay0L9ThRdpL	1
19	user_2xSkiTJLqXV1lE6uM7fjE50tpGw	2
20	user_2xXefPx0rwxJbKvgay0L9ThRdpL	8
21	user_2xSkiTJLqXV1lE6uM7fjE50tpGw	8
\.


--
-- TOC entry 3454 (class 0 OID 25178)
-- Dependencies: 225
-- Data for Name: team_memberships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_memberships (id, team_id, user_id, role, membership_status) FROM stdin;
4	8	user_2xWuoP1y9JQ4zYTzNtMhPy3nIiM	member	t
5	1	user_2xWuoP1y9JQ4zYTzNtMhPy3nIiM	member	t
\.


--
-- TOC entry 3452 (class 0 OID 25166)
-- Dependencies: 223
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teams (id, name, organization_id) FROM stdin;
2	www	1
1	my team ok	1
8	WHAT THE HELL	1
15	white	16
\.


--
-- TOC entry 3456 (class 0 OID 25196)
-- Dependencies: 227
-- Data for Name: user_organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_organizations (id, user_id, organization_id, role) FROM stdin;
\.


--
-- TOC entry 3450 (class 0 OID 25154)
-- Dependencies: 221
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, firstname, lastname, email, role, created_at, organization_id) FROM stdin;
user_2xSkiTJLqXV1lE6uM7fjE50tpGw	Vatsal	Balasra	balasravatsal@gmail.com	admin	2025-05-23 02:55:32.594225	1
user_2xWuoP1y9JQ4zYTzNtMhPy3nIiM	Bhavika	Balasra	bhavikabalasra12@gmail.com	member	2025-05-24 11:29:07.696471	1
user_2xXefPx0rwxJbKvgay0L9ThRdpL	VV	BB	vatsalbalasra247@gmail.com	admin	2025-05-24 18:25:08.691997	16
user_2xY9CROxxq0i9nGwqorTYXaZOty	vat	sal	vatsalbalasra24@gmail.com	member	2025-05-24 21:57:14.875587	\N
\.


--
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 217
-- Name: incident_service_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incident_service_links_id_seq', 34, true);


--
-- TOC entry 3484 (class 0 OID 0)
-- Dependencies: 232
-- Name: incident_updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incident_updates_id_seq', 22, true);


--
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 228
-- Name: incidents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incidents_id_seq', 36, true);


--
-- TOC entry 3486 (class 0 OID 0)
-- Dependencies: 236
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 2, true);


--
-- TOC entry 3487 (class 0 OID 0)
-- Dependencies: 215
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organizations_id_seq', 16, true);


--
-- TOC entry 3488 (class 0 OID 0)
-- Dependencies: 219
-- Name: public_status_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.public_status_pages_id_seq', 1, true);


--
-- TOC entry 3489 (class 0 OID 0)
-- Dependencies: 230
-- Name: services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_id_seq', 8, true);


--
-- TOC entry 3490 (class 0 OID 0)
-- Dependencies: 234
-- Name: subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subscriptions_id_seq', 21, true);


--
-- TOC entry 3491 (class 0 OID 0)
-- Dependencies: 224
-- Name: team_memberships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.team_memberships_id_seq', 12, true);


--
-- TOC entry 3492 (class 0 OID 0)
-- Dependencies: 222
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teams_id_seq', 15, true);


--
-- TOC entry 3493 (class 0 OID 0)
-- Dependencies: 226
-- Name: user_organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_organizations_id_seq', 1, false);


--
-- TOC entry 3263 (class 2606 OID 25099)
-- Name: incident_service_links incident_service_links_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_service_links
    ADD CONSTRAINT incident_service_links_pkey PRIMARY KEY (id);


--
-- TOC entry 3283 (class 2606 OID 25297)
-- Name: incident_updates incident_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_updates
    ADD CONSTRAINT incident_updates_pkey PRIMARY KEY (id);


--
-- TOC entry 3279 (class 2606 OID 25247)
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);


--
-- TOC entry 3287 (class 2606 OID 25349)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 3261 (class 2606 OID 25025)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 3265 (class 2606 OID 25137)
-- Name: public_status_pages public_status_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_status_pages
    ADD CONSTRAINT public_status_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 3281 (class 2606 OID 25262)
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- TOC entry 3285 (class 2606 OID 25309)
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 3273 (class 2606 OID 25184)
-- Name: team_memberships team_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_pkey PRIMARY KEY (id);


--
-- TOC entry 3271 (class 2606 OID 25171)
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- TOC entry 3275 (class 2606 OID 25202)
-- Name: user_organizations user_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_organizations
    ADD CONSTRAINT user_organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 3277 (class 2606 OID 25204)
-- Name: user_organizations user_organizations_user_id_organization_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_organizations
    ADD CONSTRAINT user_organizations_user_id_organization_id_key UNIQUE (user_id, organization_id);


--
-- TOC entry 3267 (class 2606 OID 25162)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3269 (class 2606 OID 25160)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3289 (class 2606 OID 25215)
-- Name: users fk_users_organization; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_organization FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE SET NULL;


--
-- TOC entry 3297 (class 2606 OID 25298)
-- Name: incident_updates incident_updates_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_updates
    ADD CONSTRAINT incident_updates_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id) ON DELETE CASCADE;


--
-- TOC entry 3295 (class 2606 OID 25248)
-- Name: incidents incidents_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 3300 (class 2606 OID 25350)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3288 (class 2606 OID 25138)
-- Name: public_status_pages public_status_pages_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_status_pages
    ADD CONSTRAINT public_status_pages_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 3296 (class 2606 OID 25263)
-- Name: services services_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- TOC entry 3298 (class 2606 OID 25315)
-- Name: subscriptions subscriptions_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- TOC entry 3299 (class 2606 OID 25310)
-- Name: subscriptions subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3291 (class 2606 OID 25185)
-- Name: team_memberships team_memberships_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- TOC entry 3292 (class 2606 OID 25190)
-- Name: team_memberships team_memberships_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3290 (class 2606 OID 25172)
-- Name: teams teams_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- TOC entry 3293 (class 2606 OID 25210)
-- Name: user_organizations user_organizations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_organizations
    ADD CONSTRAINT user_organizations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 3294 (class 2606 OID 25205)
-- Name: user_organizations user_organizations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_organizations
    ADD CONSTRAINT user_organizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2025-05-24 22:57:41

--
-- PostgreSQL database dump complete
--

