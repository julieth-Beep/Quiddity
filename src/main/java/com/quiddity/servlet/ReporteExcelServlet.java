package com.quiddity.servlet;

import com.quiddity.filter.ReporteExcelService;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/admin/reportes/exportar")
public class ReporteExcelServlet extends HttpServlet {

    private final ReporteExcelService reporteService = new ReporteExcelService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        // Verificar sesión admin
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Leer parámetros de fecha
        LocalDate desde, hasta;
        try {
            String paramDesde = req.getParameter("desde");
            String paramHasta = req.getParameter("hasta");
            desde = (paramDesde != null && !paramDesde.isBlank())
                    ? LocalDate.parse(paramDesde)
                    : LocalDate.now().withDayOfMonth(1);          // primer día del mes actual
            hasta = (paramHasta != null && !paramHasta.isBlank())
                    ? LocalDate.parse(paramHasta)
                    : LocalDate.now();
        } catch (DateTimeParseException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Formato de fecha inválido. Use yyyy-MM-dd.");
            return;
        }

        // Generar Excel
        byte[] excel = reporteService.generarReporte(desde, hasta);

        String nombreArchivo = "reporte_ventas_"
                + desde + "_al_" + hasta + ".xlsx";

        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + nombreArchivo + "\"");
        resp.setContentLength(excel.length);
        resp.getOutputStream().write(excel);
    }
}