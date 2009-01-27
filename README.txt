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
