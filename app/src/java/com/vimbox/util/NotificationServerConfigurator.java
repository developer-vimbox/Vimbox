package com.vimbox.util;

import com.vimbox.user.User;
import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;

public class NotificationServerConfigurator extends ServerEndpointConfig.Configurator{
    public void modifyHandshake(ServerEndpointConfig sec, HandshakeRequest request, HandshakeResponse response){
        sec.getUserProperties().put("user", (User)((HttpSession)request.getHttpSession()).getAttribute("session"));
    }
}
