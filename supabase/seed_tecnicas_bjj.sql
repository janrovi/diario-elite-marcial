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
('Armbar desde espalda',            'BJJ', 'Sumisiones', 'Control de espalda','Intermedio',   NULL),
('Kimura desde guardia cerrada',    'BJJ', 'Sumisiones', 'Guardia cerrada',   'Principiante', 'https://www.youtube.com/watch?v=lHhqiH37kok'),
('Kimura desde media guardia',      'BJJ', 'Sumisiones', 'Media guardia',     'Intermedio',   NULL),
('Kimura desde side control',       'BJJ', 'Sumisiones', 'Side control',      'Principiante', NULL),
('Americana desde montada',         'BJJ', 'Sumisiones', 'Montada',           'Principiante', NULL),
('Americana desde side control',    'BJJ', 'Sumisiones', 'Side control',      'Principiante', NULL),
('Omoplata',                        'BJJ', 'Sumisiones', 'Guardia cerrada',   'Intermedio',   'https://www.youtube.com/watch?v=KBpfQO8Uiz0'),
('Wristlock',                       'BJJ', 'Sumisiones', 'Varias',            'Avanzado',     NULL),

-- Estrangulaciones
('Triángulo desde guardia cerrada', 'BJJ', 'Sumisiones', 'Guardia cerrada',   'Principiante', 'https://www.youtube.com/watch?v=0f5IOQN3k3I'),
('Triángulo invertido',             'BJJ', 'Sumisiones', 'Guardia invertida', 'Avanzado',     NULL),
('Triángulo con brazo (arm-in)',    'BJJ', 'Sumisiones', 'Guardia cerrada',   'Intermedio',   NULL),
('Rear naked choke',                'BJJ', 'Sumisiones', 'Control de espalda','Principiante', 'https://www.youtube.com/watch?v=MVKH9Jddh0c'),
('Guillotina de brazo libre',       'BJJ', 'Sumisiones', 'De pie / Guard pull','Principiante','https://www.youtube.com/watch?v=eTvZBx8TMFU'),
('Guillotina con brazo (arm-in)',   'BJJ', 'Sumisiones', 'Half guard top',    'Avanzado',     NULL),
('Anaconda choke',                  'BJJ', 'Sumisiones', 'Turtle',            'Intermedio',   NULL),
('D''arce choke',                   'BJJ', 'Sumisiones', 'Half guard top',    'Intermedio',   'https://www.youtube.com/watch?v=ZFqAQTRQFcs'),
('Bow and arrow choke',             'BJJ', 'Sumisiones', 'Control de espalda','Intermedio',   NULL),
('Clock choke',                     'BJJ', 'Sumisiones', 'Turtle',            'Intermedio',   NULL),
('Ezekiel choke',                   'BJJ', 'Sumisiones', 'Montada',           'Intermedio',   NULL),
('Loop choke',                      'BJJ', 'Sumisiones', 'Guardia cerrada',   'Avanzado',     NULL),
('North-south choke',               'BJJ', 'Sumisiones', 'Norte-Sur',         'Avanzado',     NULL),
('Baseball bat choke',              'BJJ', 'Sumisiones', 'Turtle / Side ctrl','Avanzado',     NULL),

-- Piernas
('Heel hook interno (inside)',      'BJJ', 'Sumisiones', 'Ashi garami',       'Avanzado',     'https://www.youtube.com/watch?v=C3QRfCARSM4'),
('Heel hook externo (outside)',     'BJJ', 'Sumisiones', '50/50',             'Avanzado',     NULL),
('Kneebar',                         'BJJ', 'Sumisiones', 'Leg entanglement',  'Avanzado',     NULL),
('Toe hold',                        'BJJ', 'Sumisiones', 'Leg entanglement',  'Avanzado',     NULL),
('Calf slicer',                     'BJJ', 'Sumisiones', 'Media guardia top', 'Intermedio',   NULL),
('Straight ankle lock',             'BJJ', 'Sumisiones', 'Leg entanglement',  'Principiante', NULL),

-- ============================================================
-- POSICIONES
-- ============================================================

('Guardia cerrada',                 'BJJ', 'Posiciones', 'Guard',             'Principiante', NULL),
('Media guardia',                   'BJJ', 'Posiciones', 'Guard',             'Principiante', NULL),
('Guardia mariposa',                'BJJ', 'Posiciones', 'Guard',             'Principiante', 'https://www.youtube.com/watch?v=8mSRLw8VB_M'),
('Guardia de araña',                'BJJ', 'Posiciones', 'Guard',             'Intermedio',   NULL),
('Guardia de rodilla X (Z-guard)',  'BJJ', 'Posiciones', 'Guard',             'Intermedio',   NULL),
('Guardia de la Riva',              'BJJ', 'Posiciones', 'Guard',             'Intermedio',   NULL),
('Guardia X',                       'BJJ', 'Posiciones', 'Guard',             'Avanzado',     NULL),
('Guardia lasso',                   'BJJ', 'Posiciones', 'Guard',             'Avanzado',     NULL),
('Guardia invertida (reverse DLR)', 'BJJ', 'Posiciones', 'Guard',             'Avanzado',     NULL),
('50/50',                           'BJJ', 'Posiciones', 'Leg entanglement',  'Avanzado',     NULL),
('Ashi garami',                     'BJJ', 'Posiciones', 'Leg entanglement',  'Avanzado',     NULL),
('Montada baja',                    'BJJ', 'Posiciones', 'Top',               'Principiante', NULL),
('Montada alta',                    'BJJ', 'Posiciones', 'Top',               'Intermedio',   NULL),
('Side control',                    'BJJ', 'Posiciones', 'Top',               'Principiante', NULL),
('Norte-Sur',                       'BJJ', 'Posiciones', 'Top',               'Principiante', NULL),
('Rodilla en el vientre',           'BJJ', 'Posiciones', 'Top',               'Intermedio',   NULL),
('Control de espalda (hooks)',      'BJJ', 'Posiciones', 'Top',               'Principiante', NULL),
('Turtle',                          'BJJ', 'Posiciones', 'Bottom',            'Principiante', NULL),
('Headquarters',                    'BJJ', 'Posiciones', 'Top / Passing',     'Intermedio',   NULL),

-- ============================================================
-- BARRIDOS
-- ============================================================

('Barrido tijera',                  'BJJ', 'Barridos', 'Guardia cerrada',     'Principiante', NULL),
('Barrido cadera (hip bump)',        'BJJ', 'Barridos', 'Guardia cerrada',     'Principiante', NULL),
('Barrido péndulo (flower sweep)',  'BJJ', 'Barridos', 'Guardia cerrada',     'Principiante', NULL),
('Barrido mariposa',                'BJJ', 'Barridos', 'Guardia mariposa',    'Intermedio',   NULL),
('Barrido X-guard',                 'BJJ', 'Barridos', 'Guardia X',          'Avanzado',     NULL),
('Barrido sickle (media guardia)',  'BJJ', 'Barridos', 'Media guardia',       'Intermedio',   NULL),
('Barrido de la Riva',              'BJJ', 'Barridos', 'Guardia de la Riva', 'Intermedio',   NULL),
('Barrido omoplata',                'BJJ', 'Barridos', 'Guardia cerrada',     'Intermedio',   NULL),
('Homer Simpson sweep',             'BJJ', 'Barridos', 'Media guardia',       'Avanzado',     NULL),

-- ============================================================
-- PASAJES DE GUARDIA
-- ============================================================

('Toreando',                        'BJJ', 'Pasajes',  'Standing / Guard',    'Principiante', NULL),
('Rodilla en el centro (knee cut)', 'BJJ', 'Pasajes',  'Half guard top',      'Principiante', 'https://www.youtube.com/watch?v=xR_yl1VSAIE'),
('Over-under pass',                 'BJJ', 'Pasajes',  'Guard top',           'Intermedio',   NULL),
('Leg drag',                        'BJJ', 'Pasajes',  'Guard top',           'Intermedio',   NULL),
('Stack pass (pila)',                'BJJ', 'Pasajes',  'Closed guard top',    'Principiante', NULL),
('Smash pass (media guardia)',      'BJJ', 'Pasajes',  'Half guard top',      'Intermedio',   NULL),
('Body lock pass',                  'BJJ', 'Pasajes',  'Guard top',           'Avanzado',     NULL),
('X-pass',                          'BJJ', 'Pasajes',  'Standing',            'Principiante', NULL),
('Long step pass',                  'BJJ', 'Pasajes',  'Guard top',           'Intermedio',   NULL),
('Double under pass',               'BJJ', 'Pasajes',  'Closed guard top',    'Avanzado',     NULL),

-- ============================================================
-- DERRIBOS / TAKEDOWNS
-- ============================================================

('Single leg takedown',             'BJJ', 'Derribos', 'De pie',              'Principiante', NULL),
('Double leg takedown',             'BJJ', 'Derribos', 'De pie',              'Principiante', NULL),
('Osoto gari',                      'BJJ', 'Derribos', 'De pie',              'Principiante', NULL),
('Uchi mata',                       'BJJ', 'Derribos', 'De pie',              'Intermedio',   NULL),
('Ko uchi gari',                    'BJJ', 'Derribos', 'De pie',              'Principiante', NULL),
('Morote seoi nage',                'BJJ', 'Derribos', 'De pie',              'Intermedio',   NULL),
('Body lock takedown',              'BJJ', 'Derribos', 'De pie',              'Intermedio',   NULL),
('Guard pull a mariposa',           'BJJ', 'Derribos', 'De pie',              'Principiante', NULL),

-- ============================================================
-- ESCAPES
-- ============================================================

('Upa (bridge and roll) desde montada', 'BJJ', 'Escapes', 'Montada bottom',   'Principiante', NULL),
('Camarón desde side control',       'BJJ', 'Escapes', 'Side control bottom', 'Principiante', NULL),
('Elbow-knee escape desde montada',  'BJJ', 'Escapes', 'Montada bottom',      'Principiante', NULL),
('Granby roll',                      'BJJ', 'Escapes', 'Turtle / Side ctrl',  'Intermedio',   NULL),
('Escape rodilla en el vientre',     'BJJ', 'Escapes', 'KOB bottom',          'Intermedio',   NULL),
('Half guard recovery',              'BJJ', 'Escapes', 'Varias bottom',       'Principiante', NULL),
('Escape de la espalda',             'BJJ', 'Escapes', 'Back control bottom', 'Intermedio',   NULL);


-- ============================================================
-- RLS: la tabla es pública de lectura (cualquier usuario autenticado puede leerla)
-- ============================================================

ALTER TABLE tecnicas_catalogo ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lectura pública para usuarios autenticados"
  ON tecnicas_catalogo FOR SELECT
  TO authenticated
  USING (true);

-- Solo admin puede insertar/modificar (por ahora no se edita desde la app)
CREATE POLICY "Solo admin puede modificar"
  ON tecnicas_catalogo FOR ALL
  TO authenticated
  USING (auth.uid() = (SELECT id FROM profiles WHERE email = 'janrovi@gmail.com' LIMIT 1));
