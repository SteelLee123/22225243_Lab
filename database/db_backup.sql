--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

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

--
-- Name: get_outstanding_fees(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_outstanding_fees() RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    result JSON;
BEGIN
    WITH fee_summary AS (
        SELECT 
            s.student_id,
            s.student_name,
            COALESCE(SUM(f.amount_paid), 0) AS amount_paid,
            2000 - COALESCE(SUM(f.amount_paid), 0) AS outstanding_fee
        FROM Student s
        LEFT JOIN Student_Fees_Payments f ON s.student_id = f.student_id
        GROUP BY s.student_id, s.student_name
    )
    SELECT json_agg(
        json_build_object(
            'student_id', student_id,
            'student_name', student_name,
            'amount_paid', amount_paid,
            'outstanding_fee', outstanding_fee
        )
    )
    INTO result
    FROM fee_summary;

    RETURN result;
END;
$$;


ALTER FUNCTION public.get_outstanding_fees() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    password text NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_seq" OWNER TO postgres;

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- Name: course_enrollment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_enrollment (
    course_enrollment_id integer NOT NULL,
    course_id integer,
    student_id integer,
    course_enrollment_date date
);


ALTER TABLE public.course_enrollment OWNER TO postgres;

--
-- Name: course_enrollment_course_enrollment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_enrollment_course_enrollment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.course_enrollment_course_enrollment_id_seq OWNER TO postgres;

--
-- Name: course_enrollment_course_enrollment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_enrollment_course_enrollment_id_seq OWNED BY public.course_enrollment.course_enrollment_id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    course_id integer NOT NULL,
    course_title character varying(50) NOT NULL,
    course_credit integer NOT NULL,
    course_department character varying(40) NOT NULL
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- Name: courses_course_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courses_course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.courses_course_id_seq OWNER TO postgres;

--
-- Name: courses_course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courses_course_id_seq OWNED BY public.courses.course_id;


--
-- Name: lecturer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lecturer (
    lecturer_id integer NOT NULL,
    lecturer_name character varying(50) NOT NULL,
    lecturer_department character varying(40) NOT NULL,
    lecturer_email character varying(30) NOT NULL,
    course_id integer,
    ta_id integer
);


ALTER TABLE public.lecturer OWNER TO postgres;

--
-- Name: lecturer_lecturer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lecturer_lecturer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lecturer_lecturer_id_seq OWNER TO postgres;

--
-- Name: lecturer_lecturer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lecturer_lecturer_id_seq OWNED BY public.lecturer.lecturer_id;


--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    student_id integer NOT NULL,
    student_name character varying(50) NOT NULL,
    student_email character varying(50) NOT NULL,
    student_contact character varying(15) NOT NULL,
    student_department character varying(40)
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: student_fees_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_fees_payments (
    fee_payments_id integer NOT NULL,
    student_id integer,
    amount_paid numeric,
    balance numeric,
    payment_date date
);


ALTER TABLE public.student_fees_payments OWNER TO postgres;

--
-- Name: student_fees_payments_fee_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_fees_payments_fee_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_fees_payments_fee_payments_id_seq OWNER TO postgres;

--
-- Name: student_fees_payments_fee_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_fees_payments_fee_payments_id_seq OWNED BY public.student_fees_payments.fee_payments_id;


--
-- Name: student_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_student_id_seq OWNER TO postgres;

--
-- Name: student_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_student_id_seq OWNED BY public.student.student_id;


--
-- Name: ta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ta (
    ta_id integer NOT NULL,
    ta_name character varying(50) NOT NULL,
    ta_department character varying(40) NOT NULL,
    ta_email character varying(30)
);


ALTER TABLE public.ta OWNER TO postgres;

--
-- Name: ta_ta_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ta_ta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ta_ta_id_seq OWNER TO postgres;

--
-- Name: ta_ta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ta_ta_id_seq OWNED BY public.ta.ta_id;


--
-- Name: User id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- Name: course_enrollment course_enrollment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollment ALTER COLUMN course_enrollment_id SET DEFAULT nextval('public.course_enrollment_course_enrollment_id_seq'::regclass);


--
-- Name: courses course_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses ALTER COLUMN course_id SET DEFAULT nextval('public.courses_course_id_seq'::regclass);


--
-- Name: lecturer lecturer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer ALTER COLUMN lecturer_id SET DEFAULT nextval('public.lecturer_lecturer_id_seq'::regclass);


--
-- Name: student student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN student_id SET DEFAULT nextval('public.student_student_id_seq'::regclass);


--
-- Name: student_fees_payments fee_payments_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_fees_payments ALTER COLUMN fee_payments_id SET DEFAULT nextval('public.student_fees_payments_fee_payments_id_seq'::regclass);


--
-- Name: ta ta_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ta ALTER COLUMN ta_id SET DEFAULT nextval('public.ta_ta_id_seq'::regclass);


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, name, email, password) FROM stdin;
1	Test User	hi@edu.ug.gh	123123abc
\.


--
-- Data for Name: course_enrollment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_enrollment (course_enrollment_id, course_id, student_id, course_enrollment_date) FROM stdin;
1	1	1	2025-06-03
2	2	2	2025-06-03
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (course_id, course_title, course_credit, course_department) FROM stdin;
1	Software Engineering	3	Computer Engineering
2	Data Structures	3	Computer Engineering
3	Software Engineering	3	Computer Engineering
4	Data Structures	3	Computer Engineering
\.


--
-- Data for Name: lecturer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lecturer (lecturer_id, lecturer_name, lecturer_department, lecturer_email, course_id, ta_id) FROM stdin;
3	Mr.John Assiamah	Software Engineering	jasi@ug.edu.gh	\N	\N
4	Dr. John Doe	Linear Algebra	jdoe@ug.edu.gh	\N	\N
5	Mr.John Assiamah	Software Engineering	jasi@ug.edu.gh	\N	\N
6	Dr. John Doe	Linear Algebra	jdoe@ug.edu.gh	\N	\N
7	Mr.John Assiamah	Software Engineering	jasi@ug.edu.gh	\N	\N
8	Dr. John Kutor	Linear Algebra	jdoe@ug.edu.gh	\N	\N
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (student_id, student_name, student_email, student_contact, student_department) FROM stdin;
1	Ohnyu Lee	steel@st.ug.edu.gh	201234546	Computer Engineering
2	Abbigail Creel	acre@st.ug.edu.gh	541237654	Biomedical Engineering
\.


--
-- Data for Name: student_fees_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_fees_payments (fee_payments_id, student_id, amount_paid, balance, payment_date) FROM stdin;
1	1	1500.00	\N	2025-06-03
2	2	1000.00	\N	2025-06-03
\.


--
-- Data for Name: ta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ta (ta_id, ta_name, ta_department, ta_email) FROM stdin;
2	Akua Lee	Computer Engineering	akua@ug.edu.gh
3	Stephen Kim	Computer Engineering	akim@ug.edu.gh
\.


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_seq"', 1, true);


--
-- Name: course_enrollment_course_enrollment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_enrollment_course_enrollment_id_seq', 2, true);


--
-- Name: courses_course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courses_course_id_seq', 4, true);


--
-- Name: lecturer_lecturer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lecturer_lecturer_id_seq', 8, true);


--
-- Name: student_fees_payments_fee_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_fees_payments_fee_payments_id_seq', 2, true);


--
-- Name: student_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_student_id_seq', 2, true);


--
-- Name: ta_ta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ta_ta_id_seq', 3, true);


--
-- Name: User User_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_email_key" UNIQUE (email);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: course_enrollment course_enrollment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollment
    ADD CONSTRAINT course_enrollment_pkey PRIMARY KEY (course_enrollment_id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- Name: lecturer lecturer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer
    ADD CONSTRAINT lecturer_pkey PRIMARY KEY (lecturer_id);


--
-- Name: student_fees_payments student_fees_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_fees_payments
    ADD CONSTRAINT student_fees_payments_pkey PRIMARY KEY (fee_payments_id);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (student_id);


--
-- Name: ta ta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ta
    ADD CONSTRAINT ta_pkey PRIMARY KEY (ta_id);


--
-- Name: ta ta_ta_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ta
    ADD CONSTRAINT ta_ta_email_key UNIQUE (ta_email);


--
-- Name: course_enrollment course_enrollment_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollment
    ADD CONSTRAINT course_enrollment_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id);


--
-- Name: course_enrollment course_enrollment_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollment
    ADD CONSTRAINT course_enrollment_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id);


--
-- Name: lecturer lecturer_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer
    ADD CONSTRAINT lecturer_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id);


--
-- Name: lecturer lecturer_ta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer
    ADD CONSTRAINT lecturer_ta_id_fkey FOREIGN KEY (ta_id) REFERENCES public.ta(ta_id);


--
-- Name: student_fees_payments student_fees_payments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_fees_payments
    ADD CONSTRAINT student_fees_payments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id);


--
-- PostgreSQL database dump complete
--

