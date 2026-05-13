package com.quiddity.model;

public class Gusto {

    private int id;
    private int idUsuario;
    private String categoriaGusto;
    private int idOutfit;

    public Gusto() {
    }

    public Gusto(int id, int idUsuario, String categoriaGusto, int idOutfit) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.categoriaGusto = categoriaGusto;
        this.idOutfit = idOutfit;
    }

    public String getCategoriaGusto() {
        return this.categoriaGusto;
    }

    public void setCategoriaGusto(String categoriaGusto) {
        this.categoriaGusto = categoriaGusto;
    }

    public String toString() {
        return "Gusto{id='" + this.id + "', categoriaGusto='" + this.categoriaGusto + "'}";
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

    public int getIdOutfit() {
        return idOutfit;
    }

    public void setIdOutfit(int idOutfit) {
        this.idOutfit = idOutfit;
    }
}
