package com.quiddity.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Usuario;

/**
 * AuthFilter
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI();
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
                || path.equals("/login.jsp")
                || path.equals("/logout")
                || path.equals("/registro")
                || path.equals("/registro.jsp")
                || path.equals("/")
                || path.equals("/index.jsp")
                || path.equals("/catalogo.jsp")
                || path.equals("/chatbot")
                || path.equals("/recuperar")
                // recursos estáticos
                || path.startsWith("/uploads/")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/img/")
                || path.endsWith(".css")
                || path.endsWith(".js")
                || path.endsWith(".jpg")
                || path.endsWith(".jpeg")
                || path.endsWith(".png")
                || path.endsWith(".gif")
                || path.endsWith(".svg")
                || path.endsWith(".ico")
                || path.endsWith(".mp4");
    }

    private boolean esRutaExclusivaUsuario(String path) {
        return path.startsWith("/inicio")
                || path.startsWith("/closet")
                || path.startsWith("/facefull")
                || path.startsWith("/rutina")
                || path.startsWith("/sugerencias")
                || path.startsWith("/usuario/")
                || path.startsWith("/caracteristicas")
                || path.startsWith("/outfit") // ← agregar
                || path.startsWith("/outfitprenda")
                || path.startsWith("/closet/prenda")
                || path.startsWith("/look")
                || path.startsWith("/calendario")
                || path.startsWith("/viajes")
                || path.startsWith("/chat");
    }

    @Override
    public void init(FilterConfig fc) {
    }

    @Override
    public void destroy() {
    }
}
