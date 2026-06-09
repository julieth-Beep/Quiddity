package com.quiddity.filter;

import com.quiddity.dao.CatalogoEstadisticasDAO;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

public class ReporteExcelService {

    private static final DateTimeFormatter FMT_FECHA = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter FMT_TITULO = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final CatalogoEstadisticasDAO estadisticasDAO = new CatalogoEstadisticasDAO();

    public byte[] generarReporte(LocalDate desde, LocalDate hasta) throws IOException {

        List<Map<String, Object>> filas         = estadisticasDAO.getDatosExportacion(desde, hasta);
        List<Map<String, Object>> porCategoria  = estadisticasDAO.getVentasPorCategoriaPeriodo(desde, hasta);
        List<Map<String, Object>> topProductos  = estadisticasDAO.getTopVendidosPorPeriodo(10, desde, hasta);
        Map<String, Object>       resumen       = estadisticasDAO.getResumenPeriodo(desde, hasta);

        try (XSSFWorkbook wb = new XSSFWorkbook()) {

            // ── Estilos ──────────────────────────────────────────────────────
            CellStyle estTitulo   = crearEstilo(wb, true,  IndexedColors.DARK_RED,    IndexedColors.WHITE);
            CellStyle estHeader   = crearEstilo(wb, true,  IndexedColors.ROSE,        IndexedColors.BLACK);
            CellStyle estNormal   = crearEstilo(wb, false, IndexedColors.WHITE,       IndexedColors.BLACK);
            CellStyle estAlterna  = crearEstilo(wb, false, IndexedColors.LAVENDER,    IndexedColors.BLACK);
            CellStyle estMoneda   = crearEstiloMoneda(wb, false);
            CellStyle estMonedaA  = crearEstiloMoneda(wb, true);

            // ── Hoja 1: Detalle de ventas ─────────────────────────────────────
            Sheet shDetalle = wb.createSheet("Detalle de ventas");
            crearTitulo(shDetalle, estTitulo,
                    "Reporte de ventas — " + desde.format(FMT_TITULO) + " al " + hasta.format(FMT_TITULO), 15);

            String[] headersDetalle = {
                "# Pedido", "Fecha", "Estado", "Cliente", "Email",
                "Documento", "Departamento", "Ciudad",
                "Producto", "Categoría", "Marca",
                "Cantidad", "Precio unitario", "Subtotal", "Total pedido"
            };
            crearFila(shDetalle, 1, headersDetalle, estHeader);

            int fila = 2;
            for (Map<String, Object> d : filas) {
                Row row = shDetalle.createRow(fila);
                CellStyle cs  = (fila % 2 == 0) ? estNormal : estAlterna;
                CellStyle csM = (fila % 2 == 0) ? estMoneda  : estMonedaA;

                setCelda(row, 0,  d.get("pedidoId"),         cs);
                setCelda(row, 1,  formatearFecha(d.get("fecha")), cs);
                setCelda(row, 2,  d.get("estado"),           cs);
                setCelda(row, 3,  d.get("cliente"),          cs);
                setCelda(row, 4,  d.get("clienteEmail"),     cs);
                setCelda(row, 5,  d.get("clienteDocumento"), cs);
                setCelda(row, 6,  d.get("departamento"),     cs);
                setCelda(row, 7,  d.get("ciudad"),           cs);
                setCelda(row, 8,  d.get("producto"),         cs);
                setCelda(row, 9,  d.get("categoria"),        cs);
                setCelda(row, 10, d.get("marca"),            cs);
                setCelda(row, 11, d.get("cantidad"),         cs);
                setCeldaDouble(row, 12, d.get("precioUnitario"), csM);
                setCeldaDouble(row, 13, d.get("subtotal"),       csM);
                setCeldaDouble(row, 14, d.get("pedidoTotal"),    csM);
                fila++;
            }
            autoAjustar(shDetalle, headersDetalle.length);

            // ── Hoja 2: Top 10 productos ──────────────────────────────────────
            Sheet shTop = wb.createSheet("Top productos");
            crearTitulo(shTop, estTitulo, "Top 10 productos más vendidos", 8);

            crearFila(shTop, 1, new String[]{
                "Pos.", "Producto", "Categoría", "Marca",
                "Unidades vendidas", "Ingresos"
            }, estHeader);

            int pos = 1;
            for (Map<String, Object> p : topProductos) {
                Row row = shTop.createRow(pos + 1);
                CellStyle cs  = (pos % 2 == 0) ? estNormal : estAlterna;
                CellStyle csM = (pos % 2 == 0) ? estMoneda  : estMonedaA;
                setCelda(row, 0, pos,                      cs);
                setCelda(row, 1, p.get("nombre"),          cs);
                setCelda(row, 2, p.get("categoria"),       cs);
                setCelda(row, 3, p.get("marca"),           cs);
                setCelda(row, 4, p.get("totalVendido"),    cs);
                setCeldaDouble(row, 5, p.get("ingresos"),  csM);
                pos++;
            }
            autoAjustar(shTop, 6);

            // ── Hoja 3: Ventas por categoría ──────────────────────────────────
            Sheet shCat = wb.createSheet("Por categoría");
            crearTitulo(shCat, estTitulo, "Ventas por categoría", 4);

            crearFila(shCat, 1, new String[]{
                "Categoría", "Pedidos", "Unidades vendidas", "Ingresos"
            }, estHeader);

            int fc = 2;
            for (Map<String, Object> c : porCategoria) {
                Row row = shCat.createRow(fc);
                CellStyle cs  = (fc % 2 == 0) ? estNormal : estAlterna;
                CellStyle csM = (fc % 2 == 0) ? estMoneda  : estMonedaA;
                setCelda(row, 0, c.get("categoria"),        cs);
                setCelda(row, 1, c.get("numPedidos"),        cs);
                setCelda(row, 2, c.get("unidadesVendidas"), cs);
                setCeldaDouble(row, 3, c.get("ingresos"),   csM);
                fc++;
            }
            autoAjustar(shCat, 4);

            // ── Hoja 4: Resumen del período ───────────────────────────────────
            Sheet shRes = wb.createSheet("Resumen");
            crearTitulo(shRes, estTitulo, "Resumen del período", 2);

            String[][] datosResumen = {
                { "Período",           desde.format(FMT_TITULO) + " — " + hasta.format(FMT_TITULO) },
                { "Ingresos totales",  "$" + String.format("%,.2f", resumen.get("ingresosTotales")) },
                { "Unidades vendidas", String.valueOf(resumen.get("unidadesTotales")) },
                { "Pedidos",           String.valueOf(resumen.get("numPedidos")) },
                { "Clientes únicos",   String.valueOf(resumen.get("numClientes")) }
            };

            for (int i = 0; i < datosResumen.length; i++) {
                Row row = shRes.createRow(i + 2);
                row.createCell(0).setCellValue(datosResumen[i][0]);
                row.getCell(0).setCellStyle(estHeader);
                row.createCell(1).setCellValue(datosResumen[i][1]);
                row.getCell(1).setCellStyle(estNormal);
            }
            shRes.setColumnWidth(0, 7000);
            shRes.setColumnWidth(1, 7000);

            // ── Serializar ────────────────────────────────────────────────────
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            wb.write(out);
            return out.toByteArray();
        }
    }

    // ─── HELPERS ──────────────────────────────────────────────────────────────

    private void crearTitulo(Sheet sh, CellStyle estilo, String texto, int columnas) {
        Row row = sh.createRow(0);
        row.setHeightInPoints(24);
        Cell cell = row.createCell(0);
        cell.setCellValue(texto);
        cell.setCellStyle(estilo);
        sh.addMergedRegion(new CellRangeAddress(0, 0, 0, columnas - 1));
    }

    private void crearFila(Sheet sh, int numFila, String[] valores, CellStyle estilo) {
        Row row = sh.createRow(numFila);
        for (int i = 0; i < valores.length; i++) {
            Cell cell = row.createCell(i);
            cell.setCellValue(valores[i]);
            cell.setCellStyle(estilo);
        }
    }

    private void setCelda(Row row, int col, Object valor, CellStyle estilo) {
        Cell cell = row.createCell(col);
        if (valor instanceof Number)
            cell.setCellValue(((Number) valor).doubleValue());
        else
            cell.setCellValue(valor != null ? valor.toString() : "");
        cell.setCellStyle(estilo);
    }

    private void setCeldaDouble(Row row, int col, Object valor, CellStyle estilo) {
        Cell cell = row.createCell(col);
        cell.setCellValue(valor instanceof Number ? ((Number) valor).doubleValue() : 0);
        cell.setCellStyle(estilo);
    }

    private String formatearFecha(Object valor) {
        if (valor instanceof LocalDateTime ldt) return ldt.format(FMT_FECHA);
        return valor != null ? valor.toString() : "";
    }

    private void autoAjustar(Sheet sh, int columnas) {
        for (int i = 0; i < columnas; i++) sh.autoSizeColumn(i);
    }

    private CellStyle crearEstilo(Workbook wb, boolean negrita,
                                   IndexedColors fondo, IndexedColors fuente) {
        CellStyle cs = wb.createCellStyle();
        Font font = wb.createFont();
        font.setBold(negrita);
        font.setColor(fuente.getIndex());
        cs.setFont(font);
        cs.setFillForegroundColor(fondo.getIndex());
        cs.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        cs.setBorderBottom(BorderStyle.THIN);
        cs.setBorderTop(BorderStyle.THIN);
        cs.setBorderLeft(BorderStyle.THIN);
        cs.setBorderRight(BorderStyle.THIN);
        cs.setAlignment(HorizontalAlignment.LEFT);
        cs.setVerticalAlignment(VerticalAlignment.CENTER);
        return cs;
    }

    private CellStyle crearEstiloMoneda(Workbook wb, boolean alterna) {
        CellStyle cs = wb.createCellStyle();
        cs.setFillForegroundColor(alterna
                ? IndexedColors.LAVENDER.getIndex()
                : IndexedColors.WHITE.getIndex());
        cs.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        cs.setBorderBottom(BorderStyle.THIN);
        cs.setBorderTop(BorderStyle.THIN);
        cs.setBorderLeft(BorderStyle.THIN);
        cs.setBorderRight(BorderStyle.THIN);
        DataFormat fmt = wb.createDataFormat();
        cs.setDataFormat(fmt.getFormat("$#,##0.00"));
        return cs;
    }
}