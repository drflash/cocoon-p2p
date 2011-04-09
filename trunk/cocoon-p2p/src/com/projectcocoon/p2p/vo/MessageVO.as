package com.projectcocoon.p2p.vo
{
	
	[Bindable]
	public class MessageVO
	{
		
		public var client:ClientVO;
		public var data:String;
		public var destination:String;
		public var type:String;
		public var scope:String;
		public var command:String;
		
		public function MessageVO(_client:ClientVO=null, _data:String="", _destination:String="", _type:String="", _scope:String="", _command:String="")
		{
			client = _client;
			data = _data;
			destination = _destination;
			type = _type;
			scope = _scope;
			command = _command;
		}
		
	}
	
}