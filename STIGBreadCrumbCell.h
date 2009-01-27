#import <Cocoa/Cocoa.h>
#import "STIGPathControl.h"

@interface STIGBreadCrumbCell : NSPathComponentCell {
	STIGPathControl	*pathControl;
	NSImage			*pathSeparatorImage;	
}

@property (assign) STIGPathControl *pathControl;

- (BOOL) isFirstPathComponent;
- (BOOL) isLastPathComponent;
- (BOOL) isOnlyPathComponent;
- (NSRect) deriveFinalDividerRect:(NSRect) cellFrame;
//- (double) offsetStart;
- (NSDictionary *) attributesForTitle;
- (NSFont *) usedFont;
- (NSRect) derivePathLabelRect:(NSRect) cellFrame;
- (id) initWithPathLabel:(NSString *)label;

@end
