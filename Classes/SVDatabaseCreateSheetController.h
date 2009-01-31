

#import <Cocoa/Cocoa.h>

@class SVMainWindowController;

@interface SVDatabaseCreateSheetController : NSWindowController
{
@private
	BOOL					cancelled;
	NSMutableDictionary*	savedFields;
	
	IBOutlet NSButton*		doneButton;
	IBOutlet NSButton*		cancelButton;
	IBOutlet NSForm*		editForm;
}

- (NSString*)edit:(NSDictionary*)startingValues from:(SVMainWindowController*)sender;
- (BOOL)wasCancelled;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
