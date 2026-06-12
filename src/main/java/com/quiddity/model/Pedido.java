package com.quiddity.model;

import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

public class Pedido {

    private int id;
    private int usuarioId;
    private int direccionId;
    private Estado estado;
    private double total;
    private String notas;
    private ZonedDateTime creadoEn;
    private ZonedDateTime actualizadoEn;
    private String metodo_pago;

    // JOINs opcionales para mostrar en historial
    private Direccion direccion;
    private List<PedidoItem> items = new ArrayList<>();
    private String nombreUsuario;
    private String emailUsuario;
    private String documentoUsuario;
    private int cantidadItems;

    /**
     * PENDIENTE → CONFIRMADO → EN_PROCESO → ENVIADO → ENTREGADO
     * En cualquier punto antes de ENVIADO puede ir a CANCELADO.
     * Después de ENTREGADO puede ir a DEVUELTO.
     */
    public enum Estado {
        PENDIENTE,
        CONFIRMADO,
        EN_PROCESO,
        ENVIADO,
        ENTREGADO,
        CANCELADO,
        DEVUELTO
    }

    public Pedido() {
        this.estado = Estado.PENDIENTE;
    }

    // ── Getters y setters ──────────────────────────────────────

    public Pedido(int id, int usuarioId, int direccionId, Estado estado, double total, String notas,
            ZonedDateTime creadoEn, ZonedDateTime actualizadoEn, String metodo_pago, Direccion direccion,
            List<PedidoItem> items, String nombreUsuario, String emailUsuario, String documentoUsuario, int cantidadItems) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.direccionId = direccionId;
        this.estado = estado;
        this.total = total;
        this.notas = notas;
        this.creadoEn = creadoEn;
        this.actualizadoEn = actualizadoEn;
        this.metodo_pago = metodo_pago;
        this.direccion = direccion;
        this.items = items;
        this.nombreUsuario = nombreUsuario;
        this.emailUsuario = emailUsuario;
        this.documentoUsuario = documentoUsuario;
        this.cantidadItems = cantidadItems;
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

    public int getDireccionId() {
        return direccionId;
    }

    public void setDireccionId(int direccionId) {
        this.direccionId = direccionId;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    /** Conveniencia para cuando la DB devuelve el estado como String */
    public void setEstadoDesdeString(String estadoStr) {
        this.estado = Estado.valueOf(estadoStr);
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getNotas() {
        return notas;
    }

    public void setNotas(String notas) {
        this.notas = notas;
    }

    public ZonedDateTime getCreadoEn() {
        return creadoEn;
    }

    public void setCreadoEn(ZonedDateTime creadoEn) {
        this.creadoEn = creadoEn;
    }

    public ZonedDateTime getActualizadoEn() {
        return actualizadoEn;
    }

    public void setActualizadoEn(ZonedDateTime actualizadoEn) {
        this.actualizadoEn = actualizadoEn;
    }

    public Direccion getDireccion() {
        return direccion;
    }

    public void setDireccion(Direccion direccion) {
        this.direccion = direccion;
    }

    public List<PedidoItem> getItems() {
        return items;
    }

    public void setItems(List<PedidoItem> items) {
        this.items = items;
    }

    // ── Métodos de utilidad ────────────────────────────────────

    /** Recalcula el total sumando los subtotales de los ítems cargados. */
    public double calcularTotal() {
        return items.stream().mapToDouble(PedidoItem::getSubtotal).sum();
    }

    /** Cantidad total de productos en el pedido. */
    public int getTotalUnidades() {
        return items.stream().mapToInt(PedidoItem::getCantidad).sum();
    }

    /** Devuelve true si el pedido todavía puede cancelarse. */
    public boolean esCancelable() {
        return estado == Estado.PENDIENTE
                || estado == Estado.CONFIRMADO
                || estado == Estado.EN_PROCESO;
    }

    public String getMetodo_pago() {
        return metodo_pago;
    }

    public void setMetodo_pago(String metodo_pago) {
        this.metodo_pago = metodo_pago;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getEmailUsuario() {
        return emailUsuario;
    }

    public void setEmailUsuario(String emailUsuario) {
        this.emailUsuario = emailUsuario;
    }

    public String getDocumentoUsuario() {
        return documentoUsuario;
    }

    public void setDocumentoUsuario(String documentoUsuario) {
        this.documentoUsuario = documentoUsuario;
    }

    public int getCantidadItems() {
        return cantidadItems;
    }

    public void setCantidadItems(int cantidadItems) {
        this.cantidadItems = cantidadItems;
    }
}