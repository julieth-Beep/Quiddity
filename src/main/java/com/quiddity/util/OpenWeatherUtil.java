package com.quiddity.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.time.LocalDate;

/**
 * OpenWeatherUtil — detecta el clima esperado para un destino y fecha.
 *
 * APIs usadas (ambas gratuitas con tu key):
 * 1. Geocoding API → convierte "Bogotá" en lat/lon
 * 2. Forecast API → clima de los próximos 5 días
 *
 * CONFIGURACIÓN: pon tu API key en API_KEY111.
 */
public class OpenWeatherUtil {

    private static final String API_KEY1 = System.getenv("API_KEY1") != null ? System.getenv("API_KEY1") : "";
    private static final String GEO_URL = "https://api.openweathermap.org/geo/1.0/direct";
    private static final String FORECAST_URL = "https://api.openweathermap.org/data/2.5/forecast";
    private static final String CURRENT_URL = "https://api.openweathermap.org/data/2.5/weather";

    /**
     * Método principal — devuelve descripción de clima lista para guardar en BD.
     * Ejemplos: "soleado caluroso", "lluvioso fresco", "nublado frio"
     *
     * @param destino ciudad destino (ej: "Milan", "Paris", "Bogota")
     * @param fecha   fecha de inicio del viaje
     * @return descripción del clima o "variable" si no se puede determinar
     */
    public static String obtenerClima(String destino, Date fecha) {
        try {
            double[] coords = geocodificar(destino);
            if (coords == null)
                return "variable";

            double lat = coords[0];
            double lon = coords[1];

            LocalDate hoy = LocalDate.now();
            LocalDate fechaViaje = fecha.toLocalDate();
            long diasDif = fechaViaje.toEpochDay() - hoy.toEpochDay();

            String climaRaw;
            double tempC;

            if (diasDif >= 0 && diasDif <= 5) {
                Object[] res = obtenerForecast(lat, lon, fechaViaje);
                if (res == null)
                    return "variable";
                climaRaw = (String) res[0];
                tempC = (double) res[1];
            } else {
                Object[] res = obtenerClimaActual(lat, lon);
                if (res == null)
                    return "variable";
                climaRaw = (String) res[0];
                tempC = (double) res[1];
            }

            return construirDescripcion(climaRaw, tempC);

        } catch (Exception e) {
            System.err.println("[OpenWeatherUtil] Error: " + e.getMessage());
            return "variable";
        }
    }

    // Geocoding
    private static double[] geocodificar(String destino) throws Exception {
        String url = GEO_URL + "?q=" + URLEncoder.encode(destino, StandardCharsets.UTF_8)
                + "&limit=1&appid=" + API_KEY1;
        String json = hacerGet(url);
        if (json == null || json.equals("[]"))
            return null;
        double lat = extraerDouble(json, "\"lat\":");
        double lon = extraerDouble(json, "\"lon\":");
        return new double[] { lat, lon };
    }

    // Forecast 5 días
    private static Object[] obtenerForecast(double lat, double lon, LocalDate fecha) throws Exception {
        String url = FORECAST_URL + "?lat=" + lat + "&lon=" + lon
                + "&appid=" + API_KEY1 + "&units=metric&lang=es&cnt=40";
        String json = hacerGet(url);
        if (json == null)
            return null;

        String fechaStr = fecha.toString();
        int idx = json.indexOf(fechaStr);
        if (idx == -1)
            idx = json.indexOf("\"dt_txt\":");

        int bloqueInicio = json.lastIndexOf("{\"dt\":", idx);
        if (bloqueInicio == -1)
            bloqueInicio = 0;
        String bloque = json.substring(bloqueInicio, Math.min(bloqueInicio + 800, json.length()));

        double temp = extraerDouble(bloque, "\"temp\":");
        String desc = extraerString(bloque, "\"description\":\"");
        return new Object[] { desc, temp };
    }

    // Clima actual
    private static Object[] obtenerClimaActual(double lat, double lon) throws Exception {
        String url = CURRENT_URL + "?lat=" + lat + "&lon=" + lon
                + "&appid=" + API_KEY1 + "&units=metric&lang=es";
        String json = hacerGet(url);
        if (json == null)
            return null;
        double temp = extraerDouble(json, "\"temp\":");
        String desc = extraerString(json, "\"description\":\"");
        return new Object[] { desc, temp };
    }

    /**
     * Construye descripción útil para recomendar ropa.
     * Formato: "condicion temperatura" ej: "soleado caluroso"
     */
    private static String construirDescripcion(String desc, double tempC) {
        String d = desc != null ? desc.toLowerCase() : "";
        String cond;
        if (d.contains("lluvia") || d.contains("llovizna"))
            cond = "lluvioso";
        else if (d.contains("nieve") || d.contains("snow"))
            cond = "nevado";
        else if (d.contains("tormenta") || d.contains("thunder"))
            cond = "tormenta";
        else if (d.contains("niebla") || d.contains("fog"))
            cond = "con niebla";
        else if (d.contains("nube") || d.contains("nublado"))
            cond = "nublado";
        else if (d.contains("sol") || d.contains("clear"))
            cond = "soleado";
        else
            cond = "variable";

        String temp;
        if (tempC >= 30)
            temp = "muy caluroso";
        else if (tempC >= 22)
            temp = "caluroso";
        else if (tempC >= 15)
            temp = "templado";
        else if (tempC >= 8)
            temp = "fresco";
        else if (tempC >= 0)
            temp = "frio";
        else
            temp = "muy frio";

        return cond + " " + temp;
    }

    /**
     * Mapea clima a temporada de ropa — usado por ViajeDAO para filtrar closet.
     */
    public static String climaATemporada(String clima) {
        if (clima == null)
            return "todas";
        String c = clima.toLowerCase();
        if (c.contains("frio") || c.contains("nevado"))
            return "invierno";
        if (c.contains("caluroso") || c.contains("sol"))
            return "verano";
        if (c.contains("lluvioso") || c.contains("fresco"))
            return "otono";
        if (c.contains("templado"))
            return "primavera";
        return "todas";
    }

    // HTTP GET simple
    private static String hacerGet(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(10_000);
        conn.setReadTimeout(15_000);
        if (conn.getResponseCode() != 200)
            return null;
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String l;
            while ((l = br.readLine()) != null)
                sb.append(l);
            return sb.toString();
        }
    }

    // Parseo JSON manual sin Gson
    private static double extraerDouble(String json, String clave) {
        int idx = json.indexOf(clave);
        if (idx == -1)
            return 0.0;
        int i = idx + clave.length();
        int f = i;
        while (f < json.length() && (Character.isDigit(json.charAt(f))
                || json.charAt(f) == '.' || json.charAt(f) == '-'))
            f++;
        try {
            return Double.parseDouble(json.substring(i, f));
        } catch (Exception e) {
            return 0.0;
        }
    }

    private static String extraerString(String json, String clave) {
        int idx = json.indexOf(clave);
        if (idx == -1)
            return "";
        int i = idx + clave.length();
        int f = json.indexOf("\"", i);
        if (f == -1)
            return "";
        return json.substring(i, f);
    }
}