Work In Progress:
- Add Field. 
- Save document. 
- Create document. 
- Make version navigation work.
- Replace the Admin icon in the Toolbar. 
	Maybe change it to a couch. The log icon could be changed to an erlang icon.  
BACKLOG:
- @FinishingTouch Linkable Revisions
	The list of revisions shown in the Document view could have follow link that would fetch the revision. Probably not that useful as its the application domain that provides the revision sematics (revision date, meaning, etc) and not couch. In other words, couches revisions are really opaque.  
- Handle instances where a value exists for multiple keys. 
	label = [[parentObject allKeysForObject:item] lastObject];

- For some reason, the couch project is depending on a release version of JSON.
	trouble is that on initial checkout, that doesn't exist. Ideally the couch project would depend on a debug build of couch when build a debug version of couch and a release version when build a release version of couch.  
- Learn more about git and create a working branch to keep things safe. 
- Doc view needs to have working version options. 
- Function view needs to be able to save as, update, new. 
- We need proper icons for the toolbar
	will cocoa mask them. Turning on dim/bright versions?
- Document Tree fonts should be better. 
- Learn GDB
- Add Replication View
- Add compact database button
- Add Create/Delete Database Button
- research Keybindings
- Column headers ought to be a little taller. 
- Consider a new color for the inspector Document view
- Add a widget that will reveal the last URL used. 
	Might be nice to provide a visual description of the URL and have "links" 
	http://localhost:5984/test_suite_db/_all_docs
	      ^                              ^                        ^ 
	       Host                        Database        View
Notes, Clippings and Things Found:
I think the 'standard' way of swapping views is to place them both 
into a tabless NSTabView, then switch the current tab 
programmatically. In your case, the tabview would be the subview of 
your splitview, and the custom view and table view would be tabs in 
the tabview.

First, when implementing my window, I'd follow the standard Cocoa pattern of having a custom NSWindowController subclass to manage my window. This window controller will have an outlet connected to each of the views in the window, and will also wind up with a private accessor method — used only within the class and any subclasses, and in testing — for getting the value of each of its outlets. This design flows naturally from the test which I would write to specify that the window should contain a button. First, here's the skeleton into which I'd put tests: 
If you want your controls to act like they're part of the text (automatically moving when you add text, etc.) then you should investigate NSTextAttachment. You will probably need to create a custom NSTextAttachmentCell, but it will be able to mostly pass things through to an internal NSCell, so it probably won't be a huge amount of work.

http://mattgemmell.com/source

Fixing one of the split panes - http://www.cocoabuilder.com/archive/message/cocoa/2008/12/8/224746

NSTreeNode

Not a feature of the ObjC language, but certainly a nice addition to help using NSTreeController. NSTreeNode is a wrapper object which aids in creating trees. Just create a NSTreeNode and add other NSTreeNode objects to the -mutableChildNodes array and you are on your way to a tree. Binding this tree to a NSTreeController is relatively simple as well. Of note, remember that if you are using NSOutlineView delegate methods, you receive a NSTreeNode object now, so you must use -representedObject on “id item”.

A further note, when using the “selection” controller key on a NSTreeController, the controller returns an array of NSTreeControllerProxyObjects. Either call -self on the NSTreeControllerProxyObject or when using bindings (binding a second NSTreeController to the “selection” of the first one) remember to use “selection” with model key path of “self”. I don’t believe this is documented anywhere, but using “self” clears up a whole world of heartache and gives you the actual NSTreeNode instead of the NSTreeControllerProxyObject.


TRS  - Basic
Com. 64 - Basic , Forth
Atari 400 -Basic 
Atari 800 - Basic
Pascal
Mac - Hypercard, 
Amiga
Windows 98 - VB
Javascript
Perl 
Java
Ruby
Objective-c
	

Decisions:
The UI is the most important aspect of the application. 
Leave the information model to other people. 


Questions:
- What would it take to make the application self hosting? 
	This is probably the most important milestone as there is no better way to know if the design is working than to use the application on a daily basis. Doing this would mean putiing off the couchDb work initially. 
- Can we TDD the text manipulation stuff using the goolgle toolkit? 
- One of the text examples from apple uses CoreData.... Why and should we? 
- Is there an objective-c Column Store 
- Can I use Core data w/ CouchDb? 
- Would it make sense to start this work from unit tests to flush out the data model? Then add in GUI Bits? Maybe defer the UI until the Model is worked out? 
- Could MacFuse be used to simplfy things? Probably not but its worth looking at. 
	Cocoa Questions:
	- How do I create a bullet?
	- How do I draw a horizontal rule? 
	- How would I create Tabbed pages?
	- What is a first-responder?
	- What does NSTextView want and how do we couchDb to play along? 

Archive:
- Add version number to Document view @done @project(Work In Progress)
- SBCouchDB ought to use OrderedDictionary @done  @project(Work In Progress)
- 2009-01-25 12:50:00.972 stigmergic[13957:10b] *** -[SBCouchDocument keyAtIndex:]: unrecognized selector sent to instance 0x20268d0 @done @project(Work In Progress)
- Version numbers ought to be correct.  @done @project(Work In Progress)
- View past versions @done @project(Work In Progress)
- API - get:docID withRevisions:True  @done @project(Work In Progress)
- Create an actual CouchDocument.  @done @project(Work In Progress)
- _id and _rev ought to be the first two properties we see.  @done @project(Work In Progress)
- Inspector resizing seems to be hoarked @done @project(Work In Progress)
	- Read about layout sizing.  @done
- Debug logging should have a simple facility and a larger message.  @done @project(Work In Progress)
- Update SourceList view to have new look @done @project(BACKLOG)
- @packaging problem with permissions that are preventing erlang from starting up properly.  @done @project(Work In Progress)
- Non feature : Package up properly so it runs on vincent.  @done @project(Work In Progress)
- Give the app an icon. @activeTask @done @project(Work In Progress)
- Inspector should depcit the document contents in a table. Somtimes values will need to be treeviews. This could be a challenge.  @done @project(Work In Progress)
- Rework the debug logs so that we can more easily turn tracing on and off for a specific class. log4cocoa maybe?  @done @project(Work In Progress)
- Bread crumb should display the key of the selected table view item.  @done @project(Work In Progress)
- Wire up the inspector to the bottom of the split view.  @done @project(Work In Progress)
- Write an integration tests that will populate a test databse with several hundreds of documents. Then write some test code to paginate over these a couple hunderered at a time. Then integrate this code into the QueryResultController.  @done @project(Work In Progress)
- Need to wait a little before trying to fetch data other wise we are in too tight a loop and this is causing threading issues. I think... @done @project(Work In Progress)
- Checkout using TreeController to manage the dataGrid @done @project(Work In Progress)
- Workflow Feature - user clicks on database and gets a view of all data. @done @project(Work In Progress)

- Package erlang with the application just like the couchDB startup UI does.   @done @project(Work In Progress)




- Create Mockup for breadcrumbs using NSMatrix. Probablly should use a seperate project.  @done @project(Work In Progress)
- Display a Database Admin view.  @done @project(Work In Progress)
	- show simple fetching  @done
	- select views, etc..  @done
- Which couchDb libraries should we use? @done @project(Questions)
- catch selection events from the source Tree @done @project(Work In Progress)
- design the database view.  @done @project(Work In Progress)
- Fetch actual server info using the operation.  @done @project(Work In Progress)
	- Need to update the callback so that we can unit test operations.  @done
- create a controller for the main window @done @project(Work In Progress)
- Figure out how the data should be loaded. It needs to be done on a thread to prevent the UI from blocking.  @done @project(Work In Progress)
- Create a simple <NSOutlineViewDataSource> object that provides a hardcoded dataset to our OutlineView @done @project(Work In Progress)
- Get the OutlineView to look right.  @done @project(Work In Progress)

- Read docs. Digest information, think. @activeTask @done @project(Work In Progress)
- Create a new application that does not use the document architecture. See if we can retro fit the existing application.  @done @project(Work In Progress)

- I need to understand the document architecture better.  @done @project(Work In Progress)
	The document style of application is used for apps that can open documents on the disk. My app, being web based, should not use this style but instead have a sinlge window userinterface and the appropriate cocoa architecture. 
- NSWindowController -- How is this used exactly?  @done @project(Work In Progress)
- Setup the environment so that we can write some unit tests as we're learning how the Cocoa Text system actually works. We're gonna want to write a lot of little pieces of "spike code." @done @project(Work In Progress)
- How does the web inspector work? Could we writing something that embedds into safari?  @done @project(BACKLOG)
- NSDocument is one of the triad of Application Kit classes that establish an architectural basis for document-based applications (the others being NSDocumentController and NSWindowController). @done @project(BACKLOG)
