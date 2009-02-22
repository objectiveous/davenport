#import <SenTestingKit/SenTestingKit.h>
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
#import "SVViewDescriptor.h"
#import "SVPluginContributionLoader.h"
#import "DPContributionPlugin.h"


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
        
    [queue addOperation:pluginLoader];
   
    [queue waitUntilAllOperationsAreFinished];
    
    
    for(id <DPContributionPlugin> plugin in pluginLoader.instances){
        NSTreeNode *contributionRootNode = [plugin navigationContribution];
        STAssertNotNULL(contributionRootNode,@"Contribution returned a null tree node");
        itWorked = TRUE;            
    }      
    
    STAssertTrue(itWorked,@"failed to find conforming plugin in ~/Library/Application Support/Davenport/Plugins");    
    
    [pluginLoader release];
    [queue release];
}


@end
