package com.quiddity.model;

public class Frase {

    private int id;
    private String imagen;
    private String autor;
    private String categoria;
    private String estadoAnimo;

    public Frase() {
    }

    public Frase(int id, String imagen, String autor, String categoria, String estadoAnimo) {
        this.id = id;
        this.imagen = imagen;
        this.autor = autor;
        this.categoria = categoria;
        this.estadoAnimo = estadoAnimo;
    }

    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImagen() {
        return this.imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public String getAutor() {
        return this.autor;
    }

    public void setAutor(String autor) {
        this.autor = autor;
    }

    public String getCategoria() {
        return this.categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String toString() {
        return "Frase{id='" + this.id + "', contenido='" + this.imagen + "'}";
    }

    public String getEstadoAnimo() {
        return estadoAnimo;
    }

    public void setEstadoAnimo(String estadoAnimo) {
        this.estadoAnimo = estadoAnimo;
    }
}
