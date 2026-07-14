-- ============================================================
-- SEED: Catálogo de técnicas BJJ — tecnicas_catalogo
-- Ejecutar en Supabase SQL Editor después de crear la tabla
-- ============================================================

INSERT INTO tecnicas_catalogo (nombre, disciplina, categoria, posicion_inicio, nivel, video_url) VALUES

-- ============================================================
-- SUMISIONES
-- ============================================================

-- Brazos
('Armbar desde guardia cerrada',    'BJJ', 'Sumisiones', 'Guardia cerrada',   'Principiante', 'https://www.youtube.com/watch?v=S7pJoPCxFDg'),
('Armbar desde montada',            'BJJ', 'Sumisiones', 'Montada',           'Principiante', 'https://www.youtube.com/watch?v=U8ORNcWCH7M'),
('Armbar desde espalda',            'BJJ', 'Sumisiones', 'Control de espalda','Intermedio',   'https://www.youtube.com/watch?v=c1OFV2L5cb0'),
('Kimura desde guardia cerrada',    'BJJ', 'Sumisiones', 'Guardia cerrada',   'Principiante', 'https://www.youtube.com/watch?v=lHhqiH37kok'),
('Kimura desde media guardia',      'BJJ', 'Sumisiones', 'Media guardia',     'Intermedio',   'https://www.youtube.com/watch?v=GFgox0wot1w'),
('Kimura desde side control',       'BJJ', 'Sumisiones', 'Side control',      'Principiante', 'https://www.youtube.com/watch?v=17YpQKnIq-c'),
('Americana desde montada',         'BJJ', 'Sumisiones', 'Montada',           'Principiante', 'https://www.youtube.com/watch?v=-GLC-8bXEjw'),
('Americana desde side control',    'BJJ', 'Sumisiones', 'Side control',      'Principiante', 'https://www.youtube.com/watch?v=QODa6ytG3vQ'),
('Omoplata',                        'BJJ', 'Sumisiones', 'Guardia cerrada',   'Intermedio',   'https://www.youtube.com/watch?v=KBpfQO8Uiz0'),
('Wristlock',                       'BJJ', 'Sumisiones', 'Varias',            'Avanzado',     'https://www.youtube.com/watch?v=eto6NUdXGcU'),

-- Estrangulaciones
('Triángulo desde guardia cerrada', 'BJJ', 'Sumisiones', 'Guardia cerrada',   'Principiante', 'https://www.youtube.com/watch?v=0f5IOQN3k3I'),
('Triángulo invertido',             'BJJ', 'Sumisiones', 'Guardia invertida', 'Avanzado',     'https://www.youtube.com/watch?v=TqxuTFFbn1E'),
('Triángulo con brazo (arm-in)',    'BJJ', 'Sumisiones', 'Guardia cerrada',   'Intermedio',   'https://www.youtube.com/watch?v=52NZhOpA2YE'),
('Rear naked choke',                'BJJ', 'Sumisiones', 'Control de espalda','Principiante', 'https://www.youtube.com/watch?v=MVKH9Jddh0c'),
('Guillotina de brazo libre',       'BJJ', 'Sumisiones', 'De pie / Guard pull','Principiante','https://www.youtube.com/watch?v=eTvZBx8TMFU'),
('Guillotina con brazo (arm-in)',   'BJJ', 'Sumisiones', 'Half guard top',    'Avanzado',     'https://www.youtube.com/watch?v=wtgggEGnMOo'),
('Anaconda choke',                  'BJJ', 'Sumisiones', 'Turtle',            'Intermedio',   'https://www.youtube.com/watch?v=wtgggEGnMOo'),
('D''arce choke',                   'BJJ', 'Sumisiones', 'Half guard top',    'Intermedio',   'https://www.youtube.com/watch?v=ZFqAQTRQFcs'),
('Bow and arrow choke',             'BJJ', 'Sumisiones', 'Control de espalda','Intermedio',   'https://www.youtube.com/watch?v=Q7R71XB3dig'),
('Clock choke',                     'BJJ', 'Sumisiones', 'Turtle',            'Intermedio',   'https://www.youtube.com/watch?v=jAGbvarXopw'),
('Ezekiel choke',                   'BJJ', 'Sumisiones', 'Montada',           'Intermedio',   'https://www.youtube.com/watch?v=8q1D_yYKJAk'),
('Loop choke',                      'BJJ', 'Sumisiones', 'Guardia cerrada',   'Avanzado',     'https://www.youtube.com/watch?v=TqxuTFFbn1E'),
('North-south choke',               'BJJ', 'Sumisiones', 'Norte-Sur',         'Avanzado',     'https://www.youtube.com/watch?v=wtgggEGnMOo'),
('Baseball bat choke',              'BJJ', 'Sumisiones', 'Turtle / Side ctrl','Avanzado',     'https://www.youtube.com/watch?v=7lRDkaLuLOU'),

-- Piernas
('Heel hook interno (inside)',      'BJJ', 'Sumisiones', 'Ashi garami',       'Avanzado',     'https://www.youtube.com/watch?v=C3QRfCARSM4'),
('Heel hook externo (outside)',     'BJJ', 'Sumisiones', '50/50',             'Avanzado',     'https://www.youtube.com/watch?v=hNTsYUShvLU'),
('Kneebar',                         'BJJ', 'Sumisiones', 'Leg entanglement',  'Avanzado',     'https://www.youtube.com/watch?v=JP1e5zVnxxU'),
('Toe hold',                        'BJJ', 'Sumisiones', 'Leg entanglement',  'Avanzado',     'https://www.youtube.com/watch?v=O3f8guHJFeU'),
('Calf slicer',                     'BJJ', 'Sumisiones', 'Media guardia top', 'Intermedio',   'https://www.youtube.com/watch?v=O3f8guHJFeU'),
('Straight ankle lock',             'BJJ', 'Sumisiones', 'Leg entanglement',  'Principiante', 'https://www.youtube.com/watch?v=JP1e5zVnxxU'),

-- ============================================================
-- POSICIONES
-- ============================================================

('Guardia cerrada',                 'BJJ', 'Posiciones', 'Guard',             'Principiante', 'https://www.youtube.com/watch?v=d4mtrEbTl7w'),
('Media guardia',                   'BJJ', 'Posiciones', 'Guard',             'Principiante', 'https://www.youtube.com/watch?v=LkVOnXrzHxM'),
('Guardia mariposa',                'BJJ', 'Posiciones', 'Guard',             'Principiante', 'https://www.youtube.com/watch?v=0WG1MYvgXAM'),
('Guardia de araña',                'BJJ', 'Posiciones', 'Guard',             'Intermedio',   'https://www.youtube.com/watch?v=qpmc6uClx4o'),
('Guardia de rodilla X (Z-guard)',  'BJJ', 'Posiciones', 'Guard',             'Intermedio',   'https://www.youtube.com/watch?v=5aWM-abbmMI'),
('Guardia de la Riva',              'BJJ', 'Posiciones', 'Guard',             'Intermedio',   'https://www.youtube.com/watch?v=rGyQy2dscso'),
('Guardia X',                       'BJJ', 'Posiciones', 'Guard',             'Avanzado',     'https://www.youtube.com/watch?v=rGyQy2dscso'),
('Guardia lasso',                   'BJJ', 'Posiciones', 'Guard',             'Avanzado',     'https://www.youtube.com/watch?v=l4awJBVlBFQ'),
('Guardia invertida (reverse DLR)', 'BJJ', 'Posiciones', 'Guard',             'Avanzado',     'https://www.youtube.com/watch?v=2EWWgJBonLU'),
('50/50',                           'BJJ', 'Posiciones', 'Leg entanglement',  'Avanzado',     'https://www.youtube.com/watch?v=X-9mH0ZVgoU'),
('Ashi garami',                     'BJJ', 'Posiciones', 'Leg entanglement',  'Avanzado',     'https://www.youtube.com/watch?v=2jxskHNcMkk'),
('Montada baja',                    'BJJ', 'Posiciones', 'Top',               'Principiante', 'https://www.youtube.com/watch?v=mv9RWzQiDVw'),
('Montada alta',                    'BJJ', 'Posiciones', 'Top',               'Intermedio',   'https://www.youtube.com/watch?v=mv9RWzQiDVw'),
('Side control',                    'BJJ', 'Posiciones', 'Top',               'Principiante', 'https://www.youtube.com/watch?v=VF8GrJdysv0'),
('Norte-Sur',                       'BJJ', 'Posiciones', 'Top',               'Principiante', 'https://www.youtube.com/watch?v=VF8GrJdysv0'),
('Rodilla en el vientre',           'BJJ', 'Posiciones', 'Top',               'Intermedio',   'https://www.youtube.com/watch?v=m1wVnwzqjW4'),
('Control de espalda (hooks)',      'BJJ', 'Posiciones', 'Top',               'Principiante', 'https://www.youtube.com/watch?v=m1wVnwzqjW4'),
('Turtle',                          'BJJ', 'Posiciones', 'Bottom',            'Principiante', 'https://www.youtube.com/watch?v=8YvYkGr5FIU'),
('Headquarters',                    'BJJ', 'Posiciones', 'Top / Passing',     'Intermedio',   'https://www.youtube.com/watch?v=VF8GrJdysv0'),

-- ============================================================
-- BARRIDOS
-- ============================================================

('Barrido tijera',                  'BJJ', 'Barridos', 'Guardia cerrada',     'Principiante', 'https://www.youtube.com/watch?v=63LRiI9Qn2o'),
('Barrido cadera (hip bump)',        'BJJ', 'Barridos', 'Guardia cerrada',     'Principiante', 'https://www.youtube.com/watch?v=_A44vDVPVQk'),
('Barrido péndulo (flower sweep)',  'BJJ', 'Barridos', 'Guardia cerrada',     'Principiante', 'https://www.youtube.com/watch?v=d4mtrEbTl7w'),
('Barrido mariposa',                'BJJ', 'Barridos', 'Guardia mariposa',    'Intermedio',   'https://www.youtube.com/watch?v=Fp_QovEcig4'),
('Barrido X-guard',                 'BJJ', 'Barridos', 'Guardia X',          'Avanzado',     'https://www.youtube.com/watch?v=c7nh6tg1Ey4'),
('Barrido sickle (media guardia)',  'BJJ', 'Barridos', 'Media guardia',       'Intermedio',   'https://www.youtube.com/watch?v=Ei1qkyNXS5U'),
('Barrido de la Riva',              'BJJ', 'Barridos', 'Guardia de la Riva', 'Intermedio',   'https://www.youtube.com/watch?v=J8QJ3tOEBsY'),
('Barrido omoplata',                'BJJ', 'Barridos', 'Guardia cerrada',     'Intermedio',   'https://www.youtube.com/watch?v=fWjYQn3Xtfg'),
('Homer Simpson sweep',             'BJJ', 'Barridos', 'Media guardia',       'Avanzado',     'https://www.youtube.com/watch?v=Ei1qkyNXS5U'),

-- ============================================================
-- PASAJES DE GUARDIA
-- ============================================================

('Toreando',                        'BJJ', 'Pasajes',  'Standing / Guard',    'Principiante', 'https://www.youtube.com/watch?v=j92GL1F3Nbs'),
('Rodilla en el centro (knee cut)', 'BJJ', 'Pasajes',  'Half guard top',      'Principiante', 'https://www.youtube.com/watch?v=lOPh9K5kOcE'),
('Over-under pass',                 'BJJ', 'Pasajes',  'Guard top',           'Intermedio',   'https://www.youtube.com/watch?v=10ZtvacfW6E'),
('Leg drag',                        'BJJ', 'Pasajes',  'Guard top',           'Intermedio',   'https://www.youtube.com/watch?v=1l5WTjjtrF4'),
('Stack pass (pila)',                'BJJ', 'Pasajes',  'Closed guard top',    'Principiante', 'https://www.youtube.com/watch?v=oyK_nzc_SSU'),
('Smash pass (media guardia)',      'BJJ', 'Pasajes',  'Half guard top',      'Intermedio',   'https://www.youtube.com/watch?v=p9iBzTpXGD4'),
('Body lock pass',                  'BJJ', 'Pasajes',  'Guard top',           'Avanzado',     'https://www.youtube.com/watch?v=r-FNcolHsg4'),
('X-pass',                          'BJJ', 'Pasajes',  'Standing',            'Principiante', 'https://www.youtube.com/watch?v=j92GL1F3Nbs'),
('Long step pass',                  'BJJ', 'Pasajes',  'Guard top',           'Intermedio',   'https://www.youtube.com/watch?v=j92GL1F3Nbs'),
('Double under pass',               'BJJ', 'Pasajes',  'Closed guard top',    'Avanzado',     'https://www.youtube.com/watch?v=N-M9fEqPCgY'),

-- ============================================================
-- DERRIBOS / TAKEDOWNS
-- ===============================================