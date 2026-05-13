package com.quiddity.model;

public class ChatBot {

    private int id;
    private String pregunta;
    private String respuesta;

    public ChatBot() {
    }

    public ChatBot(int id, String pregunta, String respuesta) {
        this.id = id;
        this.pregunta = pregunta;
        this.respuesta = respuesta;
    }

    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPregunta() {
        return this.pregunta;
    }

    public void setPregunta(String pregunta) {
        this.pregunta = pregunta;
    }

    public String getRespuesta() {
        return this.respuesta;
    }

    public void setRespuesta(String respuesta) {
        this.respuesta = respuesta;
    }

    public String toString() {
        return "ChatBot{id='" + this.id + "', pregunta='" + this.pregunta + "'}";
    }
}
