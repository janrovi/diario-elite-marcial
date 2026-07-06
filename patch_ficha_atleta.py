import re

with open("src/App.jsx", "r", encoding="utf-8") as f:
    src = f.read()

# ── 1. Add athleteWellnessHistory state after athleteWellness ──
old1 = '  const [athleteWellness, setAthleteWellness] = React.useState({});'
new1 = '''  const [athleteWellness, setAthleteWellness] = React.useState({});
  const [athleteWellnessHistory, setAthleteWellnessHistory] = React.useState([]);'''
assert old1 in src, "FAIL 1: athleteWellness state not found"
src = src.replace(old1, new1, 1)

# ── 2. In selectedAthlete useEffect, add wellness history fetch after setAthleteSessions ──
old2 = '''      setAthleteSessions((data || []).map(supabaseToSession));
      setSessionsLoading(false);
    };
    fetch();
    fetchCoachNote(selectedAthlete.atleta_id);'''
new2 = '''      setAthleteSessions((data || []).map(supabaseToSession));
      setSessionsLoading(false);
      // Fetch wellness history (last 7 days)
      const sevenDaysAgo = new Date(); sevenDaysAgo.setDate(sevenDaysAgo.getDate()-6);
      const { data: wHistory } = await supabase.from("wellness_checkins")
        .select("fecha, sueno, fisico, mental")
        .eq("user_id", selectedAthlete.atleta_id)
        .gte("fecha", sevenDaysAgo.toISOString().slice(0,10))
        .order("fecha", { ascending: true });
      setAthleteWellnessHistory(wHistory || []);
    };
    fetch();
    fetchCoachNote(selectedAthlete.atleta_id);'''
assert old2 in src, "FAIL 2: selectedAthlete useEffect not found"
src = src.replace(old2, new2, 1)

# ── 3. Add fight banner at top of info panel ──
old3 = '''                  {/* ── Info view ── */}
                  {athletePanel === "info" && <div style={{ padding: "18px 22px", overflowY: "auto", maxHeight: "calc(100vh - 310px)" }}>

                    {/* Stats rápidas */}'''
new3 = '''                  {/* ── Info view ── */}
                  {athletePanel === "info" && <div style={{ padding: "18px 22px", overflowY: "auto", maxHeight: "calc(100vh - 310px)" }}>

                    {/* ── Próximo combate + fase ── */}
                    {(() => {
                      const fd = selectedAthlete.profiles?.proxima_pelea;
                      if (!fd) return null;
                      const dtf = Math.ceil((new Date(fd+"T12:00:00") - new Date()) / 86400000);
                      if (dtf < 0) return null;
                      const phases = [
                        { max:7,  label:"Fight Week", color:"#f43f5e", bg:"rgba(244,63,94,0.10)", border:"rgba(244,63,94,0.35)" },
                        { max:28, label:"Pre-Comp",   color:"#f97316", bg:"rgba(249,115,22,0.10)", border:"rgba(249,115,22,0.35)" },
                        { max:56, label:"Específica", color:"#f59e0b", bg:"rgba(245,158,11,0.10)", border:"rgba(245,158,11,0.35)" },
                        { max:84, label:"General",    color:"#3b82f6", bg:"rgba(59,130,246,0.10)", border:"rgba(59,130,246,0.35)" },
                        { max:Infinity, label:"Pre-Camp", color:"#6b7280", bg:"rgba(107,114,128,0.10)", border:"rgba(107,114,128,0.25)" },
                      ];
                      const ph = phases.find(p => dtf <= p.max);
                      return (
                        <div style={{ background:ph.bg, border:`1px solid ${ph.border}`, borderRadius:14, padding:"12px 16px", marginBottom:14, display:"flex", alignItems:"center", gap:12 }}>
                          <div style={{ fontSize:28 }}>🥊</div>
                          <div style={{ flex:1, minWidth:0 }}>
                            <div style={{ fontSize:10, fontWeight:700, color:ph.color, textTransform:"uppercase", letterSpacing:0.6 }}>{ph.label}</div>
                            <div style={{ fontSize:13, fontWeight:900, color:"var(--text)", marginTop:1 }}>
                              {dtf === 0 ? "¡Combate HOY!" : dtf === 1 ? "Combate mañana" : `${dtf} días para el combate`}
                            </div>
                            <div style={{ fontSize:10, color:"var(--text-faint)", marginTop:1 }}>{new Date(fd+"T12:00:00").toLocaleDateString("es",{weekday:"long",day:"numeric",month:"long"})}</div>
                          </div>
                          <div style={{ textAlign:"center", flexShrink:0 }}>
                            <div style={{ fontSize:32, fontWeight:900, color:ph.color, lineHeight:1 }}>{dtf}</div>
                            <div style={{ fontSize:9, color:"var(--text-faint)", textTransform:"uppercase", letterSpacing:0.4 }}>días</div>
                          </div>
                        </div>
                      );
                    })()}

                    {/* Stats rápidas */}'''
assert old3 in src, "FAIL 3: info panel start not found"
src = src.replace(old3, new3, 1)

# ── 4. After KPI stats, add HRW trend before discipline chart ──
old4 = '''                    {/* Distribución de disciplinas */}'''
new4 = '''                    {/* ── Bienestar HRW (últimos 7 días) ── */}
                    {(() => {
                      const today7 = Array.from({length:7}, (_,i) => { const d=new Date(); d.setDate(d.getDate()-(6-i)); return d.toISOString().slice(0,10); });
                      const wMap = {};
                      athleteWellnessHistory.forEach(w => { wMap[w.fecha] = w.sueno + w.fisico + w.mental; });
                      const todayHrw = athleteWellness[selectedAthlete.atleta_id];
                      if (todayHrw) wMap[today7[6]] = todayHrw.total;
                      const hasAny = today7.some(d => wMap[d] !== undefined);
                      if (!hasAny) return (
                        <div style={{ background:"var(--bg-input)", borderRadius:14, padding:"12px 14px", marginBottom:14, display:"flex", alignItems:"center", gap:10, opacity:0.65 }}>
                          <span style={{ fontSize:18 }}>🧠</span>
                          <div>
                            <div style={{ fontSize:10, fontWeight:700, color:"var(--text-faint)", textTransform:"uppercase", letterSpacing:0.8 }}>Bienestar HRW · 7 días</div>
                            <div style={{ fontSize:11, color:"var(--text-faint)", marginTop:2 }}>Sin check-ins esta semana</div>
                          </div>
                        </div>
                      );
                      return (
                        <div style={{ background:"var(--bg-input)", borderRadius:14, padding:"12px 14px", marginBottom:14 }}>
                          <div style={{ display:"flex", justifyContent:"space-between", alignItems:"center", marginBottom:10 }}>
                            <div style={{ fontSize:10, fontWeight:700, color:"var(--text-faint)", textTransform:"uppercase", letterSpacing:0.8 }}>🧠 Bienestar HRW · 7 días</div>
                            {todayHrw && (() => {
                              const tv = todayHrw.total;
                              const c = tv >= 11 ? "#4ade80" : tv >= 7 ? "#f59e0b" : "#f87171";
                              const l = tv >= 11 ? "Óptimo" : tv >= 7 ? "Moderado" : "Recuperar";
                              return <span style={{ fontSize:10, fontWeight:800, color:c, background:c+"18", borderRadius:8, padding:"2px 8px" }}>{tv}/15 · {l}</span>;
                            })()}
                          </div>
                          <div style={{ display:"flex", gap:3, alignItems:"flex-end", height:48 }}>
                            {today7.map(fecha => {
                              const val = wMap[fecha];
                              const isToday = fecha === today7[6];
                              const barH = val !== undefined ? Math.max(5, Math.round((val/15)*48)) : 3;
                              const c = val === undefined ? "var(--bg-elevated)" : val >= 11 ? "#4ade80" : val >= 7 ? "#f59e0b" : "#f87171";
                              const dayLabel = new Date(fecha+"T12:00:00").toLocaleDateString("es",{weekday:"short"}).slice(0,2);
                              return (
                                <div key={fecha} title={val !== undefined ? `${fecha}: ${val}/15` : `${fecha}: sin check-in`}
                                  style={{ flex:1, display:"flex", flexDirection:"column", alignItems:"center", gap:3 }}>
                                  <div style={{ width:"100%", height:48, display:"flex", alignItems:"flex-end" }}>
                                    <div style={{ width:"100%", height: val !== undefined ? barH : 3, borderRadius:"4px 4px 0 0",
                                      background: val !== undefined ? c : "var(--bg-elevated)",
                                      boxShadow: isToday && val !== undefined ? `0 0 8px ${c}60` : "none",
                                      opacity: val !== undefined ? 1 : 0.4 }} />
                                  </div>
                                  <span style={{ fontSize:8, color: isToday ? "var(--text-muted)" : "var(--text-faint)", fontWeight: isToday ? 800 : 400 }}>{dayLabel}</span>
                                </div>
                              );
                            })}
                          </div>
                        </div>
                      );
                    })()}

                    {/* Distribución de disciplinas */}'''
assert old4 in src, "FAIL 4: Distribución de disciplinas not found"
src = src.replace(old4, new4, 1)

# ── 5. After RPE chart, add sRPE 4-week bars before upcoming sessions ──
old5 = '''                    {/* Agenda del atleta: próximas sesiones programadas */}'''
new5 = '''                    {/* ── Carga sRPE · 4 semanas ── */}
                    {(() => {
                      const weeks = Array.from({length:4}, (_,i) => {
                        const mon = new Date(); mon.setDate(mon.getDate()-((mon.getDay()+6)%7)-((3-i)*7));
                        const sun = new Date(mon); sun.setDate(mon.getDate()+6);
                        return { mon: mon.toISOString().slice(0,10), sun: sun.toISOString().slice(0,10) };
                      });
                      const srpeByWeek = weeks.map(w => {
                        const total = athleteSessions
                          .filter(s => s.fecha >= w.mon && s.fecha <= w.sun && s.rpe && s.duracionMin)
                          .reduce((acc,s) => acc + (Number(s.rpe) * parseInt(s.duracionMin)), 0);
                        return { ...w, srpe: total };
                      });
                      const maxSrpe = Math.max(...srpeByWeek.map(w=>w.srpe), 1);
                      if (!srpeByWeek.some(w=>w.srpe > 0)) return null;
                      return (
                        <div style={{ background:"var(--bg-input)", borderRadius:14, padding:"14px", marginBottom:16 }}>
                          <div style={{ fontSize:10, fontWeight:700, color:"var(--text-faint)", textTransform:"uppercase", letterSpacing:0.8, marginBottom:10 }}>⚡ Carga sRPE · 4 semanas</div>
                          <div style={{ display:"flex", gap:6, alignItems:"flex-end", height:60 }}>
                            {srpeByWeek.map((w,i) => {
                              const barH = w.srpe > 0 ? Math.max(5, Math.round((w.srpe/maxSrpe)*60)) : 3;
                              const isThis = i === 3;
                              const c = w.srpe > 2500 ? "#f87171" : w.srpe > 1500 ? "#f59e0b" : "#4ade80";
                              return (
                                <div key={w.mon} title={`${w.mon} – ${w.sun}: sRPE ${w.srpe}`}
                                  style={{ flex:1, display:"flex", flexDirection:"column", alignItems:"center", gap:4 }}>
                                  <div style={{ fontSize:9, color: w.srpe > 2500 ? "#f87171" : "var(--text-faint)", fontWeight: isThis ? 800 : 400 }}>
                                    {w.srpe > 0 ? w.srpe.toLocaleString() : "—"}
                                  </div>
                                  <div style={{ width:"100%", height:60, display:"flex", alignItems:"flex-end" }}>
                                    <div style={{ width:"100%", height:barH, borderRadius:"5px 5px 0 0",
                                      background: w.srpe > 0 ? (isThis ? c : c+"70") : "var(--bg-elevated)",
                                      boxShadow: isThis && w.srpe > 0 ? `0 0 10px ${c}50` : "none" }} />
                                  </div>
                                  <span style={{ fontSize:8, color: isThis ? "var(--text-muted)" : "var(--text-faint)", fontWeight: isThis ? 800 : 400 }}>{isThis ? "Esta" : `S${i+1}`}</span>
                                </div>
                              );
                            })}
                          </div>
                          {srpeByWeek[3].srpe > 2500 && (
                            <div style={{ marginTop:8, fontSize:10, color:"#f87171", fontWeight:700, background:"rgba(248,113,113,0.10)", borderRadius:8, padding:"5px 10px" }}>
                              ⚠️ Carga esta semana: {srpeByWeek[3].srpe.toLocaleString()} — por encima del umbral (2500)
                            </div>
                          )}
                        </div>
                      );
                    })()}

                    {/* Agenda del atleta: próximas sesiones programadas */}'''
assert old5 in src, "FAIL 5: Agenda del atleta not found"
src = src.replace(old5, new5, 1)

with open("src/App.jsx", "w", encoding="utf-8") as f:
    f.write(src)

print("ALL 5 PATCHES APPLIED OK")
