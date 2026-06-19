<%@ page import="com.quiddity.model.Catalogo" %>
<%@ page import="com.quiddity.model.CatalogoImagen" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String ctx = request.getContextPath();
    String accion = request.getParameter("accion");
    if (accion == null) accion = "agregar";

    Catalogo producto = (Catalogo) request.getAttribute("producto");

    String pageTitle   = "agregar".equals(accion) ? "Nuevo Producto"
                       : "editar".equals(accion)  ? "Editar Producto"
                       : "Actualizar Stock";
    String pageIcon    = "agregar".equals(accion) ? "add_circle"
                       : "editar".equals(accion)  ? "edit"
                       : "inventory";
    String accionForm  = "editar".equals(accion)  ? "actualizar"
                       : "stock".equals(accion)   ? "stock"
                       : "agregar";
    boolean isStock    = "stock".equals(accion);
    boolean isEdit     = "editar".equals(accion);
    boolean isNew      = "agregar".equals(accion);
    
    String rutaCategoriaActual = "";
    if (producto != null && producto.getCategoria() != null) {
        String cat = producto.getCategoria().toLowerCase().trim();
        if (cat.contains("cuidado") && cat.contains("facial")) {
            rutaCategoriaActual = "cuidado/skincare";
        } else if (cat.contains("cuidado") && cat.contains("corporal")) {
            rutaCategoriaActual = "cuidado/corporal";
        } else if (cat.contains("belleza")) {
            rutaCategoriaActual = "belleza";
        } else if (cat.contains("perfume")) {
            rutaCategoriaActual = "perfumes";
        } else if (cat.contains("cabello")) {
            rutaCategoriaActual = "cabello";
        } else {
            rutaCategoriaActual = cat.replaceAll("[^a-z0-9]", "_").replaceAll("_+", "_");
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= pageTitle %> — Quiddity Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&family=EB+Garamond:ital,wght@0,400..800;1,400..800&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<style>
:root {
    --bg: #F8F9FA; --bg-soft: #FFFFFF; --surface: #FFFFFF;
    --text-primary: #0d0d1a; --text-secondary: #4a5568; --text-tertiary: #6c757d;
    --border: #e9ecef; --border-light: #f1f3f5;
    --pastel-sky: #e3f2fd; --pastel-sky-dark: #bbdefb;
    --pastel-mint: #e8f5e9; --pastel-mint-dark: #c8e6c9;
    --pastel-lavender: #f3e5f5; --pastel-lavender-dark: #e1bee7;
    --pastel-cream: #fff3e0; --pastel-cream-dark: #ffe0b2;
    --pastel-coral: #fce4ec; --pastel-coral-dark: #f8bbd0;
    --pastel-sage: #f1f8e9; --pastel-sage-dark: #dcedc8;
    --accent-sky: #1976d2; --accent-mint: #388e3c; --accent-lavender: #7b1fa2;
    --accent-cream: #f57c00; --accent-coral: #c2185b; --accent-sage: #689f38;
    --radius-sm: 12px; --radius-md: 14px; --radius-lg: 16px;
    --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
    --shadow: 0 2px 8px rgba(0,0,0,0.06);
    --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
    --shadow-lg: 0 12px 32px rgba(0,0,0,0.12);
    --primary: #9a3a5a; --primary-dark: #7a2e48;
}
* { margin:0; padding:0; box-sizing:border-box; }
body {
    font-family: 'Plus Jakarta Sans', sans-serif;
    background: var(--bg); color: var(--text-primary);
    -webkit-font-smoothing: antialiased; font-size: 13px; line-height: 1.5;
}
.material-symbols-outlined { font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 24; vertical-align: middle; }
::-webkit-scrollbar { width: 4px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

.layout-wrapper { display: flex; min-height: 100vh; width: 100%; }
.main-content { flex: 1; padding: 24px 40px; display: flex; flex-direction: column; gap: 20px;  }

.breadcrumb-bar {
    display: flex; align-items: center; gap: 8px;
    font-size: 11px; font-weight: 600; color: var(--text-tertiary);
}
.breadcrumb-bar a { color: var(--text-secondary); text-decoration: none; transition: color 0.2s; }
.breadcrumb-bar a:hover { color: var(--accent-sky); }
.breadcrumb-bar .sep { color: var(--border); }
.breadcrumb-bar .current { color: var(--text-primary); }

.page-header {
    display: flex; align-items: flex-start; justify-content: space-between;
    background: var(--surface); border-radius: var(--radius-lg); padding: 20px 32px;
    border: 1px solid var(--border); box-shadow: var(--shadow-sm);
    animation: fadeUp 0.45s ease forwards; opacity: 0;
}
.page-header-left { display: flex; align-items: center; gap: 16px; }
.page-header-icon {
    width: 52px; height: 52px; border-radius: var(--radius-md); display: flex;
    align-items: center; justify-content: center; font-size: 24px; flex-shrink: 0;
}
.page-header-icon.add     { background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky)); color: var(--accent-lavender); }
.page-header-icon.edit    { background: linear-gradient(135deg, var(--pastel-sky), var(--pastel-mint)); color: var(--accent-sky); }
.page-header-icon.stock   { background: linear-gradient(135deg, var(--pastel-cream), var(--pastel-mint)); color: var(--accent-cream); }
.page-header-text h1 { font-family: 'DM Sans', sans-serif; font-size: 22px; font-weight: 700; color: var(--text-primary); letter-spacing: -0.4px; margin-bottom: 3px; }
.page-header-text p { font-size: 12px; color: var(--text-secondary); font-weight: 500; }
.btn-back {
    display: inline-flex; align-items: center; gap: 7px; padding: 10px 18px;
    font-size: 11px; font-weight: 700; letter-spacing: 0.06em; text-transform: uppercase;
    border: 1.5px solid var(--border); border-radius: var(--radius-sm);
    background: var(--bg-soft); color: var(--text-secondary); cursor: pointer;
    text-decoration: none; transition: all 0.2s ease; font-family: 'Plus Jakarta Sans', sans-serif;
}
.btn-back:hover { background: var(--pastel-sky); color: var(--accent-sky); border-color: var(--pastel-sky-dark); }

.toast-container { position: fixed; top: 24px; right: 24px; z-index: 9999; display: flex; flex-direction: column; gap: 10px; pointer-events: none; }
.toast-item {
    background: var(--surface); border: 1px solid var(--border-light); border-radius: var(--radius-md);
    padding: 14px 20px; display: flex; align-items: center; gap: 12px;
    box-shadow: var(--shadow-lg); animation: slideInToast 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
    font-size: 12px; font-weight: 600; min-width: 300px; border-left: 4px solid var(--accent-sky);
    font-family: 'Plus Jakarta Sans', sans-serif; pointer-events: auto;
}
.toast-item.success { border-left-color: var(--accent-mint); }
.toast-item.error   { border-left-color: var(--accent-coral); }
.toast-icon { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 14px; flex-shrink: 0; }
.toast-item.success .toast-icon { background: var(--pastel-mint); color: var(--accent-mint); }
.toast-item.error   .toast-icon { background: var(--pastel-coral); color: var(--accent-coral); }
@keyframes slideInToast { from{transform:translateX(120%);opacity:0;} to{transform:translateX(0);opacity:1;} }

.form-card {
    background: var(--surface); border-radius: var(--radius-lg);
    border: 1px solid var(--border); box-shadow: var(--shadow-sm);
    overflow: hidden;
    animation: fadeUp 0.5s ease 0.08s forwards; opacity: 0;
    flex: 1;
    display: flex;
    flex-direction: column;
}
.form-card-header {
    padding: 18px 32px; border-bottom: 1px solid var(--border-light);
    display: flex; align-items: center; gap: 10px;
    background: linear-gradient(to right, var(--bg), var(--surface));
}
.form-card-header h2 {
    font-family: 'DM Sans', sans-serif; font-size: 13px; font-weight: 700;
    color: var(--text-primary); letter-spacing: -0.2px;
    display: flex; align-items: center; gap: 8px;
}
.form-card-header h2::before {
    content: ''; width: 3px; height: 14px; border-radius: 2px;
    background: var(--accent-sky); flex-shrink: 0; display: inline-block;
}
.form-card-body { padding: 28px 32px; flex: 1; }

.form-layout { display: grid; grid-template-columns: 1fr 320px; gap: 24px; align-items: start; }
.form-fields { display: flex; flex-direction: column; gap: 16px; }
.form-sidebar { display: flex; flex-direction: column; gap: 16px; }

.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.form-row.thirds { grid-template-columns: 1fr 1fr 1fr; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-group label {
    font-size: 10px; font-weight: 700; color: var(--text-secondary);
    text-transform: uppercase; letter-spacing: 0.1em; font-family: 'Plus Jakarta Sans', sans-serif;
}
.form-group label .required { color: var(--accent-coral); margin-left: 2px; }
.form-group label .optional { color: var(--text-tertiary); font-weight: 400; text-transform: none; letter-spacing: 0; font-size: 10px; margin-left: 4px; }
.form-group input,
.form-group select,
.form-group textarea {
    padding: 11px 14px; border: 1.5px solid var(--border);
    border-radius: var(--radius-sm); font-size: 13px; font-weight: 600;
    color: var(--text-primary); background: var(--bg-soft);
    transition: all 0.2s; font-family: 'Plus Jakarta Sans', sans-serif;
    line-height: 1.4;
}
.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    outline: none; border-color: var(--accent-sky);
    box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.08); background: var(--surface);
}
.form-group input::placeholder,
.form-group textarea::placeholder { color: var(--text-secondary); font-weight: 400; opacity: 0.7; }
.form-group textarea { resize: vertical; min-height: 90px; }
.form-group select { cursor: pointer; }
.form-group input[type="file"] {
    padding: 9px 14px; cursor: pointer; font-size: 12px; color: var(--text-secondary);
}
.form-group input[type="file"]::file-selector-button {
    padding: 5px 12px; margin-right: 12px; border: 1px solid var(--border);
    border-radius: 8px; background: var(--bg); color: var(--text-secondary);
    font-family: 'Plus Jakarta Sans', sans-serif; font-size: 10px; font-weight: 700;
    letter-spacing: 0.06em; text-transform: uppercase; cursor: pointer; transition: all 0.2s;
}
.form-group input[type="file"]::file-selector-button:hover {
    background: var(--pastel-sky); color: var(--accent-sky); border-color: var(--pastel-sky-dark);
}
.input-hint { font-size: 10px; color: var(--text-secondary); font-weight: 500; margin-top: 2px; }
.input-prefix-group { position: relative; }
.input-prefix-group .prefix {
    position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
    font-size: 13px; font-weight: 700; color: var(--text-secondary); pointer-events: none;
}
.input-prefix-group input { padding-left: 26px; }

.ruta-cat-input {
    font-family: 'DM Mono', monospace, sans-serif !important;
    font-size: 12px !important;
    letter-spacing: 0.02em;
}
.ruta-cat-preview {
    font-size: 10px; color: var(--text-secondary); font-weight: 500;
    background: var(--bg); padding: 8px 12px; border-radius: var(--radius-sm);
    border: 1px dashed var(--border-light); margin-top: 6px;
    font-family: 'DM Mono', monospace, sans-serif;
    word-break: break-all;
}
.ruta-cat-preview strong { color: var(--accent-sky); }

/* ── IMAGEN PREVIEW SIDEBAR ── */
.image-upload-card {
    background: var(--bg); border-radius: var(--radius-md);
    border: 1.5px dashed var(--border); overflow: hidden;
    transition: border-color 0.2s; position: relative;
}
.image-upload-card:hover { border-color: var(--accent-sky); }
.image-upload-card.has-image { border-style: solid; border-color: var(--border-light); }
.image-preview-area {
    width: 100%; aspect-ratio: 3/4; overflow: hidden;
    display: flex; align-items: center; justify-content: center;
    background: linear-gradient(135deg, #f5f5f5, #ebebeb);
    position: relative;
}
.image-preview-area img { width: 100%; height: 100%; object-fit: cover; display: block; }
.image-preview-placeholder {
    display: flex; flex-direction: column; align-items: center; gap: 8px;
    color: var(--text-secondary);
}
.image-preview-placeholder .icon { font-size: 40px; }
.image-preview-placeholder p { font-size: 11px; font-weight: 600; text-align: center; }
.image-upload-footer { padding: 12px 14px; border-top: 1px solid var(--border-light); }
.image-upload-footer label {
    display: flex; align-items: center; gap: 7px; cursor: pointer;
    font-size: 11px; font-weight: 700; color: var(--accent-sky); text-transform: uppercase;
    letter-spacing: 0.06em; justify-content: center;
}
.image-upload-footer label .material-symbols-outlined { font-size: 15px; }
#imagenInput { display: none; }

/* ── GALERÍA DE IMÁGENES ADICIONALES ── */
.galeria-section { margin-top: 20px; }
.galeria-upload-area {
    background: var(--bg); border-radius: var(--radius-md);
    border: 2px dashed var(--border); overflow: hidden;
    transition: all 0.2s ease; position: relative; cursor: pointer;
}
.galeria-upload-area:hover { border-color: var(--accent-sky); background: var(--pastel-sky); }
.galeria-upload-area .upload-content {
    padding: 24px 16px; text-align: center; pointer-events: none;
}
.galeria-upload-area .upload-content .material-symbols-outlined {
    font-size: 32px; color: var(--text-tertiary); margin-bottom: 8px;
}
.galeria-upload-area .upload-content p {
    font-size: 11px; color: var(--text-secondary); font-weight: 600;
}
.galeria-upload-area input[type="file"] {
    position: absolute; inset: 0; opacity: 0; cursor: pointer; width: 100%; height: 100%;
}

.galeria-grid {
    display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; margin-top: 10px;
}
.gal-thumb {
    position: relative; border-radius: 10px; overflow: hidden;
    aspect-ratio: 1; border: 2px solid transparent;
    transition: all 0.2s ease; background: var(--bg);
}
.gal-thumb:hover { transform: scale(1.03); box-shadow: 0 4px 12px rgba(0,0,0,0.12); }
.gal-thumb.principal { border-color: var(--accent-sky); }
.gal-thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }
.gal-thumb .badge-principal {
    position: absolute; top: 6px; left: 6px;
    background: var(--accent-sky); color: white;
    font-size: 8px; font-weight: 700; padding: 3px 8px;
    border-radius: 4px; text-transform: uppercase; letter-spacing: 0.05em;
}
.gal-thumb .btn-eliminar-img {
    position: absolute; top: 6px; right: 6px;
    width: 24px; height: 24px; border-radius: 50%;
    border: none; background: rgba(194,24,89,0.9); color: white;
    cursor: pointer; font-size: 14px; display: flex;
    align-items: center; justify-content: center; line-height: 1;
    transition: all 0.2s ease; opacity: 0;
}
.gal-thumb:hover .btn-eliminar-img { opacity: 1; }
.gal-thumb .btn-eliminar-img:hover { background: var(--accent-coral); transform: scale(1.1); }
.gal-thumb .btn-set-principal {
    position: absolute; bottom: 6px; left: 50%; transform: translateX(-50%);
    padding: 4px 10px; border-radius: 6px; border: none;
    background: rgba(0,0,0,0.6); color: white;
    font-size: 9px; font-weight: 700; text-transform: uppercase;
    cursor: pointer; opacity: 0; transition: all 0.2s ease; letter-spacing: 0.05em;
    white-space: nowrap;
}
.gal-thumb:hover .btn-set-principal { opacity: 1; }
.gal-thumb .btn-set-principal:hover { background: var(--accent-sky); }

.gal-thumb.nueva { border-color: var(--accent-mint); }
.gal-thumb .badge-nueva {
    position: absolute; top: 6px; left: 6px;
    background: var(--accent-mint); color: white;
    font-size: 8px; font-weight: 700; padding: 3px 8px;
    border-radius: 4px; text-transform: uppercase; letter-spacing: 0.05em;
}

.preview-nuevas { display: none; margin-top: 14px; }
.preview-nuevas.visible { display: block; }
.preview-nuevas-label {
    font-size: 10px; font-weight: 700; color: var(--text-secondary);
    text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 8px;
}

/* ── STOCK WIDGET ── */
.stock-widget {
    background: var(--bg); border-radius: var(--radius-md);
    border: 1px solid var(--border-light); padding: 16px;
}
.stock-widget-label {
    font-size: 10px; font-weight: 700; color: var(--text-secondary);
    text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 12px;
    display: flex; align-items: center; justify-content: space-between;
}
.stock-current-display {
    text-align: center; padding: 16px 0; border-bottom: 1px solid var(--border-light); margin-bottom: 14px;
}
.stock-current-display .big-num {
    font-family: 'DM Sans', sans-serif; font-size: 48px; font-weight: 700; line-height: 1;
    letter-spacing: -2px;
}
.stock-current-display .big-num.high   { color: var(--accent-mint); }
.stock-current-display .big-num.medium { color: var(--accent-cream); }
.stock-current-display .big-num.low    { color: var(--accent-coral); }
.stock-current-display .big-num.out    { color: var(--text-tertiary); }
.stock-current-display .stock-label { font-size: 10px; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.1em; margin-top: 4px; }
.stock-bar-wrap { height: 4px; background: var(--border-light); border-radius: 2px; margin-bottom: 14px; overflow: hidden; }
.stock-bar-fill { height: 100%; border-radius: 2px; transition: width 0.4s ease; }
.stock-bar-fill.high   { background: var(--accent-mint); }
.stock-bar-fill.medium { background: var(--accent-cream); }
.stock-bar-fill.low    { background: var(--accent-coral); }
.stock-bar-fill.out    { background: var(--text-tertiary); width: 0% !important; }
.stock-stepper { display: flex; align-items: center; gap: 8px; justify-content: center; margin-bottom: 12px; }
.stock-stepper-btn {
    width: 36px; height: 36px; border-radius: 10px; border: 1.5px solid var(--border);
    background: var(--surface); display: flex; align-items: center; justify-content: center;
    cursor: pointer; font-size: 18px; font-weight: 700; color: var(--text-secondary);
    transition: all 0.2s; line-height: 1; user-select: none; flex-shrink: 0;
}
.stock-stepper-btn:hover { background: var(--pastel-sky); color: var(--accent-sky); border-color: var(--pastel-sky-dark); transform: scale(1.08); }
.stock-stepper-btn.minus:hover { background: var(--pastel-coral); color: var(--accent-coral); border-color: var(--pastel-coral-dark); }
.stock-stepper input#stockDisplay {
    width: 70px; text-align: center; padding: 8px 6px;
    border: 1.5px solid var(--accent-sky); border-radius: 10px;
    font-size: 18px; font-weight: 700; color: var(--accent-sky);
    background: var(--bg-soft); font-family: 'DM Sans', sans-serif;
}
.stock-stepper input#stockDisplay:focus { outline: none; box-shadow: 0 0 0 3px rgba(25,118,210,0.1); }

.op-tabs { display: flex; gap: 6px; margin-bottom: 14px; }
.op-tab {
    flex: 1; padding: 8px 4px; border: 1.5px solid var(--border);
    border-radius: var(--radius-sm); font-size: 10px; font-weight: 700;
    letter-spacing: 0.06em; text-transform: uppercase; cursor: pointer;
    text-align: center; transition: all 0.2s; background: var(--surface);
    color: var(--text-secondary); font-family: 'Plus Jakarta Sans', sans-serif;
}
.op-tab.active { background: var(--pastel-sky); border-color: var(--accent-sky); color: var(--accent-sky); }
.op-tab:hover:not(.active) { background: var(--bg); }

.form-actions {
    display: flex; align-items: center; justify-content: space-between;
    padding: 18px 32px; border-top: 1px solid var(--border-light);
    background: linear-gradient(to right, var(--bg), var(--surface));
    margin-top: auto;
}
.form-actions-right { display: flex; gap: 10px; }
.btn-form {
    display: inline-flex; align-items: center; gap: 7px;
    padding: 11px 24px; font-size: 11px; font-weight: 700;
    letter-spacing: 0.07em; text-transform: uppercase; border: none;
    border-radius: var(--radius-sm); cursor: pointer; text-decoration: none;
    transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
    font-family: 'Plus Jakarta Sans', sans-serif;
}
.btn-form.cancel {
    background: var(--bg-soft); color: var(--text-primary);
    border: 1.5px solid var(--border);
}
.btn-form.cancel:hover { background: var(--border-light); }
.btn-form.save {
    background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
    color: var(--accent-lavender); box-shadow: 0 4px 12px rgba(123,31,162,0.15);
}
.btn-form.save:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(123,31,162,0.25); }
.btn-form.save-stock {
    background: linear-gradient(135deg, var(--pastel-mint), #c8f0cc);
    color: var(--accent-mint); box-shadow: 0 4px 12px rgba(56,142,60,0.15);
}
.btn-form.save-stock:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(56,142,60,0.25); }
.btn-form.delete-btn {
    background: var(--pastel-coral); color: var(--accent-coral);
    border: 1.5px solid var(--pastel-coral-dark);
}
.btn-form.delete-btn:hover { background: var(--accent-coral); color: white; }

.product-badge-card {
    display: flex; align-items: center; gap: 12px; padding: 14px 16px;
    background: var(--bg); border-radius: var(--radius-md);
    border: 1px solid var(--border-light);
}
.product-badge-thumb {
    width: 48px; height: 48px; border-radius: 10px; overflow: hidden;
    background: linear-gradient(135deg, #f0f0f0, #e0e0e0); flex-shrink: 0;
    display: flex; align-items: center; justify-content: center;
}
.product-badge-thumb img { width: 100%; height: 100%; object-fit: cover; }
.product-badge-info { flex: 1; min-width: 0; }
.product-badge-info .badge-name {
    font-family: 'DM Sans', sans-serif; font-size: 13px; font-weight: 700;
    color: var(--text-primary); white-space: nowrap; overflow: hidden;
    text-overflow: ellipsis; margin-bottom: 2px;
}
.product-badge-info .badge-cat { font-size: 10px; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.06em; }
.product-badge-info .badge-price { font-size: 12px; font-weight: 700; color: var(--accent-coral); margin-top: 2px; }

@keyframes fadeUp { from{opacity:0;transform:translateY(14px);} to{opacity:1;transform:translateY(0);} }

@media (max-width: 992px) {
    .form-layout { grid-template-columns: 1fr; }
    .form-sidebar { order: -1; }
    .image-preview-area { aspect-ratio: 16/9; }
    .main-content { padding: 20px 24px; }
}
@media (max-width: 600px) {
    .main-content { padding: 16px 20px; }
    .form-card-body { padding: 20px 16px; }
    .form-actions { padding: 14px 16px; }
    .form-card-header { padding: 14px 16px; }
    .page-header { padding: 16px 20px; }
    .form-row { grid-template-columns: 1fr; }
    .form-row.thirds { grid-template-columns: 1fr; }
    .galeria-grid { grid-template-columns: repeat(2, 1fr); }
}
</style>
</head>
<body>

<!-- TOASTS -->
<div class="toast-container" id="toastContainer">
    <c:if test="${not empty param.exito}">
        <div class="toast-item success">
            <div class="toast-icon"><span class="material-symbols-outlined" style="font-size:15px;">check_circle</span></div>
            <span>${param.exito}</span>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="toast-item error">
            <div class="toast-icon"><span class="material-symbols-outlined" style="font-size:15px;">error</span></div>
            <span>${param.error}</span>
        </div>
    </c:if>
</div>

<div class="layout-wrapper">
    <%@ include file="/includes/sidebar.jsp" %>

    <main class="main-content">

        <!-- Breadcrumb -->
        <nav class="breadcrumb-bar">
            <span class="material-symbols-outlined" style="font-size:14px;">home</span>
            <a href="<%= ctx %>/admin/catalogo">Catálogo Admin</a>
            <span class="sep">›</span>
            <span class="current"><%= pageTitle %></span>
        </nav>

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-header-left">
                <div class="page-header-icon <%= isNew ? "add" : isEdit ? "edit" : "stock" %>">
                    <span class="material-symbols-outlined"><%= pageIcon %></span>
                </div>
                <div class="page-header-text">
                    <h1><%= pageTitle %></h1>
                    <p>
                        <% if (isNew) { %>Completa todos los campos requeridos para agregar un producto al catálogo.
                        <% } else if (isEdit) { %>Modifica los datos del producto. Las imágenes nuevas se agregarán a la galería existente.
                        <% } else { %>Gestiona el inventario disponible para este producto.
                        <% } %>
                    </p>
                </div>
            </div>
            <a href="<%= ctx %>/admin/catalogo" class="btn-back">
                <span class="material-symbols-outlined" style="font-size:14px;">arrow_back</span>
                Volver al catálogo
            </a>
        </div>

        <!-- ==================== SECCIÓN: AGREGAR / EDITAR ==================== -->
        <% if (isNew || isEdit) { %>

        <form action="<%= ctx %>/admin/catalogo" method="POST" enctype="multipart/form-data" id="productForm">
            <input type="hidden" name="accion" value="<%= accionForm %>">
            <c:if test="${not empty producto}">
                <input type="hidden" name="id" value="${producto.id}">
            </c:if>

            <div class="form-card">
                <div class="form-card-header">
                    <h2>Información del producto</h2>
                </div>
                <div class="form-card-body">
                    <div class="form-layout">
                        <div class="form-fields">

                            <!-- Nombre -->
                            <div class="form-group">
                                <label>Nombre del producto <span class="required">*</span></label>
                                <input type="text" name="nombre" id="nombreProducto" required
                                       placeholder="Ej: Sérum Vitamina C 20%"
                                       value="<c:out value='${producto.nombre}'/>"
                                       oninput="updateRutaPreview()">
                            </div>

                            <!-- Descripción -->
                            <div class="form-group">
                                <label>Descripción <span class="optional">(recomendado)</span></label>
                                <textarea name="descripcion" rows="3" placeholder="Descripción detallada del producto, beneficios, uso recomendado..."><c:out value="${producto.descripcion}"/></textarea>
                            </div>

                            <!-- Componentes -->
                            <div class="form-group">
                                <label>Ingredientes / Componentes <span class="optional">(opcional)</span></label>
                                <textarea name="componentes" rows="2" placeholder="Ej: Ácido ascórbico 20%, niacinamida 5%, ácido hialurónico..."><c:out value="${producto.componentes}"/></textarea>
                            </div>

                            <!-- Categoría + Marca -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Categoría <span class="required">*</span></label>
                                    <select name="categoria" required id="selectCategoria" onchange="onCategoriaChange()">
                                        <option value="">Seleccionar...</option>
                                        <option value="Belleza"         ${producto.categoria == 'Belleza'          ? 'selected' : ''}>Belleza</option>
                                        <option value="Cuidado Facial"  ${producto.categoria == 'Cuidado Facial'  ? 'selected' : ''}>Cuidado Facial</option>
                                        <option value="Cuidado Corporal"${producto.categoria == 'Cuidado Corporal'? 'selected' : ''}>Cuidado Corporal</option>
                                        <option value="Perfumes"        ${producto.categoria == 'Perfumes'        ? 'selected' : ''}>Perfumes</option>
                                        <option value="Cabello"         ${producto.categoria == 'Cabello'         ? 'selected' : ''}>Cabello</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Marca <span class="optional">(opcional)</span></label>
                                    <input type="text" name="marca" placeholder="Ej: Quiddity"
                                           value="<c:out value='${producto.marca}'/>">
                                </div>
                            </div>

                            <!-- RUTA DE CATEGORÍA -->
                            <div class="form-group">
                                <label>
                                    Ruta de carpeta para imagen 
                                    <span class="optional">(estructura de carpetas)</span>
                                </label>
                                <input type="text" name="rutaCategoria" id="rutaCategoria" 
                                       class="ruta-cat-input"
                                       placeholder="Ej: cuidado/skincare/cremas"
                                       value="<%= rutaCategoriaActual %>">
                                <span class="input-hint">
                                    Formato: categoria/subcategoria/grupo. Se usa para organizar las imágenes en carpetas.
                                </span>
                                <div class="ruta-cat-preview" id="rutaPreview">
                                    <strong>Preview:</strong> uploads/catalogo/<span id="previewRuta">general</span>/<span id="previewNombre">producto.jpg</span>
                                </div>
                            </div>

                            <!-- Precio + Stock -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Precio <span class="required">*</span></label>
                                    <div class="input-prefix-group">
                                        <span class="prefix">$</span>
                                        <input type="number" name="precio" required min="0" step="0.01"
                                               placeholder="0.00"
                                               value="${producto.precio > 0 ? producto.precio : ''}">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Stock inicial <span class="required">*</span></label>
                                    <input type="number" name="stock" required min="0" placeholder="0"
                                           id="stockInput"
                                           value="${producto.stock}">
                                    <span class="input-hint">Unidades disponibles</span>
                                </div>
                            </div>

                        </div><!-- /form-fields -->

                        <!-- ═══ SIDEBAR: IMÁGENES ═══ -->
                        <div class="form-sidebar">

                            <!-- Badge del producto (solo editar) -->
                            <c:if test="${not empty producto}">
                                <div class="product-badge-card">
                                    <div class="product-badge-thumb">
                                        <c:choose>
                                            <c:when test="${not empty producto.imagen}">
                                                <c:set var="imgSrcBadge" value="${fn:startsWith(producto.imagen, 'http') ? producto.imagen : (fn:startsWith(producto.imagen, 'uploads/') ? (pageContext.request.contextPath.concat('/').concat(producto.imagen)) : (pageContext.request.contextPath.concat('/uploads/catalogo/').concat(producto.imagen)))}" />
                                                <img src="${imgSrcBadge}" 
                                                     alt="${fn:escapeXml(producto.nombre)}"
                                                     onerror="this.parentElement.innerHTML='<span class=\'material-symbols-outlined\' style=\'font-size:24px;color:#ccc;\'>image</span>'">
                                            </c:when>
                                            <c:otherwise>
                                                <span class="material-symbols-outlined" style="font-size:24px;color:#ccc;">image</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="product-badge-info">
                                        <div class="badge-name"><c:out value="${producto.nombre}"/></div>
                                        <div class="badge-cat"><c:out value="${producto.categoria}"/></div>
                                        <div class="badge-price">
                                            <fmt:formatNumber value="${producto.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Imagen PRINCIPAL -->
                            <div class="form-group" style="margin-bottom:6px;">
                                <label>
                                    Imagen principal 
                                    <% if (isNew) { %><span class="required">*</span><% } else { %><span class="optional">(dejar vacío para mantener)</span><% } %>
                                </label>
                            </div>
                            <div class="image-upload-card" id="imageUploadCard">
                                <div class="image-preview-area" id="previewArea">
                                    <c:choose>
                                        <c:when test="${not empty producto.imagen}">
                                            <c:set var="imgSrcPreview" value="${fn:startsWith(producto.imagen, 'http') ? producto.imagen : (fn:startsWith(producto.imagen, 'uploads/') ? (pageContext.request.contextPath.concat('/').concat(producto.imagen)) : (pageContext.request.contextPath.concat('/uploads/catalogo/').concat(producto.imagen)))}" />
                                            <img id="previewImg" src="${imgSrcPreview}" alt="Preview">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="image-preview-placeholder" id="previewPlaceholder">
                                                <span class="material-symbols-outlined icon">image</span>
                                                <p>Vista previa aquí</p>
                                            </div>
                                            <img id="previewImg" src="" alt="Preview" style="display:none;">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="image-upload-footer">
                                    <label for="imagenInput">
                                        <span class="material-symbols-outlined">upload</span>
                                        <%= isNew ? "Seleccionar imagen" : "Cambiar imagen" %>
                                    </label>
                                    <input type="file" id="imagenInput" name="imagen"
                                           accept="image/jpeg,image/png,image/gif"
                                           <%= isNew ? "required" : "" %>
                                           onchange="previewImage(this)">
                                </div>
                            </div>
                            <p class="input-hint">JPG, PNG o GIF — máx. 10 MB</p>

                            <!-- ═══ GALERÍA DE IMÁGENES ADICIONALES ═══ -->
                            <div class="galeria-section">
                                <div class="form-group" style="margin-bottom:6px;">
                                    <label>Imágenes de galería <span class="optional">(máx. 5)</span></label>
                                </div>
                                
                                <!-- Upload area -->
                                <div class="galeria-upload-area">
                                    <div class="upload-content">
                                        <span class="material-symbols-outlined">add_photo_alternate</span>
                                        <p>Arrastra imágenes aquí o haz clic para seleccionar</p>
                                    </div>
                                    <input type="file" name="imagenesAdicionales" multiple 
                                           accept="image/jpeg,image/png,image/gif"
                                           onchange="previewMultipleImages(this)">
                                </div>
                                <p class="input-hint">Aparecerán en el carrusel del producto</p>

                                <!-- Imágenes EXISTENTES (modo editar) -->
                                <c:if test="${not empty producto.imagenes}">
                                    <div style="margin-top:14px;">
                                        <p class="preview-nuevas-label">
                                            Galería actual (${producto.imagenes.size()} imagen${producto.imagenes.size() > 1 ? 'es' : ''})
                                        </p>
                                        <div class="galeria-grid" id="galeriaExistente">
                                            <c:forEach var="img" items="${producto.imagenes}">
                                                <div class="gal-thumb ${img.esPrincipal ? 'principal' : ''}" data-img-id="${img.id}">
                                                    <c:set var="imgSrcGal" value="${fn:startsWith(img.rutaImagen, 'http') ? img.rutaImagen : (fn:startsWith(img.rutaImagen, 'uploads/') ? (pageContext.request.contextPath.concat('/').concat(img.rutaImagen)) : (pageContext.request.contextPath.concat('/uploads/catalogo/').concat(img.rutaImagen)))}" />
                                                    <img src="${imgSrcGal}" alt="">
                                                    
                                                    <c:if test="${img.esPrincipal}">
                                                        <span class="badge-principal">Principal</span>
                                                    </c:if>
                                                    
                                                    <button type="button" class="btn-eliminar-img" onclick="eliminarImagenExistente(${img.id}, this)" title="Eliminar imagen">×</button>
                                                    
                                                    <c:if test="${!img.esPrincipal}">
                                                        <button type="button" class="btn-set-principal" onclick="setImagenPrincipal(${img.id})" title="Establecer como principal">Hacer principal</button>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Preview de NUEVAS imágenes -->
                                <div class="preview-nuevas" id="previewNuevasContainer">
                                    <p class="preview-nuevas-label">Nuevas imágenes</p>
                                    <div class="galeria-grid" id="imagenesAdicionalesPreview"></div>
                                </div>
                            </div>

                        </div><!-- /form-sidebar -->
                    </div><!-- /form-layout -->
                </div><!-- /form-card-body -->

                <div class="form-actions">
                    <div>
                        <c:if test="${not empty producto}">
                            <a href="<%= ctx %>/admin/catalogo/form?accion=stock&id=${producto.id}"
                               class="btn-form delete-btn" style="text-decoration:none;">
                                <span class="material-symbols-outlined" style="font-size:14px;">inventory</span>
                                Gestionar Stock
                            </a>
                        </c:if>
                    </div>
                    <div class="form-actions-right">
                        <a href="<%= ctx %>/admin/catalogo" class="btn-form cancel">Cancelar</a>
                        <button type="submit" class="btn-form save">
                            <span class="material-symbols-outlined" style="font-size:14px;">save</span>
                            <%= isNew ? "Guardar Producto" : "Guardar Cambios" %>
                        </button>
                    </div>
                </div>

            </div><!-- /form-card -->
        </form>

        <!-- ==================== SECCIÓN: STOCK ==================== -->
        <% } else if (isStock) { %>

        <c:if test="${empty producto}">
            <div style="padding:40px; text-align:center; background:var(--surface); border-radius:var(--radius-md); border:1px solid var(--border);">
                <span class="material-symbols-outlined" style="font-size:36px;color:var(--text-tertiary);">error</span>
                <p style="font-size:13px;color:var(--text-secondary);margin-top:12px;">Producto no encontrado.</p>
                <a href="<%= ctx %>/admin/catalogo" class="btn-form cancel" style="display:inline-flex;margin-top:14px;">Volver</a>
            </div>
        </c:if>

        <c:if test="${not empty producto}">
        <form action="<%= ctx %>/admin/catalogo" method="POST" id="stockForm">
            <input type="hidden" name="accion" value="stock">
            <input type="hidden" name="id"     value="${producto.id}">
            <input type="hidden" name="operacion" id="hiddenOp" value="set">
            <input type="hidden" name="stock"     id="hiddenStock" value="${producto.stock}">
            <input type="hidden" name="cantidad"  id="hiddenCantidad" value="1">

            <div class="form-card">
                <div class="form-card-header">
                    <h2>Gestión de Stock</h2>
                </div>
                <div class="form-card-body">
                    <div class="form-layout">

                        <div class="form-fields">

                            <div class="product-badge-card">
                                <div class="product-badge-thumb">
                                    <c:choose>
                                        <c:when test="${not empty producto.imagen}">
                                            <c:set var="imgSrcStock" value="${fn:startsWith(producto.imagen, 'http') ? producto.imagen : (fn:startsWith(producto.imagen, 'uploads/') ? (pageContext.request.contextPath.concat('/').concat(producto.imagen)) : (pageContext.request.contextPath.concat('/uploads/catalogo/').concat(producto.imagen)))}" />
                                            <img src="${imgSrcStock}"
                                                 alt="${fn:escapeXml(producto.nombre)}"
                                                 onerror="this.parentElement.innerHTML='<span class=\'material-symbols-outlined\' style=\'font-size:24px;color:#ccc;\'>image</span>'">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="material-symbols-outlined" style="font-size:24px;color:#ccc;">image</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="product-badge-info">
                                    <div class="badge-name"><c:out value="${producto.nombre}"/></div>
                                    <div class="badge-cat"><c:out value="${producto.categoria}"/></div>
                                    <div class="badge-price">
                                        <fmt:formatNumber value="${producto.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                                    </div>
                                </div>
                            </div>

                            <div>
                                <p style="font-size:10px;font-weight:700;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.1em;margin-bottom:10px;">Tipo de operación</p>
                                <div class="op-tabs">
                                    <div class="op-tab active" id="tab-set" onclick="setOpTab('set')">
                                        <span class="material-symbols-outlined" style="font-size:13px;display:block;margin-bottom:2px;">edit</span>
                                        Fijar
                                    </div>
                                    <div class="op-tab" id="tab-aumentar" onclick="setOpTab('aumentar')">
                                        <span class="material-symbols-outlined" style="font-size:13px;display:block;margin-bottom:2px;">add_circle</span>
                                        Aumentar
                                    </div>
                                    <div class="op-tab" id="tab-disminuir" onclick="setOpTab('disminuir')">
                                        <span class="material-symbols-outlined" style="font-size:13px;display:block;margin-bottom:2px;">remove_circle</span>
                                        Disminuir
                                    </div>
                                </div>
                            </div>

                            <p id="opDesc" style="font-size:11px;color:var(--text-secondary);background:var(--pastel-sky);padding:10px 14px;border-radius:var(--radius-sm);font-weight:600;">
                                <span class="material-symbols-outlined" style="font-size:13px;vertical-align:middle;">info</span>
                                Establece el stock exacto del producto.
                            </p>

                            <div class="form-group">
                                <label id="cantidadLabel">Nuevo stock <span class="required">*</span></label>
                                <input type="number" id="cantidadVisible" min="0" placeholder="0"
                                       value="${producto.stock}" oninput="updateHidden()">
                                <span class="input-hint" id="cantidadHint">Ingresa el valor exacto de stock disponible</span>
                            </div>

                        </div>

                        <div class="form-sidebar">

                            <div class="stock-widget">
                                <div class="stock-widget-label">
                                    Stock actual
                                    <span id="stockStatusLabel" style="padding:2px 8px;border-radius:6px;font-size:9px;"></span>
                                </div>

                                <div class="stock-current-display">
                                    <div class="big-num" id="stockDisplay">${producto.stock}</div>
                                    <div class="stock-label">unidades</div>
                                </div>

                                <div class="stock-bar-wrap">
                                    <div class="stock-bar-fill" id="stockBarFill"
                                         style="width: ${producto.stock > 100 ? 100 : producto.stock}%"></div>
                                </div>

                                <div class="stock-stepper">
                                    <button type="button" class="stock-stepper-btn minus" onclick="stepStock(-1)">−</button>
                                    <input type="number" id="stockDisplayInput" min="0" value="${producto.stock}"
                                           oninput="syncFromDisplay(this.value)"
                                           style="width:70px;text-align:center;padding:8px 6px;border:1.5px solid var(--accent-sky);border-radius:10px;font-size:18px;font-weight:700;color:var(--accent-sky);background:var(--bg-soft);font-family:'DM Sans',sans-serif;">
                                    <button type="button" class="stock-stepper-btn" onclick="stepStock(1)">+</button>
                                </div>

                                <p style="font-size:10px;color:var(--text-tertiary);text-align:center;font-weight:500;">
                                    El stepper actualiza el campo de la izquierda
                                </p>
                            </div>

                            <div style="background:var(--bg);border-radius:var(--radius-md);border:1px solid var(--border-light);padding:14px;">
                                <p style="font-size:10px;font-weight:700;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.1em;margin-bottom:10px;">Stock de referencia</p>
                                <div style="display:flex;flex-direction:column;gap:6px;">
                                    <div style="display:flex;justify-content:space-between;font-size:11px;font-weight:600;">
                                        <span style="color:var(--text-secondary);">Stock actual</span>
                                        <span style="color:var(--text-primary);">${producto.stock} uds.</span>
                                    </div>
                                    <div style="display:flex;justify-content:space-between;font-size:11px;font-weight:600;">
                                        <span style="color:var(--text-secondary);">Umbral bajo stock</span>
                                        <span style="color:var(--accent-cream);">< 10 uds.</span>
                                    </div>
                                    <div style="display:flex;justify-content:space-between;font-size:11px;font-weight:600;">
                                        <span style="color:var(--text-secondary);">Sin stock</span>
                                        <span style="color:var(--accent-coral);">0 uds.</span>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="<%= ctx %>/admin/catalogo/form?accion=editar&id=${producto.id}"
                       class="btn-form cancel" style="text-decoration:none;">
                        <span class="material-symbols-outlined" style="font-size:14px;">edit</span>
                        Editar datos del producto
                    </a>
                    <div class="form-actions-right">
                        <a href="<%= ctx %>/admin/catalogo" class="btn-form cancel">Cancelar</a>
                        <button type="submit" class="btn-form save-stock">
                            <span class="material-symbols-outlined" style="font-size:14px;">inventory</span>
                            Actualizar Stock
                        </button>
                    </div>
                </div>

            </div>
        </form>
        </c:if>

        <% } %>

    </main>
</div>

<script>
// ── IMAGEN PRINCIPAL PREVIEW ──
function previewImage(input) {
    var previewImg = document.getElementById('previewImg');
    var previewPlaceholder = document.getElementById('previewPlaceholder');
    var imageCard = document.getElementById('imageUploadCard');

    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            previewImg.style.display = 'block';
            if (previewPlaceholder) previewPlaceholder.style.display = 'none';
            imageCard.classList.add('has-image');
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// ── MÚLTIPLES IMÁGENES PREVIEW ──
function previewMultipleImages(input) {
    var container = document.getElementById('imagenesAdicionalesPreview');
    var wrapper = document.getElementById('previewNuevasContainer');
    
    if (!input.files || input.files.length === 0) return;
    
    wrapper.classList.add('visible');
    
    Array.from(input.files).forEach(function(file, idx) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var div = document.createElement('div');
            div.className = 'gal-thumb nueva';
            div.innerHTML = 
                '<img src="' + e.target.result + '" alt="">' +
                '<span class="badge-nueva">Nueva</span>' +
                '<button type="button" class="btn-eliminar-img" onclick="this.parentElement.remove(); checkNuevasVacias();" title="Quitar">×</button>';
            container.appendChild(div);
        };
        reader.readAsDataURL(file);
    });
}

function checkNuevasVacias() {
    var container = document.getElementById('imagenesAdicionalesPreview');
    var wrapper = document.getElementById('previewNuevasContainer');
    if (container.children.length === 0) {
        wrapper.classList.remove('visible');
    }
}

// ── ELIMINAR IMAGEN EXISTENTE ──
function eliminarImagenExistente(imagenId, btnElement) {
    if (!confirm('¿Eliminar esta imagen permanentemente?')) return;
    
    var productoId = document.querySelector('input[name="id"]')?.value;
    if (!productoId) {
        alert('Error: No se pudo determinar el producto');
        return;
    }
    
    // Eliminar visualmente primero
    var thumb = btnElement.closest('.gal-thumb');
    if (thumb) thumb.remove();
    
    // Redirigir para eliminar en servidor
    window.location.href = '<%= ctx %>/admin/catalogo?accion=eliminarImagen&imagenId=' + imagenId + '&productoId=' + productoId;
}

// ── ESTABLECER IMAGEN PRINCIPAL ──
function setImagenPrincipal(imagenId) {
    var productoId = document.querySelector('input[name="id"]')?.value;
    if (!productoId) return;
    
    // Aquí puedes hacer una petición AJAX o redirigir
    // Por ahora mostramos confirmación
    if (confirm('¿Establecer esta imagen como principal?')) {
        // TODO: Implementar endpoint setImagenPrincipal en servlet
        // window.location.href = '<%= ctx %>/admin/catalogo?accion=setPrincipal&imagenId=' + imagenId + '&productoId=' + productoId;
        alert('Funcionalidad pendiente: implementar accionSetImagenPrincipal en el servlet');
    }
}

// ── RUTA DE CATEGORÍA PREVIEW ──
var RUTAS_POR_CATEGORIA = {
    'Belleza':          'belleza',
    'Cuidado Facial':   'cuidado/skincare',
    'Cuidado Corporal': 'cuidado/corporal',
    'Perfumes':         'perfumes',
    'Cabello':          'cabello'
};

function onCategoriaChange() {
    var select = document.getElementById('selectCategoria');
    var rutaInput = document.getElementById('rutaCategoria');
    var cat = select.value;
    
    if (rutaInput && (!rutaInput.value || rutaInput.value === 'general')) {
        var rutaDefault = RUTAS_POR_CATEGORIA[cat];
        if (rutaDefault) {
            rutaInput.value = rutaDefault;
        }
    }
    updateRutaPreview();
}

function updateRutaPreview() {
    var rutaInput = document.getElementById('rutaCategoria');
    var nombreInput = document.getElementById('nombreProducto');
    var previewRuta = document.getElementById('previewRuta');
    var previewNombre = document.getElementById('previewNombre');
    
    if (!rutaInput || !previewRuta) return;
    
    var ruta = rutaInput.value.trim();
    if (!ruta) ruta = 'general';
    
    ruta = ruta.toLowerCase()
        .replace(/[áäâà]/g, 'a')
        .replace(/[éëêè]/g, 'e')
        .replace(/[íïîì]/g, 'i')
        .replace(/[óöôò]/g, 'o')
        .replace(/[úüûù]/g, 'u')
        .replace(/[ñ]/g, 'n')
        .replace(/[ç]/g, 'c')
        .replace(/[^a-z0-9/]/g, '_')
        .replace(/_+/g, '_')
        .replace(/\/_+|_+\//g, '/')
        .replace(/^\/|\/$/g, '');
    
    previewRuta.textContent = ruta;
    
    if (nombreInput && previewNombre) {
        var nombre = nombreInput.value.trim();
        if (nombre) {
            var nombreLimpio = nombre.toLowerCase()
                .replace(/[áäâà]/g, 'a')
                .replace(/[éëêè]/g, 'e')
                .replace(/[íïîì]/g, 'i')
                .replace(/[óöôò]/g, 'o')
                .replace(/[úüûù]/g, 'u')
                .replace(/[ñ]/g, 'n')
                .replace(/[ç]/g, 'c')
                .replace(/[^a-z0-9]/g, '_')
                .replace(/_+/g, '_')
                .replace(/^_+|_+$/g, '');
            previewNombre.textContent = nombreLimpio + '.jpg';
        } else {
            previewNombre.textContent = 'producto.jpg';
        }
    }
}

// ── STOCK PAGE LOGIC ──
var currentOp      = 'set';
var currentStock   = parseInt('<%= producto != null ? producto.getStock() : 0 %>') || 0;

function setOpTab(op) {
    currentOp = op;
    document.querySelectorAll('.op-tab').forEach(function(t) { t.classList.remove('active'); });
    document.getElementById('tab-' + op).classList.add('active');

    var hiddenOp   = document.getElementById('hiddenOp');
    var label      = document.getElementById('cantidadLabel');
    var hint       = document.getElementById('cantidadHint');
    var desc       = document.getElementById('opDesc');
    var input      = document.getElementById('cantidadVisible');
    if (hiddenOp) hiddenOp.value = op;

    if (op === 'set') {
        if (label) label.innerHTML = 'Nuevo stock <span class="required">*</span>';
        if (hint)  hint.textContent = 'Ingresa el valor exacto de stock disponible';
        if (desc)  desc.innerHTML = '<span class="material-symbols-outlined" style="font-size:13px;vertical-align:middle;">info</span> Establece el stock exacto del producto.';
        if (input) input.value = currentStock;
    } else if (op === 'aumentar') {
        if (label) label.innerHTML = 'Cantidad a agregar <span class="required">*</span>';
        if (hint)  hint.textContent = 'Se sumará esta cantidad al stock actual';
        if (desc)  desc.innerHTML = '<span class="material-symbols-outlined" style="font-size:13px;vertical-align:middle;">add_circle</span> Ingresa cuántas unidades quieres sumar al stock actual (' + currentStock + ' uds.).';
        if (input) input.value = '';
    } else {
        if (label) label.innerHTML = 'Cantidad a reducir <span class="required">*</span>';
        if (hint)  hint.textContent = 'Se restará esta cantidad del stock actual';
        if (desc)  desc.innerHTML = '<span class="material-symbols-outlined" style="font-size:13px;vertical-align:middle;">remove_circle</span> Ingresa cuántas unidades quieres restar del stock actual (' + currentStock + ' uds.).';
        if (input) input.value = '';
    }
    updateHidden();
}

function updateHidden() {
    var input     = document.getElementById('cantidadVisible');
    var hiddenSt  = document.getElementById('hiddenStock');
    var hiddenCan = document.getElementById('hiddenCantidad');
    if (!input) return;
    var val = parseInt(input.value) || 0;

    if (currentOp === 'set') {
        if (hiddenSt)  hiddenSt.value  = val;
        if (hiddenCan) hiddenCan.value = 1;
        syncDisplay(val);
    } else {
        if (hiddenCan) hiddenCan.value = val;
        if (hiddenSt)  hiddenSt.value  = -1;
        var preview = currentOp === 'aumentar'
            ? currentStock + val
            : Math.max(0, currentStock - val);
        syncDisplay(preview);
    }
}

function syncDisplay(val) {
    var display  = document.getElementById('stockDisplay');
    var displayInput = document.getElementById('stockDisplayInput');
    var barFill  = document.getElementById('stockBarFill');
    var statLbl  = document.getElementById('stockStatusLabel');
    
    if (display) display.textContent = val;
    if (displayInput) displayInput.value = val;

    var cls = val === 0 ? 'out' : (val < 10 ? 'low' : (val < 50 ? 'medium' : 'high'));
    
    if (display) {
        display.className = display.className.replace(/\b(out|low|medium|high|big-num)\b/g, '').trim();
        display.className += ' big-num ' + cls;
    }

    if (barFill) {
        barFill.className = 'stock-bar-fill ' + cls;
        barFill.style.width = (val > 100 ? 100 : val) + '%';
    }
    if (statLbl) {
        if (val === 0)      { statLbl.textContent = 'Sin stock';  statLbl.style.cssText = 'background:var(--pastel-coral);color:var(--accent-coral);'; }
        else if (val < 10)  { statLbl.textContent = 'Bajo stock'; statLbl.style.cssText = 'background:var(--pastel-cream);color:var(--accent-cream);'; }
        else                { statLbl.textContent = 'Disponible'; statLbl.style.cssText = 'background:var(--pastel-mint);color:var(--accent-mint);'; }
    }
}

function syncFromDisplay(val) {
    var input = document.getElementById('cantidadVisible');
    if (input && currentOp === 'set') { input.value = val; updateHidden(); }
}

function stepStock(delta) {
    var displayInput = document.getElementById('stockDisplayInput');
    var display = document.getElementById('stockDisplay');
    var input   = document.getElementById('cantidadVisible');
    
    var current = parseInt(displayInput ? displayInput.value : (display ? display.textContent : 0)) || 0;
    var next    = Math.max(0, current + delta);
    
    if (displayInput) displayInput.value = next;
    if (display) display.textContent = next;
    if (input && currentOp === 'set') { input.value = next; }
    updateHidden();
    syncDisplay(next);
}

// ── INIT ──
document.addEventListener('DOMContentLoaded', function() {
    var initStock = parseInt('<%= producto != null ? producto.getStock() : 0 %>') || 0;
    syncDisplay(initStock);
    updateRutaPreview();

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