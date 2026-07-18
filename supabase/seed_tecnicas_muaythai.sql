-- ============================================================
-- SEED: Catálogo de técnicas Muay Thai
-- Ejecutar en Supabase SQL Editor
-- ============================================================

INSERT INTO tecnicas_catalogo (nombre, disciplina, categoria, posicion_inicio, nivel, video_url) VALUES

-- ============================================================
-- PUÑETAZOS
-- ============================================================
('Jab',                             'Muay Thai', 'Puñetazos', 'Guardia',       'Principiante', 'https://www.youtube.com/results?search_query=jab+muay+thai+tutorial'),
('Cross',                           'Muay Thai', 'Puñetazos', 'Guardia',       'Principiante', 'https://www.youtube.com/results?search_query=cross+muay+thai+tutorial'),
('Hook (gancho)',                   'Muay Thai', 'Puñetazos', 'Guardia',       'Principiante', 'https://www.youtube.com/results?search_query=hook+muay+thai+tutorial'),
('Uppercut',                        'Muay Thai', 'Puñetazos', 'Guardia',       'Principiante', 'https://www.youtube.com/results?search_query=uppercut+muay+thai+tutorial'),
('Superman punch',                  'Muay Thai', 'Puñetazos', 'Guardia',       'Avanzado',     'https://www.youtube.com/results?search_query=superman+punch+muay+thai+tutorial'),

-- ============================================================
-- PATADAS
-- ============================================================
('Teep (patada frontal)',           'Muay Thai', 'Patadas', 'Guardia',         'Principiante', 'https://www.youtube.com/results?search_query=teep+patada+frontal+muay+thai+tutorial'),
('Roundhouse kick (patada circular)','Muay Thai','Patadas', 'Guardia',         'Principiante', 'https://www.youtube.com/results?search_query=roundhouse+kick+muay+thai+tutorial'),
('Patada baja (low kick)',          'Muay Thai', 'Patadas', 'Guardia',         'Principiante', 'https://www.youtube.com/results?search_query=low+kick+muay+thai+tutorial'),
('Patada media (mid kick)',         'Muay Thai', 'Patadas', 'Guardia',         'Principiante', 'https://www.youtube.com/results?search_query=mid+kick+muay+thai+tutorial'),
('Patada alta (head kick)',         'Muay Thai', 'Patadas', 'Guardia',         'Intermedio',   'https://www.youtube.com/results?search_query=head+kick+muay+thai+tutorial'),
('Patada trasera (back kick)',      'Muay Thai', 'Patadas', 'Guardia',         'Intermedio',   'https://www.youtube.com/results?search_query=back+kick+muay+thai+tutorial'),
('Patada lateral (side kick)',      'Muay Thai', 'Patadas', 'Guardia',         'Intermedio',   'https://www.youtube.com/results?search_query=side+kick+muay+thai+tutorial'),
('Patada giratoria (spinning back kick)','Muay Thai','Patadas','Guardia',      'Avanzado',     'https://www.youtube.com/results?search_query=spinning+back+kick+muay+thai+tutorial'),
('Patada de tijera (scissors kick)','Muay Thai', 'Patadas', 'Guardia',        'Avanzado',     'https://www.youtube.com/results?search_query=scissors+kick+muay+thai+tutorial'),

-- ============================================================
-- CODOS
-- ============================================================
('Codo horizontal',                 'Muay Thai', 'Codos', 'Clinch / Guardia', 'Principiante', 'https://www.youtube.com/results?search_query=codo+horizontal+muay+thai+tutorial'),
('Codo diagonal (cortante)',        'Muay Thai', 'Codos', 'Clinch / Guardia', 'Principiante', 'https://www.youtube.com/results?search_query=codo+diagonal+muay+thai+tutorial'),
('Codo de arriba a abajo',         'Muay Thai', 'Codos', 'Clinch',            'Intermedio',   'https://www.youtube.com/results?search_query=downward+elbow+muay+thai+tutorial'),
('Codo hacia atrás (reverse elbow)','Muay Thai', 'Codos', 'Clinch',           'Intermedio',   'https://www.youtube.com/results?search_query=reverse+elbow+muay+thai+tutorial'),
('Codo giratorio (spinning elbow)', 'Muay Thai', 'Codos', 'Guardia',          'Avanzado',     'https://www.youtube.com/results?search_query=spinning+elbow+muay+thai+tutorial'),
('Codo doble (double elbow)',       'Muay Thai', 'Codos', 'Clinch',            'Avanzado',     'https://www.youtube.com/results?search_query=double+elbow+muay+thai+tutorial'),

-- ============================================================
-- RODILLAS
-- ============================================================
('Rodilla frontal',                 'Muay Thai', 'Rodillas', 'Clinch',         'Principiante', 'https://www.youtube.com/results?search_query=rodilla+frontal+muay+thai+tutorial'),
('Rodilla lateral',                 'Muay Thai', 'Rodillas', 'Clinch',         'Principiante', 'https://www.youtube.com/results?search_query=rodilla+lateral+muay+thai+tutorial'),
('Rodilla voladora (flying knee)',  'Muay Thai', 'Rodillas', 'De pie',         'Avanzado',     'https://www.youtube.com/results?search_query=flying+knee+muay+thai+tutorial'),
('Rodilla diagonal',                'Muay Thai', 'Rodillas', 'Clinch',         'Intermedio',   'https://www.youtube.com/results?search_query=diagonal+knee+muay+thai+tutorial'),
('Rodilla al cuerpo',               'Muay Thai', 'Rodillas', 'Clinch',         'Principiante', 'https://www.youtube.com/results?search_query=knee+to+body+muay+thai+tutorial'),

-- ============================================================
-- CLINCH (Plum / Trabado)
-- ============================================================
('Control de cuello doble (plum)', 'Muay Thai', 'Clinch', 'Clinch',           'Principiante', 'https://www.youtube.com/results?search_query=plum+clinch+muay+thai+tutorial'),
('Control de cuello simple',       'Muay Thai', 'Clinch', 'Clinch',           'Principiante', 'https://www.youtube.com/results?search_query=single+collar+clinch+muay+thai+tutorial'),
('Entrada al clinch',              'Muay Thai', 'Clinch', 'Guardia',           'Principiante', 'https://www.youtube.com/results?search_query=clinch+entry+muay+thai+tutorial'),
('Salida del clinch',              'Muay Thai', 'Clinch', 'Clinch',            'Principiante', 'https://www.youtube.com/results?search_query=clinch+exit+muay+thai+tutorial'),
('Derribo desde clinch (sweep)',   'Muay Thai', 'Clinch', 'Clinch',            'Intermedio',   'https://www.youtube.com/results?search_query=clinch+sweep+muay+thai+tutorial'),
('Proyección desde clinch (throw)','Muay Thai', 'Clinch', 'Clinch',            'Avanzado',     'https://www.youtube.com/results?search_query=clinch+throw+muay+thai+tutorial'),

-- ============================================================
-- DEFENSA
-- ============================================================
('Teep defensivo',                  'Muay Thai', 'Defensa', 'Guardia',         'Principiante', 'https://www.youtube.com/results?search_query=defensive+teep+muay+thai+tutorial'),
('Bloqueo de patada baja',         'Muay Thai', 'Defensa', 'Guardia',         'Principiante', 'https://www.youtube.com/results?search_query=low+kick+check+muay+thai+tutorial'),
('Check (parada de patada)',       'Muay Thai', 'Defensa', 'Guardia',         'Principiante', 'https://www.youtube.com/results?search_query=kick+check+muay+thai+tutorial'),
('Bloqueo de codo',                'Muay Thai', 'Defensa', 'Guardia',         'Intermedio',   'https://www.youtube.com/results?search_query=elbow+block+muay+thai+tutorial'),
('Esquive lateral',                'Muay Thai', 'Defensa', 'Guardia',         'Intermedio',   'https://www.youtube.com/results?search_query=lateral+slip+muay+thai+tutorial'),
('Clinch defensivo',               'Muay Thai', 'Defensa', 'Guardia',         'Intermedio',   'https://www.youtube.com/results?search_query=defensive+clinch+muay+thai+tutorial');
