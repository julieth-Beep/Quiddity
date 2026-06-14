package com.quiddity.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Viaje registrado por el usuario.
 * La app detecta el clima del destino y recomienda outfits del closet.
 * Tabla: viaje
 */
public class Viaje {
    private int id;
    private int idUsuario;
    private String destino;
    private Date fechaInicio;
    private Date fechaFin;
    private String climaEsperado; // resultado de OpenWeatherMap: "soleado caluroso"
    private Double latitud; // coordenadas obtenidas por geocoding
    private Double longitud;
    private String notas;
    private Timestamp creadoEn;

    // Dato calculado — no en BD
    private int duracionDias;

    public Viaje() {
    }

    public Viaje(int id, int idUsuario, String destino, Date fechaInicio, Date fechaFin,
            String climaEsperado, Double latitud, Double longitud,
            String notas, Timestamp creadoEn) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.destino = destino;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.climaEsperado = climaEsperado;
        this.latitud = latitud;
        this.longitud = longitud;
        this.notas = notas;
        this.creadoEn = creadoEn;
    }

    /** Calcula duración en días del viaje */
    public int getDuracionDias() {
        if (fechaInicio != null && fechaFin != null) {
            long diff = fechaFin.getTime() - fechaInicio.getTime();
            return (int) (diff / (1000 * 60 * 60 * 24)) + 1;
        }
        return duracionDias;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getDestino() {
        return destino;
    }

    public void setDestino(String destino) {
        this.destino = destino;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    public String getClimaEsperado() {
        return climaEsperado;
    }

    public void setClimaEsperado(String climaEsperado) {
        this.climaEsperado = climaEsperado;
    }

    public Double getLatitud() {
        return latitud;
    }

    public void setLatitud(Double latitud) {
        this.latitud = latitud;
    }

    public Double getLongitud() {
        return longitud;
    }

    public void setLongitud(Double longitud) {
        this.longitud = longitud;
    }

    public String getNotas() {
        return notas;
    }

    public void setNotas(String notas) {
        this.notas = notas;
    }

    public Timestamp getCreadoEn() {
        return creadoEn;
    }

    public void setCreadoEn(Timestamp creadoEn) {
        this.creadoEn = creadoEn;
    }

    public void setDuracionDias(int duracionDias) {
        this.duracionDias = duracionDias;
    }
}