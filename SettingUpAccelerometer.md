# Introduction to P2P accelerometer data #

Cocoon P2P lets you send and listen for accelerometer information over the NetGroup for use in games etc.

An example Flex project (FXP file) is available in the [downloads section](http://code.google.com/p/cocoon-p2p/downloads/list)



## Source code ##



**Mobile client**

```
<?xml version="1.0" encoding="utf-8"?>
<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009" 
               xmlns:s="library://ns.adobe.com/flex/spark" 
               xmlns:p2p="com.projectcocoon.p2p.*">

   <fx:Declarations>
      <p2p:LocalNetworkDiscovery id="channel" clientName="mobile" accelerometerInterval="500" />
   </fx:Declarations>	
	
</s:Application>
```




**Accelerometer listener**

```
<?xml version="1.0" encoding="utf-8"?>
<s:WindowedApplication xmlns:fx="http://ns.adobe.com/mxml/2009" 
               xmlns:s="library://ns.adobe.com/flex/spark" 
               xmlns:mx="library://ns.adobe.com/flex/mx" 
               xmlns:p2p="com.projectcocoon.p2p.*"
               minWidth="955" minHeight="600">
	
   <fx:Declarations>
      <p2p:LocalNetworkDiscovery id="channel"
                                 clientName="client"
                                 accelerometerUpdate="onAccelerometer(event)" />
   </fx:Declarations>
	
   <fx:Script>
      <![CDATA[

         import com.projectcocoon.p2p.events.AccelerationEvent;
			
         private function onAccelerometer(evt:AccelerationEvent):void {
            clientname_txt.text = evt.acceleration.client.clientName;
            accelerateX_txt.text = String(evt.acceleration.accelerationX);
            accelerateY_txt.text = String(evt.acceleration.accelerationY);
            accelerateZ_txt.text = String(evt.acceleration.accelerationZ);
         }
			
      ]]>
   </fx:Script>
	
   <s:VGroup>
      <s:TextInput id="clientname_txt" />
      <s:TextInput id="accelerateX_txt" />
      <s:TextInput id="accelerateY_txt" />
      <s:TextInput id="accelerateZ_txt" />		
   </s:VGroup>
	
</s:WindowedApplication>
```