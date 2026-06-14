package com.quiddity.model;

/**
 * Prenda del closet del usuario.
 * Tabla: prenda
 *
 * Tipos válidos : tops, bottoms, outerwear, shoes, accessories, dresses
 * Estilos válidos: casual, formal, deportivo, elegante, bohemio
 * Temporadas : primavera, verano, otono, invierno, todas
 */
public class Prenda {
    private int id;
    private int idUsuario;
    private String tipo;
    private String color;
    private String estilo;
    private String imagen; // ruta relativa en servidor: uploads/prendas/xxx.png
    private String imagenPrettify; // ruta de la imagen procesada (fondo removido)
    private String temporada;
    private String nombre; // nombre descriptivo opcional (ej: "Bomber negra")
    private String marca; // marca opcional
    private String subcategoria;

    public Prenda() {
    }

    public Prenda(int id, int idUsuario, String tipo, String color,
            String estilo, String imagen, String temporada) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.tipo = tipo;
        this.color = color;
        this.estilo = estilo;
        this.imagen = imagen;
        this.temporada = temporada;
    }

    public Prenda(int id, int idUsuario, String tipo, String color, String estilo,
            String imagen, String imagenPrettify, String temporada,
            String nombre, String marca) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.tipo = tipo;
        this.color = color;
        this.estilo = estilo;
        this.imagen = imagen;
        this.imagenPrettify = imagenPrettify;
        this.temporada = temporada;
        this.nombre = nombre;
        this.marca = marca;
    }

    /** Devuelve la imagen prettify si existe, si no la original */
    public String getImagenMostrar() {
        return (imagenPrettify != null && !imagenPrettify.isBlank())
                ? imagenPrettify
                : imagen;
    }

    /** Descripción textual para usar en prompts de IA */
    public String getDescripcionIA() {
        StringBuilder sb = new StringBuilder();
        if (nombre != null && !nombre.isBlank())
            sb.append(nombre).append(", ");
        if (color != null)
            sb.append(color).append(" ");
        if (tipo != null)
            sb.append(tipo);
        if (estilo != null)
            sb.append(", ").append(estilo).append(" style");
        if (marca != null && !marca.isBlank())
            sb.append(", ").append(marca);
        return sb.toString().trim();
    }

    // ── Getters y Setters ──────────────────────────────────────────────────

    public int getId() {
        return id;
    }

    public String getSubcategoria() {
        return subcategoria;
    }

    public void setSubcategoria(String subcategoria) {
        this.subcategoria = subcategoria;
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

    public String getImagenPrettify() {
        return imagenPrettify;
    }

    public void setImagenPrettify(String imagenPrettify) {
        this.imagenPrettify = imagenPrettify;
    }

    public String getTemporada() {
        return temporada;
    }

    public void setTemporada(String temporada) {
        this.temporada = temporada;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

}