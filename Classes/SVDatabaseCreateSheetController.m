
#import "SVDatabaseCreateSheetController.h"
#import "DPResourceFactory.h"
#import "SVMainWindowController.h"

@implementation SVDatabaseCreateSheetController

@synthesize cancelled;
//@synthesize savedFields;	
@synthesize doneButton;
@synthesize cancelButton;
@synthesize editForm;

- (id)init{
	self = [super init];
	return self;
}


- (NSString*)windowNibName{
	return @"CreateDatabasePanel";
}

- (void)dealloc{
	[super dealloc];
//	self.savedFields release];
}

- (NSString*)edit:(NSDictionary*)startingValues from:(SVMainWindowController*)sender{
	NSWindow* window = [self window];
	cancelled = NO;

	[NSApp beginSheet:window modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[NSApp runModalForWindow:window];

	[NSApp endSheet:window];
	[window orderOut:self];
    // Return the value of our one and only form field. 
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