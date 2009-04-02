//#import <SenTestingKit/SenTestingKit.h>
#import "SVFetchQueryInfoOperation.h"
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
#import "SVRefreshCouchDatabaseNodeOperation.h"
#import "SVConstants.h" // I don't like that we hae to do this. 
#import "SVAppDelegate.h"
#import "SVMainWindowController.h"
#import "NSTreeNode+SVDavenport.h"

@interface SVRefreshCouchDatabaseNodeOperationIntegrationTest : SVAbstractIntegrationTest{
}
-(void)addDesignDocument:(SBCouchDatabase*)couchDatabase;
@end

@implementation SVRefreshCouchDatabaseNodeOperationIntegrationTest


- (void)testFindingNodes{
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"representedObject.userInfo.couchobject.name like 'it-for-davenport*'"];
    NSArray *filteredListOfNodes =  [list filteredArrayUsingPredicate:predicate];
    
    STAssertTrue([filteredListOfNodes count] > 0, @"Missing integration database to test against. ");   
    
}

- (void)estRefreshDatabase{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];    
    SVAppDelegate *appDelegate = [NSApp delegate];
    SVMainWindowController *mainWindowController = appDelegate.mainWindowController;
    NSTreeNode *rootNodeOfLeftHandNav = mainWindowController.rootNode;
    NSArray *list = [rootNodeOfLeftHandNav nodesWithCouchObjectOfType:[SBCouchDatabase class]];
        
    NSTreeNode *nodeToRefresh = [list lastObject];
    
    NSIndexPath *indexPath = [nodeToRefresh indexPath];

    NSInteger childCountBeforeUpdate = [[nodeToRefresh childNodes] count];
    
    NSTreeNode *nodeFromIndexPath = [rootNodeOfLeftHandNav descendantNodeAtIndexPath:indexPath];
    STAssertTrue(nodeFromIndexPath == nodeToRefresh, nil);
    
    //NSLog(@"%@", indexPath);
    // 1] Take the indexPath of the TreeNode that has changed, create a new NSTreeNode with fresh data. 
    // 2] Remove the children of the original node. 
    
    SVRefreshCouchDatabaseNodeOperation *operation = [[SVRefreshCouchDatabaseNodeOperation alloc] initWithCouchDatabaseTreeNode:rootNodeOfLeftHandNav
                                                                                                                      indexPath:indexPath];
    
    
    [self addDesignDocument:[nodeToRefresh couchObject]];
    
    [operationQueue addOperation:operation];        
    [operationQueue waitUntilAllOperationsAreFinished];       
    [operation release];
    [operationQueue release];
    
    NSTreeNode *updatedNode = [rootNodeOfLeftHandNav descendantNodeAtIndexPath:indexPath];
    STAssertTrue(updatedNode == nodeToRefresh, nil);


    NSInteger childCountAfterUpdate = [[updatedNode childNodes] count];
    NSLog( @"===>>>> %i %i", childCountBeforeUpdate, childCountAfterUpdate);
    STAssertTrue(childCountBeforeUpdate < childCountAfterUpdate, @" startCount: %i EndCount: %i", childCountBeforeUpdate, childCountAfterUpdate);
    
}


-(void)addDesignDocument:(SBCouchDatabase*)database{
    SBCouchView *allDesignDocumentsView = [database designDocumentsView];
    NSEnumerator *resultEnumerator = [allDesignDocumentsView viewEnumerator];
    
    SBCouchDesignDocument *designDoc;
    NSInteger count = 0;
    while (designDoc = [resultEnumerator nextObject]) {        
        [designDoc detach];
        designDoc.identity = [NSString stringWithFormat:@"%@-%i-%i", @"_design/operation-test", random(), count];
        SBCouchResponse *response = [designDoc put];
        STAssertTrue(response.ok, @"%i" , response.ok);
        count++;
    }
}

#pragma mark -

- (void) setUp{
    [super setUp];
}

- (void) tearDown{
    [super tearDown];
}

@end
