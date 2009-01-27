#import <Cocoa/Cocoa.h>
//#import "STIGBreadCrumbCell.h"

@class STIGBreadCrumbCell;

@interface STIGPathControl : NSPathControl {

}

-(void)addPathElement:(STIGBreadCrumbCell*)pathCell;
-(void)addPathElementUsingString:(NSString*)pathLabel;
-(void)removeLastElement;
@end