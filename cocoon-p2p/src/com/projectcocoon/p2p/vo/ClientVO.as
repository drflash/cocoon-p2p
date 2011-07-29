package com.projectcocoon.p2p.vo
{
	
	[Bindable]
	public class ClientVO
	{
		
		public var clientName:String;
		public var peerID:String;
		public var groupID:String;
		
		[Transient]
		public var isLocal:Boolean;
		
		public function ClientVO(clientName:String = null, peerID:String = null, groupID:String = null)
		{
			this.clientName = clientName;
			this.peerID = peerID;
			this.groupID = groupID;
		}
		
	}
}