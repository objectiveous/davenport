#import <SenTestingKit/SenTestingKit.h>
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
#import "SVViewDescriptor.h"
#import "SVPluginContributionLoader.h"
#import "SVContributionNav.h"


@interface SVLoadNavigationContributionsFromPluginsTest : SVAbstractIntegrationTest{
    BOOL itWorked;
}
@end

@implementation SVLoadNavigationContributionsFromPluginsTest

-(void)setUp{
    [super setUp];
    itWorked = FALSE;
    
    SBCouchResponse *response = [self provisionViews];
    STAssertNotNULL(response, @"Missing response");
    STAssertTrue(response.ok, @"Response not okay");
}

-(void)testLoadingOfPlugins{    
    [self provisionViews];    
    self.leaveDatabase = NO;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];    
    SVPluginContributionLoader *pluginLoader = [[SVPluginContributionLoader alloc] init];
        
    [pluginLoader addObserver:self
                   forKeyPath:@"isFinished"
                      options:0
                      context:nil];
    
    [queue addOperation:pluginLoader];
    [pluginLoader release];
    [queue waitUntilAllOperationsAreFinished];
    
    STAssertTrue(itWorked,@"failed to find conforming plugin in ~/Library/Application Support/Davenport/Plugins");
    
}

- (void)observeValueForKeyPath:(NSString*)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary*)change 
                       context:(void*)context{
    
    if([keyPath isEqual:@"isFinished"] && [object isKindOfClass:[SVPluginContributionLoader class]]){
        SVPluginContributionLoader *loader = (SVPluginContributionLoader*)object;
        //itWorked = TRUE;    
        for(id plugin in loader.instances){
            NSTreeNode *contributionRootNode = [plugin navigationContribution];
            STAssertNotNULL(contributionRootNode,@"Contribution returned a null tree node");
            itWorked = TRUE;            
        }
         
    } 
}


@end
