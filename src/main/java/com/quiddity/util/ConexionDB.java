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
        try (InputStream input = ConexionDB.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (input == null) {
                throw new RuntimeException("No se encontró db.properties en el classpath");
            }

            Properties props = new Properties();
            props.load(input);

            String url      = props.getProperty("db.url");
            String username = props.getProperty("db.username");
            String password = props.getProperty("db.password");
            String driver    = props.getProperty("db.driver");

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(url);
            config.setUsername(username);
            config.setPassword(password);
            config.setDriverClassName(driver);

            // --- Tamaño del pool ---
            // 5-10 conexiones es de sobra para un proyecto académico/pequeño.
            // No subas esto sin necesidad: Supabase free tier tiene límite de conexiones simultáneas.
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);

            // --- Tiempos ---
            config.setConnectionTimeout(10000);   // 10s máx esperando una conexión libre
            config.setIdleTimeout(300000);        // 5 min antes de cerrar una conexión ociosa
            config.setMaxLifetime(1700000);       // ~28 min, recicla conexiones antes de que Supabase las corte

            // --- Validación rápida de conexión ---
            config.setConnectionTestQuery("SELECT 1");

            // --- Si usas el modo "pooler" de Supabase (puerto 6543), recomienda esto: ---
            config.addDataSourceProperty("prepareThreshold", "0");

            config.setPoolName("QuidditPool");

            dataSource = new HikariDataSource(config);

        } catch (IOException e) {
            throw new RuntimeException("Error al inicializar ConexionDB: " + e.getMessage(), e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    // Opcional: para cerrar recursos desde los DAO
    public static void close(AutoCloseable... recursos) {
        for (AutoCloseable r : recursos) {
            if (r != null) {
                try { r.close(); }
                catch (Exception e) { e.printStackTrace(); }
            }
        }
    }

    // Llamar esto solo si necesitas apagar el pool manualmente (ej. en un ServletContextListener al destruir el contexto)
    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}