#import <SenTestingKit/SenTestingKit.h>
#import "SVFetchServerInfoOperation.h"
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
@interface SVFetchServerInfoOperationTest : SVAbstractIntegrationTest{
    BOOL itWorked;
}
@end

@implementation SVFetchServerInfoOperationTest

-(void)testSimplestThingThatWillWork{    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    SVFetchServerInfoOperation *fetchOperation = [[SVFetchServerInfoOperation alloc] initWithCouchServer:self.couchServer];
        
    [queue addOperation:fetchOperation];    
    [queue waitUntilAllOperationsAreFinished];
    STAssertNotNil(fetchOperation.rootNode, @"operation failed to return a server information in the form of a treenode");    
    [fetchOperation release];
}
#pragma mark -
-(void)setUp{
    [super setUp];
}

-(void)tearDown{
    [super tearDown];
} 

@end
