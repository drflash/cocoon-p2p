package com.projectcocoon.p2p.events
{
	import flash.events.Event;
	
	public class ObjectEvent extends Event
	{
		public function ObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}