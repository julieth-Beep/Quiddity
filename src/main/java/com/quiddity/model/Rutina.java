package com.quiddity.model;

public class Rutina {

    private int id;
    private int idUsuario;
    private String nombre;
    private String objetivo;

    public Rutina() {
    }

    public Rutina(int id, int idUsuario, String nombre, String objetivo) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.nombre = nombre;
        this.objetivo = objetivo;
    }

    public String getNombre() {
        return this.nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getObjetivo() {
        return this.objetivo;
    }

    public void setObjetivo(String objetivo) {
        this.objetivo = objetivo;
    }

    public String toString() {
        return "Rutina{id='" + this.id + "', nombre='" + this.nombre + "'}";
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
