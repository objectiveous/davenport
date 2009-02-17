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
/Library/Ruby/Gems/1.8/gems/rake-0.8.3/lib/rake.rb:992: warning: Insecure world writable dir /usr/local/spidermonkey in PATH, mode 040777
2009-02-16 20:26:13.945 xcodebuild[58745:613] Unable to load platform at path /Developer/Platforms/Aspen.platform
=== BUILDING NATIVE TARGET SVTestPlugin OF PROJECT Davenport WITH CONFIGURATION Release ===

Checking Dependencies...
** BUILD SUCCEEDED **
Applications
Preparing imaging engine…
Reading Driver Descriptor Map (DDM : 0)…
   (CRC32 $6331275F: Driver Descriptor Map (DDM : 0))
Reading Apple (Apple_partition_map : 1)…
   (CRC32 $AAF443FF: Apple (Apple_partition_map : 1))
Reading disk image (Apple_HFS : 2)…
..............................................................................................................
   (CRC32 $F6B17627: disk image (Apple_HFS : 2))
Reading  (Apple_Free : 3)…
...............................................................................................................
   (CRC32 $00000000:  (Apple_Free : 3))
Adding resources…
...............................................................................................................
Elapsed Time:  1.832s
File size: 2662918 bytes, Checksum: CRC32 $89B8842B
Sectors processed: 28594, 28577 compressed
Speed: 7.6Mbytes/sec
Savings: 81.8%
created: /Users/robevans/Projects/cocoa/davenport/appcast/build/davenport-0.1.dmg
price:davenport robevans$ 


{% endhighlight %}





Building 



