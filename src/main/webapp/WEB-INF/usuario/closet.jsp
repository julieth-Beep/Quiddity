<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">

  <title>Mi Closet - Quiddity</title>
  <style>
    :root {
      --bg: #F8F9FA;
      --bg-soft: #FFFFFF;
      --surface: #FFFFFF;
      --text-primary: #1a1a2e;
      --text-secondary: #6c757d;
      --text-tertiary: #adb5bd;
      --border: #e9ecef;
      --border-light: #f1f3f5;

      --pastel-sky: #e3f2fd;
      --pastel-sky-dark: #bbdefb;
      --pastel-mint: #e8f5e9;
      --pastel-mint-dark: #c8e6c9;
      --pastel-lavender: #f3e5f5;
      --pastel-lavender-dark: #e1bee7;
      --pastel-cream: #fff3e0;
      --pastel-cream-dark: #ffe0b2;
      --pastel-coral: #fce4ec;
      --pastel-coral-dark: #f8bbd0;
      --pastel-sage: #f1f8e9;
      --pastel-sage-dark: #dcedc8;

      --accent-sky: #1976d2;
      --accent-mint: #388e3c;
      --accent-lavender: #7b1fa2;
      --accent-cream: #f57c00;
      --accent-coral: #c2185b;
      --accent-sage: #689f38;

      --radius-sm: 10px;
      --radius-md: 14px;
      --radius-lg: 16px;
      --radius-xl: 20px;

      --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
      --shadow: 0 2px 8px rgba(0,0,0,0.06);
      --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
      --shadow-lg: 0 8px 32px rgba(0,0,0,0.12);
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Plus Jakarta Sans', sans-serif;
      background: var(--bg);
      color: var(--text-primary);
      line-height: 1.4;
      -webkit-font-smoothing: antialiased;
      font-size: 12px;
      overflow: hidden;
      height: 100vh;
    }

    .layout-wrapper {
      display: flex;
      height: 100vh;
      overflow: hidden;
    }

    .main-content {
      flex: 1;
      padding: 16px 20px;
      display: flex;
      flex-direction: column;
      height: 100vh;
      overflow-y: auto;
      overflow-x: hidden;
    }

    .page {
      max-width: 100%;
      margin: 0 auto;
      width: 100%;
    }

    /* WELCOME */
    .welcome-section {
      display: flex;
      align-items: center;
      justify-content: space-between;
      background: var(--surface);
      border-radius: var(--radius-lg);
      padding: 16px 20px;
      border: 1px solid var(--border);
      box-shadow: var(--shadow-sm);
      margin-bottom: 16px;
    }

    .welcome-content { flex: 1; }

    .welcome-title {
      font-family: 'DM Sans', sans-serif;
      font-size: 22px;
      font-weight: 700;
      color: var(--text-primary);
      margin: 0 0 3px 0;
      letter-spacing: -0.3px;
    }

    .welcome-title span {
      color: var(--accent-sky);
    }

    .welcome-subtitle {
      font-size: 12px;
      color: var(--text-secondary);
      font-weight: 500;
      margin: 0;
    }

    .welcome-actions {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .btn-add {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 8px 16px;
      background: var(--pastel-sky);
      border: 1px solid var(--pastel-sky-dark);
      border-radius: var(--radius-md);
      cursor: pointer;
      transition: all 0.25s ease;
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 12px;
      font-weight: 600;
      color: var(--accent-sky);
      text-decoration: none;
      border: none;
    }

    .btn-add:hover {
      background: var(--pastel-sky-dark);
      transform: translateY(-1px);
      box-shadow: var(--shadow);
    }

    .btn-compare-toggle {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 8px 16px;
      background: var(--pastel-lavender);
      border: 1px solid var(--pastel-lavender-dark);
      border-radius: var(--radius-md);
      cursor: pointer;
      transition: all 0.25s ease;
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 12px;
      font-weight: 600;
      color: var(--accent-lavender);
      border: none;
    }

    .btn-compare-toggle:hover {
      background: var(--pastel-lavender-dark);
      transform: translateY(-1px);
      box-shadow: var(--shadow);
    }

    .btn-compare-toggle.active {
      background: var(--accent-lavender);
      color: white;
    }

    .welcome-avatar {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .avatar-ring {
      width: 42px;
      height: 42px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--pastel-sky), var(--pastel-lavender));
      padding: 2px;
    }

    .avatar-ring img {
      width: 100%;
      height: 100%;
      border-radius: 50%;
      object-fit: cover;
      border: 2px solid white;
    }

    .avatar-info { text-align: right; }
    .avatar-name { font-weight: 700; font-size: 13px; color: var(--text-primary); }
    .avatar-role { font-size: 11px; color: var(--text-tertiary); font-weight: 600; }

    /* CHIPS SECTION - IGUAL AL CATALOGO */
    .chips-section {
      position: sticky;
      top: 0;
      z-index: 40;
      background: var(--surface);
      border: 1px solid var(--border-light);
      border-radius: var(--radius-md);
      box-shadow: var(--shadow-sm);
      margin-bottom: 16px;
    }

    .chips-container { padding: 10px 14px; }

    .chips-row {
      display: flex;
      gap: 8px;
      overflow-x: auto;
      scrollbar-width: none;
    }

    .chips-row::-webkit-scrollbar { display: none; }

    .cat-chip {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 16px;
      border: 1.5px solid var(--border);
      border-radius: var(--radius-sm);
      font-size: 11px;
      font-weight: 600;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      color: var(--text-secondary);
      cursor: pointer;
      transition: all 0.22s;
      background: var(--surface);
      white-space: nowrap;
      font-family: 'Plus Jakarta Sans', sans-serif;
    }

    .cat-chip:hover {
      border-color: var(--accent-lavender);
      color: var(--accent-lavender);
      background: var(--pastel-lavender);
    }

    .cat-chip.active {
      background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
      border-color: transparent;
      color: var(--accent-lavender);
      box-shadow: 0 4px 12px rgba(123, 31, 162, 0.15);
    }

    .subcat-chip {
      display: inline-flex;
      align-items: center;
      padding: 6px 12px;
      border: 1px solid var(--border-light);
      border-radius: var(--radius-sm);
      font-size: 10px;
      font-weight: 600;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      color: var(--text-tertiary);
      cursor: pointer;
      transition: all 0.2s;
      background: transparent;
      white-space: nowrap;
      font-family: 'Plus Jakarta Sans', sans-serif;
    }

    .subcat-chip:hover {
      border-color: var(--accent-sky);
      color: var(--accent-sky);
      background: var(--pastel-sky);
    }

    .subcat-chip.active {
      background: var(--pastel-sky);
      border-color: var(--accent-sky);
      color: var(--accent-sky);
    }

    .chips-divider {
      height: 1px;
      background: var(--border-light);
      margin: 6px 0;
    }

    /* TOOLBAR - IGUAL AL CATALOGO */
    .toolbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px 16px;
      background: var(--surface);
      border-radius: var(--radius-md);
      border: 1px solid var(--border-light);
      box-shadow: var(--shadow-sm);
      margin-bottom: 16px;
    }

    .toolbar-left {
      display: flex;
      align-items: center;
      gap: 16px;
    }

    .toolbar-title-group h2 {
      font-family: 'DM Sans', sans-serif;
      font-size: 16px;
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 2px;
      letter-spacing: -0.3px;
    }

    .toolbar-title-group p {
      font-size: 11px;
      color: var(--text-tertiary);
      font-weight: 600;
    }

    .toolbar-right {
      display: flex;
      align-items: center;
      gap: 10px;
      flex-wrap: wrap;
    }

    .search-box {
      position: relative;
      width: 260px;
    }

    .search-box input {
      width: 100%;
      padding: 10px 14px 10px 38px;
      border: 1.5px solid var(--border);
      border-radius: var(--radius-sm);
      font-size: 12px;
      font-weight: 500;
      color: var(--text-primary);
      background: var(--bg-soft);
      transition: all 0.2s;
      font-family: 'Plus Jakarta Sans', sans-serif;
      outline: none;
    }

    .search-box input:focus {
      outline: none;
      border-color: var(--accent-sky);
      box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.08);
    }

    .search-box input::placeholder {
      color: var(--text-tertiary);
    }

    .search-box .search-icon {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--text-tertiary);
      font-size: 16px;
    }

    .filter-select {
      padding: 10px 14px;
      border: 1.5px solid var(--border);
      border-radius: var(--radius-sm);
      font-size: 11px;
      font-weight: 600;
      color: var(--text-primary);
      background: var(--bg-soft);
      cursor: pointer;
      transition: all 0.2s;
      min-width: 130px;
      font-family: 'Plus Jakarta Sans', sans-serif;
      outline: none;
    }

    .filter-select:focus {
      outline: none;
      border-color: var(--accent-sky);
      box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.08);
    }

    .view-toggle {
      display: flex;
      gap: 4px;
      padding: 4px;
      background: var(--bg-soft);
      border: 1px solid var(--border);
      border-radius: var(--radius-sm);
    }

    .view-btn {
      width: 32px;
      height: 32px;
      border: none;
      background: transparent;
      border-radius: 8px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--text-tertiary);
      transition: all 0.2s ease;
    }

    .view-btn.active {
      background: var(--pastel-sky);
      color: var(--accent-sky);
    }

    .view-btn:hover:not(.active) {
      background: var(--bg);
      color: var(--text-secondary);
    }

    .view-btn .material-symbols-rounded {
      font-size: 18px;
    }

    /* COMPARE BAR */
    .compare-bar {
      display: none;
      align-items: center;
      justify-content: space-between;
      padding: 12px 16px;
      background: var(--pastel-lavender);
      border: 1px solid var(--pastel-lavender-dark);
      border-radius: var(--radius-md);
      margin-bottom: 16px;
      animation: slideDown 0.3s ease;
    }

    .compare-bar.visible {
      display: flex;
    }

    .compare-info {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 13px;
      font-weight: 700;
      color: var(--accent-lavender);
    }

    .compare-actions {
      display: flex;
      gap: 8px;
    }

    .compare-btn {
      padding: 6px 14px;
      border-radius: var(--radius-sm);
      border: none;
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 11px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.2s ease;
      display: flex;
      align-items: center;
      gap: 4px;
    }

    .compare-btn.secondary {
      background: white;
      color: var(--text-secondary);
      border: 1px solid var(--border);
    }

    .compare-btn.secondary:hover {
      background: var(--bg);
    }

    /* GRID DE PRENDAS */
    .prendas-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
      gap: 16px;
    }

    .prendas-grid.list-view {
      grid-template-columns: 1fr;
    }

    .prendas-grid.list-view .prenda-card {
      display: flex;
      flex-direction: row;
      align-items: center;
      gap: 16px;
    }

    .prendas-grid.list-view .prenda-img-wrapper {
      width: 120px;
      height: 120px;
    }

    .prendas-grid.list-view .prenda-img {
      aspect-ratio: auto;
      height: 100%;
    }

    .prendas-grid.list-view .prenda-info {
      flex: 1;
    }

    /* CARD - Fondo #f5f5f5 igual al primer archivo */
    .prenda-card {
      background: var(--surface);
      border-radius: var(--radius-lg);
      overflow: hidden;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--border-light);
      cursor: pointer;
      transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      animation: fadeUp 0.4s ease forwards;
      opacity: 0;
    }

    .prenda-card:hover {
      transform: translateY(-4px);
      box-shadow: var(--shadow-md);
      border-color: var(--pastel-sky-dark);
    }

    .prenda-card.compare-select {
      border-color: var(--accent-lavender);
      box-shadow: 0 0 0 3px rgba(123,31,162,0.15);
    }

    .prenda-card.compare-select::after {
      content: 'check_circle';
      font-family: 'Material Symbols Rounded';
      position: absolute;
      top: 8px;
      left: 8px;
      font-size: 24px;
      color: var(--accent-lavender);
      background: white;
      border-radius: 50%;
      z-index: 2;
    }

    .prenda-img-wrapper {
      position: relative;
      overflow: hidden;
      background: #f5f5f5;
    }

    .prenda-img {
      width: 100%;
      aspect-ratio: 1;
      object-fit: cover;
      transition: transform 0.5s ease;
    }

    .prenda-card:hover .prenda-img {
      transform: scale(1.05);
    }

    .prenda-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(to top, rgba(26,26,46,0.6) 0%, transparent 50%);
      opacity: 0;
      transition: opacity 0.3s ease;
      display: flex;
      align-items: flex-end;
      justify-content: center;
      padding: 12px;
      gap: 8px;
    }

    .prenda-card:hover .prenda-overlay {
      opacity: 1;
    }

    .overlay-btn {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      border: none;
      background: rgba(255,255,255,0.9);
      backdrop-filter: blur(8px);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--text-primary);
      transition: all 0.2s ease;
      text-decoration: none;
    }

    .overlay-btn:hover {
      transform: scale(1.1);
      background: white;
    }

    .overlay-btn .material-symbols-rounded {
      font-size: 18px;
    }

    .overlay-btn.prettify-btn {
      background: var(--pastel-cream);
      color: var(--accent-cream);
    }

    .overlay-btn.prettify-btn:hover {
      background: var(--pastel-cream-dark);
    }

    .overlay-btn.delete-btn {
      background: var(--pastel-coral);
      color: var(--accent-coral);
    }

    .overlay-btn.delete-btn:hover {
      background: var(--pastel-coral-dark);
    }

    .prenda-info {
      padding: 12px;
    }

    .prenda-tipo {
      font-size: 10px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: var(--text-tertiary);
      margin-bottom: 4px;
    }

    .prenda-color {
      font-size: 13px;
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 2px;
    }

    .prenda-meta {
      font-size: 11px;
      color: var(--text-secondary);
      font-weight: 500;
    }

    .prenda-tags {
      display: flex;
      gap: 4px;
      margin-top: 8px;
      flex-wrap: wrap;
    }

    .prenda-tag {
      font-size: 9px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.03em;
      padding: 3px 8px;
      border-radius: 8px;
    }

    .tag-casual { background: var(--pastel-sage); color: var(--accent-sage); }
    .tag-formal { background: var(--pastel-lavender); color: var(--accent-lavender); }
    .tag-deportivo { background: var(--pastel-sky); color: var(--accent-sky); }
    .tag-elegante { background: var(--pastel-cream); color: var(--accent-cream); }
    .tag-bohemio { background: var(--pastel-coral); color: var(--accent-coral); }

    /* COMPARE MODAL */
    .compare-modal-overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(26,26,46,0.6);
      backdrop-filter: blur(8px);
      z-index: 500;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }

    .compare-modal-overlay.open {
      display: flex;
      animation: fadeIn 0.3s ease;
    }

    .compare-modal {
      background: var(--surface);
      border-radius: var(--radius-xl);
      padding: 28px;
      width: 100%;
      max-width: 800px;
      max-height: 90vh;
      overflow-y: auto;
      box-shadow: var(--shadow-lg);
      animation: slideUp 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .compare-modal-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 24px;
    }

    .compare-modal-title {
      font-family: 'DM Sans', sans-serif;
      font-size: 20px;
      font-weight: 700;
      color: var(--text-primary);
    }

    .compare-modal-close {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      border: none;
      background: var(--bg);
      color: var(--text-secondary);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.2s ease;
    }

    .compare-modal-close:hover {
      background: var(--pastel-coral);
      color: var(--accent-coral);
    }

    .compare-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 24px;
    }

    .compare-item {
      text-align: center;
    }

    .compare-item-img {
      width: 100%;
      max-width: 280px;
      aspect-ratio: 1;
      object-fit: cover;
      border-radius: var(--radius-lg);
      background: #f5f5f5;
      margin: 0 auto 16px;
    }

    .compare-item-name {
      font-family: 'DM Sans', sans-serif;
      font-size: 16px;
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 4px;
    }

    .compare-item-type {
      font-size: 12px;
      color: var(--text-tertiary);
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin-bottom: 16px;
    }

    .compare-details {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .compare-detail {
      display: flex;
      justify-content: space-between;
      padding: 10px 14px;
      background: var(--bg);
      border-radius: var(--radius-sm);
      font-size: 12px;
    }

    .compare-detail-label {
      font-weight: 600;
      color: var(--text-secondary);
    }

    .compare-detail-value {
      font-weight: 700;
      color: var(--text-primary);
    }

    .compare-vs {
      display: flex;
      align-items: center;
      justify-content: center;
      flex-direction: column;
      gap: 8px;
    }

    .vs-badge {
      width: 48px;
      height: 48px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--accent-lavender), var(--accent-sky));
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'DM Sans', sans-serif;
      font-size: 14px;
      font-weight: 800;
    }

    /* MODAL AGREGAR */
    .modal-overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(26,26,46,0.5);
      backdrop-filter: blur(4px);
      z-index: 200;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }

    .modal-overlay.open {
      display: flex;
      animation: fadeIn 0.3s ease;
    }

    .modal {
      background: var(--surface);
      border-radius: var(--radius-xl);
      padding: 28px;
      width: 100%;
      max-width: 480px;
      max-height: 90vh;
      overflow-y: auto;
      box-shadow: var(--shadow-lg);
      animation: slideUp 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .modal-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 20px;
    }

    .modal-title {
      font-family: 'DM Sans', sans-serif;
      font-size: 18px;
      font-weight: 700;
      color: var(--text-primary);
    }

    .modal-close {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      border: none;
      background: var(--bg);
      color: var(--text-secondary);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.2s ease;
    }

    .modal-close:hover {
      background: var(--pastel-coral);
      color: var(--accent-coral);
    }

    .form-group {
      margin-bottom: 16px;
    }

    .form-group label {
      display: block;
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin-bottom: 6px;
      color: var(--text-secondary);
    }

    .form-group input,
    .form-group select {
      width: 100%;
      padding: 10px 14px;
      border: 1.5px solid var(--border);
      border-radius: var(--radius-md);
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 13px;
      font-weight: 500;
      color: var(--text-primary);
      background: var(--surface);
      transition: all 0.2s ease;
      outline: none;
    }

    .form-group input:focus,
    .form-group select:focus {
      border-color: var(--pastel-sky-dark);
      box-shadow: 0 0 0 3px rgba(25,118,210,0.08);
    }

    .img-preview-wrapper {
      position: relative;
      width: 100%;
      aspect-ratio: 1;
      border-radius: var(--radius-md);
      overflow: hidden;
      background: #f5f5f5;
      margin-bottom: 8px;
      display: none;
    }

    .img-preview-wrapper.visible {
      display: block;
    }

    .img-preview {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .img-preview-remove {
      position: absolute;
      top: 8px;
      right: 8px;
      width: 28px;
      height: 28px;
      border-radius: 50%;
      border: none;
      background: var(--pastel-coral);
      color: var(--accent-coral);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .file-input-wrapper {
      position: relative;
      overflow: hidden;
      display: inline-block;
      width: 100%;
    }

    .file-input-wrapper input[type=file] {
      position: absolute;
      left: -9999px;
    }

    .file-input-label {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      width: 100%;
      padding: 12px;
      border: 2px dashed var(--border);
      border-radius: var(--radius-md);
      cursor: pointer;
      transition: all 0.2s ease;
      font-size: 12px;
      font-weight: 600;
      color: var(--text-secondary);
    }

    .file-input-label:hover {
      border-color: var(--pastel-sky-dark);
      background: var(--pastel-sky);
      color: var(--accent-sky);
    }

    .file-input-label .material-symbols-rounded {
      font-size: 20px;
    }

    .subcategoria-group {
      display: none;
    }

    .subcategoria-group.visible {
      display: block;
      animation: fadeUp 0.3s ease;
    }

    .modal-actions {
      display: flex;
      gap: 10px;
      margin-top: 24px;
    }

    .btn-primary {
      flex: 1;
      padding: 12px;
      background: linear-gradient(135deg, var(--accent-sky), var(--accent-lavender));
      color: #fff;
      border: none;
      border-radius: var(--radius-md);
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 13px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.25s ease;
      box-shadow: 0 4px 12px rgba(25,118,210,0.2);
    }

    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(25,118,210,0.3);
    }

    .btn-primary:disabled {
      opacity: 0.6;
      cursor: not-allowed;
      transform: none;
    }

    .btn-secondary {
      flex: 1;
      padding: 12px;
      background: var(--bg);
      color: var(--text-secondary);
      border: 1.5px solid var(--border);
      border-radius: var(--radius-md);
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 13px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .btn-secondary:hover {
      background: var(--pastel-coral);
      color: var(--accent-coral);
      border-color: var(--pastel-coral-dark);
    }

    /* TOAST */
    .toast {
      position: fixed;
      bottom: 24px;
      left: 50%;
      transform: translateX(-50%) translateY(100px);
      background: var(--text-primary);
      color: #fff;
      padding: 12px 24px;
      border-radius: 24px;
      font-size: 13px;
      font-weight: 600;
      opacity: 0;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      pointer-events: none;
      z-index: 300;
      display: flex;
      align-items: center;
      gap: 8px;
      box-shadow: var(--shadow-lg);
    }

    .toast.show {
      opacity: 1;
      transform: translateX(-50%) translateY(0);
    }

    .toast .material-symbols-rounded {
      font-size: 18px;
    }

    /* LOADING OVERLAY */
    .loading-overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(26,26,46,0.4);
      backdrop-filter: blur(4px);
      z-index: 400;
      align-items: center;
      justify-content: center;
      flex-direction: column;
      gap: 16px;
    }

    .loading-overlay.visible {
      display: flex;
    }

    .spinner {
      width: 48px;
      height: 48px;
      border: 3px solid var(--pastel-sky);
      border-top-color: var(--accent-sky);
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }

    .loading-text {
      color: white;
      font-size: 14px;
      font-weight: 700;
    }

    /* ANIMATIONS */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(12px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes slideDown {
      from { opacity: 0; transform: translateY(-10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    /* EMPTY STATE */
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      color: var(--text-tertiary);
      grid-column: 1 / -1;
    }

    .empty-state .material-symbols-rounded {
      font-size: 64px;
      margin-bottom: 16px;
      display: block;
      color: var(--border);
    }

    .empty-state h3 {
      font-family: 'DM Sans', sans-serif;
      font-size: 18px;
      font-weight: 700;
      color: var(--text-secondary);
      margin-bottom: 8px;
    }

    .empty-state p {
      font-size: 13px;
      color: var(--text-tertiary);
    }

    /* RESPONSIVE */
    @media (max-width: 768px) {
      .main-content { padding: 12px; }
      .prendas-grid { grid-template-columns: repeat(2, 1fr); }
      .compare-grid { grid-template-columns: 1fr; }
      .toolbar { flex-direction: column; gap: 12px; align-items: stretch; }
      .toolbar-right { flex-wrap: wrap; }
      .search-box { width: 100%; }
      .welcome-section { flex-direction: column; gap: 12px; text-align: center; }
      .welcome-actions { flex-wrap: wrap; justify-content: center; }
    }

    ::-webkit-scrollbar { width: 4px; height: 4px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }
  </style>
</head>
<body>
<div class="layout-wrapper">

  <jsp:include page="/includes/sidebar.jsp"/>

  <main class="main-content" id="mainContent">
    <div class="page">

      <!-- Welcome Section -->
      <div class="welcome-section">
        <div class="welcome-content">
          <h1 class="welcome-title">Mi <span>Closet Virtual</span></h1>
          <p class="welcome-subtitle">Organiza, visualiza y dale estilo a tu guardarropa.</p>
        </div>
        <div class="welcome-actions">
          <button class="btn-compare-toggle" id="btnCompareToggle" onclick="toggleCompareMode()">
            <span class="material-symbols-rounded">compare_arrows</span>
            <span id="compareLabel">Comparar</span>
          </button>
          <button class="btn-add" onclick="abrirModal()">
            <span class="material-symbols-rounded">add_circle</span>
            <span>Agregar Prenda</span>
          </button>
        </div>
      </div>

      <!-- Chips de categorias - IGUAL AL CATALOGO -->
      <div class="chips-section">
        <div class="chips-container">
          <div class="chips-row" id="catRow">
            <button class="cat-chip active" data-cat="all" onclick="filterByCategory('all', this)">
              <span class="material-symbols-rounded" style="font-size:14px;">auto_awesome</span> Todas
            </button>
            <button class="cat-chip" data-cat="tops" onclick="filterByCategory('tops', this)">
              <span class="material-symbols-rounded" style="font-size:14px;">checkroom</span> Tops
            </button>
            <button class="cat-chip" data-cat="bottoms" onclick="filterByCategory('bottoms', this)">
              <span class="material-symbols-rounded" style="font-size:14px;">checkroom</span> Pantalones
            </button>
            <button class="cat-chip" data-cat="dresses" onclick="filterByCategory('dresses', this)">
              <span class="material-symbols-rounded" style="font-size:14px;">checkroom</span> Vestidos
            </button>
            <button class="cat-chip" data-cat="outerwear" onclick="filterByCategory('outerwear', this)">
              <span class="material-symbols-rounded" style="font-size:14px;">checkroom</span> Outerwear
            </button>
            <button class="cat-chip" data-cat="shoes" onclick="filterByCategory('shoes', this)">
              <span class="material-symbols-rounded" style="font-size:14px;">checkroom</span> Zapatos
            </button>
            <button class="cat-chip" data-cat="accessories" onclick="filterByCategory('accessories', this)">
              <span class="material-symbols-rounded" style="font-size:14px;">checkroom</span> Accesorios
            </button>
          </div>
        </div>
      </div>

      <!-- Compare Bar -->
      <div class="compare-bar" id="compareBar">
        <div class="compare-info">
          <span class="material-symbols-rounded">compare_arrows</span>
          <span id="compareCount">Selecciona 2 prendas para comparar</span>
        </div>
        <div class="compare-actions">
          <button class="compare-btn secondary" onclick="cancelCompare()">
            <span class="material-symbols-rounded">close</span>
            Cancelar
          </button>
        </div>
      </div>

      <!-- Toolbar - IGUAL AL CATALOGO -->
      <div class="toolbar">
        <div class="toolbar-left">
          <div class="toolbar-title-group">
            <h2 id="sectionTitle">Todas las Prendas</h2>
            <p id="prendaCount">${totalPrendas != null ? totalPrendas : '0'} prendas</p>
          </div>
        </div>
        <div class="toolbar-right">
          <div class="search-box">
            <span class="material-symbols-rounded search-icon">search</span>
            <input type="text" id="searchInput" placeholder="Buscar prenda..." oninput="searchPrendas()">
          </div>
          <select class="filter-select" id="estiloFilter" onchange="filterByEstilo()">
            <option value="">Todos los estilos</option>
            <option value="casual">Casual</option>
            <option value="formal">Formal</option>
            <option value="deportivo">Deportivo</option>
            <option value="elegante">Elegante</option>
            <option value="bohemio">Bohemio</option>
          </select>
          <select class="filter-select" id="temporadaFilter" onchange="filterByTemporada()">
            <option value="">Todas las temporadas</option>
            <option value="primavera">Primavera</option>
            <option value="verano">Verano</option>
            <option value="otono">Otono</option>
            <option value="invierno">Invierno</option>
          </select>
          <div class="view-toggle">
            <button class="view-btn active" onclick="setView('grid', this)" title="Vista grid">
              <span class="material-symbols-rounded">grid_view</span>
            </button>
            <button class="view-btn" onclick="setView('list', this)" title="Vista lista">
              <span class="material-symbols-rounded">view_list</span>
            </button>
          </div>
        </div>
      </div>

      <!-- Grid de prendas -->
      <div class="prendas-grid" id="gridPrendas">
        <c:choose>
          <c:when test="${empty prendas}">
            <div class="empty-state">
              <span class="material-symbols-rounded">checkroom</span>
              <h3>Tu closet esta vacio</h3>
              <p>Agrega tu primera prenda para empezar</p>
            </div>
          </c:when>
          <c:otherwise>
            <c:forEach var="p" items="${prendas}" varStatus="status">
              <div class="prenda-card" data-tipo="${p.tipo}" data-id="${p.id}" data-color="${fn:toLowerCase(p.color)}" data-estilo="${p.estilo}" data-temporada="${p.temporada}" style="animation-delay: ${status.index * 0.03}s" onclick="handleCardClick(this, event)">
                <div class="prenda-img-wrapper">
                  <img class="prenda-img" src="${ctx}/${p.imagen}" alt="${p.tipo}" onerror="this.src='${ctx}/img/placeholder.png'" />
                  <div class="prenda-overlay">
                    <button class="overlay-btn prettify-btn" onclick="prettify(${p.id}, event)" title="Prettify">
                      <span class="material-symbols-rounded">auto_fix_high</span>
                    </button>
                    <button class="overlay-btn delete-btn" onclick="eliminarPrenda(${p.id}, event)" title="Eliminar">
                      <span class="material-symbols-rounded">delete</span>
                    </button>
                  </div>
                </div>
                <div class="prenda-info">
                  <div class="prenda-tipo">${p.tipo}</div>
                  <div class="prenda-color">${p.color}</div>
                  <div class="prenda-meta">${p.estilo} - ${p.temporada}</div>
                  <div class="prenda-tags">
                    <span class="prenda-tag tag-${p.estilo}">${p.estilo}</span>
                  </div>
                </div>
              </div>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </main>

</div>

<!-- Modal agregar prenda -->
<div class="modal-overlay" id="modalOverlay">
  <div class="modal">
    <div class="modal-header">
      <h2 class="modal-title">Agregar prenda</h2>
      <button class="modal-close" onclick="cerrarModal()">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>
    <form id="formPrenda" enctype="multipart/form-data">
      <div class="form-group">
        <label>Foto de la prenda</label>
        <div class="img-preview-wrapper" id="imgPreviewWrapper">
          <img id="imgPreview" class="img-preview" alt="preview" />
          <button type="button" class="img-preview-remove" onclick="clearPreview()">
            <span class="material-symbols-rounded">close</span>
          </button>
        </div>
        <div class="file-input-wrapper">
          <input type="file" name="imagen" id="inputImagen" accept="image/*" required onchange="previewImagen(this)" />
          <label for="inputImagen" class="file-input-label">
            <span class="material-symbols-rounded">add_photo_alternate</span>
            <span id="fileLabelText">Seleccionar imagen</span>
          </label>
        </div>
        <small style="color:var(--text-tertiary);font-size:11px;margin-top:6px;display:block">
          Se aplicara Prettify automaticamente
        </small>
      </div>

      <div class="form-group">
        <label>Tipo</label>
        <select name="tipo" id="selectTipo" required onchange="toggleSubcategoria(this)">
          <option value="">Selecciona...</option>
          <option value="tops">Top</option>
          <option value="bottoms">Pantalon / Falda</option>
          <option value="dresses">Vestido</option>
          <option value="outerwear">Outerwear</option>
          <option value="shoes">Zapatos</option>
          <option value="accessories">Accesorio</option>
        </select>
      </div>

      <div class="form-group subcategoria-group" id="subcategoriaGroup">
        <label>Tipo de accesorio</label>
        <select name="subcategoria" id="selectSubcategoria">
          <option value="">Selecciona...</option>
          <option value="collar">Collar / Cadena</option>
          <option value="aretes">Aretes / Pendientes</option>
          <option value="bolso">Bolso / Cartera</option>
          <option value="cinturon">Cinturon</option>
          <option value="gafas">Gafas / Lentes</option>
          <option value="anillo">Anillo</option>
          <option value="pulsera">Pulsera / Brazalete</option>
          <option value="sombrero">Sombrero / Gorra</option>
          <option value="otro">Otro accesorio</option>
        </select>
      </div>

      <div class="form-group">
        <label>Color</label>
        <input type="text" name="color" placeholder="ej: negro, beige, floral" required />
      </div>

      <div class="form-group">
        <label>Estilo</label>
        <select name="estilo">
          <option value="casual">Casual</option>
          <option value="formal">Formal</option>
          <option value="deportivo">Deportivo</option>
          <option value="elegante">Elegante</option>
          <option value="bohemio">Bohemio</option>
        </select>
      </div>

      <div class="form-group">
        <label>Temporada</label>
        <select name="temporada">
          <option value="todas">Todas</option>
          <option value="primavera">Primavera</option>
          <option value="verano">Verano</option>
          <option value="otono">Otono</option>
          <option value="invierno">Invierno</option>
        </select>
      </div>

      <div class="modal-actions">
        <button type="button" class="btn-secondary" onclick="cerrarModal()">Cancelar</button>
        <button type="submit" class="btn-primary" id="btnGuardar">Guardar prenda</button>
      </div>
    </form>
  </div>
</div>

<!-- Compare Modal -->
<div class="compare-modal-overlay" id="compareModalOverlay">
  <div class="compare-modal">
    <div class="compare-modal-header">
      <h2 class="compare-modal-title">Comparar Prendas</h2>
      <button class="compare-modal-close" onclick="cerrarCompareModal()">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>
    <div class="compare-grid" id="compareGrid">
      <!-- Se llena dinamicamente -->
    </div>
  </div>
</div>

<!-- Toast -->
<div class="toast" id="toast"></div>

<!-- Loading Overlay -->
<div class="loading-overlay" id="loadingOverlay">
  <div class="spinner"></div>
  <div class="loading-text">Procesando...</div>
</div>

<script>
  var ctx = '${ctx}';
  var compareMode = false;
  var compareSelection = [];
  var activeCat = 'all';
  var activeEstilo = '';
  var activeTemporada = '';
  var searchTerm = '';

  var SECTION_TITLES = {
    'all': 'Todas las Prendas',
    'tops': 'Tops',
    'bottoms': 'Pantalones y Faldas',
    'dresses': 'Vestidos',
    'outerwear': 'Outerwear',
    'shoes': 'Zapatos',
    'accessories': 'Accesorios'
  };

  // ── CHIPS FILTER - IGUAL AL CATALOGO ──
  function filterByCategory(cat, btn) {
    activeCat = cat;

    // Actualizar chips activos
    document.querySelectorAll('.cat-chip').forEach(function(c) { c.classList.remove('active'); });
    if (btn) btn.classList.add('active');

    // Actualizar titulo
    var title = SECTION_TITLES[cat] || 'Prendas';
    document.getElementById('sectionTitle').textContent = title;

    applyFilters();
  }

  // ── FILTROS DROPDOWN ──
  function filterByEstilo() {
    activeEstilo = document.getElementById('estiloFilter').value;
    applyFilters();
  }

  function filterByTemporada() {
    activeTemporada = document.getElementById('temporadaFilter').value;
    applyFilters();
  }

  // ── BUSQUEDA ──
  function searchPrendas() {
    searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
    applyFilters();
  }

  // ── APLICAR TODOS LOS FILTROS ──
  function applyFilters() {
    var cards = document.querySelectorAll('.prenda-card');
    var visible = 0;

    cards.forEach(function(card) {
      var tipo = card.getAttribute('data-tipo') || '';
      var estilo = card.getAttribute('data-estilo') || '';
      var temporada = card.getAttribute('data-temporada') || '';
      var color = card.getAttribute('data-color') || '';
      var nombre = (card.querySelector('.prenda-color') || {}).textContent || '';
      var show = true;

      // Filtro categoria
      if (activeCat !== 'all' && tipo !== activeCat) show = false;

      // Filtro estilo
      if (show && activeEstilo && estilo !== activeEstilo) show = false;

      // Filtro temporada
      if (show && activeTemporada && temporada !== activeTemporada) show = false;

      // Filtro busqueda
      if (show && searchTerm) {
        var text = (nombre + ' ' + color + ' ' + tipo + ' ' + estilo).toLowerCase();
        if (text.indexOf(searchTerm) === -1) show = false;
      }

      card.style.display = show ? '' : 'none';
      if (show) visible++;
    });

    document.getElementById('prendaCount').textContent = visible + ' prenda' + (visible !== 1 ? 's' : '');
  }

  // ── COMPARE MODE ──
  function toggleCompareMode() {
    compareMode = !compareMode;
    var btn = document.getElementById('btnCompareToggle');
    var label = document.getElementById('compareLabel');
    var bar = document.getElementById('compareBar');

    if (compareMode) {
      btn.classList.add('active');
      label.textContent = 'Comparando...';
      bar.classList.add('visible');
      mostrarToast('Selecciona 2 prendas para comparar');
    } else {
      btn.classList.remove('active');
      label.textContent = 'Comparar';
      bar.classList.remove('visible');
      cancelCompare();
    }
  }

  function handleCardClick(card, event) {
    if (event.target.closest('.prenda-overlay') || event.target.closest('.overlay-btn')) {
      return;
    }

    if (!compareMode) return;

    var id = parseInt(card.getAttribute('data-id'));
    var index = compareSelection.indexOf(id);

    if (index > -1) {
      compareSelection.splice(index, 1);
      card.classList.remove('compare-select');
    } else {
      if (compareSelection.length >= 2) {
        mostrarToast('Solo puedes comparar 2 prendas');
        return;
      }
      compareSelection.push(id);
      card.classList.add('compare-select');
    }

    updateCompareBar();

    if (compareSelection.length === 2) {
      setTimeout(function() {
        abrirCompareModal();
      }, 300);
    }
  }

  function updateCompareBar() {
    var count = document.getElementById('compareCount');
    var remaining = 2 - compareSelection.length;

    if (remaining === 2) {
      count.textContent = 'Selecciona 2 prendas para comparar';
    } else if (remaining === 1) {
      count.textContent = 'Selecciona 1 prenda mas';
    } else {
      count.textContent = 'Listo para comparar';
    }
  }

  function cancelCompare() {
    compareSelection.forEach(function(id) {
      var card = document.querySelector('[data-id="' + id + '"]');
      if (card) card.classList.remove('compare-select');
    });
    compareSelection = [];
    updateCompareBar();
  }

  // ── COMPARE MODAL ──
  function abrirCompareModal() {
    var id1 = compareSelection[0];
    var id2 = compareSelection[1];

    var card1 = document.querySelector('[data-id="' + id1 + '"]');
    var card2 = document.querySelector('[data-id="' + id2 + '"]');

    if (!card1 || !card2) {
      mostrarToast('Error: no se encontraron las prendas');
      return;
    }

    var img1 = card1.querySelector('.prenda-img').src;
    var tipo1 = card1.querySelector('.prenda-tipo').textContent;
    var color1 = card1.querySelector('.prenda-color').textContent;
    var meta1 = card1.querySelector('.prenda-meta').textContent;
    var estilo1 = card1.getAttribute('data-estilo');
    var tipoRaw1 = card1.getAttribute('data-tipo');
    var temporada1 = card1.getAttribute('data-temporada');

    var img2 = card2.querySelector('.prenda-img').src;
    var tipo2 = card2.querySelector('.prenda-tipo').textContent;
    var color2 = card2.querySelector('.prenda-color').textContent;
    var meta2 = card2.querySelector('.prenda-meta').textContent;
    var estilo2 = card2.getAttribute('data-estilo');
    var tipoRaw2 = card2.getAttribute('data-tipo');
    var temporada2 = card2.getAttribute('data-temporada');

    var grid = document.getElementById('compareGrid');
    grid.innerHTML =
      '<div class="compare-item">' +
        '<img src="' + img1 + '" class="compare-item-img" alt="' + tipo1 + '" onerror="this.src=\'' + ctx + '/img/placeholder.png\'">' +
        '<div class="compare-item-name">' + color1 + '</div>' +
        '<div class="compare-item-type">' + tipo1 + '</div>' +
        '<div class="compare-details">' +
          '<div class="compare-detail"><span class="compare-detail-label">Estilo</span><span class="compare-detail-value">' + estilo1 + '</span></div>' +
          '<div class="compare-detail"><span class="compare-detail-label">Temporada</span><span class="compare-detail-value">' + temporada1 + '</span></div>' +
          '<div class="compare-detail"><span class="compare-detail-label">Tipo</span><span class="compare-detail-value">' + tipoRaw1 + '</span></div>' +
          '<div class="compare-detail"><span class="compare-detail-label">Color</span><span class="compare-detail-value">' + color1 + '</span></div>' +
        '</div>' +
      '</div>' +
      '<div class="compare-vs">' +
        '<div class="vs-badge">VS</div>' +
      '</div>' +
      '<div class="compare-item">' +
        '<img src="' + img2 + '" class="compare-item-img" alt="' + tipo2 + '" onerror="this.src=\'' + ctx + '/img/placeholder.png\'">' +
        '<div class="compare-item-name">' + color2 + '</div>' +
        '<div class="compare-item-type">' + tipo2 + '</div>' +
        '<div class="compare-details">' +
          '<div class="compare-detail"><span class="compare-detail-label">Estilo</span><span class="compare-detail-value">' + estilo2 + '</span></div>' +
          '<div class="compare-detail"><span class="compare-detail-label">Temporada</span><span class="compare-detail-value">' + temporada2 + '</span></div>' +
          '<div class="compare-detail"><span class="compare-detail-label">Tipo</span><span class="compare-detail-value">' + tipoRaw2 + '</span></div>' +
          '<div class="compare-detail"><span class="compare-detail-label">Color</span><span class="compare-detail-value">' + color2 + '</span></div>' +
        '</div>' +
      '</div>';

    document.getElementById('compareModalOverlay').classList.add('open');
  }

  function cerrarCompareModal() {
    document.getElementById('compareModalOverlay').classList.remove('open');
    cancelCompare();
    toggleCompareMode();
  }

  document.getElementById('compareModalOverlay').addEventListener('click', function(e) {
    if (e.target === e.currentTarget) cerrarCompareModal();
  });

  // ── VISTA GRID/LIST ──
  function setView(view, btn) {
    document.querySelectorAll('.view-btn').forEach(function(b) { b.classList.remove('active'); });
    btn.classList.add('active');

    var grid = document.getElementById('gridPrendas');
    if (view === 'list') {
      grid.classList.add('list-view');
    } else {
      grid.classList.remove('list-view');
    }
  }

  // ── MODAL ──
  function abrirModal() {
    document.getElementById('modalOverlay').classList.add('open');
  }

  function cerrarModal() {
    document.getElementById('modalOverlay').classList.remove('open');
    document.getElementById('formPrenda').reset();
    clearPreview();
    document.getElementById('subcategoriaGroup').classList.remove('visible');
    document.getElementById('selectSubcategoria').required = false;
  }

  document.getElementById('modalOverlay').addEventListener('click', function(e) {
    if (e.target === e.currentTarget) cerrarModal();
  });

  // ── PREVIEW IMAGEN ──
  function previewImagen(input) {
    if (input.files && input.files[0]) {
      var wrapper = document.getElementById('imgPreviewWrapper');
      var img = document.getElementById('imgPreview');
      var label = document.getElementById('fileLabelText');

      img.src = URL.createObjectURL(input.files[0]);
      wrapper.classList.add('visible');
      label.textContent = input.files[0].name;
    }
  }

  function clearPreview() {
    var wrapper = document.getElementById('imgPreviewWrapper');
    var input = document.getElementById('inputImagen');
    var label = document.getElementById('fileLabelText');

    wrapper.classList.remove('visible');
    input.value = '';
    label.textContent = 'Seleccionar imagen';
  }

  // ── SUBCATEGORIA ──
  function toggleSubcategoria(sel) {
    var grupo = document.getElementById('subcategoriaGroup');
    var subSel = document.getElementById('selectSubcategoria');
    if (sel.value === 'accessories') {
      grupo.classList.add('visible');
      subSel.required = true;
    } else {
      grupo.classList.remove('visible');
      subSel.required = false;
      subSel.value = '';
    }
  }

  // ── GUARDAR PRENDA ──
  document.getElementById('formPrenda').addEventListener('submit', function(e) {
    e.preventDefault();
    var btn = document.getElementById('btnGuardar');
    btn.textContent = 'Guardando...';
    btn.disabled = true;
    showLoading('Aplicando Prettify...');

    var fd = new FormData(e.target);
    var xhr = new XMLHttpRequest();
    xhr.open('POST', ctx + '/closet/prenda', true);
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        hideLoading();
        btn.textContent = 'Guardar prenda';
        btn.disabled = false;

        if (xhr.status === 201) {
          mostrarToast('Prenda agregada con Prettify');
          cerrarModal();
          setTimeout(function() { location.reload(); }, 1200);
        } else {
          var data = {};
          try { data = JSON.parse(xhr.responseText); } catch(e) {}
          mostrarToast('Error: ' + (data.error || 'No se pudo guardar'));
        }
      }
    };
    xhr.send(fd);
  });

  // ── PRETTIFY ──
  function prettify(id, e) {
    e.stopPropagation();
    showLoading('Aplicando Prettify...');
    var xhr = new XMLHttpRequest();
    xhr.open('POST', ctx + '/closet/prenda/' + id + '/prettify', true);
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        hideLoading();
        if (xhr.status === 200) {
          mostrarToast('Prettify aplicado');
          setTimeout(function() { location.reload(); }, 1000);
        } else {
          var data = {};
          try { data = JSON.parse(xhr.responseText); } catch(e) {}
          mostrarToast('Error: ' + (data.error || 'No se pudo procesar'));
        }
      }
    };
    xhr.send();
  }

  // ── ELIMINAR ──
  function eliminarPrenda(id, e) {
    e.stopPropagation();
    if (!confirm('Eliminar esta prenda?')) return;

    var xhr = new XMLHttpRequest();
    xhr.open('DELETE', ctx + '/closet/prenda/' + id, true);
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          var card = document.querySelector('[data-id="' + id + '"]');
          if (card) {
            card.style.transform = 'scale(0.8)';
            card.style.opacity = '0';
            setTimeout(function() { card.remove(); }, 300);
          }
          mostrarToast('Prenda eliminada');
        } else {
          var data = {};
          try { data = JSON.parse(xhr.responseText); } catch(e) {}
          mostrarToast('Error: ' + (data.error || 'No se pudo eliminar'));
        }
      }
    };
    xhr.send();
  }

  // ── TOAST ──
  function mostrarToast(msg) {
    var t = document.getElementById('toast');
    t.innerHTML = '<span class="material-symbols-rounded">info</span><span>' + msg + '</span>';
    t.classList.add('show');
    setTimeout(function() { t.classList.remove('show'); }, 3000);
  }

  // ── LOADING ──
  function showLoading(text) {
    var overlay = document.getElementById('loadingOverlay');
    overlay.querySelector('.loading-text').textContent = text || 'Procesando...';
    overlay.classList.add('visible');
  }

  function hideLoading() {
    document.getElementById('loadingOverlay').classList.remove('visible');
  }
</script>
</body>
</html>