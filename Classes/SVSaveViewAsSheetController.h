//
//  SVSaveViewAsSheetController.h
//  Davenport
//
//  Created by Robert Evans on 3/19/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SVMainWindowController;

@interface SVSaveViewAsSheetController : NSWindowController {
	BOOL					cancelled;
	NSMutableDictionary*	savedFields;
	
	IBOutlet NSButton*		doneButton;
	IBOutlet NSButton*		cancelButton;
	IBOutlet NSForm*		editForm;
}

- (NSString*)edit:(NSDictionary*)startingValues from:(NSWindowController*)sender;
- (BOOL)wasCancelled;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
@end
