---
layout: default
title: Davenport Contribution Model
section: hacking
---

# Plugin Motivation 

In keeping with Davenport's goal of being a framework for creating UI demanding and domain specific applications using CouchDB, an extension mechanism of some sort was needed. There any number of ways that this requirement could have been met but our current thinking is to take a traditional host/plugin approach. In our case, Davenport will fulfill the role of host -- providing core capabilities -- and plugins will contribute additional (domain specific) functionality.

## What Kind of Apps?

When you read the words "domain specific" you might have wondered exactly what was meant. Let's try to make this more concrete by starting with some background. If you are already familiar with CouchDB you may want to skip to the next section.

Let's start with a general description of CouchDB. Here's how the CouchDB developers describe it:    

>Apache CouchDB is a **distributed**, fault-tolerant and **schema-free document-oriented database** accessible via a **RESTful HTTP/JSON API**. Among other features, it provides robust, incremental replication with bi-directional conflict detection and resolution, and is queryable and indexable using a table-oriented view engine with JavaScript acting as the default view definition language.

>CouchDB is written in Erlang, but can be easily accessed from any environment that provides means to make HTTP requests. There are a multitude of third-party client libraries that make this even easier for a variety of programming languages and environments.

Three terms have been highlighted as they play a large factor in the goals of Davenport: 

1. Distributed
2. Schema-free document-oriented database
3. RESTful HTTP/JSON API

Translated into human terms, this list might read: 

1. I want to own my stuff
2. I want my stuff to be flexible 
3. I want the option to share my stuff 


# Davenport's Plugin Model

Okay, enough with the foreplay. Here's how the plugin model model works. 

Daven port is taking a [formal protocol](http://developer.apple.com/documentation/Cocoa/Conceptual/LoadingCode/Tasks/UsingPlugins.html#//apple_ref/doc/uid/20001276) approach at the moment. Plugins are expected to reside in ~/Application Support/Davenport/Plugins and for testing and design purposes, a test plugin is included in the Davenport source code. 

# Plugin Example

The best way to understand the contribution/plugin machinery is with a working example which you can find in the [treenode-experiment](http://github.com/objectiveous/davenport/tree/treenode-experiment) branch. The following sections will walk you through the important bits of the build targets. 

## In a nutshell

The Davenport target builds the Davenport host and includes the SVTestPlugin. It also installs the SVTestPlugin into ~/Application Support/Davenport/Plugins. 

The Integration Tests target is used to for testing the result of the Davenport build by way of code injection. To learn more about that, head on over to Chris Hanson's [blog](http://chanson.livejournal.com/tag/unit+testing)


 <a href="images/build-targets.png"><img src="images/build-targets.png" border="0" width="50%"/></a> 

# The Mighty Two 

There are two primary build targets ***Davenport* and **Davenport with Embedded CouchDB** the former is used for development and testing while the later is intended for release builds. As the name implies the later of these two includes a version of CouchDB (and Erlang). It's not typically used for development due to the CouchDB's startup time. 
 
So, green bullet #1 is where all the action takes place. You'll notice in the graphic that there are two non folder'ish items within the build target. Both of these items are configured within the target like so (click on the image to zoom in): 

<a href="images/target-config.png"><img src="images/target-config.png" border="0" width="30%"/></a> 

## SVTestPlugin 

This is the test plugin mentioned earlier. As you can see by looking at the following image, there's not much to it at the moment. 

![Target Plugin](images/target-plugin.png)

## CouchObjC (from CouchObjC.xcodeproj)

This an embedded project that supplies the objective-c API to CouchDB. It's embedded in this way as we are making enhancements to that code base as Davenport evolves. 


![Target CouchObjc](images/target-couchObjc.png)