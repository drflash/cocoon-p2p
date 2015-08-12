# Using Cocoon P2P object replication #

Cocoon P2P makes replicating (sharing) arbitrary objects (primitive data, objects, files, etc.) easy. Just pass an object to LocalNetworkDiscovery''s object replication methods and the object will get replicated on all peers within the network automatically. Directed replication (so only a specific peer gets the object) is also supported.

Objects get split up into chunks by Cocoon P2P and will get resembled on the receiving side. Also, all peers that receive chunks will automatically become "seeders".

In theory objects of any size can get replicated but for larger objects (i.e. files) it may be a good idea to use buffered I/O or streams - these are not provided by Cocoon P2P however.

An example Flex project (FXP file) is available in the [downloads section](http://code.google.com/p/cocoon-p2p/downloads/list)



## Source code ##

```
<?xml version="1.0" encoding="utf-8"?>
<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009" 
			   xmlns:s="library://ns.adobe.com/flex/spark" 
			   xmlns:mx="library://ns.adobe.com/flex/mx" 
			   xmlns:p2p="http://com.projectcocoon.p2p"
			   >
	<fx:Script>
		<![CDATA[
			import com.projectcocoon.p2p.events.ObjectEvent;
			import com.projectcocoon.p2p.vo.ClientVO;
			import com.projectcocoon.p2p.vo.ObjectMetadataVO;
			
			import mx.collections.ArrayCollection;
			import mx.controls.Alert;
			
			
			private function shareFile(event:MouseEvent):void
			{
				fileUtil.load();
			}
			
			protected function saveFile(event:MouseEvent):void
			{
				var data:ObjectMetadataVO = listReceived.selectedItem as ObjectMetadataVO;
				fileUtil.save(data.object as ByteArray, data.info as String);
			}
			
			private function loadCompleteHandler(event:Event):void
			{
				// share the file data (which is a ByteArray) and also pass the name of the file 
				channel.shareWithAll(fileUtil.data, fileUtil.name);
			}
			
			private function saveCompleteHandler(event:Event):void
			{
				Alert.show("File saved!", "Info");
			}
			
			private function objectAnnouncedHandler(event:ObjectEvent):void
			{
				// as soon as a object announcement comes in, request it 
				channel.requestObject(event.metadata);
			}
			
			private function objectProgressHandler(event:ObjectEvent):void
			{
				// force the list to update
				channel.receivedObjects.refresh();
			}
			
			private function getUserLabel(value:ClientVO):String
			{
				if (value.isLocal)
					return value.clientName + " (You)";
				return value.clientName;
			}
			
			private function getReceivedObjectLabel(value:ObjectMetadataVO):String
			{
				return value.info + " (" + Math.ceil(value.progress * 100) + "%)";
			}
			
		]]>
	</fx:Script>
	<fx:Declarations>
		<p2p:LocalNetworkDiscovery id="channel" 
					   clientName="{'User' + Math.ceil(Math.random() * 100)}"
					   objectAnnounced="objectAnnouncedHandler(event)"
					   objectProgress="objectProgressHandler(event)"/>
		
		<p2p:FileUtil id="fileUtil"
			      loadComplete="loadCompleteHandler(event)"
			      saveComplete="saveCompleteHandler(event)"/>
	</fx:Declarations>
	
	<s:Panel title="File Sharing Example" width="600" height="400" verticalCenter="0" horizontalCenter="0">
		
		<s:layout>
			<s:HorizontalLayout paddingBottom="6" paddingLeft="6" paddingRight="6" paddingTop="6"/>
		</s:layout>
		
		<s:VGroup width="100%" height="100%">
			<s:Label text="Users" fontWeight="bold"/>
			<s:List width="100%" height="100%" 
					dataProvider="{channel.clients}" labelFunction="getUserLabel"/>
		</s:VGroup>
		
		<s:VGroup width="100%" height="100%">
			<s:Label text="Your shared files" fontWeight="bold"/>
			<s:List id="listSent" 
					width="100%" height="100%" 
					dataProvider="{channel.sharedObjects}" 
					labelField="info"/>
			<s:Button width="100%" 
					  label="Share File" click="shareFile(event)"/>
		</s:VGroup>
		
		<s:VGroup width="100%" height="100%">
			<s:Label text="Your received files" fontWeight="bold"/>
			<s:List id="listReceived" 
					width="100%" height="100%" 
					dataProvider="{channel.receivedObjects}"
					labelFunction="getReceivedObjectLabel"
					/>
			<s:Button width="100%" 
					  label="Save File" 
					  click="saveFile(event)" 
					  enabled="{listReceived.selectedIndex != -1 &amp;&amp; listReceived.selectedItem.isComplete}"/>
		</s:VGroup>
		
	</s:Panel>
	
</s:Application>
```