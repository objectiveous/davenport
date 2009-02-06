#import <SenTestingKit/SenTestingKit.h>
#import "SVFetchQueryInfoOperation.h"
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
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
    SVFetchQueryInfoOperation *fetchOperation = [[SVFetchQueryInfoOperation alloc] 
                                                 initWithCouchServer:self.couchServer 
                                                            database:self.couchDatabase
                                                    forDesignDocument:designDocId];
    
    [fetchOperation addObserver:self
                     forKeyPath:@"isFinished" 
                        options:0
                        context:nil];
    
    [queue addOperation:fetchOperation];
    [fetchOperation release];
    
    [queue waitUntilAllOperationsAreFinished];
    
    //if(!itWorked)
       // STFail(@"Operation failed to return any server information");
    
}


- (void)observeValueForKeyPath:(NSString*)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary*)change 
                       context:(void*)context{
    
    if([keyPath isEqual:@"isFinished"] && [object isKindOfClass:[SVFetchQueryInfoOperation class]]){
        SVDebug(@"Made it here");
        id root = [(SVFetchQueryInfoOperation*)object rootNode];
        STAssertNotNULL(root, @"Root node is is null %@", root);
        
        NSInteger count = [[root childNodes] count];
        
        STAssertTrue(count == 3, @"Child count is %i", count);
        itWorked = TRUE;
    } 
}


@end
