---
layout: default
title: Logging and Tracing
section: hacking
---

## Logging 
<a href="images/logging/console.png"><img src="images/logging/console.png" border="0" width="30%" align="right"/></a>

### Overview 

Davenport uses the Apple System Logging (ASL) for logging. [Peter Hosey](http://boredzo.org/blog/archives/2008-01-19/next-week-apple-system-logger) has written quit a bit about how to use ASL and he writes in a very practical way that makes the system easy to understand. With that said, I'm not going to spend much time on the what and why-fors of ASL. 



### Turning On Logging

Much of Davenports logging is set to DEBUG, so the very first thing one needs to do is make sure that your filters are setup properly. I use a little script that does the following: 

{% highlight sh %}
#!/bin/sh
#set the master filter level
sudo syslog -c 0 -d

#default data store
sudo syslog -c syslog -d


{% endhighlight %}


### Viewing Log Messages

Viewing log messages is as simple as running Console.app but you might only be interested in a subset of messages. Console.app allows you to filter messages using its query mechanism. Remember, under the hood ASL is a database, not just a flat file. Here's an example of what a query might look like: 

<a href="images/logging/logging-query.png"><img src="images/logging/logging-query.png" border="0" width="30%"/></a>





