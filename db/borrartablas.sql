TRUNCATE TABLE spree_assets;

TRUNCATE TABLE spree_importation_attachments;

TRUNCATE TABLE spree_importation_products;

TRUNCATE TABLE spree_importation_products_taxons;

TRUNCATE TABLE spree_importation_variants;

TRUNCATE TABLE spree_importations;

TRUNCATE TABLE spree_option_values;

TRUNCATE TABLE spree_option_values_variants;

TRUNCATE TABLE spree_prices;

TRUNCATE TABLE spree_product_option_types;

TRUNCATE TABLE spree_products;

TRUNCATE TABLE spree_variants;

TRUNCATE TABLE spree_line_items;

TRUNCATE TABLE spree_orders;

TRUNCATE TABLE spree_products_taxons;

TRUNCATE TABLE spree_state_changes;

TRUNCATE TABLE spree_taxons;

INSERT INTO spree_taxons VALUES (55, 37, 0, 'Niños', 'categorias/basicos/ninos', 1, 101, 102, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:47:36.582654', '2013-12-17 14:47:36.582654');
INSERT INTO spree_taxons VALUES (49, 35, 0, 'Guantes', 'categorias/botas-y-guantes/guantes', 1, 85, 86, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:46:33.836526', '2013-12-17 14:46:33.836526');
INSERT INTO spree_taxons VALUES (47, 34, 2, 'Pantalones', 'categorias/trajes-motorista/pantalones', 1, 79, 80, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:45:44.482825', '2013-12-17 14:45:44.482825');
INSERT INTO spree_taxons VALUES (44, 33, 6, 'Accesorios', 'categorias/cascos/accesorios', 1, 71, 72, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:45:21.521589', '2013-12-17 14:45:21.521589');
INSERT INTO spree_taxons VALUES (35, 1, 2, 'Botas y Guantes', 'categorias/botas-y-guantes', 1, 84, 89, NULL, NULL, NULL, NULL, '', '2013-12-17 14:29:11.866298', '2013-12-17 14:43:14.354961');
INSERT INTO spree_taxons VALUES (36, 1, 3, 'Ropa Funcional', 'categorias/ropa-funcional', 1, 90, 99, NULL, NULL, NULL, NULL, '', '2013-12-17 14:29:56.213179', '2013-12-17 14:43:41.282285');
INSERT INTO spree_taxons VALUES (37, 1, 4, 'Básicos', 'categorias/basicos', 1, 100, 109, NULL, NULL, NULL, NULL, '', '2013-12-17 14:30:36.923601', '2013-12-17 14:44:00.022567');
INSERT INTO spree_taxons VALUES (38, 33, 0, 'System VI Evo', 'categorias/cascos/system-vi-evo', 1, 59, 60, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:44:20.172268', '2013-12-17 14:44:20.172268');
INSERT INTO spree_taxons VALUES (1, NULL, 0, 'Categorías', 'categorias', 1, 1, 110, NULL, NULL, NULL, NULL, NULL, '2013-02-18 15:45:46.347119', '2013-02-18 15:45:46.347119');
INSERT INTO spree_taxons VALUES (33, 1, 0, 'Cascos', 'categorias/cascos', 1, 58, 73, NULL, NULL, NULL, NULL, '', '2013-12-17 14:27:30.597693', '2013-12-17 14:28:03.214637');
INSERT INTO spree_taxons VALUES (39, 33, 1, 'System VI', 'categorias/cascos/system-vi', 1, 61, 62, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:44:28.294226', '2013-12-17 14:44:28.294226');
INSERT INTO spree_taxons VALUES (56, 37, 1, 'Style', 'categorias/basicos/style', 1, 103, 104, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:47:45.674947', '2013-12-17 14:47:45.674947');
INSERT INTO spree_taxons VALUES (57, 37, 2, 'Bolsas de Viaje', 'categorias/basicos/bolsas-de-viaje', 1, 105, 106, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:47:52.058517', '2013-12-17 14:47:52.058517');
INSERT INTO spree_taxons VALUES (58, 37, 3, 'Mochilas', 'categorias/basicos/mochilas', 1, 107, 108, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:48:03.124946', '2013-12-17 14:48:03.124946');
INSERT INTO spree_taxons VALUES (34, 1, 1, 'Trajes Motorista', 'categorias/trajes-motorista', 1, 74, 83, NULL, NULL, NULL, NULL, '', '2013-12-17 14:28:58.494663', '2013-12-17 14:36:13.108038');
INSERT INTO spree_taxons VALUES (40, 33, 2, 'Sport', 'categorias/cascos/sport', 1, 63, 64, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:44:41.928454', '2013-12-17 14:44:41.928454');
INSERT INTO spree_taxons VALUES (41, 33, 3, 'Enduro', 'categorias/cascos/enduro', 1, 65, 66, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:44:49.439174', '2013-12-17 14:44:49.439174');
INSERT INTO spree_taxons VALUES (42, 33, 4, 'Airflow', 'categorias/cascos/airflow', 1, 67, 68, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:45:06.579534', '2013-12-17 14:45:06.579534');
INSERT INTO spree_taxons VALUES (43, 33, 5, 'Airflow 2', 'categorias/cascos/airflow-2', 1, 69, 70, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:45:13.537657', '2013-12-17 14:45:13.537657');
INSERT INTO spree_taxons VALUES (45, 34, 0, 'Textil', 'categorias/trajes-motorista/textil', 1, 75, 76, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:45:31.250484', '2013-12-17 14:45:31.250484');
INSERT INTO spree_taxons VALUES (46, 34, 1, 'Cuero', 'categorias/trajes-motorista/cuero', 1, 77, 78, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:45:37.567274', '2013-12-17 14:45:37.567274');
INSERT INTO spree_taxons VALUES (48, 34, 3, 'Chaquetas', 'categorias/trajes-motorista/chaquetas', 1, 81, 82, NULL, NULL, NULL, NULL, '', '2013-12-17 14:45:55.642261', '2013-12-17 14:46:17.935435');
INSERT INTO spree_taxons VALUES (50, 35, 1, 'Botas', 'categorias/botas-y-guantes/botas', 1, 87, 88, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:46:42.248262', '2013-12-17 14:46:42.248262');
INSERT INTO spree_taxons VALUES (51, 36, 0, 'Lluvia', 'categorias/ropa-funcional/lluvia', 1, 91, 92, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:47:06.100513', '2013-12-17 14:47:06.100513');
INSERT INTO spree_taxons VALUES (52, 36, 1, 'Funcional Térmica', 'categorias/ropa-funcional/funcional-termica', 1, 93, 94, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:47:13.693262', '2013-12-17 14:47:13.693262');
INSERT INTO spree_taxons VALUES (53, 36, 2, 'Funcional Transpirable', 'categorias/ropa-funcional/funcional-transpirable', 1, 95, 96, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:47:20.171139', '2013-12-17 14:47:20.171139');
INSERT INTO spree_taxons VALUES (54, 36, 3, 'Seguridad', 'categorias/ropa-funcional/seguridad', 1, 97, 98, NULL, NULL, NULL, NULL, NULL, '2013-12-17 14:47:27.142381', '2013-12-17 14:47:27.142381');


--
-- Name: spree_taxons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('spree_taxons_id_seq', 58, true);

