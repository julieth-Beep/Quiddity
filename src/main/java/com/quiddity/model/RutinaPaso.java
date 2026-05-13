package com.quiddity.model;

public class RutinaPaso {

    private int id;
    private int idRutina;
    private int orden;
    private String descripcion;

    public RutinaPaso() {
    }

    public RutinaPaso(int id, int idRutina, int orden, String descripcion) {
        this.id = id;
        this.idRutina = idRutina;
        this.orden = orden;
        this.descripcion = descripcion;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdRutina() {
        return idRutina;
    }

    public void setIdRutina(int idRutina) {
        this.idRutina = idRutina;
    }

    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

}
