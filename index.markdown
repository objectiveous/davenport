---
layout: default
title: Davenport
section: intro
---

  
#Intro

Davenport is a Cocoa based hosting container for building **UI demanding** applications on top of **CouchDB**. The operative term here is UI demanding. If current web browsers provide you with a rich enough GUI model, then I would suggest simply looking at CouchDB's approach to [hosted applications](http://books.couchdb.org/relax/hosted-applications). 


### The Contribution Model

The host portion of davenport provides common services and standards, while plugins provide domain specific functionality. 

<a href="images/plugin-simple.png"><img src="images/plugin-simple.png" border="0" width="50%"/></a> 


In order to jump start development and learn sorts of services and resources a plugin might require, we started with a port of CouchDB's admin front end (Futon). The process looks some like this: 

1. Port Futon to Cocoa
2. Implement Simplest possible plugin (Todo List)
3. Migrate Futon bits into a proper plugin. 

Development as of Feb, 16 is focused on item #2. A formal protocol has been developed and the mechanics of plugin discover and loading are working. 

