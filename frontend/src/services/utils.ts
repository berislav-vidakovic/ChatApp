import { sendGETRequest, sendPOSTRequest, sendPOSTRequestProtected } from './restAPI.ts'
import { handleUserRegister, 
  handleUserLogin, handleUserLogout, handleNewChatResponse, handleUserRoleUpdate } from './messageHandlers.ts'
import { sendWsMessage } from './webSocket.ts'
import type { Dispatch, SetStateAction } from "react";

export const URL_BACKEND_HTTP =
  window.__ENV__?.BACKEND_HTTP_URL || getDefaultHttpUrl();

export const URL_BACKEND_WS =
  window.__ENV__?.BACKEND_WS_URL || getDefaultWsUrl();

declare global {
  interface Window {
    __ENV__?: {
      BACKEND_HTTP_URL?: string;
      BACKEND_WS_URL?: string;
    };
  }
}

function getDefaultHttpUrl(): string {
  const { protocol, host } = window.location;
  return `${protocol}//${host}`;
}

function getDefaultWsUrl(): string {
  const WS_PROTOCOL = window.location.protocol === "https:" ? "wss" : "ws";
  return `${WS_PROTOCOL}://${window.location.host}/websocket`;  
}
// ------------------------------------------------------------------

export async function reconnectApp(){
  console.log("Reconnecting...");
  window.location.reload();
}

export async function disconnectApp(
  setWsConnected:  Dispatch<SetStateAction<boolean>> 
){
  console.log("Disconnecting...");
  setWsConnected(false);
  //window.location.reload();
}




export async function getAllUsers(
  handleGetUsers: (data: any, status: number) => void
) {
    sendGETRequest('api/users/all', handleGetUsers);
    console.log("GET users sent...");
}


export async function registerUser(
    login: string, fullname: string, password:string) {
  const body = JSON.stringify({ login, fullname, password } );
  //{ register: { login, fullname } 
  
  sendPOSTRequest('api/users/register', body, handleUserRegister);

  console.log("POST sending: ", body );
}


export async function loginUser(userId: string, password: string) {
  const body = JSON.stringify({ userId, password } );
  
  sendPOSTRequest('api/auth/login', body, handleUserLogin);
  console.log("POST sending: ", body );
}

export async function logoutUser(userId: string) {
  const body = JSON.stringify({ userId } );
  
  sendPOSTRequest('api/auth/logout', body, handleUserLogout);
  console.log("POST sending: ", body );
}


export function sendChatMessage(currentUserId: string | null, 
  currentChatId: string | null, message: string){
  console.log(`Send message: ${message} chatID:${currentChatId} userId:${currentUserId}`);
    //{type="newMessage", status="WsStatus.OK", data = {id,msg,userId,chatId}}
  const id = sessionStorage.getItem("myID");
  const msg = { type: "newMessage", status: "WsStatus.Request", 
    data: { id, 
            userId: currentUserId, 
            chatId: currentChatId,
            msg: message
    } };

  const strJson = JSON.stringify(msg);
  console.log("Sending WS message...", strJson);
  sendWsMessage(strJson);
  console.log("WS message sent ...");
}


export function createNewChat( creatorId: string, selectedUserIds: string[]){
  console.log("Selected users:", selectedUserIds);
  // { creatorId,  memberIds: [userId1,userId2] }
  const msg = { creatorId, memberIds: selectedUserIds };
  const body = JSON.stringify(msg);
  console.log("Sending POST message...", body);

  sendPOSTRequestProtected('api/chat/new', body, handleNewChatResponse);
}


export function requestUserRoleUpdate( userId: string, userRoles: string[] ){
  const msg = { userId, userRoles };
  const body = JSON.stringify(msg);
  sendPOSTRequestProtected('api/users/roles', body, handleUserRoleUpdate);

}
