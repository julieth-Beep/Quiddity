package com.quiddity.util;

import com.quiddity.model.Prenda;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.List;

public class OutfitComposerUtil {

    private static final int W = 800;
    private static final int H = 960;
    private static final int GAP = 4;
    private static final int ACC_COL = 150;
    private static final int ACC_GAP = 20;
    private static final int HPAD = 20;
    private static final int RPAD = 30;
    private static final int VPAD = 40;

    private static int ordenAcc(String sub) {
        if (sub == null)
            return 7;
        String s = sub.toLowerCase().trim();
        if (s.contains("gafa") || s.contains("sunglass") || s.contains("lente"))
            return 1;
        if (s.contains("collar") || s.contains("necklace") || s.contains("cadena"))
            return 2;
        if (s.contains("cintur") || s.contains("belt") || s.contains("correa"))
            return 3;
        if (s.contains("aret") || s.contains("earring") || s.contains("pendiente"))
            return 4;
        if (s.contains("anill") || s.contains("ring"))
            return 5;
        if (s.contains("pulsera") || s.contains("brazalete") || s.contains("bracelet"))
            return 6;
        if (s.contains("bolso") || s.contains("bag") || s.contains("cartera") ||
                s.contains("mochila") || s.contains("clutch"))
            return 7;
        if (s.contains("sombrero") || s.contains("gorra") || s.contains("hat"))
            return 8;
        return 9;
    }

    public static boolean componer(List<PrendaConRuta> prendas, String rutaSalida) {
        try {
            BufferedImage canvas = new BufferedImage(W, H, BufferedImage.TYPE_INT_RGB);
            Graphics2D g = canvas.createGraphics();
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
            g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g.setColor(Color.WHITE);
            g.fillRect(0, 0, W, H);

            List<PrendaConRuta> accesorios = filtrar(prendas,
                    "accessories", "accesorio", "accesorios", "collar", "aretes", "anillo",
                    "bolso", "bag", "cartera", "cinturon", "gafas", "sombrero", "gorro", "joya", "pulsera");
            List<PrendaConRuta> outerwear = filtrar(prendas,
                    "outerwear", "chaqueta", "abrigo", "blazer", "jacket", "coat", "cardigan", "hoodie", "saco");
            List<PrendaConRuta> tops = filtrar(prendas,
                    "tops", "top", "camisa", "camiseta", "blusa", "shirt", "tshirt", "t-shirt",
                    "crop", "corset", "body", "tank", "bralette", "corsé", "halter");
            List<PrendaConRuta> bottoms = filtrar(prendas,
                    "bottoms", "bottom", "pantalon", "pantalón", "falda", "skirt", "pants",
                    "jeans", "jean", "shorts", "leggings", "minifalda");
            List<PrendaConRuta> dresses = filtrar(prendas,
                    "dresses", "dress", "vestido", "mono", "jumpsuit", "overall", "maxi", "midi");
            List<PrendaConRuta> zapatos = filtrar(prendas,
                    "shoes", "zapatos", "zapato", "zapatillas", "tacones", "botas", "boots",
                    "sneakers", "sandalias", "loafers", "heels", "flats", "mules");

            List<PrendaConRuta> principales = new ArrayList<>();
            principales.addAll(outerwear);
            principales.addAll(tops);
            principales.addAll(dresses);
            principales.addAll(bottoms);

            if (principales.isEmpty() && zapatos.isEmpty() && accesorios.isEmpty())
                return componerGrid(g, prendas, rutaSalida, canvas);

            Set<Integer> usados = new HashSet<>();
            for (List<PrendaConRuta> l : Arrays.asList(accesorios, outerwear, tops, bottoms, dresses, zapatos))
                for (PrendaConRuta p : l)
                    usados.add(p.id);
            for (PrendaConRuta p : prendas)
                if (!usados.contains(p.id))
                    principales.add(p);

            accesorios.sort(Comparator.comparingInt(a -> ordenAcc(a.subcategoria)));

            boolean tieneAcc = !accesorios.isEmpty();

            List<PrendaConRuta> prendSup = new ArrayList<>();
            prendSup.addAll(outerwear);
            prendSup.addAll(tops);
            List<PrendaConRuta> prendMed = new ArrayList<>();
            prendMed.addAll(dresses);
            prendMed.addAll(bottoms);

            boolean haySup = !prendSup.isEmpty();
            boolean hayMed = !prendMed.isEmpty();
            boolean hayZap = !zapatos.isEmpty();
            int nZonas = (haySup ? 1 : 0) + (hayMed ? 1 : 0) + (hayZap ? 1 : 0);

            int altDisp = H - VPAD * 2 - GAP * Math.max(0, nZonas - 1);
            int hSup, hMed, hZap;
            if (nZonas == 3) {
                hSup = (int) (altDisp * 0.38);
                hMed = (int) (altDisp * 0.38);
                hZap = altDisp - hSup - hMed;
            } else if (nZonas == 2) {
                if (haySup && hayMed) {
                    hSup = altDisp / 2;
                    hMed = altDisp - hSup;
                    hZap = 0;
                } else if (haySup && hayZap) {
                    hSup = (int) (altDisp * 0.65);
                    hMed = 0;
                    hZap = altDisp - hSup;
                } else {
                    hSup = 0;
                    hMed = (int) (altDisp * 0.65);
                    hZap = altDisp - hMed;
                }
            } else {
                hSup = haySup ? altDisp : 0;
                hMed = hayMed ? altDisp : 0;
                hZap = hayZap ? altDisp : 0;
            }

            int alturaBloque = (haySup ? hSup : 0) + (hayMed ? hMed : 0) + (hayZap ? hZap : 0)
                    + GAP * Math.max(0, nZonas - 1);

            int xAcc = W - RPAD - ACC_COL;
            int cW = tieneAcc ? xAcc - ACC_GAP - HPAD : W - 2 * HPAD;
            int cX = HPAD;
            int offsetY = Math.max(VPAD, (H - alturaBloque) / 2);

            int y = offsetY;
            if (haySup) {
                int n = Math.min(prendSup.size(), 2), wCad = n == 1 ? cW : (cW - GAP) / 2;
                int xSup = n == 1 ? cX + (cW - wCad) / 2 : cX;
                for (int i = 0; i < n; i++)
                    dibujarPrenda(g, prendSup.get(i).ruta, xSup + i * (wCad + GAP), y, wCad, hSup);
                y += hSup + GAP;
            }
            if (hayMed) {
                int n = Math.min(prendMed.size(), 2), wCad = n == 1 ? Math.min(cW, (int) (cW * 0.85)) : (cW - GAP) / 2;
                int xMed = cX + (cW - (wCad * n + GAP * (n - 1))) / 2;
                for (int i = 0; i < n; i++)
                    dibujarPrenda(g, prendMed.get(i).ruta, xMed + i * (wCad + GAP), y, wCad, hMed);
                y += hMed + GAP;
            }
            if (hayZap) {
                int n = Math.min(zapatos.size(), 2), wCad = n == 1 ? Math.min(cW, (int) (cW * 0.70)) : (cW - GAP) / 2;
                int xZap = cX + (cW - (wCad * n + GAP * (n - 1))) / 2;
                for (int i = 0; i < n; i++)
                    dibujarPrenda(g, zapatos.get(i).ruta, xZap + i * (wCad + GAP), y, wCad, hZap);
            }

            // ── Columna derecha: accesorios con separación limitada ───────
            // No estirar el espacio sobrante entre todos los accesorios
            // (eso empuja al último, ej. bolso, muy abajo). En su lugar,
            // usar separación fija máxima y centrar el bloque resultante.
            if (tieneAcc) {
                int n = accesorios.size();
                int sz = Math.min(ACC_COL, (alturaBloque - GAP * (n - 1)) / n);
                sz = Math.max(sz, 50);

                int totalAcc = sz * n;
                int espacioDisp = alturaBloque - totalAcc;
                int entre = n > 1 ? espacioDisp / (n - 1) : 0;
                entre = Math.max(entre, GAP);

                int altAcc = sz * n + entre * (n - 1);
                int yAcc = offsetY + (alturaBloque - altAcc) / 2;

                // Subir el último accesorio (bolso) para acercarlo al anterior
                int subirUltimo = 40;

                for (int i = 0; i < n; i++) {
                    int ay = yAcc + i * (sz + entre);
                    if (i == n - 1)
                        ay -= subirUltimo;
                    dibujarPrenda(g, accesorios.get(i).ruta, xAcc, ay, ACC_COL, sz);
                }
            }

            if (principales.isEmpty() && zapatos.isEmpty() && !accesorios.isEmpty()) {
                int n = Math.min(accesorios.size(), 4), size = (W - 2 * HPAD - GAP * (n - 1)) / n;
                for (int i = 0; i < n; i++)
                    dibujarPrenda(g, accesorios.get(i).ruta, HPAD + i * (size + GAP), offsetY, size, size);
            }

            g.dispose();
            File outFile = new File(rutaSalida);
            outFile.getParentFile().mkdirs();
            ImageIO.write(canvas, "png", outFile);
            return true;

        } catch (Exception e) {
            System.err.println("[OutfitComposerUtil] Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private static boolean componerGrid(Graphics2D g, List<PrendaConRuta> prendas,
            String rutaSalida, BufferedImage canvas) throws IOException {
        int n = prendas.size(), cols = n == 1 ? 1 : n == 2 ? 2 : n <= 4 ? 2 : 3;
        int rows = (int) Math.ceil((double) n / cols);
        int w = (W - HPAD * 2 - GAP * (cols - 1)) / cols, h = (H - VPAD * 2 - GAP * (rows - 1)) / rows;
        for (int i = 0; i < n; i++) {
            int col = i % cols, row = i / cols;
            dibujarPrenda(g, prendas.get(i).ruta, HPAD + col * (w + GAP), VPAD + row * (h + GAP), w, h);
        }
        g.dispose();
        File outFile = new File(rutaSalida);
        outFile.getParentFile().mkdirs();
        ImageIO.write(canvas, "png", outFile);
        return true;
    }

    private static void dibujarPrenda(Graphics2D g, String ruta, int x, int y, int w, int h) {
        if (ruta == null || w <= 0 || h <= 0)
            return;
        try {
            File f = new File(ruta);
            if (!f.exists()) {
                dibujarPlaceholder(g, x, y, w, h);
                return;
            }
            BufferedImage img = ImageIO.read(f);
            if (img == null) {
                dibujarPlaceholder(g, x, y, w, h);
                return;
            }
            double scale = Math.min((double) (w - 6) / img.getWidth(), (double) (h - 6) / img.getHeight());
            int sw = (int) (img.getWidth() * scale), sh = (int) (img.getHeight() * scale);
            g.drawImage(img, x + (w - sw) / 2, y + (h - sh) / 2, sw, sh, null);
        } catch (Exception e) {
            dibujarPlaceholder(g, x, y, w, h);
        }
    }

    private static void dibujarPlaceholder(Graphics2D g, int x, int y, int w, int h) {
        g.setColor(new Color(245, 245, 243));
        g.fillRoundRect(x, y, w, h, 10, 10);
        g.setColor(new Color(210, 210, 210));
        g.setFont(new Font("Arial", Font.PLAIN, 10));
        g.drawString("—", x + w / 2 - 4, y + h / 2 + 4);
    }

    private static List<PrendaConRuta> filtrar(List<PrendaConRuta> lista, String... tipos) {
        List<PrendaConRuta> res = new ArrayList<>();
        for (PrendaConRuta p : lista) {
            if (p.tipo == null)
                continue;
            String t = p.tipo.toLowerCase().trim();
            for (String tipo : tipos)
                if (t.equals(tipo) || t.contains(tipo) || tipo.contains(t)) {
                    res.add(p);
                    break;
                }
        }
        return res;
    }

    public static class PrendaConRuta {
        public final int id;
        public final String ruta, tipo, color, estilo, imagen, subcategoria;

        public PrendaConRuta(Prenda p, String rutaAbsoluta) {
            this.id = p.getId();
            this.ruta = rutaAbsoluta;
            this.tipo = p.getTipo();
            this.color = p.getColor();
            this.estilo = p.getEstilo();
            this.imagen = p.getImagen();
            this.subcategoria = p.getSubcategoria();
        }
    }
}