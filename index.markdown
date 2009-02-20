---
layout: default
title: Davenport
section: intro
---


<a href="images/davenport-architecture-1.png"><img src="images/davenport-architecture-1.png" border="0" width="40%" align="right"/></a> 

#Intro 

Davenport is a plugin container for building native Mac OS X applications that take advantage of **CouchDB**. Davenport provides a UI shell and a set of Services so that you can focus on developing your collaborative application. Davenport currently includes two plugins: 

1. CouchDB Admin (a port of Futon)
2. Simple task tracker

More information on these plugins can be found on the [Plugins](./plugins.html) page. 

## Origins
Davenport came to be, like many software projects, while attempting to solve an entirely different problem. You can learn more about the motivation for Davenport and, more importantly, where the project is headed [here](./history.html). 


<hr/>
# How Davenport Works

Davenport provides Cocoa developers with a basic application shell and a contribution model which enables UI additions to be made to three distinct areas of the user interface:

1. The left-hand nav
2. The body area
3. The detail area

<a href="images/plugin-simple.png"><img src="images/plugin-simple.png" border="0" width="30%" align="right"/></a> 

For example, let's say you want to build a task tracking application. Using Davenport you'd simply implement the `<DPContributionPlugin>` protocol, package your plugin and copy it into ~/Library/Application Support/Davenport/. 

An example plugin can be found in the [source code](http://github.com/objectiveous/davenport) and more information about the Plugin API can be found [here](http://localhost:4000/contributions.html).


# How to Get Involved

Grab the source from gitub and start talking. I'm more than happy to incorporate [feedback](http://objectiveous.lighthouseapp.com/projects/24460-davenport/tickets?q=all).

Davenport is being developed by a single developer... Err, wait. I'm married, although my wife does call Davenport **The Mistress**. Note to self: Get some help before you end up single. 

In any event, my name is Robert Evans. I'm a US citizen living in Buenos Aires, Argentina. Long story. Email me. ;-)



