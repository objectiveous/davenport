#import <SenTestingKit/SenTestingKit.h>
#import "SVFetchQueryInfoOperation.h"
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
#import "DPContributionPlugin.h"
#import "SVConstants.h"
#import "TPPlugin.h"


@interface TPPluginTest : SVAbstractIntegrationTest{
    NSBundle *bundle;
}
@end

@implementation TPPluginTest

-(void)setUp{
    [super setUp];
    [self loadDavenportPlugins];
    bundle = [self.loadedPlugins objectForKey:@"TPPlugin"];    
}

-(void)tearDown{
    [bundle release];
    [super tearDown];
}

-(void)testSimplestThingThatWillWork{
    Class principalClass = [bundle principalClass];
    //id <DPContributionPlugin> plugin = [principalClass new];
    TPPlugin *plugin = [principalClass new];
    STAssertNotNil(plugin, @"could not load TPPlugin");
    
    id descriptor = [[[[bundle classNamed:@"TPBaseDescriptor"] alloc] initWithPluginID:[plugin pluginID]
                                                                         label:@"US Collapse"
                                                                      identity:@"Collapse"
                                                                descriptorType:TPNavigationDescriptorDesignDoc                                   
                                                                         group:NO] autorelease];
        
    NSTreeNode *treeNode = [NSTreeNode treeNodeWithRepresentedObject:descriptor];

    [plugin setCurrentItem:treeNode];
    NSViewController *viewController = [plugin mainSectionContribution];
    STAssertNotNil(viewController,@"asdf");
}

@end
