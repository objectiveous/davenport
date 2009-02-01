#import <Cocoa/Cocoa.h>

@class SVBreadCrumbCell;

@interface SVPathControl : NSPathControl {

}

-(void)addPathElement:(SVBreadCrumbCell*)pathCell;
-(void)addPathElementUsingString:(NSString*)pathLabel;
-(void)removeLastElement;
@end