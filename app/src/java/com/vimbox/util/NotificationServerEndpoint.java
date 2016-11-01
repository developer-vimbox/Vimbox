package com.vimbox.util;

import com.google.gson.JsonObject;
import com.vimbox.database.NotificationDAO;
import com.vimbox.user.User;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value="/serverEndpoint", configurator=NotificationServerConfigurator.class)
public class NotificationServerEndpoint {
    static Set<Session> onlineUsers = Collections.synchronizedSet(new HashSet<Session>());
    
    @OnOpen
    public void handleOpen(EndpointConfig endpointConfig, Session userSession){
        userSession.getUserProperties().put("user", endpointConfig.getUserProperties().get("user"));
        onlineUsers.add(userSession);
    }
    
    @OnMessage
    public void handleMessage(String payload){
        String[] payloadArr = payload.split("\\}\\{");
        for(String pl : payloadArr){
            String[] msgArr = pl.split("\\|");
            ArrayList<String> users = retrieveUsers(msgArr[0]);
            String message = msgArr[1]; 
            String html = msgArr[2];
            JsonObject jsonOutput = new JsonObject();
            jsonOutput.addProperty("message", message);
            jsonOutput.addProperty("html", html);

            for(Session onlineUser : onlineUsers){
                User user = (User) onlineUser.getUserProperties().get("user");
                if (users.contains(user.getNric())){
                    try{
                        onlineUser.getBasicRemote().sendText(jsonOutput.toString());
                    }catch (Exception e){
                        e.printStackTrace();
                    }
                }
            }
            NotificationDAO.storeNotification(users, message, html);
        }
    }
    
    @OnClose
    public void handleClose(Session userSession){
        onlineUsers.remove(userSession);
    }
    
    @OnError
    public void handleError(Throwable t){}
    
    private ArrayList<String> retrieveUsers(String users){
        ArrayList<String> results = new ArrayList<String>();
        String[] usersArr = users.split(",");
        for(String str: usersArr){
            results.add(str);
        }
        return results;
    }
}
