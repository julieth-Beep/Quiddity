package com.quiddity.model;

import java.time.LocalDateTime;

/**
 * Modelo que representa una interacción del chatbot.
 * Mapea la tabla chatbot_interacciones de la BD.
 */
public class ChatBot {

    private int id;
    private String pregunta;
    private String respuesta;
    private int idRol; // FK → rol.id
    private LocalDateTime fecha;
    private String rolRecomendado; // NUEVO: para flujo de registro

    // ── Constructores ────────────────────────────────────────────────────────

    public ChatBot() {
    }

    public ChatBot(String pregunta, String respuesta, int idRol) {
        this.pregunta = pregunta;
        this.respuesta = respuesta;
        this.idRol = idRol;
    }

    // ── Getters / Setters ────────────────────────────────────────────────────

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPregunta() {
        return pregunta;
    }

    public void setPregunta(String pregunta) {
        this.pregunta = pregunta;
    }

    public String getRespuesta() {
        return respuesta;
    }

    public void setRespuesta(String respuesta) {
        this.respuesta = respuesta;
    }

    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

   
    public String getRolRecomendado() {
        return rolRecomendado;
    }

    public void setRolRecomendado(String rolRecomendado) {
        this.rolRecomendado = rolRecomendado;
    }

    @Override
    public String toString() {
        return "ChatBot{id=" + id + ", idRol=" + idRol +
                ", rolRecomendado=" + rolRecomendado + ", pregunta='" + pregunta + "'}";
    }
}