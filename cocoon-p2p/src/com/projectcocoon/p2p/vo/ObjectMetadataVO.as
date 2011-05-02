package com.projectcocoon.p2p.vo
{
	public class ObjectMetadataVO
	{
		public var identifier:String;
		public var size:uint;
		public var chunks:uint;
		public var info:Object;
		
		public function ObjectMetadataVO(identifier:String = null, size:uint = 0, chunks:uint = 0, info:Object = null)
		{
			this.identifier = identifier;
			this.size = size;
			this.chunks = chunks;
			this.info = info;
		}
	}
}