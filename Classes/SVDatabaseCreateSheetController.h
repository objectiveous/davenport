

#import <Cocoa/Cocoa.h>

@class SVMainWindowController;

@interface SVDatabaseCreateSheetController : NSWindowController
{
@private
	BOOL					 cancelled;
//	NSMutableDictionary     *savedFields;	
	IBOutlet NSButton       *doneButton;
	IBOutlet NSButton       *cancelButton;
	IBOutlet NSForm         *editForm;
}

@property (assign)            BOOL                 cancelled;
//@property (retain)            NSMutableDictionary *savedFields;
@property (nonatomic, retain) NSButton            *doneButton;
@property (nonatomic, retain) NSButton            *cancelButton;
@property (nonatomic, retain) NSForm              *editForm;

- (NSString*)edit:(NSDictionary*)startingValues from:(SVMainWindowController*)sender;
- (BOOL)wasCancelled;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
