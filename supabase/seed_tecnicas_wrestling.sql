-- ============================================================
-- SEED: Catálogo de técnicas Lucha / Wrestling
-- Ejecutar en Supabase SQL Editor
-- ============================================================

INSERT INTO tecnicas_catalogo (nombre, disciplina, categoria, posicion_inicio, nivel, video_url) VALUES

-- ============================================================
-- DERRIBOS (Takedowns)
-- ============================================================
('Double leg takedown',             'Lucha', 'Derribos', 'De pie',            'Principiante', 'https://www.youtube.com/results?search_query=double+leg+takedown+wrestling+tutorial'),
('Single leg takedown',             'Lucha', 'Derribos', 'De pie',            'Principiante', 'https://www.youtube.com/results?search_query=single+leg+takedown+wrestling+tutorial'),
('High crotch',                     'Lucha', 'Derribos', 'De pie',            'Principiante', 'https://www.youtube.com/results?search_query=high+crotch+wrestling+tutorial'),
('Ankle pick',                      'Lucha', 'Derribos', 'De pie',            'Principiante', 'https://www.youtube.com/results?search_query=ankle+pick+wrestling+tutorial'),
('Fireman carry',                   'Lucha', 'Derribos', 'De pie',            'Intermedio',   'https://www.youtube.com/results?search_query=fireman+carry+wrestling+tutorial'),
('Duck under',                      'Lucha', 'Derribos', 'De pie',            'Intermedio',   'https://www.youtube.com/results?search_query=duck+under+wrestling+tutorial'),
('Arm drag a derribo',              'Lucha', 'Derribos', 'De pie',            'Intermedio',   'https://www.youtube.com/results?search_query=arm+drag+wrestling+takedown+tutorial'),
('Penetration step (entry)',        'Lucha', 'Derribos', 'De pie',            'Principiante', 'https://www.youtube.com/results?search_query=penetration+step+wrestling+tutorial'),
('Level change',                    'Lucha', 'Derribos', 'De pie',            'Principiante', 'https://www.youtube.com/results?search_query=level+change+wrestling+tutorial'),
('Snap down a front headlock',      'Lucha', 'Derribos', 'De pie',            'Intermedio',   'https://www.youtube.com/results?search_query=snap+down+front+headlock+wrestling'),
('Knee tap',                        'Lucha', 'Derribos', 'De pie',            'Intermedio',   'https://www.youtube.com/results?search_query=knee+tap+wrestling+tutorial'),
('Low single',                      'Lucha', 'Derribos', 'De pie',            'Avanzado',     'https://www.youtube.com/results?search_query=low+single+leg+wrestling+tutorial'),
('High single',                     'Lucha', 'Derribos', 'De pie',            'Avanzado',     'https://www.youtube.com/results?search_query=high+single+wrestling+tutorial'),
('Bodylock takedown',               'Lucha', 'Derribos', 'De pie',            'Intermedio',   'https://www.youtube.com/results?search_query=bodylock+takedown+wrestling+tutorial'),

-- ============================================================
-- PROYECCIONES (Throws)
-- ============================================================
('Suplex trasero',                  'Lucha', 'Proyecciones', 'De pie / Clinch', 'Intermedio', 'https://www.youtube.com/results?search_query=suplex+trasero+lucha+wrestling+tutorial'),
('Suplex lateral',                  'Lucha', 'Proyecciones', 'De pie / Clinch', 'Intermedio', 'https://www.youtube.com/results?search_query=lateral+suplex+wrestling+tutorial'),
('Suplex alemán',                   'Lucha', 'Proyecciones', 'De pie / Clinch', 'Avanzado',   'https://www.youtube.com/results?search_query=german+suplex+wrestling+tutorial'),
('Hip toss',                        'Lucha', 'Proyecciones', 'De pie',          'Principiante','https://www.youtube.com/results?search_query=hip+toss+wrestling+tutorial'),
('Arm throw (ippon seoi nage)',     'Lucha', 'Proyecciones', 'De pie',          'Intermedio',  'https://www.youtube.com/results?search_query=arm+throw+wrestling+tutorial'),
('Headlock throw',                  'Lucha', 'Proyecciones', 'Clinch / De pie', 'Principiante','https://www.youtube.com/results?search_query=headlock+throw+wrestling+tutorial'),
('Bear hug (arce lock throw)',      'Lucha', 'Proyecciones', 'Clinch',          'Intermedio',  'https://www.youtube.com/results?search_query=bear+hug+wrestling+throw+tutorial'),

-- ============================================================
-- CONTROL EN SUELO (Par terre / Ground)
-- ============================================================
('Referee position (posición árbitro)', 'Lucha', 'Control suelo', 'Par terre',  'Principiante', 'https://www.youtube.com/results?search_query=referee+position+wrestling+tutorial'),
('Turk (control de cadera)',        'Lucha', 'Control suelo', 'Par terre',       'Principiante', 'https://www.youtube.com/results?search_query=turk+wrestling+par+terre+tutorial'),
('Gut wrench',                      'Lucha', 'Control suelo', 'Par terre arriba','Principiante', 'https://www.youtube.com/results?search_query=gut+wrench+wrestling+tutorial'),
('Leg lace / Laso de pierna',       'Lucha', 'Control suelo', 'Par terre arriba','Intermedio',   'https://www.youtube.com/results?search_query=leg+lace+wrestling+tutorial'),
('Tilt (inclinación)',              'Lucha', 'Control suelo', 'Par terre arriba','Intermedio',   'https://www.youtube.com/results?search_query=tilt+wrestling+par+terre+tutorial'),
('Cross face',                      'Lucha', 'Control suelo', 'Par terre arriba','Principiante', 'https://www.youtube.com/results?search_query=cross+face+wrestling+tutorial'),

-- ============================================================
-- INMOVILIZACIONES / PINS
-- ============================================================
('Cradle (cuna)',                   'Lucha', 'Inmovilizaciones', 'Suelo',       'Principiante', 'https://www.youtube.com/results?search_query=cradle+wrestling+tutorial'),
('Half nelson pin',                 'Lucha', 'Inmovilizaciones', 'Suelo',       'Principiante', 'https://www.youtube.com/results?search_query=half+nelson+pin+wrestling+tutorial'),
('Full nelson',                     'Lucha', 'Inmovilizaciones', 'Par terre arriba','Intermedio','https://www.youtube.com/results?search_query=full+nelson+wrestling+tutorial'),
('Banana split',                    'Lucha', 'Inmovilizaciones', 'Suelo',       'Avanzado',     'https://www.youtube.com/results?search_query=banana+split+wrestling+tutorial'),
('Chest to chest pin',              'Lucha', 'Inmovilizaciones', 'Suelo',       'Principiante', 'https://www.youtube.com/results?search_query=chest+to+chest+pin+wrestling+tutorial'),

-- ============================================================
-- ESCAPES (Desde abajo)
-- ============================================================
('Stand up in base',                'Lucha', 'Escapes', 'Par terre abajo',     'Principiante', 'https://www.youtube.com/results?search_query=stand+up+in+base+wrestling+tutorial'),
('Switch',                          'Lucha', 'Escapes', 'Par terre abajo',     'Principiante', 'https://www.youtube.com/results?search_query=switch+wrestling+escape+tutorial'),
('Roll through',                    'Lucha', 'Escapes', 'Par terre abajo',     'Intermedio',   'https://www.youtube.com/results?search_query=roll+through+wrestling+escape+tutorial'),
('Granby roll',                     'Lucha', 'Escapes', 'Par terre abajo',     'Avanzado',     'https://www.youtube.com/results?search_query=granby+roll+wrestling+tutorial'),
('Sit out',                         'Lucha', 'Escapes', 'Par terre abajo',     'Principiante', 'https://www.youtube.com/results?search_query=sit+out+wrestling+tutorial'),
('Peterson roll',                   'Lucha', 'Escapes', 'Par terre abajo',     'Intermedio',   'https://www.youtube.com/results?search_query=peterson+roll+wrestling+tutorial'),

-- ============================================================
-- CLINCH / TRABAJO DE PIE
-- ============================================================
('Over-under clinch',               'Lucha', 'Clinch', 'De pie',              'Principiante', 'https://www.youtube.com/results?search_query=over+under+clinch+wrestling+tutorial'),
('Collar tie',                      'Lucha', 'Clinch', 'De pie',              'Principiante', 'https://www.youtube.com/results?search_query=collar+tie+wrestling+tutorial'),
('Underhook control',               'Lucha', 'Clinch', 'De pie',              'Principiante', 'https://www.youtube.com/results?search_query=underhook+wrestling+tutorial'),
('Two-on-one (Russian tie)',        'Lucha', 'Clinch', 'De pie',              'Intermedio',   'https://www.youtube.com/results?search_query=russian+tie+two+on+one+wrestling+tutorial'),
('Front headlock control',          'Lucha', 'Clinch', 'De pie',              'Intermedio',   'https://www.youtube.com/results?search_query=front+headlock+wrestling+control+tutorial'),
('Wrist control',                   'Lucha', 'Clinch', 'De pie',              'Principiante', 'https://www.youtube.com/results?search_query=wrist+control+wrestling+tutorial');
