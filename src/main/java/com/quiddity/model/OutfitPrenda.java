package com.quiddity.model;

/**
 * Relación muchos-a-muchos entre Outfit y Prenda.
 * Tabla: outfitprenda
 */
public class OutfitPrenda {
    private int id;
    private int idOutfit;
    private int idPrenda;

    // Dato enriquecido — se llena con JOIN desde el DAO
    private Prenda prenda;

    public OutfitPrenda() {
    }

    public OutfitPrenda(int id, int idOutfit, int idPrenda) {
        this.id = id;
        this.idOutfit = idOutfit;
        this.idPrenda = idPrenda;
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

    public Prenda getPrenda() {
        return prenda;
    }

    public void setPrenda(Prenda prenda) {
        this.prenda = prenda;
    }
}