//
//  SVSaveViewAsSheetController.m
//  Davenport
//
//  Created by Robert Evans on 3/19/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVSaveViewAsSheetController.h"
#import "SVAppDelegate.h"

@implementation SVSaveViewAsSheetController

- (id)init{
	self = [super init];
	return self;
}
- (NSString*)windowNibName{
	return @"SaveViewAsPanel";
}

- (void)dealloc{
	[super dealloc];
	[savedFields release];
}

// XXX Should sender be a more generic type?
- (void)edit:(NSMutableDictionary*)newViewDictionary from:(NSWindowController*)sender{
	NSWindow* window = [self window];
	cancelled = NO;
    
    //[editForm insertEntry:@"XXXXXXXX" atIndex:0];
    //[editForm insertEntry:@"XXXXXXXX" atIndex:1];
    
    [[editForm cellAtIndex:0] setStringValue:[newViewDictionary objectForKey:@"designName"]];
    [[editForm cellAtIndex:1] setStringValue:[newViewDictionary objectForKey:@"viewName"]];    
    
    // XXX This is a sick hack and should be replaced with something based on a convention. 

	[NSApp beginSheet:window modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[NSApp runModalForWindow:window];
    
	[NSApp endSheet:window];
	[window orderOut:self];

    // XXX Obviously this will change but first we have to get the panel to display properly. 
    NSString *designName = [[[editForm cells] objectAtIndex:0] stringValue];
    NSString *viewName = [[[editForm cells] objectAtIndex:1] stringValue];
     
    [newViewDictionary setObject:viewName forKey:@"viewName"];
    [newViewDictionary setObject:designName forKey:@"designName"];    
}

- (IBAction)done:(id)sender{
	NSArray* editFields = [editForm cells];
	if ([[[editFields objectAtIndex:0] stringValue] length] == 0){
		NSBeep();
		return;
	}
	
	[NSApp stopModal];
}

- (IBAction)cancel:(id)sender{
	[NSApp stopModal];
	cancelled = YES;
}

- (BOOL)wasCancelled{
	return cancelled;
}

@end
