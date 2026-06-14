package com.quiddity.model;

import java.util.List;

/**
 * Outfit: agrupación de prendas que el usuario armó manualmente.
 * Sirve como base para generar el look con IA.
 * Tabla: outfit
 */
public class Outfit {
    private int id;
    private String clima; // soleado, lluvioso, frio, caluroso, variable
    private String ocasion; // casual, trabajo, fiesta, deporte, viaje
    private int idUsuario;

    // Datos enriquecidos — no vienen de la tabla outfit directamente
    private List<Prenda> prendas; // prendas que forman este outfit (JOIN outfitprenda)

    public Outfit() {
    }

    public Outfit(int id, String clima, String ocasion, int idUsuario) {
        this.id = id;
        this.clima = clima;
        this.ocasion = ocasion;
        this.idUsuario = idUsuario;
    }

    /**
     * Genera un prompt descriptivo para enviar a la IA (HuggingFace FLUX).
     * Describe el outfit completo basándose en las prendas que lo componen.
     */
    public String generarPromptIA(Caracteristicas caract) {
        StringBuilder sb = new StringBuilder();
        sb.append("Full body fashion photo, woman wearing: ");

        if (prendas != null) {
            for (int i = 0; i < prendas.size(); i++) {
                sb.append(prendas.get(i).getDescripcionIA());
                if (i < prendas.size() - 1)
                    sb.append(", ");
            }
        }

        // Agregar contexto del avatar si existe
        if (caract != null) {
            if (caract.getTonoPiel() != null)
                sb.append(", ").append(caract.getTonoPiel()).append(" skin tone");
            if (caract.getTipoCabello() != null)
                sb.append(", ").append(caract.getTipoCabello()).append(" hair");
        }

        sb.append(". Clean white background, full body shot, ");
        sb.append("fashion editorial style, high quality, Pinterest aesthetic, ");
        sb.append("professional lighting, no text, no watermark");

        return sb.toString();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getClima() {
        return clima;
    }

    public void setClima(String clima) {
        this.clima = clima;
    }

    public String getOcasion() {
        return ocasion;
    }

    public void setOcasion(String ocasion) {
        this.ocasion = ocasion;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public List<Prenda> getPrendas() {
        return prendas;
    }

    public void setPrendas(List<Prenda> prendas) {
        this.prendas = prendas;
    }
}