---
layout: default
title: History
section: intro
---



#What

<a href="images/davenport-architecture-1.png"><img src="images/davenport-architecture-1.png" border="0" width="50%" align="right"/></a> 

Davenport is a plugin container for building **UI demanding** applications on top of **CouchDB** for **Mac OS X**.

# Why

Davenport port was started, like many software projects, while attempting to solve an entirely different problem. Let's call that initial project, Project X. Project X -- a collaborative information-management application -- had some interesting constraints and requirements. Here are three of the forces that helped inspire Davenport:  

1. A wildly rich **information model**. 
2. **Expert users** would spend **all day** in the application.
3. Work products were **created collaboratively** in adhoc groups.


### Modeling is hard. 

Rich information models are damn hard and I knew we (there was a we once) couldn't get it right **ex-ante**. In other words, I knew we'd learn what we really needed to know *while* developing Project X. The problem was that current database/language integration would make it difficult to rapidly incorporate our "just in time" learning. And that the technical and design debt would catch up with us in short order. Why? Schema changes. Each new piece of learning required -- at a minimum -- a database schema change, model change, mapping layer change and a UI change. Throw on top of that - unit and system tests, rebuild and redeployment and pretty soon people would become averse to learning and evolving our product as the cost of change would be to high. 

*Your models are always wrong*

### And you want me to live in this thing? 
<img src="images/tools.gif" border="0" width="20%" align="right"/>
We had some really extraordinary users -- very bright people -- and they'd be spending all day in our application. 
Now, as someone who spends much of his day in an IDE, I knew what these folks would be expecting in terms of responsiveness and quality. They were going to be living in this tool and no one wants to live in a dump. 

In our determination, standard web technology just didn't cut it for these sorts of applications. Hopefully this will change but it there's another nagging issue...


*Do you really want to spend your life with bad tools?*

### That's Mine, Dammit. 

Information created in Project X belonged to the user -- not to the Corporation, not to Google, not to the State, and not to Daddy. The user owned it, and that meant it had to live on systems that the user controlled.

Control is a funny thing and people don't typically think much of it when selecting software. This will change. 

*Your business is Big Business* 

### They're my friends, not yours. 

Work products were created collaboratively, which is to be expected these days, but Project X required that we supported adhoc social networks **and** privacy. The replication (or sharing) of work products had to be such that users had control of who saw what information. 

*Your social network is your own.*
