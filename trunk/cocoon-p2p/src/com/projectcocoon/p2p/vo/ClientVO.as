package com.projectcocoon.p2p.vo
{
	
	[Bindable]
	public class ClientVO
	{
		
		public var clientName:String;
		public var peerID:String;
		public var groupID:String;
		
		public function ClientVO(_clientName:String,_peerID:String,_groupID:String)
		{
			clientName = _clientName;
			peerID = _peerID;
			groupID = _groupID;
		}
		
	}
}