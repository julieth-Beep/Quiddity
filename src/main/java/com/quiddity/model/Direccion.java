package com.quiddity.model;

public class Direccion {

    private int id;
    private int usuarioId;
    private String departamento;
    private String ciudad;
    private String barrio;
    private String direccion;
    private boolean esRural;
    private String descripcionRural; // Solo aplica si esRural = true
    private boolean predeterminada;

    public Direccion() {
    }

    public Direccion(int id, int usuarioId, String departamento, String ciudad,
            String barrio, String direccion, boolean esRural,
            String descripcionRural, boolean predeterminada) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.departamento = departamento;
        this.ciudad = ciudad;
        this.barrio = barrio;
        this.direccion = direccion;
        this.esRural = esRural;
        this.descripcionRural = descripcionRural;
        this.predeterminada = predeterminada;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public String getDepartamento() { return departamento; }
    public void setDepartamento(String departamento) { this.departamento = departamento; }

    public String getCiudad() { return ciudad; }
    public void setCiudad(String ciudad) { this.ciudad = ciudad; }

    public String getBarrio() { return barrio; }
    public void setBarrio(String barrio) { this.barrio = barrio; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public boolean isEsRural() { return esRural; }
    public void setEsRural(boolean esRural) { this.esRural = esRural; }

    public String getDescripcionRural() { return descripcionRural; }
    public void setDescripcionRural(String descripcionRural) { this.descripcionRural = descripcionRural; }

    public boolean isPredeterminada() { return predeterminada; }
    public void setPredeterminada(boolean predeterminada) { this.predeterminada = predeterminada; }

    /**
     * Devuelve una cadena legible para mostrar en pantalla.
     * Ejemplo: "Cra 5 #10-20, El Poblado, Medellín, Antioquia"
     */
    public String getDireccionCompleta() {
        StringBuilder sb = new StringBuilder();
        sb.append(direccion);
        if (barrio != null && !barrio.isBlank()) sb.append(", ").append(barrio);
        sb.append(", ").append(ciudad);
        sb.append(", ").append(departamento);
        if (esRural && descripcionRural != null && !descripcionRural.isBlank()) {
            sb.append(" (Zona rural: ").append(descripcionRural).append(")");
        }
        return sb.toString();
    }
}