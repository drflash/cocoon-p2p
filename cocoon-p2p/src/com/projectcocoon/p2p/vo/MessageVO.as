package com.projectcocoon.p2p.vo
{
	
	[Bindable]
	public class MessageVO
	{

		private static var SEQ:uint = 0;
		
		public var client:ClientVO;
		public var data:Object;
		public var destination:String;
		public var type:String;
		public var command:String;
		public var sequenceId:uint;
		public var timestamp:Date;
		
		public function MessageVO(client:ClientVO=null, data:Object=null, destination:String="", type:String="", command:String="")
		{
			this.client = client;
			this.data = data;
			this.destination = destination;
			this.type = type;
			this.command = command;
			timestamp = new Date();
			sequenceId = ++SEQ;
		}
		
		public function get isDirectMessage():Boolean
		{
			return (destination && destination != "") 
		}
		
		public function toString():String
		{
			return "MessageVO{client: " + client + ", data: " + data + ", destination: \"" + destination + "\", type: \"" + type + "\", command: \"" + command + "\", sequenceId: " + sequenceId + ", timestamp: " + timestamp + "}";
		}

	}
	
}