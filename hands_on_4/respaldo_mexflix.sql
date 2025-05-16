--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Debian 16.9-1.pgdg120+1)
-- Dumped by pg_dump version 17.4

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
-- Name: registrar_auditoria_factura(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.registrar_auditoria_factura() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO auditoria_factura (FacturaID, UsuarioID, Operacion)
    VALUES (NEW.FacturaID, NEW.UsuarioID, TG_OP);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.registrar_auditoria_factura() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actor (
    actorid integer NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL
);


ALTER TABLE public.actor OWNER TO postgres;

--
-- Name: auditoria_factura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auditoria_factura (
    auditoriaid integer NOT NULL,
    facturaid integer,
    usuarioid integer,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    operacion character varying(20)
);


ALTER TABLE public.auditoria_factura OWNER TO postgres;

--
-- Name: auditoria_factura_auditoriaid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auditoria_factura_auditoriaid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auditoria_factura_auditoriaid_seq OWNER TO postgres;

--
-- Name: auditoria_factura_auditoriaid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auditoria_factura_auditoriaid_seq OWNED BY public.auditoria_factura.auditoriaid;


--
-- Name: categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria (
    categoriaid integer NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.categoria OWNER TO postgres;

--
-- Name: consumo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consumo (
    consumoid integer NOT NULL,
    usuarioid integer NOT NULL,
    peliculaid integer,
    episodioid integer,
    tipocontenido character varying(10) NOT NULL,
    fechahorainicio timestamp without time zone NOT NULL,
    fechahorafin timestamp without time zone,
    dispositivoid integer NOT NULL,
    esrenta boolean DEFAULT false NOT NULL,
    CONSTRAINT consumo_check CHECK (((((tipocontenido)::text = 'Pelicula'::text) AND (peliculaid IS NOT NULL) AND (episodioid IS NULL)) OR (((tipocontenido)::text = 'Episodio'::text) AND (episodioid IS NOT NULL) AND (peliculaid IS NULL)))),
    CONSTRAINT consumo_tipocontenido_check CHECK (((tipocontenido)::text = ANY ((ARRAY['Pelicula'::character varying, 'Episodio'::character varying])::text[])))
);


ALTER TABLE public.consumo OWNER TO postgres;

--
-- Name: dispositivo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dispositivo (
    dispositivoid integer NOT NULL,
    tipo character varying(20) NOT NULL,
    CONSTRAINT dispositivo_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['smartphone'::character varying, 'tablet'::character varying, 'laptop'::character varying, 'TV'::character varying])::text[])))
);


ALTER TABLE public.dispositivo OWNER TO postgres;

--
-- Name: episodio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.episodio (
    episodioid integer NOT NULL,
    serieid integer NOT NULL,
    titulo character varying(100) NOT NULL,
    duracion integer NOT NULL,
    numerotemporada integer NOT NULL,
    numeroepisodio integer NOT NULL
);


ALTER TABLE public.episodio OWNER TO postgres;

--
-- Name: factura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.factura (
    facturaid integer NOT NULL,
    usuarioid integer NOT NULL,
    fecha date NOT NULL,
    montocuotamensual numeric(10,2) NOT NULL,
    montorentasadicionales numeric(10,2) DEFAULT 0 NOT NULL,
    montototal numeric(10,2) NOT NULL,
    estado character varying(20) NOT NULL,
    CONSTRAINT factura_estado_check CHECK (((estado)::text = ANY ((ARRAY['Al corriente'::character varying, 'Deudor'::character varying])::text[])))
);


ALTER TABLE public.factura OWNER TO postgres;

--
-- Name: membresia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membresia (
    membresiaid integer NOT NULL,
    usuarioid integer NOT NULL,
    tipo character varying(20) NOT NULL,
    costo numeric(10,2) NOT NULL,
    fechainicio date NOT NULL,
    fechafin date NOT NULL,
    CONSTRAINT membresia_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['Standard'::character varying, 'Extendida'::character varying, 'Premium'::character varying])::text[])))
);


ALTER TABLE public.membresia OWNER TO postgres;

--
-- Name: pelicula; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pelicula (
    peliculaid integer NOT NULL,
    categoriaid integer NOT NULL,
    titulo character varying(100) NOT NULL,
    duracion integer NOT NULL,
    fechaestreno date NOT NULL,
    esestreno boolean DEFAULT false NOT NULL
);


ALTER TABLE public.pelicula OWNER TO postgres;

--
-- Name: serie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serie (
    serieid integer NOT NULL,
    categoriaid integer NOT NULL,
    titulo character varying(100) NOT NULL,
    fechaestreno date NOT NULL
);


ALTER TABLE public.serie OWNER TO postgres;

--
-- Name: serie_actor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serie_actor (
    serieid integer NOT NULL,
    actorid integer NOT NULL
);


ALTER TABLE public.serie_actor OWNER TO postgres;

--
-- Name: sesion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sesion (
    sesionid integer NOT NULL,
    usuarioid integer NOT NULL,
    dispositivoid integer NOT NULL,
    fechahorainicio timestamp without time zone NOT NULL,
    fechahorafin timestamp without time zone
);


ALTER TABLE public.sesion OWNER TO postgres;

--
-- Name: tarjeta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tarjeta (
    tarjetaid integer NOT NULL,
    usuarioid integer NOT NULL,
    numero character varying(16) NOT NULL,
    tipo character varying(20) NOT NULL,
    fechaexpiracion date NOT NULL,
    CONSTRAINT tarjeta_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['VISA'::character varying, 'MASTERCARD'::character varying, 'AMEX'::character varying])::text[])))
);


ALTER TABLE public.tarjeta OWNER TO postgres;

--
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    usuarioid integer NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    rfc character varying(13) NOT NULL,
    direccion character varying(200) NOT NULL,
    email character varying(100) NOT NULL,
    fecharegistro date NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- Name: vista_usuarios_dispositivos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vista_usuarios_dispositivos AS
 SELECT u.nombre,
    d.tipo AS dispositivo
   FROM ((public.usuario u
     JOIN public.sesion s ON ((u.usuarioid = s.usuarioid)))
     JOIN public.dispositivo d ON ((s.dispositivoid = d.dispositivoid)));


ALTER VIEW public.vista_usuarios_dispositivos OWNER TO postgres;

--
-- Name: auditoria_factura auditoriaid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria_factura ALTER COLUMN auditoriaid SET DEFAULT nextval('public.auditoria_factura_auditoriaid_seq'::regclass);


--
-- Data for Name: actor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actor (actorid, nombre, apellido) FROM stdin;
1	Tom	Cruise
2	Bryan	Cranston
\.


--
-- Data for Name: auditoria_factura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auditoria_factura (auditoriaid, facturaid, usuarioid, fecha, operacion) FROM stdin;
\.


--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria (categoriaid, nombre) FROM stdin;
1	Acción
2	Suspenso
3	Documental
\.


--
-- Data for Name: consumo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consumo (consumoid, usuarioid, peliculaid, episodioid, tipocontenido, fechahorainicio, fechahorafin, dispositivoid, esrenta) FROM stdin;
1	1	1	\N	Pelicula	2024-05-10 20:00:00	2024-05-10 22:00:00	1	t
2	2	\N	1	Episodio	2024-05-11 18:00:00	2024-05-11 19:00:00	2	t
\.


--
-- Data for Name: dispositivo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dispositivo (dispositivoid, tipo) FROM stdin;
1	smartphone
2	laptop
3	TV
\.


--
-- Data for Name: episodio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.episodio (episodioid, serieid, titulo, duracion, numerotemporada, numeroepisodio) FROM stdin;
1	1	Piloto	58	1	1
2	2	La vida en el agua	60	1	1
\.


--
-- Data for Name: factura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.factura (facturaid, usuarioid, fecha, montocuotamensual, montorentasadicionales, montototal, estado) FROM stdin;
1	1	2024-05-31	299.00	50.00	349.00	Al corriente
2	2	2024-05-31	159.00	0.00	159.00	Al corriente
\.


--
-- Data for Name: membresia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membresia (membresiaid, usuarioid, tipo, costo, fechainicio, fechafin) FROM stdin;
1	1	Premium	299.00	2024-05-01	2024-06-01
2	2	Premium	299.00	2024-05-15	2024-06-15
\.


--
-- Data for Name: pelicula; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pelicula (peliculaid, categoriaid, titulo, duracion, fechaestreno, esestreno) FROM stdin;
1	1	Misión Imposible	120	2023-12-01	t
2	2	El Código Da Vinci	150	2022-09-15	f
\.


--
-- Data for Name: serie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serie (serieid, categoriaid, titulo, fechaestreno) FROM stdin;
1	2	Breaking Bad	2008-01-20
2	3	Planeta Tierra	2006-03-05
\.


--
-- Data for Name: serie_actor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serie_actor (serieid, actorid) FROM stdin;
1	2
\.


--
-- Data for Name: sesion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sesion (sesionid, usuarioid, dispositivoid, fechahorainicio, fechahorafin) FROM stdin;
2	2	2	2024-05-11 17:55:00	2024-05-11 19:05:00
1	1	3	2024-05-10 19:50:00	2024-05-10 22:05:00
\.


--
-- Data for Name: tarjeta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tarjeta (tarjetaid, usuarioid, numero, tipo, fechaexpiracion) FROM stdin;
1	1	4111111111111111	VISA	2027-01-01
2	2	5500000000000004	MASTERCARD	2026-12-01
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (usuarioid, nombre, apellido, rfc, direccion, email, fecharegistro) FROM stdin;
2	Luis	Pérez	PERL800202YYY	Calle Reforma 456	luis.perez@email.com	2024-05-02
1	Ana	García	GARA750101XXX	Av. México 123	ana.garcia2024@email.com	2024-05-01
\.


--
-- Name: auditoria_factura_auditoriaid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auditoria_factura_auditoriaid_seq', 1, false);


--
-- Name: actor actor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_pkey PRIMARY KEY (actorid);


--
-- Name: auditoria_factura auditoria_factura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria_factura
    ADD CONSTRAINT auditoria_factura_pkey PRIMARY KEY (auditoriaid);


--
-- Name: categoria categoria_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_nombre_key UNIQUE (nombre);


--
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (categoriaid);


--
-- Name: consumo consumo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumo
    ADD CONSTRAINT consumo_pkey PRIMARY KEY (consumoid);


--
-- Name: dispositivo dispositivo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dispositivo
    ADD CONSTRAINT dispositivo_pkey PRIMARY KEY (dispositivoid);


--
-- Name: episodio episodio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.episodio
    ADD CONSTRAINT episodio_pkey PRIMARY KEY (episodioid);


--
-- Name: factura factura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura
    ADD CONSTRAINT factura_pkey PRIMARY KEY (facturaid);


--
-- Name: membresia membresia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membresia
    ADD CONSTRAINT membresia_pkey PRIMARY KEY (membresiaid);


--
-- Name: pelicula pelicula_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pelicula
    ADD CONSTRAINT pelicula_pkey PRIMARY KEY (peliculaid);


--
-- Name: serie_actor serie_actor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie_actor
    ADD CONSTRAINT serie_actor_pkey PRIMARY KEY (serieid, actorid);


--
-- Name: serie serie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie
    ADD CONSTRAINT serie_pkey PRIMARY KEY (serieid);


--
-- Name: sesion sesion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sesion
    ADD CONSTRAINT sesion_pkey PRIMARY KEY (sesionid);


--
-- Name: tarjeta tarjeta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarjeta
    ADD CONSTRAINT tarjeta_pkey PRIMARY KEY (tarjetaid);


--
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (usuarioid);


--
-- Name: usuario usuario_rfc_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_rfc_key UNIQUE (rfc);


--
-- Name: idx_consumo_usuarioid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_consumo_usuarioid ON public.consumo USING btree (usuarioid);


--
-- Name: idx_factura_usuarioid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_factura_usuarioid ON public.factura USING btree (usuarioid);


--
-- Name: idx_membresia_usuarioid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_membresia_usuarioid ON public.membresia USING btree (usuarioid);


--
-- Name: idx_sesion_usuarioid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sesion_usuarioid ON public.sesion USING btree (usuarioid);


--
-- Name: idx_tarjeta_usuarioid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tarjeta_usuarioid ON public.tarjeta USING btree (usuarioid);


--
-- Name: factura trg_auditoria_factura; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_auditoria_factura AFTER UPDATE ON public.factura FOR EACH ROW EXECUTE FUNCTION public.registrar_auditoria_factura();


--
-- Name: consumo consumo_dispositivoid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumo
    ADD CONSTRAINT consumo_dispositivoid_fkey FOREIGN KEY (dispositivoid) REFERENCES public.dispositivo(dispositivoid);


--
-- Name: consumo consumo_episodioid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumo
    ADD CONSTRAINT consumo_episodioid_fkey FOREIGN KEY (episodioid) REFERENCES public.episodio(episodioid);


--
-- Name: consumo consumo_peliculaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumo
    ADD CONSTRAINT consumo_peliculaid_fkey FOREIGN KEY (peliculaid) REFERENCES public.pelicula(peliculaid);


--
-- Name: consumo consumo_usuarioid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumo
    ADD CONSTRAINT consumo_usuarioid_fkey FOREIGN KEY (usuarioid) REFERENCES public.usuario(usuarioid);


--
-- Name: episodio episodio_serieid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.episodio
    ADD CONSTRAINT episodio_serieid_fkey FOREIGN KEY (serieid) REFERENCES public.serie(serieid);


--
-- Name: factura factura_usuarioid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura
    ADD CONSTRAINT factura_usuarioid_fkey FOREIGN KEY (usuarioid) REFERENCES public.usuario(usuarioid);


--
-- Name: membresia membresia_usuarioid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membresia
    ADD CONSTRAINT membresia_usuarioid_fkey FOREIGN KEY (usuarioid) REFERENCES public.usuario(usuarioid);


--
-- Name: pelicula pelicula_categoriaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pelicula
    ADD CONSTRAINT pelicula_categoriaid_fkey FOREIGN KEY (categoriaid) REFERENCES public.categoria(categoriaid);


--
-- Name: serie_actor serie_actor_actorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie_actor
    ADD CONSTRAINT serie_actor_actorid_fkey FOREIGN KEY (actorid) REFERENCES public.actor(actorid);


--
-- Name: serie_actor serie_actor_serieid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie_actor
    ADD CONSTRAINT serie_actor_serieid_fkey FOREIGN KEY (serieid) REFERENCES public.serie(serieid);


--
-- Name: serie serie_categoriaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie
    ADD CONSTRAINT serie_categoriaid_fkey FOREIGN KEY (categoriaid) REFERENCES public.categoria(categoriaid);


--
-- Name: sesion sesion_dispositivoid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sesion
    ADD CONSTRAINT sesion_dispositivoid_fkey FOREIGN KEY (dispositivoid) REFERENCES public.dispositivo(dispositivoid);


--
-- Name: sesion sesion_usuarioid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sesion
    ADD CONSTRAINT sesion_usuarioid_fkey FOREIGN KEY (usuarioid) REFERENCES public.usuario(usuarioid);


--
-- Name: tarjeta tarjeta_usuarioid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarjeta
    ADD CONSTRAINT tarjeta_usuarioid_fkey FOREIGN KEY (usuarioid) REFERENCES public.usuario(usuarioid);


--
-- PostgreSQL database dump complete
--

