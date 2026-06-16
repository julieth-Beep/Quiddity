<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.quiddity.model.Catalogo" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String ctx = request.getContextPath();
    Object usuario = session.getAttribute("usuario");
    String nombreUsuario = "Administrador";
    if (usuario != null) {
        try { nombreUsuario = (String) usuario.getClass().getMethod("getNombre").invoke(usuario); } catch (Exception e) { }
    }
%>
<%!
    // Función para quitar acentos y pasar a minúsculas (compatible con Java 7)
    private String normalize(String input) {
        if (input == null) return "";
        String str = input.toLowerCase();
        str = str.replaceAll("[áäâà]", "a")
                 .replaceAll("[éëêè]", "e")
                 .replaceAll("[íïîì]", "i")
                 .replaceAll("[óöôò]", "o")
                 .replaceAll("[úüûù]", "u")
                 .replaceAll("[ñ]", "n")
                 .replaceAll("[ýÿ]", "y")
                 .replaceAll("[ç]", "c");
        return str;
    }

    private String determinarCategoria(Catalogo p) {
        String catBD = p.getCategoria() != null ? normalize(p.getCategoria()) : "";
        String nombre = normalize(p.getNombre());
        String desc = p.getDescripcion() != null ? normalize(p.getDescripcion()) : "";
        String img = p.getImagen() != null ? normalize(p.getImagen()) : "";
        String texto = catBD + " " + nombre + " " + desc + " " + img;

        if (texto.contains("belleza") || texto.contains("brocha") || texto.contains("maquillaje") ||
            texto.contains("esponja") || texto.contains("base") || texto.contains("rubor") ||
            texto.contains("labial")) return "belleza";

        if (texto.contains("cuidado") || texto.contains("skincare") || texto.contains("serum") ||
            texto.contains("crema") || texto.contains("mascarilla") || texto.contains("facial") ||
            texto.contains("corporal") || texto.contains("tonico") || texto.contains("exfoliante")) return "cuidado";

        if (texto.contains("perfume") || texto.contains("fragancia") || texto.contains("edt") ||
            texto.contains("edp") || texto.contains("vetiver") || texto.contains("rose")) return "perfumes";

        if (texto.contains("cabello") || texto.contains("shampoo") || texto.contains("acondicionador") ||
            texto.contains("capilar") || texto.contains("keratina")) return "cabello";

        return "belleza";
    }

    private String determinarSubcat(Catalogo p) {
        String nombre = normalize(p.getNombre());
        String desc = p.getDescripcion() != null ? normalize(p.getDescripcion()) : "";
        String img = p.getImagen() != null ? normalize(p.getImagen()) : "";
        String texto = nombre + " " + desc + " " + img;

        /* Belleza */
        if (texto.contains("brocha") || texto.contains("pincel")) return "brochas";
        if (texto.contains("esponja") || texto.contains("blender")) return "esponjas";
        if (texto.contains("base") || texto.contains("paleta") || texto.contains("sombras") ||
            texto.contains("corrector") || texto.contains("rubor") || texto.contains("labial")) return "maquillaje";

        /* Cuidado Facial */
        if (texto.contains("mascarilla") || texto.contains("mask") || texto.contains("arcilla")) return "mascarillas";
        if (texto.contains("serum") || texto.contains("elixir") || texto.contains("vitamina c")) return "serums";
        if (texto.contains("hidratante") || texto.contains("crema") || texto.contains("moisturizer")) return "hidratantes";
        if (texto.contains("tonico") || texto.contains("toner") || texto.contains("micelar")) return "tonicos";
        if (texto.contains("exfoliante") || texto.contains("scrub") || texto.contains("enzima")) return "exfoliantes";

        /* Cuidado Corporal */
        if (texto.contains("exfoliante corporal") || texto.contains("body scrub")) return "exfoliantes-corp";
        if (texto.contains("locion") || texto.contains("manteca") || texto.contains("butter")) return "lociones";
        if (texto.contains("aceite corporal") || texto.contains("body oil") || texto.contains("anticelulitis")) return "aceites-corp";
        if (texto.contains("tratamiento corporal") || texto.contains("reafirmante")) return "tratamientos-corp";

        /* Perfumes */
        if (texto.contains("edt") || texto.contains("eau de toilette")) return "edt";
        if (texto.contains("edp") || texto.contains("eau de parfum") || texto.contains("parfum")) return "edp";
        if (texto.contains("set") || texto.contains("cofre") || texto.contains("discovery")) return "sets-olfativos";

        /* Cabello */
        if (texto.contains("shampoo") || texto.contains("acondicionador")) return "shampoos";
        if (texto.contains("mascarilla capilar") || texto.contains("hair mask")) return "mascarillas-capilar";
        if (texto.contains("aceite capilar") || texto.contains("serum capilar") || texto.contains("argan")) return "aceites-capilares";

        return "";
    }

    private String determinarGrupo(String subcat, String categoriaBD) {
        if (subcat == null || subcat.isEmpty()) return null;
        String s = subcat.toLowerCase();
        if ("mascarillas".equals(s) || "serums".equals(s) || "hidratantes".equals(s) ||
            "tonicos".equals(s) || "exfoliantes".equals(s)) return "facial";
        if ("exfoliantes-corp".equals(s) || "lociones".equals(s) ||
            "aceites-corp".equals(s) || "tratamientos-corp".equals(s)) return "corporal";
        return null;
    }

    private String formatearSubcatLabel(String subcat) {
        if (subcat == null || subcat.isEmpty()) return "";
        String[] parts = subcat.split("-");
        String last = parts[parts.length-1];
        return last.substring(0,1).toUpperCase() + last.substring(1).replace("-"," ");
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Catálogo Admin — Quiddity</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&family=EB+Garamond:ital,wght@0,400..800;1,400..800&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<style>
/* ========== ESTILOS COMPLETOS (sin cambios) ========== */
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
    --accent-sky: #1976d2; --accent-mint: #388e3c; --accent-lavender: #7b1fa2;
    --accent-cream: #f57c00; --accent-coral: #c2185b; --accent-sage: #689f38;
    --success: #388e3c; --warning: #f57c00; --error: #c2185b;
    --radius-sm: 12px; --radius-md: 14px; --radius-lg: 16px;
    --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
    --shadow: 0 2px 8px rgba(0,0,0,0.06);
    --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
    --shadow-lg: 0 12px 32px rgba(0,0,0,0.12);
    --primary:#9a3a5a; --primary-dark:#7a2e48;
    --on-surface:#1c1b1d; --on-surface-variant:#544246; --outline:#877276;
}
* { margin:0; padding:0; box-sizing:border-box; }
body {
    font-family: 'Plus Jakarta Sans', sans-serif;
    background: var(--bg); color: var(--text-primary);
    -webkit-font-smoothing: antialiased; font-size: 12px; line-height: 1.4;
}
.material-symbols-outlined { font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 24; vertical-align: middle; }
::-webkit-scrollbar { width:4px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

.layout-wrapper { display:flex; min-height:100vh; }
.main-content { flex:1; display:flex; flex-direction:column; min-height:100vh; overflow-x:hidden; padding: 16px 20px; gap: 12px; }

/* WELCOME */
.welcome-section {
    display: flex; align-items: center; justify-content: space-between;
    background: var(--surface); border-radius: var(--radius-lg); padding: 16px 20px;
    border: 1px solid var(--border); box-shadow: var(--shadow-sm);
    animation: fadeUp 0.5s ease forwards; opacity: 0;
}
.welcome-content { flex: 1; }
.welcome-title { font-family: 'DM Sans', sans-serif; font-size: 22px; font-weight: 700; color: var(--text-primary); margin: 0 0 3px 0; letter-spacing: -0.3px; }
.welcome-title span { color: var(--accent-sky); }
.welcome-subtitle { font-size: 12px; color: var(--text-secondary); font-weight: 500; margin: 0; }
.welcome-actions { display: flex; align-items: center; gap: 10px; }

/* STATS BAR */
.stats-bar { display: grid; grid-template-columns: repeat(5, 1fr); gap: 12px; }
.stat-item {
    background: var(--surface); border-radius: var(--radius-md); padding: 14px 16px;
    box-shadow: var(--shadow-sm); border: 1px solid var(--border-light);
    transition: all 0.3s ease; position: relative; overflow: hidden; cursor: pointer;
    display: flex; align-items: center; gap: 12px;
}
.stat-item:hover { transform: translateY(-3px); box-shadow: var(--shadow); border-color: var(--pastel-sky-dark); }
.stat-item::before {
    content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px;
    background: var(--accent-coral); transform: scaleX(0); transform-origin: left; transition: transform 0.3s ease;
}
.stat-item:hover::before { transform: scaleX(1); }
.stat-icon {
    width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center;
    font-size: 18px; flex-shrink: 0; transition: all 0.3s ease;
}
.stat-item:hover .stat-icon { transform: scale(1.1); }
.stat-icon.primary { background: var(--pastel-coral); color: var(--accent-coral); }
.stat-icon.mint { background: var(--pastel-mint); color: var(--accent-mint); }
.stat-icon.cream { background: var(--pastel-cream); color: var(--accent-cream); }
.stat-icon.coral { background: var(--pastel-coral); color: var(--accent-coral); }
.stat-icon.lavender { background: var(--pastel-lavender); color: var(--accent-lavender); }
.stat-data h4 { font-family: 'DM Sans', sans-serif; font-size: 22px; font-weight: 700; color: var(--text-primary); line-height: 1; margin-bottom: 3px; letter-spacing: -0.5px; }
.stat-data p { font-size: 9px; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.06em; }

/* CHIPS */
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
.subcat-chip {
    display: inline-flex; align-items: center; padding: 6px 12px;
    border: 1px solid var(--border-light); border-radius: var(--radius-sm);
    font-size: 10px; font-weight: 600; letter-spacing: 0.06em; text-transform: uppercase;
    color: var(--text-tertiary); cursor: pointer; transition: all 0.2s;
    background: transparent; white-space: nowrap; font-family: 'Plus Jakarta Sans', sans-serif;
}
.subcat-chip:hover { border-color: var(--primary); color: var(--primary); background: var(--pastel-coral); }
.subcat-chip.active { background: var(--pastel-sky); border-color: var(--accent-sky); color: var(--accent-sky); }
.chips-divider { height: 1px; background: var(--border-light); margin: 6px 0; }

/* TOOLBAR */
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
.btn-action.toggle-btn.active { background: var(--pastel-lavender); color: var(--accent-lavender); border-color: var(--pastel-lavender-dark); }
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

/* PRODUCTS SECTION */
.products-section { display: flex; flex-direction: column; gap: 12px; }

/* CATEGORIES PANEL */
.categories-panel {
    background: var(--surface); border: 1px solid var(--border-light);
    border-radius: var(--radius-md); padding: 16px; box-shadow: var(--shadow-sm);
    transition: all 0.3s ease; display: none;
}
.categories-panel:hover { box-shadow: var(--shadow); border-color: var(--border); }
.categories-panel h3 {
    font-family: 'DM Sans', sans-serif; font-size: 14px; font-weight: 700; color: var(--text-primary);
    margin-bottom: 14px; display: flex; align-items: center; gap: 8px;
}
.categories-panel h3::before { content: ''; width: 3px; height: 14px; border-radius: 2px; background: var(--accent-sky); flex-shrink: 0; }
.cat-tree { display: flex; flex-direction: column; gap: 10px; }
.cat-tree-item { border-left: 2px solid var(--border-light); padding-left: 14px; }
.cat-tree-header { display: flex; align-items: center; gap: 8px; padding: 6px 0; cursor: pointer; }
.cat-tree-header h4 { font-family: 'DM Sans', sans-serif; font-size: 13px; font-weight: 700; color: var(--text-primary); }
.cat-tree-header .count { font-size: 10px; font-weight: 700; color: var(--accent-sky); background: var(--pastel-sky); padding: 2px 8px; border-radius: 10px; margin-left: auto; }
.cat-tree-children { display: flex; flex-direction: column; gap: 4px; padding-left: 14px; margin-top: 4px; }
.cat-tree-child {
    display: flex; align-items: center; gap: 6px; padding: 5px 10px;
    font-size: 11px; color: var(--text-secondary); cursor: pointer;
    transition: all 0.15s; border-radius: var(--radius-sm); font-weight: 600;
}
.cat-tree-child:hover { background: var(--bg); color: var(--accent-sky); }
.cat-tree-child .child-count { font-size: 9px; font-weight: 700; color: var(--text-tertiary); margin-left: auto; }
.cat-group-label { font-weight: 700; font-size: 11px; color: var(--text-primary); padding: 4px 10px 2px; text-transform: uppercase; letter-spacing: 0.05em; }

/* STATS PANEL */
.stats-panel {
    background: var(--surface); border: 1px solid var(--border-light);
    border-radius: var(--radius-md); padding: 16px; box-shadow: var(--shadow-sm);
    transition: all 0.3s ease; display: none;
}
.stats-panel:hover { box-shadow: var(--shadow); border-color: var(--border); }
.stats-panel h3 {
    font-family: 'DM Sans', sans-serif; font-size: 14px; font-weight: 700; color: var(--text-primary);
    margin-bottom: 14px; display: flex; align-items: center; gap: 8px;
}
.stats-panel h3::before { content: ''; width: 3px; height: 14px; border-radius: 2px; background: var(--accent-coral); flex-shrink: 0; }
.stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
.stat-box {
    padding: 14px; background: var(--bg); border-radius: var(--radius-sm);
    transition: all 0.3s ease; border: 1px solid var(--border-light);
}
.stat-box:hover { transform: translateY(-2px); box-shadow: var(--shadow-sm); border-color: var(--border); }
.stat-box h5 { font-size: 9px; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 8px; }
.stat-box .big-number { font-family: 'DM Sans', sans-serif; font-size: 24px; font-weight: 700; color: var(--text-primary); line-height: 1; letter-spacing: -0.5px; }
.stat-box .stat-desc { font-size: 10px; color: var(--text-tertiary); margin-top: 4px; font-weight: 600; }

/* TOP VENDIDOS LIST */
.top-list { margin-top: 12px; display: flex; flex-direction: column; gap: 6px; max-height: 240px; overflow-y: auto; }
.top-list-item {
    display: flex; align-items: center; gap: 8px; padding: 8px 10px;
    background: var(--surface); border-radius: var(--radius-sm); border: 1px solid var(--border-light);
    font-size: 11px; font-weight: 600;
}
.top-list-rank { width: 20px; height: 20px; border-radius: 6px; background: var(--pastel-sky); color: var(--accent-sky); display: flex; align-items: center; justify-content: center; font-size: 10px; font-weight: 700; flex-shrink: 0; }
.top-list-rank.gold { background: var(--pastel-cream); color: var(--accent-cream); }
.top-list-rank.silver { background: var(--pastel-lavender); color: var(--accent-lavender); }
.top-list-rank.bronze { background: var(--pastel-coral); color: var(--accent-coral); }
.top-list-name { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; color: var(--text-primary); }
.top-list-ventas { font-size: 10px; color: var(--text-secondary); font-weight: 700; flex-shrink: 0; }

/* ===== PRODUCT GRID - CARDS MAS PEQUEÑAS ===== */
.product-grid { 
    display: grid; 
    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); 
    gap: 16px; 
}
.product-card {
    position: relative;
    background: var(--surface); border-radius: var(--radius-md);
    border: 1px solid var(--border-light); box-shadow: var(--shadow-sm);
    overflow: hidden; transition: all 0.3s ease;
    display: flex; flex-direction: column;
}
.product-card:hover { 
    transform: translateY(-4px); 
    box-shadow: var(--shadow-md); 
    border-color: var(--border); 
}
.product-image { 
    width: 100%; 
    height: 220px; 
    min-height: 220px;
    max-height: 220px;
    overflow: hidden; 
    background: linear-gradient(135deg, #f5f5f5, #e8e8e8); 
    position: relative;
    flex-shrink: 0;
}
.product-image img { 
    width: 100%; 
    height: 100%; 
    object-fit: cover; 
    transition: transform 0.6s ease; 
    display: block;
}
.product-card:hover .product-image img { transform: scale(1.05); }
.product-image.no-image {
    display: flex; align-items: center; justify-content: center;
    background: linear-gradient(135deg, #f0f0f0, #e0e0e0);
}
.product-image.no-image::after {
    content: 'image';
    font-family: 'Material Symbols Outlined';
    font-size: 48px;
    color: #ccc;
}

/* STOCK INDICATOR */
.stock-indicator {
    position: absolute; bottom: 8px; left: 8px; right: 8px;
    display: flex; align-items: center; gap: 6px; padding: 5px 8px;
    background: rgba(255,255,255,0.95); backdrop-filter: blur(8px);
    font-size: 10px; font-weight: 700; z-index: 2;
    border-radius: 6px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}
.stock-indicator .stock-bar {
    flex: 1; height: 3px; background: var(--border-light);
    position: relative; border-radius: 2px;
}
.stock-indicator .stock-bar-fill {
    position: absolute; left: 0; top: 0; height: 100%; border-radius: 2px;
}
.stock-indicator .stock-bar-fill.high  { background: var(--accent-mint); }
.stock-indicator .stock-bar-fill.medium { background: var(--accent-cream); }
.stock-indicator .stock-bar-fill.low   { background: var(--accent-coral); }
.stock-indicator .stock-bar-fill.out   { background: var(--text-primary); }

.stock-strip {
    position: absolute; bottom: 0; left: 0; right: 0;
    padding: 8px 10px; background: rgba(255,255,255,0.97); backdrop-filter: blur(8px);
    display: flex; align-items: center; gap: 8px; z-index: 3;
    border-top: 1px solid var(--border-light);
    transition: all 0.25s ease;
}
.stock-strip .stock-label { font-size: 9px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; flex-shrink: 0; }
.stock-strip .stock-bar { flex: 1; height: 3px; background: var(--border-light); border-radius: 2px; position: relative; overflow: hidden; }
.stock-strip .stock-bar-fill { position: absolute; left:0; top:0; height:100%; border-radius:2px; transition: width 0.4s ease; }
.stock-strip .stock-bar-fill.high { background: var(--accent-mint); }
.stock-strip .stock-bar-fill.medium { background: var(--accent-cream); }
.stock-strip .stock-bar-fill.low { background: var(--accent-coral); }
.stock-strip .stock-qty { font-size: 10px; font-weight: 700; flex-shrink: 0; cursor: pointer; padding: 2px 6px; border-radius: 6px; transition: background 0.15s; }
.stock-strip .stock-qty:hover { background: var(--pastel-sky); }
.stock-strip .stock-qty.green { color: var(--accent-mint); }
.stock-strip .stock-qty.yellow { color: var(--accent-cream); }
.stock-strip .stock-qty.red { color: var(--accent-coral); }
.stock-strip.editing { padding: 10px 12px; justify-content: center; background: var(--surface); }
.inline-stock-editor { display: none; align-items: center; gap: 6px; }
.stock-strip.editing .inline-stock-editor { display: flex; }
.stock-strip.editing .stock-bar, .stock-strip.editing .stock-label { display: none; }
.stock-strip.editing .stock-qty { display: none; }
.inline-stock-btn {
    width: 26px; height: 26px; border-radius: 8px; border: 1.5px solid var(--border);
    background: var(--bg-soft); display: flex; align-items: center; justify-content: center;
    cursor: pointer; transition: all 0.15s; font-size: 14px; color: var(--text-secondary);
    font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 700; line-height: 1;
}
.inline-stock-btn:hover { background: var(--pastel-sky); color: var(--accent-sky); border-color: var(--pastel-sky-dark); transform: scale(1.1); }
.inline-stock-btn.confirm { background: var(--pastel-mint); color: var(--accent-mint); border-color: var(--pastel-mint-dark); font-size: 12px; }
.inline-stock-btn.confirm:hover { background: var(--accent-mint); color: white; }
.inline-stock-btn.cancel-edit { background: var(--pastel-coral); color: var(--accent-coral); border-color: var(--pastel-coral-dark); font-size: 12px; }
.inline-stock-btn.cancel-edit:hover { background: var(--accent-coral); color: white; }
.inline-stock-input {
    width: 52px; text-align: center; padding: 5px 6px;
    border: 1.5px solid var(--accent-sky); border-radius: 8px;
    font-size: 14px; font-weight: 700; color: var(--accent-sky);
    background: var(--bg-soft); font-family: 'DM Sans', sans-serif;
}
.inline-stock-input:focus { outline: none; box-shadow: 0 0 0 3px rgba(25,118,210,0.1); }
.product-overlay {
    position: absolute; top: 0; left: 0; right: 0; bottom: 52px;
    background: rgba(26, 26, 46, 0.75); backdrop-filter: blur(4px);
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    gap: 8px; opacity: 0; transition: opacity 0.3s ease; z-index: 5;
}
.product-card:hover .product-overlay { opacity: 1; }
.overlay-btn {
    display: flex; align-items: center; gap: 6px; padding: 8px 16px;
    font-size: 10px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase;
    border: none; border-radius: var(--radius-sm); cursor: pointer; transition: all 0.2s ease;
    min-width: 130px; justify-content: center; font-family: 'Plus Jakarta Sans', sans-serif;
}
.overlay-btn.edit { background: var(--surface); color: var(--text-primary); }
.overlay-btn.edit:hover { background: var(--pastel-sky); color: var(--accent-sky); }
.overlay-btn.toggle-btn { background: transparent; color: white; border: 1px solid rgba(255,255,255,0.3); }
.overlay-btn.toggle-btn:hover { background: var(--pastel-cream); color: var(--accent-cream); border-color: var(--pastel-cream); }
.overlay-btn.delete { background: transparent; color: var(--pastel-coral-dark); border: 1px solid var(--pastel-coral-dark); }
.overlay-btn.delete:hover { background: var(--accent-coral); color: white; border-color: var(--accent-coral); }
.product-info { display: flex; justify-content: space-between; align-items: flex-start; padding: 12px 12px 10px; }
.product-info-left { flex: 1; min-width: 0; }
.product-category { font-size: 9px; font-weight: 700; color: var(--text-tertiary); text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 4px; }
.product-name { font-family: 'DM Sans', sans-serif; font-size: 13px; font-weight: 700; color: var(--text-primary); line-height: 1.3; margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; letter-spacing: -0.2px; }
.product-price { font-size: 12px; font-weight: 700; color: var(--accent-coral); }
.product-actions { display: flex; flex-direction: column; gap: 4px; }
.action-btn-sm {
    width: 28px; height: 28px; border-radius: 8px; border: 1px solid var(--border-light);
    background: var(--bg-soft); display: flex; align-items: center; justify-content: center;
    cursor: pointer; transition: all 0.2s ease; color: var(--text-tertiary); font-size: 12px;
}
.action-btn-sm:hover { background: var(--pastel-sky); color: var(--accent-sky); border-color: var(--pastel-sky-dark); transform: scale(1.1); }
.action-btn-sm.delete:hover { background: var(--pastel-coral); color: var(--accent-coral); border-color: var(--pastel-coral-dark); }
.action-btn-sm.toggle:hover { background: var(--pastel-cream); color: var(--accent-cream); border-color: var(--pastel-cream-dark); }

/* MODALS */
.modal-overlay {
    position: fixed; inset: 0; background: rgba(26, 26, 46, 0.6); backdrop-filter: blur(8px);
    z-index: 9998; display: none; align-items: center; justify-content: center;
    padding: 20px;
}
.modal-overlay.active { display: flex; animation: fadeIn 0.25s ease; }
@keyframes fadeIn { from{opacity:0;} to{opacity:1;} }
.modal-content {
    background: var(--surface); max-width: 720px; width: 100%; max-height: 90vh; overflow-y: auto;
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
.image-preview {
    width: 100%; aspect-ratio: 4/3; background: var(--bg); display: flex; align-items: center; justify-content: center;
    color: var(--text-tertiary); font-size: 12px; overflow: hidden; margin-top: 6px;
    border-radius: var(--radius-sm); border: 1px dashed var(--border);
}
.image-preview img { width: 100%; height: 100%; object-fit: cover; }
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
.btn-modal.export-csv { background: var(--pastel-mint); color: var(--accent-mint); border: 1px solid var(--pastel-mint-dark); }
.btn-modal.export-csv:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(56,142,60,0.18); }

/* TOAST */
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

/* EMPTY STATE */
.empty-state {
    text-align: center; padding: 60px 40px; grid-column: 1 / -1;
    background: var(--surface); border-radius: var(--radius-md); border: 1px dashed var(--border);
}
.empty-state-icon {
    width: 64px; height: 64px; margin: 0 auto 16px; border-radius: 50%;
    background: linear-gradient(135deg, var(--pastel-coral), var(--pastel-lavender));
    display: flex; align-items: center; justify-content: center;
    color: var(--accent-coral); font-size: 28px; animation: floatIcon 3s ease-in-out infinite;
}
@keyframes floatIcon { 0%,100%{transform:translateY(0);} 50%{transform:translateY(-8px);} }
.empty-state h4 { font-family: 'DM Sans', sans-serif; font-size: 18px; font-weight: 700; color: var(--text-primary); margin-bottom: 6px; letter-spacing: -0.3px; }
.empty-state p { font-size: 12px; color: var(--text-secondary); margin-bottom: 16px; }

/* DELETE TYPE RADIOS */
.delete-type-options { display: flex; gap: 8px; justify-content: center; flex-wrap: wrap; }
.delete-type-label {
    display: flex; align-items: center; gap: 6px; font-size: 10px; cursor: pointer;
    padding: 8px 14px; border: 1.5px solid var(--border); border-radius: var(--radius-sm);
    background: var(--bg-soft); font-weight: 600; transition: all 0.2s;
}
.delete-type-label:has(input:checked) { border-color: var(--accent-coral); background: var(--pastel-coral); color: var(--accent-coral); }
.delete-type-label.soft:has(input:checked) { border-color: var(--accent-sky); background: var(--pastel-sky); color: var(--accent-sky); }

/* EXPORT MODAL */
.export-option {
    display: flex; align-items: flex-start; gap: 12px; padding: 14px;
    border: 1.5px solid var(--border); border-radius: var(--radius-sm);
    cursor: pointer; transition: all 0.2s; background: var(--bg-soft); margin-bottom: 10px;
}
.export-option:hover { border-color: var(--accent-mint); background: var(--pastel-mint); }
.export-option-icon { width: 36px; height: 36px; border-radius: 10px; background: var(--pastel-mint); color: var(--accent-mint); display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 16px; }
.export-option h5 { font-family: 'DM Sans', sans-serif; font-size: 13px; font-weight: 700; color: var(--text-primary); margin: 0 0 3px; }
.export-option p { font-size: 11px; color: var(--text-secondary); margin: 0; }

/* ANIMATIONS */
@keyframes fadeUp { from{opacity:0; transform:translateY(12px);} to{opacity:1; transform:translateY(0);} }
.anim-fade-up { animation: fadeUp 0.5s ease forwards; opacity: 0; }
.delay-1 { animation-delay: 0.06s; } .delay-2 { animation-delay: 0.12s; } .delay-3 { animation-delay: 0.18s; }
.delay-4 { animation-delay: 0.24s; } .delay-5 { animation-delay: 0.30s; }

/* RESPONSIVE */
@media (max-width:1280px) { .product-grid { grid-template-columns: repeat(3, 1fr); } .stats-bar { grid-template-columns: repeat(3, 1fr); } .stats-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width:1024px) { .product-grid { grid-template-columns: repeat(2, 1fr); } .stats-bar { grid-template-columns: repeat(2, 1fr); } .main-content { padding: 12px 16px; } }
@media (max-width:768px) {
    .product-grid { grid-template-columns: 1fr; } .stats-bar { grid-template-columns: 1fr; }
    .form-grid { grid-template-columns: 1fr; } .toolbar { flex-direction: column; gap: 12px; align-items: stretch; }
    .toolbar-right { flex-wrap: wrap; } .search-box { width: 100%; }
    .welcome-section { flex-direction: column; gap: 12px; text-align: center; }
    .stats-grid { grid-template-columns: 1fr 1fr; }
}
</style>
</head>
<body>

<!-- TOASTS -->
<div class="toast-container" id="toastContainer">
    <c:if test="${not empty param.exito}">
        <div class="toast-item success"><div class="toast-icon"><i class="fas fa-check"></i></div><span class="toast-text">${param.exito}</span></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="toast-item error"><div class="toast-icon"><i class="fas fa-exclamation"></i></div><span class="toast-text">${param.error}</span></div>
    </c:if>
</div>

<div class="layout-wrapper">
    <%@ include file="/includes/sidebar.jsp" %>
    <main class="main-content">

        <!-- Welcome Section -->
        <div class="welcome-section anim-fade-up">
            <div class="welcome-content">
                <h1 class="welcome-title">Cat&aacute;logo <span>Admin</span></h1>
                <p class="welcome-subtitle">Administra todos los productos del sistema Quiddity</p>
            </div>
            <div class="welcome-actions">
                <button class="btn-action toggle-btn" id="btnToggleStats" onclick="togglePanel('statsPanel', this)">
                    <span class="material-symbols-outlined" style="font-size:15px;">bar_chart</span> Estad&iacute;sticas
                </button>
                <button class="btn-action toggle-btn" id="btnToggleTree" onclick="togglePanel('categoriesPanel', this)">
                    <span class="material-symbols-outlined" style="font-size:15px;">account_tree</span> &Aacute;rbol
                </button>
                <button class="btn-action success-btn" onclick="openExportModal()">
                    <span class="material-symbols-outlined" style="font-size:15px;">download</span> Exportar
                </button>
                <a href="<%= ctx %>/admin/catalogo/form?accion=agregar" class="btn-action primary">
                    <span class="material-symbols-outlined">add</span> Nuevo Producto
                </a>
            </div>
        </div>

        <!-- Stats Bar -->
        <div class="stats-bar anim-fade-up delay-1">
            <div class="stat-item" onclick="filterByStatusQuick('')">
                <div class="stat-icon primary"><span class="material-symbols-outlined">inventory_2</span></div>
                <div class="stat-data"><h4>${totalProductos != null ? totalProductos : '0'}</h4><p>Total Productos</p></div>
            </div>
            <div class="stat-item" onclick="filterByStatusQuick('activo')">
                <div class="stat-icon mint"><span class="material-symbols-outlined">trending_up</span></div>
                <div class="stat-data"><h4>${productosActivos != null ? productosActivos : '0'}</h4><p>Activos</p></div>
            </div>
            <div class="stat-item" onclick="filterByStatusQuick('bajo_stock')">
                <div class="stat-icon cream"><span class="material-symbols-outlined">warning</span></div>
                <div class="stat-data"><h4>${productosBajoStock != null ? productosBajoStock : '0'}</h4><p>Bajo Stock</p></div>
            </div>
            <div class="stat-item" onclick="filterByStatusQuick('sin_stock')">
                <div class="stat-icon coral"><span class="material-symbols-outlined">block</span></div>
                <div class="stat-data"><h4>${productosSinStock != null ? productosSinStock : '0'}</h4><p>Sin Stock</p></div>
            </div>
            <div class="stat-item">
                <div class="stat-icon lavender"><span class="material-symbols-outlined">payments</span></div>
                <div class="stat-data">
                    <h4><fmt:formatNumber value="${ingresosTotales != null ? ingresosTotales : 0}" type="currency" currencySymbol="$" maxFractionDigits="0"/></h4>
                    <p>Ingresos Totales</p>
                </div>
            </div>
        </div>

        <!-- Chips Navigation -->
        <div class="chips-section anim-fade-up delay-2">
            <div class="chips-container">
                <div class="chips-row" id="catRow">
                    <button class="cat-chip active" data-cat="all">
                        <span class="material-symbols-outlined" style="font-size:14px;">auto_awesome</span> Todos
                    </button>
                    <button class="cat-chip" data-cat="belleza">
                        <span class="material-symbols-outlined" style="font-size:14px;">face_retouching_natural</span> Belleza
                    </button>
                    <button class="cat-chip" data-cat="cuidado">
                        <span class="material-symbols-outlined" style="font-size:14px;">spa</span> Cuidado
                    </button>
                    <button class="cat-chip" data-cat="perfumes">
                        <span class="material-symbols-outlined" style="font-size:14px;">water_drop</span> Perfumes
                    </button>
                    <button class="cat-chip" data-cat="cabello">
                        <span class="material-symbols-outlined" style="font-size:14px;">self_improvement</span> Cabello
                    </button>
                </div>
                <div id="subcatDivider" class="chips-divider" style="display:none;"></div>
                <div id="subcatRow" class="chips-row" style="display:none; padding-top:8px;"></div>
                <div id="subsubcatDivider" class="chips-divider" style="display:none;"></div>
                <div id="subsubcatRow" class="chips-row" style="display:none; padding-top:8px;"></div>
            </div>
        </div>

        <!-- Toolbar -->
        <div class="toolbar anim-fade-up delay-2">
            <div class="toolbar-left">
                <div class="toolbar-title-group">
                    <h2 id="sectionTitle">Todos los Productos</h2>
                    <p id="productCount">${productos != null ? productos.size() : '0'} productos</p>
                </div>
            </div>
            <div class="toolbar-right">
                <div class="search-box">
                    <span class="material-symbols-outlined search-icon">search</span>
                    <input type="text" id="searchInput" placeholder="Buscar producto..." oninput="searchProducts()">
                </div>
                <select class="filter-select" id="statusFilter" onchange="filterByStatus()">
                    <option value="">Todos los estados</option>
                    <option value="activo">Activo</option>
                    <option value="inactivo">Inactivo</option>
                    <option value="bajo_stock">Bajo Stock</option>
                    <option value="sin_stock">Sin Stock</option>
                </select>
                <select class="filter-select" id="sortFilter" onchange="sortProducts()">
                    <option value="">Ordenar por</option>
                    <option value="nombre_asc">Nombre A&#8209;Z</option>
                    <option value="nombre_desc">Nombre Z&#8209;A</option>
                    <option value="precio_asc">Precio &#8593;</option>
                    <option value="precio_desc">Precio &#8595;</option>
                    <option value="stock_asc">Stock &#8593;</option>
                    <option value="stock_desc">Stock &#8595;</option>
                    <option value="ventas_desc">M&aacute;s vendidos</option>
                </select>
            </div>
        </div>

        <!-- Products Section -->
        <div class="products-section">

            <!-- Statistics Panel (togglable) -->
            <div class="stats-panel anim-fade-up delay-3" id="statsPanel">
                <h3>Estad&iacute;sticas del Cat&aacute;logo</h3>
                <div class="stats-grid">
                    <div class="stat-box">
                        <h5>Top 10 M&aacute;s Vendidos</h5>
                        <div class="big-number" id="statsTopCount">
                            ${not empty topVendidos ? topVendidos.size() : '0'}
                        </div>
                        <p class="stat-desc">Productos con mayor rotaci&oacute;n</p>
                        <div class="top-list" id="topVendidosList">
                            <c:choose>
                                <c:when test="${not empty topVendidos}">
                                    <c:forEach var="tv" items="${topVendidos}" varStatus="st">
                                        <div class="top-list-item">
                                            <div class="top-list-rank ${st.index == 0 ? 'gold' : (st.index == 1 ? 'silver' : (st.index == 2 ? 'bronze' : ''))}">${st.index + 1}</div>
                                            <span class="top-list-name">${tv['nombre']}</span>
                                            <span class="top-list-ventas">${tv['totalVendido']} uds.</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p style="font-size:11px;color:var(--text-tertiary);text-align:center;padding:12px 0;">Sin datos de ventas a&uacute;n</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="stat-box">
                        <h5>Ventas por Categor&iacute;a</h5>
                        <div class="big-number">${ventasPorCategoria != null ? ventasPorCategoria.size() : '0'}</div>
                        <p class="stat-desc">Categor&iacute;as con ventas registradas</p>
                        <div class="top-list" style="margin-top:10px;">
                            <c:choose>
                                <c:when test="${not empty ventasPorCategoria}">
                                    <c:forEach var="vc" items="${ventasPorCategoria}">
                                        <div class="top-list-item">
                                            <div class="top-list-rank" style="background:var(--pastel-lavender);color:var(--accent-lavender);">
                                                <span class="material-symbols-outlined" style="font-size:12px;">category</span>
                                            </div>
                                            <span class="top-list-name">${vc['categoria']}</span>
                                            <span class="top-list-ventas">${vc['totalVentas']}</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p style="font-size:11px;color:var(--text-tertiary);text-align:center;padding:12px 0;">Sin datos a&uacute;n</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="stat-box">
                        <h5>Sin Ventas (30 d&iacute;as)</h5>
                        <div class="big-number">${sinVentas != null ? sinVentas.size() : '0'}</div>
                        <p class="stat-desc">Productos sin movimiento reciente</p>
                        <div class="top-list" style="margin-top:10px;">
                            <c:choose>
                                <c:when test="${not empty sinVentas}">
                                    <c:forEach var="sv" items="${sinVentas}" end="4">
                                        <div class="top-list-item">
                                            <div class="top-list-rank" style="background:var(--pastel-cream);color:var(--accent-cream);">
                                                <span class="material-symbols-outlined" style="font-size:12px;">pause_circle</span>
                                            </div>
                                            <span class="top-list-name">${sv.nombre}</span>
                                            <span class="top-list-ventas" style="color:var(--accent-cream);">0 uds.</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p style="font-size:11px;color:var(--text-tertiary);text-align:center;padding:12px 0;">&iexcl;Todos los productos tienen ventas!</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="stat-box">
                        <h5>Ingresos del Cat&aacute;logo</h5>
                        <div class="big-number">
                            $<fmt:formatNumber value="${ingresosTotales != null ? ingresosTotales : 0}" pattern="#,##0"/>
                        </div>
                        <p class="stat-desc">Total acumulado en ventas</p>
                        <div style="margin-top:14px; display:flex; flex-direction:column; gap:6px;">
                            <div style="display:flex; justify-content:space-between; font-size:10px; color:var(--text-secondary);">
                                <span>Productos activos</span>
                                <span style="font-weight:700; color:var(--accent-mint);">${productosActivos != null ? productosActivos : '0'}</span>
                            </div>
                            <div style="display:flex; justify-content:space-between; font-size:10px; color:var(--text-secondary);">
                                <span>Sin stock</span>
                                <span style="font-weight:700; color:var(--accent-coral);">${productosSinStock != null ? productosSinStock : '0'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Categories Tree Panel (togglable) -->
            <div class="categories-panel anim-fade-up delay-3" id="categoriesPanel">
                <h3>&Aacute;rbol de Categor&iacute;as</h3>
                <div class="cat-tree" id="catTree"></div>
            </div>

            <!-- Product Grid -->
            <div class="product-grid" id="productGrid">
            <c:choose>
                <c:when test="${empty productos}">
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <span class="material-symbols-outlined" style="font-size:32px;">inventory_2</span>
                        </div>
                        <h4>No hay productos registrados</h4>
                        <p>Comienza agregando tu primer producto al cat&aacute;logo.</p>
                        <button class="btn-action primary" onclick="openAddModal()" style="margin-top:12px;">
                            <span class="material-symbols-outlined" style="font-size:18px;">add</span> Agregar Producto
                        </button>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${productos}" varStatus="status">
                        <% 
                            Catalogo prod = (Catalogo) pageContext.getAttribute("p");
                            String cat = determinarCategoria(prod);
                            String subcat = determinarSubcat(prod);
                            String grupo = determinarGrupo(subcat, prod.getCategoria());
                            String subcatLabel = formatearSubcatLabel(subcat);
                            pageContext.setAttribute("dataCat", cat);
                            pageContext.setAttribute("dataGroup", grupo != null ? grupo : "");
                            pageContext.setAttribute("dataSubcat", subcat != null ? subcat : "");
                            pageContext.setAttribute("dataSubcatLabel", subcatLabel);
                        %>
                        <div class="product-card"
                             data-id="${p.id}"
                             data-cat="${dataCat}"
                             data-group="${dataGroup}"
                             data-subcat="${dataSubcat}"
                             data-subcat-label="${dataSubcatLabel}"
                             data-categoria="${p.categoria}"
                             data-marca="${p.marca}"
                             data-nombre="${p.nombre}"
                             data-descripcion="${p.descripcion}"
                             data-componentes="${p.componentes}"
                             data-precio="${p.precio}"
                             data-stock="${p.stock}"
                             data-activo="${p.activo}">

                            <div class="product-image">
                                <c:choose>
    <c:when test="${not empty p.imagen}">
        <c:choose>
            <%-- URL externa (Supabase, CDN, etc.) --%>
            <c:when test="${fn:startsWith(p.imagen, 'http')}">
                <img src="${p.imagen}" 
                     alt="${fn:escapeXml(p.nombre)}" 
                     onerror="this.parentElement.classList.add('no-image'); this.style.display='none';">
            </c:when>
            <%-- Ruta completa tipo uploads/catalogo/cuidado/skincare/cremas/vitamin_c.jpg --%>
            <c:when test="${fn:startsWith(p.imagen, 'uploads/')}">
                <img src="${ctx}/${p.imagen}" 
                     alt="${fn:escapeXml(p.nombre)}" 
                     onerror="this.parentElement.classList.add('no-image'); this.style.display='none';">
            </c:when>
            <%-- Ruta antigua tipo cuidado_corporal/xxx.jpg (fallback) --%>
            <c:otherwise>
                <img src="${ctx}/uploads/catalogo/${p.imagen}" 
                     alt="${fn:escapeXml(p.nombre)}" 
                     onerror="this.parentElement.classList.add('no-image'); this.style.display='none';">
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:linear-gradient(135deg,#f0f0f0,#e0e0e0);">
            <span class="material-symbols-outlined" style="font-size:40px;color:#ccc;">image</span>
        </div>
    </c:otherwise>
</c:choose>

                                <c:if test="${!p.activo}"><span class="product-badge badge-inactive">Inactivo</span></c:if>
                                <c:if test="${p.activo && p.stock == 0}"><span class="product-badge badge-out">Sin Stock</span></c:if>
                                <c:if test="${p.activo && p.stock > 0 && p.stock < 10}"><span class="product-badge badge-low">Stock Bajo</span></c:if>

                                <div class="stock-indicator">
                                    <span style="font-size:10px;font-weight:700;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.04em;">Stock: ${p.stock}</span>
                                    <div class="stock-bar">
                                        <div class="stock-bar-fill ${p.stock == 0 ? 'out' : (p.stock < 10 ? 'low' : (p.stock < 50 ? 'medium' : 'high'))}"
                                             style="width: ${p.stock > 100 ? 100 : p.stock}%"></div>
                                    </div>
                                </div>

                                <!-- OVERLAY CRUD -->
                                <div class="product-overlay">
                                    <a href="<%= ctx %>/admin/catalogo/form?accion=editar&id=${p.id}" class="overlay-btn edit" onclick="event.stopPropagation()">
                                        Editar
                                    </a>
                                    <a href="<%= ctx %>/admin/catalogo/form?accion=stock&id=${p.id}" class="overlay-btn stock-btn" onclick="event.stopPropagation()">
                                        Stock
                                    </a>
                                    <button class="overlay-btn toggle-btn" onclick="event.stopPropagation(); toggleActivo(${p.id})">
                                        <span class="material-symbols-outlined" style="font-size:16px;">${p.activo ? 'visibility_off' : 'visibility'}</span> ${p.activo ? 'Desactivar' : 'Activar'}
                                    </button>
                                    <button class="overlay-btn delete" onclick="event.stopPropagation(); confirmDelete(${p.id}, '${fn:escapeXml(p.nombre)}')">
                                        <span class="material-symbols-outlined" style="font-size:16px;">delete</span> Eliminar
                                    </button>
                                </div>
                            </div>

                            <div class="product-info">
                                <div class="product-info-left">
                                    <p class="product-category">${p.categoria}${not empty p.marca ? ' &mdash; '.concat(p.marca) : ''}</p>
                                    <h4 class="product-name">${p.nombre}</h4>
                                    <p class="product-marca">${not empty p.marca ? p.marca : '&nbsp;'}</p>
                                    <p class="product-price"><fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/></p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </div>

            <!-- MODALS (sin cambios) -->

            <div class="modal-overlay" id="deleteModal">
                <div class="modal-content" style="max-width:440px;">
                    <div class="modal-header">
                        <h3><span class="material-symbols-outlined" style="font-size:18px;margin-right:6px;color:var(--accent-coral);">delete_forever</span>Confirmar Eliminaci&oacute;n</h3>
                        <button class="modal-close" onclick="closeModal('deleteModal')"><span class="material-symbols-outlined">close</span></button>
                    </div>
                    <div class="modal-body" style="text-align:center;">
                        <div style="width:56px;height:56px;border-radius:50%;background:var(--pastel-coral);display:flex;align-items:center;justify-content:center;margin:0 auto 14px;">
                            <span class="material-symbols-outlined" style="font-size:26px;color:var(--accent-coral);">delete_forever</span>
                        </div>
                        <p style="font-size:12px;color:var(--text-secondary);margin-bottom:6px;">&iquest;Est&aacute;s segura de que deseas eliminar este producto?</p>
                        <p id="deleteProductName" style="font-family:'DM Sans',sans-serif;font-size:16px;font-weight:700;color:var(--text-primary);margin-bottom:18px;"></p>

                        <p style="font-size:10px;font-weight:700;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.08em;margin-bottom:10px;">Tipo de eliminaci&oacute;n</p>
                        <div class="delete-type-options">
                            <label class="delete-type-label soft">
                                <input type="radio" name="deleteTypeDisplay" value="soft" checked
                                       onchange="document.getElementById('deleteTypeInput').value='soft'">
                                <span class="material-symbols-outlined" style="font-size:14px;">visibility_off</span>
                                Soft &mdash; marcar inactivo
                            </label>
                            <label class="delete-type-label">
                                <input type="radio" name="deleteTypeDisplay" value="hard"
                                       onchange="document.getElementById('deleteTypeInput').value='hard'">
                                <span class="material-symbols-outlined" style="font-size:14px;">delete_sweep</span>
                                Hard &mdash; eliminar definitivo
                            </label>
                        </div>
                        <p style="font-size:10px;color:var(--text-tertiary);margin-top:10px;">
                            Soft: el producto se desactiva y puede recuperarse. Hard: se elimina permanentemente.
                        </p>
                    </div>
                    <form action="<%= ctx %>/admin/catalogo" method="POST" id="deleteForm">
                        <input type="hidden" name="accion" value="eliminar">
                        <input type="hidden" name="id" id="deleteId">
                        <input type="hidden" name="deleteType" id="deleteTypeInput" value="soft">
                        <div class="modal-footer" style="justify-content:center;">
                            <button type="button" class="btn-modal cancel" onclick="closeModal('deleteModal')">Cancelar</button>
                            <button type="submit" class="btn-modal danger">
                                <span class="material-symbols-outlined" style="font-size:15px;">delete</span> Confirmar Eliminaci&oacute;n
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-overlay" id="exportModal">
                <div class="modal-content" style="max-width:480px;">
                    <div class="modal-header">
                        <h3><span class="material-symbols-outlined" style="font-size:18px;margin-right:6px;color:var(--accent-mint);">download</span>Exportar Cat&aacute;logo</h3>
                        <button class="modal-close" onclick="closeModal('exportModal')"><span class="material-symbols-outlined">close</span></button>
                    </div>
                    <div class="modal-body">
                        <p style="font-size:12px;color:var(--text-secondary);margin-bottom:16px;">
                            Selecciona el formato y el alcance de los datos a exportar.
                        </p>
                        <div class="export-option" onclick="exportData('csv', 'visible')">
                            <div class="export-option-icon"><span class="material-symbols-outlined">table_chart</span></div>
                            <div>
                                <h5>CSV &mdash; Productos visibles</h5>
                                <p>Exporta solo los productos actualmente filtrados/visibles en pantalla.</p>
                            </div>
                        </div>
                        <div class="export-option" onclick="exportData('csv', 'all')">
                            <div class="export-option-icon"><span class="material-symbols-outlined">dataset</span></div>
                            <div>
                                <h5>CSV &mdash; Todos los productos</h5>
                                <p>Exporta el cat&aacute;logo completo sin importar los filtros activos.</p>
                            </div>
                        </div>
                        <div class="export-option" style="opacity:0.5; cursor:not-allowed;" onclick="showToast('Exportaci&oacute;n Excel pr&oacute;ximamente', 'warning')">
                            <div class="export-option-icon" style="background:var(--pastel-sage);color:var(--accent-sage);">
                                <span class="material-symbols-outlined">description</span>
                            </div>
                            <div>
                                <h5>Excel &mdash; Pr&oacute;ximamente</h5>
                                <p>Exportaci&oacute;n con formato enriquecido y gr&aacute;ficas.</p>
                            </div>
                        </div>
                        <div style="padding:12px; background:var(--pastel-sky); border-radius:var(--radius-sm); margin-top:4px;">
                            <p style="font-size:11px; color:var(--accent-sky); font-weight:600; display:flex; align-items:center; gap:6px;">
                                <span class="material-symbols-outlined" style="font-size:15px;">info</span>
                                El archivo incluir&aacute;: ID, nombre, categor&iacute;a, marca, precio, stock, estado activo.
                            </p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-modal cancel" onclick="closeModal('exportModal')">Cerrar</button>
                    </div>
                </div>
            </div>

            <form id="toggleForm" action="<%= ctx %>/admin/catalogo" method="POST" style="display:none;">
                <input type="hidden" name="accion" value="toggleActivo">
                <input type="hidden" name="id" id="toggleId">
            </form>

        </div>
    </main>
</div>

<script>
// ==================== CONFIGURACIÓN DE SUBCATEGORÍAS ====================
var SUBCATS = {
    'all': [],
    'belleza': [
        { key: 'brochas',    label: 'Brochas' },
        { key: 'esponjas',   label: 'Esponjas' },
        { key: 'maquillaje', label: 'Maquillaje' }
    ],
    'cuidado': [
        { key: 'facial',   label: 'Facial', subs: [
            { key: 'mascarillas', label: 'Mascarillas' },
            { key: 'serums',      label: 'Serums' },
            { key: 'hidratantes', label: 'Hidratantes' },
            { key: 'tonicos',     label: 'Tónicos' },
            { key: 'exfoliantes', label: 'Exfoliantes' }
        ]},
        { key: 'corporal', label: 'Corporal', subs: [
            { key: 'exfoliantes-corp',  label: 'Exfoliantes' },
            { key: 'lociones',          label: 'Lociones & Mantecas' },
            { key: 'aceites-corp',      label: 'Aceites Corporales' },
            { key: 'tratamientos-corp', label: 'Tratamientos' }
        ]}
    ],
    'perfumes': [
        { key: 'edt',            label: 'EDT' },
        { key: 'edp',            label: 'EDP' },
        { key: 'sets-olfativos', label: 'Sets Olfativos' }
    ],
    'cabello': [
        { key: 'shampoos',            label: 'Shampoo & Acondicionador' },
        { key: 'mascarillas-capilar', label: 'Mascarillas Capilares' },
        { key: 'aceites-capilares',   label: 'Aceites & Serums' }
    ]
};

var SECTION_META = {
    'all':      { label: 'Todos los productos',  title: 'Todos los Productos' },
    'belleza':  { label: 'Colección Belleza',    title: 'Belleza & Maquillaje' },
    'cuidado':  { label: 'Ritual de Cuidado',    title: 'Cuidado de la Piel' },
    'perfumes': { label: 'Fragancias Botánicas', title: 'Perfumes & Fragancias' },
    'cabello':  { label: 'Cuidado Capilar',      title: 'Cuidado del Cabello' }
};

var activeCat    = 'all';
var activeGroup  = null;
var activeSubcat = null;
var activeStatus = '';
var activeSort   = '';
var searchTerm   = '';

// ==================== FUNCIONES DE FILTRADO ====================
function filterByCategory(cat) {
    activeCat    = cat;
    activeGroup  = null;
    activeSubcat = null;

    document.querySelectorAll('.cat-chip').forEach(function(c) { c.classList.remove('active'); });
    var btn = document.querySelector('.cat-chip[data-cat="' + cat + '"]');
    if (btn) btn.classList.add('active');

    renderSubcategories(cat);

    var meta = SECTION_META[cat];
    if (meta) document.getElementById('sectionTitle').textContent = meta.title;

    applyFilters();
}

function renderSubcategories(cat) {
    var subRow    = document.getElementById('subcatRow');
    var subDiv    = document.getElementById('subcatDivider');
    var subSubRow = document.getElementById('subsubcatRow');
    var subSubDiv = document.getElementById('subsubcatDivider');

    subSubRow.style.display = 'none';
    subSubDiv.style.display = 'none';
    subSubRow.innerHTML = '';

    if (cat === 'all' || !SUBCATS[cat]) {
        subRow.style.display = 'none';
        subDiv.style.display = 'none';
        subRow.innerHTML = '';
        return;
    }

    var items    = SUBCATS[cat];
    var isGrouped = items.length > 0 && items[0].subs !== undefined;

    subDiv.style.display = 'block';
    subRow.style.display = 'flex';
    subRow.innerHTML =
        '<button class="subcat-chip active" data-sub="all">Todos</button>' +
        items.map(function(item) {
            return '<button class="subcat-chip" data-sub="' + item.key + '">' + item.label + '</button>';
        }).join('');

    subRow.querySelectorAll('.subcat-chip').forEach(function(chip) {
        chip.addEventListener('click', handleSubcatClick);
    });

    function handleSubcatClick(e) {
        var chip   = e.currentTarget;
        var subKey = chip.getAttribute('data-sub');

        subRow.querySelectorAll('.subcat-chip').forEach(function(c) { c.classList.remove('active'); });
        chip.classList.add('active');

        if (subKey === 'all') {
            // "Todos" — limpiar filtros de subcat y grupo
            activeGroup  = null;
            activeSubcat = null;
            hideSubsubcats();
        } else if (isGrouped) {
            // Cuidado: primer nivel es grupo (facial / corporal)
            activeGroup  = subKey;
            activeSubcat = null;
            var groupObj = items.find(function(g) { return g.key === subKey; });
            if (groupObj && groupObj.subs) renderSubsubcats(groupObj.subs);
            else hideSubsubcats();
        } else {
            // Belleza / Perfumes / Cabello: subcat directa
            activeGroup  = null;
            activeSubcat = subKey;   // se asigna ANTES de hideSubsubcats
            hideSubsubcats();        // ya NO pisa activeSubcat
        }

        applyFilters();
    }
}

function renderSubsubcats(subs) {
    var subRow = document.getElementById('subsubcatRow');
    var subDiv = document.getElementById('subsubcatDivider');

    subDiv.style.display = 'block';
    subRow.style.display = 'flex';
    subRow.innerHTML =
        '<button class="subcat-chip active" data-subsub="all">Todos</button>' +
        subs.map(function(s) {
            return '<button class="subcat-chip" data-subsub="' + s.key + '">' + s.label + '</button>';
        }).join('');

    subRow.querySelectorAll('.subcat-chip').forEach(function(chip) {
        chip.addEventListener('click', handleSubsubClick);
    });

    function handleSubsubClick(e) {
        var chip   = e.currentTarget;
        var subsub = chip.getAttribute('data-subsub');

        subRow.querySelectorAll('.subcat-chip').forEach(function(c) { c.classList.remove('active'); });
        chip.classList.add('active');

        activeSubcat = (subsub === 'all') ? null : subsub;
        applyFilters();
    }
}

function hideSubsubcats() {
    var subRow = document.getElementById('subsubcatRow');
    var subDiv = document.getElementById('subsubcatDivider');
    subRow.style.display = 'none';
    subDiv.style.display = 'none';
    subRow.innerHTML = '';
    // ✅ NO se toca activeSubcat aquí — lo gestiona quien llama a esta función
}

function filterByStatus() {
    activeStatus = document.getElementById('statusFilter').value;
    applyFilters();
}

function filterByStatusQuick(status) {
    activeStatus = status;
    var sel = document.getElementById('statusFilter');
    if (sel) sel.value = status;
    applyFilters();
}

function sortProducts() {
    activeSort = document.getElementById('sortFilter').value;
    applyFilters();
}

function searchProducts() {
    searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
    applyFilters();
}

function applyFilters() {
    var cards   = document.querySelectorAll('.product-card');
    var visible = 0;

    cards.forEach(function(card) {
        var cat    = card.getAttribute('data-cat')   || '';
        var group  = card.getAttribute('data-group') || null;
        var sub    = card.getAttribute('data-subcat')|| null;
        var stock  = parseInt(card.getAttribute('data-stock'))  || 0;
        var activo = card.getAttribute('data-activo') === 'true';
        var nombre = (card.getAttribute('data-nombre') || '').toLowerCase();
        var show   = true;

        // Convertir string vacío a null para comparaciones limpias
        if (group === '') group = null;
        if (sub   === '') sub   = null;

        // Filtro de categoría principal
        if (activeCat !== 'all') {
            if (cat !== activeCat) show = false;
        }

        // Filtro de grupo o subcategoría
        if (show && (activeGroup !== null || activeSubcat !== null)) {
            if (activeGroup !== null && activeSubcat === null) {
                if (group !== activeGroup) show = false;
            } else if (activeSubcat !== null) {
                if (sub !== activeSubcat) show = false;
            }
        }

        // Filtro de estado
        if (show && activeStatus) {
            if      (activeStatus === 'bajo_stock' && !(stock > 0 && stock < 10)) show = false;
            else if (activeStatus === 'sin_stock'  && stock !== 0)                show = false;
            else if (activeStatus === 'activo'     && !activo)                   show = false;
            else if (activeStatus === 'inactivo'   && activo)                    show = false;
        }

        // Filtro de búsqueda
        if (show && searchTerm && !nombre.includes(searchTerm)) show = false;

        card.style.display = show ? '' : 'none';
        if (show) visible++;
    });

    document.getElementById('productCount').textContent =
        visible + ' producto' + (visible !== 1 ? 's' : '');

    sortVisibleCards();
}

function sortVisibleCards() {
    if (!activeSort) return;
    var grid  = document.getElementById('productGrid');
    var cards = Array.prototype.filter.call(
        grid.querySelectorAll('.product-card'),
        function(c) { return c.style.display !== 'none'; }
    );
    cards.sort(function(a, b) {
        switch (activeSort) {
            case 'nombre_asc':
                return (a.getAttribute('data-nombre') || '').localeCompare(b.getAttribute('data-nombre') || '');
            case 'nombre_desc':
                return (b.getAttribute('data-nombre') || '').localeCompare(a.getAttribute('data-nombre') || '');
            case 'precio_asc':
                return (parseFloat(a.getAttribute('data-precio')) || 0) - (parseFloat(b.getAttribute('data-precio')) || 0);
            case 'precio_desc':
                return (parseFloat(b.getAttribute('data-precio')) || 0) - (parseFloat(a.getAttribute('data-precio')) || 0);
            case 'stock_asc':
                return (parseInt(a.getAttribute('data-stock')) || 0) - (parseInt(b.getAttribute('data-stock')) || 0);
            case 'stock_desc':
                return (parseInt(b.getAttribute('data-stock')) || 0) - (parseInt(a.getAttribute('data-stock')) || 0);
            case 'ventas_desc':
                return (parseInt(b.getAttribute('data-ventas')) || 0) - (parseInt(a.getAttribute('data-ventas')) || 0);
            default:
                return 0;
        }
    });
    cards.forEach(function(card) { grid.appendChild(card); });
}

// ==================== FUNCIONES ADMINISTRATIVAS ====================
function openAddModal() {
    document.getElementById('addModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function closeModal(modalId) {
    document.getElementById(modalId).classList.remove('active');
    document.body.style.overflow = '';
}

function previewImage(input, previewId) {
    var preview = document.getElementById(previewId);
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            preview.innerHTML = '<img src="' + e.target.result + '" alt="Preview">';
        };
        reader.readAsDataURL(input.files[0]);
    }
}

function openEditModal(id) {
    var card = document.querySelector('.product-card[data-id="' + id + '"]');
    if (!card) return;

    document.getElementById('editId').value          = id;
    document.getElementById('editNombre').value      = card.getAttribute('data-nombre')      || '';
    document.getElementById('editPrecio').value      = card.getAttribute('data-precio')      || '';
    document.getElementById('editStock').value       = card.getAttribute('data-stock')       || '';
    document.getElementById('editDescripcion').value = card.getAttribute('data-descripcion') || '';
    document.getElementById('editComponentes').value = card.getAttribute('data-componentes') || '';
    document.getElementById('editMarca').value       = card.getAttribute('data-marca')       || '';

    var catSelect = document.getElementById('editCategoria');
    var catValue  = card.getAttribute('data-categoria') || '';
    for (var i = 0; i < catSelect.options.length; i++) {
        if (catSelect.options[i].value.toLowerCase() === catValue.toLowerCase()) {
            catSelect.selectedIndex = i;
            break;
        }
    }

    var img         = card.querySelector('.product-image img');
    var editPreview = document.getElementById('editPreview');
    if (img && img.src && img.complete && img.naturalWidth > 0) {
        editPreview.innerHTML = '<img src="' + img.src + '" alt="Preview">';
    } else {
        editPreview.innerHTML =
            '<span style="display:flex;align-items:center;gap:6px;color:var(--text-tertiary);">' +
            '<span class="material-symbols-outlined" style="font-size:20px;">image</span>' +
            ' La imagen actual se mantendrá</span>';
    }

    document.getElementById('editModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function confirmDelete(id, name) {
    document.getElementById('deleteId').value = id;
    document.getElementById('deleteProductName').textContent = name;
    document.querySelector('input[name="deleteTypeDisplay"][value="soft"]').checked = true;
    document.getElementById('deleteTypeInput').value = 'soft';
    document.getElementById('deleteModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function toggleActivo(id) {
    if (confirm('¿Cambiar el estado activo/inactivo de este producto?')) {
        document.getElementById('toggleId').value = id;
        document.getElementById('toggleForm').submit();
    }
}

function openExportModal() {
    document.getElementById('exportModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function exportData(format, scope) {
    var cards = (scope === 'visible')
        ? Array.prototype.filter.call(document.querySelectorAll('.product-card'), function(c) {
              return c.style.display !== 'none';
          })
        : Array.prototype.slice.call(document.querySelectorAll('.product-card'));

    if (cards.length === 0) {
        showToast('No hay productos para exportar', 'warning');
        closeModal('exportModal');
        return;
    }

    var rows = [['ID', 'Nombre', 'Categoria', 'Marca', 'Precio', 'Stock', 'Activo']];
    cards.forEach(function(card) {
        rows.push([
            card.getAttribute('data-id')       || '',
            '"' + (card.getAttribute('data-nombre')    || '').replace(/"/g, '""') + '"',
            '"' + (card.getAttribute('data-categoria') || '') + '"',
            '"' + (card.getAttribute('data-marca')     || '') + '"',
            card.getAttribute('data-precio')   || '0',
            card.getAttribute('data-stock')    || '0',
            card.getAttribute('data-activo')   || 'false'
        ]);
    });

    var csvContent = rows.map(function(r) { return r.join(','); }).join('\n');
    var blob       = new Blob(['\uFEFF' + csvContent], { type: 'text/csv;charset=utf-8;' });
    var url        = URL.createObjectURL(blob);
    var link       = document.createElement('a');
    var dateStr    = new Date().toISOString().slice(0, 10);

    link.href     = url;
    link.download = 'quiddity-catalogo-' + scope + '-' + dateStr + '.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);

    closeModal('exportModal');
    showToast('Exportado: ' + cards.length + ' productos (' + scope + ')', 'success');
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
        toast.style.opacity    = '0';
        toast.style.transform  = 'translateX(120%)';
        setTimeout(function() { if (toast.parentNode) toast.parentNode.removeChild(toast); }, 400);
    }, 4000);
}

function togglePanel(panelId, btn) {
    var panel     = document.getElementById(panelId);
    var isVisible = panel.style.display === 'block';
    panel.style.display = isVisible ? 'none' : 'block';
    btn.classList.toggle('active', !isVisible);
}

function renderCategoriesTree() {
    var container = document.getElementById('catTree');
    if (!container) return;

    var counts = { belleza: 0, cuidado: 0, perfumes: 0, cabello: 0 };
    document.querySelectorAll('.product-card').forEach(function(card) {
        var cat = card.getAttribute('data-cat');
        if (counts[cat] !== undefined) counts[cat]++;
    });

    var html = '';
    for (var key in SUBCATS) {
        if (key === 'all') continue;
        var label = key === 'belleza'  ? 'Belleza'
                  : key === 'cuidado'  ? 'Cuidado'
                  : key === 'perfumes' ? 'Perfumes'
                  : 'Cabello';

        html += '<div class="cat-tree-item">';
        html += '<div class="cat-tree-header" onclick="toggleTreeItem(this)">';
        html += '<span class="material-symbols-outlined" style="font-size:16px;color:var(--accent-sky);">expand_more</span>';
        html += '<h4>' + label + '</h4>';
        html += '<span class="count">' + (counts[key] || 0) + '</span>';
        html += '</div><div class="cat-tree-children">';

        var items = SUBCATS[key];
        if (items.length && items[0].subs) {
            items.forEach(function(g) {
                html += '<div class="cat-group-label">' + g.label + '</div>';
                g.subs.forEach(function(s) {
                    html += '<div class="cat-tree-child" onclick="jumpToSub(\'' + key + '\', \'' + s.key + '\')">';
                    html += '<span class="material-symbols-outlined" style="font-size:12px;">subdirectory_arrow_right</span>';
                    html += s.label + '<span class="child-count"></span></div>';
                });
            });
        } else {
            items.forEach(function(s) {
                html += '<div class="cat-tree-child" onclick="jumpToSub(\'' + key + '\', \'' + s.key + '\')">';
                html += '<span class="material-symbols-outlined" style="font-size:12px;">subdirectory_arrow_right</span>';
                html += s.label + '<span class="child-count"></span></div>';
            });
        }
        html += '</div></div>';
    }
    container.innerHTML = html;
}

function jumpToSub(cat, subKey) {
    filterByCategory(cat);
    setTimeout(function() {
        var subRow = document.getElementById('subcatRow');
        var chips  = subRow.querySelectorAll('.subcat-chip');
        for (var i = 0; i < chips.length; i++) {
            if (chips[i].getAttribute('data-sub') === subKey) {
                chips[i].click();
                break;
            }
        }
    }, 100);
}

function toggleTreeItem(header) {
    var children = header.nextElementSibling;
    var icon     = header.querySelector('.material-symbols-outlined');
    if (children.style.display === 'none') {
        children.style.display = 'flex';
        icon.textContent = 'expand_more';
    } else {
        children.style.display = 'none';
        icon.textContent = 'chevron_right';
    }
}

// ==================== INICIALIZACIÓN ====================
document.addEventListener('DOMContentLoaded', function() {
    renderCategoriesTree();
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
        if ((e.key === 'n' || e.key === 'N') &&
            !e.target.matches('input, textarea, select') &&
            !document.querySelector('.modal-overlay.active')) {
            openAddModal();
        }
    });

    setTimeout(function() {
        document.querySelectorAll('.toast-item').forEach(function(t) {
            t.style.transition = 'all 0.4s ease';
            t.style.opacity    = '0';
            t.style.transform  = 'translateX(120%)';
            setTimeout(function() { if (t.parentNode) t.parentNode.removeChild(t); }, 400);
        });
    }, 4000);
});
</script>
</body>
</html>