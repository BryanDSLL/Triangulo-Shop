CREATE SCHEMA sistema;

ALTER SCHEMA sistema OWNER TO postgres;

SET default_tablespace = '';

SET client_encoding = 'UTF8';

CREATE TABLE sistema.registros (
    idregistro integer NOT NULL,
    tipo character varying(30),
    lado1 character varying(30),
    lado2 character varying(30),
    lado3 character varying(30),
    data date
);

ALTER TABLE sistema.registros OWNER TO postgres;

-- Criar a sequência manualmente
CREATE SEQUENCE sistema.registros_idregistro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- Associar a sequência à coluna idregistro
ALTER TABLE sistema.registros ALTER COLUMN idregistro SET DEFAULT nextval('sistema.registros_idregistro_seq');

-- Inserção dos dados via COPY (mesmo conteúdo que você mandou)
INSERT INTO sistema.registros (idregistro, tipo, lado1, lado2, lado3, data) VALUES
(1, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(2, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(3, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(4, 'Triângulo Isósceles', '5', '6', '5', '2025-04-29'),
(5, 'Triângulo Escaleno', '5', '6', '7', '2025-04-29'),
(6, 'Não é um triângulo!', '5', '600', '7', '2025-04-29'),
(7, 'Triângulo Escaleno', '5', '6', '7', '2025-04-29'),
(8, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(9, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(10, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(11, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(12, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(13, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(14, 'Não é um triângulo!', '555', '5', '55', '2025-04-29'),
(15, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(16, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(17, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(18, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(19, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(20, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(21, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(22, 'Triângulo Equilátero', '5', '5', '5', '2025-04-29'),
(23, 'Triângulo Equilátero', '5', '5', '5', '2025-05-02'),
(24, 'Triângulo Equilátero', '5', '5', '5', '2025-05-02'),
(25, 'Triângulo Equilátero', '5', '5', '5', '2025-05-02'),
(26, 'Triângulo Equilátero', '5', '5', '5', '2025-05-02'),
(27, 'Triângulo Equilátero', '5', '5', '5', '2025-05-03'),
(28, 'Triângulo Equilátero', '5', '5', '5', '2025-05-03'),
(29, 'Triângulo Equilátero', '5', '5', '5', '2025-05-03'),
(30, 'Triângulo Equilátero', '5', '5', '5', '2025-05-03'),
(31, 'Triângulo Isósceles', '5', '6', '5', '2025-05-03'),
(32, 'Triângulo Escaleno', '5', '6', '7', '2025-05-03'),
(33, 'Triângulo Equilátero', '5', '5', '5', '2025-05-04'),
(34, 'Triângulo Escaleno', '5', '6', '7', '2025-05-04'),
(35, 'Triângulo Equilátero', '5', '5', '5', '2025-05-05'),
(36, 'Triângulo Equilátero', '5', '5', '5', '2025-05-05'),
(37, 'Triângulo Equilátero', '2', '2', '2', '2025-05-05'),
(38, 'Não é um triângulo!', '2', '2', '25', '2025-05-05'),
(39, 'Não é um triângulo!', '2', '2', '25', '2025-05-05'),
(40, 'Não é um triângulo!', '5', '200', '5', '2025-05-05'),
(41, 'Não é um triângulo!', '10', '200', '5', '2025-05-05'),
(42, 'Triângulo Isósceles', '10', '10', '5', '2025-05-05'),
(43, 'Triângulo Isósceles', '10', '10', '9', '2025-05-05'),
(44, 'Não é um triângulo!', '01', '10', '9', '2025-05-05'),
(45, 'Não é um triângulo!', '1', '2', '9', '2025-05-05'),
(46, 'Não é um triângulo!', '1', '2', '1', '2025-05-05'),
(47, 'Não é um triângulo!', '1', '9', '10', '2025-05-05'),
(48, 'Triângulo Escaleno', '2', '9', '10', '2025-05-05'),
(49, 'Triângulo Escaleno', '4', '8', '9', '2025-05-05'),
(50, 'Triângulo Equilátero', '5', '5', '5', '2025-05-06'),
(51, 'Triângulo Isósceles', '5', '6', '5', '2025-05-06'),
(52, 'Não é um triângulo!', '5', '600', '5', '2025-05-06'),
(53, 'Não é um triângulo!', '50', '544', '50', '2025-05-06');


-- Ajustar o valor atual da sequência
SELECT pg_catalog.setval('sistema.registros_idregistro_seq', 53, true);

-- Adicionar chave primária
ALTER TABLE ONLY sistema.registros
    ADD CONSTRAINT registros_pkey PRIMARY KEY (idregistro);
