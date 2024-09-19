-- create the 'forum' user, allow login and set a password
CREATE ROLE forum WITH LOGIN PASSWORD '123';

-- create a new database
CREATE DATABASE forumdb WITH OWNER forum;

-- now connect to the forum database
-- and execute all the population statements
\c forumdb

SET ROLE TO forum;

CREATE SCHEMA forum AUTHORIZATION forum;

SET search_path=forum;


--
-- Name: categories; Type: TABLE; Schema: forum; Owner: forum
--

CREATE TABLE forum.categories (
    id integer GENERATED ALWAYS AS IDENTITY,
    title text NOT NULL,
    description text
);


--
-- Name: j_posts_tags; Type: TABLE; Schema: forum; Owner: forum
--

CREATE TABLE forum.j_posts_tags (
    tag_id integer NOT NULL,
    post_id integer NOT NULL
);


--
-- Name: posts; Type: TABLE; Schema: forum; Owner: forum
--

CREATE TABLE forum.posts (
    id integer GENERATED ALWAYS AS IDENTITY,
    title text,
    content text,
    author integer NOT NULL,
    category integer NOT NULL,
    reply_to integer,
    created_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_edited_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    editable boolean DEFAULT true,
    likes integer DEFAULT 0
);


--
-- Name: tags; Type: TABLE; Schema: forum; Owner: forum
--

CREATE TABLE forum.tags (
    id integer GENERATED ALWAYS AS IDENTITY,
    tag text NOT NULL,
    parent integer
);


--
-- Name: users; Type: TABLE; Schema: forum; Owner: forum
--

CREATE TABLE forum.users (
    id integer GENERATED ALWAYS AS IDENTITY,
    username text NOT NULL,
    email text NOT NULL
);

--
-- Data for Name: categories; Type: TABLE DATA; Schema: forum; Owner: forum
--

COPY forum.categories (id, title, description) FROM stdin;
5	Software engineering	Software engineering discussions
1	Database	Database related discussions
2	Unix	Unix and Linux discussions
3	Programming Languages	All about programming languages
4	A.I	Machine Learning discussions
\.



--
-- Data for Name: j_posts_tags; Type: TABLE DATA; Schema: forum; Owner: forum
--

COPY forum.j_posts_tags (tag_id, post_id) FROM stdin;
3	7
3	6
4	5
3	5
4	6
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: forum; Owner: forum
--

COPY forum.posts (id, title, content, author, category, reply_to, created_on, last_edited_on, editable, likes) FROM stdin;
3	Programming languages	All about programming languages	1	1	\N	2023-01-23 15:21:55.747463+00	2023-01-23 15:21:55.747463+00	t	3
5	Indexing PostgreSQL	Btree in PostgreSQL is....	1	1	\N	2023-01-23 15:21:55.747463+00	2023-01-23 15:21:55.747463+00	t	3
6	Indexing Mysql	Btree in Mysql is....	1	1	\N	2023-01-23 15:22:02.38953+00	2023-01-23 15:22:02.38953+00	t	3
7	A view of  Data types in C++	Data type in C++ are	2	3	\N	2023-01-23 15:26:21.367814+00	2023-01-23 15:26:21.367814+00	t	0
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: forum; Owner: forum
--


COPY forum.tags (id, tag, parent) FROM stdin;
1	Operating Systems	\N
2	Linux	1
3	Ubuntu	2
4	Kubuntu	3
5	Database	\N
6	Operating Systems	\N
\.



--
-- Data for Name: users; Type: TABLE DATA; Schema: forum; Owner: forum
--

COPY forum.users (id, username, email) FROM stdin;
1	luca_ferrari	luca@pgtraining.com
2	enrico_pirozzi	enrico@pgtraiing.com
3	newuser 	newuser@pgtraining.com
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: forum; Owner: forum
--

SELECT pg_catalog.setval('forum.categories_id_seq', 5, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: forum; Owner: forum
--

SELECT pg_catalog.setval('forum.posts_id_seq', 8, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: forum; Owner: forum
--

SELECT pg_catalog.setval('forum.tags_id_seq', 4, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: forum; Owner: forum
--

SELECT pg_catalog.setval('forum.users_id_seq', 4, true);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: j_posts_tags j_posts_tags_pkey; Type: CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.j_posts_tags
    ADD CONSTRAINT j_posts_tags_pkey PRIMARY KEY (tag_id, post_id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: j_posts_tags j_posts_tags_post_pk_fkey; Type: FK CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.j_posts_tags
    ADD CONSTRAINT j_posts_tags_post_id_fkey FOREIGN KEY (post_id) REFERENCES forum.posts(id);


--
-- Name: j_posts_tags j_posts_tags_tag_pk_fkey; Type: FK CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.j_posts_tags
    ADD CONSTRAINT j_posts_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES forum.tags(id);


--
-- Name: posts posts_author_fkey; Type: FK CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.posts
    ADD CONSTRAINT posts_author_fkey FOREIGN KEY (author) REFERENCES forum.users(id);


--
-- Name: posts posts_category_fkey; Type: FK CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.posts
    ADD CONSTRAINT posts_category_fkey FOREIGN KEY (category) REFERENCES forum.categories(id);


--
-- Name: posts posts_reply_to_fkey; Type: FK CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.posts
    ADD CONSTRAINT posts_reply_to_fkey FOREIGN KEY (reply_to) REFERENCES forum.posts(id);


--
-- Name: tags tags_parent_fkey; Type: FK CONSTRAINT; Schema: forum; Owner: forum
--

ALTER TABLE ONLY forum.tags
    ADD CONSTRAINT tags_parent_fkey FOREIGN KEY (parent) REFERENCES forum.tags(id);


--
-- PostgreSQL database dump complete
--