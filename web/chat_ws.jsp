<%-- 
    Document   : chat_ws
    Created on : 15/08/2018, 09:18:50 PM
    Author     : Manuel Anaya
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="db.conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
        <%
            String fn = request.getParameter("fn") != null ? request.getParameter("fn") : "";
            String jsonIn = request.getParameter("arg") != null ? request.getParameter("arg") : "";
            ChatWS  QuerySelect = new ChatWS();
                    
            String JsonOut = "";
            if(!fn.equals("")){
                try{
                    switch(fn){
                        case "1":
                            JsonOut = QuerySelect.GetAllUsers();
                        break;
                    }
                } catch (Exception ex) {}
                
            }else{
                JsonOut = "{result: \"Sin funcion\"}";
            }
        %>
        <%!
            //Declaracion de servicion web
            public class ChatWS extends conexion{
    
                public ChatWS(){}

                public String GetAllUsers() throws Exception{
                    String rsJson = "";
                    ResultSet rs;
                    try{
                        super.Conectar();
                        PreparedStatement st = null;
                        st = super.getConexion().prepareCall("{call st_get_all_usrs()}");
                        rs = st.executeQuery();
                        while(rs.next()){
                            rsJson = rs.getString("result");
                        }
                    }catch(Exception e){
                        throw e;
                    }finally{
                        super.Desconectar();
                    }

                    return rsJson;
                }
            }
            
        %>

    <%=JsonOut%>
