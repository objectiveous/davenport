#import <Cocoa/Cocoa.h>
#import "SVPathControl.h"

@interface SVBreadCrumbCell : NSPathComponentCell {
	SVPathControl	*pathControl;
	NSImage			*pathSeparatorImage;
    // isContent is used to distinguish between two types of path 
    // elements; those that represent content elements (things like documents)
    // and path elements that are strictly navigational. 
    // 
    // Content elements get poped off the path array before a new one can be added. 
    // The result of this decision is that there can only ever be one 
    // The default value is NO. 
    BOOL             isContent;
}

@property (assign) SVPathControl *pathControl;
@property BOOL isContent;

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
