package com.quiddity.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.quiddity.dao.DashboardDAO;
import com.quiddity.model.Usuario;

/**
 * DashboardServlet
 *
 * Rutas:
 *   GET  /admin/dashboard  → panel principal del admin con datos en JSP
 *   GET  /api/dashboard   → API JSON con todos los datos
 */
@WebServlet(urlPatterns = {"/admin/dashboard", "/api/dashboard"})
public class DashboardServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Verificar sesión y rol admin
        HttpSession session = req.getSession(false);
        Usuario sesionUsuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        
        if (sesionUsuario == null || sesionUsuario.getIdRol() != 1) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        String uri = req.getRequestURI();
        
        // Si es /api/dashboard → devuelve JSON
        if (uri.endsWith("/api/dashboard")) {
            respJSON(req, resp);
            return;
        }
        
        // Si es /admin/dashboard → forward al JSP con datos
        respJSP(req, resp);
    }
    
    /**
     * Responde con JSON (para AJAX futuro)
     */
    private void respJSON(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        try {
            Map<String, Object> response = new java.util.LinkedHashMap<>();
            response.put("kpis", dashboardDAO.obtenerKPIs());
            response.put("heatmap", dashboardDAO.obtenerActividadHeatmap());
            response.put("livefeed", dashboardDAO.obtenerUltimosPedidos());
            response.put("topProducts", dashboardDAO.obtenerTopProductos());
            response.put("salesCalendar", dashboardDAO.obtenerCalendarioVentas());
            response.put("categories", dashboardDAO.obtenerCategoriasBurbujas());
            response.put("healthRadar", dashboardDAO.obtenerSaludRadar());
            response.put("actividadReciente", dashboardDAO.obtenerActividadReciente());
            response.put("success", true);
            
            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(response));
            out.flush();
            
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = resp.getWriter();
            out.print("{\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
            out.flush();
            e.printStackTrace();
        }
    }
    
    /**
     * Forward al JSP con todos los datos como atributos
     */
    private void respJSP(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setAttribute("kpis", dashboardDAO.obtenerKPIs());
        req.setAttribute("heatmap", dashboardDAO.obtenerActividadHeatmap());
        req.setAttribute("livefeed", dashboardDAO.obtenerUltimosPedidos());
        req.setAttribute("topProducts", dashboardDAO.obtenerTopProductos());
        req.setAttribute("salesCalendar", dashboardDAO.obtenerCalendarioVentas());
        req.setAttribute("categories", dashboardDAO.obtenerCategoriasBurbujas());
        req.setAttribute("healthRadar", dashboardDAO.obtenerSaludRadar());
        req.setAttribute("actividadReciente", dashboardDAO.obtenerActividadReciente());
        
        req.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(req, resp);
    }
}