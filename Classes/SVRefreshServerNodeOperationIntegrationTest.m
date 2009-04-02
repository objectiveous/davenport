#import <SenTestingKit/SenTestingKit.h>
#import "SVFetchQueryInfoOperation.h"
#import "SVAbstractIntegrationTest.h"
#import "SVConstants.h" 
#import "SVDavenport.h"
#import "SVAppDelegate.h"
#import "SVMainWindowController.h"
#import "NSTreeNode+SVDavenport.h"
#import "SVRefreshCouchServerNodeOperation.h"

@interface SVRefreshServerNodeOperationIntegrationTest : SVAbstractIntegrationTest{
}
@end

@implementation SVRefreshServerNodeOperationIntegrationTest

-(void)testRefreshOfServerNode{
	SVDebug(@"Empty Test.");
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];  
    
    SVAppDelegate *appDelegate = [NSApp delegate];
    SVMainWindowController *mainWindowController = appDelegate.mainWindowController;
    NSTreeNode *rootNodeOfLeftHandNav = mainWindowController.rootNode;
    
    //STAssertNotNil(rootNodeOfLeftHandNav, @"Could not grab the root node from Davenport");    
    NSArray *list = [rootNodeOfLeftHandNav nodesWithCouchObjectOfType:[SBCouchServer class]];
    STAssertNotNil(list, @"Empty list of TreeNodes w/ SBCouchServer objects ");
    STAssertTrue([list count] > 0 , @"Server Nodes = %i", [list count]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"representedObject.userInfo.couchobject.name like 'it-for-davenport*'"];
    //NSArray *filteredListOfNodes =  [list filteredArrayUsingPredicate:predicate];

    /*
    
    
       
    NSTreeNode *nodeToRefresh = [filteredListOfNodes lastObject];    
    NSIndexPath *indexPath = [nodeToRefresh indexPath];
    
    NSTreeNode *serverNode;
    
    SVRefreshCouchServerNodeOperation *operation = [[SVRefreshCouchServerNodeOperation alloc] initWithCouchServerTreeNode:serverNode
                                                                                                                      indexPath:indexPath];
    
    
    //[self addDesignDocument:[nodeToRefresh couchObject]];
    
    [operationQueue addOperation:operation];        
    [operationQueue waitUntilAllOperationsAreFinished];       
    [operation release];
    [operationQueue release];
    
    NSTreeNode *updatedNode = [rootNodeOfLeftHandNav descendantNodeAtIndexPath:indexPath];
    STAssertTrue(updatedNode == nodeToRefresh, nil);
    */
}

@end
