#import <Cocoa/Cocoa.h>
#import "SVPathControl.h"

@interface SVBreadCrumbCell : NSPathComponentCell {
	SVPathControl	*pathControl;
	NSImage			*pathSeparatorImage;	
}

@property (assign) SVPathControl *pathControl;

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
