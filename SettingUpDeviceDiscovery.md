# Introduction to device discovery #

Device discovery lets you get a list of all connected clients on a given NetGroup and events for connecting and disconnecting clients.

An example Flex project (FXP file) is available in the [downloads section](http://code.google.com/p/cocoon-p2p/downloads/list)



## Source code ##

```
<?xml version="1.0" encoding="utf-8"?>
<s:WindowedApplication 
   xmlns:fx="http://ns.adobe.com/mxml/2009" 
   xmlns:s="library://ns.adobe.com/flex/spark" 
   xmlns:mx="library://ns.adobe.com/flex/mx" 
   xmlns:p2p="com.projectcocoon.p2p.*">

   <fx:Declarations>
      <p2p:LocalNetworkDiscovery id="channel" clientName="My name" />
   </fx:Declarations>
	
   <s:List dataProvider="{channel.clients}" labelField="clientName" />
	
</s:WindowedApplication>
```

## Video tutorial ##

<a href='http://www.youtube.com/watch?feature=player_embedded&v=bXnHav_z2L0' target='_blank'><img src='http://img.youtube.com/vi/bXnHav_z2L0/0.jpg' width='600' height=400 /></a>