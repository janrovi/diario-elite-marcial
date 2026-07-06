with open("src/App.jsx", "r", encoding="utf-8") as f:
    src = f.read()

# ── 1. Remove flex from outer wrapper ──
old1 = '{equipoTab === "atletas" && <div className="em-coach-layout" style={{ display: "flex", gap: 20, alignItems: "flex-start", flexWrap: "wrap" }}>'
new1 = '{equipoTab === "atletas" && <div className="em-coach-layout">'
assert old1 in src, "FAIL 1"
src = src.replace(old1, new1, 1)

# ── 2. Left panel: wrap in !selectedAthlete conditional + make full width ──
old2 = '              {/* ══ Panel izquierdo: equipo ══ */}\n              {(() => {\n                const nivelesCount = { profesional: 0, amateur: 0, fitness: 0 };\n                activeAthletes.forEach(a => {\n                  const n = athleteNiveles[a.atleta_id] || "fitness";\n                  nivelesCount[n] = (nivelesCount[n] || 0) + 1;\n                });\n                const DAYS = ["L","M","X","J","V","S","D"];\n                return (\n              <div className={`em-coach-sidebar${selectedAthlete ? " em-coach-sidebar--collapsed" : ""}`} style={{ flex: "0 0 440px", minWidth: 320, background: "var(--bg-card)", border: "1px solid var(--border)", borderRadius: 20, overflow: "hidden" }}>'
new2 = '              {/* ══ Panel equipo (full width, oculto cuando hay atleta seleccionado) ══ */}\n              {!selectedAthlete && (() => {\n                const nivelesCount = { profesional: 0, amateur: 0, fitness: 0 };\n                activeAthletes.forEach(a => {\n                  const n = athleteNiveles[a.atleta_id] || "fitness";\n                  nivelesCount[n] = (nivelesCount[n] || 0) + 1;\n                });\n                const DAYS = ["L","M","X","J","V","S","D"];\n                return (\n              <div className="em-coach-sidebar" style={{ width: "100%", background: "var(--bg-card)", border: "1px solid var(--border)", borderRadius: 20, overflow: "hidden" }}>'
assert old2 in src, "FAIL 2"
src = src.replace(old2, new2, 1)

# ── 3. Make athlete list scroll area taller ──
old3 = '<div style={{ overflowY:"auto", maxHeight:"calc(100vh - 430px)", padding:"14px" }}>'
new3 = '<div style={{ overflowY:"auto", maxHeight:"calc(100vh - 260px)", padding:"14px" }}>'
assert old3 in src, "FAIL 3"
src = src.replace(old3, new3, 1)

# ── 4. Wrap athlete cards in a 2-column grid ──
old4 = '                        {/* Cards de atletas del grupo */}\n                        {grupo.length === 0 && (\n                          <div style={{ fontSize:11, color:"var(--text-faint)", padding:"8px 12px", background:"var(--bg-input)", borderRadius:10, textAlign:"center", fontStyle:"italic" }}>\n                            Ningún atleta en esta categoría\n                          </div>\n                        )}\n                        {grupo.map(a => {'
new4 = '                        {/* Cards de atletas del grupo */}\n                        {grupo.length === 0 && (\n                          <div style={{ fontSize:11, color:"var(--text-faint)", padding:"8px 12px", background:"var(--bg-input)", borderRadius:10, textAlign:"center", fontStyle:"italic" }}>\n                            Ningún atleta en esta categoría\n                          </div>\n                        )}\n                        <div style={{ display:"grid", gridTemplateColumns:"repeat(auto-fill,minmax(340px,1fr))", gap:8 }}>\n                        {grupo.map(a => {'
assert old4 in src, "FAIL 4"
src = src.replace(old4, new4, 1)

# ── 5. Close the grid div after grupo.map ──
old5 = '                        })}\n                      </div>\n                    );\n                  })}\n\n                </div>{/* fin scroll */}'
new5 = '                        })}</div>{/* fin grid */}\n                      </div>\n                    );\n                  })}\n\n                </div>{/* fin scroll */}'
assert old5 in src, "FAIL 5"
src = src.replace(old5, new5, 1)

# ── 6. Athlete detail: ternary → && + full width + visible back button ──
old6 = '              {/* Panel detalle atleta */}\n              {selectedAthlete ? (() => {\n                const rpeData = athleteSessions.filter(s => s.rpe).slice(0, 14).reverse();\n                const maxRpe = 10;\n                const avgRpeNum = (() => { const r = athleteSessions.filter(s=>s.rpe).map(s=>Number(s.rpe)); return r.length ? (r.reduce((a,b)=>a+b,0)/r.length) : null; })();\n                const avgRpeStr = avgRpeNum ? avgRpeNum.toFixed(1) : "—";\n                const avgRpeColor = avgRpeNum >= 8 ? "#f87171" : avgRpeNum >= 6 ? "#f6ad55" : "#4ade80";\n                return (\n                <div className="em-coach-panel em-coach-panel--fullscreen em-coach-athlete-detail" style={{ flex: 1, minWidth: 280, background: "var(--bg-card)", border: "1px solid var(--border)", borderRadius: 20, overflow: "hidden" }}>\n\n                  {/* Botón volver (solo mobile) */}\n                  <button onClick={() => setSelectedAthlete(null)}\n                    style={{ display: "none", width: "100%", padding: "12px 18px", background: "var(--bg-elevated)", border: "none", borderBottom: "1px solid var(--border)", textAlign: "left", color: RED, fontSize: 14, fontWeight: 700, cursor: "pointer" }}\n                    className="em-coach-back-btn">\n                    ← Volver al equipo\n                  </button>'
new6 = '              {/* Panel detalle atleta (full width) */}\n              {selectedAthlete && (() => {\n                const rpeData = athleteSessions.filter(s => s.rpe).slice(0, 14).reverse();\n                const maxRpe = 10;\n                const avgRpeNum = (() => { const r = athleteSessions.filter(s=>s.rpe).map(s=>Number(s.rpe)); return r.length ? (r.reduce((a,b)=>a+b,0)/r.length) : null; })();\n                const avgRpeStr = avgRpeNum ? avgRpeNum.toFixed(1) : "—";\n                const avgRpeColor = avgRpeNum >= 8 ? "#f87171" : avgRpeNum >= 6 ? "#f6ad55" : "#4ade80";\n                return (\n                <div className="em-coach-panel em-coach-panel--fullscreen em-coach-athlete-detail" style={{ width: "100%", background: "var(--bg-card)", border: "1px solid var(--border)", borderRadius: 20, overflow: "hidden" }}>\n\n                  {/* Botón volver */}\n                  <button onClick={() => setSelectedAthlete(null)}\n                    style={{ display: "flex", alignItems: "center", gap: 8, width: "100%", padding: "10px 18px", background: "var(--bg-elevated)", border: "none", borderBottom: `1px solid ${RED}30`, color: RED, fontSize: 13, fontWeight: 700, cursor: "pointer" }}\n                    className="em-coach-back-btn">\n                    ← Volver al equipo\n                  </button>'
assert old6 in src, "FAIL 6"
src = src.replace(old6, new6, 1)

# ── 7. Remove placeholder "Resumen del equipo" panel (replace ternary closing with && closing) ──
old7 = '                );\n              })() : (\n                <div className="em-coach-panel" style={{ flex: 1, minWidth: 280, background: "var(--bg-card)", border: "1px solid var(--border)", borderRadius: 20, overflow: "hidden" }}>\n                  {/* Cabecera */}\n                  <div style={{ padding: "16px 20px", borderBottom: "1px solid var(--border)", background: darkMode ? "rgba(255,255,255,0.02)" : "rgba(0,0,0,0.02)" }}>\n                    <div style={{ fontSize: 13, fontWeight: 800, color: "var(--text)" }}>📊 Resumen del equipo</div>\n                    <div style={{ fontSize: 11, color: "var(--text-faint)", marginTop: 2 }}>{t("coach_select_athlete",lang)}</div>\n                  </div>'
new7 = '                );\n              })()}\n              {false && (\n                <div className="em-coach-panel" style={{ flex: 1, minWidth: 280, background: "var(--bg-card)", border: "1px solid var(--border)", borderRadius: 20, overflow: "hidden" }}>\n                  {/* Cabecera */}\n                  <div style={{ padding: "16px 20px", borderBottom: "1px solid var(--border)", background: darkMode ? "rgba(255,255,255,0.02)" : "rgba(0,0,0,0.02)" }}>\n                    <div style={{ fontSize: 13, fontWeight: 800, color: "var(--text)" }}>📊 Resumen del equipo</div>\n                    <div style={{ fontSize: 11, color: "var(--text-faint)", marginTop: 2 }}>{t("coach_select_athlete",lang)}</div>\n                  </div>'
assert old7 in src, "FAIL 7"
src = src.replace(old7, new7, 1)

with open("src/App.jsx", "w", encoding="utf-8") as f:
    f.write(src)

print("ALL 7 PATCHES APPLIED OK")
