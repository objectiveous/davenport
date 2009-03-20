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
- (NSString*)edit:(NSDictionary*)startingValues from:(NSWindowController*)sender{
	NSWindow* window = [self window];
	cancelled = NO;
    
    // XXX This is a sick hack and should be replaced with something based on a 
    //     convention. 
 
    
	[NSApp beginSheet:window modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[NSApp runModalForWindow:window];
    
	[NSApp endSheet:window];
	[window orderOut:self];

    // XXX Obviously this will change but first we have to get the panel to display properly. 
	return [[[editForm cells] objectAtIndex:0] stringValue];
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
