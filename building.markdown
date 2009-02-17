---
layout: default
title: Building Davenport
section: hacking
---

# Overview

<a href="images/builds/targets.png"><img src="images/builds/targets.png" border="0" width="30%" align="right"/></a>

In addition to the Xcode build targets, release builds can take advantage of Dr. Nic's [choctop](http://drnic.github.com/choctop/) . 


## DMG Generation 

To generate a new DMG, run:

{% highlight sh %}

price:davenport robevans$ rake dmg
(in /Users/robevans/Projects/cocoa/davenport)
=== BUILDING NATIVE TARGET SVTestPlugin OF PROJECT Davenport WITH CONFIGURATION Release ===

Checking Dependencies...
** BUILD SUCCEEDED **
Applications
Preparing imaging engine
Reading Driver Descriptor Map (DDM : 0)
   (CRC32 $6331275F: Driver Descriptor Map (DDM : 0))
Reading Apple (Apple_partition_map : 1)
   (CRC32 $AAF443FF: Apple (Apple_partition_map : 1))
Reading disk image (Apple_HFS : 2)
..............................................................................................................
   (CRC32 $58EF5B15: disk image (Apple_HFS : 2))
Reading  (Apple_Free : 3)
...............................................................................................................
   (CRC32 $00000000:  (Apple_Free : 3))
Adding resources
...............................................................................................................
Elapsed Time:  2.669s
File size: 2226259 bytes, Checksum: CRC32 $25461E71
Sectors processed: 28594, 28577 compressed
Speed: 5.2Mbytes/sec
Savings: 84.8%
created: /Users/robevans/Projects/cocoa/davenport/appcast/build/davenport-0.1.dmg

{% endhighlight %}




