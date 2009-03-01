#import <SenTestingKit/SenTestingKit.h>
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
#import "DPContributionPlugin.h"
#import "SVPluginContributionLoaderOperation.h"


@interface SVLoadNavigationContributionsFromPluginsTest : SVAbstractIntegrationTest{
    BOOL itWorked;
}
@end

@implementation SVLoadNavigationContributionsFromPluginsTest

/*
-(void)setUp{
    [super setUp];
}
*/
-(void)testLoadingOfPlugins{    
    [self provisionViews];
    [super loadDavenportPlugins];
    STAssertNotNil(self.loadedPlugins, nil);
    STAssertTrue([self.loadedPlugins count] > 0, nil);
}


@end
