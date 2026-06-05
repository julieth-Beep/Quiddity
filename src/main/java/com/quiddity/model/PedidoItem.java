package com.quiddity.model;

public class PedidoItem {

    private int id;
    private int pedidoId;
    private int catalogoId;
    private int cantidad;
    private double precioUnitario; // Snapshot del precio al momento de comprar
    private Catalogo producto;     // JOIN para traer datos del producto (opcional)

    public PedidoItem() {
    }

    public PedidoItem(int id, int pedidoId, int catalogoId, int cantidad, double precioUnitario) {
        this.id = id;
        this.pedidoId = pedidoId;
        this.catalogoId = catalogoId;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPedidoId() { return pedidoId; }
    public void setPedidoId(int pedidoId) { this.pedidoId = pedidoId; }

    public int getCatalogoId() { return catalogoId; }
    public void setCatalogoId(int catalogoId) { this.catalogoId = catalogoId; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(double precioUnitario) { this.precioUnitario = precioUnitario; }

    public Catalogo getProducto() { return producto; }
    public void setProducto(Catalogo producto) { this.producto = producto; }

    /** Subtotal calculado en Java (refleja la columna GENERATED en la DB) */
    public double getSubtotal() {
        return precioUnitario * cantidad;
    }
}