package com.quiddity.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConexionDB {

    private static String URL;
    private static String USERNAME;
    private static String PASSWORD;
    private static String DRIVER;

    static {
        try (InputStream input = ConexionDB.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (input == null) {
                throw new RuntimeException("No se encontró db.properties en el classpath");
            }

            Properties props = new Properties();
            props.load(input);

            URL      = props.getProperty("db.url");
            USERNAME = props.getProperty("db.username");
            PASSWORD = props.getProperty("db.password");
            DRIVER   = props.getProperty("db.driver");

            Class.forName(DRIVER);

        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException("Error al inicializar ConexionDB: " + e.getMessage(), e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
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
}