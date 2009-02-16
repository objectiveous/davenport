---
layout: default
title: IDE Setup
section: hacking
---

This document explains how to get the Davenport source code installed and building on your Mac. 

Forewarning
===========
I'm relatively new to objective-c, Cocoa and Xcode. This means the more experienced among you may witness me doing something stupid. When this happens, please let me know. ;-)  **<objectiveous@gmail.com>**.


#Prerequisites

## CouchDB

Although Davenport comes with an embedded version of CouchDB, you'll want to have a standalone version of CouchDB installed. I highly recommend Jan Lehnardt's [CouchDBX](http://jan.prima.de/~jan/plok/archives/142-CouchDBX-Revival.html). The reason for having a standalone version are twofold: 

1. It improves Davenport's startup time. Useful when debugging. 
2. It'll simplify Davenport's build configuration and make it easier for you to get started hacking. 

## Git
Make sure you have **Git** installed. If you don't use MacPorts you might try [Git](http://code.google.com/p/git-osx-installer/). You might also try using a native Git GUI like [GitX]( http://gitx.frim.nl/). 

Getting The Source
==================
Davenport depends on four Frameworks not supplied by apple -- [BWToolkit](http://www.brandonwalkin.com/blog/2008/11/13/introducing-bwtoolkit/), [RBSplitView](http://www.brockerhoff.net/src/rbs.html), JSON, and CouchObjC. The first two frameworks are embedded, meaning they exit within the Davenport source code itself, while the later two do not. The reason the later two are not embedded is that the development of Davenport necessitated some API additions in CouchObjC. So, being a good little **Fork'er** it. You can find that project [here](http://github.com/objectiveous/couchobj/tree/master). 

In the end, this means you will need to clone two projects CouchObjC and Davenport. Here's how that's done:


{% highlight sh %}
price:/ robevans$ cd /projects
price:projects robevans$ git clone git://github.com/objectiveous/couchobj.git
price:projects robevans$ git clone git://github.com/objectiveous/davenport.git 

{% endhighlight %}

Building The Codebase
======================
Next, we'll perform a headless build xcodebuild. 

{% highlight sh %}

price:projects robevans$ xcodebuild build OBJROOT=build/ SYMROOT=build/
price:projects robevans$ davenport-checkout-public 
Initialized empty Git repository in /private/tmp/foo/couchobj/.git/
remote: Counting objects: 798, done.
remote: Compressing objects: 100% (373/373), done.
remote: Total 798 (delta 465), reused 615 (delta 352)
Receiving objects: 100% (798/798), 187.24 KiB | 94 KiB/s, done.
Resolving deltas: 100% (465/465), done.
Initialized empty Git repository in /private/tmp/foo/davenport/.git/
remote: Counting objects: 507, done.
remote: Compressing objects: 100% (413/413), done.
remote: Total 507 (delta 185), reused 250 (delta 69)
Receiving objects: 100% (507/507), 4.81 MiB | 86 KiB/s, done.
Resolving deltas: 100% (185/185), done.
2009-01-29 10:06:10.587 xcodebuild[4047:613] 
Unable to load platform at path /Developer/Platforms/Aspen.platform
=== BUILDING NATIVE TARGET JSON OF PROJECT JSON WITH THE DEFAULT CONFIGURATION (Release) ===


Checking Dependencies...

....

Touch /tmp/foo/davenport/build/Release/Davenport.app
    cd /tmp/foo/davenport
    /usr/bin/touch -c /tmp/foo/davenport/build/Release/Davenport.app
**BUILD SUCCEEDED**

{% endhighlight %}

Running Davenport
=================
Now that we've performed a build, let's run Davenport and see what it looks like. Be sure to have CouchDB running before proceeding.

{% highlight sh %}
price:projects robevans$ open ./davenport/build/Release/Davenport.app
{% endhighlight %}

Running Xcode
======================
Hopefully you've made it this far without any problems. 

Let's fire-up Xcode and have a look:
 
{% highlight sh %}
price:projects robevans$ open ./davenport/Davenport.xcodeproj/
{% endhighlight %}


Targets
========
There are two targets that are primary interest to the new Davenport hacker: 

1. Davenport
2. Davenport with Embedded CouchDB

The only difference between these two targets is that Davenport with Embedded CouchDB includes a Run Script that will copy the contents of CouchDBX into the Davenport build. In other words, it puts a version of CouchDB into build/Release/Davenport.app/Contents/Resources/CouchDb. 

![img](./images/targets.png)

# Running and Writing Tests
This is probably the most important section and... there's... no... content! 