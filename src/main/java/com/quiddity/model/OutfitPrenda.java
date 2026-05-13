package com.quiddity.model;

public class OutfitPrenda {

    private int id;
    private int idOutfit;
    private int idPrenda;

    public OutfitPrenda() {
    }

    public OutfitPrenda(int id, int idOutfit, int idPrenda) {
        this.id = id;
        this.idOutfit = idOutfit;
        this.idPrenda = idPrenda;
    }

    public String toString() {
        return "OutfitPrenda{id='" + this.id + "', idOutfit='" + this.idOutfit + "', idPrenda='" + this.idPrenda + "'}";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdOutfit() {
        return idOutfit;
    }

    public void setIdOutfit(int idOutfit) {
        this.idOutfit = idOutfit;
    }

    public int getIdPrenda() {
        return idPrenda;
    }

    public void setIdPrenda(int idPrenda) {
        this.idPrenda = idPrenda;
    }
}
