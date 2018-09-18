<%-- 
    Document   : index
    Created on : 3/09/2018, 09:33:41 AM
    Author     : Manuel Anaya
--%>

<%@page import="java.util.Random"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <%
            String sEmisor = request.getParameter("emsr")!=null?request.getParameter("emsr").toString():"";;
            String sReceptor = request.getParameter("rctr")!=null?request.getParameter("rctr").toString():"";;
        %>
    </head>
    <body>
        <div class="chatbox">
            <div class="chatlogs" id="ls_msj">
                    
            </div>

            <div class="chat-form">
                <textarea id="c_msj"></textarea>
                <div class="upload-btnsend-wrapper">
                    <input type="file" name="myfile" id="c_file"/>
                    <label for="c_file"><figure><svg xmlns="http://www.w3.org/2000/svg" width="20" height="17" viewBox="0 0 20 17"><path d="M10 0l-5.2 4.9h3.3v5.1h3.8v-5.1h3.3l-5.2-4.9zm9.3 11.5l-3.2-2.1h-2l3.4 2.6h-3.5c-.1 0-.2.1-.2.1l-.8 2.3h-6l-.8-2.2c-.1-.1-.1-.2-.2-.2h-3.6l3.4-2.6h-2l-3.2 2.1c-.4.3-.7 1-.6 1.5l.6 3.1c.1.5.7.9 1.2.9h16.3c.6 0 1.1-.4 1.3-.9l.6-3.1c.1-.5-.2-1.2-.7-1.5z"/></svg></figure></label>

                </div>
                
                <button id="btn_enviar">Enviar</button>
            </div>
	</div>
    </body>
    <script src="https://www.gstatic.com/firebasejs/5.4.2/firebase.js"></script>
    <script>

        // Conexion a la base de datos de firebase
        var config = {
                apiKey: "AIzaSyAq_zjuoJnmAsGo08mO_znOqJnE7yUY3Gs",
            authDomain: "skyroutechat.firebaseapp.com",
            databaseURL: "https://skyroutechat.firebaseio.com",
            projectId: "skyroutechat",
            storageBucket: "skyroutechat.appspot.com",
            messagingSenderId: "311529220800"
        };
        firebase.initializeApp(config);//init
        //
        
        //String con la sala de chat del emisor y receptor    
        var sSalaEmisor = '<%=sEmisor%>'+'_'+'<%=sReceptor%>';
        var sSalaReceptor ='<%=sReceptor%>'+'_'+'<%=sEmisor%>';//Referencia a la base del receptor    
        
        //Referencia a los objetos de la vista
        var txtMensje = OB_('c_msj');
        var btnEnviar = OB_('btn_enviar');
        var lstMensajes = OB_('ls_msj');
        var inFile = OB_('c_file');
        
        //Imagen default loading
        var LOADING_IMAGE_URL = 'https://www.google.com/images/spin-32.gif?a';

        // Send Mensaje TXT
        btnEnviar.addEventListener('click', sendMensajeTxt);
        //Send Mesaje IMG
        inFile.onchange = function (){sendMensajeImg();};
        
        
        
        function init(){
            loadMensajes();//Cargar mensajes previos
        }
        
        //Get Object
        function OB_(OB_I) {
            if (document.all) {
                OB = document.all[OB_I];
            }
            else if (document.getElementById) {
                OB = document.getElementById(OB_I);
            }
            else if (document.layers) {
                OB = document.layers(OB_I);
            }
            return OB;
        }
      
      
        /*
         * Funcion que cargalos mensajes previos, 
         * asi como una modificacion en la base de datos
         */
        function loadMensajes(){
            var callback = function (snap){
              var msj = snap.val();  
              showMensaje(msj, snap.key);
            };
            
            firebase.database().ref(sSalaEmisor).on('child_added', callback);//Se añade un nodo
            firebase.database().ref(sSalaEmisor).on('child_changed', callback);//Se actualiza un nodo
        }
        
        /*
         * Funcion que recibe el msj de bd y lo pinta 
         * en la vista
         */
        function showMensaje(msj, sKey){
            var sHtml = '';
            //console.log(msj);
            
            if(OB_('adj_'+sKey) == undefined) {//Mensaje no existe lo crea
                console.log('mesanje no existe');
                if(msj.sTipoMensaje.toString().includes('1_')){
                    switch(msj.sTipoMensaje.toString()){//Si lo envio el emisor
                        case "1_1"://Text simple
                            sHtml += '<div class="chat emisor" >'+
                                        '<div class="user-photo">'+
                                            '<img src="#"/>'+
                                        '</div>'+
                                            '<p class="chat-message" id=\"msj_'+sKey+'\">'+msj.sMensaje+'</p>'+
                                     '</div>';
                        break;
                        case "1_2"://Masaje Imagen
                            sHtml += '<div class="chat emisor">'+
                                        '<div class="user-photo">'+
                                            '<img src="#"/>'+
                                        '</div>'+
                                            '<p class="chat-message img" id=\"msj_'+sKey+'\">'+msj.sMensaje+'<br>'+
                                                '<img id=\"adj_'+sKey+'\"style=\"width: 50%;margin:10px auto;display:block;\" src="'+msj.uriAdjunto+'"/ align=\"center\" onclick=\"downFile(\''+msj.pathAdjunto+'\')\">'+'</p>'+
                                    '</div>';
                        break;
                    }
                }else{
                    switch(msj.sTipoMensaje.toString()){//Si fue un mensaje que nos envio el receptor
                        case "2_1"://Mensaje simple
                            sHtml += '<div class="chat receptor">'+
                                        '<div class="user-photo">'+
                                            '<img src="#"/>'+
                                        '</div>'+
                                        '<p class="chat-message">'+msj.sMensaje+'</p>'+
                                     '</div>';
                        break;
                        case "2_2"://Mensaje imagen
                            sHtml += '<div class="chat receptor">'+
                                        '<div class="user-photo">'+
                                            '<img src="#"/>'+
                                        '</div>'+
                                            '<p class="chat-message img" id=\"msj_'+sKey+'\">'+msj.sMensaje+'<br>\n\
                                                <img id=\"adj_'+sKey+'\" style=\"width: 50%;margin:10px auto;display:block;\" src="'+msj.uriAdjunto+'"/>'+
                                            '</p>'+
                                     '</div>';
                        break;
                    }
                }
            }else{//Actuliza la imagen adjunta del mensaje KEY
                console.log('mensaje existe');
                OB_('adj_'+sKey).src = msj.uriAdjunto;//SRC
                OB_('adj_'+sKey).setAttribute( "onClick", "downFile('"+msj.pathAdjunto+"');" );//add download
            }
            lstMensajes.innerHTML += sHtml;
            lstMensajes.scrollTop = lstMensajes.scrollHeight;
        }
      
        /*
         * Funcion que enviar un msj de texto simple
         */
        function sendMensajeTxt(){
            var sMensaje = txtMensje.value;
            
            if(sMensaje.length != 0){
                var sHora = Date.now();
            
                firebase.database().ref(sSalaEmisor).push({
                        hora: sHora,
                        sMensaje: sMensaje,
                        sTipoMensaje: '1_1',
                        uriAdjunto: '',
                        pathAdjunto: ''
                });

                firebase.database().ref(sSalaReceptor).push({
                        hora: sHora,
                        sMensaje: sMensaje,
                        sTipoMensaje: '2_1',
                        uriAdjunto: '',
                        pathAdjunto: ''
                });

                txtMensje.value = '';
            }
        }
        
        /*
         *Funcion que inviar una IMAGEN
         */
        function sendMensajeImg(){
            if(inFile.files[0] != undefined){
                var sHora = Date.now();
                var file = inFile.files[0];
                
                firebase.database().ref(sSalaEmisor).push({
                        hora: sHora,
                        sMensaje: 'Has enviado una imagen',
                        sTipoMensaje: '1_2',
                        uriAdjunto: LOADING_IMAGE_URL,
                        pathAdjunto: ''
                }).then(function (msjRef){
                    var filePath = sSalaEmisor + '/' + msjRef.key + '/' + file.name;
                    return firebase.storage().ref(filePath).put(file).then(function(fileSnapshot) {
                      // 3 - Generate a public URL for the file.
                      return fileSnapshot.ref.getDownloadURL().then((url) => {
                        // 4 - Update the chat message placeholder with the image’s URL.
                        return msjRef.update({
                          uriAdjunto: url,
                          pathAdjunto: fileSnapshot.metadata.fullPath
                        });
                      });
                    });
                  }).catch(function(error) {
                    console.error('There was an error uploading a file to Cloud Storage:', error);
                  });

                firebase.database().ref(sSalaReceptor).push({
                        hora: sHora,
                        sMensaje: sSalaEmisor+' te ha enviado una imagen',
                        sTipoMensaje: "2_2",
                        uriAdjunto: LOADING_IMAGE_URL
                }).then(function (msjRef){
                    var filePath = sSalaReceptor + '/' + msjRef.key + '/' + file.name;
                    return firebase.storage().ref(filePath).put(file).then(function(fileSnapshot) {
                      // 3 - Generate a public URL for the file.
                      return fileSnapshot.ref.getDownloadURL().then((url) => {
                        // 4 - Update the chat message placeholder with the image’s URL.
                        return msjRef.update({
                          uriAdjunto: url,
                          pathAdjunto: fileSnapshot.metadata.fullPath
                        });
                      });
                    });
                  }).catch(function(error) {
                    console.error('There was an error uploading a file to Cloud Storage:', error);
                  });
            }
        }
      
      
        //Run init
        init();
        
        
        function downFile(sPathFile){
            if(sPathFile.length != 0){
                var storageRef = firebase.storage().ref();
                var postData = new FormData();
                storageRef.child(sPathFile).getDownloadURL().then(function(url) {
                    // `url` is the download URL for 'images/stars.jpg'
                    
                    // This can be downloaded directly:
                    var xhr = new XMLHttpRequest();
                    xhr.responseType = 'blob';
                    xhr.onload = function(event) {
                      var blob = xhr.response;
                      
                       var a = document.createElement("a");
                    a.href = window.URL.createObjectURL(blob);
                    a.download = "fileName.png";
                    a.click();
                    };
                    xhr.open('GET', url);
                    xhr.send();
                    
                  }).catch(function(error) {
                    // Handle any errors
                    console.error('Download Error:', error);
                  });
            }
        }
    </script>
</html>
