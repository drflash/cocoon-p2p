package com.projectcocoon.p2p.managers
{
	import com.projectcocoon.p2p.NetStatusCode;
	import com.projectcocoon.p2p.command.CommandList;
	import com.projectcocoon.p2p.command.CommandScope;
	import com.projectcocoon.p2p.command.CommandType;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MessageVO;
	
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.utils.Dictionary;

	[Event(name="groupConnected", type="com.projectcocoon.p2p.events.GroupEvent")]
	[Event(name="groupClosed", type="com.projectcocoon.p2p.events.GroupEvent")]
	[Event(name="clientAdded", type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="clientUpdate", type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="clientRemoved", type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="dataReceived", type="com.projectcocoon.p2p.events.MessageEvent")]
	public class GroupManager extends EventDispatcher
	{
		
		private var netConnection:NetConnection;
		private var groups:Dictionary = new Dictionary();
		
		
		// ========================== //
		
		public function GroupManager(netConnection:NetConnection)
		{
			this.netConnection = netConnection;
			this.netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 9999);
		}
		
		public function createNetGroup(groupSpec:String):NetGroup
		{
			var group:NetGroup = new NetGroup(netConnection, groupSpec);
			group.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 9999);
			
			var groupInfo:GroupInfo = new GroupInfo(groupSpec);
			groups[group] = groupInfo;
			
			return group;
		}
		
		public function leaveNetGroup(netGroup:NetGroup):void
		{
			netGroup.close();
		}
		
		public function announceToGroup(netGroup:NetGroup):MessageVO
		{
			var client:ClientVO = getLocalClient(netGroup);
			if (client)
			{
				var msg:MessageVO = new MessageVO(client, null, null, CommandType.SERVICE, CommandScope.ALL, CommandList.ANNOUNCE_NAME);
				netGroup.post(msg);
				return msg;
			}
			return null;
		}
		
		public function sendMessageToAll(value:Object, netGroup:NetGroup):MessageVO
		{
			var client:ClientVO = getLocalClient(netGroup);
			if (client)
			{
				var msg:MessageVO = new MessageVO(client, value, null, CommandType.MESSAGE, CommandScope.ALL);
				netGroup.post(msg);
				return msg;
			}
			return null;
		}
		
		public function sendMessageToClient(value:Object, netGroup:NetGroup, client:ClientVO):MessageVO
		{
			return sendMessageToGroupAddress(value, netGroup, client.groupID);
		}
		
		public function sendMessageToGroupAddress(value:Object, netGroup:NetGroup, groupAddress:String):MessageVO
		{
			var client:ClientVO = getLocalClient(netGroup);
			if (client)
			{
				var msg:MessageVO = new MessageVO(client, value, groupAddress, CommandType.MESSAGE, CommandScope.DIRECT);
				netGroup.sendToNearest(msg, groupAddress);
				return msg;
			}
			return null;
		}
		
		public function getLocalClient(netGroup:NetGroup):ClientVO
		{
			return getClient(netGroup, netConnection.nearID);
		}
		
		public function getClient(netGroup:NetGroup, peerID:String):ClientVO
		{
			var groupInfo:GroupInfo = groups[netGroup];
			if (groupInfo)
			{
				return getClientByPeerID(groupInfo, peerID);
			}
			return null;
		}
		
		public function getClients(netGroup:NetGroup):Vector.<ClientVO>
		{
			var groupInfo:GroupInfo = groups[netGroup];
			if (groupInfo)
			{
				return groupInfo.clients;
			}
			return new Vector.<ClientVO>();
		}
		
		
		// ============= Private ============= //
		
		private function getClientByPeerID(groupInfo:GroupInfo, peerID:String):ClientVO
		{
			for each (var client:ClientVO in groupInfo.clients)
			{
				if (client.peerID == peerID)
					return client;
			}
			return null;
		}
		
		private function groupConnected(netGroup:NetGroup):void
		{
			addNeighbour(netGroup, netConnection.nearID, true);
			dispatchEvent(new GroupEvent(GroupEvent.GROUP_CONNECTED, netGroup));
			// adds the local client to the list of peers in the NetGroup
		}

		private function addNeighbour(netGroup:NetGroup, peerID:String, isLocal:Boolean = false):void
		{
			var groupInfo:GroupInfo = groups[netGroup];
			if (groupInfo)
			{
				if (!getClientByPeerID(groupInfo, peerID))
				{
					var client:ClientVO = new ClientVO();
					client.peerID = peerID;
					client.groupID = netGroup.convertPeerIDToGroupAddress(client.peerID);
					client.isLocal = isLocal;
					groupInfo.clients.push(client);
					dispatchEvent(new ClientEvent(ClientEvent.CLIENT_ADDED, client, netGroup));
				}
			}
		}
		
		private function removeNeighbour(netGroup:NetGroup, peerID:String):void
		{
			var groupInfo:GroupInfo = groups[netGroup];
			if (groupInfo)
			{
				var client:ClientVO = getClientByPeerID(groupInfo, peerID);
				if (!client)
					return;
				var idx:int = groupInfo.clients.indexOf(client)
				if (idx > -1)
				{
					groupInfo.clients.splice(idx, 1);
					dispatchEvent(new ClientEvent(ClientEvent.CLIENT_REMOVED, client, netGroup));
				}
			}
		}
		
		private function handleSendTo(event:NetStatusEvent):void
		{
			if (event.info.fromLocal == true) 
			{
				dispatchEvent(new MessageEvent(MessageEvent.DATA_RECEIVED, event.info.message as MessageVO, event.target as NetGroup));
			} 
			else 
			{
				event.target.sendToNearest(event.info.message, event.info.message.destination);
			}
		}
		
		private function handlePosting(event:NetStatusEvent):void
		{
			var msg:MessageVO = event.info.message as MessageVO;
				
			if (!msg)
				return;
			
			var group:NetGroup = event.target as NetGroup; 
			var groupInfo:GroupInfo = groups[group];
			
			if (msg.type == CommandType.SERVICE) 
			{
				if (msg.command == CommandList.ANNOUNCE_NAME) 
				{
					for each (var client:ClientVO in groupInfo.clients) 
					{
						if(client.groupID == msg.client.groupID) 
						{
							client.clientName = msg.client.clientName;
							dispatchEvent(new ClientEvent(ClientEvent.CLIENT_UPDATE, client, group));
							break;
						}
					}
				}
			} 
			else 
			{
				dispatchEvent(new MessageEvent(MessageEvent.DATA_RECEIVED, msg, group));
			}
		}		
		
		private function cleanup(netGroup:NetGroup):void
		{
			netGroup.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			dispatchEvent(new GroupEvent(GroupEvent.GROUP_CLOSED, netGroup));
			delete groups[netGroup];
		}
		
		private function cleanupAll():void
		{
			netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			for each (var netGroup:NetGroup in groups)
				netGroup.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			groups = null;
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			switch (event.info.code) 
			{
				case NetStatusCode.NETGROUP_CONNECT_SUCCESS:
					groupConnected(event.info.group as NetGroup);
					break;
				case NetStatusCode.NETGROUP_NEIGHBOUR_CONNECT:
					addNeighbour(event.target as NetGroup, event.info.peerID);
					break;
				case NetStatusCode.NETGROUP_NEIGHBOUR_DISCONNECT:
					removeNeighbour(event.target as NetGroup, event.info.peerID);
					break;
				case NetStatusCode.NETGROUP_POSTING_NOTIFY:
					handlePosting(event);
					break;
				case NetStatusCode.NETGROUP_SENDTO_NOTIFY:
					handleSendTo(event);
					break;
				case NetStatusCode.NETGROUP_CONNECT_CLOSED:
				case NetStatusCode.NETGROUP_CONNECT_FAILED:
				case NetStatusCode.NETGROUP_CONNECT_REJECTED:
					cleanup(event.info.group as NetGroup);
					break;
				case NetStatusCode.NETCONNECTION_CONNECT_FAILED:
				case NetStatusCode.NETCONNECTION_CONNECT_CLOSED:
					cleanupAll();
					break;
				
			}
		}
		
	}
}

import com.projectcocoon.p2p.vo.ClientVO;

import flash.net.NetConnection;

class GroupInfo
{
	public var peerIds:Vector.<String>;
	public var clients:Vector.<ClientVO>;
	public var groupSpec:String;
	
	public function GroupInfo(groupSpec:String)
	{
		this.groupSpec = groupSpec;
		peerIds = new Vector.<String>();
		clients = new Vector.<ClientVO>();
	}
	
}