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
    //NSTreeNode *databaseNode = [self findADatabaseTreeNode:rootNodeOfLeftHandNav];

    NSArray *list = [rootNodeOfLeftHandNav nodesHoldingUserDataOfType:[SBCouchDatabase class]];
    //STAssertNotNil(list,nil);
 
    //STAssertNotNil(databaseNode, @"Could not find a database Node");
    id node = nil;
    SVFetchDatabaseInfoOperation *operation = [[SVFetchDatabaseInfoOperation alloc] initWithCouchDatabaseTreeNode:node];
            
    [operationQueue addOperation:operation];        
    [operationQueue waitUntilAllOperationsAreFinished];
   
    [operation release];
    [operationQueue release];
}

-(NSTreeNode*)findADatabaseTreeNode:(NSTreeNode*)rootNode{
    id <DPContributionNavigationDescriptor> descriptor = [rootNode representedObject];
    id couchDocument = [[descriptor userInfo] objectForKey:@"couchobject"];

    if([couchDocument isKindOfClass:[SBCouchDatabase class]])
        return rootNode;
    
    for(NSTreeNode *node in [rootNode childNodes]){
        id databaseNode = [self findADatabaseTreeNode:node];
        if(databaseNode){
            return databaseNode;
        }else{
            return [self findADatabaseTreeNode:node];
        }
    }    
    return nil;
}

#pragma mark -

- (void) setUp{
    // don't call supers setup because we're gonna rely on Davenports 
    // internal state for testing. 
}

- (void) tearDown{
    // again, don't call super
}

@end
