# Introduction to P2P messaging #

Cocoon P2P messaging lets you send messages to everyone in a NetGroup or a specific client.

An example Flex project (FXP file) is available in the [downloads section](http://code.google.com/p/cocoon-p2p/downloads/list)



## Source code ##

```
<?xml version="1.0" encoding="utf-8"?>
<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009" 
               xmlns:s="library://ns.adobe.com/flex/spark" 
               xmlns:mx="library://ns.adobe.com/flex/mx" 
               xmlns:p2p="com.projectcocoon.p2p.*"
               minWidth="955" minHeight="600">
    
    <fx:Script>
        <![CDATA[
            import com.projectcocoon.p2p.events.MessageEvent;
            
            protected function channel_dataReceivedHandler(event:MessageEvent):void
            {
                if(!event.message.isDirectMessage) {
                    chatlog_txt.text += event.message.client.clientName+": "+event.message.data+"\n";
                } else {
                    chatlog_txt.text += "PRIVATE MESSAGE from "+ event.message.client.clientName+": "+event.message.data+"\n";                    
                }
            }
            
            protected function save_btn_clickHandler(event:MouseEvent):void
            {
                channel.clientName = username_txt.text;
                username_panel.visible = false;
            }
            
            protected function send_btn_clickHandler(event:MouseEvent):void
            {
                if(clients_list.selectedItem) {
                    channel.sendMessageToClient(chat_txt.text, clients_list.selectedItem.groupID);    
                } else {
                    channel.sendMessageToAll(chat_txt.text);
                }
                chat_txt.text = "";
            }
            
        ]]>
    </fx:Script>
    <fx:Declarations>
        <p2p:LocalNetworkDiscovery id="channel"
                                   loopback="true"
                                   dataReceived="channel_dataReceivedHandler(event)" />
    </fx:Declarations>

    <s:List id="clients_list" dataProvider="{channel.clients}" labelField="clientName" x="342" y="24" height="237" />
    
    <s:TextInput id="chat_txt" x="30" y="276" width="299"/>
    <s:Button id="send_btn" x="342" y="277" width="112" label="Send" click="send_btn_clickHandler(event)"/>
    <s:TextArea id="chatlog_txt" editable="false" x="30" y="24" width="299" height="237"/>
    
    <s:Panel id="username_panel" x="115" y="109" width="250" height="103" title="Set your username">
        <s:Button id="save_btn" x="10" y="39" width="228" label="Save" click="save_btn_clickHandler(event)"/>
        <s:TextInput id="username_txt" x="10" y="10" width="228" />
    </s:Panel>
    
</s:Application>

```