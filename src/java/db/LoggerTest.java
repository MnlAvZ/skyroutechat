/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package db;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Manuel Anaya
 */
public class LoggerTest {
    private final static Logger LOGGER = Logger.getLogger("db.LoggerTest");//TAG
    
    public static void main(String[] args) {
        String hola = "hola";
        int n = 0;
        
        n = parse(hola);
        
        
    }
    
    public static int parse(String s){
        int n =0;
        try{
            n = Integer.parseInt(s);
        }catch(Exception e){
            LOGGER.log(Level.INFO, "Proceso exitoso");//Etiqueda de que solo va a mostrar informacion
            //LOGGER.log(Level.SEVERE, "ERROR MASIVO");//Erro GRAVE
            //LOGGER.log(Level.WARNING, "Ocurrio un error de acceso en 0xFF");// WARNING
        }
        return n;
    }
}
