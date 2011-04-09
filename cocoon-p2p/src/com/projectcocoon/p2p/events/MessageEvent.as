package com.projectcocoon.p2p.events
{
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MessageVO;
	
	import flash.events.Event;
	
	public class MessageEvent extends Event
	{
		
		public static const DATA_RECEIVED:String = "dataReceived";
		
		[Bindable] public var message:MessageVO;
		
		public function MessageEvent(type:String, data:MessageVO=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			message = data;
			super(type, bubbles, cancelable);
		}
		
	}
}