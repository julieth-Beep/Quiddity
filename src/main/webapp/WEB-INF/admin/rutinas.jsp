<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.quiddity.model.Rutina" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="com.quiddity.model.Caracteristicas" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String ctx = request.getContextPath();
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    String nombreUsuario = "Usuario";
    boolean esAdmin = false;
    if (usuario != null) {
        nombreUsuario = usuario.getNombre();
        esAdmin = usuario.getIdRol() == 1;
    }
    List<Rutina> rutinas = (List<Rutina>) request.getAttribute("rutinas");
    Caracteristicas caractUsuario = (Caracteristicas) request.getAttribute("caracteristicas");
    Boolean perfilIncompletoAttr = (Boolean) request.getAttribute("perfilIncompleto");
    boolean perfilIncompleto = perfilIncompletoAttr != null && perfilIncompletoAttr;
    if (rutinas == null) rutinas = new ArrayList<Rutina>();
%>
<%!
    private String normalize(String input) {
        if (input == null) return "";
        String str = input.toLowerCase();
        str = str.replaceAll("[\u00e1\u00e4\u00e2\u00e0]", "a")
                 .replaceAll("[\u00e9\u00eb\u00ea\u00e8]", "e")
                 .replaceAll("[\u00ed\u00ef\u00ee\u00ec]", "i")
                 .replaceAll("[\u00f3\u00f6\u00f4\u00f2]", "o")
                 .replaceAll("[\u00fa\u00fc\u00fb\u00f9]", "u")
                 .replaceAll("[\u00f1]", "n");
        return str;
    }
    private String getEmbedUrl(String url) {
        if (url == null || url.isEmpty()) return null;
        if (url.contains("youtube.com") || url.contains("youtu.be")) {
            String videoId = null;
            if (url.contains("youtu.be/")) {
                int idx = url.lastIndexOf("youtu.be/");
                if (idx != -1) {
                    videoId = url.substring(idx + 9);
                    int qIdx = videoId.indexOf("?");
                    if (qIdx != -1) videoId = videoId.substring(0, qIdx);
                }
            } else if (url.contains("v=")) {
                int idx = url.indexOf("v=");
                if (idx != -1) {
                    videoId = url.substring(idx + 2);
                    int qIdx = videoId.indexOf("&");
                    if (qIdx != -1) videoId = videoId.substring(0, qIdx);
                }
            } else if (url.contains("embed/")) {
                int idx = url.lastIndexOf("embed/");
                if (idx != -1) {
                    videoId = url.substring(idx + 6);
                    int qIdx = videoId.indexOf("?");
                    if (qIdx != -1) videoId = videoId.substring(0, qIdx);
                }
            }
            if (videoId != null && !videoId.isEmpty()) {
                return "https://www.youtube.com/embed/" + videoId;
            }
            return null;
        }
        if (url.contains("facebook.com") || url.contains("fb.watch")) {
            try {
                return "https://www.facebook.com/plugins/video.php?href=" + 
                       java.net.URLEncoder.encode(url, "UTF-8") + 
                       "&show_text=false&width=380&height=220";
            } catch (Exception e) { return null; }
        }
        return null;
    }
    private String getCategoriaLabel(String cat) {
        if (cat == null) return "General";
        return cat;
    }
    private String getCategoriaClass(String cat) {
        if (cat == null) return "maquillaje";
        String c = normalize(cat);
        if (c.contains("cuidado de la piel")) return "cuidado";
        if (c.contains("cabello")) return "cabello";
        if (c.contains("cuidado corporal") || c.contains("corporal")) return "cuerpo";
        if (c.contains("maquillaje")) return "maquillaje";
        return "maquillaje";
    }
    /**
     * Indica si una rutina coincide con las características del usuario
     * (o es universal en esa caracteristica) -> usada para el badge
     * "Recomendado para ti". Misma regla OR que aplica el RutinaDAO.
     */
    private boolean esRecomendada(Rutina r, Caracteristicas c) {
        if (c == null) {
            // Sin perfil: solo se consideran recomendadas las 100% universales
            return r.getTipoPiel() == null && r.getTipoCabello() == null &&
                   r.getTonoPiel() == null && r.getFormaCara() == null &&
                   r.getTipoCuerpo() == null;
        }
        boolean matchPiel = r.getTipoPiel() == null || r.getTipoPiel().equalsIgnoreCase(c.getTipoPiel());
        boolean matchCabello = r.getTipoCabello() == null || r.getTipoCabello().equalsIgnoreCase(c.getTipoCabello());
        boolean matchTono = r.getTonoPiel() == null || (c.getTonoPiel() != null && r.getTonoPiel().equalsIgnoreCase(c.getTonoPiel()));
        boolean matchCara = r.getFormaCara() == null || (c.getFormaCara() != null && r.getFormaCara().equalsIgnoreCase(c.getFormaCara()));
        boolean matchCuerpo = r.getTipoCuerpo() == null || (c.getTipoCuerpo() != null && r.getTipoCuerpo().equalsIgnoreCase(c.getTipoCuerpo()));
        return matchPiel || matchCabello || matchTono || matchCara || matchCuerpo;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Rutinas Beauty — Quiddity</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&family=EB+Garamond:ital,wght@0,400..800;1,400..800&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

<style>
:root {
    --bg: #F8F9FA; --bg-soft: #FFFFFF; --surface: #FFFFFF;
    --text-primary: #1a1a2e; --text-secondary: #6c757d; --text-tertiary: #adb5bd;
    --border: #e9ecef; --border-light: #f1f3f5;
    --pastel-sky: #e3f2fd; --pastel-sky-dark: #bbdefb;
    --pastel-mint: #e8f5e9; --pastel-mint-dark: #c8e6c9;
    --pastel-lavender: #f3e5f5; --pastel-lavender-dark: #e1bee7;
    --pastel-cream: #fff3e0; --pastel-cream-dark: #ffe0b2;
    --pastel-coral: #fce4ec; --pastel-coral-dark: #f8bbd0;
    --pastel-sage: #f1f8e9; --pastel-sage-dark: #dcedc8;
    --pastel-rose: #ffebee; --pastel-rose-dark: #ffcdd2;
    --accent-sky: #1976d2; --accent-mint: #388e3c; --accent-lavender: #7b1fa2;
    --accent-cream: #f57c00; --accent-coral: #c2185b; --accent-sage: #689f38;
    --accent-rose: #d32f2f;
    --success: #388e3c; --warning: #f57c00; --error: #c2185b;
    --radius-sm: 12px; --radius-md: 14px; --radius-lg: 16px;
    --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
    --shadow: 0 2px 8px rgba(0,0,0,0.06);
    --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
    --shadow-lg: 0 12px 32px rgba(0,0,0,0.12);
    --primary:#9a3a5a; --primary-dark:#7a2e48;
}
* { margin:0; padding:0; box-sizing:border-box; }
body {
    font-family: 'Plus Jakarta Sans', sans-serif;
    background: var(--bg); color: var(--text-primary);
    -webkit-font-smoothing: antialiased; font-size: 12px; line-height: 1.4;
    overflow: hidden;
    height: 100vh;
}
.material-symbols-outlined { font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 24; vertical-align: middle; }
::-webkit-scrollbar { width:4px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

.layout-wrapper { display:flex; height:100vh; overflow:hidden; }
.main-content {
    flex:1; display:flex; flex-direction:column;
    height:100vh; overflow-y:auto; overflow-x:hidden;
    padding: 16px 20px; gap: 12px;
    transition: max-width 0.3s ease;
}
.main-content.sidebar-open { max-width: calc(100% - 260px); }
.main-content.sidebar-closed { max-width: 100%; }

.welcome-section {
    display: flex; align-items: center; justify-content: space-between;
    background: var(--surface); border-radius: var(--radius-lg); padding: 16px 20px;
    border: 1px solid var(--border); box-shadow: var(--shadow-sm);
    animation: fadeUp 0.5s ease forwards; opacity: 0;
}
.welcome-content { flex: 1; }
.welcome-title { font-family: 'DM Sans', sans-serif; font-size: 22px; font-weight: 700; color: var(--text-primary); margin: 0 0 3px 0; letter-spacing: -0.3px; }
.welcome-title span { color: var(--accent-lavender); }
.welcome-subtitle { font-size: 12px; color: var(--text-secondary); font-weight: 500; margin: 0; }
.welcome-actions { display: flex; align-items: center; gap: 10px; }

.perfil-alert {
    display: flex; align-items: center; gap: 10px; background: var(--pastel-cream);
    border: 1px solid var(--pastel-cream-dark); border-radius: var(--radius-md);
    padding: 12px 16px; font-size: 11px; font-weight: 600; color: var(--accent-cream);
}
.perfil-alert a { color: var(--accent-cream); text-decoration: underline; font-weight: 700; }
.perfil-alert .material-symbols-outlined { font-size: 18px; }

.stats-bar { display: grid; grid-template-columns: repeat(5, 1fr); gap: 12px; }
.stat-item {
    background: var(--surface); border-radius: var(--radius-md); padding: 14px 16px;
    box-shadow: var(--shadow-sm); border: 1px solid var(--border-light);
    transition: all 0.3s ease; position: relative; overflow: hidden; cursor: pointer;
    display: flex; align-items: center; gap: 12px;
}
.stat-item:hover { transform: translateY(-3px); box-shadow: var(--shadow); border-color: var(--pastel-lavender-dark); }
.stat-item::before {
    content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px;
    background: var(--accent-lavender); transform: scaleX(0); transform-origin: left; transition: transform 0.3s ease;
}
.stat-item:hover::before { transform: scaleX(1); }
.stat-icon {
    width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center;
    font-size: 18px; flex-shrink: 0; transition: all 0.3s ease;
}
.stat-item:hover .stat-icon { transform: scale(1.1); }
.stat-icon.primary { background: var(--pastel-lavender); color: var(--accent-lavender); }
.stat-icon.mint { background: var(--pastel-mint); color: var(--accent-mint); }
.stat-icon.cream { background: var(--pastel-cream); color: var(--accent-cream); }
.stat-icon.coral { background: var(--pastel-coral); color: var(--accent-coral); }
.stat-icon.lavender { background: var(--pastel-sky); color: var(--accent-sky); }
.stat-data h4 { font-family: 'DM Sans', sans-serif; font-size: 22px; font-weight: 700; color: var(--text-primary); line-height: 1; margin-bottom: 3px; letter-spacing: -0.5px; }
.stat-data p { font-size: 9px; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.06em; }

.chips-section {
    position: sticky; top: 0; z-index: 40; background: var(--surface);
    border: 1px solid var(--border-light); border-radius: var(--radius-md);
    box-shadow: var(--shadow-sm);
}
.chips-container { padding: 10px 14px; }
.chips-row { display: flex; gap: 8px; overflow-x: auto; scrollbar-width: none; }
.chips-row::-webkit-scrollbar { display: none; }
.cat-chip {
    display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px;
    border: 1.5px solid var(--border); border-radius: var(--radius-sm);
    font-size: 11px; font-weight: 600; letter-spacing: 0.06em; text-transform: uppercase;
    color: var(--text-secondary); cursor: pointer; transition: all 0.22s;
    background: var(--surface); white-space: nowrap; font-family: 'Plus Jakarta Sans', sans-serif;
}
.cat-chip:hover { border-color: var(--primary); color: var(--primary); background: var(--pastel-coral); }
.cat-chip.active {
    background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
    border-color: transparent; color: var(--accent-lavender);
    box-shadow: 0 4px 12px rgba(123, 31, 162, 0.15);
}

.toolbar {
    display: flex; justify-content: space-between; align-items: center;
    padding: 12px 16px; background: var(--surface); border-radius: var(--radius-md);
    border: 1px solid var(--border-light); box-shadow: var(--shadow-sm);
}
.toolbar-left { display: flex; align-items: center; gap: 16px; }
.toolbar-title-group h2 { font-family: 'DM Sans', sans-serif; font-size: 16px; font-weight: 700; color: var(--text-primary); margin-bottom: 2px; letter-spacing: -0.3px; }
.toolbar-title-group p { font-size: 11px; color: var(--text-tertiary); font-weight: 600; }
.toolbar-right { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.btn-action {
    display: inline-flex; align-items: center; gap: 6px; padding: 10px 20px;
    font-size: 11px; font-weight: 700; letter-spacing: 0.06em; text-transform: uppercase;
    border: none; border-radius: var(--radius-sm); cursor: pointer;
    transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); text-decoration: none;
    font-family: 'Plus Jakarta Sans', sans-serif;
}
.btn-action.primary {
    background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
    color: var(--accent-lavender); box-shadow: 0 4px 12px rgba(123, 31, 162, 0.15);
}
.btn-action.primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(123, 31, 162, 0.25); }
.btn-action.secondary { background: var(--bg-soft); color: var(--text-primary); border: 1px solid var(--border); }
.btn-action.secondary:hover { background: var(--pastel-sky); color: var(--accent-sky); border-color: var(--pastel-sky-dark); }
.btn-action.success-btn { background: var(--pastel-mint); color: var(--accent-mint); border: 1px solid var(--pastel-mint-dark); }
.btn-action.success-btn:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(56,142,60,0.18); }
.btn-action.toggle-btn { background: var(--bg-soft); color: var(--text-secondary); border: 1px solid var(--border); }
.btn-action.toggle-btn.active { background: var(--pastel-coral); color: var(--accent-coral); border-color: var(--pastel-coral-dark); }
.search-box { position: relative; width: 260px; }
.search-box input {
    width: 100%; padding: 10px 14px 10px 38px; border: 1.5px solid var(--border);
    border-radius: var(--radius-sm); font-size: 12px; font-weight: 500; color: var(--text-primary);
    background: var(--bg-soft); transition: all 0.2s; font-family: 'Plus Jakarta Sans', sans-serif;
}
.search-box input:focus { outline: none; border-color: var(--accent-sky); box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.08); }
.search-box input::placeholder { color: var(--text-tertiary); }
.search-box .search-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-tertiary); font-size: 16px; }
.filter-select {
    padding: 10px 14px; border: 1.5px solid var(--border); border-radius: var(--radius-sm);
    font-size: 11px; font-weight: 600; color: var(--text-primary); background: var(--bg-soft);
    cursor: pointer; transition: all 0.2s; min-width: 130px; font-family: 'Plus Jakarta Sans', sans-serif;
}
.filter-select:focus { outline: none; border-color: var(--accent-sky); box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.08); }

.rutina-grid { 
    display: grid; 
    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); 
    gap: 16px; 
}
.rutina-card {
    position: relative;
    background: var(--surface); border-radius: var(--radius-md);
    border: 1px solid var(--border-light); box-shadow: var(--shadow-sm);
    overflow: hidden; transition: all 0.3s ease;
    display: flex; flex-direction: column;
}
.rutina-card.recomendada { border-color: var(--pastel-mint-dark); box-shadow: 0 0 0 1px var(--pastel-mint-dark); }
.rutina-card:hover { 
    transform: translateY(-4px); 
    box-shadow: var(--shadow-md); 
    border-color: var(--border); 
}
.rutina-video { 
    width: 100%; 
    height: 220px; 
    min-height: 220px;
    max-height: 220px;
    overflow: hidden; 
    background: linear-gradient(135deg, #1a1a2e, #2d2d44); 
    position: relative;
    flex-shrink: 0;
}
.rutina-video iframe { 
    width: 100%; 
    height: 100%; 
    border: none;
    display: block;
}
.rutina-video.no-video {
    display: flex; align-items: center; justify-content: center;
    background: linear-gradient(135deg, #1a1a2e, #2d2d44);
}
.rutina-video.no-video::after {
    content: 'smart_display';
    font-family: 'Material Symbols Outlined';
    font-size: 48px;
    color: rgba(255,255,255,0.3);
}

.favorite-badge {
    position: absolute; top: 10px; right: 10px;
    width: 32px; height: 32px; border-radius: 50%;
    background: rgba(255,255,255,0.95); backdrop-filter: blur(8px);
    display: flex; align-items: center; justify-content: center;
    cursor: pointer; transition: all 0.2s ease; z-index: 5;
    box-shadow: 0 2px 8px rgba(0,0,0,0.15); border: none;
}
.favorite-badge:hover { transform: scale(1.15); }
.favorite-badge .material-symbols-outlined { 
    font-size: 18px; 
    color: var(--accent-coral);
    font-variation-settings: 'FILL' 1;
}
.favorite-badge.not-fav .material-symbols-outlined {
    color: var(--text-tertiary);
    font-variation-settings: 'FILL' 0;
}

.cat-badge {
    position: absolute; top: 10px; left: 10px;
    padding: 5px 12px; border-radius: 20px;
    font-size: 9px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em;
    color: white; z-index: 5; backdrop-filter: blur(8px);
    background: rgba(123, 31, 162, 0.85);
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}
.cat-badge.maquillaje { background: rgba(194, 24, 89, 0.85); }
.cat-badge.cuidado { background: rgba(25, 118, 210, 0.85); }
.cat-badge.cabello { background: rgba(56, 142, 60, 0.85); }
.cat-badge.cuerpo { background: rgba(123, 31, 162, 0.85); }

.recomendada-badge {
    position: absolute; top: 10px; left: 50%; transform: translateX(-50%);
    padding: 5px 12px; border-radius: 20px;
    font-size: 9px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em;
    color: white; z-index: 5; background: rgba(56, 142, 60, 0.9);
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    display: flex; align-items: center; gap: 4px;
}
.recomendada-badge .material-symbols-outlined { font-size: 12px; font-variation-settings: 'FILL' 1; }

.product-overlay {
    position: absolute; top: 0; left: 0; right: 0; bottom: 0;
    background: rgba(26, 26, 46, 0.85); backdrop-filter: blur(4px);
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    gap: 8px; opacity: 0; transition: opacity 0.3s ease; z-index: 4;
}
.rutina-card:hover .product-overlay { opacity: 1; }
.overlay-btn {
    display: flex; align-items: center; gap: 6px; padding: 8px 16px;
    font-size: 10px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase;
    border: none; border-radius: var(--radius-sm); cursor: pointer; transition: all 0.2s ease;
    min-width: 130px; justify-content: center; font-family: 'Plus Jakarta Sans', sans-serif;
}
.overlay-btn.edit { background: var(--surface); color: var(--text-primary); }
.overlay-btn.edit:hover { background: var(--pastel-sky); color: var(--accent-sky); }
.overlay-btn.play { background: var(--pastel-mint); color: var(--accent-mint); }
.overlay-btn.play:hover { background: var(--accent-mint); color: white; }
.overlay-btn.delete { background: transparent; color: var(--pastel-coral-dark); border: 1px solid var(--pastel-coral-dark); }
.overlay-btn.delete:hover { background: var(--accent-coral); color: white; border-color: var(--accent-coral); }
.overlay-btn.fav-btn { background: var(--pastel-coral); color: var(--accent-coral); }
.overlay-btn.fav-btn:hover { background: var(--accent-coral); color: white; }

.rutina-info { padding: 14px 14px 12px; }
.rutina-category { 
    font-size: 9px; font-weight: 700; color: var(--accent-lavender); 
    text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 4px; 
}
.rutina-name { 
    font-family: 'DM Sans', sans-serif; font-size: 14px; font-weight: 700; 
    color: var(--text-primary); line-height: 1.3; margin-bottom: 6px;
    display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
    overflow: hidden; letter-spacing: -0.2px; 
}
.rutina-objetivo { 
    font-size: 11px; color: var(--text-secondary); margin-bottom: 10px;
    display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
    overflow: hidden; line-height: 1.4;
}
.rutina-caract {
    display: flex; flex-wrap: wrap; gap: 4px; margin-bottom: 10px;
}
.caract-tag {
    display: inline-flex; align-items: center; gap: 3px;
    padding: 3px 8px; border-radius: 10px; font-size: 9px; font-weight: 700;
    text-transform: uppercase; letter-spacing: 0.04em; white-space: nowrap;
}
.caract-tag.piel { background: var(--pastel-sky); color: var(--accent-sky); }
.caract-tag.cabello { background: var(--pastel-mint); color: var(--accent-mint); }
.caract-tag.tono { background: var(--pastel-cream); color: var(--accent-cream); }
.caract-tag.cara { background: var(--pastel-lavender); color: var(--accent-lavender); }
.caract-tag.cuerpo { background: var(--pastel-coral); color: var(--accent-coral); }

.rutina-footer {
    display: flex; align-items: center; justify-content: space-between;
    padding: 10px 14px; border-top: 1px solid var(--border-light);
    background: var(--bg-soft);
}
.rutina-author { 
    display: flex; align-items: center; gap: 6px; font-size: 10px; 
    color: var(--text-tertiary); font-weight: 600; 
}
.rutina-author .material-symbols-outlined { font-size: 14px; }
.rutina-actions { display: flex; gap: 6px; }
.action-btn-sm {
    width: 28px; height: 28px; border-radius: 8px; border: 1px solid var(--border-light);
    background: var(--surface); display: flex; align-items: center; justify-content: center;
    cursor: pointer; transition: all 0.2s ease; color: var(--text-tertiary); font-size: 12px;
}
.action-btn-sm:hover { background: var(--pastel-sky); color: var(--accent-sky); border-color: var(--pastel-sky-dark); transform: scale(1.1); }
.action-btn-sm.delete:hover { background: var(--pastel-coral); color: var(--accent-coral); border-color: var(--pastel-coral-dark); }
.action-btn-sm.fav:hover { background: var(--pastel-coral); color: var(--accent-coral); border-color: var(--pastel-coral-dark); }

.modal-overlay {
    position: fixed; inset: 0; background: rgba(26, 26, 46, 0.6); backdrop-filter: blur(8px);
    z-index: 9998; display: none; align-items: center; justify-content: center;
    padding: 20px;
}
.modal-overlay.active { display: flex; animation: fadeIn 0.25s ease; }
@keyframes fadeIn { from{opacity:0;} to{opacity:1;} }
.modal-content {
    background: var(--surface); max-width: 640px; width: 100%; max-height: 90vh; overflow-y: auto;
    box-shadow: var(--shadow-lg); border-radius: var(--radius-lg);
    animation: modalSlideUp 0.35s cubic-bezier(0.34, 1.56, 0.64, 1); position: relative;
    border: 1px solid var(--border-light);
}
@keyframes modalSlideUp { from{opacity:0; transform:translateY(24px) scale(0.97);} to{opacity:1; transform:translateY(0) scale(1);} }
.modal-header { padding: 16px 20px; border-bottom: 1px solid var(--border-light); display: flex; justify-content: space-between; align-items: center; }
.modal-header h3 { font-family: 'DM Sans', sans-serif; font-size: 16px; font-weight: 700; color: var(--text-primary); letter-spacing: -0.3px; }
.modal-close {
    width: 32px; height: 32px; border-radius: 8px; border: 1px solid var(--border-light);
    background: var(--bg-soft); cursor: pointer; display: flex; align-items: center; justify-content: center;
    transition: all 0.2s ease; color: var(--text-tertiary);
}
.modal-close:hover { background: var(--pastel-coral); color: var(--accent-coral); border-color: var(--pastel-coral-dark); transform: rotate(90deg); }
.modal-body { padding: 20px; }
.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.form-group { display: flex; flex-direction: column; gap: 4px; }
.form-group.full-width { grid-column: 1 / -1; }
.form-group label { font-size: 10px; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.08em; font-family: 'Plus Jakarta Sans', sans-serif; }
.form-group input, .form-group select, .form-group textarea {
    padding: 10px 14px; border: 1.5px solid var(--border); border-radius: var(--radius-sm);
    font-size: 12px; font-weight: 500; color: var(--text-primary); background: var(--bg-soft);
    transition: all 0.2s; font-family: 'Plus Jakarta Sans', sans-serif;
}
.form-group input:focus, .form-group select:focus, .form-group textarea:focus {
    outline: none; border-color: var(--accent-sky); box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.08);
}
.form-group textarea { resize: vertical; min-height: 80px; }
.video-preview {
    width: 100%; aspect-ratio: 16/9; background: linear-gradient(135deg, #1a1a2e, #2d2d44);
    display: flex; align-items: center; justify-content: center;
    color: rgba(255,255,255,0.5); font-size: 12px; overflow: hidden; margin-top: 6px;
    border-radius: var(--radius-sm); border: 1px dashed var(--border);
}
.video-preview iframe { width: 100%; height: 100%; border: none; }
.modal-footer { padding: 14px 20px; border-top: 1px solid var(--border-light); display: flex; justify-content: flex-end; gap: 10px; }
.btn-modal {
    padding: 10px 22px; font-size: 11px; font-weight: 700; letter-spacing: 0.06em; text-transform: uppercase;
    border: none; border-radius: var(--radius-sm); cursor: pointer; transition: all 0.3s ease;
    font-family: 'Plus Jakarta Sans', sans-serif; display: inline-flex; align-items: center; gap: 6px;
}
.btn-modal.cancel { background: var(--bg-soft); color: var(--text-primary); border: 1px solid var(--border); }
.btn-modal.cancel:hover { background: var(--border-light); }
.btn-modal.save {
    background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
    color: var(--accent-lavender); box-shadow: 0 4px 12px rgba(123, 31, 162, 0.15);
}
.btn-modal.save:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(123, 31, 162, 0.25); }
.btn-modal.danger {
    background: linear-gradient(135deg, var(--pastel-coral), #ffab91);
    color: var(--accent-coral); box-shadow: 0 4px 12px rgba(194, 24, 89, 0.15);
}
.btn-modal.danger:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(194, 24, 89, 0.25); }

.toast-container { position: fixed; top: 24px; right: 24px; z-index: 9999; display: flex; flex-direction: column; gap: 10px; pointer-events: none; }
.toast-item {
    background: var(--surface); border: 1px solid var(--border-light); border-radius: var(--radius-md);
    padding: 14px 20px; display: flex; align-items: center; gap: 12px;
    box-shadow: var(--shadow-lg); animation: slideInToast 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
    font-size: 12px; font-weight: 600; min-width: 300px; border-left: 4px solid var(--accent-sky);
    font-family: 'Plus Jakarta Sans', sans-serif; pointer-events: auto;
}
.toast-item.success { border-left-color: var(--accent-mint); }
.toast-item.error { border-left-color: var(--accent-coral); }
.toast-item.warning { border-left-color: var(--accent-cream); }
@keyframes slideInToast { from{transform:translateX(120%); opacity:0;} to{transform:translateX(0); opacity:1;} }
.toast-icon { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 14px; flex-shrink: 0; color: var(--text-primary); }
.toast-item.success .toast-icon { background: var(--pastel-mint); color: var(--accent-mint); }
.toast-item.error .toast-icon { background: var(--pastel-coral); color: var(--accent-coral); }
.toast-item.warning .toast-icon { background: var(--pastel-cream); color: var(--accent-cream); }
.toast-text { flex: 1; color: var(--text-primary); }

.empty-state {
    text-align: center; padding: 60px 40px; grid-column: 1 / -1;
    background: var(--surface); border-radius: var(--radius-md); border: 1px dashed var(--border);
}
.empty-state-icon {
    width: 64px; height: 64px; margin: 0 auto 16px; border-radius: 50%;
    background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
    display: flex; align-items: center; justify-content: center;
    color: var(--accent-lavender); font-size: 28px; animation: floatIcon 3s ease-in-out infinite;
}
@keyframes floatIcon { 0%,100%{transform:translateY(0);} 50%{transform:translateY(-8px);} }
.empty-state h4 { font-family: 'DM Sans', sans-serif; font-size: 18px; font-weight: 700; color: var(--text-primary); margin-bottom: 6px; letter-spacing: -0.3px; }
.empty-state p { font-size: 12px; color: var(--text-secondary); margin-bottom: 16px; }

.video-modal-content { max-width: 800px; }
.video-player-container {
    width: 100%; aspect-ratio: 16/9; background: #000;
    border-radius: var(--radius-sm); overflow: hidden;
}
.video-player-container iframe { width: 100%; height: 100%; border: none; }

@keyframes fadeUp { from{opacity:0; transform:translateY(12px);} to{opacity:1; transform:translateY(0);} }
.anim-fade-up { animation: fadeUp 0.5s ease forwards; opacity: 0; }
.delay-1 { animation-delay: 0.06s; } .delay-2 { animation-delay: 0.12s; } .delay-3 { animation-delay: 0.18s; }
.delay-4 { animation-delay: 0.24s; } .delay-5 { animation-delay: 0.30s; }

@media (max-width:1280px) { .rutina-grid { grid-template-columns: repeat(2, 1fr); } .stats-bar { grid-template-columns: repeat(3, 1fr); } }
@media (max-width:1024px) { .rutina-grid { grid-template-columns: repeat(2, 1fr); } .stats-bar { grid-template-columns: repeat(2, 1fr); } .main-content { padding: 12px 16px; } }
@media (max-width:768px) {
    .rutina-grid { grid-template-columns: 1fr; } .stats-bar { grid-template-columns: repeat(2, 1fr); }
    .form-grid { grid-template-columns: 1fr; } .toolbar { flex-direction: column; gap: 12px; align-items: stretch; }
    .toolbar-right { flex-wrap: wrap; } .search-box { width: 100%; }
    .welcome-section { flex-direction: column; gap: 12px; text-align: center; }
}
</style>
</head>
<body>

<div class="toast-container" id="toastContainer">
    <c:if test="${not empty param.success}">
        <div class="toast-item success"><div class="toast-icon"><i class="fas fa-check"></i></div><span class="toast-text">${fn:escapeXml(param.success)}</span></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="toast-item error"><div class="toast-icon"><i class="fas fa-exclamation"></i></div><span class="toast-text">${fn:escapeXml(param.error)}</span></div>
    </c:if>
</div>

<div class="layout-wrapper">
    <%@ include file="/includes/sidebar.jsp" %>
    <main class="main-content sidebar-open" id="mainContent">

        <div class="welcome-section anim-fade-up">
            <div class="welcome-content">
                <h1 class="welcome-title">Rutinas <span>Beauty</span></h1>
                <p class="welcome-subtitle">
                    <%= esAdmin ? "Gestiona todas las rutinas del sistema" : "Descubre rutinas personalizadas para ti" %>
                </p>
            </div>
            <div class="welcome-actions">
                <% if (!esAdmin) { %>
                <button class="btn-action toggle-btn" id="btnToggleFav" onclick="toggleFavoritesFilter(this)">
                    <span class="material-symbols-outlined" style="font-size:15px;">favorite</span> Mis Favoritas
                </button>
                <button class="btn-action toggle-btn" id="btnToggleReco" onclick="toggleRecomendadasFilter(this)">
                    <span class="material-symbols-outlined" style="font-size:15px;">auto_awesome</span> Para mi perfil
                </button>
                <% } %>
                <% if (esAdmin) { %>
                <button class="btn-action primary" onclick="openAddModal()">
                    <span class="material-symbols-outlined">add</span> Nueva Rutina
                </button>
                <% } %>
            </div>
        </div>

        <% if (!esAdmin && perfilIncompleto) { %>
        <div class="perfil-alert anim-fade-up">
            <span class="material-symbols-outlined">info</span>
            <span>Aún no completaste tu perfil de características. <a href="<%= ctx %>/facefull">Complétalo aquí</a> para ver rutinas personalizadas según tu tipo de piel, cabello y más.</span>
        </div>
        <% } %>

        <div class="stats-bar anim-fade-up delay-1">
            <div class="stat-item" onclick="filterByCategory('all')">
                <div class="stat-icon primary"><span class="material-symbols-outlined">auto_awesome</span></div>
                <div class="stat-data"><h4 id="countTotal"><%= rutinas != null ? rutinas.size() : 0 %></h4><p>Total Rutinas</p></div>
            </div>
            <div class="stat-item" onclick="filterByCategory('maquillaje')">
                <div class="stat-icon mint"><span class="material-symbols-outlined">face_retouching_natural</span></div>
                <div class="stat-data"><h4 id="countMaquillaje">0</h4><p>Maquillaje</p></div>
            </div>
            <div class="stat-item" onclick="filterByCategory('cuidado')">
                <div class="stat-icon cream"><span class="material-symbols-outlined">spa</span></div>
                <div class="stat-data"><h4 id="countCuidado">0</h4><p>Cuidado Piel</p></div>
            </div>
            <div class="stat-item" onclick="filterByCategory('cabello')">
                <div class="stat-icon coral"><span class="material-symbols-outlined">self_improvement</span></div>
                <div class="stat-data"><h4 id="countCabello">0</h4><p>Cabello</p></div>
            </div>
            <div class="stat-item" onclick="filterByCategory('cuerpo')">
                <div class="stat-icon lavender"><span class="material-symbols-outlined">accessibility</span></div>
                <div class="stat-data"><h4 id="countCuerpo">0</h4><p>Corporal</p></div>
            </div>
        </div>

        <div class="chips-section anim-fade-up delay-2">
            <div class="chips-container">
                <div class="chips-row" id="catRow">
                    <button class="cat-chip active" data-cat="all">
                        <span class="material-symbols-outlined" style="font-size:14px;">auto_awesome</span> Todas
                    </button>
                    <button class="cat-chip" data-cat="maquillaje">
                        <span class="material-symbols-outlined" style="font-size:14px;">face_retouching_natural</span> Maquillaje
                    </button>
                    <button class="cat-chip" data-cat="cuidado">
                        <span class="material-symbols-outlined" style="font-size:14px;">spa</span> Cuidado de la Piel
                    </button>
                    <button class="cat-chip" data-cat="cabello">
                        <span class="material-symbols-outlined" style="font-size:14px;">self_improvement</span> Cabello
                    </button>
                    <button class="cat-chip" data-cat="cuerpo">
                        <span class="material-symbols-outlined" style="font-size:14px;">accessibility</span> Cuidado Corporal
                    </button>
                </div>
            </div>
        </div>

        <div class="toolbar anim-fade-up delay-2">
            <div class="toolbar-left">
                <div class="toolbar-title-group">
                    <h2 id="sectionTitle">Todas las Rutinas</h2>
                    <p id="rutinaCount"><%= rutinas != null ? rutinas.size() : 0 %> rutinas</p>
                </div>
            </div>
            <div class="toolbar-right">
                <div class="search-box">
                    <span class="material-symbols-outlined search-icon">search</span>
                    <input type="text" id="searchInput" placeholder="Buscar rutina..." oninput="searchRutinas()">
                </div>
                <select class="filter-select" id="caractFilter" onchange="filterByCaracteristicas()">
                    <option value="">Todas las caracteristicas</option>
                    <option value="tipo_piel">Tipo de Piel</option>
                    <option value="tipo_cabello">Tipo de Cabello</option>
                    <option value="tono_piel">Tono de Piel</option>
                    <option value="forma_cara">Forma de Cara</option>
                    <option value="tipo_cuerpo">Tipo de Cuerpo</option>
                </select>
                <select class="filter-select" id="sortFilter" onchange="sortRutinas()">
                    <option value="">Ordenar por</option>
                    <option value="nombre_asc">Nombre A-Z</option>
                    <option value="nombre_desc">Nombre Z-A</option>
                    <option value="categoria">Categoria</option>
                    <option value="favoritos">Favoritos primero</option>
                </select>
            </div>
        </div>

        <div class="rutina-grid" id="rutinaGrid">
        <c:choose>
            <c:when test="${empty rutinas}">
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <span class="material-symbols-outlined" style="font-size:32px;">self_improvement</span>
                    </div>
                    <h4>No hay rutinas registradas</h4>
                    <p>Comienza agregando tu primera rutina de belleza.</p>
                    <% if (esAdmin) { %>
                    <button class="btn-action primary" onclick="openAddModal()" style="margin-top:12px;">
                        <span class="material-symbols-outlined" style="font-size:18px;">add</span> Agregar Rutina
                    </button>
                    <% } %>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="r" items="${rutinas}" varStatus="status">
                    <% 
                        Rutina rut = (Rutina) pageContext.getAttribute("r");
                        String catClass = getCategoriaClass(rut.getCategoria());
                        String embedUrl = getEmbedUrl(rut.getUrl());
                        boolean hasVideo = embedUrl != null && !embedUrl.isEmpty();
                        boolean isFav = "true".equalsIgnoreCase(rut.getFavoritos());
                        boolean recomendada = !esAdmin && esRecomendada(rut, caractUsuario);
                        pageContext.setAttribute("catClass", catClass);
                        pageContext.setAttribute("embedUrl", embedUrl);
                        pageContext.setAttribute("hasVideo", hasVideo);
                        pageContext.setAttribute("isFav", isFav);
                        pageContext.setAttribute("recomendada", recomendada);
                    %>
                    <div class="rutina-card anim-fade-up delay-${(status.index % 5) + 1} ${recomendada ? 'recomendada' : ''}"
                         data-id="${r.id}"
                         data-cat="${catClass}"
                         data-categoria="${fn:escapeXml(r.categoria)}"
                         data-nombre="${fn:escapeXml(r.nombre)}"
                         data-objetivo="${fn:escapeXml(r.objetivo)}"
                         data-subcategoria="${fn:escapeXml(r.subcategoria)}"
                         data-tipopiel="${fn:escapeXml(r.tipoPiel)}"
                         data-tipocabello="${fn:escapeXml(r.tipoCabello)}"
                         data-tonopiel="${fn:escapeXml(r.tonoPiel)}"
                         data-formacara="${fn:escapeXml(r.formaCara)}"
                         data-tipocuerpo="${fn:escapeXml(r.tipoCuerpo)}"
                         data-favoritos="${r.favoritos}"
                         data-url="${fn:escapeXml(r.url)}"
                         data-recomendada="${recomendada}"
                         data-esadmin="<%= esAdmin %>">

                        <div class="rutina-video ${hasVideo ? '' : 'no-video'}">
                            <c:if test="${hasVideo}">
                                <iframe src="${embedUrl}" 
                                        scrolling="no" 
                                        frameborder="0" 
                                        allowfullscreen="true" 
                                        allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share">
                                </iframe>
                            </c:if>

                            <div class="cat-badge ${catClass}">
                                <%= getCategoriaLabel(rut.getCategoria()) %>
                            </div>

                            <c:if test="${recomendada}">
                                <div class="recomendada-badge">
                                    <span class="material-symbols-outlined">auto_awesome</span> Para ti
                                </div>
                            </c:if>

                            <button class="favorite-badge ${isFav ? '' : 'not-fav'}" 
                                    onclick="event.stopPropagation(); toggleFavorito(${r.id}, this)"
                                    title="${isFav ? 'Quitar de favoritos' : 'Agregar a favoritos'}">
                                <span class="material-symbols-outlined">favorite</span>
                            </button>

                            <div class="product-overlay">
                                <button class="overlay-btn play" onclick="event.stopPropagation(); playVideo('${fn:escapeXml(r.url)}', '${fn:escapeXml(r.nombre)}')">
                                    <span class="material-symbols-outlined" style="font-size:16px;">play_arrow</span> Ver Video
                                </button>
                                <% if (esAdmin) { %>
                                <button class="overlay-btn edit" onclick="event.stopPropagation(); openEditModal(${r.id})">
                                    <span class="material-symbols-outlined" style="font-size:16px;">edit</span> Editar
                                </button>
                                <button class="overlay-btn delete" onclick="event.stopPropagation(); confirmDelete(${r.id}, '${fn:escapeXml(r.nombre)}')">
                                    <span class="material-symbols-outlined" style="font-size:16px;">delete</span> Eliminar
                                </button>
                                <% } else { %>
                                <button class="overlay-btn fav-btn" onclick="event.stopPropagation(); toggleFavorito(${r.id}, null)">
                                    <span class="material-symbols-outlined" style="font-size:16px;">favorite</span> ${isFav ? 'Quitar Fav' : 'Favorito'}
                                </button>
                                <% } %>
                            </div>
                        </div>

                        <div class="rutina-info">
                            <p class="rutina-category">${not empty r.subcategoria ? r.subcategoria : r.categoria}</p>
                            <h4 class="rutina-name">${r.nombre}</h4>
                            <p class="rutina-objetivo">${r.objetivo}</p>
                            <div class="rutina-caract">
                                <c:if test="${not empty r.tipoPiel}">
                                    <span class="caract-tag piel">${r.tipoPiel}</span>
                                </c:if>
                                <c:if test="${not empty r.tipoCabello}">
                                    <span class="caract-tag cabello">${r.tipoCabello}</span>
                                </c:if>
                                <c:if test="${not empty r.tonoPiel}">
                                    <span class="caract-tag tono">${r.tonoPiel}</span>
                                </c:if>
                                <c:if test="${not empty r.formaCara}">
                                    <span class="caract-tag cara">${r.formaCara}</span>
                                </c:if>
                                <c:if test="${not empty r.tipoCuerpo}">
                                    <span class="caract-tag cuerpo">${r.tipoCuerpo}</span>
                                </c:if>
                            </div>
                        </div>

                        <div class="rutina-footer">
                            <div class="rutina-author">
                                <span class="material-symbols-outlined">person</span>
                                <%= esAdmin ? "Admin" : "Personalizada" %>
                            </div>
                            <div class="rutina-actions">
                                <button class="action-btn-sm" onclick="playVideo('${fn:escapeXml(r.url)}', '${fn:escapeXml(r.nombre)}')" title="Ver video">
                                    <span class="material-symbols-outlined" style="font-size:14px;">play_arrow</span>
                                </button>
                                <% if (esAdmin) { %>
                                <button class="action-btn-sm" onclick="openEditModal(${r.id})" title="Editar">
                                    <span class="material-symbols-outlined" style="font-size:14px;">edit</span>
                                </button>
                                <button class="action-btn-sm delete" onclick="confirmDelete(${r.id}, '${fn:escapeXml(r.nombre)}')" title="Eliminar">
                                    <span class="material-symbols-outlined" style="font-size:14px;">delete</span>
                                </button>
                                <% } else { %>
                                <button class="action-btn-sm fav" onclick="toggleFavorito(${r.id}, this)" title="Favorito">
                                    <span class="material-symbols-outlined" style="font-size:14px;">favorite</span>
                                </button>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </div>

        <!-- ADD MODAL -->
        <div class="modal-overlay" id="addModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><span class="material-symbols-outlined" style="font-size:18px;margin-right:6px;color:var(--accent-lavender);">add_circle</span>Nueva Rutina</h3>
                    <button class="modal-close" onclick="closeModal('addModal')"><span class="material-symbols-outlined">close</span></button>
                </div>
                <form action="<%= ctx %>/rutinas" method="POST" id="addForm">
                    <input type="hidden" name="action" value="guardar">
                    <div class="modal-body">
                        <div class="form-grid">
                            <div class="form-group full-width">
                                <label>Nombre de la Rutina</label>
                                <input type="text" name="nombre" required placeholder="Ej: Rutina de Maquillaje Natural">
                            </div>
                            <div class="form-group full-width">
                                <label>Objetivo</label>
                                <textarea name="objetivo" rows="3" placeholder="Describe el objetivo de esta rutina..."></textarea>
                            </div>
                            <div class="form-group">
                                <label>Categoria</label>
                                <select name="categoria">
                                    <option value="">Sin categoria</option>
                                    <option value="Maquillaje">Maquillaje</option>
                                    <option value="Cuidado de la Piel">Cuidado de la Piel</option>
                                    <option value="Cabello">Cabello</option>
                                    <option value="Cuidado Corporal">Cuidado Corporal</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Subcategoria</label>
                                <input type="text" name="subcategoria" placeholder="Ej: Por tipo de piel, Por ocasion, etc.">
                            </div>
                            <div class="form-group full-width">
                                <label>URL del Video (YouTube o Facebook)</label>
                                <input type="url" name="url" id="addUrl" placeholder="https://www.youtube.com/watch?v=..." onchange="previewVideo('addUrl', 'addPreview')">
                                <div class="video-preview" id="addPreview">
                                    <span style="display:flex;align-items:center;gap:6px;">
                                        <span class="material-symbols-outlined" style="font-size:24px;">smart_display</span>
                                        Vista previa del video
                                    </span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Tipo de Piel</label>
                                <select name="tipo_piel">
                                    <option value="">Cualquiera (universal)</option>
                                    <option value="normal">Normal</option>
                                    <option value="seca">Seca</option>
                                    <option value="grasa">Grasa</option>
                                    <option value="mixta">Mixta</option>
                                    <option value="sensible">Sensible</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Tipo de Cabello</label>
                                <select name="tipo_cabello">
                                    <option value="">Cualquiera (universal)</option>
                                    <option value="liso">Liso</option>
                                    <option value="ondulado">Ondulado</option>
                                    <option value="rizado">Rizado</option>
                                    <option value="muy_rizado">Muy rizado</option>
                                    <option value="corto">Corto</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Tono de Piel</label>
                                <select name="tono_piel">
                                    <option value="">Cualquiera (universal)</option>
                                    <option value="claro">Claro</option>
                                    <option value="medio">Medio</option>
                                    <option value="oscuro">Oscuro</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Forma de Cara</label>
                                <select name="forma_cara">
                                    <option value="">Cualquiera (universal)</option>
                                    <option value="ovalada">Ovalada</option>
                                    <option value="redonda">Redonda</option>
                                    <option value="cuadrada">Cuadrada</option>
                                    <option value="corazon">Corazón</option>
                                    <option value="diamante">Diamante</option>
                                    <option value="rectangular">Rectangular</option>
                                    <option value="triangular">Triangular</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Tipo de Cuerpo</label>
                                <select name="tipo_cuerpo">
                                    <option value="">Cualquiera (universal)</option>
                                    <option value="rectangulo">Rectángulo</option>
                                    <option value="pera">Pera</option>
                                    <option value="manzana">Manzana</option>
                                    <option value="reloj_arena">Reloj de arena</option>
                                    <option value="invertido">Invertido</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Favorito</label>
                                <select name="favoritos">
                                    <option value="false">No</option>
                                    <option value="true">Si</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-modal cancel" onclick="closeModal('addModal')">Cancelar</button>
                        <button type="submit" class="btn-modal save">
                            <span class="material-symbols-outlined" style="font-size:15px;">save</span> Guardar Rutina
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- EDIT MODAL -->
        <div class="modal-overlay" id="editModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><span class="material-symbols-outlined" style="font-size:18px;margin-right:6px;color:var(--accent-sky);">edit</span>Editar Rutina</h3>
                    <button class="modal-close" onclick="closeModal('editModal')"><span class="material-symbols-outlined">close</span></button>
                </div>
                <form action="<%= ctx %>/rutinas" method="POST" id="editForm">
                    <input type="hidden" name="action" value="guardar">
                    <input type="hidden" name="id" id="editId">
                    <div class="modal-body">
                        <div class="form-grid">
                            <div class="form-group full-width">
                                <label>Nombre de la Rutina</label>
                                <input type="text" name="nombre" id="editNombre" required>
                            </div>
                            <div class="form-group full-width">
                                <label>Objetivo</label>
                                <textarea name="objetivo" id="editObjetivo" rows="3"></textarea>
                            </div>
                            <div class="form-group">
                                <label>Categoria</label>
                                <select name="categoria" id="editCategoria">
                                    <option value="">Sin categoria</option>
                                    <option value="Maquillaje">Maquillaje</option>
                                    <option value="Cuidado de la Piel">Cuidado de la Piel</option>
                                    <option value="Cabello">Cabello</option>
                                    <option value="Cuidado Corporal">Cuidado Corporal</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Subcategoria</label>
                                <input type="text" name="subcategoria" id="editSubcategoria">
                            </div>
                            <div class="form-group full-width">
                                <label>URL del Video (YouTube o Facebook)</label>
                                <input type="url" name="url" id="editUrl" onchange="previewVideo('editUrl', 'editPreview')">
                                <div class="video-preview" id="editPreview">
                                    <span style="display:flex;align-items:center;gap:6px;">
                                        <span class="material-symbols-outlined" style="font-size:24px;">smart_display</span>
                                        Vista previa del video
                                    </span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Tipo de Piel</label>
                                <select name="tipo_piel" id="editTipoPiel">
                                    <option value="">Cualquiera (universal)</option>
                                    <option value="normal">Normal</option>
                                    <option value="seca">Seca</option>
                                    <option value="grasa">Grasa</option>
                                    <option value="mixta">Mixta</option>
                                    <option value="sensible">Sensible</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Tipo de Cabello</label>
                                <select name="tipo_cabello" id="editTipoCabello">
                                    <option value="">Cualquiera (universal)</option>
                                    <option value="liso">Liso</option>
                                    <option value="ondulado">Ondulado</option>
                                    <option value="rizado">Rizado</option>
                                    <option value="muy_rizado">Muy rizado</option>
                                    <option value="corto">Corto</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Tono de Piel</label>
                                <select name="tono_piel" id="editTonoPiel">
                                    <option value="">Cualquiera (universal)</option>
                                    <option value="claro">Claro</option>
                                    <option value="medio">Medio</option>
                                    <option value="oscuro">Oscuro</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Forma de Cara</label>
                                <select name="forma_cara" id="editFormaCara">
                                    <option value="">Cualquiera (universal)</option>
                                    <option value="ovalada">Ovalada</option>
                                    <option value="redonda">Redonda</option>
                                    <option value="cuadrada">Cuadrada</option>
                                    <option value="corazon">Corazón</option>
                                    <option value="diamante">Diamante</option>
                                    <option value="rectangular">Rectangular</option>
                                    <option value="triangular">Triangular</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Tipo de Cuerpo</label>
                                <select name="tipo_cuerpo" id="editTipoCuerpo">
                                    <option value="">Cualquiera (universal)</option>
                                    <option value="rectangulo">Rectángulo</option>
                                    <option value="pera">Pera</option>
                                    <option value="manzana">Manzana</option>
                                    <option value="reloj_arena">Reloj de arena</option>
                                    <option value="invertido">Invertido</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Favorito</label>
                                <select name="favoritos" id="editFavoritos">
                                    <option value="false">No</option>
                                    <option value="true">Si</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-modal cancel" onclick="closeModal('editModal')">Cancelar</button>
                        <button type="submit" class="btn-modal save">
                            <span class="material-symbols-outlined" style="font-size:15px;">save</span> Actualizar Rutina
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- DELETE MODAL -->
        <div class="modal-overlay" id="deleteModal">
            <div class="modal-content" style="max-width:440px;">
                <div class="modal-header">
                    <h3><span class="material-symbols-outlined" style="font-size:18px;margin-right:6px;color:var(--accent-coral);">delete_forever</span>Confirmar Eliminacion</h3>
                    <button class="modal-close" onclick="closeModal('deleteModal')"><span class="material-symbols-outlined">close</span></button>
                </div>
                <div class="modal-body" style="text-align:center;">
                    <div style="width:56px;height:56px;border-radius:50%;background:var(--pastel-coral);display:flex;align-items:center;justify-content:center;margin:0 auto 14px;">
                        <span class="material-symbols-outlined" style="font-size:26px;color:var(--accent-coral);">delete_forever</span>
                    </div>
                    <p style="font-size:12px;color:var(--text-secondary);margin-bottom:6px;">Estas segura de que deseas eliminar esta rutina?</p>
                    <p id="deleteRutinaName" style="font-family:'DM Sans',sans-serif;font-size:16px;font-weight:700;color:var(--text-primary);margin-bottom:18px;"></p>
                    <p style="font-size:10px;color:var(--text-tertiary);margin-top:10px;">
                        Esta accion no se puede deshacer. La rutina se eliminara permanentemente.
                    </p>
                </div>
                <form action="<%= ctx %>/rutinas" method="POST" id="deleteForm">
                    <input type="hidden" name="action" value="eliminar">
                    <input type="hidden" name="id" id="deleteId">
                    <div class="modal-footer" style="justify-content:center;">
                        <button type="button" class="btn-modal cancel" onclick="closeModal('deleteModal')">Cancelar</button>
                        <button type="submit" class="btn-modal danger">
                            <span class="material-symbols-outlined" style="font-size:15px;">delete</span> Confirmar Eliminacion
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- VIDEO PLAYER MODAL -->
        <div class="modal-overlay" id="videoModal">
            <div class="modal-content video-modal-content">
                <div class="modal-header">
                    <h3 id="videoModalTitle"><span class="material-symbols-outlined" style="font-size:18px;margin-right:6px;color:var(--accent-mint);">play_circle</span>Ver Video</h3>
                    <button class="modal-close" onclick="closeModal('videoModal')"><span class="material-symbols-outlined">close</span></button>
                </div>
                <div class="modal-body" style="padding:0;">
                    <div class="video-player-container" id="videoPlayerContainer"></div>
                </div>
            </div>
        </div>

    </main>
</div>

<script>
var activeCat = 'all';
var activeCaract = '';
var activeSort = '';
var searchTerm = '';
var showFavoritesOnly = false;
var showRecomendadasOnly = false;

function filterByCategory(cat) {
    activeCat = cat;
    document.querySelectorAll('.cat-chip').forEach(function(c) { c.classList.remove('active'); });
    var btn = document.querySelector('.cat-chip[data-cat="' + cat + '"]');
    if (btn) btn.classList.add('active');

    var titles = {
        'all': 'Todas las Rutinas',
        'maquillaje': 'Rutinas de Maquillaje',
        'cuidado': 'Rutinas de Cuidado de la Piel',
        'cabello': 'Rutinas de Cabello',
        'cuerpo': 'Rutinas de Cuidado Corporal'
    };
    document.getElementById('sectionTitle').textContent = titles[cat] || 'Rutinas';
    applyFilters();
}

function searchRutinas() {
    searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
    applyFilters();
}

function filterByCaracteristicas() {
    activeCaract = document.getElementById('caractFilter').value;
    applyFilters();
}

function sortRutinas() {
    activeSort = document.getElementById('sortFilter').value;
    applyFilters();
}

function toggleFavoritesFilter(btn) {
    showFavoritesOnly = !showFavoritesOnly;
    btn.classList.toggle('active', showFavoritesOnly);
    applyFilters();
}

function toggleRecomendadasFilter(btn) {
    showRecomendadasOnly = !showRecomendadasOnly;
    btn.classList.toggle('active', showRecomendadasOnly);
    applyFilters();
}

function applyFilters() {
    var cards = document.querySelectorAll('.rutina-card');
    var visible = 0;

    cards.forEach(function(card) {
        var cat = card.getAttribute('data-cat') || '';
        var nombre = (card.getAttribute('data-nombre') || '').toLowerCase();
        var objetivo = (card.getAttribute('data-objetivo') || '').toLowerCase();
        var categoria = (card.getAttribute('data-categoria') || '').toLowerCase();
        var subcategoria = (card.getAttribute('data-subcategoria') || '').toLowerCase();
        var tipoPiel = card.getAttribute('data-tipopiel') || '';
        var tipoCabello = card.getAttribute('data-tipocabello') || '';
        var tonoPiel = card.getAttribute('data-tonopiel') || '';
        var formaCara = card.getAttribute('data-formacara') || '';
        var tipoCuerpo = card.getAttribute('data-tipocuerpo') || '';
        var favoritos = card.getAttribute('data-favoritos') || 'false';
        var recomendada = card.getAttribute('data-recomendada') === 'true';
        var show = true;

        if (activeCat !== 'all') {
            if (cat !== activeCat) show = false;
        }

        if (show && activeCaract) {
            var hasValue = false;
            if (activeCaract === 'tipo_piel' && tipoPiel) hasValue = true;
            if (activeCaract === 'tipo_cabello' && tipoCabello) hasValue = true;
            if (activeCaract === 'tono_piel' && tonoPiel) hasValue = true;
            if (activeCaract === 'forma_cara' && formaCara) hasValue = true;
            if (activeCaract === 'tipo_cuerpo' && tipoCuerpo) hasValue = true;
            if (!hasValue) show = false;
        }

        if (show && showFavoritesOnly) {
            if (favoritos !== 'true') show = false;
        }

        if (show && showRecomendadasOnly) {
            if (!recomendada) show = false;
        }

        if (show && searchTerm) {
            var text = nombre + ' ' + objetivo + ' ' + categoria + ' ' + subcategoria;
            if (!text.includes(searchTerm)) show = false;
        }

        card.style.display = show ? '' : 'none';
        if (show) visible++;
    });

    document.getElementById('rutinaCount').textContent =
        visible + ' rutina' + (visible !== 1 ? 's' : '');

    sortVisibleCards();
}

function sortVisibleCards() {
    if (!activeSort) return;
    var grid = document.getElementById('rutinaGrid');
    var cards = Array.prototype.filter.call(
        grid.querySelectorAll('.rutina-card'),
        function(c) { return c.style.display !== 'none'; }
    );
    cards.sort(function(a, b) {
        switch (activeSort) {
            case 'nombre_asc':
                return (a.getAttribute('data-nombre') || '').localeCompare(b.getAttribute('data-nombre') || '');
            case 'nombre_desc':
                return (b.getAttribute('data-nombre') || '').localeCompare(a.getAttribute('data-nombre') || '');
            case 'categoria':
                return (a.getAttribute('data-categoria') || '').localeCompare(b.getAttribute('data-categoria') || '');
            case 'favoritos':
                var fa = a.getAttribute('data-favoritos') === 'true' ? 1 : 0;
                var fb = b.getAttribute('data-favoritos') === 'true' ? 1 : 0;
                return fb - fa;
            default:
                return 0;
        }
    });
    cards.forEach(function(card) { grid.appendChild(card); });
}

function openAddModal() {
    document.getElementById('addModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function closeModal(modalId) {
    document.getElementById(modalId).classList.remove('active');
    document.body.style.overflow = '';
    if (modalId === 'videoModal') {
        document.getElementById('videoPlayerContainer').innerHTML = '';
    }
}

function previewVideo(inputId, previewId) {
    var url = document.getElementById(inputId).value;
    var preview = document.getElementById(previewId);
    var embedUrl = null;

    if (url && (url.includes('youtube.com') || url.includes('youtu.be'))) {
        var videoId = null;
        if (url.includes('youtu.be/')) {
            var idx = url.lastIndexOf('youtu.be/');
            if (idx !== -1) {
                videoId = url.substring(idx + 9);
                var qIdx = videoId.indexOf('?');
                if (qIdx !== -1) videoId = videoId.substring(0, qIdx);
            }
        } else if (url.includes('v=')) {
            var idx = url.indexOf('v=');
            if (idx !== -1) {
                videoId = url.substring(idx + 2);
                var qIdx = videoId.indexOf('&');
                if (qIdx !== -1) videoId = videoId.substring(0, qIdx);
            }
        } else if (url.includes('embed/')) {
            var idx = url.lastIndexOf('embed/');
            if (idx !== -1) {
                videoId = url.substring(idx + 6);
                var qIdx = videoId.indexOf('?');
                if (qIdx !== -1) videoId = videoId.substring(0, qIdx);
            }
        }
        if (videoId) {
            embedUrl = 'https://www.youtube.com/embed/' + videoId;
        }
    } else if (url && (url.includes('facebook.com') || url.includes('fb.watch'))) {
        embedUrl = 'https://www.facebook.com/plugins/video.php?href=' + encodeURIComponent(url) + '&show_text=false&width=380&height=220';
    }

    if (embedUrl) {
        preview.innerHTML = '<iframe src="' + embedUrl + '" scrolling="no" frameborder="0" allowfullscreen="true" allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share" style="width:100%;height:100%;"></iframe>';
    } else {
        preview.innerHTML = '<span style="display:flex;align-items:center;gap:6px;"><span class="material-symbols-outlined" style="font-size:24px;">smart_display</span>Vista previa del video</span>';
    }
}

function openEditModal(id) {
    var card = document.querySelector('.rutina-card[data-id="' + id + '"]');
    if (!card) return;

    document.getElementById('editId').value = id;
    document.getElementById('editNombre').value = card.getAttribute('data-nombre') || '';
    document.getElementById('editObjetivo').value = card.getAttribute('data-objetivo') || '';
    document.getElementById('editSubcategoria').value = card.getAttribute('data-subcategoria') || '';
    document.getElementById('editUrl').value = card.getAttribute('data-url') || '';

    var catSelect = document.getElementById('editCategoria');
    var catValue = card.getAttribute('data-categoria') || '';
    var found = false;
    for (var i = 0; i < catSelect.options.length; i++) {
        if (catSelect.options[i].value === catValue) {
            catSelect.selectedIndex = i;
            found = true;
            break;
        }
    }
    if (!found) {
        catSelect.selectedIndex = 0;
    }

    var tp = document.getElementById('editTipoPiel');
    var tpVal = card.getAttribute('data-tipopiel') || '';
    for (var i = 0; i < tp.options.length; i++) { if (tp.options[i].value === tpVal) { tp.selectedIndex = i; break; } }

    var tc = document.getElementById('editTipoCabello');
    var tcVal = card.getAttribute('data-tipocabello') || '';
    for (var i = 0; i < tc.options.length; i++) { if (tc.options[i].value === tcVal) { tc.selectedIndex = i; break; } }

    var tnp = document.getElementById('editTonoPiel');
    var tnpVal = card.getAttribute('data-tonopiel') || '';
    for (var i = 0; i < tnp.options.length; i++) { if (tnp.options[i].value === tnpVal) { tnp.selectedIndex = i; break; } }

    var fc = document.getElementById('editFormaCara');
    var fcVal = card.getAttribute('data-formacara') || '';
    for (var i = 0; i < fc.options.length; i++) { if (fc.options[i].value === fcVal) { fc.selectedIndex = i; break; } }

    var tcr = document.getElementById('editTipoCuerpo');
    var tcrVal = card.getAttribute('data-tipocuerpo') || '';
    for (var i = 0; i < tcr.options.length; i++) { if (tcr.options[i].value === tcrVal) { tcr.selectedIndex = i; break; } }

    var fav = document.getElementById('editFavoritos');
    var favVal = card.getAttribute('data-favoritos') || 'false';
    fav.value = favVal;

    previewVideo('editUrl', 'editPreview');

    document.getElementById('editModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function confirmDelete(id, name) {
    document.getElementById('deleteId').value = id;
    document.getElementById('deleteRutinaName').textContent = name;
    document.getElementById('deleteModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function playVideo(url, title) {
    if (!url) {
        showToast('No hay video disponible', 'warning');
        return;
    }
    var embedUrl = null;
    if (url.includes('youtube.com') || url.includes('youtu.be')) {
        var videoId = null;
        if (url.includes('youtu.be/')) {
            var idx = url.lastIndexOf('youtu.be/');
            if (idx !== -1) {
                videoId = url.substring(idx + 9);
                var qIdx = videoId.indexOf('?');
                if (qIdx !== -1) videoId = videoId.substring(0, qIdx);
            }
        } else if (url.includes('v=')) {
            var idx = url.indexOf('v=');
            if (idx !== -1) {
                videoId = url.substring(idx + 2);
                var qIdx = videoId.indexOf('&');
                if (qIdx !== -1) videoId = videoId.substring(0, qIdx);
            }
        } else if (url.includes('embed/')) {
            var idx = url.lastIndexOf('embed/');
            if (idx !== -1) {
                videoId = url.substring(idx + 6);
                var qIdx = videoId.indexOf('?');
                if (qIdx !== -1) videoId = videoId.substring(0, qIdx);
            }
        }
        if (videoId) {
            embedUrl = 'https://www.youtube.com/embed/' + videoId + '?rel=0';
        }
    } else if (url.includes('facebook.com') || url.includes('fb.watch')) {
        embedUrl = 'https://www.facebook.com/plugins/video.php?href=' + encodeURIComponent(url) + '&show_text=false&width=800&height=450';
    }

    if (!embedUrl) {
        showToast('URL de video no soportada', 'warning');
        return;
    }

    document.getElementById('videoModalTitle').innerHTML = '<span class="material-symbols-outlined" style="font-size:18px;margin-right:6px;color:var(--accent-mint);">play_circle</span>' + (title || 'Ver Video');
    document.getElementById('videoPlayerContainer').innerHTML = '<iframe src="' + embedUrl + '" scrolling="no" frameborder="0" allowfullscreen="true" allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share" style="width:100%;height:100%;"></iframe>';
    document.getElementById('videoModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function toggleFavorito(id, btn) {
    var card = document.querySelector('.rutina-card[data-id="' + id + '"]');
    if (!card) return;
    var isFav = card.getAttribute('data-favoritos') === 'true';
    var newFav = isFav ? 'false' : 'true';

    var form = document.createElement('form');
    form.method = 'POST';
    form.action = '<%= ctx %>/rutinas';
    form.style.display = 'none';

    var actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = 'guardar';
    form.appendChild(actionInput);

    var idInput = document.createElement('input');
    idInput.type = 'hidden';
    idInput.name = 'id';
    idInput.value = id;
    form.appendChild(idInput);

    var favInput = document.createElement('input');
    favInput.type = 'hidden';
    favInput.name = 'favoritos';
    favInput.value = newFav;
    form.appendChild(favInput);

    var fields = ['nombre', 'objetivo', 'categoria', 'subcategoria', 'url', 'tipo_piel', 'tipo_cabello', 'tono_piel', 'forma_cara', 'tipo_cuerpo'];
    fields.forEach(function(field) {
        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = field;
        var attrName = field.replace(/_/g, '');
        input.value = card.getAttribute('data-' + attrName) || '';
        form.appendChild(input);
    });

    document.body.appendChild(form);
    form.submit();
}

function showToast(message, type) {
    type = type || 'success';
    var icons = { success: 'check_circle', error: 'error', warning: 'warning' };
    var container = document.getElementById('toastContainer');
    var toast = document.createElement('div');
    toast.className = 'toast-item ' + type;
    toast.innerHTML =
        '<div class="toast-icon">' +
        '<span class="material-symbols-outlined" style="font-size:16px;">' + icons[type] + '</span>' +
        '</div>' +
        '<span class="toast-text">' + message + '</span>';
    container.appendChild(toast);
    setTimeout(function() {
        toast.style.transition = 'all 0.4s ease';
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(120%)';
        setTimeout(function() { if (toast.parentNode) toast.parentNode.removeChild(toast); }, 400);
    }, 4000);
}

function updateCategoryCounts() {
    var counts = { maquillaje: 0, cuidado: 0, cabello: 0, cuerpo: 0 };

    document.querySelectorAll('.rutina-card').forEach(function(card) {
        var cat = card.getAttribute('data-cat');
        if (cat && counts[cat] !== undefined) {
            counts[cat]++;
        }
    });

    document.getElementById('countMaquillaje').textContent = counts.maquillaje;
    document.getElementById('countCuidado').textContent = counts.cuidado;
    document.getElementById('countCabello').textContent = counts.cabello;
    document.getElementById('countCuerpo').textContent = counts.cuerpo;

    var totalCards = document.querySelectorAll('.rutina-card').length;
    var totalEl = document.getElementById('countTotal');
    if (totalEl) totalEl.textContent = totalCards;
}

document.addEventListener('DOMContentLoaded', function() {
    updateCategoryCounts();
    applyFilters();

    document.querySelectorAll('.cat-chip').forEach(function(chip) {
        chip.addEventListener('click', function() {
            filterByCategory(this.getAttribute('data-cat'));
        });
    });

    document.querySelectorAll('.modal-overlay').forEach(function(overlay) {
        overlay.addEventListener('click', function(e) {
            if (e.target === overlay) closeModal(overlay.id);
        });
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-overlay.active').forEach(function(m) {
                closeModal(m.id);
            });
        }
    });

    setTimeout(function() {
        document.querySelectorAll('.toast-item').forEach(function(t) {
            t.style.transition = 'all 0.4s ease';
            t.style.opacity = '0';
            t.style.transform = 'translateX(120%)';
            setTimeout(function() { if (t.parentNode) t.parentNode.removeChild(t); }, 400);
        });
    }, 4000);
});


/* ===== SIDEBAR TOGGLE ===== */
let sidebarOpen = true;
function toggleSidebar() {
    const mainContent = document.getElementById('mainContent');
    sidebarOpen = !sidebarOpen;
    if (sidebarOpen) {
        mainContent.classList.remove('sidebar-closed');
        mainContent.classList.add('sidebar-open');
    } else {
        mainContent.classList.remove('sidebar-open');
        mainContent.classList.add('sidebar-closed');
    }
}
</script>
</body>
</html>