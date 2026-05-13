package com.quiddity.model;

public class Notificacion {

    private int id;
    private int idUsuario;
    private int idFrase;

    public Notificacion() {
    }

    public Notificacion(int id, int idUsuario, int idFrase) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.idFrase = idFrase;
    }

    public String toString() {
        return "Notificacion{id='" + this.id + "', idUsuario='" + this.idUsuario + "'}";
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

    public int getIdFrase() {
        return idFrase;
    }

    public void setIdFrase(int idFrase) {
        this.idFrase = idFrase;
    }
}
