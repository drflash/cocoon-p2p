# Using Cocoon P2P in non-Flex / pure-AS3 projects #

As of version 0.82 Cocoon P2P can also be used in non-Flex projects (e.g. AS3 Projects in Flash Builder, Flash Projects in Flash CS 5, AS3 Projects in FDT, etc.).

To use the non-Flex (pure AS3) version make sure to [download the correct SWC](WhichOneIsTheCorrectVersion.md) or set the correct compiler flags when [compiling from source](BuildFromSource.md).

Some key differences / important things:

  * in the AS3 version the properties _clients_, _sharedObjects_ and _receivedObjects_ of the LocalNetworkDiscovery class are **typed Vectors**
  * in the Flex version the properties _clients_, _sharedObjects_ and _receivedObjects_ of the LocalNetworkDiscovery class are **ArrayCollections**
  * the AS3 version can be used in Flex as well (of course), but it **does not support Data Binding**

An example AS3 project (ZIP file) is available in the [downloads section](http://code.google.com/p/cocoon-p2p/downloads/list)



## Source code ##

```
// AS3 example
channel = new LocalNetworkDiscovery();
channel.clientName = "MyName";
channel.addEventListener(ClientEvent.CLIENT_ADDED, onClientAdded);
channel.addEventListener(ClientEvent.CLIENT_UPDATE, onClientUpdate);
channel.addEventListener(ClientEvent.CLIENT_REMOVED, onClientRemoved);
channel.addEventListener(MessageEvent.DATA_RECEIVED, onDataReceived);
channel.connect();
```