# Carga de Entrenamiento

**Fuente:** ENFAF — Experto Universitario en Preparación Física para MMA y Deportes de Combate, Asignatura 1 · Módulo 4 · Clase 3 (`MODULO4FuerzaClase3CargadeEntrenamiento1.pdf`).

## 1. ¿Qué es la carga?

- **Carga externa**: el estímulo objetivo aplicado (kg, repeticiones, distancia, velocidad, tiempo).
- **Carga interna**: la respuesta biológica individual a ese estímulo (frecuencia cardíaca, percepción de esfuerzo, lactato, etc.).
- Componentes clave: **volumen** (cantidad total de trabajo), **densidad** (relación trabajo:descanso) e **intensidad** (nivel de esfuerzo relativo).
- **RPE (Rate of Perceived Exertion)**: escala subjetiva de esfuerzo percibido, herramienta central para cuantificar carga interna sin necesidad de tecnología cara.

## 2. La carga en MMA

- El MMA exige un perfil bioenergético mixto (aeróbico + anaeróbico), lo que complica cuantificar la carga con una sola métrica.
- **Escala RPE 0–10** (Foster et al., 2001): usada tras la sesión para estimar el esfuerzo global.
- **Método sRPE (session-RPE)** de Foster et al. (2001): Carga de la sesión = RPE × duración de la sesión (minutos). Es el método más extendido y validado en deportes de combate por su bajo coste y buena correlación con marcadores fisiológicos.
- **PlayerLoad**: métrica derivada de acelerómetros/IMU que cuantifica la carga externa mediante los cambios de aceleración en los tres ejes.
  - Investigación de referencia: tesis doctoral de **Kirk (2014)** y artículo de **Kirk et al. (2023)**, que aplican PlayerLoad al análisis de carga en combate y entrenamiento de MMA.

## 3. Bases biológicas

- **Ciclo de supercompensación**: tras un estímulo de carga, el organismo atraviesa fatiga → recuperación → supercompensación (mejora por encima del nivel basal) → pérdida del efecto si no hay nuevo estímulo. La planificación busca aplicar la siguiente carga en la fase de supercompensación.
- **Ley de Schultz-Arnodt (umbral mínimo de carga)**: para generar una adaptación, el estímulo debe superar un umbral mínimo; por debajo de ese umbral no hay adaptación, y por encima de cierto límite el estímulo pasa a ser lesivo o de sobreentrenamiento.

## 4. Carga según tipo de luchador

Tabla conceptual (frecuencia, volumen e intensidad varían según nivel y fase):

| Nivel / Fase | Pre-Training Camp | Training Camp | Fight Week | Día de combate |
|---|---|---|---|---|
| **Novel (principiante)** | Frecuencia y volumen bajos-moderados, intensidad baja-moderada, foco técnico | Incremento progresivo y controlado | Reducción marcada de volumen, mantener intensidad técnica | Activación ligera, sin fatiga residual |
| **Amateur** | Frecuencia y volumen moderados-altos | Pico de volumen e intensidad específica de combate | Tapering (reducción de volumen, mantenimiento de intensidad) | Activación neuromuscular breve |
| **Profesional** | Volumen alto, alta variabilidad de estímulos | Máxima especificidad, alta intensidad controlada | Tapering más pronunciado y personalizado | Protocolo de activación individualizado |

*(Nota: la tabla original del curso detalla estos cruces con valores cualitativos específicos por casilla; aquí se resume el patrón general.)*

## 5. Cargas incompatibles

Concepto de **interferencia**: combinar ciertos tipos de carga en la misma sesión o microciclo puede reducir la adaptación de una o ambas cualidades. El curso presenta una tabla de 6 combinaciones típicas, clasificadas como:

- **Incompatible** (alta interferencia, evitar combinar en la misma sesión/día).
- **Compatible** (se pueden combinar sin pérdida relevante de adaptación).
- **Riesgo de interferencia** (combinación posible pero requiere control de orden, volumen e intensidad).

Ejemplo de patrón general: fuerza máxima + resistencia aeróbica de larga duración en la misma sesión = alto riesgo de interferencia; fuerza máxima + trabajo técnico de baja intensidad = compatible.

## 6. Carga en otros deportes de combate (datos comparativos)

**Lactato post-combate/sesión (mmol/L), de mayor a menor:**

| Deporte | Lactato (mmol/L) |
|---|---|
| Wrestling (lucha) | 20.0 |
| MMA (competición) | 19.7 |
| MMA (sparring) | 16.3 |
| Boxeo amateur | 13.5 |
| Judo | 12.3 |
| BJJ | 10.4 |
| Muay Thai | 9.7 |
| Taekwondo | 7.5 |

**Ratio trabajo:pausa por deporte:**

| Deporte | Ratio trabajo:pausa |
|---|---|
| BJJ | 13.00 |
| Lucha olímpica | 2.00 |
| Judo | 2.00 |
| Boxeo | 1.00 |
| MMA | 1.00 |
| Taekwondo | 0.80 |
| Muay Thai | 0.67 |
| Kickboxing | 0.50 |

Estos datos evidencian que el MMA tiene una de las demandas metabólicas más altas (lactato) entre los deportes de combate, con un ratio trabajo:pausa similar al boxeo, mientras que el BJJ se caracteriza por esfuerzos sostenidos con pausas relativamente más largas dentro de la acción de agarre.

## 7. Bibliografía

1. Foster, C. et al. (2001). A new approach to monitoring exercise training. *Journal of Strength and Conditioning Research*.
2. Kirk, C. (2014). Tesis doctoral sobre cuantificación de carga en MMA mediante PlayerLoad.
3. Kirk, C. et al. (2015). Estudios relacionados sobre carga de entrenamiento en deportes de combate.
4. Kirk, C. et al. (2023). Aplicación de PlayerLoad en el análisis de carga de entrenamiento y competición en MMA.
5. Slimani, M. et al. (2017). Revisión sobre demandas físicas y fisiológicas en deportes de combate.
6. Del Vecchio, F. B. et al. (2011). Análisis de tiempo-movimiento y perfil fisiológico en MMA.
7. (Y otras fuentes adicionales citadas en el módulo original sobre carga, supercompensación y fisiología del entrenamiento en deportes de combate — 19 referencias en total en el documento fuente.)

## Relevancia para la app

Este contenido es clave para diseñar la lógica de **planificación y periodización de cargas** dentro de la app: permite ajustar automáticamente volumen/intensidad según el nivel del deportista (novel/amateur/profesional) y la fase (pre-camp, training camp, fight week, día de combate), evitar combinaciones de carga incompatibles en el mismo microciclo, y usar el método sRPE como herramienta simple y accesible para que entrenadores registren y monitoricen la carga interna de sus atletas sin necesidad de tecnología avanzada.
