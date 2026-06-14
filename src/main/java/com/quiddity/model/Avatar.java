package com.quiddity.model;

/**
 * Avatar del usuario — une usuario con sus características físicas.
 * Tabla: avatar
 */
public class Avatar {
    private int idAvatar;
    private int idUsuario;
    private int idCaracteristicas;

    // Datos enriquecidos (JOIN) — se llenan desde el DAO cuando se necesitan
    private Caracteristicas caracteristicas;

    public Avatar() {
    }

    public Avatar(int idAvatar, int idUsuario, int idCaracteristicas) {
        this.idAvatar = idAvatar;
        this.idUsuario = idUsuario;
        this.idCaracteristicas = idCaracteristicas;
    }

    public int getIdAvatar() {
        return idAvatar;
    }

    public void setIdAvatar(int idAvatar) {
        this.idAvatar = idAvatar;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdCaracteristicas() {
        return idCaracteristicas;
    }

    public void setIdCaracteristicas(int idCaracteristicas) {
        this.idCaracteristicas = idCaracteristicas;
    }

    public Caracteristicas getCaracteristicas() {
        return caracteristicas;
    }

    public void setCaracteristicas(Caracteristicas caracteristicas) {
        this.caracteristicas = caracteristicas;
    }
}