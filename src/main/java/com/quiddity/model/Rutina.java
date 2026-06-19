package com.quiddity.model;

public class Rutina {

    private int id;
    private int idUsuario;
    private String nombre;
    private String objetivo;
    private String url;
    private String favoritos;
    private String categoria;
    private String subcategoria;
    private String tipoPiel;
    private String tipoCabello;
    private String tonoPiel;
    private String formaCara;
    private String tipoCuerpo;

    public Rutina() {
    }

    public Rutina(int id, int idUsuario, String nombre, String objetivo, String url,
            String favoritos, String categoria, String subcategoria,
            String tipoPiel, String tipoCabello, String tonoPiel,
            String formaCara, String tipoCuerpo) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.nombre = nombre;
        this.objetivo = objetivo;
        this.url = url;
        this.favoritos = favoritos;
        this.categoria = categoria;
        this.subcategoria = subcategoria;
        this.tipoPiel = tipoPiel;
        this.tipoCabello = tipoCabello;
        this.tonoPiel = tonoPiel;
        this.formaCara = formaCara;
        this.tipoCuerpo = tipoCuerpo;
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

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getObjetivo() {
        return objetivo;
    }

    public void setObjetivo(String objetivo) {
        this.objetivo = objetivo;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getFavoritos() {
        return favoritos;
    }

    public void setFavoritos(String favoritos) {
        this.favoritos = favoritos;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getSubcategoria() {
        return subcategoria;
    }

    public void setSubcategoria(String subcategoria) {
        this.subcategoria = subcategoria;
    }

    public String getTipoPiel() {
        return tipoPiel;
    }

    public void setTipoPiel(String tipoPiel) {
        this.tipoPiel = tipoPiel;
    }

    public String getTipoCabello() {
        return tipoCabello;
    }

    public void setTipoCabello(String tipoCabello) {
        this.tipoCabello = tipoCabello;
    }

    public String getTonoPiel() {
        return tonoPiel;
    }

    public void setTonoPiel(String tonoPiel) {
        this.tonoPiel = tonoPiel;
    }

    public String getFormaCara() {
        return formaCara;
    }

    public void setFormaCara(String formaCara) {
        this.formaCara = formaCara;
    }

    public String getTipoCuerpo() {
        return tipoCuerpo;
    }

    public void setTipoCuerpo(String tipoCuerpo) {
        this.tipoCuerpo = tipoCuerpo;
    }
}