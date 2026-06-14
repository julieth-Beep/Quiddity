package com.quiddity.model;

import java.sql.Date;

/**
 * Asignación de un look generado a un día específico del calendario.
 * Tabla: calendario_outfit
 */
public class CalendarioOutfit {
    private int id;
    private int idUsuario;
    private int idLook; // FK a look_generado
    private Date fecha;
    private int orden; // si hay varios looks en un día: 1, 2, 3...
    private String momentoDia; // mañana, tarde, noche
    private String ocasion; // trabajo, casual, evento, deporte
    private String nota; // texto libre del usuario

    // Datos enriquecidos (JOIN con look_generado) — para mostrar en UI
    private String imagenGenerada; // imagen del look para mostrar en el calendario
    private String promptIA;

    public CalendarioOutfit() {
    }

    public CalendarioOutfit(int id, int idUsuario, int idLook, Date fecha,
            int orden, String momentoDia, String ocasion, String nota) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.idLook = idLook;
        this.fecha = fecha;
        this.orden = orden;
        this.momentoDia = momentoDia;
        this.ocasion = ocasion;
        this.nota = nota;
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

    public int getIdLook() {
        return idLook;
    }

    public void setIdLook(int idLook) {
        this.idLook = idLook;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public String getMomentoDia() {
        return momentoDia;
    }

    public void setMomentoDia(String momentoDia) {
        this.momentoDia = momentoDia;
    }

    public String getOcasion() {
        return ocasion;
    }

    public void setOcasion(String ocasion) {
        this.ocasion = ocasion;
    }

    public String getNota() {
        return nota;
    }

    public void setNota(String nota) {
        this.nota = nota;
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