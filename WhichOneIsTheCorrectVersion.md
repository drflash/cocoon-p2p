# Which SWC file should I download? #

Starting with version 0.82 Cocoon P2P is available in two versions: the "classic" version which is compatible with the Flex SDK and a "pure AS3" version which works in non-Flex projects.

Just look at the filename:

  * CocoonP2P-x.y.z.swc --> that's the "classic" Flex compatible version
  * CocoonP2P-x.y.z-as3.swc --> that's the "pure AS3" version

Some key differences / important things:

  * in the AS3 version the properties _clients_, _sharedObjects_ and _receivedObjects_ of the LocalNetworkDiscovery class are **typed Vectors**
  * in the Flex version the properties _clients_, _sharedObjects_ and _receivedObjects_ of the LocalNetworkDiscovery class are **ArrayCollections**
  * the AS3 version can be used in Flex as well (of course), but it **does not support Data Binding**

<br><br>
