package com.quiddity.model;

public class CatalogoImagen {
    private int id;
    private int catalogoId;
    private String rutaImagen;
    private int orden;
    private boolean esPrincipal;

    public CatalogoImagen() {}

    public CatalogoImagen(int id, int catalogoId, String rutaImagen, int orden, boolean esPrincipal) {
        this.id = id;
        this.catalogoId = catalogoId;
        this.rutaImagen = rutaImagen;
        this.orden = orden;
        this.esPrincipal = esPrincipal;
    }

    // Getters
    public int getId() { return id; }
    public int getCatalogoId() { return catalogoId; }
    public String getRutaImagen() { return rutaImagen; }
    public int getOrden() { return orden; }
    public boolean isEsPrincipal() { return esPrincipal; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setCatalogoId(int catalogoId) { this.catalogoId = catalogoId; }
    public void setRutaImagen(String rutaImagen) { this.rutaImagen = rutaImagen; }
    public void setOrden(int orden) { this.orden = orden; }
    public void setEsPrincipal(boolean esPrincipal) { this.esPrincipal = esPrincipal; }
}