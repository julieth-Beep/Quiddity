package com.quiddity.model;

import java.sql.Timestamp;

/**
 * Look generado por IA o armado manualmente.
 * Es el resultado final que se guarda, se muestra en historial
 * y se asigna al calendario o a viajes.
 * Tabla: look_generado
 */
public class LookGenerado {
    private int id;
    private int idUsuario;
    private Integer idOutfit; // null si fue generado por chat IA directo
    private String imagenGenerada; // ruta relativa: uploads/looks/look_xxx.png
    private String promptIA; // el prompt que se envió a HuggingFace o Pollinations
    private boolean esManual; // true = usuario armó prendas, false = IA puro (chat)
    private boolean favorito;
    private Timestamp creadoEn;

    // Datos enriquecidos — no de la tabla, para mostrar en UI
    private String titulo; // título opcional que el usuario puede poner

    public LookGenerado() {
    }

    public LookGenerado(int id, int idUsuario, Integer idOutfit, String imagenGenerada,
            String promptIA, boolean esManual, boolean favorito, Timestamp creadoEn) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.idOutfit = idOutfit;
        this.imagenGenerada = imagenGenerada;
        this.promptIA = promptIA;
        this.esManual = esManual;
        this.favorito = favorito;
        this.creadoEn = creadoEn;
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

    public Integer getIdOutfit() {
        return idOutfit;
    }

    public void setIdOutfit(Integer idOutfit) {
        this.idOutfit = idOutfit;
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

    public boolean isEsManual() {
        return esManual;
    }

    public void setEsManual(boolean esManual) {
        this.esManual = esManual;
    }

    public boolean isFavorito() {
        return favorito;
    }

    public void setFavorito(boolean favorito) {
        this.favorito = favorito;
    }

    public Timestamp getCreadoEn() {
        return creadoEn;
    }

    public void setCreadoEn(Timestamp creadoEn) {
        this.creadoEn = creadoEn;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }
}