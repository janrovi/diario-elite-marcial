import { useState, useEffect } from "react";

const DISCIPLINES = ["BJJ", "MMA", "Muay Thai", "Taekwondo", "Grappling", "Fuerza", "Movilidad", "Boxeo", "Otra"];
const STORAGE_KEY = "elite_marcial_sesiones";

const EMPTY_SESSION = {
  id: null,
  nombre: "",
  fecha: new Date().toISOString().slice(0, 10),
  hora: "",
  disciplina: "",
  duracionMin: "",
  rpe: "",
  fatiga: "",
  notas: "",
  tecnica: { nombre: "", descripcion: "" },
  entrenamiento: "",
  sensaciones: { cuerpo: "", mente: "", observaciones: "" },
  proximaSesion: ""
};

function loadSessions() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : [];
  } catch { return []; }
}

function saveSessions(sessions) {
  try { localStorage.setItem(STORAGE_KEY, JSON.stringify(sessions)); } catch {}
}

const RED = "#e53e3e";

const s = {
  app: { fontFamily: "inherit", color: "#fff", minHeight: "100vh", background: "#0a0a0a" },
  header: { background: "#111", borderBottom: "1px solid #222", padding: "12px 20px", display: "flex", alignItems: "center", justifyContent: "space-between", position: "sticky", top: 0, zIndex: 10 },
  logo: { display: "flex", alignItems: "center", gap: 10 },
  logoIcon: { width: 34, height: 34, background: RED, borderRadius: 7, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 15, fontWeight: 700, color: "#fff", flexShrink: 0 },
  logoText: { fontSize: 15, fontWeight: 600, color: "#fff" },
  logoSub: { fontSize: 11, color: "#555", marginTop: 1 },
  nav: { display: "flex", gap: 6, alignItems: "center" },
  navBtn: (active) => ({ background: active ? RED : "transparent", color: active ? "#fff" : "#666", border: `1px solid ${active ? RED : "#2a2a2a"}`, borderRadius: 6, padding: "6px 14px", fontSize: 13, cursor: "pointer", fontWeight: active ? 600 : 400, transition: "all 0.15s" }),
  btnNew: { background: RED, color: "#fff", border: "none", borderRadius: 6, padding: "7px 14px", fontSize: 13, fontWeight: 600, cursor: "pointer" },
  main: { padding: "20px 16px", maxWidth: 720, margin: "0 auto" },
  card: { background: "#111", border: "1px solid #1e1e1e", borderRadius: 10, padding: "16px 18px", marginBottom: 14 },
  sectionTitle: { fontSize: 11, fontWeight: 700, color: RED, textTransform: "uppercase", letterSpacing: 1.2, marginBottom: 12 },
  label: { fontSize: 12, color: "#666", marginBottom: 5, display: "block" },
  input: { background: "#1a1a1a", border: "1px solid #2a2a2a", borderRadius: 6, color: "#fff", padding: "9px 11px", fontSize: 14, width: "100%", outline: "none" },
  textarea: { background: "#1a1a1a", border: "1px solid #2a2a2a", borderRadius: 6, color: "#fff", padding: "9px 11px", fontSize: 14, width: "100%", resize: "vertical", minHeight: 80, lineHeight: 1.6, outline: "none" },
  select: { background: "#1a1a1a", border: "1px solid #2a2a2a", borderRadius: 6, color: "#fff", padding: "9px 11px", fontSize: 14, width: "100%", outline: "none" },
  grid2: { display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 },
  grid3: { display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 12 },
  grid4: { display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 10, marginBottom: 14 },
  btnPrimary: { background: RED, color: "#fff", border: "none", borderRadius: 7, padding: "11px 22px", fontSize: 14, fontWeight: 600, cursor: "pointer", width: "100%" },
  btnSecondary: { background: "transparent", color: "#888", border: "1px solid #2a2a2a", borderRadius: 7, padding: "11px 22px", fontSize: 14, cursor: "pointer" },
  btnBack: { background: "transparent", color: "#888", border: "1px solid #2a2a2a", borderRadius: 6, padding: "7px 14px", fontSize: 13, cursor: "pointer", marginBottom: 16, display: "inline-flex", alignItems: "center", gap: 6 },
  btnEdit: { background: "transparent", color: RED, border: `1px solid ${RED}44`, borderRadius: 6, padding: "7px 14px", fontSize: 13, cursor: "pointer" },
  btnDelete: { background: "transparent", color: "#555", border: "1px solid #222", borderRadius: 6, padding: "6px 10px", fontSize: 12, cursor: "pointer" },
  sessionRow: { background: "#111", border: "1px solid #1e1e1e", borderRadius: 9, padding: "14px 16px", marginBottom: 10, cursor: "pointer", display: "flex", justifyContent: "space-between", alignItems: "center", transition: "border-color 0.15s" },
  badge: { background: RED + "22", color: RED, borderRadius: 4, padding: "2px 8px", fontSize: 11, fontWeight: 600, border: `1px solid ${RED}33` },
  statCard: { background: "#111", border: "1px solid #1e1e1e", borderRadius: 8, padding: "14px", textAlign: "center" },
  statNum: { fontSize: 26, fontWeight: 700, color: RED },
  statLabel: { fontSize: 10, color: "#555", marginTop: 3, textTransform: "uppercase", letterSpacing: 0.8 },
  emptyState: { textAlign: "center", padding: "70px 20px", color: "#333" },
  actions: { display: "flex", gap: 8, flexShrink: 0 },
  formActions: { display: "flex", gap: 10, justifyContent: "flex-end", paddingBottom: 40, marginTop: 4 },
};

export default function App() {
  const [view, setView] = useState("sesiones");
  const [sessions, setSessions] = useState(loadSessions);
  const [form, setForm] = useState(EMPTY_SESSION);
  const [detailId, setDetailId] = useState(null);

  useEffect(() => { saveSessions(sessions); }, [sessions]);

  const saveSession = () => {
    if (!form.nombre.trim()) return alert("Añade un nombre a la sesión.");
    if (form.id) {
      setSessions(ss => ss.map(x => x.id === form.id ? form : x));
    } else {
      setSessions(ss => [{ ...form, id: Date.now() }, ...ss]);
    }
    setView("sesiones");
  };

  const deleteSession = (id, e) => {
    e.stopPropagation();
    if (!confirm("¿Eliminar esta sesión?")) return;
    setSessions(ss => ss.filter(x => x.id !== id));
    if (detailId === id) setDetailId(null);
  };

  const openNew = () => {
    setForm({ ...EMPTY_SESSION, id: null, fecha: new Date().toISOString().slice(0, 10) });
    setView("form");
  };

  const openEdit = (session, e) => {
    if (e) e.stopPropagation();
    setForm(session);
    setView("form");
  };

  const openDetail = (session) => {
    setDetailId(session.id);
    setView("detail");
  };

  const setF = (key, val) => setForm(f => ({ ...f, [key]: val }));
  const setNested = (key, sub, val) => setForm(f => ({ ...f, [key]: { ...f[key], [sub]: val } }));

  const sorted = [...sessions].sort((a, b) => new Date(b.fecha) - new Date(a.fecha));
  const detail = sessions.find(ss => ss.id === detailId);

  const totalMin = sessions.reduce((a, ss) => a + (parseFloat(ss.duracionMin) || 0), 0);
  const rpeList = sessions.filter(ss => ss.rpe);
  const avgRpe = rpeList.length ? (rpeList.reduce((a, ss) => a + parseFloat(ss.rpe), 0) / rpeList.length).toFixed(1) : "—";
  const discCount = {};
  sessions.forEach(ss => { if (ss.disciplina) discCount[ss.disciplina] = (discCount[ss.disciplina] || 0) + 1; });
  const topDisc = Object.entries(discCount).sort((a, b) => b[1] - a[1])[0];
  const getRpeColor = (v) => v >= 8 ? RED : v >= 5 ? "#f6ad55" : "#68d391";

  const Field = ({ label, children }) => (
    <div>
      <label style={s.label}>{label}</label>
      {children}
    </div>
  );

  const DetailBlock = ({ title, children }) => (
    <div style={s.card}>
      <div style={s.sectionTitle}>{title}</div>
      {children}
    </div>
  );

  const SubField = ({ label, value }) => value ? (
    <div style={{ marginBottom: 10 }}>
      <div style={{ fontSize: 11, color: "#555", marginBottom: 3 }}>{label}</div>
      <div style={{ fontSize: 14, color: "#bbb", lineHeight: 1.6, whiteSpace: "pre-wrap" }}>{value}</div>
    </div>
  ) : null;

  return (
    <div style={s.app}>
      <header style={s.header}>
        <div style={s.logo}>
          <div style={s.logoIcon}>EM</div>
          <div>
            <div style={s.logoText}>Élite Marcial</div>
            <div style={s.logoSub}>Diario de Entrenamiento</div>
          </div>
        </div>
        <div style={s.nav}>
          <button style={s.navBtn(view === "sesiones" || view === "detail")} onClick={() => setView("sesiones")}>Sesiones</button>
          <button style={s.navBtn(view === "stats")} onClick={() => setView("stats")}>Stats</button>
          <button style={s.btnNew} onClick={openNew}>+ Nueva</button>
        </div>
      </header>

      <main style={s.main}>

        {/* LISTA */}
        {view === "sesiones" && (
          sorted.length === 0 ? (
            <div style={s.emptyState}>
              <div style={{ fontSize: 48, marginBottom: 16 }}>🥋</div>
              <div style={{ fontSize: 16, color: "#444", marginBottom: 8 }}>Sin sesiones todavía</div>
              <div style={{ fontSize: 13, color: "#333" }}>Pulsa "+ Nueva" para registrar tu primera sesión</div>
            </div>
          ) : sorted.map(ss => (
            <div key={ss.id} style={s.sessionRow} onClick={() => openDetail(ss)}>
              <div style={{ minWidth: 0 }}>
                <div style={{ fontSize: 14, fontWeight: 600, marginBottom: 5, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{ss.nombre}</div>
                <div style={{ display: "flex", gap: 8, flexWrap: "wrap", alignItems: "center" }}>
                  <span style={{ fontSize: 12, color: "#555" }}>{ss.fecha}</span>
                  {ss.disciplina && <span style={s.badge}>{ss.disciplina}</span>}
                  {ss.duracionMin && <span style={{ fontSize: 12, color: "#666" }}>{ss.duracionMin} min</span>}
                  {ss.rpe && <span style={{ fontSize: 12, color: getRpeColor(ss.rpe) }}>RPE {ss.rpe}</span>}
                </div>
              </div>
              <div style={s.actions}>
                <button style={s.btnDelete} onClick={(e) => deleteSession(ss.id, e)}>✕</button>
                <button style={s.btnEdit} onClick={(e) => openEdit(ss, e)}>Editar</button>
              </div>
            </div>
          ))
        )}

        {/* DETALLE */}
        {view === "detail" && detail && (
          <>
            <button style={s.btnBack} onClick={() => setView("sesiones")}>← Volver</button>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 16 }}>
              <div>
                <div style={{ fontSize: 20, fontWeight: 700, marginBottom: 6 }}>{detail.nombre}</div>
                <div style={{ display: "flex", gap: 8, flexWrap: "wrap", alignItems: "center" }}>
                  <span style={{ fontSize: 13, color: "#555" }}>{detail.fecha}</span>
                  {detail.hora && <span style={{ fontSize: 13, color: "#555" }}>{detail.hora}</span>}
                  {detail.disciplina && <span style={s.badge}>{detail.disciplina}</span>}
                </div>
              </div>
              <button style={s.btnEdit} onClick={(e) => openEdit(detail, e)}>Editar</button>
            </div>

            <div style={s.grid4}>
              {[["Duración", detail.duracionMin ? detail.duracionMin + " min" : "—"],
                ["RPE", detail.rpe || "—"],
                ["Intensidad", detail.intensidad || "—"],
                ["Fatiga", detail.fatiga || "—"]].map(([label, val]) => (
                <div key={label} style={s.statCard}>
                  <div style={s.statNum}>{val}</div>
                  <div style={s.statLabel}>{label}</div>
                </div>
              ))}
            </div>

            {detail.tecnica?.nombre && (
              <DetailBlock title="Técnica del día">
                <div style={{ fontWeight: 600, marginBottom: 6 }}>{detail.tecnica.nombre}</div>
                {detail.tecnica.descripcion && <div style={{ fontSize: 13, color: "#aaa", lineHeight: 1.6 }}>{detail.tecnica.descripcion}</div>}
              </DetailBlock>
            )}

            {detail.entrenamiento && (
              <DetailBlock title="Entrenamiento">
                <div style={{ fontSize: 14, color: "#bbb", lineHeight: 1.6, whiteSpace: "pre-wrap" }}>{detail.entrenamiento}</div>
              </DetailBlock>
            )}

            {(detail.sensaciones?.cuerpo || detail.sensaciones?.mente || detail.sensaciones?.observaciones) && (
              <DetailBlock title="Sensaciones">
                <SubField label="Cuerpo" value={detail.sensaciones.cuerpo} />
                <SubField label="Mente" value={detail.sensaciones.mente} />
                <SubField label="Observaciones" value={detail.sensaciones.observaciones} />
              </DetailBlock>
            )}

            {detail.proximaSesion && (
              <DetailBlock title="Próxima sesión">
                <div style={{ fontSize: 14, color: "#bbb", lineHeight: 1.6 }}>{detail.proximaSesion}</div>
              </DetailBlock>
            )}

            {detail.notas && (
              <DetailBlock title="Notas generales">
                <div style={{ fontSize: 14, color: "#bbb", lineHeight: 1.6 }}>{detail.notas}</div>
              </DetailBlock>
            )}
          </>
        )}

        {/* FORMULARIO */}
        {view === "form" && (
          <>
            <div style={{ fontSize: 18, fontWeight: 700, marginBottom: 20 }}>{form.id ? "Editar sesión" : "Nueva sesión"}</div>

            <div style={s.card}>
              <div style={s.sectionTitle}>General</div>
              <Field label="Nombre de la sesión *">
                <input style={s.input} value={form.nombre} onChange={e => setF("nombre", e.target.value)} placeholder='Ej: "BJJ — sparring", "Fuerza — tren superior"' />
              </Field>
              <div style={{ ...s.grid3, marginTop: 12 }}>
                <Field label="Fecha">
                  <input type="date" style={s.input} value={form.fecha} onChange={e => setF("fecha", e.target.value)} />
                </Field>
                <Field label="Hora">
                  <input style={s.input} value={form.hora} onChange={e => setF("hora", e.target.value)} placeholder="07:30" />
                </Field>
                <Field label="Disciplina">
                  <select style={s.select} value={form.disciplina} onChange={e => setF("disciplina", e.target.value)}>
                    <option value="">— Selecciona —</option>
                    {DISCIPLINES.map(d => <option key={d}>{d}</option>)}
                  </select>
                </Field>
              </div>
              <div style={{ ...s.grid3, marginTop: 12 }}>
                <Field label="Duración (min)">
                  <input type="number" style={s.input} value={form.duracionMin} onChange={e => setF("duracionMin", e.target.value)} placeholder="75" />
                </Field>
                <Field label="RPE (1–10)">
                  <input type="number" min="1" max="10" style={s.input} value={form.rpe} onChange={e => setF("rpe", e.target.value)} placeholder="7" />
                </Field>
                <Field label="Fatiga percibida (1–10)">
                  <input type="number" min="1" max="10" style={s.input} value={form.fatiga} onChange={e => setF("fatiga", e.target.value)} placeholder="6" />
                </Field>
              </div>
            </div>

            <div style={s.card}>
              <div style={s.sectionTitle}>Técnica del día</div>
              <Field label="Nombre de la técnica">
                <input style={s.input} value={form.tecnica.nombre} onChange={e => setNested("tecnica", "nombre", e.target.value)} placeholder="Ej: Jab + cross con paso" />
              </Field>
              <div style={{ marginTop: 12 }}>
                <Field label="Descripción / notas">
                  <textarea style={s.textarea} value={form.tecnica.descripcion} onChange={e => setNested("tecnica", "descripcion", e.target.value)} placeholder="Cómo ejecutarla, puntos clave..." />
                </Field>
              </div>
            </div>

            <div style={s.card}>
              <div style={s.sectionTitle}>Entrenamiento</div>
              <textarea style={{ ...s.textarea, minHeight: 100 }} value={form.entrenamiento} onChange={e => setF("entrenamiento", e.target.value)} placeholder="Calentamiento, bloques, acondicionamiento..." />
            </div>

            <div style={s.card}>
              <div style={s.sectionTitle}>Sensaciones</div>
              <Field label="Cuerpo">
                <textarea style={s.textarea} value={form.sensaciones.cuerpo} onChange={e => setNested("sensaciones", "cuerpo", e.target.value)} placeholder="Estado físico, molestias, energía..." />
              </Field>
              <div style={{ marginTop: 12 }}>
                <Field label="Mente">
                  <textarea style={s.textarea} value={form.sensaciones.mente} onChange={e => setNested("sensaciones", "mente", e.target.value)} placeholder="Concentración, motivación..." />
                </Field>
              </div>
              <div style={{ marginTop: 12 }}>
                <Field label="Observaciones">
                  <textarea style={s.textarea} value={form.sensaciones.observaciones} onChange={e => setNested("sensaciones", "observaciones", e.target.value)} placeholder="Qué mejorar, qué ha funcionado..." />
                </Field>
              </div>
            </div>

            <div style={s.card}>
              <div style={s.sectionTitle}>Próxima sesión</div>
              <textarea style={s.textarea} value={form.proximaSesion} onChange={e => setF("proximaSesion", e.target.value)} placeholder="Objetivo o enfoque para la próxima sesión..." />
            </div>

            <div style={s.card}>
              <div style={s.sectionTitle}>Notas generales</div>
              <textarea style={s.textarea} value={form.notas} onChange={e => setF("notas", e.target.value)} placeholder="Cualquier otra anotación relevante..." />
            </div>

            <div style={s.formActions}>
              <button style={s.btnSecondary} onClick={() => setView("sesiones")}>Cancelar</button>
              <button style={{ ...s.btnPrimary, width: "auto", padding: "11px 28px" }} onClick={saveSession}>Guardar sesión</button>
            </div>
          </>
        )}

        {/* STATS */}
        {view === "stats" && (
          <>
            <div style={{ fontSize: 16, fontWeight: 600, marginBottom: 16, color: "#fff" }}>Estadísticas generales</div>
            <div style={{ ...s.grid2, marginBottom: 14 }}>
              <div style={s.statCard}><div style={s.statNum}>{sessions.length}</div><div style={s.statLabel}>Sesiones totales</div></div>
              <div style={s.statCard}><div style={s.statNum}>{(Math.round(totalMin / 60 * 10) / 10)}h</div><div style={s.statLabel}>Horas totales</div></div>
              <div style={s.statCard}><div style={s.statNum}>{avgRpe}</div><div style={s.statLabel}>RPE medio</div></div>
              <div style={s.statCard}><div style={s.statNum} style={{ fontSize: 18 }}>{topDisc ? topDisc[0] : "—"}</div><div style={s.statLabel}>Disciplina top</div></div>
            </div>

            {Object.keys(discCount).length > 0 && (
              <div style={s.card}>
                <div style={s.sectionTitle}>Por disciplina</div>
                {Object.entries(discCount).sort((a, b) => b[1] - a[1]).map(([disc, count]) => (
                  <div key={disc} style={{ marginBottom: 12 }}>
                    <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 5 }}>
                      <span style={{ fontSize: 13 }}>{disc}</span>
                      <span style={{ fontSize: 13, color: RED, fontWeight: 600 }}>{count} sesiones</span>
                    </div>
                    <div style={{ background: "#1a1a1a", borderRadius: 3, height: 5 }}>
                      <div style={{ height: 5, background: RED, borderRadius: 3, width: `${(count / sessions.length) * 100}%`, transition: "width 0.4s" }} />
                    </div>
                  </div>
                ))}
              </div>
            )}

            {sorted.length > 0 && (
              <div style={s.card}>
                <div style={s.sectionTitle}>Últimas sesiones — RPE</div>
                {sorted.slice(0, 10).map(ss => (
                  <div key={ss.id} style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 10 }}>
                    <span style={{ fontSize: 12, color: "#555", minWidth: 85, flexShrink: 0 }}>{ss.fecha}</span>
                    <span style={{ fontSize: 12, flex: 1, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap", color: "#888" }}>{ss.nombre}</span>
                    {ss.rpe ? (
                      <div style={{ minWidth: 70, flexShrink: 0 }}>
                        <div style={{ background: "#1a1a1a", borderRadius: 3, height: 5 }}>
                          <div style={{ height: 5, background: getRpeColor(ss.rpe), borderRadius: 3, width: `${ss.rpe * 10}%` }} />
                        </div>
                        <div style={{ fontSize: 11, color: getRpeColor(ss.rpe), marginTop: 2, textAlign: "right" }}>{ss.rpe}/10</div>
                      </div>
                    ) : <span style={{ fontSize: 12, color: "#333", minWidth: 70 }}>—</span>}
                  </div>
                ))}
              </div>
            )}

            {sessions.length === 0 && (
              <div style={s.emptyState}>
                <div style={{ fontSize: 13 }}>Registra sesiones para ver estadísticas</div>
              </div>
            )}
          </>
        )}
      </main>
    </div>
  );
}