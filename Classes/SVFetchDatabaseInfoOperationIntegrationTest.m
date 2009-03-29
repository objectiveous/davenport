//#import <SenTestingKit/SenTestingKit.h>
#import "SVFetchQueryInfoOperation.h"
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
#import "SVFetchDatabaseInfoOperation.h"
#import "SVConstants.h" // I don't like that we hae to do this. 
#import "SVAppDelegate.h"
#import "SVMainWindowController.h"
#import "NSTreeNode+SVDavenport.h"

@interface SVFetchDatabaseInfoOperationIntegrationTest : SVAbstractIntegrationTest{
}
-(NSTreeNode*)findADatabaseTreeNode:(NSTreeNode*)rootNode;
@end

@implementation SVFetchDatabaseInfoOperationIntegrationTest

- (void)testSimplestThingThatWillWork{
	SVDebug(@"Empty Test.");
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    // How do we get at the NSTreeNode? 
    SVAppDelegate *appDelegate = [NSApp delegate];
    SVMainWindowController *mainWindowController = appDelegate.mainWindowController;
    NSTreeNode *rootNodeOfLeftHandNav = mainWindowController.rootNode;
    
    STAssertNotNil(rootNodeOfLeftHandNav, @"Could not grab the root node from Davenport");
  
    NSArray *list = [rootNodeOfLeftHandNav nodesWithCouchObjectOfType:[SBCouchDatabase class]];
    STAssertNotNil(list,nil);
    STAssertTrue([list count] > 0, @"list of TreeNodes is empy.");
    for(NSTreeNode *node in list){
        id object = [node couchObject];
        STAssertTrue([object isKindOfClass:[SBCouchDatabase class]], nil);
    }
    id node = nil;
    SVFetchDatabaseInfoOperation *operation = [[SVFetchDatabaseInfoOperation alloc] initWithCouchDatabaseTreeNode:node];
            
    [operationQueue addOperation:operation];        
    [operationQueue waitUntilAllOperationsAreFinished];
   
    [operation release];
    [operationQueue release];

}

#pragma mark -

- (void) setUp{
    // don't call super's setup because we're gonna rely on Davenports 
    // internal state for testing. 
}

- (void) tearDown{
    // again, don't call super
}

@end
