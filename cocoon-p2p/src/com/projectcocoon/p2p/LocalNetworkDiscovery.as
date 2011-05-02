/*
* Copyright 2011 (c) Peter Elst, project-cocoon.com.
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package com.projectcocoon.p2p
{
	
	import com.projectcocoon.p2p.command.CommandList;
	import com.projectcocoon.p2p.command.CommandScope;
	import com.projectcocoon.p2p.command.CommandType;
	import com.projectcocoon.p2p.events.AccelerationEvent;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.managers.GroupManager;
	import com.projectcocoon.p2p.managers.ObjectManager;
	import com.projectcocoon.p2p.util.ClassRegistry;
	import com.projectcocoon.p2p.vo.AccelerationVO;
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MessageVO;
	
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.registerClassAlias;
	import flash.sensors.Accelerometer;
	
	import mx.collections.ArrayCollection;
	import mx.core.IMXMLObject;

	[Event(name="groupConnected", type="com.projectcocoon.p2p.events.GroupEvent")]
	[Event(name="groupClosed", type="com.projectcocoon.p2p.events.GroupEvent")]
	[Event(name="clientAdded", type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="clientAdded", type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="clientUpdate", type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="clientRemoved", type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="dataReceived", type="com.projectcocoon.p2p.events.MessageEvent")]
	[Event(name="accelerometerUpdate", type="com.projectcocoon.p2p.events.AccelerationEvent")]
	public class LocalNetworkDiscovery extends EventDispatcher implements IMXMLObject
	{
		/**
		 * URL for LAN connectivity
		 */
		private static const RTMFP_LOCAL:String = "rtmfp:";
		
		/**
		 * URL for peer discovery through Adobe's Cirrus service
		 * @see http://labs.adobe.com/technologies/cirrus/
		 */ 
		private static const RTMFP_CIRRUS:String = "rtmfp://p2p.rtmfp.net";
	
		private var _autoConnect:Boolean = true;
		private var _nc:NetConnection;
		private var _groupSpec:GroupSpecifier;
		private var _groupManager:GroupManager;
		private var _objectManager:ObjectManager;
		private var _group:NetGroup;
		private var _clientName:String;
		private var _localClient:ClientVO;
		private var _clients:ArrayCollection = new ArrayCollection();
		private var _groupName:String = "default";
		private var _multicastAddress:String = "225.225.0.1:30303";
		private var _receiveLocal:Boolean = false;
		private var _acc:Accelerometer;
		private var _accelerometerInterval:uint = 0;
		
		// ========================== //
			
		public function LocalNetworkDiscovery()
		{
			registerClasses();
		}
		
		public function initialized(document:Object, id:String):void
		{
			if (autoConnect)
				connect();
		}
		
		/**
		 * Connects to the p2p network 
		 */		
		public function connect():void
		{
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_nc.connect(RTMFP_LOCAL);
		}
		
		public function close():void
		{
			// todo
		}
		
		/**
		 * Sends an arbitrary message (object, primitive, etc.) to a specific peer in the p2p network 
		 * @param value the message to send. Can be any type.
		 * @param groupID the group address of the peer (usually ClientVO.groupID)
		 */		
		public function sendMessageToClient(value:Object, groupID:String):void
		{
			var msg:MessageVO = _groupManager.sendMessageToGroupAddress(value, _group, groupID);
			if(loopback) 
				dispatchEvent(new MessageEvent(MessageEvent.DATA_RECEIVED, msg));
		}
		
		/**
		 * Sends an arbitrary message (object, primitive, etc.) to all peers in the p2p network 
		 * @param value the message to send. Can be any type.
		 */
		public function sendMessageToAll(value:Object):void
		{
			var msg:MessageVO = _groupManager.sendMessageToAll(value, _group);
			if(loopback) 
				dispatchEvent(new MessageEvent(MessageEvent.DATA_RECEIVED, msg));
		}
		
		public function shareWithClient(value:Object, groupID:String):void
		{
			if (!_objectManager)
				_objectManager = new ObjectManager(_groupManager);
			_objectManager.share(value, _groupName, groupID);
		}
		
		public function shareWithAll(value:Object):void
		{
			if (!_objectManager)
				_objectManager = new ObjectManager(_groupManager);
			_objectManager.share(value, _groupName);
		}
		
		// ========================== //
		
		[Bindable(event="clientsConnectedChange")]
		public function get clientsConnected():uint
		{
			if (_groupManager && _group)
				return _groupManager.getClients(_group).length;
			return 0;
		}
		
		[Bindable(event="clientsChange")]
		public function get clients():ArrayCollection
		{
			return _clients;
		}
		
		public function get autoConnect():Boolean
		{
			return _autoConnect;
		}
		public function set autoConnect(value:Boolean):void
		{
			_autoConnect = value;
		}
		
		public function get clientName():String
		{
			return _clientName;
		}
		public function set clientName(val:String):void
		{
			_clientName = val;
			if(_localClient) 
			{
				_localClient.clientName = val;
				announceName();
			}
		}		
		
		public function get groupName():String
		{
			return _groupName;
		}
		public function set groupName(val:String):void
		{
			_groupName = val;
		}
		
		public function get multicastAddress():String
		{
			return _multicastAddress;
		}
		public function set multicastAddress(val:String):void
		{
			_multicastAddress = val;
		}
		
		public function get loopback():Boolean
		{
			return _receiveLocal;
		}
		public function set loopback(bool:Boolean):void
		{
			_receiveLocal = bool;
		}
		
		public function get accelerometerInterval():uint
		{
			return _accelerometerInterval;	
		}
		public function set accelerometerInterval(val:uint):void
		{
			_accelerometerInterval = val;
			if(_accelerometerInterval > 0) {
				_acc = new Accelerometer();
				_acc.setRequestedUpdateInterval(accelerometerInterval);
				_acc.addEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
			} else {
				_acc.removeEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
			}
		}
		
		
		// ============= Private ============= //
		
		private function registerClasses():void
		{
			ClassRegistry.registerClasses();
		}
		
		private function setupGroup():void
		{
			// Groupspec for the main group
			_groupSpec = new GroupSpecifier(groupName);
			_groupSpec.postingEnabled = true;
			_groupSpec.routingEnabled = true;
			_groupSpec.ipMulticastMemberUpdatesEnabled = true;
			_groupSpec.objectReplicationEnabled = true;
			_groupSpec.addIPMulticastAddress(multicastAddress);
			
			// create and setup the GroupManager
			_groupManager = new GroupManager(_nc);
			_groupManager.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
			_groupManager.addEventListener(GroupEvent.GROUP_CLOSED, onGroupClosed);
			_groupManager.addEventListener(ClientEvent.CLIENT_ADDED, onClientAdded);
			_groupManager.addEventListener(ClientEvent.CLIENT_REMOVED, onClientRemoved);
			_groupManager.addEventListener(ClientEvent.CLIENT_UPDATE, onClientUpdate);
			_groupManager.addEventListener(MessageEvent.DATA_RECEIVED, onDataReceived);
				
			// create the group
			_group = _groupManager.createNetGroup(_groupSpec.groupspecWithAuthorizations());
			
		}

		private function setupClient():void
		{		
			// get the local ClientVO for reference
			_localClient = _groupManager.getLocalClient(_group);
			_localClient.clientName = getClientName();
		}
		
		private function getClientName():String
		{
			if(!_clientName) 
				_clientName = "";
			return _clientName;
		}
		
		private function announceName():void
		{
			// announce ourself to the other peers
			_groupManager.announceToGroup(_group);
		}
		
		// ============= Event Handlers ============= //
		
		private function onNetStatus(evt:NetStatusEvent):void
		{
			switch (evt.info.code) 
			{
				case NetStatusCode.NETCONNECTION_CONNECT_SUCCESS:
					setupGroup();
					break;
			}
		}
		
		private function onGroupConnected(event:GroupEvent):void
		{
			if (event.group == _group)
			{
				_localClient = _groupManager.getLocalClient(_group);
				_localClient.clientName = getClientName();
			}
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onGroupClosed(event:GroupEvent):void
		{
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onClientAdded(event:ClientEvent):void
		{
			if (event.group == _group)
			{
				_clients.addItem(event.client);
				dispatchEvent(new Event("clientsConnectedChange"));
				announceName();
			}
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onClientRemoved(event:ClientEvent):void
		{
			if (event.group == _group)
			{
				_clients.removeItemAt(_clients.getItemIndex(event.client));
				dispatchEvent(new Event("clientsConnectedChange"));
			}
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onClientUpdate(event:ClientEvent):void
		{
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onDataReceived(event:MessageEvent):void
		{
			if(event.group == _group && event.message.command == CommandList.ACCELEROMETER) 
			{
				var acc:AccelerationVO = event.message.data as AccelerationVO;
				dispatchEvent(new AccelerationEvent(AccelerationEvent.ACCELEROMETER, acc));
			}
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onAccelerometer(evt:AccelerometerEvent):void
		{
			var acc:AccelerationVO = new AccelerationVO(_localClient, evt.accelerationX, evt.accelerationY, evt.accelerationZ, evt.timestamp);
			var msg:MessageVO = new MessageVO(_localClient, acc, null, CommandType.SERVICE, CommandScope.ALL, CommandList.ACCELEROMETER);
			if(loopback) 
				dispatchEvent(new AccelerationEvent(AccelerationEvent.ACCELEROMETER, acc));
			_group.post(msg);
		}

	}
	
}