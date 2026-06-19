package com.quiddity.model;

import java.util.ArrayList;
import java.util.List;

public class Catalogo {

    private int id;
    private String nombre;
    private String descripcion;
    private String componentes;
    private double precio;
    private int stock;
    private String imagen;
    private String categoria;
    private String marca;
    private boolean meGusta;
    private boolean activo;

    private List<CatalogoImagen> imagenes = new ArrayList<>();

    public Catalogo() {
    }
    
    public Catalogo(int id, String nombre, String descripcion, String componentes, double precio, int stock,
            String imagen, String categoria, String marca, boolean meGusta, boolean activo) {
        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.componentes = componentes;
        this.precio = precio;
        this.stock = stock;
        this.imagen = imagen;
        this.categoria = categoria;
        this.marca = marca;
        this.meGusta = meGusta;
        this.activo = activo;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getComponentes() {
        return componentes;
    }

    public void setComponentes(String componentes) {
        this.componentes = componentes;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }


    public boolean getMeGusta() {
        return meGusta;
    }


    public void setMeGusta(boolean meGusta) {
        this.meGusta = meGusta;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public List<CatalogoImagen> getImagenes() { return imagenes; }
    public void setImagenes(List<CatalogoImagen> imagenes) { this.imagenes = imagenes; }

    // Helper: obtener solo las imágenes NO principales (para el carrusel)
    public List<CatalogoImagen> getImagenesAdicionales() {
        List<CatalogoImagen> adicionales = new ArrayList<>();
        for (CatalogoImagen img : imagenes) {
            if (!img.isEsPrincipal()) {
                adicionales.add(img);
            }
        }
        return adicionales;
    }
    
    // Helper: contar total de imágenes
    public int getTotalImagenes() {
        return imagenes.size();
    }
}
