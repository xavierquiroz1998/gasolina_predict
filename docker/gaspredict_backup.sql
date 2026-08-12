--
-- PostgreSQL database dump
--

\restrict h9mgMrOyNMa24uaGV2nzDTA91Jvj7gTk9oQpkrihaNrHafWPnSJSeBqeBymE2xu

-- Dumped from database version 17.10 (Debian 17.10-0+deb13u1)
-- Dumped by pg_dump version 17.10 (Debian 17.10-0+deb13u1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: fuel_prices; Type: TABLE; Schema: public; Owner: gaspredict
--

CREATE TABLE public.fuel_prices (
    id integer NOT NULL,
    date date NOT NULL,
    fuel_type character varying(20) NOT NULL,
    price double precision NOT NULL,
    previous_price double precision,
    change_percent double precision,
    band_status character varying(10),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.fuel_prices OWNER TO gaspredict;

--
-- Name: COLUMN fuel_prices.date; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.fuel_prices.date IS 'Dia 11 del mes correspondiente';


--
-- Name: COLUMN fuel_prices.fuel_type; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.fuel_prices.fuel_type IS 'extra, ecopais, super_95, diesel';


--
-- Name: COLUMN fuel_prices.price; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.fuel_prices.price IS 'Precio en USD/galon';


--
-- Name: COLUMN fuel_prices.previous_price; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.fuel_prices.previous_price IS 'Precio del mes anterior';


--
-- Name: COLUMN fuel_prices.change_percent; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.fuel_prices.change_percent IS 'Porcentaje de cambio vs mes anterior';


--
-- Name: COLUMN fuel_prices.band_status; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.fuel_prices.band_status IS 'TECHO, PISO, DENTRO, LIBRE';


--
-- Name: fuel_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: gaspredict
--

CREATE SEQUENCE public.fuel_prices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fuel_prices_id_seq OWNER TO gaspredict;

--
-- Name: fuel_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gaspredict
--

ALTER SEQUENCE public.fuel_prices_id_seq OWNED BY public.fuel_prices.id;


--
-- Name: news_cache; Type: TABLE; Schema: public; Owner: gaspredict
--

CREATE TABLE public.news_cache (
    id integer NOT NULL,
    title character varying(500) NOT NULL,
    source character varying(200),
    url character varying(1000) NOT NULL,
    published_date timestamp without time zone,
    sentiment character varying(20) NOT NULL,
    sentiment_score double precision,
    summary text,
    fetched_at timestamp without time zone
);


ALTER TABLE public.news_cache OWNER TO gaspredict;

--
-- Name: COLUMN news_cache.title; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.news_cache.title IS 'Titulo de la noticia';


--
-- Name: COLUMN news_cache.source; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.news_cache.source IS 'Fuente de la noticia';


--
-- Name: COLUMN news_cache.url; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.news_cache.url IS 'URL unica de la noticia';


--
-- Name: COLUMN news_cache.published_date; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.news_cache.published_date IS 'Fecha de publicacion';


--
-- Name: COLUMN news_cache.sentiment; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.news_cache.sentiment IS 'positivo, negativo, neutro';


--
-- Name: COLUMN news_cache.sentiment_score; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.news_cache.sentiment_score IS 'Score numerico del sentimiento';


--
-- Name: COLUMN news_cache.summary; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.news_cache.summary IS 'Resumen o descripcion de la noticia';


--
-- Name: COLUMN news_cache.fetched_at; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.news_cache.fetched_at IS 'Cuando se obtuvo la noticia';


--
-- Name: news_cache_id_seq; Type: SEQUENCE; Schema: public; Owner: gaspredict
--

CREATE SEQUENCE public.news_cache_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.news_cache_id_seq OWNER TO gaspredict;

--
-- Name: news_cache_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gaspredict
--

ALTER SEQUENCE public.news_cache_id_seq OWNED BY public.news_cache.id;


--
-- Name: predictions; Type: TABLE; Schema: public; Owner: gaspredict
--

CREATE TABLE public.predictions (
    id integer NOT NULL,
    created_at timestamp without time zone,
    fuel_type character varying(20) NOT NULL,
    approach character varying(20) NOT NULL,
    target_date date NOT NULL,
    predicted_price double precision NOT NULL,
    actual_price double precision,
    wti_predicted double precision,
    wti_actual double precision,
    band_status character varying(10),
    accuracy_pct double precision,
    model_weights json,
    confidence_lower double precision,
    confidence_upper double precision
);


ALTER TABLE public.predictions OWNER TO gaspredict;

--
-- Name: COLUMN predictions.created_at; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.created_at IS 'Cuando se genero la prediccion';


--
-- Name: COLUMN predictions.fuel_type; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.fuel_type IS 'Tipo de combustible predicho';


--
-- Name: COLUMN predictions.approach; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.approach IS 'two_layer o ensemble';


--
-- Name: COLUMN predictions.target_date; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.target_date IS 'Dia 11 objetivo de la prediccion';


--
-- Name: COLUMN predictions.predicted_price; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.predicted_price IS 'Precio predicho USD/galon';


--
-- Name: COLUMN predictions.actual_price; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.actual_price IS 'Precio real (se llena cuando llega el dia 11)';


--
-- Name: COLUMN predictions.wti_predicted; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.wti_predicted IS 'WTI predicho para ese periodo';


--
-- Name: COLUMN predictions.wti_actual; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.wti_actual IS 'WTI real (se llena despues)';


--
-- Name: COLUMN predictions.band_status; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.band_status IS 'Estado de banda aplicado';


--
-- Name: COLUMN predictions.accuracy_pct; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.accuracy_pct IS 'Precision porcentual (se calcula despues)';


--
-- Name: COLUMN predictions.model_weights; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.model_weights IS 'Pesos del ensemble usados';


--
-- Name: COLUMN predictions.confidence_lower; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.confidence_lower IS 'Limite inferior intervalo de confianza';


--
-- Name: COLUMN predictions.confidence_upper; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.predictions.confidence_upper IS 'Limite superior intervalo de confianza';


--
-- Name: predictions_id_seq; Type: SEQUENCE; Schema: public; Owner: gaspredict
--

CREATE SEQUENCE public.predictions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.predictions_id_seq OWNER TO gaspredict;

--
-- Name: predictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gaspredict
--

ALTER SEQUENCE public.predictions_id_seq OWNED BY public.predictions.id;


--
-- Name: wti_daily; Type: TABLE; Schema: public; Owner: gaspredict
--

CREATE TABLE public.wti_daily (
    id integer NOT NULL,
    date date NOT NULL,
    close_price double precision NOT NULL,
    open_price double precision,
    high double precision,
    low double precision,
    volume bigint,
    created_at timestamp without time zone
);


ALTER TABLE public.wti_daily OWNER TO gaspredict;

--
-- Name: COLUMN wti_daily.date; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_daily.date IS 'Fecha del registro';


--
-- Name: COLUMN wti_daily.close_price; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_daily.close_price IS 'Precio de cierre USD/barril';


--
-- Name: COLUMN wti_daily.open_price; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_daily.open_price IS 'Precio de apertura';


--
-- Name: COLUMN wti_daily.high; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_daily.high IS 'Precio maximo del dia';


--
-- Name: COLUMN wti_daily.low; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_daily.low IS 'Precio minimo del dia';


--
-- Name: COLUMN wti_daily.volume; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_daily.volume IS 'Volumen de transacciones';


--
-- Name: wti_daily_id_seq; Type: SEQUENCE; Schema: public; Owner: gaspredict
--

CREATE SEQUENCE public.wti_daily_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wti_daily_id_seq OWNER TO gaspredict;

--
-- Name: wti_daily_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gaspredict
--

ALTER SEQUENCE public.wti_daily_id_seq OWNED BY public.wti_daily.id;


--
-- Name: wti_predictions; Type: TABLE; Schema: public; Owner: gaspredict
--

CREATE TABLE public.wti_predictions (
    id integer NOT NULL,
    created_at timestamp without time zone,
    target_month date NOT NULL,
    predicted_avg double precision NOT NULL,
    actual_avg double precision,
    confidence_lower double precision,
    confidence_upper double precision,
    sarima_prediction double precision,
    xgboost_prediction double precision,
    lstm_prediction double precision,
    weights json,
    accuracy_pct double precision
);


ALTER TABLE public.wti_predictions OWNER TO gaspredict;

--
-- Name: COLUMN wti_predictions.created_at; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_predictions.created_at IS 'Cuando se genero la prediccion';


--
-- Name: COLUMN wti_predictions.target_month; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_predictions.target_month IS 'Primer dia del mes objetivo';


--
-- Name: COLUMN wti_predictions.predicted_avg; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_predictions.predicted_avg IS 'Precio promedio predicho USD/barril';


--
-- Name: COLUMN wti_predictions.actual_avg; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_predictions.actual_avg IS 'Precio promedio real (se llena despues)';


--
-- Name: COLUMN wti_predictions.confidence_lower; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_predictions.confidence_lower IS 'Limite inferior del intervalo';


--
-- Name: COLUMN wti_predictions.confidence_upper; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_predictions.confidence_upper IS 'Limite superior del intervalo';


--
-- Name: COLUMN wti_predictions.sarima_prediction; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_predictions.sarima_prediction IS 'Prediccion individual SARIMA';


--
-- Name: COLUMN wti_predictions.xgboost_prediction; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_predictions.xgboost_prediction IS 'Prediccion individual XGBoost';


--
-- Name: COLUMN wti_predictions.lstm_prediction; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_predictions.lstm_prediction IS 'Prediccion individual LSTM';


--
-- Name: COLUMN wti_predictions.weights; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_predictions.weights IS 'Pesos del ensemble';


--
-- Name: COLUMN wti_predictions.accuracy_pct; Type: COMMENT; Schema: public; Owner: gaspredict
--

COMMENT ON COLUMN public.wti_predictions.accuracy_pct IS 'Precision porcentual (se calcula despues)';


--
-- Name: wti_predictions_id_seq; Type: SEQUENCE; Schema: public; Owner: gaspredict
--

CREATE SEQUENCE public.wti_predictions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wti_predictions_id_seq OWNER TO gaspredict;

--
-- Name: wti_predictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gaspredict
--

ALTER SEQUENCE public.wti_predictions_id_seq OWNED BY public.wti_predictions.id;


--
-- Name: fuel_prices id; Type: DEFAULT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.fuel_prices ALTER COLUMN id SET DEFAULT nextval('public.fuel_prices_id_seq'::regclass);


--
-- Name: news_cache id; Type: DEFAULT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.news_cache ALTER COLUMN id SET DEFAULT nextval('public.news_cache_id_seq'::regclass);


--
-- Name: predictions id; Type: DEFAULT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.predictions ALTER COLUMN id SET DEFAULT nextval('public.predictions_id_seq'::regclass);


--
-- Name: wti_daily id; Type: DEFAULT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.wti_daily ALTER COLUMN id SET DEFAULT nextval('public.wti_daily_id_seq'::regclass);


--
-- Name: wti_predictions id; Type: DEFAULT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.wti_predictions ALTER COLUMN id SET DEFAULT nextval('public.wti_predictions_id_seq'::regclass);


--
-- Data for Name: fuel_prices; Type: TABLE DATA; Schema: public; Owner: gaspredict
--

COPY public.fuel_prices (id, date, fuel_type, price, previous_price, change_percent, band_status, created_at, updated_at) FROM stdin;
1	2020-07-11	extra	1.75	\N	\N	\N	2026-08-07 17:12:27.154493	2026-08-07 17:12:27.154494
2	2020-07-11	ecopais	1.75	\N	\N	\N	2026-08-07 17:12:27.154495	2026-08-07 17:12:27.154495
3	2020-07-11	super_95	2.4	\N	\N	\N	2026-08-07 17:12:27.154496	2026-08-07 17:12:27.154497
4	2020-07-11	diesel	1.088	\N	\N	\N	2026-08-07 17:12:27.154498	2026-08-07 17:12:27.154498
5	2020-08-11	extra	1.75	1.75	0	DENTRO	2026-08-07 17:12:27.156617	2026-08-07 17:12:27.156619
6	2020-08-11	ecopais	1.75	1.75	0	DENTRO	2026-08-07 17:12:27.156619	2026-08-07 17:12:27.15662
7	2020-08-11	super_95	2.28	2.4	-5	LIBRE	2026-08-07 17:12:27.15662	2026-08-07 17:12:27.15662
8	2020-08-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.15662	2026-08-07 17:12:27.156621
9	2020-09-11	extra	1.68	1.75	-4	DENTRO	2026-08-07 17:12:27.156621	2026-08-07 17:12:27.156621
10	2020-09-11	ecopais	1.68	1.75	-4	DENTRO	2026-08-07 17:12:27.156621	2026-08-07 17:12:27.156622
11	2020-09-11	super_95	2.15	2.28	-5.7	LIBRE	2026-08-07 17:12:27.156622	2026-08-07 17:12:27.156622
12	2020-09-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156622	2026-08-07 17:12:27.156623
13	2020-10-11	extra	1.68	1.68	0	DENTRO	2026-08-07 17:12:27.156623	2026-08-07 17:12:27.156623
14	2020-10-11	ecopais	1.68	1.68	0	DENTRO	2026-08-07 17:12:27.156624	2026-08-07 17:12:27.156624
15	2020-10-11	super_95	2.1	2.15	-2.33	LIBRE	2026-08-07 17:12:27.156624	2026-08-07 17:12:27.156624
16	2020-10-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156625	2026-08-07 17:12:27.156625
17	2020-11-11	extra	1.68	1.68	0	DENTRO	2026-08-07 17:12:27.156625	2026-08-07 17:12:27.156625
18	2020-11-11	ecopais	1.68	1.68	0	DENTRO	2026-08-07 17:12:27.156625	2026-08-07 17:12:27.156626
19	2020-11-11	super_95	2	2.1	-4.76	LIBRE	2026-08-07 17:12:27.156626	2026-08-07 17:12:27.156626
20	2020-11-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156626	2026-08-07 17:12:27.156627
21	2020-12-11	extra	1.75	1.68	4.17	DENTRO	2026-08-07 17:12:27.156627	2026-08-07 17:12:27.156627
22	2020-12-11	ecopais	1.75	1.68	4.17	DENTRO	2026-08-07 17:12:27.156627	2026-08-07 17:12:27.156627
23	2020-12-11	super_95	2.15	2	7.5	LIBRE	2026-08-07 17:12:27.156628	2026-08-07 17:12:27.156628
24	2020-12-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156628	2026-08-07 17:12:27.156628
25	2021-01-11	extra	1.75	1.75	0	DENTRO	2026-08-07 17:12:27.156628	2026-08-07 17:12:27.156629
26	2021-01-11	ecopais	1.75	1.75	0	DENTRO	2026-08-07 17:12:27.156629	2026-08-07 17:12:27.156629
27	2021-01-11	super_95	2.2	2.15	2.33	LIBRE	2026-08-07 17:12:27.156629	2026-08-07 17:12:27.15663
28	2021-01-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.15663	2026-08-07 17:12:27.15663
29	2021-02-11	extra	1.8	1.75	2.86	DENTRO	2026-08-07 17:12:27.15663	2026-08-07 17:12:27.15663
30	2021-02-11	ecopais	1.8	1.75	2.86	DENTRO	2026-08-07 17:12:27.156631	2026-08-07 17:12:27.156631
31	2021-02-11	super_95	2.3	2.2	4.55	LIBRE	2026-08-07 17:12:27.156631	2026-08-07 17:12:27.156631
32	2021-02-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156632	2026-08-07 17:12:27.156632
33	2021-03-11	extra	1.85	1.8	2.78	DENTRO	2026-08-07 17:12:27.156632	2026-08-07 17:12:27.156632
34	2021-03-11	ecopais	1.85	1.8	2.78	DENTRO	2026-08-07 17:12:27.156632	2026-08-07 17:12:27.156633
35	2021-03-11	super_95	2.45	2.3	6.52	LIBRE	2026-08-07 17:12:27.156633	2026-08-07 17:12:27.156633
36	2021-03-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156633	2026-08-07 17:12:27.156634
37	2021-04-11	extra	1.85	1.85	0	DENTRO	2026-08-07 17:12:27.156634	2026-08-07 17:12:27.156634
38	2021-04-11	ecopais	1.85	1.85	0	DENTRO	2026-08-07 17:12:27.156634	2026-08-07 17:12:27.156634
39	2021-04-11	super_95	2.4	2.45	-2.04	LIBRE	2026-08-07 17:12:27.156635	2026-08-07 17:12:27.156635
40	2021-04-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156635	2026-08-07 17:12:27.156635
41	2021-05-11	extra	1.9	1.85	2.7	DENTRO	2026-08-07 17:12:27.156636	2026-08-07 17:12:27.156636
42	2021-05-11	ecopais	1.9	1.85	2.7	DENTRO	2026-08-07 17:12:27.156636	2026-08-07 17:12:27.156636
43	2021-05-11	super_95	2.55	2.4	6.25	LIBRE	2026-08-07 17:12:27.156636	2026-08-07 17:12:27.156637
44	2021-05-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156637	2026-08-07 17:12:27.156637
45	2021-06-11	extra	1.95	1.9	2.63	DENTRO	2026-08-07 17:12:27.156637	2026-08-07 17:12:27.156638
46	2021-06-11	ecopais	1.95	1.9	2.63	DENTRO	2026-08-07 17:12:27.156638	2026-08-07 17:12:27.156638
47	2021-06-11	super_95	2.7	2.55	5.88	LIBRE	2026-08-07 17:12:27.156638	2026-08-07 17:12:27.156638
48	2021-06-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156639	2026-08-07 17:12:27.156639
49	2021-07-11	extra	2	1.95	2.56	DENTRO	2026-08-07 17:12:27.156639	2026-08-07 17:12:27.156639
50	2021-07-11	ecopais	2	1.95	2.56	DENTRO	2026-08-07 17:12:27.15664	2026-08-07 17:12:27.15664
51	2021-07-11	super_95	2.8	2.7	3.7	LIBRE	2026-08-07 17:12:27.15664	2026-08-07 17:12:27.15664
52	2021-07-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.15664	2026-08-07 17:12:27.156641
53	2021-08-11	extra	2	2	0	DENTRO	2026-08-07 17:12:27.156641	2026-08-07 17:12:27.156641
54	2021-08-11	ecopais	2	2	0	DENTRO	2026-08-07 17:12:27.156641	2026-08-07 17:12:27.156642
55	2021-08-11	super_95	2.75	2.8	-1.79	LIBRE	2026-08-07 17:12:27.156642	2026-08-07 17:12:27.156642
56	2021-08-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156642	2026-08-07 17:12:27.156642
57	2021-09-11	extra	2	2	0	DENTRO	2026-08-07 17:12:27.156643	2026-08-07 17:12:27.156643
58	2021-09-11	ecopais	2	2	0	DENTRO	2026-08-07 17:12:27.156643	2026-08-07 17:12:27.156644
59	2021-09-11	super_95	2.68	2.75	-2.55	LIBRE	2026-08-07 17:12:27.156644	2026-08-07 17:12:27.156644
60	2021-09-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156644	2026-08-07 17:12:27.156644
61	2021-10-11	extra	2.05	2	2.5	DENTRO	2026-08-07 17:12:27.156645	2026-08-07 17:12:27.156645
62	2021-10-11	ecopais	2.05	2	2.5	DENTRO	2026-08-07 17:12:27.156645	2026-08-07 17:12:27.156645
63	2021-10-11	super_95	2.85	2.68	6.34	LIBRE	2026-08-07 17:12:27.156645	2026-08-07 17:12:27.156646
64	2021-10-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156646	2026-08-07 17:12:27.156646
65	2021-11-11	extra	2.1	2.05	2.44	DENTRO	2026-08-07 17:12:27.156646	2026-08-07 17:12:27.156647
66	2021-11-11	ecopais	2.1	2.05	2.44	DENTRO	2026-08-07 17:12:27.156647	2026-08-07 17:12:27.156647
67	2021-11-11	super_95	3.1	2.85	8.77	LIBRE	2026-08-07 17:12:27.156647	2026-08-07 17:12:27.156647
68	2021-11-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156648	2026-08-07 17:12:27.156648
69	2021-12-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156648	2026-08-07 17:12:27.156648
70	2021-12-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156648	2026-08-07 17:12:27.156649
71	2021-12-11	super_95	3.05	3.1	-1.61	LIBRE	2026-08-07 17:12:27.156649	2026-08-07 17:12:27.156649
72	2021-12-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156649	2026-08-07 17:12:27.15665
73	2022-01-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.15665	2026-08-07 17:12:27.15665
74	2022-01-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.15665	2026-08-07 17:12:27.156651
75	2022-01-11	super_95	3.1	3.05	1.64	LIBRE	2026-08-07 17:12:27.156651	2026-08-07 17:12:27.156651
76	2022-01-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156651	2026-08-07 17:12:27.156651
77	2022-02-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156652	2026-08-07 17:12:27.156652
78	2022-02-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156652	2026-08-07 17:12:27.156652
79	2022-02-11	super_95	3.2	3.1	3.23	LIBRE	2026-08-07 17:12:27.156653	2026-08-07 17:12:27.156653
80	2022-02-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156653	2026-08-07 17:12:27.156653
81	2022-03-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156653	2026-08-07 17:12:27.156654
82	2022-03-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156654	2026-08-07 17:12:27.156654
83	2022-03-11	super_95	3.5	3.2	9.37	LIBRE	2026-08-07 17:12:27.156654	2026-08-07 17:12:27.156654
84	2022-03-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156655	2026-08-07 17:12:27.156655
85	2022-04-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156655	2026-08-07 17:12:27.156655
86	2022-04-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156656	2026-08-07 17:12:27.156656
87	2022-04-11	super_95	3.72	3.5	6.29	LIBRE	2026-08-07 17:12:27.156656	2026-08-07 17:12:27.156656
88	2022-04-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156656	2026-08-07 17:12:27.156657
89	2022-05-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156657	2026-08-07 17:12:27.156657
90	2022-05-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156657	2026-08-07 17:12:27.156658
91	2022-05-11	super_95	3.81	3.72	2.42	LIBRE	2026-08-07 17:12:27.156658	2026-08-07 17:12:27.156658
92	2022-05-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156658	2026-08-07 17:12:27.156658
93	2022-06-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156659	2026-08-07 17:12:27.156659
94	2022-06-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156659	2026-08-07 17:12:27.156659
95	2022-06-11	super_95	4.1	3.81	7.61	LIBRE	2026-08-07 17:12:27.15666	2026-08-07 17:12:27.15666
96	2022-06-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.15666	2026-08-07 17:12:27.15666
97	2022-07-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156661	2026-08-07 17:12:27.156661
98	2022-07-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156661	2026-08-07 17:12:27.156661
99	2022-07-11	super_95	3.9	4.1	-4.88	LIBRE	2026-08-07 17:12:27.156662	2026-08-07 17:12:27.156662
100	2022-07-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156662	2026-08-07 17:12:27.156662
101	2022-08-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156663	2026-08-07 17:12:27.156663
102	2022-08-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156708	2026-08-07 17:12:27.15671
103	2022-08-11	super_95	3.65	3.9	-6.41	LIBRE	2026-08-07 17:12:27.15671	2026-08-07 17:12:27.156711
104	2022-08-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156711	2026-08-07 17:12:27.156711
105	2022-09-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156711	2026-08-07 17:12:27.156712
106	2022-09-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156712	2026-08-07 17:12:27.156712
107	2022-09-11	super_95	3.45	3.65	-5.48	LIBRE	2026-08-07 17:12:27.156712	2026-08-07 17:12:27.156713
108	2022-09-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156713	2026-08-07 17:12:27.156713
109	2022-10-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156713	2026-08-07 17:12:27.156713
110	2022-10-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156714	2026-08-07 17:12:27.156714
111	2022-10-11	super_95	3.38	3.45	-2.03	LIBRE	2026-08-07 17:12:27.156714	2026-08-07 17:12:27.156714
112	2022-10-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156715	2026-08-07 17:12:27.156715
113	2022-11-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156715	2026-08-07 17:12:27.156715
114	2022-11-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156715	2026-08-07 17:12:27.156716
115	2022-11-11	super_95	3.2	3.38	-5.33	LIBRE	2026-08-07 17:12:27.156716	2026-08-07 17:12:27.156716
116	2022-11-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156716	2026-08-07 17:12:27.156717
117	2022-12-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156717	2026-08-07 17:12:27.156717
118	2022-12-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156717	2026-08-07 17:12:27.156717
119	2022-12-11	super_95	3.05	3.2	-4.69	LIBRE	2026-08-07 17:12:27.156718	2026-08-07 17:12:27.156718
120	2022-12-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156718	2026-08-07 17:12:27.156718
121	2023-01-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156719	2026-08-07 17:12:27.156719
122	2023-01-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156719	2026-08-07 17:12:27.156719
123	2023-01-11	super_95	2.95	3.05	-3.28	LIBRE	2026-08-07 17:12:27.156719	2026-08-07 17:12:27.15672
124	2023-01-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.15672	2026-08-07 17:12:27.15672
125	2023-02-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.15672	2026-08-07 17:12:27.156721
126	2023-02-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156721	2026-08-07 17:12:27.156721
127	2023-02-11	super_95	2.85	2.95	-3.39	LIBRE	2026-08-07 17:12:27.156721	2026-08-07 17:12:27.156722
128	2023-02-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156722	2026-08-07 17:12:27.156722
129	2023-03-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156722	2026-08-07 17:12:27.156723
130	2023-03-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156723	2026-08-07 17:12:27.156723
131	2023-03-11	super_95	2.8	2.85	-1.75	LIBRE	2026-08-07 17:12:27.156723	2026-08-07 17:12:27.156723
132	2023-03-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156724	2026-08-07 17:12:27.156724
133	2023-04-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156724	2026-08-07 17:12:27.156724
134	2023-04-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156725	2026-08-07 17:12:27.156725
135	2023-04-11	super_95	2.85	2.8	1.79	LIBRE	2026-08-07 17:12:27.156725	2026-08-07 17:12:27.156725
136	2023-04-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156725	2026-08-07 17:12:27.156726
137	2023-05-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156726	2026-08-07 17:12:27.156726
138	2023-05-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156726	2026-08-07 17:12:27.156726
139	2023-05-11	super_95	2.75	2.85	-3.51	LIBRE	2026-08-07 17:12:27.156727	2026-08-07 17:12:27.156727
140	2023-05-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156727	2026-08-07 17:12:27.156727
141	2023-06-11	extra	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156728	2026-08-07 17:12:27.156728
142	2023-06-11	ecopais	2.1	2.1	0	DENTRO	2026-08-07 17:12:27.156728	2026-08-07 17:12:27.156728
143	2023-06-11	super_95	2.7	2.75	-1.82	LIBRE	2026-08-07 17:12:27.156729	2026-08-07 17:12:27.156729
144	2023-06-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156731	2026-08-07 17:12:27.156731
145	2023-07-11	extra	2.4	2.1	14.29	TECHO	2026-08-07 17:12:27.156731	2026-08-07 17:12:27.156731
146	2023-07-11	ecopais	2.4	2.1	14.29	TECHO	2026-08-07 17:12:27.156732	2026-08-07 17:12:27.156732
147	2023-07-11	super_95	2.75	2.7	1.85	LIBRE	2026-08-07 17:12:27.156732	2026-08-07 17:12:27.156732
148	2023-07-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156733	2026-08-07 17:12:27.156733
149	2023-08-11	extra	2.4	2.4	0	DENTRO	2026-08-07 17:12:27.156733	2026-08-07 17:12:27.156733
150	2023-08-11	ecopais	2.4	2.4	0	DENTRO	2026-08-07 17:12:27.156734	2026-08-07 17:12:27.156734
151	2023-08-11	super_95	2.9	2.75	5.45	LIBRE	2026-08-07 17:12:27.156734	2026-08-07 17:12:27.156734
152	2023-08-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156734	2026-08-07 17:12:27.156735
153	2023-09-11	extra	2.4	2.4	0	DENTRO	2026-08-07 17:12:27.156735	2026-08-07 17:12:27.156735
154	2023-09-11	ecopais	2.4	2.4	0	DENTRO	2026-08-07 17:12:27.156735	2026-08-07 17:12:27.156736
155	2023-09-11	super_95	3.1	2.9	6.9	LIBRE	2026-08-07 17:12:27.156736	2026-08-07 17:12:27.156736
156	2023-09-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156736	2026-08-07 17:12:27.156736
157	2023-10-11	extra	2.465	2.4	2.71	DENTRO	2026-08-07 17:12:27.156737	2026-08-07 17:12:27.156737
158	2023-10-11	ecopais	2.465	2.4	2.71	DENTRO	2026-08-07 17:12:27.156737	2026-08-07 17:12:27.156737
159	2023-10-11	super_95	3.05	3.1	-1.61	LIBRE	2026-08-07 17:12:27.156737	2026-08-07 17:12:27.156738
160	2023-10-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156738	2026-08-07 17:12:27.156738
161	2023-11-11	extra	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156738	2026-08-07 17:12:27.156739
162	2023-11-11	ecopais	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156739	2026-08-07 17:12:27.156739
163	2023-11-11	super_95	2.95	3.05	-3.28	LIBRE	2026-08-07 17:12:27.156739	2026-08-07 17:12:27.156739
164	2023-11-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.15674	2026-08-07 17:12:27.15674
165	2023-12-11	extra	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.15674	2026-08-07 17:12:27.15674
166	2023-12-11	ecopais	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156741	2026-08-07 17:12:27.156741
167	2023-12-11	super_95	2.8	2.95	-5.08	LIBRE	2026-08-07 17:12:27.156741	2026-08-07 17:12:27.156742
168	2023-12-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156742	2026-08-07 17:12:27.156742
169	2024-01-11	extra	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156742	2026-08-07 17:12:27.156743
170	2024-01-11	ecopais	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156743	2026-08-07 17:12:27.156744
171	2024-01-11	super_95	2.72	2.8	-2.86	LIBRE	2026-08-07 17:12:27.156744	2026-08-07 17:12:27.156745
172	2024-01-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156745	2026-08-07 17:12:27.156745
173	2024-02-11	extra	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156746	2026-08-07 17:12:27.156746
174	2024-02-11	ecopais	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156746	2026-08-07 17:12:27.156747
175	2024-02-11	super_95	2.75	2.72	1.1	LIBRE	2026-08-07 17:12:27.156747	2026-08-07 17:12:27.156747
176	2024-02-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156748	2026-08-07 17:12:27.156748
177	2024-03-11	extra	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156748	2026-08-07 17:12:27.156748
178	2024-03-11	ecopais	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156749	2026-08-07 17:12:27.156749
179	2024-03-11	super_95	2.8	2.75	1.82	LIBRE	2026-08-07 17:12:27.15675	2026-08-07 17:12:27.15675
180	2024-03-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.15675	2026-08-07 17:12:27.156751
181	2024-04-11	extra	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156751	2026-08-07 17:12:27.156751
182	2024-04-11	ecopais	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156752	2026-08-07 17:12:27.156752
183	2024-04-11	super_95	2.85	2.8	1.79	LIBRE	2026-08-07 17:12:27.156752	2026-08-07 17:12:27.156753
184	2024-04-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156753	2026-08-07 17:12:27.156754
185	2024-05-11	extra	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156754	2026-08-07 17:12:27.156754
186	2024-05-11	ecopais	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156755	2026-08-07 17:12:27.156758
187	2024-05-11	super_95	2.95	2.85	3.51	LIBRE	2026-08-07 17:12:27.156758	2026-08-07 17:12:27.156758
188	2024-05-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.156758	2026-08-07 17:12:27.156758
189	2024-06-11	extra	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156759	2026-08-07 17:12:27.156759
190	2024-06-11	ecopais	2.465	2.465	0	DENTRO	2026-08-07 17:12:27.156759	2026-08-07 17:12:27.156759
191	2024-06-11	super_95	2.9	2.95	-1.69	LIBRE	2026-08-07 17:12:27.15676	2026-08-07 17:12:27.15676
192	2024-06-11	diesel	1.088	1.088	0	DENTRO	2026-08-07 17:12:27.15676	2026-08-07 17:12:27.15676
193	2024-07-11	extra	2.722	2.465	10.43	TECHO	2026-08-07 17:12:27.156761	2026-08-07 17:12:27.156761
194	2024-07-11	ecopais	2.722	2.465	10.43	TECHO	2026-08-07 17:12:27.156761	2026-08-07 17:12:27.156761
195	2024-07-11	super_95	3.1	2.9	6.9	LIBRE	2026-08-07 17:12:27.156761	2026-08-07 17:12:27.156762
196	2024-07-11	diesel	1.8	1.088	65.44	TECHO	2026-08-07 17:12:27.156762	2026-08-07 17:12:27.156762
197	2024-08-11	extra	2.722	2.722	0	DENTRO	2026-08-07 17:12:27.156762	2026-08-07 17:12:27.156762
198	2024-08-11	ecopais	2.722	2.722	0	DENTRO	2026-08-07 17:12:27.156763	2026-08-07 17:12:27.156763
199	2024-08-11	super_95	3.05	3.1	-1.61	LIBRE	2026-08-07 17:12:27.156764	2026-08-07 17:12:27.156764
200	2024-08-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156764	2026-08-07 17:12:27.156765
201	2024-09-11	extra	2.742	2.722	0.73	DENTRO	2026-08-07 17:12:27.156765	2026-08-07 17:12:27.156765
202	2024-09-11	ecopais	2.742	2.722	0.73	DENTRO	2026-08-07 17:12:27.156766	2026-08-07 17:12:27.156766
203	2024-09-11	super_95	3	3.05	-1.64	LIBRE	2026-08-07 17:12:27.156766	2026-08-07 17:12:27.156767
204	2024-09-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156767	2026-08-07 17:12:27.156767
205	2024-10-11	extra	2.796	2.742	1.97	DENTRO	2026-08-07 17:12:27.156768	2026-08-07 17:12:27.156768
206	2024-10-11	ecopais	2.796	2.742	1.97	DENTRO	2026-08-07 17:12:27.156768	2026-08-07 17:12:27.156769
207	2024-10-11	super_95	3.1	3	3.33	LIBRE	2026-08-07 17:12:27.156769	2026-08-07 17:12:27.15677
208	2024-10-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.15677	2026-08-07 17:12:27.15677
209	2024-11-11	extra	2.783	2.796	-0.46	DENTRO	2026-08-07 17:12:27.15677	2026-08-07 17:12:27.156771
210	2024-11-11	ecopais	2.783	2.796	-0.46	DENTRO	2026-08-07 17:12:27.156771	2026-08-07 17:12:27.156771
211	2024-11-11	super_95	2.95	3.1	-4.84	LIBRE	2026-08-07 17:12:27.156771	2026-08-07 17:12:27.156772
212	2024-11-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156772	2026-08-07 17:12:27.156772
213	2024-12-11	extra	2.723	2.783	-2.16	DENTRO	2026-08-07 17:12:27.156772	2026-08-07 17:12:27.156772
214	2024-12-11	ecopais	2.723	2.783	-2.16	DENTRO	2026-08-07 17:12:27.156773	2026-08-07 17:12:27.156773
215	2024-12-11	super_95	2.85	2.95	-3.39	LIBRE	2026-08-07 17:12:27.156773	2026-08-07 17:12:27.156773
216	2024-12-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156774	2026-08-07 17:12:27.156774
217	2025-01-11	extra	2.692	2.723	-1.14	DENTRO	2026-08-07 17:12:27.156774	2026-08-07 17:12:27.156774
218	2025-01-11	ecopais	2.692	2.723	-1.14	DENTRO	2026-08-07 17:12:27.156774	2026-08-07 17:12:27.156775
219	2025-01-11	super_95	2.8	2.85	-1.75	LIBRE	2026-08-07 17:12:27.156775	2026-08-07 17:12:27.156775
220	2025-01-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156775	2026-08-07 17:12:27.156776
221	2025-02-11	extra	2.733	2.692	1.52	DENTRO	2026-08-07 17:12:27.156776	2026-08-07 17:12:27.156776
222	2025-02-11	ecopais	2.733	2.692	1.52	DENTRO	2026-08-07 17:12:27.156776	2026-08-07 17:12:27.156776
223	2025-02-11	super_95	2.9	2.8	3.57	LIBRE	2026-08-07 17:12:27.156777	2026-08-07 17:12:27.156777
224	2025-02-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156777	2026-08-07 17:12:27.156777
225	2025-03-11	extra	2.786	2.733	1.94	DENTRO	2026-08-07 17:12:27.156778	2026-08-07 17:12:27.156778
226	2025-03-11	ecopais	2.786	2.733	1.94	DENTRO	2026-08-07 17:12:27.156778	2026-08-07 17:12:27.156778
227	2025-03-11	super_95	2.95	2.9	1.72	LIBRE	2026-08-07 17:12:27.156778	2026-08-07 17:12:27.156779
228	2025-03-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156779	2026-08-07 17:12:27.156779
229	2025-04-11	extra	2.826	2.786	1.44	DENTRO	2026-08-07 17:12:27.15678	2026-08-07 17:12:27.156781
230	2025-04-11	ecopais	2.826	2.786	1.44	DENTRO	2026-08-07 17:12:27.156781	2026-08-07 17:12:27.156781
231	2025-04-11	super_95	3.05	2.95	3.39	LIBRE	2026-08-07 17:12:27.156781	2026-08-07 17:12:27.156781
232	2025-04-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156782	2026-08-07 17:12:27.156782
233	2025-05-11	extra	2.853	2.826	0.96	DENTRO	2026-08-07 17:12:27.156782	2026-08-07 17:12:27.156782
234	2025-05-11	ecopais	2.853	2.826	0.96	DENTRO	2026-08-07 17:12:27.156783	2026-08-07 17:12:27.156783
235	2025-05-11	super_95	3.12	3.05	2.3	LIBRE	2026-08-07 17:12:27.156783	2026-08-07 17:12:27.156783
236	2025-05-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156783	2026-08-07 17:12:27.156784
237	2025-06-11	extra	2.879	2.853	0.91	DENTRO	2026-08-07 17:12:27.156784	2026-08-07 17:12:27.156784
238	2025-06-11	ecopais	2.879	2.853	0.91	DENTRO	2026-08-07 17:12:27.156784	2026-08-07 17:12:27.156784
239	2025-06-11	super_95	3.15	3.12	0.96	LIBRE	2026-08-07 17:12:27.156785	2026-08-07 17:12:27.156785
240	2025-06-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156785	2026-08-07 17:12:27.156785
241	2025-07-11	extra	2.896	2.879	0.59	DENTRO	2026-08-07 17:12:27.156786	2026-08-07 17:12:27.156786
242	2025-07-11	ecopais	2.896	2.879	0.59	DENTRO	2026-08-07 17:12:27.156786	2026-08-07 17:12:27.156786
243	2025-07-11	super_95	3.2	3.15	1.59	LIBRE	2026-08-07 17:12:27.156786	2026-08-07 17:12:27.156787
244	2025-07-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156787	2026-08-07 17:12:27.156787
245	2025-08-11	extra	2.91	2.896	0.48	DENTRO	2026-08-07 17:12:27.156787	2026-08-07 17:12:27.156788
246	2025-08-11	ecopais	2.91	2.896	0.48	DENTRO	2026-08-07 17:12:27.156788	2026-08-07 17:12:27.156788
247	2025-08-11	super_95	3.25	3.2	1.56	LIBRE	2026-08-07 17:12:27.156788	2026-08-07 17:12:27.156788
248	2025-08-11	diesel	1.8	1.8	0	DENTRO	2026-08-07 17:12:27.156789	2026-08-07 17:12:27.156789
249	2025-09-11	extra	2.879	2.91	-1.07	DENTRO	2026-08-07 17:12:27.156789	2026-08-07 17:12:27.156789
250	2025-09-11	ecopais	2.879	2.91	-1.07	DENTRO	2026-08-07 17:12:27.15679	2026-08-07 17:12:27.15679
251	2025-09-11	super_95	3.18	3.25	-2.15	LIBRE	2026-08-07 17:12:27.15679	2026-08-07 17:12:27.15679
252	2025-09-11	diesel	2.8	1.8	55.56	TECHO	2026-08-07 17:12:27.15679	2026-08-07 17:12:27.156791
253	2025-10-11	extra	2.92	2.879	1.42	DENTRO	2026-08-07 17:12:27.156791	2026-08-07 17:12:27.156791
254	2025-10-11	ecopais	2.92	2.879	1.42	DENTRO	2026-08-07 17:12:27.156791	2026-08-07 17:12:27.156792
255	2025-10-11	super_95	3.3	3.18	3.77	LIBRE	2026-08-07 17:12:27.156792	2026-08-07 17:12:27.156792
256	2025-10-11	diesel	2.8	2.8	0	DENTRO	2026-08-07 17:12:27.156792	2026-08-07 17:12:27.156793
257	2025-11-11	extra	2.895	2.92	-0.86	DENTRO	2026-08-07 17:12:27.156793	2026-08-07 17:12:27.156793
258	2025-11-11	ecopais	2.895	2.92	-0.86	DENTRO	2026-08-07 17:12:27.156793	2026-08-07 17:12:27.156793
259	2025-11-11	super_95	3.25	3.3	-1.52	LIBRE	2026-08-07 17:12:27.156794	2026-08-07 17:12:27.156794
260	2025-11-11	diesel	2.75	2.8	-1.79	DENTRO	2026-08-07 17:12:27.156794	2026-08-07 17:12:27.156794
261	2025-12-11	extra	2.87	2.895	-0.86	DENTRO	2026-08-07 17:12:27.156795	2026-08-07 17:12:27.156795
262	2025-12-11	ecopais	2.87	2.895	-0.86	DENTRO	2026-08-07 17:12:27.156795	2026-08-07 17:12:27.156795
263	2025-12-11	super_95	3.2	3.25	-1.54	LIBRE	2026-08-07 17:12:27.156795	2026-08-07 17:12:27.156796
264	2025-12-11	diesel	2.7	2.75	-1.82	DENTRO	2026-08-07 17:12:27.156796	2026-08-07 17:12:27.156796
267	2026-01-11	super_95	3.28	3.2	2.5	LIBRE	2026-08-07 17:12:27.156797	2026-08-07 17:12:27.156797
271	2026-02-11	super_95	3.35	3.28	2.13	LIBRE	2026-08-07 17:12:27.156799	2026-08-07 17:12:27.156799
275	2026-03-11	super_95	3.41	3.35	1.79	LIBRE	2026-08-07 17:12:27.156802	2026-08-07 17:12:27.156802
277	2026-04-11	extra	3.034	2.89	4.98	TECHO	\N	\N
278	2026-04-11	ecopais	3.034	2.89	4.98	TECHO	\N	\N
279	2026-04-11	diesel	2.969	2.828	4.99	TECHO	\N	\N
280	2026-04-11	super_95	4.2	3.41	23.17	LIBRE	\N	\N
281	2026-05-11	extra	3.186	3.034	5	TECHO	\N	\N
282	2026-05-11	ecopais	3.186	3.034	5	TECHO	\N	\N
283	2026-05-11	diesel	3.118	2.969	5.02	TECHO	\N	\N
284	2026-05-11	super_95	4.89	4.2	16.43	LIBRE	\N	\N
285	2026-06-11	extra	3.345	3.186	4.99	TECHO	\N	\N
286	2026-06-11	ecopais	3.345	3.186	4.99	TECHO	\N	\N
287	2026-06-11	diesel	3.274	3.118	5	TECHO	\N	\N
288	2026-06-11	super_95	5.52	4.89	12.88	LIBRE	\N	\N
289	2026-07-11	extra	3.265	3.345	-2.39	DECRETO444	\N	\N
290	2026-07-11	ecopais	3.265	3.345	-2.39	DECRETO444	\N	\N
291	2026-07-11	diesel	3.204	3.274	-2.14	DECRETO444	\N	\N
292	2026-07-11	super_95	5.52	5.52	0	LIBRE	\N	\N
265	2026-01-11	extra	2.855	2.87	-0.52	TECHO	2026-08-07 17:12:27.156796	2026-08-07 17:12:27.156797
266	2026-01-11	ecopais	2.855	2.87	-0.52	TECHO	2026-08-07 17:12:27.156797	2026-08-07 17:12:27.156797
268	2026-01-11	diesel	2.72	2.7	0.74	TECHO	2026-08-07 17:12:27.156798	2026-08-07 17:12:27.156798
269	2026-02-11	extra	2.875	2.855	0.7	TECHO	2026-08-07 17:12:27.156798	2026-08-07 17:12:27.156798
270	2026-02-11	ecopais	2.875	2.855	0.7	TECHO	2026-08-07 17:12:27.156799	2026-08-07 17:12:27.156799
272	2026-02-11	diesel	2.8	2.72	2.94	TECHO	2026-08-07 17:12:27.1568	2026-08-07 17:12:27.156801
273	2026-03-11	extra	2.89	2.875	0.52	TECHO	2026-08-07 17:12:27.156801	2026-08-07 17:12:27.156801
274	2026-03-11	ecopais	2.89	2.875	0.52	TECHO	2026-08-07 17:12:27.156801	2026-08-07 17:12:27.156802
276	2026-03-11	diesel	2.828	2.8	1	TECHO	2026-08-07 17:12:27.156802	2026-08-07 17:12:27.156802
293	2026-08-12	extra	3.242	3.265	-0.7	DECRETO468	\N	\N
294	2026-08-12	ecopais	3.242	3.265	-0.7	DECRETO468	\N	\N
295	2026-08-12	diesel	3.181	3.204	-0.72	DECRETO468	\N	\N
296	2026-08-12	super_95	4.74	5.52	-14.13	LIBRE	\N	\N
\.


--
-- Data for Name: news_cache; Type: TABLE DATA; Schema: public; Owner: gaspredict
--

COPY public.news_cache (id, title, source, url, published_date, sentiment, sentiment_score, summary, fetched_at) FROM stdin;
\.


--
-- Data for Name: predictions; Type: TABLE DATA; Schema: public; Owner: gaspredict
--

COPY public.predictions (id, created_at, fuel_type, approach, target_date, predicted_price, actual_price, wti_predicted, wti_actual, band_status, accuracy_pct, model_weights, confidence_lower, confidence_upper) FROM stdin;
2	2026-08-12 19:11:55.593277	ecopais	two_layer	2026-08-12	3.061	\N	\N	\N	DENTRO	\N	{"sarima": 0.1808, "xgboost": 0.5135, "lstm": 0.3057}	3.1979	3.2301
1	2026-08-12 19:26:14.809202	extra	two_layer	2026-08-12	3.241	\N	\N	\N	DECRETO468	\N	{"sarima": 0.1807, "xgboost": 0.5131, "lstm": 0.3062}	3.2248	3.2572
3	2026-08-12 19:26:24.304201	diesel	two_layer	2026-08-12	3.18	\N	\N	\N	DECRETO468	\N	{"sarima": 0.1867, "xgboost": 0.5303, "lstm": 0.283}	3.1641	3.1959
4	2026-08-12 19:26:34.081226	super_95	two_layer	2026-08-12	4.742	\N	\N	\N	LIBRE	\N	{"sarima": 0.1755, "xgboost": 0.4985, "lstm": 0.326}	4.5713	4.9127
\.


--
-- Data for Name: wti_daily; Type: TABLE DATA; Schema: public; Owner: gaspredict
--

COPY public.wti_daily (id, date, close_price, open_price, high, low, volume, created_at) FROM stdin;
1	2025-08-07	63.880001068115234	64.36000061035156	65.11000061035156	63.70000076293945	300518	2026-08-07 17:13:09.174707
2	2025-08-08	63.880001068115234	63.849998474121094	64.58000183105469	62.77000045776367	322939	2026-08-07 17:13:09.1765
3	2025-08-11	63.959999084472656	63.47999954223633	64.44000244140625	63.02000045776367	234807	2026-08-07 17:13:09.177444
4	2025-08-12	63.16999816894531	64	64.33999633789062	63.060001373291016	304441	2026-08-07 17:13:09.178142
5	2025-08-13	62.650001525878906	63.06999969482422	63.380001068115234	61.939998626708984	298939	2026-08-07 17:13:09.178836
6	2025-08-14	63.959999084472656	62.790000915527344	64.0999984741211	62.58000183105469	251652	2026-08-07 17:13:09.179526
7	2025-08-15	62.79999923706055	63.90999984741211	64.1500015258789	62.68000030517578	197390	2026-08-07 17:13:09.180221
8	2025-08-18	63.41999816894531	63	63.790000915527344	62.18000030517578	95113	2026-08-07 17:13:09.181055
9	2025-08-19	62.349998474121094	63.27000045776367	63.38999938964844	62.25	99484	2026-08-07 17:13:09.181784
10	2025-08-20	63.209999084472656	62.599998474121094	63.54999923706055	62.38999938964844	280663	2026-08-07 17:13:09.182396
11	2025-08-21	63.52000045776367	62.849998474121094	63.66999816894531	62.52000045776367	250166	2026-08-07 17:13:09.18306
12	2025-08-22	63.65999984741211	63.5	63.93000030517578	63.310001373291016	223169	2026-08-07 17:13:09.183694
13	2025-08-25	64.80000305175781	63.880001068115234	65.0999984741211	63.529998779296875	185270	2026-08-07 17:13:09.184268
14	2025-08-26	63.25	64.75	64.76000213623047	63.130001068115234	199101	2026-08-07 17:13:09.18487
15	2025-08-27	64.1500015258789	63.310001373291016	64.2300033569336	62.95000076293945	193476	2026-08-07 17:13:09.185439
16	2025-08-28	64.5999984741211	63.869998931884766	64.69999694824219	63.349998474121094	208931	2026-08-07 17:13:09.185991
17	2025-08-29	64.01000213623047	64.26000213623047	64.55000305175781	63.880001068115234	0	2026-08-07 17:13:09.186601
18	2025-09-02	65.58999633789062	63.95000076293945	66.02999877929688	63.65999984741211	320218	2026-08-07 17:13:09.187192
19	2025-09-03	63.970001220703125	65.62000274658203	65.72000122070312	63.720001220703125	298737	2026-08-07 17:13:09.187776
20	2025-09-04	63.47999954223633	63.81999969482422	63.84000015258789	62.720001220703125	251689	2026-08-07 17:13:09.188358
21	2025-09-05	61.869998931884766	63.33000183105469	63.4900016784668	61.45000076293945	294540	2026-08-07 17:13:09.188973
22	2025-09-08	62.2599983215332	62	63.34000015258789	61.849998474121094	237288	2026-08-07 17:13:09.189588
23	2025-09-09	62.630001068115234	62.43000030517578	63.66999816894531	62.369998931884766	268529	2026-08-07 17:13:09.190186
24	2025-09-10	63.66999816894531	62.7400016784668	64.08000183105469	62.720001220703125	260684	2026-08-07 17:13:09.190771
25	2025-09-11	62.369998931884766	63.79999923706055	63.79999923706055	62.209999084472656	222661	2026-08-07 17:13:09.191366
26	2025-09-12	62.689998626708984	62.27000045776367	63.97999954223633	61.689998626708984	313265	2026-08-07 17:13:09.191923
27	2025-09-15	63.29999923706055	62.970001220703125	63.66999816894531	62.52000045776367	205560	2026-08-07 17:13:09.192621
28	2025-09-16	64.5199966430664	63.310001373291016	64.76000213623047	62.88999938964844	234250	2026-08-07 17:13:09.193338
29	2025-09-17	64.05000305175781	64.58999633789062	64.66999816894531	63.689998626708984	165427	2026-08-07 17:13:09.193992
30	2025-09-18	63.56999969482422	63.9900016784668	64.55000305175781	63.33000183105469	82321	2026-08-07 17:13:09.19461
31	2025-09-19	62.68000030517578	63.59000015258789	63.650001525878906	62.599998474121094	87165	2026-08-07 17:13:09.195213
32	2025-09-22	62.63999938964844	62.7400016784668	63.18000030517578	61.97999954223633	223779	2026-08-07 17:13:09.195933
33	2025-09-23	63.40999984741211	62.33000183105469	63.88999938964844	61.849998474121094	265948	2026-08-07 17:13:09.196703
34	2025-09-24	64.98999786376953	63.63999938964844	65.05000305175781	63.25	282721	2026-08-07 17:13:09.197503
35	2025-09-25	64.9800033569336	64.80000305175781	65.33999633789062	64.05999755859375	258353	2026-08-07 17:13:09.198225
36	2025-09-26	65.72000122070312	65.19999694824219	66.41999816894531	64.66000366210938	284990	2026-08-07 17:13:09.198965
37	2025-09-29	63.45000076293945	65.06999969482422	65.4000015258789	62.97999954223633	294292	2026-08-07 17:13:09.199574
38	2025-09-30	62.369998931884766	63.13999938964844	63.2599983215332	62.029998779296875	271649	2026-08-07 17:13:09.200162
39	2025-10-01	61.779998779296875	62.459999084472656	62.88999938964844	61.400001525878906	274339	2026-08-07 17:13:09.200792
40	2025-10-02	60.47999954223633	61.779998779296875	62.540000915527344	60.400001525878906	290507	2026-08-07 17:13:09.201376
41	2025-10-03	60.880001068115234	60.70000076293945	61.380001068115234	60.54999923706055	240044	2026-08-07 17:13:09.201959
42	2025-10-06	61.689998626708984	61.13999938964844	62.119998931884766	61.040000915527344	224682	2026-08-07 17:13:09.202539
43	2025-10-07	61.72999954223633	61.72999954223633	62.11000061035156	60.720001220703125	245121	2026-08-07 17:13:09.203107
44	2025-10-08	62.54999923706055	62.04999923706055	62.91999816894531	62.04999923706055	273318	2026-08-07 17:13:09.203702
45	2025-10-09	61.5099983215332	62.310001373291016	62.869998931884766	61.25	259171	2026-08-07 17:13:09.204363
46	2025-10-10	58.900001525878906	61.4900016784668	61.66999816894531	58.220001220703125	339103	2026-08-07 17:13:09.204975
47	2025-10-13	59.4900016784668	59	60.16999816894531	59	339103	2026-08-07 17:13:09.205631
48	2025-10-14	58.70000076293945	59.58000183105469	59.81999969482422	57.68000030517578	259200	2026-08-07 17:13:09.206266
49	2025-10-15	58.27000045776367	58.599998474121094	59.41999816894531	58.20000076293945	224919	2026-08-07 17:13:09.206896
50	2025-10-16	57.459999084472656	58.77000045776367	59.11000061035156	57.2599983215332	203866	2026-08-07 17:13:09.207467
51	2025-10-17	57.540000915527344	57.5	57.720001220703125	56.599998474121094	108748	2026-08-07 17:13:09.208052
52	2025-10-20	57.52000045776367	57.72999954223633	57.810001373291016	56.349998474121094	108146	2026-08-07 17:13:09.2088
53	2025-10-21	57.81999969482422	57.369998931884766	58.279998779296875	56.9900016784668	314207	2026-08-07 17:13:09.210131
54	2025-10-22	58.5	57.59000015258789	59.83000183105469	57.34000015258789	378637	2026-08-07 17:13:09.211116
55	2025-10-23	61.790000915527344	59.939998626708984	62.20000076293945	59.63999938964844	735186	2026-08-07 17:13:09.211902
56	2025-10-24	61.5	61.790000915527344	62.59000015258789	61.209999084472656	373744	2026-08-07 17:13:09.21247
57	2025-10-27	61.310001373291016	61.81999969482422	62.16999816894531	60.66999816894531	272191	2026-08-07 17:13:09.2131
58	2025-10-28	60.150001525878906	61.5	61.5	59.7599983215332	307568	2026-08-07 17:13:09.213695
59	2025-10-29	60.47999954223633	60.18000030517578	61.02000045776367	59.70000076293945	276875	2026-08-07 17:13:09.214263
60	2025-10-30	60.56999969482422	60.38999938964844	60.790000915527344	59.63999938964844	247917	2026-08-07 17:13:09.214826
61	2025-10-31	60.97999954223633	60.29999923706055	61.380001068115234	59.9900016784668	278598	2026-08-07 17:13:09.215391
62	2025-11-03	61.04999923706055	61.400001525878906	61.5	60.5099983215332	0	2026-08-07 17:13:09.215967
63	2025-11-04	60.560001373291016	61.029998779296875	61.029998779296875	59.939998626708984	219300	2026-08-07 17:13:09.216523
64	2025-11-05	59.599998474121094	60.43000030517578	61.09000015258789	59.52000045776367	292518	2026-08-07 17:13:09.217075
65	2025-11-06	59.43000030517578	59.68000030517578	60.5099983215332	58.83000183105469	277768	2026-08-07 17:13:09.217641
66	2025-11-07	59.75	59.650001525878906	60.459999084472656	59.31999969482422	259446	2026-08-07 17:13:09.21817
67	2025-11-10	60.130001068115234	59.869998931884766	60.47999954223633	59.40999984741211	222879	2026-08-07 17:13:09.21871
68	2025-11-11	61.040000915527344	60.06999969482422	61.279998779296875	59.65999984741211	264427	2026-08-07 17:13:09.219236
69	2025-11-12	58.4900016784668	61.04999923706055	61.060001373291016	58.29999923706055	329517	2026-08-07 17:13:09.219769
70	2025-11-13	58.689998626708984	58.470001220703125	59.209999084472656	58.119998931884766	247349	2026-08-07 17:13:09.220313
71	2025-11-14	60.09000015258789	58.709999084472656	60.650001525878906	58.709999084472656	334116	2026-08-07 17:13:09.220883
72	2025-11-17	59.90999984741211	59.79999923706055	60.439998626708984	59.31999969482422	189638	2026-08-07 17:13:09.221497
73	2025-11-18	60.7400016784668	59.7400016784668	60.93000030517578	59.310001373291016	105325	2026-08-07 17:13:09.222081
74	2025-11-19	59.439998626708984	60.619998931884766	60.790000915527344	58.77000045776367	79622	2026-08-07 17:13:09.222682
75	2025-11-20	59.13999938964844	59.630001068115234	60.33000183105469	58.86000061035156	324282	2026-08-07 17:13:09.223269
76	2025-11-21	58.060001373291016	58.79999923706055	58.79999923706055	57.380001068115234	345014	2026-08-07 17:13:09.223859
77	2025-11-24	58.84000015258789	58.04999923706055	59.060001373291016	57.41999816894531	238138	2026-08-07 17:13:09.224462
78	2025-11-25	57.95000076293945	58.88999938964844	58.959999084472656	57.099998474121094	334442	2026-08-07 17:13:09.225064
79	2025-11-26	58.650001525878906	58.04999923706055	58.720001220703125	57.65999984741211	228285	2026-08-07 17:13:09.225777
80	2025-11-28	58.54999923706055	58.58000183105469	59.63999938964844	58.27000045776367	153758	2026-08-07 17:13:09.226801
81	2025-12-01	59.31999969482422	58.959999084472656	59.970001220703125	58.83000183105469	232770	2026-08-07 17:13:09.227502
82	2025-12-02	58.63999938964844	59.52000045776367	59.66999816894531	58.279998779296875	255513	2026-08-07 17:13:09.22811
83	2025-12-03	58.95000076293945	58.650001525878906	59.63999938964844	58.369998931884766	260974	2026-08-07 17:13:09.228765
84	2025-12-04	59.66999816894531	59.09000015258789	60.02000045776367	58.810001373291016	264993	2026-08-07 17:13:09.229367
85	2025-12-05	60.08000183105469	59.70000076293945	60.5	59.41999816894531	255075	2026-08-07 17:13:09.229965
86	2025-12-08	58.880001068115234	60.150001525878906	60.29999923706055	58.68000030517578	263009	2026-08-07 17:13:09.230821
87	2025-12-09	58.25	58.869998931884766	59.16999816894531	58.119998931884766	260206	2026-08-07 17:13:09.231452
88	2025-12-10	58.459999084472656	58.369998931884766	59.04999923706055	57.65999984741211	256508	2026-08-07 17:13:09.232145
89	2025-12-11	57.599998474121094	58.90999984741211	58.939998626708984	57.0099983215332	286808	2026-08-07 17:13:09.232745
90	2025-12-12	57.439998626708984	57.88999938964844	58.189998626708984	57.150001525878906	212806	2026-08-07 17:13:09.233362
91	2025-12-15	56.81999969482422	57.5	57.79999923706055	56.400001525878906	229310	2026-08-07 17:13:09.233939
92	2025-12-16	55.27000045776367	56.68000030517578	56.70000076293945	54.97999954223633	230933	2026-08-07 17:13:09.234507
93	2025-12-17	55.939998626708984	55.22999954223633	56.97999954223633	55.20000076293945	125608	2026-08-07 17:13:09.235148
94	2025-12-18	56.150001525878906	56.900001525878906	57.029998779296875	55.880001068115234	85735	2026-08-07 17:13:09.235734
95	2025-12-19	56.65999984741211	56.029998779296875	56.900001525878906	55.81999969482422	209264	2026-08-07 17:13:09.236327
96	2025-12-22	58.0099983215332	56.630001068115234	58.130001068115234	56.599998474121094	221576	2026-08-07 17:13:09.236913
97	2025-12-23	58.380001068115234	57.95000076293945	58.560001373291016	57.7400016784668	183633	2026-08-07 17:13:09.237489
98	2025-12-24	58.349998474121094	58.470001220703125	58.75	58.130001068115234	111762	2026-08-07 17:13:09.238083
99	2025-12-26	56.7400016784668	58.349998474121094	58.880001068115234	56.650001525878906	166669	2026-08-07 17:13:09.238832
100	2025-12-29	58.08000183105469	57.040000915527344	58.29999923706055	56.90999984741211	178590	2026-08-07 17:13:09.239374
101	2025-12-30	57.95000076293945	57.810001373291016	58.470001220703125	57.599998474121094	143802	2026-08-07 17:13:09.239943
102	2025-12-31	57.41999816894531	57.95000076293945	58.54999923706055	57.20000076293945	157160	2026-08-07 17:13:09.240532
103	2026-01-02	57.31999969482422	57.40999984741211	57.93000030517578	56.599998474121094	189503	2026-08-07 17:13:09.241107
104	2026-01-05	58.31999969482422	57.470001220703125	58.5099983215332	56.310001373291016	301483	2026-08-07 17:13:09.241758
105	2026-01-06	57.130001068115234	58.34000015258789	58.869998931884766	56.84000015258789	292067	2026-08-07 17:13:09.242597
106	2026-01-07	55.9900016784668	57	57.16999816894531	55.7599983215332	383128	2026-08-07 17:13:09.243551
107	2026-01-08	57.7599983215332	56.41999816894531	58.7400016784668	55.970001220703125	334134	2026-08-07 17:13:09.244248
108	2026-01-09	59.119998931884766	58.400001525878906	59.77000045776367	57.61000061035156	360309	2026-08-07 17:13:09.244898
109	2026-01-12	59.5	59	59.90999984741211	58.45000076293945	309700	2026-08-07 17:13:09.245425
110	2026-01-13	61.150001525878906	59.95000076293945	61.5	59.470001220703125	411190	2026-08-07 17:13:09.245933
111	2026-01-14	62.02000045776367	61.119998931884766	62.36000061035156	59.189998626708984	410261	2026-08-07 17:13:09.246412
112	2026-01-15	59.189998626708984	61.060001373291016	61.13999938964844	58.880001068115234	113642	2026-08-07 17:13:09.246902
113	2026-01-16	59.439998626708984	59.2599983215332	60.18000030517578	58.939998626708984	113794	2026-08-07 17:13:09.247379
114	2026-01-20	60.34000015258789	59.0099983215332	60.68000030517578	58.70000076293945	499595	2026-08-07 17:13:09.247863
115	2026-01-21	60.619998931884766	59.56999969482422	60.88999938964844	59.220001220703125	333062	2026-08-07 17:13:09.24834
116	2026-01-22	59.36000061035156	60.68000030517578	60.81999969482422	58.959999084472656	324349	2026-08-07 17:13:09.248846
117	2026-01-23	61.06999969482422	59.65999984741211	61.36000061035156	59.52000045776367	283419	2026-08-07 17:13:09.249324
118	2026-01-26	60.630001068115234	61.220001220703125	61.709999084472656	60.31999969482422	281062	2026-08-07 17:13:09.249828
119	2026-01-27	62.38999938964844	60.779998779296875	62.630001068115234	60.13999938964844	360208	2026-08-07 17:13:09.250342
120	2026-01-28	63.209999084472656	62.58000183105469	63.56999969482422	62.06999969482422	354864	2026-08-07 17:13:09.250844
121	2026-01-29	65.41999816894531	63.5	66.4800033569336	63.279998779296875	560007	2026-08-07 17:13:09.251326
122	2026-01-30	65.20999908447266	65.5199966430664	66.11000061035156	63.63999938964844	449325	2026-08-07 17:13:09.251826
123	2026-02-02	62.13999938964844	64.72000122070312	64.73999786376953	61.38999938964844	414083	2026-08-07 17:13:09.252301
124	2026-02-03	63.209999084472656	62.279998779296875	64.20999908447266	61.119998931884766	381144	2026-08-07 17:13:09.252796
125	2026-02-04	65.13999938964844	63.79999923706055	65.52999877929688	62.86000061035156	446588	2026-08-07 17:13:09.253279
126	2026-02-05	63.290000915527344	64.48999786376953	64.66999816894531	62.650001525878906	389763	2026-08-07 17:13:09.253772
127	2026-02-06	63.54999923706055	63.099998474121094	64.58000183105469	62.20000076293945	448924	2026-08-07 17:13:09.254267
128	2026-02-09	64.36000061035156	62.9900016784668	64.87999725341797	62.619998931884766	298005	2026-08-07 17:13:09.254773
129	2026-02-10	63.959999084472656	64.44000244140625	64.70999908447266	63.650001525878906	276292	2026-08-07 17:13:09.255303
130	2026-02-11	64.62999725341797	64.19999694824219	65.83000183105469	64.1500015258789	340194	2026-08-07 17:13:09.25583
131	2026-02-12	62.84000015258789	64.87000274658203	65.0999984741211	62.38999938964844	369303	2026-08-07 17:13:09.256406
132	2026-02-13	62.88999938964844	62.9900016784668	63.2599983215332	62.13999938964844	255793	2026-08-07 17:13:09.257021
133	2026-02-17	62.33000183105469	63.29999923706055	64.13999938964844	61.869998931884766	328727	2026-08-07 17:13:09.257686
134	2026-02-18	65.19000244140625	62.29999923706055	65.55999755859375	62.119998931884766	115379	2026-08-07 17:13:09.258328
135	2026-02-19	66.43000030517578	65.0999984741211	66.9000015258789	64.87999725341797	113408	2026-08-07 17:13:09.258952
136	2026-02-20	66.38999938964844	66.66999816894531	67.05000305175781	65.94000244140625	351351	2026-08-07 17:13:09.259605
137	2026-02-23	66.30999755859375	65.88999938964844	67.27999877929688	65.37999725341797	270365	2026-08-07 17:13:09.26024
138	2026-02-24	65.62999725341797	66.30999755859375	67.1500015258789	65.55000305175781	312124	2026-08-07 17:13:09.260845
139	2026-02-25	65.41999816894531	66.06999969482422	66.5999984741211	65.12000274658203	306780	2026-08-07 17:13:09.261395
140	2026-02-26	65.20999908447266	65.6500015258789	66.70999908447266	63.599998474121094	498542	2026-08-07 17:13:09.261951
141	2026-02-27	67.0199966430664	65.3499984741211	67.83000183105469	64.8499984741211	437053	2026-08-07 17:13:09.262488
142	2026-03-02	71.2300033569336	75	75.33000183105469	69.19999694824219	881329	2026-08-07 17:13:09.263035
143	2026-03-03	74.55999755859375	71.2300033569336	77.9800033569336	70.41000366210938	1009753	2026-08-07 17:13:09.263569
144	2026-03-04	74.66000366210938	74.73999786376953	77.2300033569336	73.27999877929688	617822	2026-08-07 17:13:09.264171
145	2026-03-05	81.01000213623047	76.1500015258789	82.16000366210938	74.97000122070312	707030	2026-08-07 17:13:09.264797
146	2026-03-06	90.9000015258789	79.08000183105469	92.61000061035156	78.23999786376953	996251	2026-08-07 17:13:09.26539
147	2026-03-09	94.7699966430664	98	119.4800033569336	81.19000244140625	1107193	2026-08-07 17:13:09.265956
148	2026-03-10	83.44999694824219	85.75	91.4800033569336	76.7300033569336	801564	2026-08-07 17:13:09.266531
149	2026-03-11	87.25	86.88999938964844	88.98999786376953	81.79000091552734	538020	2026-08-07 17:13:09.267156
150	2026-03-12	95.7300033569336	89.31999969482422	97.19000244140625	88.61000061035156	548999	2026-08-07 17:13:09.267768
151	2026-03-13	98.70999908447266	96.73999786376953	99.31999969482422	92.04000091552734	436700	2026-08-07 17:13:09.268344
152	2026-03-16	93.5	100.93000030517578	102.44000244140625	92.93000030517578	455454	2026-08-07 17:13:09.268899
153	2026-03-17	96.20999908447266	94.41000366210938	98.41999816894531	93.83000183105469	308425	2026-08-07 17:13:09.269476
154	2026-03-18	96.31999969482422	96	100.55000305175781	91.95999908447266	157222	2026-08-07 17:13:09.270071
155	2026-03-19	96.13999938964844	99.12999725341797	101.4800033569336	92.80000305175781	118719	2026-08-07 17:13:09.270676
156	2026-03-20	98.31999969482422	95	99.66999816894531	93.41999816894531	461845	2026-08-07 17:13:09.271251
157	2026-03-23	88.12999725341797	100.51000213623047	101.66999816894531	84.37000274658203	666790	2026-08-07 17:13:09.271853
158	2026-03-24	92.3499984741211	88.77999877929688	93.36000061035156	86.33999633789062	420067	2026-08-07 17:13:09.272466
159	2026-03-25	90.31999969482422	88.48999786376953	91.7300033569336	86.45999908447266	405170	2026-08-07 17:13:09.273162
160	2026-03-26	94.4800033569336	91.37999725341797	95.44000244140625	89.51000213623047	350768	2026-08-07 17:13:09.273762
161	2026-03-27	99.63999938964844	93.30999755859375	101.23999786376953	92.08000183105469	374920	2026-08-07 17:13:09.274351
162	2026-03-30	102.87999725341797	102.5999984741211	105.36000061035156	99.43000030517578	374075	2026-08-07 17:13:09.274927
163	2026-03-31	101.37999725341797	105.06999969482422	106.86000061035156	99.62000274658203	495395	2026-08-07 17:13:09.27551
164	2026-04-01	100.12000274658203	101.72000122070312	103.30999755859375	96.5	434561	2026-08-07 17:13:09.276202
165	2026-04-02	111.54000091552734	98.91999816894531	113.97000122070312	97.5	0	2026-08-07 17:13:09.276885
166	2026-04-06	112.41000366210938	112.95999908447266	115.4800033569336	108.88999938964844	271742	2026-08-07 17:13:09.277506
167	2026-04-07	112.94999694824219	112.62000274658203	117.62999725341797	109.19999694824219	429331	2026-08-07 17:13:09.278083
168	2026-04-08	94.41000366210938	108.73999786376953	109.19000244140625	91.05000305175781	599576	2026-08-07 17:13:09.278674
169	2026-04-09	97.87000274658203	96.77999877929688	102.69999694824219	95.25	427201	2026-08-07 17:13:09.279267
170	2026-04-10	96.56999969482422	98.2300033569336	100.41999816894531	95.51000213623047	314855	2026-08-07 17:13:09.279845
171	2026-04-13	99.08000183105469	102	105.62999725341797	97.02999877929688	344337	2026-08-07 17:13:09.280463
172	2026-04-14	91.27999877929688	97.98999786376953	98	91.05999755859375	315821	2026-08-07 17:13:09.281068
173	2026-04-15	91.29000091552734	92.0199966430664	93.30000305175781	86.95999908447266	240397	2026-08-07 17:13:09.281746
174	2026-04-16	94.69000244140625	91.47000122070312	95.44000244140625	90.5199966430664	194354	2026-08-07 17:13:09.282443
175	2026-04-17	83.8499984741211	93.18000030517578	94.04000091552734	80.55999755859375	116624	2026-08-07 17:13:09.28303
176	2026-04-20	89.61000061035156	89	91.19999694824219	87.0199966430664	115578	2026-08-07 17:13:09.283633
177	2026-04-21	92.12999725341797	87.88999938964844	94.44999694824219	87.76000213623047	383596	2026-08-07 17:13:09.284239
178	2026-04-22	92.95999908447266	90	93.7300033569336	87.63999938964844	299675	2026-08-07 17:13:09.284834
179	2026-04-23	95.8499984741211	92.9000015258789	98.38999938964844	92.30000305175781	365210	2026-08-07 17:13:09.28545
180	2026-04-24	94.4000015258789	96.62000274658203	97.8499984741211	92.68000030517578	330280	2026-08-07 17:13:09.286042
181	2026-04-27	96.37000274658203	95.5999984741211	97.66999816894531	94.58999633789062	219055	2026-08-07 17:13:09.286647
182	2026-04-28	99.93000030517578	96.66999816894531	101.8499984741211	96.23999786376953	281078	2026-08-07 17:13:09.287256
183	2026-04-29	106.87999725341797	99.70999908447266	108.5999984741211	98.41999816894531	318841	2026-08-07 17:13:09.287841
184	2026-04-30	105.06999969482422	109.06999969482422	110.93000030517578	103.33999633789062	341994	2026-08-07 17:13:09.288626
185	2026-05-01	101.94000244140625	105.13999938964844	106.6500015258789	99.30000305175781	268707	2026-08-07 17:13:09.289218
186	2026-05-04	106.41999816894531	99.7300033569336	107.45999908447266	99.11000061035156	342843	2026-08-07 17:13:09.289804
187	2026-05-05	102.2699966430664	104.93000030517578	105.4800033569336	101.08000183105469	241150	2026-08-07 17:13:09.290401
188	2026-05-06	95.08000183105469	102.69999694824219	102.69999694824219	88.66000366210938	423491	2026-08-07 17:13:09.291009
189	2026-05-07	94.80999755859375	96.30000305175781	97.98999786376953	89.8499984741211	392091	2026-08-07 17:13:09.291591
190	2026-05-08	95.41999816894531	98.25	98.63999938964844	93.81999969482422	243423	2026-08-07 17:13:09.292184
191	2026-05-11	98.06999969482422	98.19000244140625	100.37000274658203	96.12999725341797	256251	2026-08-07 17:13:09.292812
192	2026-05-12	102.18000030517578	98.38999938964844	102.72000122070312	98	231747	2026-08-07 17:13:09.293472
193	2026-05-13	101.0199966430664	102.16000366210938	103.66999816894531	100.55999755859375	212582	2026-08-07 17:13:09.294087
194	2026-05-14	101.16999816894531	101.0199966430664	102.3499984741211	99.38999938964844	173862	2026-08-07 17:13:09.294658
195	2026-05-15	105.41999816894531	102.05999755859375	106	101.4800033569336	96552	2026-08-07 17:13:09.295259
196	2026-05-18	108.66000366210938	106	109.47000122070312	102.6500015258789	117910	2026-08-07 17:13:09.295977
197	2026-05-19	107.7699966430664	107.11000061035156	109.23999786376953	106.76000213623047	206472	2026-08-07 17:13:09.296573
198	2026-05-20	98.26000213623047	104.12000274658203	104.44999694824219	96.94000244140625	320034	2026-08-07 17:13:09.297142
199	2026-05-21	96.3499984741211	98.94999694824219	102.66000366210938	95.76000213623047	345482	2026-08-07 17:13:09.297726
200	2026-05-22	96.5999984741211	98	99.43000030517578	94.7300033569336	261142	2026-08-07 17:13:09.298336
201	2026-05-26	93.88999938964844	93.87999725341797	94.69999694824219	89.41000366210938	358867	2026-08-07 17:13:09.298951
202	2026-05-27	88.68000030517578	93.38999938964844	93.69000244140625	87.7699966430664	290948	2026-08-07 17:13:09.299534
203	2026-05-28	88.9000015258789	89.11000061035156	92.5199966430664	87.11000061035156	235145	2026-08-07 17:13:09.300147
204	2026-05-29	87.36000061035156	88.55000305175781	89.0199966430664	86.3499984741211	267803	2026-08-07 17:13:09.300741
205	2026-06-01	92.16000366210938	88.5	94.77999877929688	88.44999694824219	322039	2026-08-07 17:13:09.301342
206	2026-06-02	93.76000213623047	92.44999694824219	94	90.12000274658203	238146	2026-08-07 17:13:09.301933
207	2026-06-03	96.0199966430664	93.44999694824219	97	93.44999694824219	260613	2026-08-07 17:13:09.30252
208	2026-06-04	93.04000091552734	95.75	95.91000366210938	91.91000366210938	219500	2026-08-07 17:13:09.303122
209	2026-06-05	90.54000091552734	92.81999969482422	93.62999725341797	89.68000030517578	252903	2026-08-07 17:13:09.303703
210	2026-06-08	91.30000305175781	93	95.47000122070312	90.38999938964844	278650	2026-08-07 17:13:09.30441
211	2026-06-09	88.19999694824219	91.27999877929688	91.55000305175781	85.94999694824219	306101	2026-08-07 17:13:09.305018
212	2026-06-10	90.02999877929688	89.4000015258789	91.87000274658203	87.38999938964844	291935	2026-08-07 17:13:09.305557
213	2026-06-11	87.70999908447266	92.25	93.63999938964844	85.73999786376953	317151	2026-08-07 17:13:09.306178
214	2026-06-12	84.87999725341797	86.63999938964844	87.2300033569336	83.19999694824219	233924	2026-08-07 17:13:09.306723
215	2026-06-15	80.75	81.4000015258789	82.41999816894531	79.69999694824219	208395	2026-08-07 17:13:09.307273
216	2026-06-16	76.05000305175781	81.0999984741211	81.58000183105469	75.5199966430664	205050	2026-08-07 17:13:09.307835
217	2026-06-17	76.79000091552734	76.58999633789062	80.02999877929688	74.58999633789062	100474	2026-08-07 17:13:09.308384
218	2026-06-18	76.5999984741211	75.52999877929688	76.98999786376953	73.58000183105469	97813	2026-08-07 17:13:09.30903
219	2026-06-22	74.81999969482422	78.93000030517578	78.95999908447266	74.44999694824219	315903	2026-08-07 17:13:09.309793
220	2026-06-23	73.20999908447266	74.13999938964844	74.44999694824219	72.4800033569336	203509	2026-08-07 17:13:09.310898
221	2026-06-24	70.33999633789062	73.12999725341797	73.18000030517578	69.62999725341797	251403	2026-08-07 17:13:09.311508
222	2026-06-25	71.91999816894531	69.94999694824219	72.5	68.9000015258789	228065	2026-08-07 17:13:09.312049
223	2026-06-26	69.2300033569336	71.44000244140625	71.86000061035156	68.55999755859375	249316	2026-08-07 17:13:09.312607
224	2026-06-29	70.75	70.5	71.1500015258789	69.31999969482422	170488	2026-08-07 17:13:09.313165
225	2026-06-30	69.5	70.43000030517578	71.5999984741211	69.22000122070312	194279	2026-08-07 17:13:09.313699
226	2026-07-01	68.58000183105469	69.9800033569336	70.19000244140625	67.91999816894531	200004	2026-08-07 17:13:09.314238
227	2026-07-02	68.69000244140625	68.02999877929688	68.80000305175781	67.04000091552734	183635	2026-08-07 17:13:09.314762
228	2026-07-06	68.55000305175781	68.68000030517578	69.20999908447266	67.81999969482422	229909	2026-08-07 17:13:09.315286
229	2026-07-07	70.44000244140625	68.58000183105469	72.51000213623047	68.58000183105469	264072	2026-08-07 17:13:09.315816
230	2026-07-08	73.5199966430664	72.37999725341797	76.08000183105469	71.75	445251	2026-08-07 17:13:09.316344
231	2026-07-09	72.08000183105469	74.94999694824219	75.12999725341797	71.41999816894531	264009	2026-08-07 17:13:09.316894
232	2026-07-10	71.41000366210938	71.86000061035156	73.16000366210938	70.7699966430664	219817	2026-08-07 17:13:09.317406
233	2026-07-13	78.13999938964844	73.69000244140625	78.58000183105469	72.61000061035156	327411	2026-08-07 17:13:09.31793
234	2026-07-14	79.33999633789062	78.04000091552734	81.2699966430664	77.83999633789062	409973	2026-08-07 17:13:09.318439
235	2026-07-15	79.5999984741211	79.73999786376953	80.93000030517578	78.19000244140625	239855	2026-08-07 17:13:09.318965
236	2026-07-16	78.94999694824219	80	80.87000274658203	78.58000183105469	188731	2026-08-07 17:13:09.319574
237	2026-07-17	82.48999786376953	79.56999969482422	82.76000213623047	78.61000061035156	96003	2026-08-07 17:13:09.320206
238	2026-07-20	83.2300033569336	83.76000213623047	85.38999938964844	80.2699966430664	99783	2026-08-07 17:13:09.320733
239	2026-07-21	84.91000366210938	83.4800033569336	85.80000305175781	82.25	298109	2026-08-07 17:13:09.321255
240	2026-07-22	86.83000183105469	84.69000244140625	88.61000061035156	84.44000244140625	358021	2026-08-07 17:13:09.321771
241	2026-07-23	92.19000244140625	87.72000122070312	93.5	87.31999969482422	401934	2026-08-07 17:13:09.322286
242	2026-07-24	89.30999755859375	92.55000305175781	92.83000183105469	87.68000030517578	365438	2026-08-07 17:13:09.322796
243	2026-07-27	82.61000061035156	86.12000274658203	86.19999694824219	81.62999725341797	352813	2026-08-07 17:13:09.323332
244	2026-07-28	79.26000213623047	82	82.43000030517578	77.77999877929688	368026	2026-08-07 17:13:09.323851
245	2026-07-29	84.45999908447266	80.04000091552734	85.56999969482422	79.91999816894531	327417	2026-08-07 17:13:09.324371
246	2026-07-30	83.58999633789062	84.6500015258789	85.94000244140625	82.97000122070312	235395	2026-08-07 17:13:09.324987
247	2026-07-31	84.66999816894531	83.91999816894531	86.87000274658203	81.05999755859375	257851	2026-08-07 17:13:09.32551
248	2026-08-03	80.33999633789062	80.0999984741211	81.30000305175781	78.43000030517578	294823	2026-08-07 17:13:09.326071
249	2026-08-04	75.7699966430664	80.0999984741211	82.33000183105469	75.11000061035156	362270	2026-08-07 17:13:09.326711
250	2026-08-05	75.22000122070312	75.16999816894531	76.69999694824219	74.23999786376953	259965	2026-08-07 17:13:09.327266
251	2026-08-06	77.29000091552734	75.13999938964844	78.51000213623047	74.56999969482422	259965	2026-08-07 17:13:09.32778
252	2026-08-07	78.11000061035156	78.16999816894531	78.7699966430664	76.52999877929688	137850	2026-08-07 17:13:09.328318
\.


--
-- Data for Name: wti_predictions; Type: TABLE DATA; Schema: public; Owner: gaspredict
--

COPY public.wti_predictions (id, created_at, target_month, predicted_avg, actual_avg, confidence_lower, confidence_upper, sarima_prediction, xgboost_prediction, lstm_prediction, weights, accuracy_pct) FROM stdin;
\.


--
-- Name: fuel_prices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gaspredict
--

SELECT pg_catalog.setval('public.fuel_prices_id_seq', 296, true);


--
-- Name: news_cache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gaspredict
--

SELECT pg_catalog.setval('public.news_cache_id_seq', 1, false);


--
-- Name: predictions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gaspredict
--

SELECT pg_catalog.setval('public.predictions_id_seq', 4, true);


--
-- Name: wti_daily_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gaspredict
--

SELECT pg_catalog.setval('public.wti_daily_id_seq', 252, true);


--
-- Name: wti_predictions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gaspredict
--

SELECT pg_catalog.setval('public.wti_predictions_id_seq', 1, false);


--
-- Name: fuel_prices fuel_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.fuel_prices
    ADD CONSTRAINT fuel_prices_pkey PRIMARY KEY (id);


--
-- Name: news_cache news_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.news_cache
    ADD CONSTRAINT news_cache_pkey PRIMARY KEY (id);


--
-- Name: news_cache news_cache_url_key; Type: CONSTRAINT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.news_cache
    ADD CONSTRAINT news_cache_url_key UNIQUE (url);


--
-- Name: predictions predictions_pkey; Type: CONSTRAINT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.predictions
    ADD CONSTRAINT predictions_pkey PRIMARY KEY (id);


--
-- Name: fuel_prices uq_fuel_price_date_type; Type: CONSTRAINT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.fuel_prices
    ADD CONSTRAINT uq_fuel_price_date_type UNIQUE (date, fuel_type);


--
-- Name: wti_daily wti_daily_date_key; Type: CONSTRAINT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.wti_daily
    ADD CONSTRAINT wti_daily_date_key UNIQUE (date);


--
-- Name: wti_daily wti_daily_pkey; Type: CONSTRAINT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.wti_daily
    ADD CONSTRAINT wti_daily_pkey PRIMARY KEY (id);


--
-- Name: wti_predictions wti_predictions_pkey; Type: CONSTRAINT; Schema: public; Owner: gaspredict
--

ALTER TABLE ONLY public.wti_predictions
    ADD CONSTRAINT wti_predictions_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict h9mgMrOyNMa24uaGV2nzDTA91Jvj7gTk9oQpkrihaNrHafWPnSJSeBqeBymE2xu

