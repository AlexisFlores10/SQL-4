CREATE TABLE public.categoria (
    idcategoria bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    categoria character varying(100) NOT NULL
);

CREATE TABLE public.recinto (
    idrecinto bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre character varying(150) NOT NULL,
    direccion character varying(255),
    ciudad character varying(100),
    capacidadtotal integer
);

CREATE TABLE public.usuario (
    idusuario bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    correo character varying(150) NOT NULL UNIQUE,
    telefono character varying(20),
    usuario character varying(50) NOT NULL UNIQUE,
    clave character varying(255) NOT NULL,
    fecharegistro date DEFAULT CURRENT_DATE,
    estado character varying(30) DEFAULT 'activo'::character varying
);

CREATE TABLE public.evento (
    idevento bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre character varying(150) NOT NULL,
    descripcion character varying(500),
    idcategoria bigint NOT NULL REFERENCES public.categoria(idcategoria)
);

CREATE TABLE public.asiento (
    idasiento bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fila character varying(10) NOT NULL,
    numero character varying(10) NOT NULL,
    zona character varying(50),
    idrecinto bigint NOT NULL REFERENCES public.recinto(idrecinto),
    CONSTRAINT uq_asiento_recinto UNIQUE (idrecinto, fila, numero)
);

CREATE TABLE public.funcion (
    idfuncion bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha date NOT NULL,
    hora time without time zone NOT NULL,
    estado character varying(30) DEFAULT 'programada'::character varying,
    idevento bigint NOT NULL REFERENCES public.evento(idevento),
    idrecinto bigint NOT NULL REFERENCES public.recinto(idrecinto)
);

CREATE TABLE public.tarifa (
    idtarifa bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    precio numeric(10,2) NOT NULL CHECK (precio >= 0),
    estado character varying(30) DEFAULT 'activa'::character varying,
    idfuncion bigint NOT NULL REFERENCES public.funcion(idfuncion),
    idasiento bigint NOT NULL REFERENCES public.asiento(idasiento),
    CONSTRAINT uq_tarifa_funcion_asiento UNIQUE (idfuncion, idasiento)
);

CREATE TABLE public.pago (
    idpago bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha date DEFAULT CURRENT_DATE,
    hora time without time zone DEFAULT CURRENT_TIME,
    montototal numeric(10,2) NOT NULL CHECK (montototal >= 0),
    metodopago character varying(50) NOT NULL,
    estado character varying(30) DEFAULT 'pendiente'::character varying,
    idusuario bigint NOT NULL REFERENCES public.usuario(idusuario)
);

CREATE TABLE public.tique (
    idtique bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo character varying(100) NOT NULL UNIQUE,
    preciopagado numeric(10,2) NOT NULL CHECK (preciopagado >= 0),
    fechaemision timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(30) DEFAULT 'emitido'::character varying,
    idprecio bigint NOT NULL REFERENCES public.tarifa(idtarifa),
    idpago bigint NOT NULL REFERENCES public.pago(idpago),
    idusuario bigint NOT NULL REFERENCES public.usuario(idusuario)
);

INSERT INTO public.categoria (idcategoria, categoria) OVERRIDING SYSTEM VALUE VALUES
(1, 'Conciertos'), (2, 'Teatro'), (3, 'Deportes'), (4, 'Comedia'), (5, 'Festivales'),
(6, 'Danza'), (7, 'Musicales'), (8, 'Tecnología'), (9, 'Arte y Exposición'), (10, 'Cine');

INSERT INTO public.recinto (idrecinto, nombre, direccion, ciudad, capacidadtotal) OVERRIDING SYSTEM VALUE VALUES
(1, 'Estadio Central', 'Avenida Central 100', 'San Salvador', 45000),
(2, 'Teatro Nacional', 'Plaza Morazán', 'San Salvador', 800),
(3, 'Arena Deportiva', 'Boulevard del Deporte', 'Santa Tecla', 12000),
(4, 'Auditorio Norte', 'Km 14 Carretera Norte', 'Popotlán', 1500),
(5, 'Centro de Convenciones', 'Avenida La Revolución', 'San Salvador', 10000),
(6, 'Sala Cultural', 'Calle San Antonio Abad', 'San Salvador', 500),
(7, 'Foro Musical', 'Centro Comercial Galerías', 'San Salvador', 2000),
(8, 'Pabellón Expo', 'CIFCO Antiguo', 'San Salvador', 8000),
(9, 'Cine Teatro', 'Paseo El Carmen', 'Santa Tecla', 1200),
(10, 'Polideportivo Sur', 'Boulevard Sur', 'Santa Tecla', 6000);

INSERT INTO public.usuario (nombre, apellido, correo, telefono, usuario, clave) VALUES
('Ana', 'López', 'ana.lopez@email.com', '7100-0001', 'ana_lopez', 'clave123'),
('Carlos', 'Méndez', 'carlos.mendez@email.com', '7100-0002', 'carlos_mendez', 'clave123'),
('María', 'García', 'maria.garcia@email.com', '7100-0003', 'maria_garcia', 'clave123'),
('José', 'Hernández', 'jose.hernandez@email.com', '7100-0004', 'jose_hernandez', 'clave123'),
('Lucía', 'Ramírez', 'lucia.ramirez@email.com', '7100-0005', 'lucia_ramirez', 'clave123'),
('Daniel', 'Castro', 'daniel.castro@email.com', '7100-0006', 'daniel_castro', 'clave123'),
('Sofía', 'Reyes', 'sofia.reyes@email.com', '7100-0007', 'sofia_reyes', 'clave123'),
('Miguel', 'Flores', 'miguel.flores@email.com', '7100-0008', 'miguel_flores', 'clave123'),
('Elena', 'Vargas', 'elena.vargas@email.com', '7100-0009', 'elena_vargas', 'clave123'),
('Pedro', 'Morales', 'pedro.morales@email.com', '7100-0010', 'pedro_morales', 'clave123'),
('Prueba', 'Once', 'prueba11@email.com', '7100-0011', 'prueba_11', 'clave123'),
('Prueba', 'Doce', 'prueba12@email.com', '7100-0012', 'prueba_12', 'clave123'),
('Prueba', 'Trece', 'prueba13@email.com', '7100-0013', 'prueba_13', 'clave123'),
('Prueba', 'Catorce', 'prueba14@email.com', '7100-0014', 'prueba_14', 'clave123'),
('Prueba', 'Quince', 'prueba15@email.com', '7100-0015', 'prueba_15', 'clave123');

INSERT INTO public.evento (nombre, descripcion, idcategoria) VALUES
('Noche de Rock', 'Concierto de bandas nacionales e internacionales', 1),
('Hamlet', 'Obra clásica de William Shakespeare', 2),
('Final de Basket', 'Partido de campeonato nacional', 3),
('Stand-up Comedy', 'Noche de risas con comediantes invitados', 4),
('Festival de Verano', 'Música y arte al aire libre', 5),
('Noche de Danza', 'Gala de ballet contemporáneo', 6),
('Gran Musical', 'Espectáculo teatral con música en vivo', 7),
('Foro Tecnológico', 'Conferencias sobre innovación y desarrollo', 8),
('Expo Creativa', 'Exhibición de arte moderno y fotografía', 9),
('Cine al Aire Libre', 'Proyección de películas independientes', 10);

INSERT INTO public.asiento (fila, numero, zona, idrecinto) VALUES
('A', '1', 'VIP', 1), ('A', '2', 'VIP', 1),
('B', '1', 'General', 2), ('B', '2', 'General', 2),
('C', '1', 'Platea', 3), ('C', '2', 'Platea', 3),
('D', '1', 'VIP', 4), ('D', '2', 'VIP', 4),
('E', '1', 'General', 5), ('E', '2', 'General', 5),
('F', '1', 'VIP', 6), ('F', '2', 'VIP', 6),
('G', '1', 'Platea', 7), ('G', '2', 'Platea', 7),
('H', '1', 'VIP', 8), ('H', '2', 'VIP', 8),
('I', '1', 'General', 9), ('I', '2', 'General', 9),
('J', '1', 'VIP', 10), ('J', '2', 'VIP', 10);

INSERT INTO public.funcion (fecha, hora, estado, idevento, idrecinto) VALUES
('2026-12-01', '19:00:00', 'programada', 1, 1),
('2026-12-02', '20:00:00', 'programada', 2, 2),
('2026-12-03', '18:30:00', 'programada', 3, 3),
('2026-12-04', '21:00:00', 'programada', 4, 4),
('2026-12-05', '16:00:00', 'programada', 5, 5),
('2026-12-06', '19:30:00', 'programada', 6, 6),
('2026-12-07', '20:00:00', 'programada', 7, 7),
('2026-12-08', '09:00:00', 'programada', 8, 8),
('2026-12-09', '10:00:00', 'programada', 9, 9),
('2026-12-10', '19:00:00', 'programada', 10, 10);

INSERT INTO public.tarifa (precio, estado, idfuncion, idasiento) VALUES
(45.00, 'activa', 1, 1),
(25.00, 'activa', 2, 2),
(30.00, 'activa', 3, 3),
(20.00, 'activa', 4, 4),
(35.00, 'activa', 5, 5),
(18.00, 'activa', 6, 6),
(40.00, 'activa', 7, 7),
(15.00, 'activa', 8, 8),
(12.00, 'activa', 9, 9),
(10.00, 'activa', 10, 10);

INSERT INTO public.pago (fecha, hora, montototal, metodopago, estado, idusuario)
SELECT DATE '2026-11-02', (TIME '10:00' + (v.n * INTERVAL '1 minute'))::time,
       v.monto, v.metodo, 'pendiente', v.idusuario
FROM (VALUES
(1, 45.00, 'Tarjeta', 1),
(2, 25.00, 'Efectivo', 2),
(3, 30.00, 'Transferencia', 3),
(4, 20.00, 'Tarjeta', 4),
(5, 35.00, 'Efectivo', 5),
(6, 18.00, 'Tarjeta', 6),
(7, 40.00, 'Transferencia', 7),
(8, 15.00, 'Tarjeta', 8),
(9, 12.00, 'Efectivo', 9),
(10, 10.00, 'Tarjeta', 10)
) AS v(n, monto, metodo, idusuario);

INSERT INTO public.tique (codigo, preciopagado, fechaemision, estado, idprecio, idpago, idusuario)
SELECT v.codigo, v.precio, TIMESTAMP '2026-11-02 11:00:00' + (v.n * INTERVAL '1 minute'),
       'emitido', ta.idtarifa, p.idpago, u.idusuario
FROM (VALUES
(1, 'TK-2026-001', 'Noche de Rock', 45.00, 'ana_lopez'),
(2, 'TK-2026-002', 'Hamlet', 25.00, 'carlos_mendez'),
(3, 'TK-2026-003', 'Final de Basket', 30.00, 'maria_garcia'),
(4, 'TK-2026-004', 'Stand-up Comedy', 20.00, 'jose_hernandez'),
(5, 'TK-2026-005', 'Festival de Verano', 35.00, 'lucia_ramirez'),
(6, 'TK-2026-006', 'Noche de Danza', 18.00, 'daniel_castro'),
(7, 'TK-2026-007', 'Gran Musical', 40.00, 'sofia_reyes'),
(8, 'TK-2026-008', 'Foro Tecnológico', 15.00, 'miguel_flores'),
(9, 'TK-2026-009', 'Expo Creativa', 12.00, 'elena_vargas'),
(10, 'TK-2026-010', 'Cine al Aire Libre', 10.00, 'pedro_morales')
) AS v(n, codigo, evento, precio, usuario)
JOIN public.usuario u ON u.usuario = v.usuario
JOIN public.pago p ON p.idusuario = u.idusuario 
    AND p.fecha = DATE '2026-11-02' 
    AND p.montototal = v.precio
JOIN public.evento e ON e.nombre = v.evento
JOIN public.funcion f ON f.idevento = e.idevento
JOIN public.tarifa ta ON ta.idfuncion = f.idfuncion AND ta.precio = v.precio;

SELECT idcategoria, categoria FROM public.categoria WHERE categoria = 'Conciertos';
UPDATE public.categoria SET categoria = 'Musica en vivo' WHERE categoria = 'Conciertos';

SELECT idrecinto, direccion FROM public.recinto WHERE nombre = 'Estadio Central';
UPDATE public.recinto SET direccion = 'Avenida Central 150' WHERE nombre = 'Estadio Central';

SELECT idusuario, telefono FROM public.usuario WHERE usuario = 'ana_lopez';
UPDATE public.usuario SET telefono = '7100-0001' WHERE usuario = 'ana_lopez';

SELECT idevento, descripcion FROM public.evento WHERE nombre = 'Noche de Rock';
UPDATE public.evento SET descripcion = 'Concierto de rock en vivo' WHERE nombre = 'Noche de Rock';

SELECT idasiento, zona FROM public.asiento WHERE fila = 'A' AND numero = '1'
AND idrecinto = (SELECT idrecinto FROM public.recinto WHERE nombre = 'Estadio Central');
UPDATE public.asiento SET zona = 'Preferencial' WHERE fila = 'A' AND numero = '1'
AND idrecinto = (SELECT idrecinto FROM public.recinto WHERE nombre = 'Estadio Central');

SELECT idfuncion, estado FROM public.funcion WHERE fecha = DATE '2026-12-01' AND hora = TIME '19:00';
UPDATE public.funcion SET estado = 'confirmada' WHERE fecha = DATE '2026-12-01' AND hora = TIME '19:00';

SELECT idtarifa, estado FROM public.tarifa WHERE precio = 45.00
AND idfuncion = (SELECT f.idfuncion FROM public.funcion f JOIN public.evento e ON e.idevento=f.idevento WHERE e.nombre='Noche de Rock');
UPDATE public.tarifa SET estado = 'promocional' WHERE precio = 45.00
AND idfuncion = (SELECT f.idfuncion FROM public.funcion f JOIN public.evento e ON e.idevento=f.idevento WHERE e.nombre='Noche de Rock');

SELECT idpago, estado FROM public.pago WHERE idusuario = (SELECT idusuario FROM public.usuario WHERE usuario='ana_lopez');
UPDATE public.pago SET estado = 'confirmado' WHERE idusuario = (SELECT idusuario FROM public.usuario WHERE usuario='ana_lopez');

SELECT idtique, estado FROM public.tique WHERE codigo = 'TK-2026-002';
UPDATE public.tique SET estado = 'validado' WHERE codigo = 'TK-2026-002';

SELECT idrecinto, capacidadtotal FROM public.recinto WHERE nombre = 'Teatro Nacional';
UPDATE public.recinto SET capacidadtotal = 850 WHERE nombre = 'Teatro Nacional';

SELECT idusuario, usuario, estado FROM public.usuario WHERE usuario = 'prueba_11';
DELETE FROM public.usuario WHERE usuario = 'prueba_11';

SELECT idusuario, usuario, estado FROM public.usuario WHERE usuario = 'prueba_12';
DELETE FROM public.usuario WHERE usuario = 'prueba_12';

SELECT idusuario, usuario, estado FROM public.usuario WHERE usuario = 'prueba_13';
DELETE FROM public.usuario WHERE usuario = 'prueba_13';

SELECT idusuario, usuario, estado FROM public.usuario WHERE usuario = 'prueba_14';
DELETE FROM public.usuario WHERE usuario = 'prueba_14';

SELECT idusuario, usuario, estado FROM public.usuario WHERE usuario = 'prueba_15';
DELETE FROM public.usuario WHERE usuario = 'prueba_15';

SELECT 'categoria' AS tabla, COUNT(*) AS registros FROM public.categoria
UNION ALL SELECT 'recinto', COUNT(*) FROM public.recinto
UNION ALL SELECT 'usuario', COUNT(*) FROM public.usuario
UNION ALL SELECT 'evento', COUNT(*) FROM public.evento
UNION ALL SELECT 'asiento', COUNT(*) FROM public.asiento
UNION ALL SELECT 'funcion', COUNT(*) FROM public.funcion
UNION ALL SELECT 'tarifa', COUNT(*) FROM public.tarifa
UNION ALL SELECT 'pago', COUNT(*) FROM public.pago
UNION ALL SELECT 'tique', COUNT(*) FROM public.tique;