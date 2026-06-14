package com.quiddity.model;

import java.sql.Timestamp;

/**
 * Registro histórico de cada vez que se aplicó Prettify a una prenda.
 * Tabla: prenda_prettify
 */
public class PrendaPrettify {
    private int id;
    private int idPrenda;
    private String imagenOriginal; // ruta de la foto cruda del usuario
    private String imagenCorregida; // ruta con fondo removido y recortada
    private String parametros; // JSON con datos del proceso (proveedor, tiempo, etc.)
    private Timestamp creadoEn;

    public PrendaPrettify() {
    }

    public PrendaPrettify(int id, int idPrenda, String imagenOriginal,
            String imagenCorregida, String parametros, Timestamp creadoEn) {
        this.id = id;
        this.idPrenda = idPrenda;
        this.imagenOriginal = imagenOriginal;
        this.imagenCorregida = imagenCorregida;
        this.parametros = parametros;
        this.creadoEn = creadoEn;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdPrenda() {
        return idPrenda;
    }

    public void setIdPrenda(int idPrenda) {
        this.idPrenda = idPrenda;
    }

    public String getImagenOriginal() {
        return imagenOriginal;
    }

    public void setImagenOriginal(String imagenOriginal) {
        this.imagenOriginal = imagenOriginal;
    }

    public String getImagenCorregida() {
        return imagenCorregida;
    }

    public void setImagenCorregida(String imagenCorregida) {
        this.imagenCorregida = imagenCorregida;
    }

    public String getParametros() {
        return parametros;
    }

    public void setParametros(String parametros) {
        this.parametros = parametros;
    }

    public Timestamp getCreadoEn() {
        return creadoEn;
    }

    public void setCreadoEn(Timestamp creadoEn) {
        this.creadoEn = creadoEn;
    }
}