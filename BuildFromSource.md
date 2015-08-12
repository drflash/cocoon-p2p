# Building Cocoon P2P from source #

The easiest way to build Cocoon P2P from source is to check out the project from [SVN](http://code.google.com/p/cocoon-p2p/source/checkout), import it as a library project into Flash Builder and compile it there. Compilation should also work fine in other tools or directly on the command line using mxmlc.

Key parameters:
  * latest release SWC was created using Flash Builder 4.5.1 and Flex SDK 4.1 (Build 16076)
  * minimum target is Flash Player 10.1
  * you may want to choose to include the manifest.xml file in the SWC

**Note:** Starting with version 0.8.2 you have to use [conditional compilation](http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf69084-7abd.html) to create the target SWC file. Depending on whether you want to use the Flex-compatible version (with ArrayCollections and Data Binding support) or you prefer to use Cocoon P2P in pure AS3, you have to set additional compiler flags.

For Flex-compatible build
```
-define CONFIG::FLEX true -define CONFIG::AS3 false -target-player 10.1.0
```

For pure-AS3 build
```
-define CONFIG::FLEX false -define CONFIG::AS3 true -target-player 10.1.0
```

