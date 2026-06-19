package com.quiddity.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class ClimaUtil {

    private static final String API_KEY = "1cb2bdd620a79010f860863aba507865";
    private static final String URL_BASE = "https://api.openweathermap.org/data/2.5/weather";

    public static class ClimaData {
        public String ciudad;
        public String pais;
        public double tempC;
        public String descripcion;
        public String icono;
        public int humedad;
        public double viento;

        public String getTempFormateada() {
            return Math.round(tempC) + "C";
        }

        public String getCondicion() {
            String d = descripcion != null ? descripcion.toLowerCase() : "";
            if (d.contains("clear") || d.contains("sun"))
                return "Soleado";
            if (d.contains("cloud"))
                return "Parcialmente nublado";
            if (d.contains("rain") || d.contains("drizzle"))
                return "Lluvioso";
            if (d.contains("thunder"))
                return "Tormenta";
            if (d.contains("snow"))
                return "Nevado";
            if (d.contains("mist") || d.contains("fog"))
                return "Con niebla";
            return "Variable";
        }

        public String getEstiloSugerido() {
            if (tempC >= 25)
                return "Verano ligero";
            if (tempC >= 18)
                return "Casual primavera";
            if (tempC >= 10)
                return "Otono abrigado";
            return "Invierno calido";
        }
    }

    public static ClimaData obtenerPorCoordenadas(double lat, double lon) {
        if (API_KEY == null || API_KEY.isBlank()) {
            System.err.println("[ClimaUtil] API_KEY no configurada");
            return null;
        }
        try {
            String urlStr = URL_BASE + "?lat=" + lat + "&lon=" + lon
                    + "&appid=" + API_KEY + "&units=metric&lang=es";

            String json = hacerGet(urlStr);
            if (json == null)
                return null;

            ClimaData c = new ClimaData();
            c.ciudad = extraerString(json, "\"name\":\"");
            c.pais = extraerString(json, "\"country\":\"");
            c.tempC = extraerDouble(json, "\"temp\":");
            c.descripcion = extraerString(json, "\"description\":\"");
            c.icono = extraerString(json, "\"icon\":\"");
            c.humedad = (int) extraerDouble(json, "\"humidity\":");
            c.viento = extraerDouble(json, "\"speed\":");

            return c;

        } catch (Exception e) {
            System.err.println("[ClimaUtil] Error: " + e.getMessage());
            return null;
        }
    }

    private static String hacerGet(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(10000);
        conn.setReadTimeout(15000);
        if (conn.getResponseCode() != 200)
            return null;

        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null)
                sb.append(line);
            return sb.toString();
        }
    }

    private static String extraerString(String json, String clave) {
        int idx = json.indexOf(clave);
        if (idx == -1)
            return "";
        int i = idx + clave.length();
        int f = json.indexOf("\"", i);
        return f == -1 ? "" : json.substring(i, f);
    }

    private static double extraerDouble(String json, String clave) {
        int idx = json.indexOf(clave);
        if (idx == -1)
            return 0;
        int i = idx + clave.length();
        int f = i;
        while (f < json.length() && (Character.isDigit(json.charAt(f))
                || json.charAt(f) == '.' || json.charAt(f) == '-'))
            f++;
        try {
            return Double.parseDouble(json.substring(i, f));
        } catch (Exception e) {
            return 0;
        }
    }
}