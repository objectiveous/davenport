//
//  SVAbstractIntegrationTest.m
//  Davenport
//
//  Created by Robert Evans on 2/2/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVAbstractIntegrationTest.h"
#import "SVPluginContributionLoaderOperation.h"
#import "DPContributionPlugin.h"

static NSString *MAP_FUNCTION     = @"function(doc) { if(doc.name == 'Frank'){ emit('Number of Franks', 1);}}";
static NSString *REDUCE_FUNCTION  = @"function(k, v, rereduce) { return sum(v);}";

static NSString *DAVENPORT_TEST_DESIGN_NAME = @"integration-test";
static NSString *DAVENPORT_TEST_VIEW_NAME_1 = @"frankCount";
static NSString *DAVENPORT_TEST_VIEW_NAME_2 = @"funnyMen";
static NSString *DAVENPORT_TEST_VIEW_NAME_3 = @"jazzMen";

@implementation SVAbstractIntegrationTest

@synthesize couchServer;
@synthesize couchDatabase;
@synthesize leaveDatabase;
@synthesize loadedPlugins;

#pragma mark -
- (void)setUp {
    leaveDatabase = false;
    // Better safe than sorry
    srandom(time(NULL));
    couchServer = [[SBCouchServer alloc] initWithHost:@"localhost" port:5984];
    
    NSString *name = [NSString stringWithFormat:@"it-for-davenport-%u", random()];
    
    if([couchServer createDatabase:name]){
        couchDatabase = [[couchServer database:name] retain];
    }else{
        STFail(@"Could not create database %@", name);
    }    
}

-(SBCouchResponse*)provisionViews{
    SBCouchView *view = [[SBCouchView alloc] initWithName:@"totals" andMap:MAP_FUNCTION andReduce:REDUCE_FUNCTION];
    
    SBCouchDesignDocument *designDocument = [[SBCouchDesignDocument alloc] initWithDesignDomain:DAVENPORT_TEST_DESIGN_NAME];
    [designDocument addView:view withName:DAVENPORT_TEST_VIEW_NAME_1];
    [designDocument addView:view withName:DAVENPORT_TEST_VIEW_NAME_2];
    [designDocument addView:view withName:DAVENPORT_TEST_VIEW_NAME_3];

    return [self.couchDatabase createDocument:designDocument];
}

- (void)tearDown {
    // There are times when we want to manually inspect the test database. 
    if(!leaveDatabase)
        [couchServer deleteDatabase:couchDatabase.name];

    
    [couchDatabase release];
    [couchServer release];
}

// TODO is there a better way?
-(NSString*)designDocName{
    return DAVENPORT_TEST_DESIGN_NAME;
}

- (void)loadDavenportPlugins{
    loadedPlugins = [[NSMutableDictionary alloc] init];
    SVPluginContributionLoaderOperation *pluginLoader = [[SVPluginContributionLoaderOperation alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:pluginLoader];
    [queue waitUntilAllOperationsAreFinished];
    
    for(id <DPContributionPlugin, NSObject> plugin in pluginLoader.instances){
        NSBundle *bundle = [NSBundle bundleForClass:[plugin class] ];
        [self.loadedPlugins setObject:bundle forKey:[plugin pluginID]]; 
    }        
    [queue release];     
}
@end
