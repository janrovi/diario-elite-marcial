-- ============================================================
-- SEED: Catálogo de técnicas Boxeo
-- Ejecutar en Supabase SQL Editor
-- ============================================================

INSERT INTO tecnicas_catalogo (nombre, disciplina, categoria, posicion_inicio, nivel, video_url) VALUES

-- ============================================================
-- GOLPES BÁSICOS
-- ============================================================
('Jab',                             'Boxeo', 'Golpes', 'Guardia',            'Principiante', 'https://www.youtube.com/results?search_query=jab+boxeo+tutorial+tecnica'),
('Cross (directo de derecha)',      'Boxeo', 'Golpes', 'Guardia',            'Principiante', 'https://www.youtube.com/results?search_query=cross+directo+derecha+boxeo+tutorial'),
('Hook (gancho)',                   'Boxeo', 'Golpes', 'Guardia',            'Principiante', 'https://www.youtube.com/results?search_query=gancho+hook+boxeo+tutorial'),
('Uppercut (golpe de abajo)',       'Boxeo', 'Golpes', 'Guardia',            'Principiante', 'https://www.youtube.com/results?search_query=uppercut+boxeo+tutorial'),
('Jab al cuerpo',                  'Boxeo', 'Golpes', 'Guardia',            'Principiante', 'https://www.youtube.com/results?search_query=jab+al+cuerpo+boxeo+tutorial'),
('Cross al cuerpo',                'Boxeo', 'Golpes', 'Guardia',            'Principiante', 'https://www.youtube.com/results?search_query=cross+al+cuerpo+boxeo+tutorial'),
('Hook al cuerpo',                 'Boxeo', 'Golpes', 'Guardia',            'Intermedio',   'https://www.youtube.com/results?search_query=hook+al+cuerpo+boxeo+tutorial'),
('Uppercut al cuerpo',             'Boxeo', 'Golpes', 'Guardia',            'Intermedio',   'https://www.youtube.com/results?search_query=uppercut+al+cuerpo+boxeo+tutorial'),
('Overhand (golpe por encima)',     'Boxeo', 'Golpes', 'Guardia',            'Intermedio',   'https://www.youtube.com/results?search_query=overhand+boxeo+tutorial'),
('Shovel hook',                    'Boxeo', 'Golpes', 'Guardia',            'Avanzado',     'https://www.youtube.com/results?search_query=shovel+hook+boxing+tutorial'),

-- ============================================================
-- COMBINACIONES
-- ============================================================
('Combinación 1-2 (jab-cross)',    'Boxeo', 'Combinaciones', 'Guardia',      'Principiante', 'https://www.youtube.com/results?search_query=combinacion+1-2+jab+cross+boxeo'),
('Combinación 1-2-3 (jab-cross-hook)', 'Boxeo', 'Combinaciones', 'Guardia', 'Principiante', 'https://www.youtube.com/results?search_query=combinacion+1-2-3+boxeo+tutorial'),
('Combinación 1-1-2',              'Boxeo', 'Combinaciones', 'Guardia',      'Principiante', 'https://www.youtube.com/results?search_query=combinacion+1-1-2+boxeo+tutorial'),
('Jab-cross-hook al cuerpo-hook',  'Boxeo', 'Combinaciones', 'Guardia',      'Intermedio',   'https://www.youtube.com/results?search_query=jab+cross+hook+cuerpo+head+boxing'),
('Jab-uppercut-cross',             'Boxeo', 'Combinaciones', 'Guardia',      'Intermedio',   'https://www.youtube.com/results?search_query=jab+uppercut+cross+boxing+combination'),
('Combinación cuerpo-cabeza',      'Boxeo', 'Combinaciones', 'Guardia',      'Intermedio',   'https://www.youtube.com/results?search_query=body+head+combination+boxing+tutorial'),
('Combinación 4 golpes',           'Boxeo', 'Combinaciones', 'Guardia',      'Avanzado',     'https://www.youtube.com/results?search_query=4+punch+combination+boxing+tutorial'),

-- ============================================================
-- DEFENSA
-- ============================================================
('Slip (esquive lateral)',         'Boxeo', 'Defensa', 'Guardia',            'Principiante', 'https://www.youtube.com/results?search_query=slip+boxeo+esquive+tutorial'),
('Bob and weave (esquive bajo)',   'Boxeo', 'Defensa', 'Guardia',            'Principiante', 'https://www.youtube.com/results?search_query=bob+and+weave+boxeo+tutorial'),
('Parry (desvío)',                 'Boxeo', 'Defensa', 'Guardia',            'Principiante', 'https://www.youtube.com/results?search_query=parry+boxeo+desvio+tutorial'),
('Cover up (cobertura)',           'Boxeo', 'Defensa', 'Guardia',            'Principiante', 'https://www.youtube.com/results?search_query=cover+up+boxing+defense+tutorial'),
('Roll (rollo defensivo)',         'Boxeo', 'Defensa', 'Guardia',            'Intermedio',   'https://www.youtube.com/results?search_query=roll+boxing+defensive+tutorial'),
('Pull back (paso atrás)',         'Boxeo', 'Defensa', 'Guardia',            'Principiante', 'https://www.youtube.com/results?search_query=pull+back+boxing+defense+tutorial'),
('Clinch defensivo',              'Boxeo', 'Defensa', 'Guardia',            'Intermedio',   'https://www.youtube.com/results?search_query=clinch+defensivo+boxeo+tutorial'),
('Shoulder roll',                  'Boxeo', 'Defensa', 'Guardia',            'Avanzado',     'https://www.youtube.com/results?search_query=shoulder+roll+boxing+tutorial'),

-- ============================================================
-- FOOTWORK (Trabajo de pies)
-- ============================================================
('Paso adelante / atrás',          'Boxeo', 'Footwork', 'Guardia',           'Principiante', 'https://www.youtube.com/results?search_query=footwork+paso+adelante+atras+boxeo'),
('Paso lateral',                   'Boxeo', 'Footwork', 'Guardia',           'Principiante', 'https://www.youtube.com/results?search_query=lateral+step+boxing+footwork+tutorial'),
('Pivot (pivote)',                  'Boxeo', 'Footwork', 'Guardia',           'Intermedio',   'https://www.youtube.com/results?search_query=pivot+boxeo+footwork+tutorial'),
('Cut off (cortar el ring)',       'Boxeo', 'Footwork', 'Guardia',           'Intermedio',   'https://www.youtube.com/results?search_query=cut+off+ring+boxing+footwork'),
('In and out (entrada y salida)',  'Boxeo', 'Footwork', 'Guardia',           'Intermedio',   'https://www.youtube.com/results?search_query=in+and+out+boxing+footwork+tutorial'),
('Circular footwork',              'Boxeo', 'Footwork', 'Guardia',           'Avanzado',     'https://www.youtube.com/results?search_query=circular+footwork+boxing+tutorial'),

-- ============================================================
-- GUARDIA Y POSTURA
-- ============================================================
('Guardia ortodoxa',               'Boxeo', 'Guardia', 'De pie',             'Principiante', 'https://www.youtube.com/results?search_query=guardia+ortodoxa+boxeo+tutorial'),
('Guardia zurda (southpaw)',       'Boxeo', 'Guardia', 'De pie',             'Principiante', 'https://www.youtube.com/results?search_query=guardia+zurda+southpaw+boxeo+tutorial'),
('Guardia alta',                   'Boxeo', 'Guardia', 'De pie',             'Principiante', 'https://www.youtube.com/results?search_query=guardia+alta+boxeo+tutorial'),
('Peek-a-boo',                     'Boxeo', 'Guardia', 'De pie',             'Avanzado',     'https://www.youtube.com/results?search_query=peek+a+boo+boxing+style+tutorial'),

-- ============================================================
-- TRABAJO EN CLENCH
-- ============================================================
('Control de cabeza en clinch',    'Boxeo', 'Clinch', 'Clinch',              'Intermedio',   'https://www.youtube.com/results?search_query=head+control+clinch+boxing+tutorial'),
('Golpe corto en clinch',         'Boxeo', 'Clinch', 'Clinch',              'Intermedio',   'https://www.youtube.com/results?search_query=short+punch+clinch+boxing+tutorial'),
('Salida del clinch',             'Boxeo', 'Clinch', 'Clinch',              'Intermedio',   'https://www.youtube.com/results?search_query=break+from+clinch+boxing+tutorial');
