# Test de Course Navette

**Fuente:** `MODULO3Clase3TESTDECOURSENAVETTE.pdf` (curso ENFAF, Asignatura 1 · Módulo 3 · Clase 3) — ver original en `ENFAF/`.

## ¿Qué es?

Prueba de campo incremental para evaluar la resistencia cardiorrespiratoria y estimar el VO₂máx. Se corre en un tramo de 20 metros al ritmo marcado por señales acústicas que aumentan progresivamente de frecuencia. Desarrollado por el Dr. Luc Léger (Universidad de Montreal, finales de los 70; implementado formalmente en 1988).

## Cómo se realiza

1. Circuito de 20 metros entre dos líneas.
2. Al primer beep, el sujeto corre a la línea contraria.
3. Debe pisar o sobrepasar la línea antes del siguiente beep.
4. Giro técnico (pivotar sobre el eje corporal, sin giros circulares).
5. El ritmo sube 0.5 km/h cada minuto, empezando en 8.5 km/h.
6. Termina al fallar dos veces seguidas o por abandono voluntario.

## Fundamento fisiológico

Recorre progresivamente los tres sistemas energéticos: aláctico al inicio, láctico en fases medias, aeróbico como predominante en la mayor parte del test. Al final el sujeto se acerca a su VO₂máx (sube FC y lactato en sangre).

Mide: VO₂máx estimado, velocidad aeróbica máxima (VAM), capacidad de recuperación/cambios de dirección, tolerancia al esfuerzo progresivo.

## Fórmula de estimación del VO₂máx

VO₂máx (ml/kg/min) = 5,857 × Velocidad final (km/h) − 19,458

Ejemplo: velocidad final 14,5 km/h → VO₂máx ≈ 65,97 ml/kg/min.

### Baremo de etapas (Léger, 1988)

| Etapa | Velocidad (km/h) | Etapa | Velocidad (km/h) |
|---|---|---|---|
| 1 | 8,5 | 11 | 13,5 |
| 2 | 9 | 12 | 14 |
| 3 | 9,5 | 13 | 14,5 |
| 4 | 10 | 14 | 15 |
| 5 | 10,5 | 15 | 15,5 |
| 6 | 11 | 16 | 16 |
| 7 | 11,5 | 17 | 16,5 |
| 8 | 12 | 18 | 17 |
| 9 | 12,5 | 19 | 17,5 |
| 10 | 13 | 20 | 18 |

### Interpretación

- **<35 ml/kg/min:** bajo rendimiento cardiorrespiratorio.
- **35–45:** promedio.
- **45–55:** bueno.
- **>55:** excelente.

La interpretación debe contextualizarse con sexo, edad, disciplina y nivel de entrenamiento.

## Aplicaciones prácticas

Evaluación física en escuelas/clubes/selecciones, medición de evolución en planes de entrenamiento, determinación de ritmos de entrenamiento por % de VO₂máx, identificación de talento con elevada capacidad aeróbica.

## Requisitos y recomendaciones

Espacio plano marcado de 20 m, reproductor de audio con la pista del test, conos/líneas, cronómetro y supervisión, calentamiento previo obligatorio. Evitar en personas con afecciones cardiovasculares sin supervisión.

## Ventajas y limitaciones

**Ventajas:** fácil de implementar, sin equipamiento caro, evaluación grupal, comparabilidad internacional, motivacional.

**Limitaciones:** influencia de la motivación, riesgo si no hay calentamiento, no apto sin autorización médica en problemas cardíacos, estimación indirecta (margen de error).

## Bibliografía citada

- Léger, L. & Lambert, J. (1982) — *A maximal multistage 20-m shuttle run test to predict VO₂max*, European Journal of Applied Physiology.
- Tabla de VO₂ y velocidades (baremo oficial Luc Léger, 1988).
- Apunts Medicina de l'Esport (2020) — Test de Course Navette: protocolo y aplicaciones.
- Entrevista a Luc Léger (2021), Revista Peruana de Ciencias de la Actividad Física y Deporte.
- Palabra de Runner (2023) — comparación con otras pruebas aeróbicas.
- Valldecabres, V. — Todo sobre el Test de Course Navette (victorvalldecabres.com).

## Relevancia para la app

Test estandarizado y de bajo coste para evaluar/monitorizar la resistencia cardiorrespiratoria de atletas dentro de la app; la fórmula y el baremo permiten calcular VO₂máx automáticamente a partir del resultado del test.
