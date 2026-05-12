--
-- PostgreSQL database dump
--

\restrict Hc1NuVnYPdh5fveJMJACPBwlOuuBhf7SkQdQcVnyQ0bRkV7HAHjJ0RDeZQqVJtO

-- Dumped from database version 18.3 (Debian 18.3-1.pgdg13+1)
-- Dumped by pg_dump version 18.3 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.quizzes DROP CONSTRAINT IF EXISTS quizzes_campaign_id_fkey;
ALTER TABLE IF EXISTS ONLY public.quiz_responses DROP CONSTRAINT IF EXISTS quiz_responses_quiz_id_fkey;
ALTER TABLE IF EXISTS ONLY public.settings DROP CONSTRAINT IF EXISTS settings_pkey;
ALTER TABLE IF EXISTS ONLY public.reminders DROP CONSTRAINT IF EXISTS reminders_pkey;
ALTER TABLE IF EXISTS ONLY public.quizzes DROP CONSTRAINT IF EXISTS quizzes_pkey;
ALTER TABLE IF EXISTS ONLY public.quiz_responses DROP CONSTRAINT IF EXISTS quiz_responses_quiz_id_phone_key;
ALTER TABLE IF EXISTS ONLY public.quiz_responses DROP CONSTRAINT IF EXISTS quiz_responses_pkey;
ALTER TABLE IF EXISTS ONLY public.messages_log DROP CONSTRAINT IF EXISTS messages_log_wa_msg_id_key;
ALTER TABLE IF EXISTS ONLY public.messages_log DROP CONSTRAINT IF EXISTS messages_log_pkey;
ALTER TABLE IF EXISTS ONLY public.leave_requests DROP CONSTRAINT IF EXISTS leave_requests_pkey;
ALTER TABLE IF EXISTS ONLY public.leads DROP CONSTRAINT IF EXISTS leads_pkey;
ALTER TABLE IF EXISTS ONLY public.faqs DROP CONSTRAINT IF EXISTS faqs_pkey;
ALTER TABLE IF EXISTS ONLY public.employees DROP CONSTRAINT IF EXISTS employees_pkey;
ALTER TABLE IF EXISTS ONLY public.employees DROP CONSTRAINT IF EXISTS employees_phone_key;
ALTER TABLE IF EXISTS ONLY public.customer_queries DROP CONSTRAINT IF EXISTS customer_queries_pkey;
ALTER TABLE IF EXISTS ONLY public.contacts DROP CONSTRAINT IF EXISTS contacts_pkey;
ALTER TABLE IF EXISTS ONLY public.contacts DROP CONSTRAINT IF EXISTS contacts_phone_key;
ALTER TABLE IF EXISTS ONLY public.campaigns DROP CONSTRAINT IF EXISTS campaigns_pkey;
ALTER TABLE IF EXISTS ONLY public.callbacks DROP CONSTRAINT IF EXISTS callbacks_pkey;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_pkey;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_phone_date_key;
ALTER TABLE IF EXISTS public.reminders ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.quizzes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.quiz_responses ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.messages_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.leave_requests ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.leads ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.faqs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.employees ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.customer_queries ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.contacts ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.campaigns ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.callbacks ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.attendance ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.settings;
DROP SEQUENCE IF EXISTS public.reminders_id_seq;
DROP TABLE IF EXISTS public.reminders;
DROP SEQUENCE IF EXISTS public.quizzes_id_seq;
DROP TABLE IF EXISTS public.quizzes;
DROP SEQUENCE IF EXISTS public.quiz_responses_id_seq;
DROP TABLE IF EXISTS public.quiz_responses;
DROP SEQUENCE IF EXISTS public.messages_log_id_seq;
DROP TABLE IF EXISTS public.messages_log;
DROP SEQUENCE IF EXISTS public.leave_requests_id_seq;
DROP TABLE IF EXISTS public.leave_requests;
DROP SEQUENCE IF EXISTS public.leads_id_seq;
DROP TABLE IF EXISTS public.leads;
DROP SEQUENCE IF EXISTS public.faqs_id_seq;
DROP TABLE IF EXISTS public.faqs;
DROP SEQUENCE IF EXISTS public.employees_id_seq;
DROP TABLE IF EXISTS public.employees;
DROP SEQUENCE IF EXISTS public.customer_queries_id_seq;
DROP TABLE IF EXISTS public.customer_queries;
DROP SEQUENCE IF EXISTS public.contacts_id_seq;
DROP TABLE IF EXISTS public.contacts;
DROP SEQUENCE IF EXISTS public.campaigns_id_seq;
DROP TABLE IF EXISTS public.campaigns;
DROP SEQUENCE IF EXISTS public.callbacks_id_seq;
DROP TABLE IF EXISTS public.callbacks;
DROP SEQUENCE IF EXISTS public.attendance_id_seq;
DROP TABLE IF EXISTS public.attendance;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    id integer NOT NULL,
    phone text NOT NULL,
    check_in timestamp without time zone,
    check_out timestamp without time zone,
    check_in_lat double precision,
    check_in_lng double precision,
    check_out_lat double precision,
    check_out_lng double precision,
    work_plan text,
    eod_report text,
    date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_id_seq OWNER TO postgres;

--
-- Name: attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_id_seq OWNED BY public.attendance.id;


--
-- Name: callbacks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.callbacks (
    id integer NOT NULL,
    phone character varying,
    name character varying,
    preferred_time character varying,
    status character varying DEFAULT 'pending'::character varying,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.callbacks OWNER TO postgres;

--
-- Name: callbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.callbacks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.callbacks_id_seq OWNER TO postgres;

--
-- Name: callbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.callbacks_id_seq OWNED BY public.callbacks.id;


--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaigns (
    id integer NOT NULL,
    type character varying NOT NULL,
    question text,
    option_a character varying(255),
    option_b character varying(255),
    option_c character varying(255),
    correct_answer character(1),
    explanation text,
    youtube_link character varying(255),
    image_url character varying(255),
    caption text,
    scheduled_at timestamp without time zone NOT NULL,
    status character varying DEFAULT 'scheduled'::character varying,
    total_sent integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.campaigns OWNER TO postgres;

--
-- Name: campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.campaigns_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.campaigns_id_seq OWNER TO postgres;

--
-- Name: campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.campaigns_id_seq OWNED BY public.campaigns.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contacts (
    id integer NOT NULL,
    phone character varying,
    name character varying,
    company character varying,
    joined_at timestamp without time zone DEFAULT now(),
    opt_out boolean DEFAULT false
);


ALTER TABLE public.contacts OWNER TO postgres;

--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contacts_id_seq OWNER TO postgres;

--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;


--
-- Name: customer_queries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_queries (
    id integer NOT NULL,
    phone character varying,
    name character varying,
    category character varying,
    original_message text,
    status character varying DEFAULT 'open'::character varying,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.customer_queries OWNER TO postgres;

--
-- Name: customer_queries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_queries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_queries_id_seq OWNER TO postgres;

--
-- Name: customer_queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_queries_id_seq OWNED BY public.customer_queries.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    name text NOT NULL,
    phone text NOT NULL,
    role text DEFAULT 'employee'::text
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_id_seq OWNER TO postgres;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: faqs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faqs (
    id integer NOT NULL,
    keywords text NOT NULL,
    answer text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.faqs OWNER TO postgres;

--
-- Name: faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faqs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faqs_id_seq OWNER TO postgres;

--
-- Name: faqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faqs_id_seq OWNED BY public.faqs.id;


--
-- Name: leads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leads (
    id integer NOT NULL,
    phone character varying,
    name character varying,
    company character varying,
    requirement text,
    contact_phone character varying,
    status character varying DEFAULT 'new'::character varying,
    notes text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.leads OWNER TO postgres;

--
-- Name: leads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leads_id_seq OWNER TO postgres;

--
-- Name: leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leads_id_seq OWNED BY public.leads.id;


--
-- Name: leave_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_requests (
    id integer NOT NULL,
    phone text NOT NULL,
    leave_type text,
    leave_date text,
    reason text,
    status text DEFAULT 'Pending'::text
);


ALTER TABLE public.leave_requests OWNER TO postgres;

--
-- Name: leave_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leave_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leave_requests_id_seq OWNER TO postgres;

--
-- Name: leave_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leave_requests_id_seq OWNED BY public.leave_requests.id;


--
-- Name: messages_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages_log (
    id integer NOT NULL,
    phone character varying,
    direction character varying,
    message text,
    wa_msg_id character varying,
    sent_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.messages_log OWNER TO postgres;

--
-- Name: messages_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.messages_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messages_log_id_seq OWNER TO postgres;

--
-- Name: messages_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_log_id_seq OWNED BY public.messages_log.id;


--
-- Name: quiz_responses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quiz_responses (
    id integer NOT NULL,
    quiz_id integer,
    phone character varying NOT NULL,
    answer character(1) NOT NULL,
    is_correct boolean NOT NULL,
    responded_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.quiz_responses OWNER TO postgres;

--
-- Name: quiz_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quiz_responses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quiz_responses_id_seq OWNER TO postgres;

--
-- Name: quiz_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quiz_responses_id_seq OWNED BY public.quiz_responses.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quizzes (
    id integer NOT NULL,
    campaign_id integer,
    question text NOT NULL,
    option_a character varying(255) NOT NULL,
    option_b character varying(255) NOT NULL,
    option_c character varying(255) NOT NULL,
    correct_answer character(1) NOT NULL,
    explanation text,
    youtube_link character varying(255),
    is_active boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.quizzes OWNER TO postgres;

--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quizzes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quizzes_id_seq OWNER TO postgres;

--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quizzes_id_seq OWNED BY public.quizzes.id;


--
-- Name: reminders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reminders (
    id integer NOT NULL,
    employee_phone text NOT NULL,
    description text NOT NULL,
    due_at timestamp without time zone NOT NULL,
    status text DEFAULT 'Pending'::text
);


ALTER TABLE public.reminders OWNER TO postgres;

--
-- Name: reminders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reminders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reminders_id_seq OWNER TO postgres;

--
-- Name: reminders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reminders_id_seq OWNED BY public.reminders.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    key text NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- Name: attendance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance ALTER COLUMN id SET DEFAULT nextval('public.attendance_id_seq'::regclass);


--
-- Name: callbacks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.callbacks ALTER COLUMN id SET DEFAULT nextval('public.callbacks_id_seq'::regclass);


--
-- Name: campaigns id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaigns ALTER COLUMN id SET DEFAULT nextval('public.campaigns_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: customer_queries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_queries ALTER COLUMN id SET DEFAULT nextval('public.customer_queries_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: faqs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faqs ALTER COLUMN id SET DEFAULT nextval('public.faqs_id_seq'::regclass);


--
-- Name: leads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads ALTER COLUMN id SET DEFAULT nextval('public.leads_id_seq'::regclass);


--
-- Name: leave_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests ALTER COLUMN id SET DEFAULT nextval('public.leave_requests_id_seq'::regclass);


--
-- Name: messages_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages_log ALTER COLUMN id SET DEFAULT nextval('public.messages_log_id_seq'::regclass);


--
-- Name: quiz_responses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_responses ALTER COLUMN id SET DEFAULT nextval('public.quiz_responses_id_seq'::regclass);


--
-- Name: quizzes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);


--
-- Name: reminders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reminders ALTER COLUMN id SET DEFAULT nextval('public.reminders_id_seq'::regclass);


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (id, phone, check_in, check_out, check_in_lat, check_in_lng, check_out_lat, check_out_lng, work_plan, eod_report, date) FROM stdin;
\.


--
-- Data for Name: callbacks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.callbacks (id, phone, name, preferred_time, status, created_at) FROM stdin;
\.


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.campaigns (id, type, question, option_a, option_b, option_c, correct_answer, explanation, youtube_link, image_url, caption, scheduled_at, status, total_sent, created_at) FROM stdin;
\.


--
-- Data for Name: contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contacts (id, phone, name, company, joined_at, opt_out) FROM stdin;
1000	919000596952	Galam Obulesu Yadav	\N	2026-05-06 04:43:50.845547	f
1025	919000736254	Rakesh	Va.electricals	2026-05-06 06:14:32.878141	f
1	918310029635	srujan	\N	2026-04-27 04:14:57.441222	f
564	919618307057	Reddy	\N	2026-04-28 07:21:37.917151	f
596	918123054064	NATURE'S	\N	2026-04-28 13:10:11.534596	f
639	919686699872	🎶Guru🎶	\N	2026-04-28 13:26:15.456562	f
33	918125163407	Askworx.in	\N	2026-04-27 04:22:42.42392	f
494	918147577824		\N	2026-04-28 05:01:33.330194	f
909	917058069655		\N	2026-05-04 05:25:28.610753	f
319	917559053238		\N	2026-04-28 02:36:42.921977	f
16	919652759166		\N	2026-04-27 04:15:36.113641	f
51	918367518556		\N	2026-04-27 04:30:41.162773	f
422	919666543876		\N	2026-04-28 04:25:29.733072	f
229	919182396962		\N	2026-04-27 05:40:51.069792	f
334	919535903904		\N	2026-04-28 03:31:34.328317	f
502	918088693950		\N	2026-04-28 05:45:06.647362	f
266	919663261122		\N	2026-04-27 07:20:22.695128	f
498	919902314980		\N	2026-04-28 05:35:17.281873	f
736	919355777526		\N	2026-04-29 07:19:10.735362	f
261	919187458714		\N	2026-04-27 06:50:29.395504	f
939	912244066666		\N	2026-05-05 10:47:17.93542	f
1327	917289047171		\N	2026-05-09 11:47:32.179589	f
75	919701288041		\N	2026-04-27 04:55:19.529351	f
251	918217822332		\N	2026-04-27 05:59:40.678093	f
52	919030108949		\N	2026-04-27 04:40:13.774361	f
270	918147456955	Srujan	\N	2026-04-27 07:26:41.018295	t
1160	919160969446	Samba Shiva	SR Automations	2026-05-07 07:32:05.107811	f
1193	919949306860	Sudhakar Telugu	\N	2026-05-07 11:23:27.504999	f
1197	919035977090	Sandesh Kotte	\N	2026-05-07 15:01:41.149005	f
1207	919844095004	Anil Purohit	\N	2026-05-07 15:05:44.968654	f
71	917676776845	Suma	SRA	2026-04-27 04:52:43.912645	f
440	919900803001	Sarath Reddy K	\N	2026-04-28 04:31:46.270834	f
230	919032173158	Ankush.Punse	\N	2026-04-27 05:42:57.025285	f
735	9030108949	shravan Kumar	\N	2026-04-29 04:25:35.878776	f
943	919912312716	Sharath Kumar Amma	\N	2026-05-05 16:04:08.851849	f
958	919666773015	Praveen PJ	\N	2026-05-05 16:05:05.123275	f
1074	917075813424	Madhuri Ganji	\N	2026-05-06 13:43:10.66444	f
406	918019731640	udaykiran	\N	2026-04-28 04:23:29.579691	f
1424	919880564894	Silent Heart	\N	2026-05-10 17:01:25.59091	f
\.


--
-- Data for Name: customer_queries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_queries (id, phone, name, category, original_message, status, created_at) FROM stdin;
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (id, name, phone, role) FROM stdin;
\.


--
-- Data for Name: faqs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faqs (id, keywords, answer, created_at) FROM stdin;
1	what do you do, what is askworx, who are you, about askworx	ASKworX Smart Automation LLP provides end-to-end industrial automation — PLC & SCADA engineering, IIoT, cloud analytics, robotics, and digital software. 🏭\n\n🌐 www.askworx.in | 📞 +919187458714	2026-04-25 09:05:24.975712
2	plc, programmable logic controller	We design & commission complete PLC systems — Micro PLCs, Motion Controllers, VFDs, Safety PLCs, and AC Servo Drives for Automotive, Pharma, Food & Beverage, and more. ⚡	2026-04-25 09:05:24.980751
3	scada, hmi, supervisory control	We develop full SCADA & HMI systems with real-time monitoring, alarming, historical trending, and multi-site remote access using platforms like MC Works64. 🖥️	2026-04-25 09:05:24.985645
4	robot, robotics, cobot, collaborative robot	We integrate industrial robots and cobots for welding, assembly, pick & place, and palletizing with full commissioning & after-sales support. 🤖	2026-04-25 09:05:24.994013
5	iiot, industrial iot, iot gateway, mqtt, opc-ua, modbus	Our IIoT solutions connect your machines to the cloud via OPC-UA, Modbus, and MQTT with secure edge computing and real-time dashboards. ☁️	2026-04-25 09:05:24.999006
6	atex, hazardous area, explosion proof	We supply and support ATEX-certified instruments for hazardous area classifications. Contact our team for specific product recommendations. 🔒\n\n📞 +919187458714	2026-04-25 09:05:25.003934
7	price, pricing, cost, how much, quote, quotation	Our pricing is tailored to your project scope. We deliver a detailed proposal within 24 hours. 💬	2026-04-25 09:05:25.008853
8	contact, phone number, email, address, office, location	📞 +919187458714\n📧 contact@askworx.in\n🌐 www.askworx.in\n📍 1381, 6th Main Road, RR Nagar, Bangalore — 560098	2026-04-25 09:05:25.013623
9	whatsapp bot, chatbot, wa bot, automation bot	We build AI-powered WhatsApp Business bots with CRM integration, lead capture, broadcast scheduling, and a multi-agent admin dashboard. 📱	2026-04-25 09:05:25.019104
10	website, web app, mobile app, app development, flutter, react	We build Progressive Web Apps, mobile apps (Flutter/React Native), corporate sites, and enterprise ERP/MES software. 🌐	2026-04-25 09:05:25.024034
11	what do you do, what is askworx, who are you, about askworx	ASKworX Smart Automation LLP provides end-to-end industrial automation — PLC & SCADA engineering, IIoT, cloud analytics, robotics, and digital software. 🏭\n\n🌐 www.askworx.in | 📞 +919030108949	2026-04-27 04:11:54.066916
12	atex, hazardous area, explosion proof	We supply and support ATEX-certified instruments for hazardous area classifications. Contact our team for specific product recommendations. 🔒\n\n📞 +919030108949	2026-04-27 04:11:55.684738
13	contact, phone number, email, address, office, location	📞 +919030108949\n📧 contact@askworx.in\n🌐 www.askworx.in\n📍 1381, 6th Main Road, RR Nagar, Bangalore — 560098	2026-04-27 04:11:56.169451
\.


--
-- Data for Name: leads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leads (id, phone, name, company, requirement, contact_phone, status, notes, created_at) FROM stdin;
1	917676776845	Suma	SRA	Technical Query: Industrial Automation / PLC / ATEX	11:02am	converted	\N	2026-04-27 05:30:55.652842
2	919000736254	Rakesh	Va.electricals	Service Request: Industrial Automation / PLC / ATEX	1	new	\N	2026-05-06 06:16:06.828495
3	919160969446	Samba Shiva	SR Automations	Service Request: Digital Marketing & SEO	Now	new	\N	2026-05-07 07:33:46.600379
\.


--
-- Data for Name: leave_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_requests (id, phone, leave_type, leave_date, reason, status) FROM stdin;
\.


--
-- Data for Name: messages_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages_log (id, phone, direction, message, wa_msg_id, sent_at) FROM stdin;
1	918310029635	incoming	Hello ASKworX Support, I need assistance with your industrial platform.	wamid.HBgMOTE4MzEwMDI5NjM1FQIAEhgUM0JCN0QxNTJCRTIxQzJCRkY1RjEA	2026-04-27 04:14:57.456535
2	918310029635	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-04-27 04:14:57.996489
3	918310029635	incoming	917892943426	wamid.HBgMOTE4MzEwMDI5NjM1FQIAEhgUM0I1MDUxNDJFQzdCRkY2OERBQUQA	2026-04-27 04:15:10.866942
4	918310029635	outgoing	Let me connect you with our team for this.	\N	2026-04-27 04:15:11.268193
5	918310029635	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-04-27 04:15:11.638632
6	919652759166	incoming	main_menu	wamid.HBgMOTE5NjUyNzU5MTY2FQIAEhggQTUyRjNGOURFODg2NzdCRkJDQkM4MkM4NUQ3M0NFNDcA	2026-04-27 04:15:38.543452
7	919652759166	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 04:15:38.988379
8	919652759166	incoming	our_solutions	wamid.HBgMOTE5NjUyNzU5MTY2FQIAEhggQTVFRjRERUIyNTIxRjMyQzREMjY5RDFBRDAwMzc4RTcA	2026-04-27 04:16:11.0824
9	919652759166	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-27 04:16:11.542456
10	919652759166	incoming	iiot_analytics	wamid.HBgMOTE5NjUyNzU5MTY2FQIAEhggQTU0NUU1NzI3RUM0NzY1MURCOEQ5NDhBNjU2NDVEMTIA	2026-04-27 04:16:24.386273
11	919652759166	outgoing	[Image: https://images.unsplash.com/photo-1518770660439-4636190af475?w=800] 📊 IIoT & Analytics Solutions\nConnecting your plant to the cloud.\n\nSelect a service:	\N	2026-04-27 04:16:24.853004
12	919652759166	incoming	cloud_analytics	wamid.HBgMOTE5NjUyNzU5MTY2FQIAEhggQTUwMDYzMTZDNjM3QUYyN0RCQTYwRUQ3MjQ0N0IyNDcA	2026-04-27 04:16:31.235374
13	919652759166	outgoing	[Image: https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800] ☁️ Cloud Insights & Analytics\nTransforming Data into Operational Intelligence\n\n✅ Real-time production dashboards\n✅ OEE tracking & reporting\n✅ Predictive maintenance alerts\n✅ Energy consumption monitoring\n\n📊 Our customers achieve 99.9% visibility.	\N	2026-04-27 04:16:31.674152
14	918310029635	incoming	Hello ASKworX Support, I need assistance with your industrial platform.	wamid.HBgMOTE4MzEwMDI5NjM1FQIAEhgUM0I0MDk4NzhGQjhEMTA3RjI3NDYA	2026-04-27 04:22:44.111166
15	918310029635	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-04-27 04:22:44.739335
16	918310029635	incoming	Hello ASKworX Support, I need assistance with your industrial platform.	wamid.HBgMOTE4MzEwMDI5NjM1FQIAEhgUM0IxRTY5RjIyMzJFRjg4OURBQzYA	2026-04-27 04:22:48.22198
17	918310029635	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 04:22:48.771905
18	918310029635	incoming	Hello ASKworX Support, I need assistance with your industrial platform.	wamid.HBgMOTE4MzEwMDI5NjM1FQIAEhgUM0IyOTE1RUE1MUQzQjU2NDZDMUIA	2026-04-27 04:22:55.896189
19	918310029635	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 04:22:56.419544
20	919030108949	incoming	main_menu	wamid.HBgMOTE5MDMwMTA4OTQ5FQIAEhgUM0E5QUQ0NzNDNjBFRkQ5QjgyQTMA	2026-04-27 04:49:05.610324
21	919030108949	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 04:49:07.044184
22	919652759166	incoming	main_menu	wamid.HBgMOTE5NjUyNzU5MTY2FQIAEhggQTVCQjFCOUVFRjNBOTA5MEQxMjMzNDE2MzUwMEIxMDAA	2026-04-27 04:51:19.592921
23	919652759166	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 04:51:20.246914
24	919652759166	incoming	our_solutions	wamid.HBgMOTE5NjUyNzU5MTY2FQIAEhggQTUzRjhGQTRDOTQ4QTQ3OENEMkU5NkEzNUI2RjA3MEEA	2026-04-27 04:51:33.09448
25	919652759166	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-27 04:51:33.557439
26	919652759166	incoming	industrial_auto	wamid.HBgMOTE5NjUyNzU5MTY2FQIAEhggQTU4OTYyMjlDQTkxMTQyRDlBRkYzQURGRjI4QzEyMjMA	2026-04-27 04:51:41.381657
27	919652759166	outgoing	[Image: https://images.unsplash.com/photo-1537462715879-360eeb61a0ad?w=800] ⚙️ Industrial Automation\nThe Foundation: Total Control at Machine Level\n\nWe design, build, and commission high-reliability automation systems engineered for continuous 24/7 industrial operations. Our experts specialize in creating seamless machine-level interfaces that maximize uptime.\n\n🔹 End-to-End System Design\n🔹 Retrofitting & Upgrades\n🔹 Machine Monitoring\n🔹 High-Performance Algorithms\n🔹 Safety-First Engineering\n\nSelect a service to learn more:	\N	2026-04-27 04:51:41.898203
28	917676776845	incoming	Hi..	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM3MzVDM0YzRDZDMkMxQjBEMzIxMUNGMjY4NTEzMjIA	2026-04-27 04:52:43.923097
29	917676776845	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-04-27 04:52:44.395367
30	919652759166	incoming	plc_control	wamid.HBgMOTE5NjUyNzU5MTY2FQIAEhggQTVDNzRDRDUzQTA0OTg2MDUxNEVFMjE5RDM5MEQwNzkA	2026-04-27 04:56:58.464875
31	919652759166	outgoing	[Image: https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=800] ⚡ PLC & Control Systems\nComplete programmable control solutions for your plant floor.\n\n✅ Micro & Modular PLCs\n✅ Motion Controllers\n✅ Integrated PLC/HMI units\n✅ Variable Frequency Inverters (VFDs)\n✅ AC Servo Drive Systems\n✅ High-speed precision control\n✅ Safety PLC systems\n✅ Redundant control architecture\n\n🎯 Industries served:\nAutomotive | Pharma | Food & Beverage | Packaging | EV & Battery\n\n📞 Contact us for a free consultation and custom quote.	\N	2026-04-27 04:56:59.147464
34	917676776845	incoming	Okay	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM0Q0MxNDJERDFEQTkzRUM4NDI5MDE5NjgyNzI4QkQA	2026-04-27 05:15:49.879876
35	917676776845	outgoing	Please select one of the options above 👆	\N	2026-04-27 05:15:50.514436
36	917676776845	incoming	Share the options	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUMwMjUxQjBEMzZGRTU5QjZFOEE5NURDOUNENjY3RDUA	2026-04-27 05:16:23.544232
37	917676776845	outgoing	Please select one of the options above 👆	\N	2026-04-27 05:16:23.951524
32	919652759166	incoming	get_free_quote	wamid.HBgMOTE5NjUyNzU5MTY2FQIAEhggQTU3RkYyMzhCRTExNjcxOUVBNzFBRTI5NTA4MDE3RkQA	2026-04-27 04:57:42.19193
33	919652759166	outgoing	💬 Free Consultation Request\nOur experts will analyze your requirements and provide a detailed proposal within 24 hours. 🎯\n\nPlease share your *full name*:	\N	2026-04-27 04:57:42.633774
40	917676776845	incoming	Hi	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUMzQUVDQ0RDMURDN0U4NDZBNTRCMkQyNkJGRDUyQzcA	2026-04-27 05:23:04.431333
41	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 05:23:05.086902
42	917676776845	incoming	our_solutions	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM1QTgyMDgxREI3ODdCNzhFRUQ0N0EwNzVCMzNCM0YA	2026-04-27 05:23:49.735457
43	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-27 05:23:50.221874
50	917676776845	incoming	Suma	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUMwM0MzM0VEM0IzREM5M0I5RTIyQTJCRUMwRTFFNTYA	2026-04-27 05:24:51.601745
51	917676776845	outgoing	👋 Hello Suma!\n\n🏢 What is your *company name* and *industry*?\n\nExample: ABC Manufacturing, Automotive	\N	2026-04-27 05:24:51.987257
38	919030108949	incoming	Hi	wamid.HBgMOTE5MDMwMTA4OTQ5FQIAEhgUM0FDQzRCREIwNUREQTIwNUU2NUUA	2026-04-27 05:20:03.699929
39	919030108949	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 05:20:04.505448
44	917676776845	incoming	iiot_analytics	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUMzMEIwOUVCMEYzODI1QURFNjg3MjU1MEM5NTUxQ0YA	2026-04-27 05:24:13.072882
45	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1518770660439-4636190af475?w=800] 📊 IIoT & Analytics Solutions\nConnecting your plant to the cloud.\n\nSelect a service:	\N	2026-04-27 05:24:13.515837
46	917676776845	incoming	iiot_gateway	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNGNEJFREE5OEIwMzJDNzUzRUNDRjFBNkVFMkUyQ0YA	2026-04-27 05:24:24.100969
47	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1518770660439-4636190af475?w=800] 🌐 IIoT Gateway Solutions\nThe Bridge: Connecting Your Plant to the Cloud\n\n✅ Industrial IoT gateway deployment\n✅ Machine-to-cloud connectivity\n✅ OPC-UA, Modbus, MQTT protocols\n✅ Secure encrypted data transfer\n✅ Edge computing solutions\n\n📞 Contact us for a free consultation.	\N	2026-04-27 05:24:24.615199
48	917676776845	incoming	get_free_quote	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM5QkFCRDg1REE1MEEyQ0NBNTBBQ0NFM0M0MUQ2MzIA	2026-04-27 05:24:37.381031
49	917676776845	outgoing	💬 Free Consultation Request\nOur experts will analyze your requirements and provide a detailed proposal within 24 hours. 🎯\n\nPlease share your *full name*:	\N	2026-04-27 05:24:37.812584
52	917676776845	incoming	Automotive	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNGNUQyMjZCQjMyREI0NkQ2Q0YwNzNFQUExQjQzNTEA	2026-04-27 05:25:01.993259
53	917676776845	outgoing	📋 Briefly describe your *requirement*:\n\nExample:\n"Need PLC automation for 3 production lines"\n"Want WhatsApp bot for our hotel"	\N	2026-04-27 05:25:02.386516
54	917676776845	incoming	Fx5u series , 32di, 32do PLC with transistor type source	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM0NjkwMTlFNzBCQkI4NUY5NEMzQ0RFQjRGNTU5QkQA	2026-04-27 05:25:57.966313
55	917676776845	outgoing	We design & commission complete PLC systems — Micro PLCs, Motion Controllers, VFDs, Safety PLCs, and AC Servo Drives for Automotive, Pharma, Food & Beverage, and more. ⚡	\N	2026-04-27 05:25:58.435691
56	917676776845	incoming	main_menu	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM4QkFEMkYwNEZBNUQ4OTc3MjBDRDYxN0IyNzk2NTkA	2026-04-27 05:26:07.09286
57	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 05:26:07.644738
58	917676776845	incoming	3.5kw vfd quote required	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUMwMjI5NjI2MjUzNDc0QzQ0QjA4NTkyMEEyQkRCNkYA	2026-04-27 05:26:31.184938
59	917676776845	outgoing	Our pricing is tailored to your project scope. We deliver a detailed proposal within 24 hours. 💬	\N	2026-04-27 05:26:31.624262
60	917676776845	incoming	main_menu	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM1MkEwMzI5Mzg5NTQ4N0M1QjVENjFGODA0QTg2RDMA	2026-04-27 05:29:46.899753
61	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 05:29:47.483944
62	917676776845	incoming	talk_to_expert	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNEMUVGMUVDMzBEOURFOTA1OUE5RjcxQzRGOUIyOUEA	2026-04-27 05:29:48.494919
63	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800] 📞 ASKworX Smart Automation LLP Support Center\nHow can we help you today?\n\nSelect a category below to connect with the right expert.	\N	2026-04-27 05:29:49.006639
64	917676776845	incoming	quotation	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM2NUNBNjY5NUM5MjAxNzY4RDE0MkJFOUQzRkE5NjIA	2026-04-27 05:30:00.874597
65	917676776845	outgoing	Our pricing is tailored to your project scope. We deliver a detailed proposal within 24 hours. 💬	\N	2026-04-27 05:30:01.358641
66	917676776845	incoming	technical	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM3QjZDNTJGNkYxRjg1RjRDNjlCMzcwNUUwOEQwMEEA	2026-04-27 05:30:12.717693
67	917676776845	outgoing	✅ *Selected:* Technical Query\n\nWhich service area can we help you with?	\N	2026-04-27 05:30:13.140392
68	917676776845	incoming	cat_automation	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUMzRUE2NTc2ODQzMTI1NERFMUZCRTRFMDY2RkEzNkEA	2026-04-27 05:30:17.600395
69	917676776845	outgoing	Great choice! To connect you with the right expert, may I have your name?	\N	2026-04-27 05:30:18.016
70	917676776845	incoming	Suma	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUMwNDkyMzY4QUY0RjJCRUY4OTVDMjEzMzdGMzFENzAA	2026-04-27 05:30:27.379555
71	917676776845	outgoing	Company name?	\N	2026-04-27 05:30:27.832181
72	917676776845	incoming	SRA	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNBRDMzQkQ1MzFFQkI4OEI3MjQ4NzM5RTQ3NzU0MEUA	2026-04-27 05:30:41.250052
73	917676776845	outgoing	Preferred time to connect?	\N	2026-04-27 05:30:41.695343
74	917676776845	incoming	11:02am	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNEQjNBMEI5NEMxOTFGMkE2RTAxNjU1RTk0MTRENUUA	2026-04-27 05:30:55.623793
75	917676776845	outgoing	✅ Thank you! Our team will connect with you shortly.	\N	2026-04-27 05:30:56.091701
76	918310029635	outgoing	📩 *New Customer Query*\n\n👤 *Number:* +917676776845\n📂 *Category:* Technical Query\n💬 *Message:* Interested In: Industrial Automation / PLC / ATEX\nName: Suma\nCompany: SRA\nPreferred Time: 11:02am\n\nLead generated from Expert Menu.	\N	2026-04-27 05:30:56.828273
77	917676776845	incoming	service	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNCRTk5QTIzNUYzNDNCNkJERjc1NDIzRDkyNTZCQkEA	2026-04-27 05:31:16.784762
78	917676776845	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-04-27 05:31:17.198656
79	917676776845	incoming	Thank you	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM5ODY0MTdFODM0QTU1QjY3MkMwNDY3N0E5OTFDQjgA	2026-04-27 05:31:27.508701
80	917676776845	outgoing	Please select one of the options above 👆	\N	2026-04-27 05:31:27.926836
81	917676776845	incoming	Hi	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNGRDY0ODdGMDg4NDE3QjJBMkIwQjZDRDhFOUEzOTcA	2026-04-27 05:33:06.468607
82	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 05:33:07.103413
83	917676776845	incoming	about_askworx	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUMyRjkzMTNEMEZCQjRFMzM0ODI1MjNDQUUxODYzM0YA	2026-04-27 05:34:22.193259
84	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 About ASKworX Smart Automation LLP\nGround to Cloud — Engineering Smart Automation\n\nAt ASKworX Smart Automation LLP, we bridge the gap between shop-floor machinery and cloud-connected intelligence. We provide high-reliability solutions for modern manufacturing.\n\n🛠 Our Solutions:\n✅ PLC & SCADA Engineering\n✅ Control Panel Design\n✅ Industrial Networking\n✅ Robotics & Motion Control\n✅ IIoT & Cloud Integration\n✅ Data Visualization\n\n⚲ Office Address:\n1381, 6th Main Road, 1st Phase, BEML Layout, 5th Stage, RR Nagar, Bangalore, Karnataka - 560098.\n\n📞 Contact Detail:\n☎︎ +919030108949\n📧 contact@askworx.in\n🌐 www.askworx.in	\N	2026-04-27 05:34:22.652065
85	917676776845	incoming	our_industries	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM0Mzk5MEU1MTJCNDI0RTVBNEE5RUVFNzE4NTk1QTAA	2026-04-27 05:34:33.765409
86	917676776845	outgoing	🏭 Industries We Serve\n🚗 Automotive | 🔋 EV | 💊 Pharma | 🍔 Food & Bev | 📦 Material Handling | 👕 Textiles | EMS | Oil & Gas\n\nWe work with ALL manufacturing sectors!	\N	2026-04-27 05:34:34.191415
93	917676776845	incoming	Need GS series 7 inch HMI	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNFNjIyRTNGMjU5N0I0QjU5NUE0QzNGODZGMTg5RDEA	2026-04-27 05:35:45.356677
94	917676776845	outgoing	We develop full SCADA & HMI systems with real-time monitoring, alarming, historical trending, and multi-site remote access using platforms like MC Works64. 🖥️	\N	2026-04-27 05:35:45.850785
95	917676776845	incoming	main_menu	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNCRTZBQTk3QzI4MTIwRkYyRkFFMDNDOUFBRjgxNjgA	2026-04-27 05:35:49.903765
96	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 05:35:50.349447
97	917676776845	incoming	Thank you	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNBREI0MkZGMkIxQkI0QzUwREFEOEE5RDBGRkI1MjkA	2026-04-27 05:36:01.831061
98	917676776845	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-04-27 05:36:02.253209
99	917676776845	incoming	Tha k you	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM1QTI2OUFBNEI4NTg5QkJENUQyRjI3MDY3MUFDRUQA	2026-04-27 05:36:09.12702
100	917676776845	outgoing	Please select one of the options above 👆	\N	2026-04-27 05:36:09.622581
101	917676776845	incoming	Share me options	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUMzMzJBMDMyOThEODI0NzJEMzMwNDlCN0IwOTZCOUMA	2026-04-27 05:36:21.67054
102	917676776845	outgoing	Please select one of the options above 👆	\N	2026-04-27 05:36:22.086231
87	917676776845	incoming	get_free_quote	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUMzM0VCMUQwMUQ2OEVFMTQ3ODUyNEQ2NDQwNDhCMTkA	2026-04-27 05:34:43.815914
88	917676776845	outgoing	💬 Free Consultation Request\nOur experts will analyze your requirements and provide a detailed proposal within 24 hours. 🎯\n\nPlease share your *full name*:	\N	2026-04-27 05:34:44.207021
89	917676776845	incoming	Suna	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNCNzg1QkM0QjU2RDc5RjVDRDVFM0RBOUQxQzc3N0IA	2026-04-27 05:34:51.880345
90	917676776845	outgoing	👋 Hello Suna!\n\n🏢 What is your *company name* and *industry*?\n\nExample: ABC Manufacturing, Automotive	\N	2026-04-27 05:34:52.249997
91	917676776845	incoming	Automotive	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM5RTU5QTY2MThDNUVFMzVBRDk5NTE4NTI1Q0RGMkYA	2026-04-27 05:35:18.185675
92	917676776845	outgoing	📋 Briefly describe your *requirement*:\n\nExample:\n"Need PLC automation for 3 production lines"\n"Want WhatsApp bot for our hotel"	\N	2026-04-27 05:35:18.588908
103	917676776845	incoming	Hi	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM3NDI4MEE2MTYwMTIxRjYyNjMwRjRCQjU0OEMwRUIA	2026-04-27 05:36:26.485576
104	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 05:36:26.917428
105	919032173158	incoming	Hi	wamid.HBgMOTE5MDMyMTczMTU4FQIAEhgUM0FENjdEREU0NDlDMjgwRTA0Q0UA	2026-04-27 05:42:57.045648
106	919032173158	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 05:42:57.794595
107	919032173158	incoming	our_solutions	wamid.HBgMOTE5MDMyMTczMTU4FQIAEhgUM0E2NERGOEYyMUM0RDhERDBCM0UA	2026-04-27 05:43:10.619376
108	919032173158	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-27 05:43:11.03821
109	918310029635	incoming	Hi	wamid.HBgMOTE4MzEwMDI5NjM1FQIAEhggQTU4MkE3RDFDQ0VBMzZCRTRFMTlCOUJBODQ0QUJCNDgA	2026-04-27 05:43:21.915753
110	918310029635	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 05:43:22.455493
111	918310029635	incoming	Hello ASKworX Support, I need assistance with your industrial platform.	wamid.HBgMOTE4MzEwMDI5NjM1FQIAEhggQTUwRTQ3MTBCMjRBRjlFNjQwNjczOEY5MkZGM0UyRTkA	2026-04-27 05:43:32.243694
112	918310029635	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 05:43:32.762652
113	918217822332	incoming	Hi	wamid.HBgMOTE4MjE3ODIyMzMyFQIAEhgWM0VCMEFEQUVDNUFCNDI5NTg5MjdBMQA=	2026-04-27 05:59:40.69743
114	918217822332	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 05:59:41.626731
115	918217822332	incoming	our_solutions	wamid.HBgMOTE4MjE3ODIyMzMyFQIAEhgWM0VCMEVFQ0ZGQkQ4QzNCRDFBRjM2MQA=	2026-04-27 06:00:02.532859
116	918217822332	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-27 06:00:03.101795
117	919187458714	incoming	Hello ASKworX Support, I need assistance with your industrial platform.	wamid.HBgMOTE5MTg3NDU4NzE0FQIAEhggQTUzMDVGNERDNEUwN0U5MEU2QzA5RkRFQ0JDQjVENzEA	2026-04-27 06:50:29.411627
118	919187458714	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 06:50:30.147102
119	919663261122	incoming	[UNSUPPORTED_RECEIVED]	wamid.HBgMOTE5NjYzMjYxMTIyFQIAEhgSOTE1MTU0RDIzOTc0ODIwNTIxAA==	2026-04-27 07:20:22.708299
120	919663261122	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-04-27 07:20:23.712673
121	918147456955	incoming	Hi	wamid.HBgMOTE4MTQ3NDU2OTU1FQIAEhgWM0VCMEIzNTNENTRCRDg5MTgxMENFMAA=	2026-04-27 07:26:41.035086
122	918147456955	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 07:26:41.952275
123	918147456955	incoming	thank you	wamid.HBgMOTE4MTQ3NDU2OTU1FQIAEhgWM0VCMDVCQ0VGNkJCQTUwMDJDQzcyOQA=	2026-04-27 07:34:19.25561
124	918147456955	outgoing	🙏 You're most welcome! I'm glad I could assist you.\n\nI think you are satisfied with the information. If you need *urgent contact*, please reach out to our team directly at:\n\n📞 *+919030108949*\n\nHave a wonderful day! 😊	\N	2026-04-27 07:34:19.839525
125	918147456955	incoming	main_menu	wamid.HBgMOTE4MTQ3NDU2OTU1FQIAEhgWM0VCMDU0OTNFNUI1Mzk5ODYyNTExOQA=	2026-04-27 07:34:34.270876
126	918147456955	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-27 07:34:34.774524
127	919663261122	incoming	[UNSUPPORTED_RECEIVED]	wamid.HBgMOTE5NjYzMjYxMTIyFQIAEhgSRDlGN0NGQUE3ODkxNTVFNjRDAA==	2026-04-27 08:32:10.832821
128	919663261122	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-04-27 08:32:11.630251
129	919663261122	outgoing	sorry for the inconvenience.	\N	2026-04-27 09:31:53.076591
130	919663261122	outgoing	Text Hi to start Your conversation	\N	2026-04-27 09:32:18.418265
131	919030108949	outgoing	hello 	\N	2026-04-27 10:28:46.610648
132	919032173158	incoming	industrial_auto	wamid.HBgMOTE5MDMyMTczMTU4FQIAEhgUM0EwMUE2NDczMTBGNkYzMzVBNTgA	2026-04-28 02:35:00.974965
133	919032173158	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-04-28 02:35:01.914506
134	919032173158	incoming	digital_software	wamid.HBgMOTE5MDMyMTczMTU4FQIAEhgUM0FFRTk3MDJBODY5MjAyNDU2NEQA	2026-04-28 02:35:14.479287
135	919032173158	outgoing	Please select one of the options above 👆	\N	2026-04-28 02:35:14.942473
136	919032173158	incoming	talk_to_expert	wamid.HBgMOTE5MDMyMTczMTU4FQIAEhgUM0E1OUYwNzhGRkRFNTZBM0NEMUQA	2026-04-28 02:35:27.032293
137	919032173158	outgoing	[Image: https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800] 📞 ASKworX Smart Automation LLP Support Center\nHow can we help you today?\n\nSelect a category below to connect with the right expert.	\N	2026-04-28 02:35:27.625925
138	919032173158	incoming	quotation	wamid.HBgMOTE5MDMyMTczMTU4FQIAEhgUM0E0MjQxRDM1MzIyM0I2RkUwQkUA	2026-04-28 02:35:39.630994
139	919032173158	outgoing	Our pricing is tailored to your project scope. We deliver a detailed proposal within 24 hours. 💬	\N	2026-04-28 02:35:40.090155
140	919032173158	incoming	main_menu	wamid.HBgMOTE5MDMyMTczMTU4FQIAEhgUM0EwMDEyOUQ4MUEzN0Y4NjlEMzkA	2026-04-28 02:35:43.937111
141	919032173158	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 02:35:44.546749
142	917559053238	incoming	Hi	wamid.HBgMOTE3NTU5MDUzMjM4FQIAEhggQUM2NzA4M0E1RDg2RTBERTYxNTI1OUUxQTczOThBREUA	2026-04-28 02:36:42.933074
143	917559053238	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 02:36:43.596422
144	917559053238	incoming	our_solutions	wamid.HBgMOTE3NTU5MDUzMjM4FQIAEhggQUMyMTIyQTBFRjU3NUY2M0UzNUNFNjFFQjRGQTA1ODUA	2026-04-28 02:37:00.489165
145	917559053238	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 02:37:00.966074
146	919032173158	incoming	about_askworx	wamid.HBgMOTE5MDMyMTczMTU4FQIAEhgUM0E5NUZBQ0ZGOTVDOTcwMzM5QzMA	2026-04-28 02:38:44.946597
147	919032173158	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 About ASKworX Smart Automation LLP\nGround to Cloud — Engineering Smart Automation\n\nAt ASKworX Smart Automation LLP, we bridge the gap between shop-floor machinery and cloud-connected intelligence. We provide high-reliability solutions for modern manufacturing.\n\n🛠 Our Solutions:\n✅ PLC & SCADA Engineering\n✅ Control Panel Design\n✅ Industrial Networking\n✅ Robotics & Motion Control\n✅ IIoT & Cloud Integration\n✅ Data Visualization\n\n⚲ Office Address:\n1381, 6th Main Road, 1st Phase, BEML Layout, 5th Stage, RR Nagar, Bangalore, Karnataka - 560098.\n\n📞 Contact Detail:\n☎︎ +919030108949\n📧 contact@askworx.in\n🌐 www.askworx.in	\N	2026-04-28 02:38:45.451024
148	919535903904	incoming	Hi	wamid.HBgMOTE5NTM1OTAzOTA0FQIAEhgUM0E2NzUzMDZGQkVDNDQyRDIxNzkA	2026-04-28 03:31:34.345798
149	919535903904	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 03:31:35.27359
150	919535903904	incoming	our_solutions	wamid.HBgMOTE5NTM1OTAzOTA0FQIAEhgUM0FFNDg0NkFDN0Q4MkNBMjQ3QUUA	2026-04-28 03:32:56.614456
151	919535903904	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 03:32:57.249056
152	919535903904	incoming	industrial_auto	wamid.HBgMOTE5NTM1OTAzOTA0FQIAEhgUM0EzMUFCMDM1OTEwQTIwMzE1OEQA	2026-04-28 03:33:25.603055
153	919535903904	outgoing	[Image: https://images.unsplash.com/photo-1537462715879-360eeb61a0ad?w=800] ⚙️ Industrial Automation\nThe Foundation: Total Control at Machine Level\n\nWe design, build, and commission high-reliability automation systems engineered for continuous 24/7 industrial operations. Our experts specialize in creating seamless machine-level interfaces that maximize uptime.\n\n🔹 End-to-End System Design\n🔹 Retrofitting & Upgrades\n🔹 Machine Monitoring\n🔹 High-Performance Algorithms\n🔹 Safety-First Engineering\n\nSelect a service to learn more:	\N	2026-04-28 03:33:26.195313
155	919535903904	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 03:33:36.39913
156	919535903904	incoming	plc_control	wamid.HBgMOTE5NTM1OTAzOTA0FQIAEhgUM0ExMjgzQTRGOUMxRTk2OTI4NUMA	2026-04-28 03:34:16.62247
157	919535903904	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 03:34:17.129521
158	919535903904	incoming	about_askworx	wamid.HBgMOTE5NTM1OTAzOTA0FQIAEhgUM0E4MzZDNkFGM0UwNTE1QkM2MUEA	2026-04-28 03:34:37.986584
172	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:08.256799
159	919535903904	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 About ASKworX Smart Automation LLP\nGround to Cloud — Engineering Smart Automation\n\nAt ASKworX Smart Automation LLP, we bridge the gap between shop-floor machinery and cloud-connected intelligence. We provide high-reliability solutions for modern manufacturing.\n\n🛠 Our Solutions:\n✅ PLC & SCADA Engineering\n✅ Control Panel Design\n✅ Industrial Networking\n✅ Robotics & Motion Control\n✅ IIoT & Cloud Integration\n✅ Data Visualization\n\n⚲ Office Address:\n1381, 6th Main Road, 1st Phase, BEML Layout, 5th Stage, RR Nagar, Bangalore, Karnataka - 560098.\n\n📞 Contact Detail:\n☎︎ +919030108949\n📧 contact@askworx.in\n🌐 www.askworx.in	\N	2026-04-28 03:34:38.678503
160	919535903904	incoming	get_free_quote	wamid.HBgMOTE5NTM1OTAzOTA0FQIAEhgUM0EyNzlGQUY1REI0Q0UzNTExMUMA	2026-04-28 03:35:03.467547
161	919535903904	outgoing	💬 Free Consultation Request\nOur experts will analyze your requirements and provide a detailed proposal within 24 hours. 🎯\n\nPlease share your *full name*:	\N	2026-04-28 03:35:04.024422
162	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:01.138423
163	918147456955	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:01.928313
164	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:02.58613
165	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:03.180924
166	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:03.984411
167	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:04.687621
168	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:05.383537
169	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:06.032922
170	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:06.923817
171	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:07.610737
173	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:09.078334
174	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:09.896412
175	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:10.619873
176	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-28 04:00:11.205187
177	917676776845	incoming	main_menu	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUNCREQ3MTg5MjUzNkZFNzAxRkREODYyM0QxQjAwNTAA	2026-04-28 04:00:55.527907
178	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 04:00:56.39859
179	919535903904	incoming	main_menu	wamid.HBgMOTE5NTM1OTAzOTA0FQIAEhgWM0VCMDdGQjMzOTM2RUQwN0Y2NkNGRAA=	2026-04-28 04:02:10.989034
180	919535903904	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 04:02:11.606312
181	918019731640	incoming	main_menu	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUM5MzkyMUM0QzZBNDMzOUYyOTYzQUE0QzNFNDYxRDYA	2026-04-28 04:23:29.593727
182	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 04:23:30.466143
183	918019731640	incoming	about_askworx	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUMwNzY4NkE3NDg2MzAzQzg1NUMwRTQzOUNBQTM3MEUA	2026-04-28 04:23:38.587731
184	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 About ASKworX Smart Automation LLP\nGround to Cloud — Engineering Smart Automation\n\nAt ASKworX Smart Automation LLP, we bridge the gap between shop-floor machinery and cloud-connected intelligence. We provide high-reliability solutions for modern manufacturing.\n\n🛠 Our Solutions:\n✅ PLC & SCADA Engineering\n✅ Control Panel Design\n✅ Industrial Networking\n✅ Robotics & Motion Control\n✅ IIoT & Cloud Integration\n✅ Data Visualization\n\n⚲ Office Address:\n1381, 6th Main Road, 1st Phase, BEML Layout, 5th Stage, RR Nagar, Bangalore, Karnataka - 560098.\n\n📞 Contact Detail:\n☎︎ +919030108949\n📧 contact@askworx.in\n🌐 www.askworx.in	\N	2026-04-28 04:23:39.048646
185	918019731640	incoming	our_industries	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUMwN0MyNTRFMjg0MkY1MEZDMkVGNUY4MUFBRDlBNjIA	2026-04-28 04:23:45.619963
186	918019731640	outgoing	🏭 Industries We Serve\n🚗 Automotive | 🔋 EV | 💊 Pharma | 🍔 Food & Bev | 📦 Material Handling | 👕 Textiles | EMS | Oil & Gas\n\nWe work with ALL manufacturing sectors!	\N	2026-04-28 04:23:46.122551
187	918019731640	incoming	main_menu	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUM3RkU0M0MxRTE4QUUwNkU2QTZERDc0RkRGMEEwNTUA	2026-04-28 04:24:13.986527
188	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 04:24:14.588248
189	919666543876	incoming	about_askworx	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUNDREM1MzZDNDNDRjU1NzgxQUQyMkE0OTlDOEE4MTgA	2026-04-28 04:25:29.744295
190	919666543876	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 About ASKworX Smart Automation LLP\nGround to Cloud — Engineering Smart Automation\n\nAt ASKworX Smart Automation LLP, we bridge the gap between shop-floor machinery and cloud-connected intelligence. We provide high-reliability solutions for modern manufacturing.\n\n🛠 Our Solutions:\n✅ PLC & SCADA Engineering\n✅ Control Panel Design\n✅ Industrial Networking\n✅ Robotics & Motion Control\n✅ IIoT & Cloud Integration\n✅ Data Visualization\n\n⚲ Office Address:\n1381, 6th Main Road, 1st Phase, BEML Layout, 5th Stage, RR Nagar, Bangalore, Karnataka - 560098.\n\n📞 Contact Detail:\n☎︎ +919030108949\n📧 contact@askworx.in\n🌐 www.askworx.in	\N	2026-04-28 04:25:30.587094
191	919666543876	incoming	our_solutions	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUM2ODkzOTQ5NUZFMEYzQUVCODczODMxMERCODVGNEYA	2026-04-28 04:25:40.743742
192	919666543876	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 04:25:41.358848
193	919666543876	incoming	digital_software	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUM4QUFBNTYzRjc1RjNDMTI4NkFGNkU3OUQwNzdEREEA	2026-04-28 04:26:57.470618
194	919666543876	outgoing	[Image: https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=800] 💻 Digital & Software Solutions\nBridging traditional automation with modern digital thinking to scale your business.\n\nFrom automated customer engagement to full-scale enterprise software, we engineer tools that drive growth.	\N	2026-04-28 04:26:58.134062
195	919032173158	incoming	main_menu	wamid.HBgMOTE5MDMyMTczMTU4FQIAEhgUM0FGNjQ4RjI4OEUyRTA3N0YzQkYA	2026-04-28 04:30:04.31974
196	919032173158	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 04:30:04.960564
197	919900803001	incoming	Hi	wamid.HBgMOTE5OTAwODAzMDAxFQIAEhgUM0ExRkQ1NUIxM0Y4MDZEMjZGRTEA	2026-04-28 04:31:46.281211
199	919900803001	incoming	our_solutions	wamid.HBgMOTE5OTAwODAzMDAxFQIAEhgUM0E1QTI1MDkyNERCQjcyREQ3NEQA	2026-04-28 04:32:09.181543
242	918088693950	outgoing	💬 Free Consultation Request\nOur experts will analyze your requirements and provide a detailed proposal within 24 hours. 🎯\n\nPlease share your *full name*:	\N	2026-04-28 06:10:05.797975
198	919900803001	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 04:31:47.816932
207	919666543876	incoming	back_to_software	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUM4NTJEMEIyQjhCMUUyREI2MjY3ODA0RjE1OTgyN0QA	2026-04-28 04:34:58.653067
208	919666543876	outgoing	[Image: https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800] 💻 Software Solutions\nCustom-engineered software systems to automate and scale your business operations.\n\nSelect a specialized solution:	\N	2026-04-28 04:34:59.309366
213	919666543876	incoming	main_menu	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUNFREI1MjY5MzlBRTMwNzlCMEQxRkNEN0U1MTM5Q0UA	2026-04-28 04:35:53.723757
214	919666543876	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 04:35:54.202057
215	919666543876	incoming	talk_to_expert	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUM2MkU1RDI1MjM5NTk2Q0E3NjcyRkQzRUQwNTNGMkUA	2026-04-28 04:36:03.355216
216	919666543876	outgoing	[Image: https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800] 📞 ASKworX Smart Automation LLP Support Center\nHow can we help you today?\n\nSelect a category below to connect with the right expert.	\N	2026-04-28 04:36:03.883613
217	919666543876	incoming	technical	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUMxNUIzQ0EzQjhBQ0ZFNUZEQjBEMEE4RjEwN0U4MTUA	2026-04-28 04:36:11.812367
218	919666543876	outgoing	✅ *Selected:* Technical Query\n\nWhich service area can we help you with?	\N	2026-04-28 04:36:12.323715
219	919666543876	incoming	cat_automation	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUNERjM2RThDMzhCNDdFMDVFRDBGN0YyNjEzRTZCODUA	2026-04-28 04:36:18.52934
220	919666543876	outgoing	Great choice! To connect you with the right expert, may I have your name?	\N	2026-04-28 04:36:19.038481
221	918019731640	incoming	our_solutions	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUM0MTI5NjU1OTY3Njk4NzNERkNENEJGOUNDMzhGNTkA	2026-04-28 04:36:27.933175
222	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 04:36:28.406319
200	919900803001	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 04:32:09.836029
201	919666543876	incoming	software_solutions	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUMzODhBNjQxMkM2N0E1N0UwRTVDOEM2NjhEM0Q1REIA	2026-04-28 04:33:55.802771
202	919666543876	outgoing	[Image: https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800] 💻 Software Solutions\nCustom-engineered software systems to automate and scale your business operations.\n\nSelect a specialized solution:	\N	2026-04-28 04:33:56.358506
203	919666543876	incoming	industrial_sw	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUNDNkFBQzNGMkI1QUE0NUExQUQzQTUxQTUwM0IxNEMA	2026-04-28 04:34:04.597339
204	919666543876	outgoing	[Image: https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800] ⚙️ Industrial & ERP Software\nRobust backend systems to manage your shop floor and business.\n\n✅ Custom ERP & MES Systems\n✅ Real-time Inventory Tracking\n✅ Shop-floor Data Logging\n✅ Predictive Analytics Engines\n✅ Secure Cloud Dashboards\n✅ Desktop Process Monitors\n\nBridging the gap between machinery and business intelligence.	\N	2026-04-28 04:34:05.123562
205	919666543876	incoming	seo_marketing	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUNDRTYxRjk0NTg2RTczRTNFMDFDMDVCNkJCMEFCNDYA	2026-04-28 04:34:12.040523
206	919666543876	outgoing	[Image: https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800] 📈 Digital Marketing & SEO\nDominating search results and driving high-intent traffic.\n\n✅ Data-Driven SEO Strategies\n✅ ROI-Focused Google Ads (PPC)\n✅ LinkedIn B2B Lead Generation\n✅ Social Media Brand Positioning\n✅ Content Authority Building\n✅ Advanced Analytics & Tracking\n\nWe don't just get traffic; we get paying customers.	\N	2026-04-28 04:34:12.638648
209	919666543876	incoming	whatsapp_bot	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUMyMjkwQzRBNzVFNzhCQzU4MDNBQTg5MkI4M0EzQjgA	2026-04-28 04:35:05.322683
210	919666543876	outgoing	[Image: https://images.unsplash.com/photo-1611746872915-64382b5c76da?w=800] 📱 WhatsApp Business Automation\nTransform your Customer Experience with 24/7 Intelligent Automation.\n\n✅ AI-Powered Conversation Flows\n✅ Full CRM & Database Integration\n✅ Automated Lead Qualification\n✅ Order Tracking & Payments\n✅ Multi-agent Admin Dashboard\n✅ Direct Broadcast Management\n\nScale your sales and support without adding headcount.	\N	2026-04-28 04:35:05.850683
211	919666543876	incoming	get_free_quote	wamid.HBgMOTE5NjY2NTQzODc2FQIAEhggQUM5QTRFRTk5NUQwRDNCMkQ2QkY5MUMzOTQ3NTkxMjkA	2026-04-28 04:35:21.197608
212	919666543876	outgoing	💬 Free Consultation Request\nOur experts will analyze your requirements and provide a detailed proposal within 24 hours. 🎯\n\nPlease share your *full name*:	\N	2026-04-28 04:35:21.689561
223	918147577824	incoming	[UNSUPPORTED_RECEIVED]	wamid.HBgMOTE4MTQ3NTc3ODI0FQIAEhgSQTVFRTA3NTdCQ0EwODVENUUxAA==	2026-04-28 05:01:33.353019
224	918147577824	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-04-28 05:01:34.07618
225	919902314980	incoming	Hi	wamid.HBgMOTE5OTAyMzE0OTgwFQIAEhggQUM1RjdDNjA5Q0NFQzc5NzhDQTk0RDFGMDFENkZCNkQA	2026-04-28 05:35:17.295283
226	919902314980	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 05:35:18.169124
227	918088693950	incoming	Hello this is akash from Strategi Automation	wamid.HBgMOTE4MDg4NjkzOTUwFQIAEhgWM0VCMEFCQTM2RjJBNDIyRTZFMjNBRAA=	2026-04-28 05:45:06.659455
228	918088693950	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-04-28 05:45:07.296923
229	918088693950	outgoing	hi Akash 	\N	2026-04-28 05:49:41.021569
230	918088693950	incoming	is it bot texting me?	wamid.HBgMOTE4MDg4NjkzOTUwFQIAEhgWM0VCMERDNTdCODFCNjZEQTcwREY3MwA=	2026-04-28 05:50:02.277047
231	918088693950	outgoing	Please select one of the options above 👆	\N	2026-04-28 05:50:02.927899
232	918088693950	outgoing	This is a chat  bot , also we are from supporting team  my name is srujan 	\N	2026-04-28 05:51:36.525525
233	918088693950	incoming	hi	wamid.HBgMOTE4MDg4NjkzOTUwFQIAEhgWM0VCMDFDQzIwMjNCRDYxQThDNTY1MQA=	2026-04-28 06:09:31.468558
234	918088693950	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 06:09:32.246155
235	918088693950	incoming	our_solutions	wamid.HBgMOTE4MDg4NjkzOTUwFQIAEhgWM0VCMDJCMzg5OUQxOURBMDUxREExRAA=	2026-04-28 06:09:41.168756
236	918088693950	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 06:09:41.993559
237	918088693950	incoming	industrial_auto	wamid.HBgMOTE4MDg4NjkzOTUwFQIAEhgWM0VCMDg3N0M5MTI4MTIwNTBERUEzNQA=	2026-04-28 06:09:49.089936
238	918088693950	outgoing	[Image: https://images.unsplash.com/photo-1537462715879-360eeb61a0ad?w=800] ⚙️ Industrial Automation\nThe Foundation: Total Control at Machine Level\n\nWe design, build, and commission high-reliability automation systems engineered for continuous 24/7 industrial operations. Our experts specialize in creating seamless machine-level interfaces that maximize uptime.\n\n🔹 End-to-End System Design\n🔹 Retrofitting & Upgrades\n🔹 Machine Monitoring\n🔹 High-Performance Algorithms\n🔹 Safety-First Engineering\n\nSelect a service to learn more:	\N	2026-04-28 06:09:49.735811
239	918088693950	incoming	plc_control	wamid.HBgMOTE4MDg4NjkzOTUwFQIAEhgWM0VCMEI1MjQ5MTM2QjQ3OENCMzkwNwA=	2026-04-28 06:09:58.034822
240	918088693950	outgoing	[Image: https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=800] ⚡ PLC & Control Systems\nComplete programmable control solutions for your plant floor.\n\n✅ Micro & Modular PLCs\n✅ Motion Controllers\n✅ Integrated PLC/HMI units\n✅ Variable Frequency Inverters (VFDs)\n✅ AC Servo Drive Systems\n✅ High-speed precision control\n✅ Safety PLC systems\n✅ Redundant control architecture\n\n🎯 Industries served:\nAutomotive | Pharma | Food & Beverage | Packaging | EV & Battery\n\n📞 Contact us for a free consultation and custom quote.	\N	2026-04-28 06:09:58.606825
241	918088693950	incoming	get_free_quote	wamid.HBgMOTE4MDg4NjkzOTUwFQIAEhgWM0VCMDk3NkI5N0I1MjEyMkY4MThGNAA=	2026-04-28 06:10:05.308377
243	918088693950	incoming	Akash Subramanian	wamid.HBgMOTE4MDg4NjkzOTUwFQIAEhgWM0VCMERBQTFBODZEMjBDQTU2NTFBMgA=	2026-04-28 06:10:21.074078
244	918088693950	outgoing	👋 Hello Akash Subramanian!\n\n🏢 What is your *company name* and *industry*?\n\nExample: ABC Manufacturing, Automotive	\N	2026-04-28 06:10:21.571624
245	918217822332	incoming	main_menu	wamid.HBgMOTE4MjE3ODIyMzMyFQIAEhgUMkE0ODhBQkIzNEY1NjY5MTY5NEYA	2026-04-28 06:18:44.052073
246	918217822332	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 06:18:44.596697
247	918217822332	incoming	digital_software	wamid.HBgMOTE4MjE3ODIyMzMyFQIAEhgUMkEzNjA0NTM3ODBBNzYzN0E3M0MA	2026-04-28 06:18:51.804989
248	918217822332	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-04-28 06:18:52.316357
249	918147577824	outgoing	Sorry For The Inconvenience Text HI to Start The Conversation	\N	2026-04-28 06:30:50.032303
250	919618307057	incoming	Hi	wamid.HBgMOTE5NjE4MzA3MDU3FQIAEhggQTU1MEE1REVBM0JCNTRDMzE5ODIyRjREMDdERTNDOTQA	2026-04-28 07:21:37.926853
251	919618307057	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 07:21:38.815346
252	919618307057	incoming	our_solutions	wamid.HBgMOTE5NjE4MzA3MDU3FQIAEhggQTVBOEE4QjVCRDU1ODczOEJGMjc3QTNENEYzQjhDODkA	2026-04-28 07:21:50.74428
253	919618307057	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 07:21:51.332624
254	919618307057	incoming	digital_software	wamid.HBgMOTE5NjE4MzA3MDU3FQIAEhggQTU2RTQ2MEZFMkVGMzU4NjNDQzAyNjE5QkU5NURBQTEA	2026-04-28 07:21:59.466194
255	919618307057	outgoing	[Image: https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=800] 💻 Digital & Software Solutions\nBridging traditional automation with modern digital thinking to scale your business.\n\nFrom automated customer engagement to full-scale enterprise software, we engineer tools that drive growth.	\N	2026-04-28 07:22:00.106121
256	919618307057	incoming	software_solutions	wamid.HBgMOTE5NjE4MzA3MDU3FQIAEhggQTU4MUJERTJCMTNGMjA3MUZGRTU4OEY0QzhGNDEwNTcA	2026-04-28 07:22:06.380459
257	919618307057	outgoing	[Image: https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800] 💻 Software Solutions\nCustom-engineered software systems to automate and scale your business operations.\n\nSelect a specialized solution:	\N	2026-04-28 07:22:06.953922
258	919618307057	incoming	web_app_dev	wamid.HBgMOTE5NjE4MzA3MDU3FQIAEhggQTU2QTdCMDQ5NDI1Q0NFQjQ1OTMwRDc1NzBBNTdBMkUA	2026-04-28 07:22:13.28519
259	919618307057	outgoing	[Image: https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800] 🌐 Web & Mobile Portfolio\nEnterprise-grade digital products designed for high performance.\n\n✅ Progressive Web Apps (PWA)\n✅ High-Speed Corporate Websites\n✅ Mobile Apps (Flutter, React Native)\n✅ Headless CMS Solutions\n✅ Serverless API Architecture\n✅ AWS/GCP Cloud Deployment\n\nBuilt for speed, security, and extreme scalability. 🚀	\N	2026-04-28 07:22:13.833357
260	919618307057	incoming	get_free_quote	wamid.HBgMOTE5NjE4MzA3MDU3FQIAEhggQTUwN0I2OEM2MUM3RERGQUFFNjAxNzNBOTZEOEM3M0YA	2026-04-28 07:22:22.290173
261	919618307057	outgoing	💬 Free Consultation Request\nOur experts will analyze your requirements and provide a detailed proposal within 24 hours. 🎯\n\nPlease share your *full name*:	\N	2026-04-28 07:22:22.863656
262	919618307057	incoming	main_menu	wamid.HBgMOTE5NjE4MzA3MDU3FQIAEhggQTVCMEZFNUVDOERCMjY5MkVGOEY0RTczNTlBRUMyRUIA	2026-04-28 07:22:28.400771
263	919618307057	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 07:22:28.994869
264	919618307057	incoming	talk_to_expert	wamid.HBgMOTE5NjE4MzA3MDU3FQIAEhggQTU4ODZGMDJCNjQ4Mzg5MjFENTdDMkEzRkEzQzNDMEEA	2026-04-28 07:22:33.350166
265	919618307057	outgoing	[Image: https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800] 📞 ASKworX Smart Automation LLP Support Center\nHow can we help you today?\n\nSelect a category below to connect with the right expert.	\N	2026-04-28 07:22:33.965642
266	918123054064	incoming	Hi	wamid.HBgMOTE4MTIzMDU0MDY0FQIAEhggQUMzMEQ5ODM4MTEwMDgxMjgwOTM4ODVDRkVDM0Q1MEEA	2026-04-28 13:10:11.543193
267	918123054064	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 13:10:12.327055
268	918123054064	incoming	our_solutions	wamid.HBgMOTE4MTIzMDU0MDY0FQIAEhggQUNDNkU2MDlERDNFQ0RBRjAyRTdGQ0JBRTcwNzJCOUYA	2026-04-28 13:10:31.236866
269	918123054064	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 13:10:31.762035
270	918123054064	incoming	industrial_auto	wamid.HBgMOTE4MTIzMDU0MDY0FQIAEhggQUM3QUYwODE4MUVDNTE5QUM3RDI3RjhFQkY2QThDNkUA	2026-04-28 13:10:42.016279
271	918123054064	outgoing	[Image: https://images.unsplash.com/photo-1537462715879-360eeb61a0ad?w=800] ⚙️ Industrial Automation\nThe Foundation: Total Control at Machine Level\n\nWe design, build, and commission high-reliability automation systems engineered for continuous 24/7 industrial operations. Our experts specialize in creating seamless machine-level interfaces that maximize uptime.\n\n🔹 End-to-End System Design\n🔹 Retrofitting & Upgrades\n🔹 Machine Monitoring\n🔹 High-Performance Algorithms\n🔹 Safety-First Engineering\n\nSelect a service to learn more:	\N	2026-04-28 13:10:42.544235
272	918123054064	incoming	plc_control	wamid.HBgMOTE4MTIzMDU0MDY0FQIAEhggQUM2RDAxOThFOTdFNkQ2MUIxNkE5MjMxNUIwMzMyNzYA	2026-04-28 13:10:55.303027
274	918123054064	incoming	get_free_quote	wamid.HBgMOTE4MTIzMDU0MDY0FQIAEhggQUM1NjA0QkY1MTAwQzUwOEYxMUMyNUIzOEQyQkM1Q0EA	2026-04-28 13:11:02.487882
331	917676776845	incoming	main_menu	wamid.HBgMOTE3Njc2Nzc2ODQ1FQIAEhggQUM0RkEyNDY3NEJGNTE3RTUyOTZDNTQ5MzRFQTA5MTIA	2026-04-29 04:19:00.022185
273	918123054064	outgoing	[Image: https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=800] ⚡ PLC & Control Systems\nComplete programmable control solutions for your plant floor.\n\n✅ Micro & Modular PLCs\n✅ Motion Controllers\n✅ Integrated PLC/HMI units\n✅ Variable Frequency Inverters (VFDs)\n✅ AC Servo Drive Systems\n✅ High-speed precision control\n✅ Safety PLC systems\n✅ Redundant control architecture\n\n🎯 Industries served:\nAutomotive | Pharma | Food & Beverage | Packaging | EV & Battery\n\n📞 Contact us for a free consultation and custom quote.	\N	2026-04-28 13:10:55.804213
285	918123054064	incoming	next_to_scada	wamid.HBgMOTE4MTIzMDU0MDY0FQIAEhggQUNCNjAxNDA5NjZBMkU2QUI5MjVFMzA1QkFDMDYzMUQA	2026-04-28 13:11:54.468217
286	918123054064	outgoing	[Image: https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800] 🖥️ SCADA & HMI Development\nVisualize and control your entire operation from one screen.\n\n✅ Complete SCADA system development\n✅ MC Works64 & industry-standard platforms\n✅ HMI design for intuitive process control\n✅ Real-time monitoring & alarming\n✅ Historical data logging & trending\n✅ Multi-site remote monitoring\n✅ Custom reporting & dashboards\n✅ Mobile access to your plant data\n\n📊 Result: Complete plant visibility in real-time\n\n📞 Contact us for a free consultation and custom quote.	\N	2026-04-28 13:11:54.829728
275	918123054064	outgoing	💬 Free Consultation Request\nOur experts will analyze your requirements and provide a detailed proposal within 24 hours. 🎯\n\nPlease share your *full name*:	\N	2026-04-28 13:11:02.840815
276	918123054064	incoming	next_to_scada	wamid.HBgMOTE4MTIzMDU0MDY0FQIAEhggQUNFM0U5NzlDOEY3MDQzOTNBRUUzOTFBOTBCNEFFQzAA	2026-04-28 13:11:12.82973
277	918123054064	incoming	main_menu	wamid.HBgMOTE4MTIzMDU0MDY0FQIAEhggQUNGNjk5QjJDMDM2NTY0ODlFNDQzNzk2NTA0OTI1OTAA	2026-04-28 13:11:38.305468
278	918123054064	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 13:11:38.810943
279	918123054064	incoming	our_solutions	wamid.HBgMOTE4MTIzMDU0MDY0FQIAEhggQUNBOTA5NkU4OTJCRTM0M0IxOUZFMjgyQjYxNzUyNkUA	2026-04-28 13:11:43.176033
280	918123054064	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 13:11:43.592024
281	918123054064	incoming	industrial_auto	wamid.HBgMOTE4MTIzMDU0MDY0FQIAEhggQUMxREM5NTNEMzk3QTUwMzY4NTE3MEY4QjlCMUFCNjQA	2026-04-28 13:11:47.329501
282	918123054064	outgoing	[Image: https://images.unsplash.com/photo-1537462715879-360eeb61a0ad?w=800] ⚙️ Industrial Automation\nThe Foundation: Total Control at Machine Level\n\nWe design, build, and commission high-reliability automation systems engineered for continuous 24/7 industrial operations. Our experts specialize in creating seamless machine-level interfaces that maximize uptime.\n\n🔹 End-to-End System Design\n🔹 Retrofitting & Upgrades\n🔹 Machine Monitoring\n🔹 High-Performance Algorithms\n🔹 Safety-First Engineering\n\nSelect a service to learn more:	\N	2026-04-28 13:11:47.828267
283	918123054064	incoming	plc_control	wamid.HBgMOTE4MTIzMDU0MDY0FQIAEhggQUM3RTU1Qjk2M0RGMjQzRDIyODc3QTBDNDdCNEQ5QjkA	2026-04-28 13:11:50.762499
284	918123054064	outgoing	[Image: https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=800] ⚡ PLC & Control Systems\nComplete programmable control solutions for your plant floor.\n\n✅ Micro & Modular PLCs\n✅ Motion Controllers\n✅ Integrated PLC/HMI units\n✅ Variable Frequency Inverters (VFDs)\n✅ AC Servo Drive Systems\n✅ High-speed precision control\n✅ Safety PLC systems\n✅ Redundant control architecture\n\n🎯 Industries served:\nAutomotive | Pharma | Food & Beverage | Packaging | EV & Battery\n\n📞 Contact us for a free consultation and custom quote.	\N	2026-04-28 13:11:51.264704
287	919686699872	incoming	Hi	wamid.HBgMOTE5Njg2Njk5ODcyFQIAEhggQUNDN0IxQzQ3RkZFMUEzMDQyQUVCNTdFRTM5MzdDRkIA	2026-04-28 13:26:15.46106
288	919686699872	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 13:26:16.419763
289	919686699872	incoming	Lovely 😍	wamid.HBgMOTE5Njg2Njk5ODcyFQIAEhggQUM5RjMwRjc5MUE1MThFNkFFNkZFMzkyRUU0Njk1MDkA	2026-04-28 13:26:27.012857
290	919686699872	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-04-28 13:26:27.493988
291	919686699872	incoming	about_askworx	wamid.HBgMOTE5Njg2Njk5ODcyFQIAEhggQUMwMDkwRUE2Q0NBOEFEMjA5MDgwNzdBODlERTU3M0MA	2026-04-28 13:26:36.887831
292	919686699872	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 About ASKworX Smart Automation LLP\nGround to Cloud — Engineering Smart Automation\n\nAt ASKworX Smart Automation LLP, we bridge the gap between shop-floor machinery and cloud-connected intelligence. We provide high-reliability solutions for modern manufacturing.\n\n🛠 Our Solutions:\n✅ PLC & SCADA Engineering\n✅ Control Panel Design\n✅ Industrial Networking\n✅ Robotics & Motion Control\n✅ IIoT & Cloud Integration\n✅ Data Visualization\n\n⚲ Office Address:\n1381, 6th Main Road, 1st Phase, BEML Layout, 5th Stage, RR Nagar, Bangalore, Karnataka - 560098.\n\n📞 Contact Detail:\n☎︎ +919030108949\n📧 contact@askworx.in\n🌐 www.askworx.in	\N	2026-04-28 13:26:37.415823
293	919686699872	incoming	our_industries	wamid.HBgMOTE5Njg2Njk5ODcyFQIAEhggQUM5MzhFQjRFQTkyM0ZCODQ1QzRDQzA0MDE4M0Y3QUIA	2026-04-28 13:26:47.392895
294	919686699872	outgoing	🏭 Industries We Serve\n🚗 Automotive | 🔋 EV | 💊 Pharma | 🍔 Food & Bev | 📦 Material Handling | 👕 Textiles | EMS | Oil & Gas\n\nWe work with ALL manufacturing sectors!	\N	2026-04-28 13:26:47.895922
295	919686699872	incoming	our_solutions	wamid.HBgMOTE5Njg2Njk5ODcyFQIAEhggQUNBNTJERjkzMUI4MjRDODA4QkVBMjgwMEEwMEYwOTgA	2026-04-28 13:26:52.978767
296	919686699872	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 13:26:53.44357
297	919686699872	incoming	👏👏👏	wamid.HBgMOTE5Njg2Njk5ODcyFQIAEhggQUMwMzREQTdBNjkzMTIxMjkzM0U0NEQ1Rjc0QUVBRkQA	2026-04-28 13:27:02.899213
298	919686699872	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-04-28 13:27:03.549252
299	918125163407	incoming	Hii	wamid.HBgMOTE4MTI1MTYzNDA3FQIAEhggQTVFQUVDRUMzRUQ3OTMyOUM4NTg0OEE0NjczMTZBQTIA	2026-04-28 13:31:04.310684
300	918125163407	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-04-28 13:31:04.842402
301	918310029635	incoming	Hello ASKworX Support, I need assistance with your industrial platform.	wamid.HBgMOTE4MzEwMDI5NjM1FQIAEhgUM0JCNjQwRjFCQzVGQ0JBQzQ0MjUA	2026-04-28 15:46:42.593005
302	918310029635	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-28 15:46:43.488272
303	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:01.049462
304	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:02.183163
305	918147456955	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:03.17643
306	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:04.141431
307	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:05.015932
308	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:05.658275
309	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:06.354993
310	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:07.073358
311	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:07.756333
312	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:08.291484
313	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:08.866944
314	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:09.657979
315	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:10.788092
316	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:11.477473
317	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:12.156981
318	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:13.135924
319	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:14.057492
320	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:14.897826
321	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:15.672286
322	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:16.655655
323	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:17.279889
324	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:18.243009
325	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:19.187855
326	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-29 04:00:19.71583
327	919900803001	incoming	Why are you sending me this follow up message, it spams	wamid.HBgMOTE5OTAwODAzMDAxFQIAEhgUM0EzRTA3N0Q1RTcyQjdCODZDREUA	2026-04-29 04:01:24.832838
328	919900803001	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-04-29 04:01:25.542716
329	919032173158	incoming	about_askworx	wamid.HBgMOTE5MDMyMTczMTU4FQIAEhgUM0E5QUVGMDhBNjJFRTZBMEM2RTYA	2026-04-29 04:04:22.722889
330	919032173158	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 About ASKworX Smart Automation LLP\nGround to Cloud — Engineering Smart Automation\n\nAt ASKworX Smart Automation LLP, we bridge the gap between shop-floor machinery and cloud-connected intelligence. We provide high-reliability solutions for modern manufacturing.\n\n🛠 Our Solutions:\n✅ PLC & SCADA Engineering\n✅ Control Panel Design\n✅ Industrial Networking\n✅ Robotics & Motion Control\n✅ IIoT & Cloud Integration\n✅ Data Visualization\n\n⚲ Office Address:\n1381, 6th Main Road, 1st Phase, BEML Layout, 5th Stage, RR Nagar, Bangalore, Karnataka - 560098.\n\n📞 Contact Detail:\n☎︎ +919030108949\n📧 contact@askworx.in\n🌐 www.askworx.in	\N	2026-04-29 04:04:23.646335
332	917676776845	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-04-29 04:19:00.864251
333	919355777526	incoming	[UNSUPPORTED_RECEIVED]	wamid.HBgMOTE5MzU1Nzc3NTI2FQIAEhgSRDY0MUQ3MUY1QkExQ0YyMzU0AA==	2026-04-29 07:19:10.745231
334	919355777526	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-04-29 07:19:11.435856
335	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:01.644805
336	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:02.827182
337	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:03.598136
338	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:04.444033
339	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:05.11266
340	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:06.14166
341	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:06.98776
342	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:07.691453
343	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:08.750731
344	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:09.752434
345	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:10.613367
346	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:11.39573
347	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:12.187954
348	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:12.902215
349	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:13.810666
350	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:14.433219
351	918147456955	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:15.245862
352	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:16.244956
353	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:16.877147
354	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:17.377194
355	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:18.010281
356	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:18.869537
357	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:19.508296
358	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:20.298442
560	919000736254	incoming	Hi	wamid.HBgMOTE5MDAwNzM2MjU0FQIAEhggQUM5MDZGMDA4MjQ2OEY5QjM3MjU1QkEzMjQ2NUI0RjcA	2026-05-06 06:14:32.884916
359	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:21.167487
360	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-04-30 04:00:21.968794
361	919900803001	incoming	Stop	wamid.HBgMOTE5OTAwODAzMDAxFQIAEhgUM0EyMjMyREUxNjMyQzhBQ0E4NUUA	2026-04-30 04:01:31.017988
362	919900803001	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-04-30 04:01:31.595981
363	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:01.469681
364	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:02.450944
365	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:03.337251
366	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:04.032218
367	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:04.870385
368	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:05.776897
369	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:06.494873
370	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:07.233125
371	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:08.171189
372	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:08.934756
373	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:09.836045
374	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:10.506358
375	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:11.224721
376	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:12.192871
377	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:12.964865
378	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:13.532762
379	918147456955	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:14.391877
380	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:15.170511
381	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:15.72041
382	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:16.308703
383	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:17.075589
384	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:17.866146
385	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:18.431413
386	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:19.258616
600	917075813424	outgoing	May I know your requirement exactly 	\N	2026-05-06 13:45:50.86314
601	917075813424	outgoing	May I know your requirement exactly 	\N	2026-05-06 13:45:50.916735
387	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:20.103907
388	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-01 04:00:21.043052
389	918147456955	incoming	HI	wamid.HBgMOTE4MTQ3NDU2OTU1FQIAEhgWM0VCMEMxMkEzQ0QyRjgxQTQ5MzA3NgA=	2026-05-01 05:17:40.568227
390	918147456955	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-01 05:17:41.980621
391	918147456955	incoming	our_solutions	wamid.HBgMOTE4MTQ3NDU2OTU1FQIAEhgWM0VCMDAxMjIwMDQyM0Q2RTY1QzY0NQA=	2026-05-01 05:17:56.527185
392	918147456955	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-05-01 05:17:57.1552
393	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:01.568356
394	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:02.423238
395	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:03.226745
396	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:03.872094
397	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:04.653796
398	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:05.443522
399	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:06.087141
400	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:06.837703
401	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:07.820571
402	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:08.890338
403	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:09.806348
404	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:10.412582
405	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:11.010894
406	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:12.031274
407	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:12.971332
408	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:13.556542
409	918147456955	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:14.25189
410	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:15.201753
411	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:15.90608
412	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:16.452068
413	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:17.019719
414	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:17.912253
415	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:18.362028
416	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:18.947554
417	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:19.633671
418	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-02 04:00:20.486362
419	918147456955	incoming	opt_out	wamid.HBgMOTE4MTQ3NDU2OTU1FQIAEhggQUNEQzY4MkFCNUY3NjdBNDhGREJGMEI0NTFDQkJFQzkA	2026-05-02 04:02:53.506761
420	918147456955	outgoing	✅ You have successfully opted out of our automated broadcasts and daily messages. If you ever need assistance, you can always type 'hi' or 'menu'.	\N	2026-05-02 04:02:54.253786
421	918147456955	incoming	Hi	wamid.HBgMOTE4MTQ3NDU2OTU1FQIAEhggQUM2MUU3RUFGNDY1Q0E4OTQ3NzVDNUY4MDREQjVERDkA	2026-05-02 04:03:10.910526
422	918147456955	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-02 04:03:11.593307
423	918147456955	incoming	STOP	wamid.HBgMOTE4MTQ3NDU2OTU1FQIAEhggQUMwM0U5OEVEMjM4QzczNzM2RTAzMDc0RTg4NDY5NDQA	2026-05-02 04:03:18.682678
424	918147456955	outgoing	✅ You have successfully opted out of our automated broadcasts and daily messages. If you ever need assistance, you can always type 'hi' or 'menu'.	\N	2026-05-02 04:03:19.336767
425	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:01.162515
426	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:02.117209
427	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:02.969215
428	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:03.699754
429	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:04.605564
430	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:05.44263
431	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:06.079992
432	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:06.88431
433	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:07.642601
434	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:08.373498
435	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:08.988195
436	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:09.620452
437	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:10.377944
438	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:10.986284
439	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:11.805632
440	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:12.783965
441	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:13.402592
442	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:13.978516
443	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:14.809803
444	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:15.688328
445	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:16.263833
446	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:16.911556
447	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:17.412184
448	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:18.370582
449	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-03 04:00:19.136844
450	918310029635	outgoing	hi\n	\N	2026-05-03 06:48:31.624723
451	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:01.178004
452	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:02.057415
453	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:02.808428
454	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:03.549005
455	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:04.346411
456	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:05.424798
457	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:06.028684
458	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:06.851734
459	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:07.756722
460	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:08.641716
461	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:09.118433
462	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:09.656301
463	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:10.55891
464	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:11.160261
465	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:11.761637
466	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:12.426356
467	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:13.039806
468	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:13.660379
469	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:14.57697
470	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:15.314932
471	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:15.845357
472	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:16.41241
473	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:16.915601
474	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:17.983171
475	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-04 04:00:18.714285
476	919701288041	outgoing	Hi 	\N	2026-05-04 04:54:25.838627
477	919701288041	outgoing	Hi 	\N	2026-05-04 04:54:25.898295
478	919701288041	outgoing	Hi 	\N	2026-05-04 04:54:26.421264
479	917058069655	incoming	[UNSUPPORTED_RECEIVED]	wamid.HBgMOTE3MDU4MDY5NjU1FQIAEhgSMkYzRUYyQkNBRkQ2M0U0MEJFAA==	2026-05-04 05:25:28.617977
480	917058069655	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-05-04 05:25:29.560052
481	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:02.472513
482	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:03.236427
483	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:03.98432
484	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:04.73309
485	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:05.626419
486	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:06.334321
487	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:07.033298
488	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:07.658347
489	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:08.585633
490	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:09.612052
491	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:10.398994
492	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:11.107477
493	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:12.007591
494	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:12.974316
495	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:13.76931
496	917058069655	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:14.574536
497	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:15.078363
498	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:15.725394
499	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:16.410576
500	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:16.922825
501	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:17.36192
502	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:18.001871
503	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:18.615433
504	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:19.211351
505	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:20.019581
506	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-05 04:00:20.628975
507	912244066666	incoming	[UNSUPPORTED_RECEIVED]	wamid.HBgMOTEyMjQ0MDY2NjY2FQIAEhgSMjVCQkU0OUZEMzExQjA5RDMwAA==	2026-05-05 10:47:17.942958
508	912244066666	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-05-05 10:47:18.944756
509	919912312716	incoming	Hi	wamid.HBgMOTE5OTEyMzEyNzE2FQIAEhgUM0E3NUM2QjM5RkU1M0I2RDI5OEUA	2026-05-05 16:04:08.859151
510	919912312716	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-05 16:04:09.840086
511	919912312716	incoming	our_solutions	wamid.HBgMOTE5OTEyMzEyNzE2FQIAEhgUM0EyOUUyRkY3NEFFQkQ4Mjc1MjUA	2026-05-05 16:04:22.85095
512	919912312716	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-05-05 16:04:23.343652
513	919912312716	incoming	digital_software	wamid.HBgMOTE5OTEyMzEyNzE2FQIAEhgUM0FEQzUyQjQyOEI4RTkwQzYzMzAA	2026-05-05 16:04:52.447819
514	919912312716	outgoing	[Image: https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=800] 💻 Digital & Software Solutions\nBridging traditional automation with modern digital thinking to scale your business.\n\nFrom automated customer engagement to full-scale enterprise software, we engineer tools that drive growth.	\N	2026-05-05 16:04:53.100611
515	919666773015	incoming	Hi	wamid.HBgMOTE5NjY2NzczMDE1FQIAEhggQUMxNzNGRjgzOUM5QUYwREI4MTFGRkE3RDkwNDlGMEEA	2026-05-05 16:05:05.127848
516	919666773015	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-05 16:05:05.718677
517	919912312716	incoming	software_solutions	wamid.HBgMOTE5OTEyMzEyNzE2FQIAEhgUM0EzQUVERjNBRDk0MTk5Rjk1QTMA	2026-05-05 16:05:06.861172
518	919912312716	outgoing	[Image: https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800] 💻 Software Solutions\nCustom-engineered software systems to automate and scale your business operations.\n\nSelect a specialized solution:	\N	2026-05-05 16:05:07.378452
519	917058069655	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:01.331878
520	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:02.116992
521	919666773015	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:02.936645
522	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:03.816918
523	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:04.424937
524	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:05.165598
525	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:06.009465
526	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:06.703674
527	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:07.315134
528	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:08.178904
529	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:08.97779
530	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:09.592786
531	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:10.52324
532	919912312716	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:11.427083
533	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:12.121601
534	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:12.9432
535	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:13.563407
536	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:14.17424
537	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:15.087383
538	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:15.827051
539	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:16.416018
540	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:17.041254
541	912244066666	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:17.69859
542	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:18.398821
543	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:18.818635
544	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:19.279945
545	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:20.223752
546	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:20.929494
547	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-06 04:00:21.530786
548	919000596952	incoming	Hi	wamid.HBgMOTE5MDAwNTk2OTUyFQIAEhggQUM1NTgzRDQ3OTQxOEM4QUVBRjI1Q0FGNUM1REFCMzcA	2026-05-06 04:43:50.858901
549	919000596952	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-06 04:43:51.921364
550	919000596952	incoming	our_solutions	wamid.HBgMOTE5MDAwNTk2OTUyFQIAEhggQUM1MjBBOUUzMTU1OEJCRkYyNTVDQ0Y5QTlBN0YxOEUA	2026-05-06 04:44:07.762077
551	919000596952	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-05-06 04:44:08.351718
552	919000596952	incoming	Quote	wamid.HBgMOTE5MDAwNTk2OTUyFQIAEhggQUMzRTIzNTEwNUM0M0U0NEIzODA3NEE1QUU4RDkyMkIA	2026-05-06 04:46:04.962033
553	919000596952	outgoing	Our pricing is tailored to your project scope. We deliver a detailed proposal within 24 hours. 💬	\N	2026-05-06 04:46:05.589758
554	919000596952	incoming	main_menu	wamid.HBgMOTE5MDAwNTk2OTUyFQIAEhggQUNFNDREMjc0RUE4QzA4ODY0MjlGRjhGRDIyM0ZBOTQA	2026-05-06 04:46:09.492675
555	919000596952	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-06 04:46:10.087032
556	919000596952	incoming	talk_to_expert	wamid.HBgMOTE5MDAwNTk2OTUyFQIAEhggQUM5MjVBNEEzODgzMTJCOUU2NjdDMDMxQjdBMDAxQTkA	2026-05-06 04:46:15.975549
557	919000596952	outgoing	[Image: https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800] 📞 ASKworX Smart Automation LLP Support Center\nHow can we help you today?\n\nSelect a category below to connect with the right expert.	\N	2026-05-06 04:46:16.636673
558	919000596952	incoming	quotation	wamid.HBgMOTE5MDAwNTk2OTUyFQIAEhggQUNEQkY2QUFDM0Y5QjczQTJEQ0I4M0FDMkY0MjgxNUMA	2026-05-06 04:46:33.034862
559	919000596952	outgoing	Our pricing is tailored to your project scope. We deliver a detailed proposal within 24 hours. 💬	\N	2026-05-06 04:46:33.605831
561	919000736254	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-06 06:14:33.658853
562	919000736254	incoming	our_solutions	wamid.HBgMOTE5MDAwNzM2MjU0FQIAEhggQUNCNEY2RDNERkI4NTY0NjY5MTEwMzI2NkMxNTIzRjEA	2026-05-06 06:14:57.658973
563	919000736254	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-05-06 06:14:58.146496
564	919000736254	incoming	digital_software	wamid.HBgMOTE5MDAwNzM2MjU0FQIAEhggQUMzOEM5NEJBODAyQjU1MTA0NTMzMUE4RTM5NDg0ODAA	2026-05-06 06:15:10.285524
565	919000736254	outgoing	[Image: https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=800] 💻 Digital & Software Solutions\nBridging traditional automation with modern digital thinking to scale your business.\n\nFrom automated customer engagement to full-scale enterprise software, we engineer tools that drive growth.	\N	2026-05-06 06:15:10.707052
566	919000736254	incoming	main_menu	wamid.HBgMOTE5MDAwNzM2MjU0FQIAEhggQUM5RUQyNjhGNEFCODlGNTQzM0VGMjNFQjJFMTU0NDgA	2026-05-06 06:15:20.863875
567	919000736254	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-06 06:15:21.341935
568	919000736254	incoming	talk_to_expert	wamid.HBgMOTE5MDAwNzM2MjU0FQIAEhggQUM3NUNCMzlDQkU1OEYzODhGMDUzMjAyNUI3QTJDNTEA	2026-05-06 06:15:27.774054
569	919000736254	outgoing	[Image: https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800] 📞 ASKworX Smart Automation LLP Support Center\nHow can we help you today?\n\nSelect a category below to connect with the right expert.	\N	2026-05-06 06:15:28.254994
570	919000736254	incoming	service	wamid.HBgMOTE5MDAwNzM2MjU0FQIAEhggQUNEQUYzRkRCODc5NkUwNzI1OTJFNjc0NDkyNTc4MTgA	2026-05-06 06:15:33.393593
571	919000736254	outgoing	✅ *Selected:* Service Request\n\nWhich service area can we help you with?	\N	2026-05-06 06:15:33.796469
572	919000736254	incoming	cat_automation	wamid.HBgMOTE5MDAwNzM2MjU0FQIAEhggQUM5RjIwMDhFMzZEREMzMzJEQThBOURBNkEwMEE0NDkA	2026-05-06 06:15:37.70153
573	919000736254	outgoing	Great choice! To connect you with the right expert, may I have your name?	\N	2026-05-06 06:15:38.178142
574	919000736254	incoming	Rakesh	wamid.HBgMOTE5MDAwNzM2MjU0FQIAEhggQUNFMDU5NzMyOThBOTc4MTI2N0Y5RTIyRjQxN0I2MzIA	2026-05-06 06:15:49.02202
575	919000736254	outgoing	Company name?	\N	2026-05-06 06:15:49.628709
576	919000736254	incoming	Va.electricals	wamid.HBgMOTE5MDAwNzM2MjU0FQIAEhggQUM1NTc2OEI2MUNCRjEwNjFGNTUzMzc0OEQ3NjVEQzEA	2026-05-06 06:15:57.362161
577	919000736254	outgoing	Preferred time to connect?	\N	2026-05-06 06:15:57.882069
578	919000736254	incoming	1	wamid.HBgMOTE5MDAwNzM2MjU0FQIAEhggQUMxMTAwMUEyRTIzN0NBOEQ5Qzk5RTM0MTNFM0IyRTkA	2026-05-06 06:16:06.807614
579	919000736254	outgoing	✅ Thank you! Our team will connect with you shortly.	\N	2026-05-06 06:16:08.351391
580	919030108949	outgoing	📩 *New Customer Query*\n\n👤 *Number:* +919000736254\n📂 *Category:* Service Request\n💬 *Message:* Interested In: Industrial Automation / PLC / ATEX\nName: Rakesh\nCompany: Va.electricals\nPreferred Time: 1\n\nLead generated from Expert Menu.	\N	2026-05-06 06:16:08.789009
581	919000736254	outgoing	Hi 	\N	2026-05-06 06:28:50.684234
582	912244066666	incoming	[UNSUPPORTED_RECEIVED]	wamid.HBgMOTEyMjQ0MDY2NjY2FQIAEhgSOTg3NTdCQkMyM0QxN0VENTQyAA==	2026-05-06 11:36:42.80332
583	912244066666	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-05-06 11:36:43.73571
584	917075813424	incoming	Hi	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUM5Nzg3QzBFOTFERjlCNzgyQTJFNDYxNzA1OUI2MEQA	2026-05-06 13:43:10.671765
585	917075813424	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-06 13:43:11.489501
586	917075813424	incoming	talk_to_expert	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUNFQkJCOTk5QTdDQUI1MzI4Q0U2MkZGOTcxMUZCMkEA	2026-05-06 13:43:24.09988
587	917075813424	outgoing	[Image: https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800] 📞 ASKworX Smart Automation LLP Support Center\nHow can we help you today?\n\nSelect a category below to connect with the right expert.	\N	2026-05-06 13:43:24.577927
588	917075813424	incoming	quotation	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUM0QjkxQTMxQ0JBM0E5QTk3NDM5NkQxRDE3RTM1RUIA	2026-05-06 13:43:33.20055
589	917075813424	outgoing	Our pricing is tailored to your project scope. We deliver a detailed proposal within 24 hours. 💬	\N	2026-05-06 13:43:33.665838
590	917075813424	incoming	main_menu	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUM4NkRENTA0NkU1MjI1MjQ3MkY0NDFGMzBFQzhCNEUA	2026-05-06 13:43:38.752407
591	917075813424	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-06 13:43:39.206689
592	917075813424	incoming	talk_to_expert	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUNFMjI2MjA2NEUyMDY2OUEzNUNGOUYzMzNBRTExRjcA	2026-05-06 13:43:43.413895
593	917075813424	outgoing	[Image: https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800] 📞 ASKworX Smart Automation LLP Support Center\nHow can we help you today?\n\nSelect a category below to connect with the right expert.	\N	2026-05-06 13:43:43.923201
594	917075813424	incoming	quotation	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUM4MTI5RkU5MDQwQzgxNzc3NDRGQzQ2Q0IzODg2QTAA	2026-05-06 13:43:47.891694
595	917075813424	outgoing	Our pricing is tailored to your project scope. We deliver a detailed proposal within 24 hours. 💬	\N	2026-05-06 13:43:48.383291
596	917075813424	incoming	technical	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUNDQjBBMkQ3QTk1NzU0ODNDQUQ4RkUyRTQwNTZCMjkA	2026-05-06 13:43:55.552262
597	917075813424	outgoing	✅ *Selected:* Technical Query\n\nWhich service area can we help you with?	\N	2026-05-06 13:43:56.001578
598	917075813424	incoming	cat_automation	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUM1Q0ZFNEYzMTFCMDk3MUFBMTA4M0ZEOEM5NTlFQ0IA	2026-05-06 13:43:59.943378
599	917075813424	outgoing	Great choice! To connect you with the right expert, may I have your name?	\N	2026-05-06 13:44:00.473584
602	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:01.057299
603	917058069655	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:01.855612
604	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:02.804894
605	919000736254	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:03.82003
606	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:04.51417
607	919666773015	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:05.322432
608	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:06.276255
609	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:07.122722
610	917075813424	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:07.88092
611	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:08.718826
612	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:09.282128
613	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:10.001086
614	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:10.697981
615	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:11.367112
616	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:12.024021
617	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:12.937015
618	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:13.798717
619	919912312716	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:14.657558
620	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:15.355808
621	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:15.99824
622	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:16.857138
623	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:17.635921
624	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:18.253438
625	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:18.776896
626	919000596952	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:19.29272
627	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:19.882604
628	912244066666	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:20.82418
629	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:21.531146
630	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:23.045932
631	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:23.50996
632	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:24.081996
633	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-07 04:00:24.645295
634	919030108949	outgoing	⚠️ ASKworX Smart Automation LLP Alert!\nYou have [1] new leads pending follow-up.\nLogin to dashboard to view details.	\N	2026-05-07 04:30:01.374235
635	917075813424	incoming	main_menu	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUM5N0Y3RDM2QjgxMjI5Q0EwN0JGNzJEM0ZEOTY1NEIA	2026-05-07 06:06:35.759325
636	917075813424	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-07 06:06:36.600037
637	917075813424	incoming	about_askworx	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUM3RUZEQjY2QTgyMkYwRjQ5MDI5ODcyNzg4OEE1MDcA	2026-05-07 06:06:43.786608
638	917075813424	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 About ASKworX Smart Automation LLP\nGround to Cloud — Engineering Smart Automation\n\nAt ASKworX Smart Automation LLP, we bridge the gap between shop-floor machinery and cloud-connected intelligence. We provide high-reliability solutions for modern manufacturing.\n\n🛠 Our Solutions:\n✅ PLC & SCADA Engineering\n✅ Control Panel Design\n✅ Industrial Networking\n✅ Robotics & Motion Control\n✅ IIoT & Cloud Integration\n✅ Data Visualization\n\n⚲ Office Address:\n1381, 6th Main Road, 1st Phase, BEML Layout, 5th Stage, RR Nagar, Bangalore, Karnataka - 560098.\n\n📞 Contact Detail:\n☎︎ +919030108949\n📧 contact@askworx.in\n🌐 www.askworx.in	\N	2026-05-07 06:06:44.289671
639	917075813424	incoming	get_free_quote	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUMxM0QxRDhCNEVDQTUzN0E1MUZCMjY3QTlBQTg2OTQA	2026-05-07 06:07:01.500781
640	917075813424	outgoing	💬 Free Consultation Request\nOur experts will analyze your requirements and provide a detailed proposal within 24 hours. 🎯\n\nPlease share your *full name*:	\N	2026-05-07 06:07:01.964996
641	919160969446	incoming	Hi	wamid.HBgMOTE5MTYwOTY5NDQ2FQIAEhggQUM0QjVEOUY2NTlGQTcyQjNEQkVDRkZGODBEMUExQjgA	2026-05-07 07:32:05.117409
642	919160969446	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-07 07:32:05.891142
643	919160969446	incoming	talk_to_expert	wamid.HBgMOTE5MTYwOTY5NDQ2FQIAEhggQUM1QjJCOTgwNEEzOTJEOTY5NDJCMTdFQjYwODMwMDIA	2026-05-07 07:32:15.423192
644	919160969446	outgoing	[Image: https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800] 📞 ASKworX Smart Automation LLP Support Center\nHow can we help you today?\n\nSelect a category below to connect with the right expert.	\N	2026-05-07 07:32:15.915384
645	919160969446	incoming	service	wamid.HBgMOTE5MTYwOTY5NDQ2FQIAEhggQUNBMUFDNEQzRUJGQ0VFMkNCMDYyMzQxMDZDNzZBNjEA	2026-05-07 07:32:32.495739
646	919160969446	outgoing	✅ *Selected:* Service Request\n\nWhich service area can we help you with?	\N	2026-05-07 07:32:32.898363
647	919160969446	incoming	cat_marketing	wamid.HBgMOTE5MTYwOTY5NDQ2FQIAEhggQUMyRERERDdGMjA0NjI5RUUxQjBBQzBCNEU1N0M0NEUA	2026-05-07 07:32:41.144182
648	919160969446	outgoing	Great choice! To connect you with the right expert, may I have your name?	\N	2026-05-07 07:32:41.516662
649	919160969446	incoming	Samba Shiva	wamid.HBgMOTE5MTYwOTY5NDQ2FQIAEhggQUNCNzFDMDQ5RUFENkFGQTI1MDYzQkQ4NTBDNjJGM0IA	2026-05-07 07:32:55.48253
650	919160969446	outgoing	Company name?	\N	2026-05-07 07:32:55.849395
651	919160969446	incoming	SR Automations	wamid.HBgMOTE5MTYwOTY5NDQ2FQIAEhggQUM5QUZFNDAyMkZGN0UyOEU3RjI0MjgyRjIwMEFGOEIA	2026-05-07 07:33:09.394148
652	919160969446	outgoing	Preferred time to connect?	\N	2026-05-07 07:33:10.07523
653	919160969446	incoming	Now	wamid.HBgMOTE5MTYwOTY5NDQ2FQIAEhggQUMwREY5REVEODAzRjQ3MzI0RDYyQ0I4Qjg0Qzc0MUMA	2026-05-07 07:33:46.578782
654	919160969446	outgoing	✅ Thank you! Our team will connect with you shortly.	\N	2026-05-07 07:33:47.000831
655	919030108949	outgoing	📩 *New Customer Query*\n\n👤 *Number:* +919160969446\n📂 *Category:* Service Request\n💬 *Message:* Interested In: Digital Marketing & SEO\nName: Samba Shiva\nCompany: SR Automations\nPreferred Time: Now\n\nLead generated from Expert Menu.	\N	2026-05-07 07:33:47.778463
656	912244066666	incoming	[UNSUPPORTED_RECEIVED]	wamid.HBgMOTEyMjQ0MDY2NjY2FQIAEhgSOEI4MzdGODhGQkY2NjE1RUVGAA==	2026-05-07 10:24:43.886854
657	912244066666	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-05-07 10:24:44.917678
658	919949306860	incoming	Hi	wamid.HBgMOTE5OTQ5MzA2ODYwFQIAEhggQTU4OUQxNUNGQzdFMDk2MUU4M0U5QjQ4MUFBRkM3RDEA	2026-05-07 11:23:27.512192
659	919949306860	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-07 11:23:28.409953
660	919035977090	incoming	Hi	wamid.HBgMOTE5MDM1OTc3MDkwFQIAEhgUM0E5MzY0QzYxNjIwNjk2MDdBRjgA	2026-05-07 15:01:41.155219
661	919035977090	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-07 15:01:41.915086
662	919035977090	incoming	our_solutions	wamid.HBgMOTE5MDM1OTc3MDkwFQIAEhgUM0FDRkQ4Rjg1ODQ4RDZFNTFBNjMA	2026-05-07 15:02:11.607326
665	919844095004	incoming	[CONTACTS_RECEIVED]	wamid.HBgMOTE5ODQ0MDk1MDA0FQIAEhggQUMwOTBBOTMyM0QxQzhCRjdDN0M1NzA3MDVDNUYwQTUA	2026-05-07 15:05:44.974895
666	919844095004	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-05-07 15:05:45.592243
663	919035977090	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-05-07 15:02:12.076877
664	919035977090	outgoing	Hi 	\N	2026-05-07 15:04:06.137097
667	919844095004	incoming	[DOCUMENT_RECEIVED]: 1-Pager_Bhavishyath_Training_Instt.pdf	wamid.HBgMOTE5ODQ0MDk1MDA0FQIAEhggQUMyMzg3MUVEMkY0RUUwMkU3NUM3NUMzM0FDQzI1NzMA	2026-05-07 15:06:07.259203
668	919844095004	outgoing	Please select one of the options above 👆	\N	2026-05-07 15:06:07.716622
669	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:01.152748
670	917058069655	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:01.903062
671	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:02.796578
672	919000736254	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:03.75126
673	919666773015	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:04.45886
674	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:05.187696
675	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:05.942897
676	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:06.606063
677	919035977090	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:07.371159
678	917075813424	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:08.273462
679	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:09.156254
680	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:09.804881
681	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:10.555162
682	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:11.130985
683	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:11.768781
684	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:12.356897
685	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:13.386291
686	919912312716	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:14.198517
687	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:14.858303
688	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:15.40447
689	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:16.145313
690	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:16.625425
691	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:17.521632
692	919844095004	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:18.070828
693	919160969446	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:18.575771
694	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:19.153727
695	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:19.65307
696	919000596952	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:20.166795
697	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:20.868523
698	912244066666	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:21.661295
699	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:22.324739
700	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:23.121825
701	919949306860	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:23.669447
702	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:24.263243
703	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:24.908399
704	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-08 04:00:25.457666
705	919030108949	outgoing	⚠️ ASKworX Smart Automation LLP Alert!\nYou have [2] new leads pending follow-up.\nLogin to dashboard to view details.	\N	2026-05-08 04:30:01.094076
706	918367518556	outgoing	Hi	\N	2026-05-08 04:59:03.52163
707	912244066666	incoming	[UNSUPPORTED_RECEIVED]	wamid.HBgMOTEyMjQ0MDY2NjY2FQIAEhgSNUIxMTkxMUEzNzEwRDAxMDZDAA==	2026-05-08 12:30:40.135506
708	912244066666	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-05-08 12:30:41.100721
709	917075813424	incoming	main_menu	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUM0RDIxNDM0MTBDNzUxOTZGNDREOUVGNzFCQzQ4ODYA	2026-05-08 13:49:32.865916
710	917075813424	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-08 13:49:33.625893
711	917075813424	incoming	about_askworx	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUM0MDRBOEZBMjQ5MDVFNjUzRjNGOUY4NEYzQjEyMjUA	2026-05-08 13:50:00.551868
712	917075813424	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 About ASKworX Smart Automation LLP\nGround to Cloud — Engineering Smart Automation\n\nAt ASKworX Smart Automation LLP, we bridge the gap between shop-floor machinery and cloud-connected intelligence. We provide high-reliability solutions for modern manufacturing.\n\n🛠 Our Solutions:\n✅ PLC & SCADA Engineering\n✅ Control Panel Design\n✅ Industrial Networking\n✅ Robotics & Motion Control\n✅ IIoT & Cloud Integration\n✅ Data Visualization\n\n⚲ Office Address:\n1381, 6th Main Road, 1st Phase, BEML Layout, 5th Stage, RR Nagar, Bangalore, Karnataka - 560098.\n\n📞 Contact Detail:\n☎︎ +919030108949\n📧 contact@askworx.in\n🌐 www.askworx.in	\N	2026-05-08 13:50:01.002917
713	917075813424	incoming	our_industries	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUMzMkYzQzFGRTIwQThFQjNCNTAxNzYzNDcyNDgwNzgA	2026-05-08 13:50:31.758014
714	917075813424	outgoing	🏭 Industries We Serve\n🚗 Automotive | 🔋 EV | 💊 Pharma | 🍔 Food & Bev | 📦 Material Handling | 👕 Textiles | EMS | Oil & Gas\n\nWe work with ALL manufacturing sectors!	\N	2026-05-08 13:50:32.367735
715	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:01.241744
716	917058069655	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:02.15429
717	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:03.038259
718	919000736254	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:03.991584
719	919666773015	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:04.594403
720	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:05.263531
721	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:06.020808
722	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:06.526608
723	919035977090	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:07.233599
724	917075813424	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:08.164631
725	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:09.142544
754	917075813424	incoming	our_solutions	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUNGNzQwQTE5OEI4Qjc4NDcxOTE2MjM0NjZFM0ZEOEYA	2026-05-09 04:40:37.505757
726	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:09.714841
727	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:10.477798
728	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:11.12641
729	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:11.797819
730	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:12.301039
731	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:13.083678
732	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:13.564512
733	919912312716	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:14.320789
734	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:14.99466
735	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:15.6651
736	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:16.122247
737	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:16.942037
738	919844095004	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:17.425618
739	919160969446	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:17.986676
740	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:18.429749
741	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:19.1012
742	919000596952	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:19.78976
743	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:20.639663
744	912244066666	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:21.380454
745	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:21.99669
746	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:22.486323
747	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:22.979601
748	919949306860	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:23.630935
749	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:24.21189
750	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-09 04:00:24.710821
751	919030108949	outgoing	⚠️ ASKworX Smart Automation LLP Alert!\nYou have [2] new leads pending follow-up.\nLogin to dashboard to view details.	\N	2026-05-09 04:30:01.089486
752	917075813424	incoming	main_menu	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUNCM0JGNDM1QkQwRDA1MjE5QjQwNjMwRTBDNEUzRkMA	2026-05-09 04:40:23.075851
753	917075813424	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-09 04:40:23.85978
755	917075813424	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-05-09 04:40:37.944268
756	917289047171	incoming	[UNSUPPORTED_RECEIVED]	wamid.HBgMOTE3Mjg5MDQ3MTcxFQIAEhgSRTcwOUM4MkIxRDVEN0Q1NzgwAA==	2026-05-09 11:47:32.201349
757	917289047171	outgoing	🤖 *ASKworX Smart Automation LLP Support Assistant*\n\nI can answer questions about our services, location, and technical capabilities.\n\n*Go ahead, ask me anything!* (e.g., 'What is SCADA?' or 'Where is your office?')	\N	2026-05-09 11:47:33.080217
758	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:01.276785
759	917058069655	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:02.501524
760	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:03.547477
761	919000736254	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:04.306895
762	919666773015	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:05.245865
763	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:05.961246
764	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:06.544573
765	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:07.050106
766	919035977090	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:07.803456
767	917075813424	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:08.633443
768	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:09.674289
769	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:10.188235
770	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:10.939223
771	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:11.658714
772	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:12.244461
773	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:12.930234
774	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:13.520096
775	919912312716	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:14.421065
776	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:15.068657
777	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:15.563076
778	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:16.218916
779	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:16.714413
780	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:17.610953
781	919844095004	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:18.106827
818	918019731640	incoming	back_to_software	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUM0Q0JBQkY1MEQwNzA5RTM0NjY5RTZGQ0JENEY2REEA	2026-05-10 13:53:28.248085
782	919160969446	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:18.578896
783	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:19.103715
784	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:19.776276
785	919000596952	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:20.562202
786	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:21.235054
787	912244066666	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:21.882543
788	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:22.467542
789	917289047171	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:23.099661
790	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:23.831697
791	919949306860	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:24.705358
792	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:25.270622
793	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:25.884421
794	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-10 04:00:26.471922
795	917075813424	incoming	main_menu	wamid.HBgMOTE3MDc1ODEzNDI0FQIAEhggQUNCODg5NEU1NDk1Mzc0Q0EwQTlDMjU1ODk0QTQ1RTEA	2026-05-10 04:19:53.8786
796	917075813424	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-10 04:19:54.797955
797	919030108949	outgoing	⚠️ ASKworX Smart Automation LLP Alert!\nYou have [2] new leads pending follow-up.\nLogin to dashboard to view details.	\N	2026-05-10 04:30:00.913326
798	918019731640	incoming	main_menu	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUNCMTBGRDdGNTUzQ0ZDN0IyNUVEQzQzNjZCRkY5MUYA	2026-05-10 13:42:50.584444
799	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-10 13:42:51.760244
800	918019731640	incoming	our_solutions	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUM4NTNCRTc3MjZCNEVCMjFEREFENUM0NTY2NUE3OUQA	2026-05-10 13:43:26.642602
801	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800] 🔧 Our Solutions — Ground to Cloud Automation\nFrom sensor-level data to cloud intelligence, we engineer the future of manufacturing.\n\n✅ PLC & SCADA Systems\n✅ Industrial Networking & IIoT\n✅ Digital Transformation (Software/ERP)\n✅ ATEX Certified Industrial Products\n✅ AI-Powered Data Analytics\n\nWhat are you looking for?	\N	2026-05-10 13:43:27.143834
802	918019731640	incoming	digital_software	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUM3QUUxMDlCRUUwQ0Q0NkE3NEQzMDBEOTJDOTgwMDUA	2026-05-10 13:43:58.265783
803	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=800] 💻 Digital & Software Solutions\nBridging traditional automation with modern digital thinking to scale your business.\n\nFrom automated customer engagement to full-scale enterprise software, we engineer tools that drive growth.	\N	2026-05-10 13:43:58.797923
804	918019731640	incoming	software_solutions	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUMwM0U1NzE0MUUzRTQ5N0MxMkE0RDlCNjUwNzhFQUMA	2026-05-10 13:44:26.058512
805	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800] 💻 Software Solutions\nCustom-engineered software systems to automate and scale your business operations.\n\nSelect a specialized solution:	\N	2026-05-10 13:44:26.537736
806	918019731640	incoming	web_app_dev	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUM3REQyMzM4MDIyQkJBQzEzQkIwOUVBQjk2QkJBODQA	2026-05-10 13:44:50.098715
807	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800] 🌐 Web & Mobile Portfolio\nEnterprise-grade digital products designed for high performance.\n\n✅ Progressive Web Apps (PWA)\n✅ High-Speed Corporate Websites\n✅ Mobile Apps (Flutter, React Native)\n✅ Headless CMS Solutions\n✅ Serverless API Architecture\n✅ AWS/GCP Cloud Deployment\n\nBuilt for speed, security, and extreme scalability. 🚀	\N	2026-05-10 13:44:50.561172
808	918019731640	incoming	industrial_sw	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUMyRTdDQUFFNDVGMzIyMzk2RDVGQjlFQzZGRTA4OTQA	2026-05-10 13:45:42.638823
809	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800] ⚙️ Industrial & ERP Software\nRobust backend systems to manage your shop floor and business.\n\n✅ Custom ERP & MES Systems\n✅ Real-time Inventory Tracking\n✅ Shop-floor Data Logging\n✅ Predictive Analytics Engines\n✅ Secure Cloud Dashboards\n✅ Desktop Process Monitors\n\nBridging the gap between machinery and business intelligence.	\N	2026-05-10 13:45:43.122984
810	918019731640	incoming	whatsapp_bot	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUMwRTZGRkUyREE2QjNERDQ1MEVCMjA3MkNCMjRGQzMA	2026-05-10 13:46:01.702255
811	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=800] 💻 Digital & Software Solutions\nBridging traditional automation with modern digital thinking to scale your business.\n\nFrom automated customer engagement to full-scale enterprise software, we engineer tools that drive growth.	\N	2026-05-10 13:46:02.33061
812	918019731640	incoming	get_free_quote	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUMzRDMwQjYzNzcwMzg2NTQ2NjhENzUwRkM1QkYwNzcA	2026-05-10 13:46:19.779774
813	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=800] 💻 Digital & Software Solutions\nBridging traditional automation with modern digital thinking to scale your business.\n\nFrom automated customer engagement to full-scale enterprise software, we engineer tools that drive growth.	\N	2026-05-10 13:46:20.237464
814	918019731640	incoming	industrial_auto	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUNGM0EyQkE1MjhBN0YwN0RFNDE3MkRGREUxNkVFQkEA	2026-05-10 13:46:57.048396
815	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=800] 💻 Digital & Software Solutions\nBridging traditional automation with modern digital thinking to scale your business.\n\nFrom automated customer engagement to full-scale enterprise software, we engineer tools that drive growth.	\N	2026-05-10 13:46:57.491208
816	918019731640	incoming	seo_marketing	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUM5Q0NGM0I0RkFDMDA3N0I1OEVFNzE1NDQ5REMxRkYA	2026-05-10 13:47:14.255246
817	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800] 📈 Digital Marketing & SEO\nDominating search results and driving high-intent traffic.\n\n✅ Data-Driven SEO Strategies\n✅ ROI-Focused Google Ads (PPC)\n✅ LinkedIn B2B Lead Generation\n✅ Social Media Brand Positioning\n✅ Content Authority Building\n✅ Advanced Analytics & Tracking\n\nWe don't just get traffic; we get paying customers.	\N	2026-05-10 13:47:14.78271
820	918019731640	incoming	main_menu	wamid.HBgMOTE4MDE5NzMxNjQwFQIAEhggQUM5MDJBMjI1OUFGQTRFNkYwMTcyMTg1MzU0RTBDNEMA	2026-05-10 13:54:26.696011
821	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800] 🏭 Welcome to ASKworX Smart Automation LLP!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?	\N	2026-05-10 13:54:27.204546
819	918019731640	outgoing	[Image: https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800] 💻 Software Solutions\nCustom-engineered software systems to automate and scale your business operations.\n\nSelect a specialized solution:	\N	2026-05-10 13:53:28.775192
822	919880564894	incoming	Hiii	wamid.HBgMOTE5ODgwNTY0ODk0FQIAEhggQUM3M0U2RjgzNTNCRTgwQkYxRDg3MTFEOTlERjgyQjMA	2026-05-10 17:01:25.597787
823	919880564894	outgoing	Hi! 👋 Thanks for reaching out to *ASKworX Smart Automation LLP*.\n\nWe've received your message and our team will assist you shortly.	\N	2026-05-10 17:01:26.344396
824	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:01.08255
825	917058069655	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:02.042968
826	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:02.799935
827	919000736254	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:03.569237
828	919666773015	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:04.472165
829	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:05.175495
830	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:05.845868
831	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:06.347879
832	917075813424	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:07.244222
833	919035977090	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:07.839769
834	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:08.698285
835	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:09.228281
836	919880564894	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:09.756248
837	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:10.552802
838	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:11.140176
839	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:12.00157
840	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:12.591477
841	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:13.399919
842	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:13.864254
843	919912312716	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:14.626027
844	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:15.286318
845	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:15.894536
846	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:16.860411
847	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:17.719381
848	919844095004	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:18.51296
849	919160969446	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:19.14859
850	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:19.700147
851	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:20.354483
852	919000596952	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:20.923493
853	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:21.482003
854	912244066666	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:22.054427
855	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:22.707535
856	917289047171	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:23.344618
857	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:23.861609
858	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:24.484138
859	919949306860	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:25.035437
860	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:25.595493
861	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-11 04:00:26.153633
862	919030108949	outgoing	⚠️ ASKworX Smart Automation LLP Alert!\nYou have [2] new leads pending follow-up.\nLogin to dashboard to view details.	\N	2026-05-11 04:30:00.910366
863	918147577824	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:01.232228
864	917058069655	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:02.142224
865	917559053238	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:02.801442
866	919000736254	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:03.547155
867	919652759166	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:04.265665
868	919666773015	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:05.01064
869	9030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:05.589023
870	919686699872	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:06.0402
871	917075813424	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:07.000445
872	919035977090	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:07.736255
873	918367518556	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:08.369304
874	919666543876	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:08.864283
875	919880564894	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:09.404503
876	918123054064	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:09.892229
877	919182396962	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:10.687293
878	919535903904	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:11.484719
879	919663261122	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:12.079435
880	918088693950	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:13.20427
881	919912312716	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:14.033541
882	917676776845	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:15.037852
883	919902314980	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:15.621645
884	918310029635	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:16.156352
885	919355777526	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:16.852261
886	919900803001	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:17.682375
887	919844095004	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:18.409804
888	919160969446	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:19.114684
889	919187458714	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:19.618655
890	919618307057	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:20.351647
891	919000596952	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:20.90491
892	919032173158	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:21.423639
893	912244066666	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:22.256088
894	918125163407	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:22.87648
895	917289047171	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:23.445373
896	919030108949	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:23.953502
897	919949306860	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:24.536803
898	919701288041	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:25.213361
899	918217822332	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:25.764191
900	918019731640	outgoing	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀	\N	2026-05-12 04:00:26.360529
901	919030108949	outgoing	⚠️ ASKworX Smart Automation LLP Alert!\nYou have [2] new leads pending follow-up.\nLogin to dashboard to view details.	\N	2026-05-12 04:30:00.772445
\.


--
-- Data for Name: quiz_responses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quiz_responses (id, quiz_id, phone, answer, is_correct, responded_at) FROM stdin;
\.


--
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quizzes (id, campaign_id, question, option_a, option_b, option_c, correct_answer, explanation, youtube_link, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: reminders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reminders (id, employee_phone, description, due_at, status) FROM stdin;
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settings (key, value) FROM stdin;
greeting_customer	🌅 *Good Morning from ASKworX Smart Automation LLP!* 🏭\n\nWe hope you have a productive day ahead. If you need any assistance with Industrial Automation, IIoT, or Software solutions, we are just a message away. 🚀
btn_start_day	🏢 START DAY
btn_end_day	🏢 END DAY
content_industrial_body	⚙️ Industrial Automation\nThe Foundation: Total Control at Machine Level\n\nWe design, build, and commission high-reliability automation systems engineered for continuous 24/7 industrial operations. Our experts specialize in creating seamless machine-level interfaces that maximize uptime.\n\n🔹 End-to-End System Design\n🔹 Retrofitting & Upgrades\n🔹 Machine Monitoring\n🔹 High-Performance Algorithms\n🔹 Safety-First Engineering\n\nSelect a service to learn more:
content_industrial_image	https://images.unsplash.com/photo-1537462715879-360eeb61a0ad?w=800
content_software_image	https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=800
content_iiot_body	📊 IIoT & Analytics Solutions\nConnecting your plant to the cloud.\n\nSelect a service:
support_center	📞 ASKworX Smart Automation LLP Support Center\nHow can we help you today?\n\nSelect a category below to connect with the right expert.
content_welcome_body	🏭 Welcome to {{company}}!\nGround to Cloud — Engineering Smart Automation\n\nWe help manufacturers move from shop-floor control to cloud-connected intelligence.\n\n🎯 Trusted by industries across India\n⚡ 24/7 Automation Support\n🌐 www.askworx.in\n\nHow can we assist you today?
content_iiot_image	https://images.unsplash.com/photo-1518770660439-4636190af475?w=800
greeting_employee	🌅 *Good Morning, {{name}}!* 🏆\n\nAnother day to pioneer industrial excellence. Don't forget to **Start Your Day** in the Internal Hub to log your focus objectives.\n\nLet's make an impact! 🚀
about_company	🏭 About ASKworX Smart Automation LLP\nGround to Cloud — Engineering Smart Automation\n\nAt ASKworX Smart Automation LLP, we bridge the gap between shop-floor machinery and cloud-connected intelligence. We provide high-reliability solutions for modern manufacturing.\n\n🛠 Our Solutions:\n✅ PLC & SCADA Engineering\n✅ Control Panel Design\n✅ Industrial Networking\n✅ Robotics & Motion Control\n✅ IIoT & Cloud Integration\n✅ Data Visualization\n\n⚲ Office Address:\n1381, 6th Main Road, 1st Phase, BEML Layout, 5th Stage, RR Nagar, Bangalore, Karnataka - 560098.\n\n📞 Contact Detail:\n☎︎ +919030108949\n📧 contact@askworx.in\n🌐 www.askworx.in
hub_welcome	*ASKworX Smart Automation LLP INTERNAL HUB*\n\nWelcome back, *Champion*! 🏆\n\nAt ASKworX Smart Automation LLP, we aren't just building automation; we are *pioneering the future* of industrial intelligence. 🏭✨\n\nYour expertise today moves the needle for industries worldwide. From Ground to Cloud, let's deliver excellence and show why ASKworX Smart Automation LLP is the leader in Smart Automation. 🚀\n\nReady to make an impact? Select an action below: 👇
btn_apply_leave	🏝️ APPLY LEAVE
content_welcome_image	https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800
content_software_body	💻 Digital & Software Solutions\nBridging traditional automation with modern digital thinking to scale your business.\n\nFrom automated customer engagement to full-scale enterprise software, we engineer tools that drive growth.
\.


--
-- Name: attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_id_seq', 1, false);


--
-- Name: callbacks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.callbacks_id_seq', 1, false);


--
-- Name: campaigns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.campaigns_id_seq', 1, false);


--
-- Name: contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contacts_id_seq', 1512, true);


--
-- Name: customer_queries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_queries_id_seq', 1, false);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_id_seq', 1, false);


--
-- Name: faqs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faqs_id_seq', 13, true);


--
-- Name: leads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leads_id_seq', 3, true);


--
-- Name: leave_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_requests_id_seq', 1, false);


--
-- Name: messages_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_log_id_seq', 901, true);


--
-- Name: quiz_responses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quiz_responses_id_seq', 1, false);


--
-- Name: quizzes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quizzes_id_seq', 1, false);


--
-- Name: reminders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reminders_id_seq', 1, false);


--
-- Name: attendance attendance_phone_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_phone_date_key UNIQUE (phone, date);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: callbacks callbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.callbacks
    ADD CONSTRAINT callbacks_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_phone_key UNIQUE (phone);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: customer_queries customer_queries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_queries
    ADD CONSTRAINT customer_queries_pkey PRIMARY KEY (id);


--
-- Name: employees employees_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_phone_key UNIQUE (phone);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: faqs faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faqs
    ADD CONSTRAINT faqs_pkey PRIMARY KEY (id);


--
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (id);


--
-- Name: messages_log messages_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages_log
    ADD CONSTRAINT messages_log_pkey PRIMARY KEY (id);


--
-- Name: messages_log messages_log_wa_msg_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages_log
    ADD CONSTRAINT messages_log_wa_msg_id_key UNIQUE (wa_msg_id);


--
-- Name: quiz_responses quiz_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_responses
    ADD CONSTRAINT quiz_responses_pkey PRIMARY KEY (id);


--
-- Name: quiz_responses quiz_responses_quiz_id_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_responses
    ADD CONSTRAINT quiz_responses_quiz_id_phone_key UNIQUE (quiz_id, phone);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: reminders reminders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reminders
    ADD CONSTRAINT reminders_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (key);


--
-- Name: quiz_responses quiz_responses_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_responses
    ADD CONSTRAINT quiz_responses_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id);


--
-- Name: quizzes quizzes_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id);


--
-- PostgreSQL database dump complete
--

\unrestrict Hc1NuVnYPdh5fveJMJACPBwlOuuBhf7SkQdQcVnyQ0bRkV7HAHjJ0RDeZQqVJtO

