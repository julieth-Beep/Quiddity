package com.quiddity.model;

import java.sql.Date;

/**
 * Outfit o look asignado a un día específico de un viaje.
 * Puede ser un outfit del closet (idOutfit) o un look generado por IA
 * (idLookGenerado).
 * Tabla: viaje_outfit
 */
public class ViajeOutfit {
    private int id;
    private int idViaje;
    private Integer idOutfit; // null si es look generado
    private Integer idLookGenerado; // null si es outfit del closet
    private Date dia;
    private String motivo; // descripción del evento de ese día
    private String tipo; // "outfit" | "look"

    // Datos enriquecidos para el frontend
    private String climaOutfit;
    private String ocasionOutfit;
    private String imagenGenerada; // imagen del look
    private String promptIA;

    public ViajeOutfit() {
    }

    public ViajeOutfit(int id, int idViaje, Integer idOutfit,
            Integer idLookGenerado, Date dia, String motivo, String tipo) {
        this.id = id;
        this.idViaje = idViaje;
        this.idOutfit = idOutfit;
        this.idLookGenerado = idLookGenerado;
        this.dia = dia;
        this.motivo = motivo;
        this.tipo = tipo;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdViaje() {
        return idViaje;
    }

    public void setIdViaje(int idViaje) {
        this.idViaje = idViaje;
    }

    public Integer getIdOutfit() {
        return idOutfit;
    }

    public void setIdOutfit(Integer idOutfit) {
        this.idOutfit = idOutfit;
    }

    public Integer getIdLookGenerado() {
        return idLookGenerado;
    }

    public void setIdLookGenerado(Integer idLookGenerado) {
        this.idLookGenerado = idLookGenerado;
    }

    public Date getDia() {
        return dia;
    }

    public void setDia(Date dia) {
        this.dia = dia;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getClimaOutfit() {
        return climaOutfit;
    }

    public void setClimaOutfit(String climaOutfit) {
        this.climaOutfit = climaOutfit;
    }

    public String getOcasionOutfit() {
        return ocasionOutfit;
    }

    public void setOcasionOutfit(String ocasionOutfit) {
        this.ocasionOutfit = ocasionOutfit;
    }

    public String getImagenGenerada() {
        return imagenGenerada;
    }

    public void setImagenGenerada(String imagenGenerada) {
        this.imagenGenerada = imagenGenerada;
    }

    public String getPromptIA() {
        return promptIA;
    }

    public void setPromptIA(String promptIA) {
        this.promptIA = promptIA;
    }
}