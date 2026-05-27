package com.quiddity.filter;

import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Usuario;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AuthFilter
 *
 * Protege todas las rutas internas según el rol del usuario en sesión.
 *
 * Rutas públicas (sin sesión): /login, /registro, /index.jsp, recursos estáticos
 *
 * Rutas protegidas:
 *   /admin/*      → solo ROL_ADMIN     (1)
 *   /usuario/*    → solo ROL_USUARIO   (2)
 *   /inicio       → solo ROL_USUARIO   (2)
 *   /closet       → solo ROL_USUARIO   (2)
 *   /facescan     → solo ROL_USUARIO   (2)
 *   /rutina       → solo ROL_USUARIO   (2)
 *   /sugerencias  → solo ROL_USUARIO   (2)
 *   /comprador/*  → solo ROL_COMPRADOR (3)
 *   /carrito      → solo ROL_COMPRADOR (3)
 *   /catalogo     → ROL_USUARIO (2) y ROL_COMPRADOR (3) y ROL_ADMIN (1)
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String uri         = req.getRequestURI();
        // Ruta relativa al contexto
        String path = uri.substring(contextPath.length());

        // ── 1. Rutas siempre permitidas (públicas) ──────────────────────────
        if (esPublica(path)) {
            chain.doFilter(request, response);
            return;
        }

        // ── 2. Verificar sesión activa ─────────────────────────────────────
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            resp.sendRedirect(contextPath + "/login");
            return;
        }

        int rol = usuario.getIdRol();

        // ── 3. Verificar permisos según ruta ────────────────────────────────

        // Solo Admin
        if (path.startsWith("/admin")) {
            if (rol != UsuarioDAO.ROL_ADMIN) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // Solo Comprador
        if (path.startsWith("/comprador") || path.startsWith("/carrito")) {
            if (rol != UsuarioDAO.ROL_COMPRADOR && rol != UsuarioDAO.ROL_ADMIN) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // Solo Usuario (rol 2) — páginas exclusivas
        if (esRutaExclusivaUsuario(path)) {
            if (rol != UsuarioDAO.ROL_USUARIO && rol != UsuarioDAO.ROL_ADMIN) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // Catálogo — accesible para todos los roles autenticados
        if (path.startsWith("/catalogo")) {
            chain.doFilter(request, response);
            return;
        }

        // Gestión de usuarios — protegida (el servlet hace su propia lógica interna)
        if (path.startsWith("/usuarios")) {
            chain.doFilter(request, response);
            return;
        }

        // Cualquier otra ruta autenticada: dejar pasar
        chain.doFilter(request, response);
    }

    // ── Helpers ─────────────────────────────────────────────────────────────

    private boolean esPublica(String path) {
        return path.equals("/login")
            || path.equals("/logout")
            || path.equals("/registro")
            || path.equals("/")
            || path.equals("/index.jsp")
            || path.startsWith("/css/")
            || path.startsWith("/js/")
            || path.startsWith("/img/")
            || path.startsWith("/uploads/")
            || path.startsWith("/favicon");
    }

    private boolean esRutaExclusivaUsuario(String path) {
        return path.startsWith("/inicio")
            || path.startsWith("/closet")
            || path.startsWith("/facescan")
            || path.startsWith("/rutina")
            || path.startsWith("/sugerencias")
            || path.startsWith("/usuario/");
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}