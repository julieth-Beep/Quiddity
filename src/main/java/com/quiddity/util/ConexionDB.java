package com.quiddity.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class ConexionDB {

    private static HikariDataSource dataSource;

    static {
        try {
            // Lee variables de entorno primero (Railway), si no existen usa db.properties (local)
            String url      = System.getenv("DB_URL");
            String username = System.getenv("DB_USER");
            String password = System.getenv("DB_PASSWORD");

            if (url == null || username == null || password == null) {
                // Fallback: cargar desde db.properties
                try (InputStream input = ConexionDB.class
                        .getClassLoader()
                        .getResourceAsStream("db.properties")) {

                    if (input == null) {
                        throw new RuntimeException("No se encontró db.properties en el classpath");
                    }

                    Properties props = new Properties();
                    props.load(input);

                    url      = props.getProperty("db.url");
                    username = props.getProperty("db.username");
                    password = props.getProperty("db.password");
                }
            }

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(url);
            config.setUsername(username);
            config.setPassword(password);
            config.setDriverClassName("org.postgresql.Driver");

            // --- Tamaño del pool ---
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);

            // --- Tiempos ---
            config.setConnectionTimeout(10000);   // 10s máx esperando una conexión libre
            config.setIdleTimeout(300000);        // 5 min antes de cerrar una conexión ociosa
            config.setMaxLifetime(1700000);       // ~28 min, recicla conexiones antes de que Supabase las corte

            // --- Validación rápida de conexión ---
            config.setConnectionTestQuery("SELECT 1");

            config.setPoolName("QuidditPool");

            dataSource = new HikariDataSource(config);

        } catch (IOException e) {
            throw new RuntimeException("Error al inicializar ConexionDB: " + e.getMessage(), e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static void close(AutoCloseable... recursos) {
        for (AutoCloseable r : recursos) {
            if (r != null) {
                try { r.close(); }
                catch (Exception e) { e.printStackTrace(); }
            }
        }
    }

    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}