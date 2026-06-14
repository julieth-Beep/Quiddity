package com.quiddity.util;

import com.quiddity.model.Caracteristicas;
import com.quiddity.model.Prenda;

import java.util.List;

/**
 * PromptBuilder — centraliza la construcción de prompts para
 * HuggingFace/Pollinations.
 */
public class PromptBuilder {

    private static final String SUFIJO = ", white background, full body shot, fashion editorial photography, "
            + "high quality, professional studio lighting, Pinterest aesthetic, "
            + "no text, no watermark";

    /**
     * IMAGEN 6 — Outfit armado manualmente con prendas del closet.
     */
    public static String buildOutfitManual(List<Prenda> prendas, Caracteristicas caracteristicas) {
        StringBuilder sb = new StringBuilder();
        sb.append("Fashion photo, full body, woman wearing EXACTLY these clothing items: ");

        if (prendas != null && !prendas.isEmpty()) {
            for (int i = 0; i < prendas.size(); i++) {
                Prenda p = prendas.get(i);
                sb.append(describir(p));
                if (i < prendas.size() - 1)
                    sb.append(" AND ");
            }
        } else {
            sb.append("stylish casual outfit");
        }

        sb.append(". Show the complete outfit from head to toe");

        if (caracteristicas != null) {
            if (caracteristicas.getTonoPiel() != null)
                sb.append(", woman with ").append(caracteristicas.getTonoPiel()).append(" skin tone");
            if (caracteristicas.getTipoCabello() != null)
                sb.append(", ").append(caracteristicas.getTipoCabello()).append(" hair");
        }

        sb.append(SUFIJO);
        return sb.toString();
    }

    /**
     * IMAGEN 4 — Chat IA libre.
     */
    public static String buildChatOutfit(String mensajeUsuario, Caracteristicas caracteristicas) {
        StringBuilder sb = new StringBuilder();
        sb.append("Full body fashion photo of a woman in a stylish complete outfit. ");
        sb.append("Outfit style: ").append(mensajeUsuario.trim());

        if (caracteristicas != null) {
            if (caracteristicas.getTonoPiel() != null)
                sb.append(". Woman with ").append(caracteristicas.getTonoPiel()).append(" skin tone");
            if (caracteristicas.getTipoCabello() != null)
                sb.append(", ").append(caracteristicas.getTipoCabello()).append(" hair");
        }

        sb.append(SUFIJO);
        return sb.toString();
    }

    /**
     * IMAGEN 10 — Outfit para viaje según clima.
     */
    public static String buildViaje(List<Prenda> prendas, String destino,
            String clima, Caracteristicas caracteristicas) {
        StringBuilder sb = new StringBuilder();
        sb.append("Full body fashion photo, woman wearing a travel outfit");

        if (destino != null && !destino.isBlank())
            sb.append(" for ").append(destino);
        if (clima != null && !clima.isBlank())
            sb.append(", ").append(clima).append(" weather");

        if (prendas != null && !prendas.isEmpty()) {
            sb.append(". Wearing: ");
            int max = Math.min(prendas.size(), 4);
            for (int i = 0; i < max; i++) {
                sb.append(describir(prendas.get(i)));
                if (i < max - 1)
                    sb.append(", ");
            }
        }

        if (caracteristicas != null && caracteristicas.getTonoPiel() != null)
            sb.append(". Woman with ").append(caracteristicas.getTonoPiel()).append(" skin tone");

        sb.append(SUFIJO);
        return sb.toString();
    }

    /**
     * IMAGEN 3 — Recomendación automática.
     */
    public static String buildRecomendacion(String estilo, String ocasion,
            String clima, Caracteristicas caracteristicas) {
        StringBuilder sb = new StringBuilder();
        sb.append("Full body fashion photo of a stylish woman wearing a complete ");
        if (estilo != null)
            sb.append(estilo).append(" ");
        sb.append("outfit");
        if (ocasion != null)
            sb.append(" for ").append(ocasion);
        if (clima != null && !clima.isBlank())
            sb.append(" in ").append(clima).append(" weather");

        if (caracteristicas != null && caracteristicas.getTonoPiel() != null)
            sb.append(". Woman with ").append(caracteristicas.getTonoPiel()).append(" skin tone");

        sb.append(SUFIJO);
        return sb.toString();
    }

    /**
     * Genera descripción rica de una prenda usando todos los campos disponibles.
     * color + tipo + estilo + temporada (lo que haya)
     */
    private static String describir(Prenda p) {
        StringBuilder sb = new StringBuilder();

        // Color
        if (p.getColor() != null && !p.getColor().isBlank())
            sb.append(p.getColor()).append(" ");

        // Tipo — traducir a inglés para mejores resultados en HuggingFace
        if (p.getTipo() != null) {
            sb.append(traducirTipo(p.getTipo()));
        }

        // Estilo
        if (p.getEstilo() != null && !p.getEstilo().isBlank()) {
            sb.append(" (").append(p.getEstilo()).append(" style)");
        }

        return sb.toString().trim();
    }

    /** Traduce tipos de prenda a inglés para mejores resultados con FLUX */
    private static String traducirTipo(String tipo) {
        if (tipo == null)
            return "clothing";
        switch (tipo.toLowerCase().trim()) {
            case "tops":
                return "top";
            case "bottoms":
                return "pants";
            case "dresses":
                return "dress";
            case "outerwear":
                return "jacket";
            case "shoes":
                return "shoes";
            case "accessories":
                return "accessory";
            case "pantalon":
            case "pantalón":
                return "pants";
            case "falda":
                return "skirt";
            case "vestido":
                return "dress";
            case "camisa":
                return "shirt";
            case "camiseta":
                return "t-shirt";
            case "chaqueta":
                return "jacket";
            case "abrigo":
                return "coat";
            case "zapatos":
                return "shoes";
            case "bolso":
                return "bag";
            default:
                return tipo;
        }
    }

    private PromptBuilder() {
    }
}