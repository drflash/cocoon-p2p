# Frequently Asked Questions #
<br />
## Message delivery seems sloooow. I thought P2P should be fast? ##

The underlying architecture of Cocoon P2P (i.e. the RTMFP protocol which is actually using IP Multicast and the UDP network protocol) is actually pretty fast.

Factors that can slow down things is the local LAN infrastructure (routers, switches, etc.) and how these devices handle IP Multicast.

If e.g. your routers do not allow any IP Multicast (which is the case in some corporate environments) then RTMFP falls back to "Application Level Multicast" which is more expensive in terms of performance. So maybe that's the reason why you experience a lot of lag - difficult to say, you may need to experiment a bit.
<br />
## Can I use Cocoon P2P with Adobe's Flash Media Server? ##

Absolutely. RTMFP is available in the Enterprise and Interactive Editions of Flash Media Server. To use FMS just set the url accordingly, e.g.
```
<p2p:LocalNetworkDiscovery url="rtmfp://fms.server/appName">
```
<br />

## I get the "1046 - Type was not found or was not a compile-time constant: NetGroup" compile error ##

Cocoon P2P uses RTMFP Groups which were introduced in Flash Player 10.1 - thus, when using Cocoon P2P you need to target the Flash Player 10.1 API. Just add `-target-player 10.1.0` to the compiler arguments and you should be fine.
<br />
## How do I do x and y? ##
Hmm - maybe you want to discuss this on the [Cocoon P2P mailing list](http://groups.google.com/group/cocoon-p2p)?
<br />
## I've got a feature request / I found a bug ##
Head over to the [issues](http://code.google.com/p/cocoon-p2p/issues/list) section and log it there. Also, you may want to talk to us directly on the [Cocoon P2P mailing list](http://groups.google.com/group/cocoon-p2p).
<br />
