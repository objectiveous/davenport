#import <SenTestingKit/SenTestingKit.h>
#import "SVFetchQueryInfoOperation.h"
#import "SVAbstractIntegrationTest.h"
#import "SVConstants.h" 
#import "SVDavenport.h"
#import "SVAppDelegate.h"
#import "SVMainWindowController.h"
#import "NSTreeNode+SVDavenport.h"
#import "SVRefreshCouchServerNodeOperation.h"

static const NSString *TEST_DATABASE_DOINK = @"doink"; 
@interface SVRefreshServerNodeOperationIntegrationTest : SVAbstractIntegrationTest{
}
- (NSTreeNode *) rootNavigationNodeFromDavenport;
@end

@implementation SVRefreshServerNodeOperationIntegrationTest





-(void)testRefreshOfServerNode{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];  
    
    NSTreeNode *rootNodeOfLeftHandNav = [self rootNavigationNodeFromDavenport];

    NSArray *list = [rootNodeOfLeftHandNav nodesWithCouchObjectOfType:[SBCouchServer class]];
    STAssertNotNil(list, @"Empty list of TreeNodes w/ SBCouchServer objects ");
    STAssertTrue([list count] > 0 , @"Server Nodes = %i", [list count]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"representedObject.userInfo.couchobject.name like 'localhost*'"];
    NSArray *filteredListOfNodes =  [list filteredArrayUsingPredicate:predicate];
    STAssertNotNil(filteredListOfNodes, nil);
    STAssertTrue([filteredListOfNodes count], @" Server list is empty");
    NSTreeNode *nodeToRefresh = [filteredListOfNodes lastObject];
    STAssertNotNil(nodeToRefresh, nil);
    NSIndexPath *indexPath = [nodeToRefresh indexPath];
    
    NSTreeNode *serverNode;
    SBCouchServer *server = [nodeToRefresh couchObject];
    STAssertNotNil(server, @"Missing a server %@", server);
    [server createDatabase:@"doink"];
    
    SVRefreshCouchServerNodeOperation *operation = [[SVRefreshCouchServerNodeOperation alloc] initWithCouchServerTreeNode:nodeToRefresh
                                                                                                                      indexPath:indexPath];
    

    
    [operationQueue addOperation:operation];        
    [operationQueue waitUntilAllOperationsAreFinished];       
    [operation release];
    [operationQueue release];
    
    NSArray *refreshedList = [rootNodeOfLeftHandNav nodesWithCouchObjectOfType:[SBCouchDatabase class]];
    NSPredicate *doinkDatabasePredicate = [NSPredicate predicateWithFormat:@"representedObject.userInfo.couchobject.name like 'doink*'"];
    NSArray *doinkDatabases =  [refreshedList filteredArrayUsingPredicate:doinkDatabasePredicate];   
    STAssertNotNil(doinkDatabases, nil);
    STAssertTrue([doinkDatabases count] == 1, nil);
    [server deleteDatabase:@"doink"];
}

- (NSTreeNode *) rootNavigationNodeFromDavenport {
    SVAppDelegate *appDelegate = [NSApp delegate];
    SVMainWindowController *mainWindowController = appDelegate.mainWindowController;
    NSTreeNode *rootNodeOfLeftHandNav = mainWindowController.rootNode;
    return rootNodeOfLeftHandNav;
}    
    
@end
