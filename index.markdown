---
layout: default
title: Davenport
section: intro
---


#What

<a href="images/davenport-architecture-1.png"><img src="images/davenport-architecture-1.png" border="0" width="50%" align="right"/></a> 

Davenport is a Cocoa-based hosting container for building **UI demanding** applications on top of **CouchDB**. If the current state of web browsers provides you with a rich enough GUI, then consider looking at CouchDB's approach to [hosted applications](http://books.couchdb.org/relax/hosted-applications). 

# Why

Davenport port was started, like many software projects, while attempting to solve an entirely different problem. Let's call that initial project, Project X. Project X -- a collaborative information-creation application -- had some interesting constraints and requirements. Here are three forces that inspired Davenport:  

1. A wildly rich **information model**. 
2. **Expert users** would spend **all day** in the application.
3. Work products were **created collaboratively** in adhoc groups.


### Modeling is hard. 

Rich information models are damn hard and I knew we (there was a we once) couldn't get it right **ex-ante**. In other words, I knew we would learn what we really needed to know *while* developing Project X. The problem was that current database/language integration would make it difficult to rapidly incorporate our "just in time" learning. Why? Schema changes. Each new piece of learning required -- at a minimum -- a database schema change, model change, mapping layer change and a UI change. Throw on top of that - unit and system tests, rebuild and redeployment. 

### And you want me to live in this thing? 

Our users would spend all day in Project X much the way a developer spends much of her day in an IDE, or a graphic designer in his tool of choice. The point is, that browser technology just doesn't cut it for these sorts of applications. 

### That's Mine, Dammit. 

Information created in Project X belonged to the user. Not to the Corporation, not to Google, not to the State, not to Daddy. The user owned it, and that meant it had to live on systems they had control of.

### They're my friends, not yours. 

Work products were created collaboratively, which is to be expected these days, but Project X required that we supported adhoc social networks **and** privacy. The replication (or sharing) of work products had to be such that users had control of who saw what information. 

Your business is Big Business. Your social network is your own.

# Who

Davenport is being developed by a single developer... Err, wait. I'm married, although my wife does call Davenport **The Mistress**. Note to self: Get some help before you end up single. 

In any event, my name is Robert Evans. I'm a US citizen living in Buenos Aires, Argentina. Long story. Email me. ;-)  



