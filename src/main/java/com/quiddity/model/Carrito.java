package com.quiddity.model;

public class Carrito {

    private int id;
    private int usuarioId;
    private int catalogoId;
    private int cantidad;
    private Catalogo producto; // JOIN para traer datos del producto

    public Carrito() {
    }

    public Carrito(int id, int usuarioId, int catalogoId, int cantidad) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.catalogoId = catalogoId;
        this.cantidad = cantidad;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public int getCatalogoId() {
        return catalogoId;
    }

    public void setCatalogoId(int catalogoId) {
        this.catalogoId = catalogoId;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public Catalogo getProducto() {
        return producto;
    }

    public void setProducto(Catalogo producto) {
        this.producto = producto;
    }

    // Subtotal calculado del ítem
    public double getSubtotal() {
        if (producto != null)
            return producto.getPrecio() * cantidad;
        return 0;
    }
}
