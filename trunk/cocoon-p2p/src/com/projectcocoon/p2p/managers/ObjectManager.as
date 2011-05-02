package com.projectcocoon.p2p.managers
{
	import com.projectcocoon.p2p.util.SerializationUtil;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;
	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	public class ObjectManager extends EventDispatcher
	{
		
		public static var CHUNKSIZE:uint = 64 * 1024; // 64KBytes
		
		private var groupManager:GroupManager;
		
		public function ObjectManager(groupManager:GroupManager)
		{
			this.groupManager = groupManager;
		}
		
		/**
		 * Start sharing an object
		 * @param value the Object to share (can be anything except null)
		 * @param defaultGroupName the name of the default NetGroup all peers initially get added to
		 * @param groupID the Group Address of the peer with whom this Object should be shared
		 */
		public function share(value:Object, defaultGroupName:String, groupID:String = null):void
		{
			if (!value)
				throw IllegalOperationError("value must not be null");
			
			var data:ByteArray = new SerializationUtil().serialize(value);
			var metadata:ObjectMetadataVO = getMetaData(data);
			
			// TODO: store data, create group for sharing, announce metadata on default group
			
		}
		
		private function getMetaData(data:ByteArray):ObjectMetadataVO
		{
			var metadata:ObjectMetadataVO = new ObjectMetadataVO();
			metadata.identifier = getOneAtATimeHash(data);
			metadata.size = data.length;
			metadata.chunks = getChunks(data);
			return metadata;
		}
		
		private function getChunks(data:ByteArray):uint
		{
			return Math.floor(data.length / CHUNKSIZE) + 1;
		}
		
		private function getOneAtATimeHash(key:ByteArray):String
		{
			var hash:int = 0;
			var b:int;
			key.position = 0;
			while (key.bytesAvailable > 0) 
			{
				b = key.readByte()
				hash += (b & 0xFF);
				hash += (hash << 10);
				hash ^= (hash >>> 6);
			}
			hash += (hash << 3);
			hash ^= (hash >>> 11);
			hash += (hash << 15);
			return hash.toString(16);
		}
		
	}
}