package com.quiddity.model;

public class Caracteristicas {

    private int id;
    private String tonoPiel;
    private String formaCara;
    private String tipoCuerpo;
    private String tipoCabello;
    private String tipoPiel;

    public Caracteristicas() {
    }

    public Caracteristicas(int id, String tonoPiel, String formaCara, String tipoCuerpo, String tipoCabello,
            String tipoPiel) {
        this.id = id;
        this.tonoPiel = tonoPiel;
        this.formaCara = formaCara;
        this.tipoCuerpo = tipoCuerpo;
        this.tipoCabello = tipoCabello;
        this.tipoPiel = tipoPiel;
    }

    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTonoPiel() {
        return this.tonoPiel;
    }

    public void setTonoPiel(String tonoPiel) {
        this.tonoPiel = tonoPiel;
    }

    public String getFormaCara() {
        return this.formaCara;
    }

    public void setFormaCara(String formaCara) {
        this.formaCara = formaCara;
    }

    public String getTipoCuerpo() {
        return this.tipoCuerpo;
    }

    public void setTipoCuerpo(String tipoCuerpo) {
        this.tipoCuerpo = tipoCuerpo;
    }

    public String getTipoCabello() {
        return this.tipoCabello;
    }

    public void setTipoCabello(String tipoCabello) {
        this.tipoCabello = tipoCabello;
    }

    public String getTipoPiel() {
        return this.tipoPiel;
    }

    public void setTipoPiel(String tipoPiel) {
        this.tipoPiel = tipoPiel;
    }

    public String toString() {
        return "Caracteristicas{id='" + this.id + "', tonoPiel='" + this.tonoPiel + "', formaCara='" + this.formaCara
                + "'}";
    }
}
