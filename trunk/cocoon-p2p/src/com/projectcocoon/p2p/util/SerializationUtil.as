package com.projectcocoon.p2p.util
{
	import flash.utils.ByteArray;

	public class SerializationUtil
	{
		
		public function serialize(object:Object):ByteArray
		{
			try
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.writeObject(object);
				byteArray.position = 0;
				return byteArray;
			}
			catch (e:Error)
			{
			}
			return null;
		}
		
		public function deserialize(bytes:ByteArray):Object
		{
			try
			{
				bytes.position = 0;
				return bytes.readObject();
			}
			catch (e:Error)
			{
			}
			return null;
		}
	}
}