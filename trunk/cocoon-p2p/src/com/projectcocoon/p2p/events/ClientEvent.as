package com.projectcocoon.p2p.events
{
	import com.projectcocoon.p2p.vo.ClientVO;
	
	import flash.events.Event;
	
	public class ClientEvent extends Event
	{
		
		public static const CLIENT_ADDED:String = "clientAdded";
		public static const CLIENT_UPDATE:String = "clientUpdate";
		public static const CLIENT_REMOVED:String = "clientRemoved";
		
		[Bindable] public var client:ClientVO;
		
		public function ClientEvent(type:String, data:ClientVO=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			client = data;
			super(type, bubbles, cancelable);
		}
		
	}
}