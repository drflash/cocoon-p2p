The Cocoon P2P library allows you to easily set up device discovery and communication with different devices on the local network (LAN/WLAN).

With Cocoon P2P you can use you're mobile device as the controller for a game being played on your PC or create application that span across several screens and devices.

Cocoon P2P supports messaging, object-replication, video and accelerometer data.

**Requirements:** Flash Player 10.1 or later or AIR 2.0 or later for desktop, mobile (Android, iOS, PlayBook) and TVs.

| Beta version online now, including support for device discovery, messaging, object-replication and accelerometer - video streaming will be available soon |
|:----------------------------------------------------------------------------------------------------------------------------------------------------------|

Cocoon P2P is pretty easy to use - for sample code check the [Wiki](http://code.google.com/p/cocoon-p2p/w/list) pages and the [Downloads](http://code.google.com/p/cocoon-p2p/downloads) section.

If you're not sure which version to download check [this page](WhichOneIsTheCorrectVersion.md).



| <a href='http://www.youtube.com/watch?feature=player_embedded&v=F4I5871lJl4' target='_blank'><img src='http://img.youtube.com/vi/F4I5871lJl4/0.jpg' width='425' height=344 /></a> | <a href='http://www.youtube.com/watch?feature=player_embedded&v=sXKVblg-x5I' target='_blank'><img src='http://img.youtube.com/vi/sXKVblg-x5I/0.jpg' width='425' height=344 /></a> |
|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

_video clips recorded at Adobe MAX 2010, courtesy of hebiflux.com_

### Device discovery ###

```
<p2p:LocalNetworkDiscovery id="channel" clientName="My device" />

<s:List dataProvider="{channel.clients}" labelField="clientName" />
```

### Messaging ###

```
<p2p:LocalNetworkDiscovery id="channel" 
     clientAdded="onClientAdded(event)" 
     clientUpdated="onClientUpdated(event)" 
     clientRemoved="onClientRemoved(event)"
     dataReceived="onDataReceived(event)"
     loopback="true" />
```

### Accelerometer ###

```
<p2p:LocalNetworkDiscovery id="channel" 
     accelerometerInterval="1000"
     accelerometerUpdate="onAccelerometer(event)" />
```

### Object replication ###

```
<p2p:LocalNetworkDiscovery id="channel" 
     objectComplete="onFileComplete(event)" />
```

### Video streaming  _(support coming soon)_ ###

```
<p2p:LocalNetworkDiscovery id="channel" 
     videoStream="{cam}" />
```