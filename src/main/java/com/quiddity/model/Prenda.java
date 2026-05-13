package com.quiddity.model;

public class Prenda {

    private int id;
    private int idUsuario;
    private String tipo;
    private String color;
    private String estilo;
    private String imagen;
    private String temporada;

    public Prenda() {
    }

    public Prenda(int id, int idUsuario, String tipo, String color, String estilo, String imagen,
            String temporada) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.tipo = tipo;
        this.color = color;
        this.estilo = estilo;
        this.imagen = imagen;
        this.temporada = temporada;
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

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getEstilo() {
        return estilo;
    }

    public void setEstilo(String estilo) {
        this.estilo = estilo;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public String getTemporada() {
        return temporada;
    }

    public void setTemporada(String temporada) {
        this.temporada = temporada;
    }

}
