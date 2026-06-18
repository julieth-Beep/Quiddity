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
    String nombreUsuario = (usuario != null) ? usuario.getNombre() : "Usuario";
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
                if (idx != -1) { videoId = url.substring(idx + 9); int q = videoId.indexOf("?"); if (q != -1) videoId = videoId.substring(0, q); }
            } else if (url.contains("v=")) {
                int idx = url.indexOf("v=");
                if (idx != -1) { videoId = url.substring(idx + 2); int q = videoId.indexOf("&"); if (q != -1) videoId = videoId.substring(0, q); }
            } else if (url.contains("embed/")) {
                int idx = url.lastIndexOf("embed/");
                if (idx != -1) { videoId = url.substring(idx + 6); int q = videoId.indexOf("?"); if (q != -1) videoId = videoId.substring(0, q); }
            }
            if (videoId != null && !videoId.isEmpty()) return "https://www.youtube.com/embed/" + videoId;
            return null;
        }
        if (url.contains("facebook.com") || url.contains("fb.watch")) {
            try { return "https://www.facebook.com/plugins/video.php?href=" + java.net.URLEncoder.encode(url, "UTF-8") + "&show_text=false&width=380&height=220"; }
            catch (Exception e) { return null; }
        }
        return null;
    }
    private String getCategoriaClass(String cat) {
        if (cat == null) return "general";
        String c = cat.toLowerCase()
            .replaceAll("[\u00e1\u00e4\u00e2\u00e0]","a").replaceAll("[\u00e9\u00eb\u00ea\u00e8]","e")
            .replaceAll("[\u00ed\u00ef\u00ee\u00ec]","i").replaceAll("[\u00f3\u00f6\u00f4\u00f2]","o")
            .replaceAll("[\u00fa\u00fc\u00fb\u00f9]","u");
        if (c.contains("cuidado de la piel")) return "cuidado";
        if (c.contains("perfume")) return "perfumes";
        if (c.contains("cabello")) return "cabello";
        if (c.contains("corporal")) return "cuerpo";
        if (c.contains("maquillaje")) return "maquillaje";
        return "general";
    }
    private boolean esRecomendada(Rutina r, Caracteristicas c) {
        if (c == null) {
            return r.getTipoPiel() == null && r.getTipoCabello() == null &&
                   r.getTonoPiel() == null && r.getFormaCara() == null && r.getTipoCuerpo() == null;
        }
        boolean mp = r.getTipoPiel() == null || r.getTipoPiel().equalsIgnoreCase(c.getTipoPiel());
        boolean mc = r.getTipoCabello() == null || r.getTipoCabello().equalsIgnoreCase(c.getTipoCabello());
        boolean mt = r.getTonoPiel() == null || (c.getTonoPiel() != null && r.getTonoPiel().equalsIgnoreCase(c.getTonoPiel()));
        boolean mf = r.getFormaCara() == null || (c.getFormaCara() != null && r.getFormaCara().equalsIgnoreCase(c.getFormaCara()));
        boolean mb = r.getTipoCuerpo() == null || (c.getTipoCuerpo() != null && r.getTipoCuerpo().equalsIgnoreCase(c.getTipoCuerpo()));
        return mp || mc || mt || mf || mb;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mis Rutinas Beauty — Quiddity</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<style>
:root {
    --bg:#F8F9FA; --bg-soft:#FFFFFF; --surface:#FFFFFF;
    --text-primary:#1a1a2e; --text-secondary:#6c757d; --text-tertiary:#adb5bd;
    --border:#e9ecef; --border-light:#f1f3f5;
    --pastel-sky:#e3f2fd; --pastel-sky-dark:#bbdefb;
    --pastel-mint:#e8f5e9; --pastel-mint-dark:#c8e6c9;
    --pastel-lavender:#f3e5f5; --pastel-lavender-dark:#e1bee7;
    --pastel-cream:#fff3e0; --pastel-cream-dark:#ffe0b2;
    --pastel-coral:#fce4ec; --pastel-coral-dark:#f8bbd0;
    --accent-sky:#1976d2; --accent-mint:#388e3c; --accent-lavender:#7b1fa2;
    --accent-cream:#f57c00; --accent-coral:#c2185b;
    --radius-sm:12px; --radius-md:14px; --radius-lg:16px;
    --shadow-sm:0 1px 3px rgba(0,0,0,0.04);
    --shadow:0 2px 8px rgba(0,0,0,0.06);
    --shadow-md:0 4px 16px rgba(0,0,0,0.08);
    --shadow-lg:0 12px 32px rgba(0,0,0,0.12);
    --primary:#9a3a5a;
}
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--bg);color:var(--text-primary);-webkit-font-smoothing:antialiased;font-size:12px;line-height:1.4;overflow:hidden;height:100vh;}
.material-symbols-outlined{font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 24;vertical-align:middle;}
::-webkit-scrollbar{width:4px;}::-webkit-scrollbar-track{background:transparent;}::-webkit-scrollbar-thumb{background:var(--border);border-radius:2px;}

.layout-wrapper{display:flex;height:100vh;overflow:hidden;}
.main-content{flex:1;display:flex;flex-direction:column;height:100vh;overflow-y:auto;overflow-x:hidden;padding:16px 20px;gap:12px;transition:max-width 0.3s ease;}
.main-content.sidebar-open{max-width:calc(100% - 260px);}
.main-content.sidebar-closed{max-width:100%;}

/* WELCOME */
.welcome-section{display:flex;align-items:center;justify-content:space-between;background:var(--surface);border-radius:var(--radius-lg);padding:16px 20px;border:1px solid var(--border);box-shadow:var(--shadow-sm);animation:fadeUp 0.5s ease forwards;opacity:0;}
.welcome-title{font-family:'DM Sans',sans-serif;font-size:22px;font-weight:700;color:var(--text-primary);margin:0 0 3px 0;letter-spacing:-0.3px;}
.welcome-title span{color:var(--accent-lavender);}
.welcome-subtitle{font-size:12px;color:var(--text-secondary);font-weight:500;margin:0;}
.welcome-actions{display:flex;align-items:center;gap:10px;}

/* ALERTA PERFIL */
.perfil-alert{display:flex;align-items:center;gap:10px;background:var(--pastel-cream);border:1px solid var(--pastel-cream-dark);border-radius:var(--radius-md);padding:12px 16px;font-size:11px;font-weight:600;color:var(--accent-cream);}
.perfil-alert a{color:var(--accent-cream);text-decoration:underline;font-weight:700;}
.perfil-alert .material-symbols-outlined{font-size:18px;}

/* STATS */
.stats-bar{display:grid;grid-template-columns:repeat(6,1fr);gap:12px;}
.stat-item{background:var(--surface);border-radius:var(--radius-md);padding:14px 16px;box-shadow:var(--shadow-sm);border:1px solid var(--border-light);transition:all 0.3s ease;position:relative;overflow:hidden;cursor:pointer;display:flex;align-items:center;gap:12px;}
.stat-item:hover{transform:translateY(-3px);box-shadow:var(--shadow);border-color:var(--pastel-lavender-dark);}
.stat-item::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--accent-lavender);transform:scaleX(0);transform-origin:left;transition:transform 0.3s ease;}
.stat-item:hover::before{transform:scaleX(1);}
.stat-icon{width:40px;height:40px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0;}
.stat-icon.primary{background:var(--pastel-lavender);color:var(--accent-lavender);}
.stat-icon.mint{background:var(--pastel-mint);color:var(--accent-mint);}
.stat-icon.cream{background:var(--pastel-cream);color:var(--accent-cream);}
.stat-icon.coral{background:var(--pastel-coral);color:var(--accent-coral);}
.stat-icon.sky{background:var(--pastel-sky);color:var(--accent-sky);}
.stat-data h4{font-family:'DM Sans',sans-serif;font-size:22px;font-weight:700;color:var(--text-primary);line-height:1;margin-bottom:3px;letter-spacing:-0.5px;}
.stat-data p{font-size:9px;font-weight:700;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.06em;}

/* CHIPS */
.chips-section{position:sticky;top:0;z-index:40;background:var(--surface);border:1px solid var(--border-light);border-radius:var(--radius-md);box-shadow:var(--shadow-sm);}
.chips-container{padding:10px 14px;}
.chips-row{display:flex;gap:8px;overflow-x:auto;scrollbar-width:none;}
.chips-row::-webkit-scrollbar{display:none;}
.cat-chip{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border:1.5px solid var(--border);border-radius:var(--radius-sm);font-size:11px;font-weight:600;letter-spacing:0.06em;text-transform:uppercase;color:var(--text-secondary);cursor:pointer;transition:all 0.22s;background:var(--surface);white-space:nowrap;font-family:'Plus Jakarta Sans',sans-serif;}
.cat-chip:hover{border-color:var(--primary);color:var(--primary);background:var(--pastel-coral);}
.cat-chip.active{background:linear-gradient(135deg,var(--pastel-lavender),var(--pastel-sky));border-color:transparent;color:var(--accent-lavender);box-shadow:0 4px 12px rgba(123,31,162,0.15);}

/* TOOLBAR */
.toolbar{display:flex;justify-content:space-between;align-items:center;padding:12px 16px;background:var(--surface);border-radius:var(--radius-md);border:1px solid var(--border-light);box-shadow:var(--shadow-sm);}
.toolbar-left{display:flex;align-items:center;gap:16px;}
.toolbar-title-group h2{font-family:'DM Sans',sans-serif;font-size:16px;font-weight:700;color:var(--text-primary);margin-bottom:2px;letter-spacing:-0.3px;}
.toolbar-title-group p{font-size:11px;color:var(--text-tertiary);font-weight:600;}
.toolbar-right{display:flex;align-items:center;gap:10px;flex-wrap:wrap;}
.btn-toggle{display:inline-flex;align-items:center;gap:6px;padding:10px 18px;font-size:11px;font-weight:700;letter-spacing:0.06em;text-transform:uppercase;border:1.5px solid var(--border);border-radius:var(--radius-sm);cursor:pointer;transition:all 0.2s;background:var(--bg-soft);color:var(--text-secondary);font-family:'Plus Jakarta Sans',sans-serif;}
.btn-toggle:hover{border-color:var(--accent-coral);color:var(--accent-coral);background:var(--pastel-coral);}
.btn-toggle.active{background:var(--pastel-coral);color:var(--accent-coral);border-color:var(--pastel-coral-dark);}
.search-box{position:relative;width:240px;}
.search-box input{width:100%;padding:10px 14px 10px 38px;border:1.5px solid var(--border);border-radius:var(--radius-sm);font-size:12px;font-weight:500;color:var(--text-primary);background:var(--bg-soft);transition:all 0.2s;font-family:'Plus Jakarta Sans',sans-serif;}
.search-box input:focus{outline:none;border-color:var(--accent-sky);box-shadow:0 0 0 4px rgba(25,118,210,0.08);}
.search-box input::placeholder{color:var(--text-tertiary);}
.search-icon{position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--text-tertiary);font-size:16px;}
.filter-select{padding:10px 14px;border:1.5px solid var(--border);border-radius:var(--radius-sm);font-size:11px;font-weight:600;color:var(--text-primary);background:var(--bg-soft);cursor:pointer;transition:all 0.2s;min-width:130px;font-family:'Plus Jakarta Sans',sans-serif;}
.filter-select:focus{outline:none;border-color:var(--accent-sky);box-shadow:0 0 0 4px rgba(25,118,210,0.08);}

/* GRID */
.rutina-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:16px;}
.rutina-card{position:relative;background:var(--surface);border-radius:var(--radius-md);border:1px solid var(--border-light);box-shadow:var(--shadow-sm);overflow:hidden;transition:all 0.3s ease;display:flex;flex-direction:column;}
.rutina-card.recomendada{border-color:var(--pastel-mint-dark);box-shadow:0 0 0 1px var(--pastel-mint-dark);}
.rutina-card:hover{transform:translateY(-4px);box-shadow:var(--shadow-md);}

/* VIDEO */
.rutina-video{width:100%;height:200px;min-height:200px;max-height:200px;overflow:hidden;background:linear-gradient(135deg,#1a1a2e,#2d2d44);position:relative;flex-shrink:0;}
.rutina-video iframe{width:100%;height:100%;border:none;display:block;}
.rutina-video.no-video{display:flex;align-items:center;justify-content:center;}
.rutina-video.no-video::after{content:'smart_display';font-family:'Material Symbols Outlined';font-size:48px;color:rgba(255,255,255,0.3);}

/* BADGES */
.cat-badge{position:absolute;top:10px;left:10px;padding:5px 12px;border-radius:20px;font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:white;z-index:5;backdrop-filter:blur(8px);box-shadow:0 2px 8px rgba(0,0,0,0.15);}
.cat-badge.maquillaje{background:rgba(194,24,91,0.85);}
.cat-badge.cuidado{background:rgba(25,118,210,0.85);}
.cat-badge.perfumes{background:rgba(245,124,0,0.85);}
.cat-badge.cabello{background:rgba(56,142,60,0.85);}
.cat-badge.cuerpo{background:rgba(123,31,162,0.85);}
.cat-badge.general{background:rgba(96,125,139,0.85);}

.recomendada-badge{position:absolute;bottom:10px;left:10px;padding:4px 10px;border-radius:20px;font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:0.06em;color:white;z-index:5;background:rgba(56,142,60,0.9);box-shadow:0 2px 8px rgba(0,0,0,0.15);display:flex;align-items:center;gap:4px;}
.recomendada-badge .material-symbols-outlined{font-size:11px;font-variation-settings:'FILL' 1;}

.fav-btn-float{position:absolute;top:10px;right:10px;width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,0.95);backdrop-filter:blur(8px);display:flex;align-items:center;justify-content:center;cursor:pointer;transition:all 0.2s ease;z-index:5;box-shadow:0 2px 8px rgba(0,0,0,0.15);border:none;}
.fav-btn-float:hover{transform:scale(1.15);}
.fav-btn-float .material-symbols-outlined{font-size:18px;color:var(--accent-coral);font-variation-settings:'FILL' 1;}
.fav-btn-float.not-fav .material-symbols-outlined{color:var(--text-tertiary);font-variation-settings:'FILL' 0;}

/* OVERLAY */
.card-overlay{position:absolute;top:0;left:0;right:0;bottom:0;background:rgba(26,26,46,0.75);backdrop-filter:blur(3px);display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;opacity:0;transition:opacity 0.3s ease;z-index:4;}
.rutina-card:hover .card-overlay{opacity:1;}
.overlay-btn{display:flex;align-items:center;gap:6px;padding:9px 20px;font-size:10px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;border:none;border-radius:var(--radius-sm);cursor:pointer;transition:all 0.2s ease;min-width:140px;justify-content:center;font-family:'Plus Jakarta Sans',sans-serif;}
.overlay-btn.play{background:var(--pastel-mint);color:var(--accent-mint);}
.overlay-btn.play:hover{background:var(--accent-mint);color:white;}
.overlay-btn.fav{background:var(--pastel-coral);color:var(--accent-coral);}
.overlay-btn.fav:hover{background:var(--accent-coral);color:white;}

/* INFO */
.rutina-info{padding:14px 14px 10px;}
.rutina-category{font-size:9px;font-weight:700;color:var(--accent-lavender);text-transform:uppercase;letter-spacing:0.1em;margin-bottom:4px;}
.rutina-name{font-family:'DM Sans',sans-serif;font-size:14px;font-weight:700;color:var(--text-primary);line-height:1.3;margin-bottom:5px;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;letter-spacing:-0.2px;}
.rutina-objetivo{font-size:11px;color:var(--text-secondary);margin-bottom:10px;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;line-height:1.4;}
.rutina-caract{display:flex;flex-wrap:wrap;gap:4px;}
.caract-tag{display:inline-flex;align-items:center;gap:3px;padding:3px 8px;border-radius:10px;font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:0.04em;white-space:nowrap;}
.caract-tag.piel{background:var(--pastel-sky);color:var(--accent-sky);}
.caract-tag.cabello{background:var(--pastel-mint);color:var(--accent-mint);}
.caract-tag.tono{background:var(--pastel-cream);color:var(--accent-cream);}
.caract-tag.cara{background:var(--pastel-lavender);color:var(--accent-lavender);}
.caract-tag.cuerpo{background:var(--pastel-coral);color:var(--accent-coral);}
.caract-tag.universal{background:var(--border-light);color:var(--text-tertiary);}

/* FOOTER CARD */
.rutina-footer{display:flex;align-items:center;justify-content:space-between;padding:10px 14px;border-top:1px solid var(--border-light);background:var(--bg-soft);}
.rutina-meta{display:flex;align-items:center;gap:6px;font-size:10px;color:var(--text-tertiary);font-weight:600;}
.rutina-meta .material-symbols-outlined{font-size:14px;}
.rutina-footer-actions{display:flex;gap:6px;}
.icon-btn{width:28px;height:28px;border-radius:8px;border:1px solid var(--border-light);background:var(--surface);display:flex;align-items:center;justify-content:center;cursor:pointer;transition:all 0.2s ease;color:var(--text-tertiary);}
.icon-btn:hover{background:var(--pastel-sky);color:var(--accent-sky);border-color:var(--pastel-sky-dark);transform:scale(1.1);}
.icon-btn.fav-icon:hover{background:var(--pastel-coral);color:var(--accent-coral);border-color:var(--pastel-coral-dark);}
.icon-btn.fav-icon.active{background:var(--pastel-coral);color:var(--accent-coral);border-color:var(--pastel-coral-dark);}
.icon-btn.fav-icon.active .material-symbols-outlined{font-variation-settings:'FILL' 1;}

/* EMPTY STATE */
.empty-state{text-align:center;padding:60px 40px;grid-column:1/-1;background:var(--surface);border-radius:var(--radius-md);border:1px dashed var(--border);}
.empty-icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;background:linear-gradient(135deg,var(--pastel-lavender),var(--pastel-sky));display:flex;align-items:center;justify-content:center;color:var(--accent-lavender);font-size:28px;animation:floatIcon 3s ease-in-out infinite;}
@keyframes floatIcon{0%,100%{transform:translateY(0);}50%{transform:translateY(-8px);}}
.empty-state h4{font-family:'DM Sans',sans-serif;font-size:18px;font-weight:700;color:var(--text-primary);margin-bottom:6px;}
.empty-state p{font-size:12px;color:var(--text-secondary);}

/* MODAL */
.modal-overlay{position:fixed;inset:0;background:rgba(26,26,46,0.6);backdrop-filter:blur(8px);z-index:9998;display:none;align-items:center;justify-content:center;padding:20px;}
.modal-overlay.active{display:flex;animation:fadeIn 0.25s ease;}
@keyframes fadeIn{from{opacity:0;}to{opacity:1;}}
.modal-content{background:var(--surface);max-width:800px;width:100%;max-height:90vh;overflow-y:auto;box-shadow:var(--shadow-lg);border-radius:var(--radius-lg);animation:slideUp 0.35s cubic-bezier(0.34,1.56,0.64,1);border:1px solid var(--border-light);}
@keyframes slideUp{from{opacity:0;transform:translateY(24px) scale(0.97);}to{opacity:1;transform:translateY(0) scale(1);}}
.modal-header{padding:16px 20px;border-bottom:1px solid var(--border-light);display:flex;justify-content:space-between;align-items:center;}
.modal-header h3{font-family:'DM Sans',sans-serif;font-size:16px;font-weight:700;color:var(--text-primary);letter-spacing:-0.3px;}
.modal-close{width:32px;height:32px;border-radius:8px;border:1px solid var(--border-light);background:var(--bg-soft);cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all 0.2s ease;color:var(--text-tertiary);}
.modal-close:hover{background:var(--pastel-coral);color:var(--accent-coral);border-color:var(--pastel-coral-dark);transform:rotate(90deg);}
.video-player{width:100%;aspect-ratio:16/9;background:#000;overflow:hidden;}
.video-player iframe{width:100%;height:100%;border:none;}

/* TOAST */
.toast-container{position:fixed;top:24px;right:24px;z-index:9999;display:flex;flex-direction:column;gap:10px;pointer-events:none;}
.toast-item{background:var(--surface);border:1px solid var(--border-light);border-radius:var(--radius-md);padding:14px 20px;display:flex;align-items:center;gap:12px;box-shadow:var(--shadow-lg);animation:slideInToast 0.4s cubic-bezier(0.34,1.56,0.64,1);font-size:12px;font-weight:600;min-width:280px;pointer-events:auto;}
.toast-item.success{border-left:4px solid var(--accent-mint);}
.toast-item.error{border-left:4px solid var(--accent-coral);}
.toast-item.warning{border-left:4px solid var(--accent-cream);}
@keyframes slideInToast{from{transform:translateX(120%);opacity:0;}to{transform:translateX(0);opacity:1;}}
.toast-icon{width:28px;height:28px;border-radius:8px;display:flex;align-items:center;justify-content:center;flex-shrink:0;}
.toast-item.success .toast-icon{background:var(--pastel-mint);color:var(--accent-mint);}
.toast-item.error .toast-icon{background:var(--pastel-coral);color:var(--accent-coral);}
.toast-item.warning .toast-icon{background:var(--pastel-cream);color:var(--accent-cream);}

@keyframes fadeUp{from{opacity:0;transform:translateY(12px);}to{opacity:1;transform:translateY(0);}}
.anim-fade-up{animation:fadeUp 0.5s ease forwards;opacity:0;}
.delay-1{animation-delay:0.06s;}.delay-2{animation-delay:0.12s;}.delay-3{animation-delay:0.18s;}.delay-4{animation-delay:0.24s;}.delay-5{animation-delay:0.30s;}

@media(max-width:1280px){.stats-bar{grid-template-columns:repeat(3,1fr);}}
@media(max-width:1024px){.stats-bar{grid-template-columns:repeat(2,1fr);}.rutina-grid{grid-template-columns:repeat(2,1fr);}.main-content{padding:12px 16px;}}
@media(max-width:768px){.rutina-grid{grid-template-columns:1fr;}.stats-bar{grid-template-columns:repeat(2,1fr);}.toolbar{flex-direction:column;gap:12px;align-items:stretch;}.toolbar-right{flex-wrap:wrap;}.search-box{width:100%;}.welcome-section{flex-direction:column;gap:12px;text-align:center;}}
</style>
</head>
<body>

<div class="toast-container" id="toastContainer">
    <c:if test="${not empty param.success}">
        <div class="toast-item success"><div class="toast-icon"><span class="material-symbols-outlined" style="font-size:14px;">check_circle</span></div><span>${fn:escapeXml(param.success)}</span></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="toast-item error"><div class="toast-icon"><span class="material-symbols-outlined" style="font-size:14px;">error</span></div><span>${fn:escapeXml(param.error)}</span></div>
    </c:if>
</div>

<div class="layout-wrapper">
    <%@ include file="/includes/sidebar.jsp" %>
    <main class="main-content sidebar-open" id="mainContent">

        <!-- WELCOME -->
        <div class="welcome-section anim-fade-up">
            <div>
                <h1 class="welcome-title">Mis Rutinas <span>Beauty</span></h1>
                <p class="welcome-subtitle">Rutinas personalizadas según tu perfil y rutinas generales para todos</p>
            </div>
            <div class="welcome-actions">
                <button class="btn-toggle" id="btnFav" onclick="toggleFavoritesFilter(this)">
                    <span class="material-symbols-outlined" style="font-size:15px;">favorite</span> Mis Favoritas
                </button>
                <button class="btn-toggle" id="btnReco" onclick="toggleRecomendadasFilter(this)">
                    <span class="material-symbols-outlined" style="font-size:15px;">auto_awesome</span> Para mi perfil
                </button>
            </div>
        </div>

        <!-- ALERTA PERFIL INCOMPLETO -->
        <% if (perfilIncompleto) { %>
        <div class="perfil-alert anim-fade-up">
            <span class="material-symbols-outlined">info</span>
            <span>Aún no completaste tu perfil de características.
                <a href="<%= ctx %>/facefull">Complétalo aquí</a>
                para ver rutinas personalizadas según tu tipo de piel, cabello y más.
            </span>
        </div>
        <% } %>

        <!-- STATS -->
        <div class="stats-bar anim-fade-up delay-1">
            <div class="stat-item" onclick="filterByCategory('all')">
                <div class="stat-icon primary"><span class="material-symbols-outlined">auto_awesome</span></div>
                <div class="stat-data"><h4 id="countTotal"><%= rutinas.size() %></h4><p>Total</p></div>
            </div>
            <div class="stat-item" onclick="filterByCategory('maquillaje')">
                <div class="stat-icon coral"><span class="material-symbols-outlined">face_retouching_natural</span></div>
                <div class="stat-data"><h4 id="countMaquillaje">0</h4><p>Maquillaje</p></div>
            </div>
            <div class="stat-item" onclick="filterByCategory('cuidado')">
                <div class="stat-icon sky"><span class="material-symbols-outlined">spa</span></div>
                <div class="stat-data"><h4 id="countCuidado">0</h4><p>Cuidado Piel</p></div>
            </div>
            <div class="stat-item" onclick="filterByCategory('perfumes')">
                <div class="stat-icon cream"><span class="material-symbols-outlined">water_drop</span></div>
                <div class="stat-data"><h4 id="countPerfumes">0</h4><p>Perfumes</p></div>
            </div>
            <div class="stat-item" onclick="filterByCategory('cabello')">
                <div class="stat-icon mint"><span class="material-symbols-outlined">self_improvement</span></div>
                <div class="stat-data"><h4 id="countCabello">0</h4><p>Cabello</p></div>
            </div>
            <div class="stat-item" onclick="filterByCategory('cuerpo')">
                <div class="stat-icon primary"><span class="material-symbols-outlined">accessibility</span></div>
                <div class="stat-data"><h4 id="countCuerpo">0</h4><p>Corporal</p></div>
            </div>
        </div>

        <!-- CHIPS -->
        <div class="chips-section anim-fade-up delay-2">
            <div class="chips-container">
                <div class="chips-row">
                    <button class="cat-chip active" data-cat="all"><span class="material-symbols-outlined" style="font-size:14px;">auto_awesome</span> Todas</button>
                    <button class="cat-chip" data-cat="maquillaje"><span class="material-symbols-outlined" style="font-size:14px;">face_retouching_natural</span> Maquillaje</button>
                    <button class="cat-chip" data-cat="cuidado"><span class="material-symbols-outlined" style="font-size:14px;">spa</span> Cuidado de la Piel</button>
                    <button class="cat-chip" data-cat="perfumes"><span class="material-symbols-outlined" style="font-size:14px;">water_drop</span> Perfumes</button>
                    <button class="cat-chip" data-cat="cabello"><span class="material-symbols-outlined" style="font-size:14px;">self_improvement</span> Cabello</button>
                    <button class="cat-chip" data-cat="cuerpo"><span class="material-symbols-outlined" style="font-size:14px;">accessibility</span> Cuidado Corporal</button>
                </div>
            </div>
        </div>

        <!-- TOOLBAR -->
        <div class="toolbar anim-fade-up delay-2">
            <div class="toolbar-left">
                <div class="toolbar-title-group">
                    <h2 id="sectionTitle">Todas las Rutinas</h2>
                    <p id="rutinaCount"><%= rutinas.size() %> rutinas</p>
                </div>
            </div>
            <div class="toolbar-right">
                <div class="search-box">
                    <span class="material-symbols-outlined search-icon">search</span>
                    <input type="text" id="searchInput" placeholder="Buscar rutina..." oninput="applyFilters()">
                </div>
                <select class="filter-select" id="sortFilter" onchange="applyFilters()">
                    <option value="">Ordenar por</option>
                    <option value="nombre_asc">Nombre A-Z</option>
                    <option value="nombre_desc">Nombre Z-A</option>
                    <option value="recomendadas">Recomendadas primero</option>
                    <option value="favoritos">Favoritas primero</option>
                </select>
            </div>
        </div>

        <!-- GRID -->
        <div class="rutina-grid" id="rutinaGrid">
        <c:choose>
            <c:when test="${empty rutinas}">
                <div class="empty-state">
                    <div class="empty-icon"><span class="material-symbols-outlined" style="font-size:32px;">self_improvement</span></div>
                    <h4>No hay rutinas disponibles</h4>
                    <p><% if (perfilIncompleto) { %>Completa tu perfil para ver rutinas personalizadas.<% } else { %>Próximamente habrá rutinas para tu perfil.<% } %></p>
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
                        boolean esUniversal = rut.getTipoPiel() == null && rut.getTipoCabello() == null
                                           && rut.getTonoPiel() == null && rut.getFormaCara() == null
                                           && rut.getTipoCuerpo() == null;
                        boolean recomendada = esRecomendada(rut, caractUsuario);
                        pageContext.setAttribute("catClass", catClass);
                        pageContext.setAttribute("embedUrl", embedUrl);
                        pageContext.setAttribute("hasVideo", hasVideo);
                        pageContext.setAttribute("isFav", isFav);
                        pageContext.setAttribute("esUniversal", esUniversal);
                        pageContext.setAttribute("recomendada", recomendada);
                    %>
                    <div class="rutina-card anim-fade-up delay-${(status.index % 5) + 1} ${recomendada ? 'recomendada' : ''}"
                         data-id="${r.id}"
                         data-cat="${catClass}"
                         data-categoria="${fn:escapeXml(r.categoria)}"
                         data-nombre="${fn:escapeXml(r.nombre)}"
                         data-objetivo="${fn:escapeXml(r.objetivo)}"
                         data-url="${fn:escapeXml(r.url)}"
                         data-favoritos="${r.favoritos}"
                         data-recomendada="${recomendada}"
                         data-universal="${esUniversal}">

                        <div class="rutina-video ${hasVideo ? '' : 'no-video'}">
                            <c:if test="${hasVideo}">
                                <iframe src="${embedUrl}" scrolling="no" frameborder="0" allowfullscreen="true"
                                        allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share"></iframe>
                            </c:if>

                            <!-- Badge categoría -->
                            <div class="cat-badge ${catClass}"><%= rut.getCategoria() != null ? rut.getCategoria() : "General" %></div>

                            <!-- Badge recomendada / universal -->
                            <% if (recomendada && !esUniversal) { %>
                            <div class="recomendada-badge">
                                <span class="material-symbols-outlined">auto_awesome</span> Para ti
                            </div>
                            <% } else if (esUniversal) { %>
                            <div class="recomendada-badge" style="background:rgba(96,125,139,0.9);">
                                <span class="material-symbols-outlined">public</span> General
                            </div>
                            <% } %>

                            <!-- Botón favorito flotante -->
                            <button class="fav-btn-float <%= isFav ? "" : "not-fav" %>"
                                    onclick="event.stopPropagation(); toggleFavorito(${r.id}, this)"
                                    title="${isFav ? 'Quitar de favoritos' : 'Agregar a favoritos'}">
                                <span class="material-symbols-outlined">favorite</span>
                            </button>

                            <!-- Overlay hover -->
                            <div class="card-overlay">
                                <button class="overlay-btn play" onclick="event.stopPropagation(); playVideo('${fn:escapeXml(r.url)}', '${fn:escapeXml(r.nombre)}')">
                                    <span class="material-symbols-outlined" style="font-size:16px;">play_arrow</span> Ver Video
                                </button>
                                <button class="overlay-btn fav" onclick="event.stopPropagation(); toggleFavorito(${r.id}, null)">
                                    <span class="material-symbols-outlined" style="font-size:16px;">favorite</span>
                                    ${isFav ? 'Quitar favorito' : 'Agregar favorito'}
                                </button>
                            </div>
                        </div>

                        <div class="rutina-info">
                            <p class="rutina-category">${not empty r.subcategoria ? r.subcategoria : r.categoria}</p>
                            <h4 class="rutina-name">${r.nombre}</h4>
                            <p class="rutina-objetivo">${r.objetivo}</p>
                            <div class="rutina-caract">
                                <c:if test="${not empty r.tipoPiel}"><span class="caract-tag piel">${r.tipoPiel}</span></c:if>
                                <c:if test="${not empty r.tipoCabello}"><span class="caract-tag cabello">${r.tipoCabello}</span></c:if>
                                <c:if test="${not empty r.tonoPiel}"><span class="caract-tag tono">${r.tonoPiel}</span></c:if>
                                <c:if test="${not empty r.formaCara}"><span class="caract-tag cara">${r.formaCara}</span></c:if>
                                <c:if test="${not empty r.tipoCuerpo}"><span class="caract-tag cuerpo">${r.tipoCuerpo}</span></c:if>
                                <c:if test="${esUniversal}"><span class="caract-tag universal">Para todos</span></c:if>
                            </div>
                        </div>

                        <div class="rutina-footer">
                            <div class="rutina-meta">
                                <span class="material-symbols-outlined">${recomendada && !esUniversal ? 'person' : 'public'}</span>
                                ${recomendada && !esUniversal ? 'Personalizada' : 'General'}
                            </div>
                            <div class="rutina-footer-actions">
                                <button class="icon-btn" onclick="playVideo('${fn:escapeXml(r.url)}', '${fn:escapeXml(r.nombre)}')" title="Ver video">
                                    <span class="material-symbols-outlined" style="font-size:14px;">play_arrow</span>
                                </button>
                                <button class="icon-btn fav-icon <%= isFav ? "active" : "" %>"
                                        onclick="toggleFavorito(${r.id}, this)" title="Favorito">
                                    <span class="material-symbols-outlined" style="font-size:14px;">favorite</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </div>

        <!-- VIDEO MODAL -->
        <div class="modal-overlay" id="videoModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="videoModalTitle"><span class="material-symbols-outlined" style="font-size:18px;margin-right:6px;color:var(--accent-mint);">play_circle</span>Ver Video</h3>
                    <button class="modal-close" onclick="closeVideoModal()"><span class="material-symbols-outlined">close</span></button>
                </div>
                <div class="video-player" id="videoPlayer"></div>
            </div>
        </div>

    </main>
</div>

<script>
var activeCat = 'all';
var showFavOnly = false;
var showRecoOnly = false;

function filterByCategory(cat) {
    activeCat = cat;
    document.querySelectorAll('.cat-chip').forEach(function(c){ c.classList.remove('active'); });
    var chip = document.querySelector('.cat-chip[data-cat="' + cat + '"]');
    if (chip) chip.classList.add('active');
    var titles = { all:'Todas las Rutinas', maquillaje:'Maquillaje', cuidado:'Cuidado de la Piel', perfumes:'Perfumes', cabello:'Cabello', cuerpo:'Cuidado Corporal' };
    document.getElementById('sectionTitle').textContent = titles[cat] || 'Rutinas';
    applyFilters();
}

function toggleFavoritesFilter(btn) {
    showFavOnly = !showFavOnly;
    btn.classList.toggle('active', showFavOnly);
    applyFilters();
}

function toggleRecomendadasFilter(btn) {
    showRecoOnly = !showRecoOnly;
    btn.classList.toggle('active', showRecoOnly);
    applyFilters();
}

function applyFilters() {
    var search = document.getElementById('searchInput').value.toLowerCase().trim();
    var sort   = document.getElementById('sortFilter').value;
    var cards  = document.querySelectorAll('.rutina-card');
    var visible = 0;

    cards.forEach(function(card) {
        var cat       = card.getAttribute('data-cat') || '';
        var nombre    = (card.getAttribute('data-nombre') || '').toLowerCase();
        var objetivo  = (card.getAttribute('data-objetivo') || '').toLowerCase();
        var categoria = (card.getAttribute('data-categoria') || '').toLowerCase();
        var fav       = card.getAttribute('data-favoritos') === 'true';
        var reco      = card.getAttribute('data-recomendada') === 'true';
        var show = true;

        if (activeCat !== 'all' && cat !== activeCat) show = false;
        if (show && showFavOnly && !fav) show = false;
        if (show && showRecoOnly && !reco) show = false;
        if (show && search && !(nombre + ' ' + objetivo + ' ' + categoria).includes(search)) show = false;

        card.style.display = show ? '' : 'none';
        if (show) visible++;
    });

    document.getElementById('rutinaCount').textContent = visible + ' rutina' + (visible !== 1 ? 's' : '');
    updateCounts();
    if (sort) sortCards(sort);
}

function sortCards(sort) {
    var grid  = document.getElementById('rutinaGrid');
    var cards = Array.from(grid.querySelectorAll('.rutina-card')).filter(function(c){ return c.style.display !== 'none'; });
    cards.sort(function(a, b) {
        if (sort === 'nombre_asc')   return (a.getAttribute('data-nombre')||'').localeCompare(b.getAttribute('data-nombre')||'');
        if (sort === 'nombre_desc')  return (b.getAttribute('data-nombre')||'').localeCompare(a.getAttribute('data-nombre')||'');
        if (sort === 'recomendadas') return (b.getAttribute('data-recomendada')==='true'?1:0) - (a.getAttribute('data-recomendada')==='true'?1:0);
        if (sort === 'favoritos')    return (b.getAttribute('data-favoritos')==='true'?1:0) - (a.getAttribute('data-favoritos')==='true'?1:0);
        return 0;
    });
    cards.forEach(function(c){ grid.appendChild(c); });
}

function updateCounts() {
    var counts = { maquillaje:0, cuidado:0, perfumes:0, cabello:0, cuerpo:0 };
    document.querySelectorAll('.rutina-card').forEach(function(c){
        var cat = c.getAttribute('data-cat');
        if (counts[cat] !== undefined) counts[cat]++;
    });
    document.getElementById('countMaquillaje').textContent = counts.maquillaje;
    document.getElementById('countCuidado').textContent    = counts.cuidado;
    document.getElementById('countPerfumes').textContent   = counts.perfumes;
    document.getElementById('countCabello').textContent    = counts.cabello;
    document.getElementById('countCuerpo').textContent     = counts.cuerpo;
    document.getElementById('countTotal').textContent      = document.querySelectorAll('.rutina-card').length;
}

function toggleFavorito(id, btn) {
    var card = document.querySelector('.rutina-card[data-id="' + id + '"]');
    if (!card) return;
    var newFav = card.getAttribute('data-favoritos') !== 'true' ? 'true' : 'false';

    var form = document.createElement('form');
    form.method = 'POST';
    form.action = '<%= ctx %>/rutinas';
    form.style.display = 'none';
    [['action','favorito'],['id',id],['favoritos',newFav]].forEach(function(p){
        var i = document.createElement('input'); i.type='hidden'; i.name=p[0]; i.value=p[1]; form.appendChild(i);
    });
    document.body.appendChild(form);
    form.submit();
}

function playVideo(url, title) {
    if (!url) { showToast('No hay video disponible', 'warning'); return; }
    var embedUrl = null;
    if (url.includes('youtube.com') || url.includes('youtu.be')) {
        var videoId = null;
        if (url.includes('youtu.be/')) { var idx=url.lastIndexOf('youtu.be/'); if(idx!==-1){videoId=url.substring(idx+9);var q=videoId.indexOf('?');if(q!==-1)videoId=videoId.substring(0,q);} }
        else if (url.includes('v=')) { var idx=url.indexOf('v='); if(idx!==-1){videoId=url.substring(idx+2);var q=videoId.indexOf('&');if(q!==-1)videoId=videoId.substring(0,q);} }
        else if (url.includes('embed/')) { var idx=url.lastIndexOf('embed/'); if(idx!==-1){videoId=url.substring(idx+6);var q=videoId.indexOf('?');if(q!==-1)videoId=videoId.substring(0,q);} }
        if (videoId) embedUrl = 'https://www.youtube.com/embed/' + videoId + '?rel=0';
    } else if (url.includes('facebook.com') || url.includes('fb.watch')) {
        embedUrl = 'https://www.facebook.com/plugins/video.php?href=' + encodeURIComponent(url) + '&show_text=false&width=800&height=450';
    }
    if (!embedUrl) { showToast('URL de video no soportada', 'warning'); return; }
    document.getElementById('videoModalTitle').innerHTML = '<span class="material-symbols-outlined" style="font-size:18px;margin-right:6px;color:var(--accent-mint);">play_circle</span>' + (title || 'Ver Video');
    document.getElementById('videoPlayer').innerHTML = '<iframe src="' + embedUrl + '" scrolling="no" frameborder="0" allowfullscreen="true" allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share" style="width:100%;height:100%;"></iframe>';
    document.getElementById('videoModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function closeVideoModal() {
    document.getElementById('videoModal').classList.remove('active');
    document.getElementById('videoPlayer').innerHTML = '';
    document.body.style.overflow = '';
}

function showToast(message, type) {
    var icons = { success:'check_circle', error:'error', warning:'warning' };
    var t = document.createElement('div');
    t.className = 'toast-item ' + (type||'success');
    t.innerHTML = '<div class="toast-icon"><span class="material-symbols-outlined" style="font-size:14px;">' + icons[type||'success'] + '</span></div><span>' + message + '</span>';
    document.getElementById('toastContainer').appendChild(t);
    setTimeout(function(){ t.style.transition='all 0.4s'; t.style.opacity='0'; t.style.transform='translateX(120%)'; setTimeout(function(){ if(t.parentNode) t.parentNode.removeChild(t); },400); }, 4000);
}

document.addEventListener('DOMContentLoaded', function() {
    updateCounts();
    applyFilters();
    document.querySelectorAll('.cat-chip').forEach(function(chip){
        chip.addEventListener('click', function(){ filterByCategory(this.getAttribute('data-cat')); });
    });
    document.getElementById('videoModal').addEventListener('click', function(e){ if(e.target===this) closeVideoModal(); });
    document.addEventListener('keydown', function(e){ if(e.key==='Escape') closeVideoModal(); });
    setTimeout(function(){
        document.querySelectorAll('.toast-item').forEach(function(t){
            t.style.transition='all 0.4s'; t.style.opacity='0'; t.style.transform='translateX(120%)';
            setTimeout(function(){ if(t.parentNode) t.parentNode.removeChild(t); },400);
        });
    }, 4000);
});

let sidebarOpen = true;
function toggleSidebar() {
    const mc = document.getElementById('mainContent');
    sidebarOpen = !sidebarOpen;
    mc.classList.toggle('sidebar-open', sidebarOpen);
    mc.classList.toggle('sidebar-closed', !sidebarOpen);
}
</script>
</body>
</html>