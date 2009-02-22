#import <SenTestingKit/SenTestingKit.h>
#import "SVFetchQueryInfoOperation.h"
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
#import "TPDatabaseInstallerOperation.h"
#import "SVPluginContributionLoaderOperation.h"
#import "TPPlugin.h"

@interface TPDatabaseInstallerTest : SVAbstractIntegrationTest{
    NSBundle *tpPlugin; 
    NSOperation *databseInstallOperation;
}
@property (retain) NSBundle    *tpPlugin; 
@property (retain) NSOperation *databseInstallOperation;
@end
    
@implementation TPDatabaseInstallerTest
@synthesize tpPlugin, databseInstallOperation;

-(void)testSimplestThingThatWillWork{    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:self.databseInstallOperation];
    [queue waitUntilAllOperationsAreFinished];
        
    [queue release];
}

#pragma mark -
#pragma mark Setup Mojo

// XXX Consider moving this into a super class for plugins. 
-(void)setUp{
    [super setUp]; 

    SVPluginContributionLoaderOperation *pluginLoader = [[SVPluginContributionLoaderOperation alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:pluginLoader];
    [queue waitUntilAllOperationsAreFinished];
    
    for(id <DPContributionPlugin, NSObject> plugin in pluginLoader.instances){
        if([[plugin pluginID] isEqualToString:@"TPPlugin"]){
            self.tpPlugin = [NSBundle bundleForClass:[plugin class] ];
            STAssertNotNil(self.tpPlugin, @"Could not load the bunlde");
            Class installerOperationClass = [self.tpPlugin classNamed:@"TPDatabaseInstallerOperation"];
            STAssertNotNil(installerOperationClass, @"Did not load operation class from the plugin");
            self.databseInstallOperation = [[installerOperationClass alloc] init];
            STAssertNotNil(self.databseInstallOperation, @"operation is null");            
        }
    }        
    [queue release];     
}

-(void) tearDown{
    [databseInstallOperation release];
    [tpPlugin release];
    [super tearDown];    
}


@end
