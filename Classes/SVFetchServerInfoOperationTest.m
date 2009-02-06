#import <SenTestingKit/SenTestingKit.h>
#import "SVFetchServerInfoOperation.h"
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
@interface SVFetchServerInfoOperationTest : SVAbstractIntegrationTest{
    BOOL itWorked;
}
@end

@implementation SVFetchServerInfoOperationTest

-(void)setUp{
    [super setUp];
    itWorked = FALSE;
}

-(void)testSimplestThingThatWillWork{    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    SVFetchServerInfoOperation *fetchOperation = [[SVFetchServerInfoOperation alloc] initWithCouchServer:self.couchServer];

    [fetchOperation addObserver:self
                     forKeyPath:@"isFinished" 
                        options:0
                        context:nil];
    
    [queue addOperation:fetchOperation];
    [fetchOperation release];
    
    [queue waitUntilAllOperationsAreFinished];

    STAssertNotNil(fetchOperation.rootNode, @"operation failed to return a server information in the form of a treenode");
    
    
    if(!itWorked)
        STFail(@"Operation failed to return any server information");

}


- (void)observeValueForKeyPath:(NSString*)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary*)change 
                       context:(void*)context{
    
    if([keyPath isEqual:@"isFinished"] && [object isKindOfClass:[SVFetchServerInfoOperation class]]){
        id root = [(SVFetchServerInfoOperation*)object rootNode];
        SVDebug(@"Fetch Operation %@", root);
        itWorked = TRUE;
    } 
}


@end
