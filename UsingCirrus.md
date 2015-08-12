# Using Cocoon P2P with Adobe's Cirrus service #

Cocoon P2P allows you to use Adobe's [Cirrus peer introduction service](http://labs.adobe.com/technologies/cirrus/). By using Cirrus you can connect to other peers who are located outside your LAN. Cocoon P2P will still allow local clients to connect, though. So in essence: all local peers will still connect directly on the LAN, remote peers will use Cirrus to connect.

**Note:** To use Cirrus you have to get yourself a Cirrus developer key which requires a free Adobe ID. More information can be found [here](http://labs.adobe.com/technologies/cirrus/).

To use it, just set the `useCirrus` property to true and specify your developer key with the `key` property.



## Source code ##

```
<?xml version="1.0" encoding="utf-8"?>
<s:WindowedApplication 
   xmlns:fx="http://ns.adobe.com/mxml/2009"
   xmlns:s="library://ns.adobe.com/flex/spark"
   xmlns:mx="library://ns.adobe.com/flex/mx" 
   xmlns:p2p="com.projectcocoon.p2p.*" 
   title="P2P messaging" showStatusBar="false" 
   width="525" height="250">

   <fx:Declarations>
      <p2p:LocalNetworkDiscovery id="discovery" 
         clientAdded="onClientAdded(event)"
         clientRemoved="onClientRemoved(event)" 
         dataReceived="onDataReceived(event)" 
         clientName="My name" 
         loopback="true" 
         useCirrus="true"
         key="YOUR_CIRRUS_DEVELOPER_KEY"/> 
   </fx:Declarations>

   <fx:Script> 
   <![CDATA[ 
 
      import com.projectcocoon.p2p.events.ClientEvent; 
      import com.projectcocoon.p2p.events.MessageEvent;

      private var lastClientSelected:int = -1;

      private function sendMessage(evt:Event=null):void { 
         if(client_list.selectedIndex != -1) { 
            discovery.sendMessageToClient(message_txt.text, client_list.selectedItem.groupID); 
         } else { 
            discovery.sendMessageToAll(message_txt.text); 
         } 
         message_txt.text = "";
      }

      private function onClientAdded(evt:ClientEvent):void { 
            chat_txt.htmlText += "<i>*"+evt.client.clientName+" joined the chatroom*</i><br />"; 
      }

      private function onClientRemoved(evt:ClientEvent):void { 
            chat_txt.htmlText += "<i>*"+evt.client.clientName+" left the chatroom*</i><br />"; 
      }

      private function onDataReceived(evt:MessageEvent):void { 
            if(evt.message.scope == "all") { 
                  chat_txt.htmlText += "<b>"+evt.message.client.clientName+"</b>:"+evt.message.data+"<br/>"; 
            } else { 
                  chat_txt.htmlText += "<font color=\"#CC0000\"><i><b>"+evt.message.client.clientName+
                                       "</b>: "+evt.message.data+"</i></font><br />"; 
            }
      }

      private function toggleSelect(evt:MouseEvent):void { 
            if(client_list.selectedIndex == lastClientSelected) client_list.selectedIndex = -1; 
            lastClientSelected = client_list.selectedIndex; 
      }

   ]]>
   </fx:Script>

   <mx:TextArea id="chat_txt" editable="false" x="10" y="10" width="376" height="200" />

   <s:List id="client_list" width="120" labelField="clientName" 
           dataProvider="{discovery.clients}" x="394" y="10" height="230" click="toggleSelect(event)" />

   <s:Button id="send_btn" x="291" y="218" width="95" label="Send" 
             click="sendMessage(event)" enabled="{message_txt.text.length > 0}"/> 

   <s:TextInput id="message_txt" x="10" y="218" width="273" enter="sendMessage(event)" />

</s:WindowedApplication>
```