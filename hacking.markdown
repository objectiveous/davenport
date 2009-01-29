---
layout: default
title: Hacking Davenport
section: hacking
---


This document explains how to get the Davenport source code installed and building on your Mac. 

{% highlight bash %}
#!/bin/sh

# Clone the source 
git clone git://github.com/objectiveous/couchobj.git;
git clone git://github.com/objectiveous/davenport.git; 

# Move into the Davenport project
cd davenport; 

# Perform a headless build
xcodebuild build OBJROOT=build/ SYMROOT=build/

{% endhighlight %}

If that went well, fire-up xcode. 

{% highlight bash %}

price:davenport robevans$
price:davenport robevans$ open Davenport.xcodeproj/




{% endhighlight %}



