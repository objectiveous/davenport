#import <Cocoa/Cocoa.h>
//#import "STIGBreadCrumbCell.h"

@class SVBreadCrumbCell;

@interface SVPathControl : NSPathControl {

}

-(void)addPathElement:(SVBreadCrumbCell*)pathCell;
-(void)addPathElementUsingString:(NSString*)pathLabel;
-(void)removeLastElement;
@end