/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package db;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author Manuel Anaya
 */
public class conexion {
    private Connection conexion;
    private String host = "127.0.0.1";
    private String database = "chatskyroute";
    private String usuario = "root";
    private String password = "";
    
	
    public void Conectar() throws Exception{
        try{
            Class.forName("com.mysql.jdbc.Driver");
            conexion = DriverManager.getConnection("jdbc:mysql://"+host+":3306/"+database+"?user=" + usuario + "&password=" + password);
        }catch(Exception e){
            throw e;
        }
    }

    public void Desconectar() throws Exception{
            try{
        if(conexion != null){
            if(conexion.isClosed() == false){
                conexion.close();
            }
        } 
    }catch(Exception e){
        throw e;
    }
    }

    protected Connection getConexion(){
            return this.conexion;
    }
}
