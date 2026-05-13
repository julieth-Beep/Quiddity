package com.quiddity.model;

public class Outfit {

    private int id;
    private String clima; // con ubicacion del usuario
    private String ocacion;

    public Outfit() {
    }

    public Outfit(int id, String clima, String ocacion) {
        this.id = id;
        this.clima = clima;
        this.ocacion = ocacion;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getClima() {
        return clima;
    }

    public void setClima(String clima) {
        this.clima = clima;
    }

    public String getOcacion() {
        return ocacion;
    }

    public void setOcacion(String ocacion) {
        this.ocacion = ocacion;
    }

}
