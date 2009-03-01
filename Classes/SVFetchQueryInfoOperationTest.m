#import <SenTestingKit/SenTestingKit.h>
#import "SVFetchQueryInfoOperation.h"
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
#import "SVBaseNavigationDescriptor.h"


@interface SVFetchQueryInfoOperationTest : SVAbstractIntegrationTest{
    BOOL itWorked;
}
@end

@implementation SVFetchQueryInfoOperationTest

-(void)setUp{
    [super setUp];
    itWorked = FALSE;
        
    SBCouchResponse *response = [self provisionViews];
    STAssertNotNULL(response, @"Missing response");
    STAssertTrue(response.ok, @"Response not okay");
}

-(void)testSimplestThingThatWillWork{    
    [self provisionViews];    
    self.leaveDatabase = NO;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

                                                                                                    
    NSString *designDocId = [NSString stringWithFormat:@"_design/%@",[self designDocName]];
    SVBaseNavigationDescriptor *desc = [[SVBaseNavigationDescriptor alloc] initWithLabel:[self designDocName] andIdentity:designDocId type:DPDescriptorCouchDesign];
    NSTreeNode *nodeWithViewDescriptor = [NSTreeNode treeNodeWithRepresentedObject:desc];
    
 
    
    SVFetchQueryInfoOperation *fetchOperation = [[SVFetchQueryInfoOperation alloc] 
                                                 initWithCouchDatabase:self.couchDatabase
                                                 designDocTreeNode:nodeWithViewDescriptor];


    [queue addOperation:fetchOperation];    
    [queue waitUntilAllOperationsAreFinished];    

    NSTreeNode *root = [fetchOperation designDocTreeNode];
    STAssertNotNULL(root, @"Root node is is null %@", root);
    
    NSInteger count = [[root childNodes] count];    
    STAssertTrue(count == 3, @"Child count is %i", count);
    [queue release];

}


@end
