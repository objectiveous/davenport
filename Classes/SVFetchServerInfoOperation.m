//
//  SVFetchServerInfoOperation.m
// 
//
//  Created by Robert Evans on 12/30/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "SVFetchServerInfoOperation.h"
#import "SVAppDelegate.h"
#import "NSTreeNode+SVDavenport.h"
#import <CouchObjC/CouchObjC.h>
#import "SVBaseNavigationDescriptor.h"
#import "DPContributionNavigationDescriptor.h"

#define QUERIES                 @"QUERIES"
#define DATABASES               @"DATABASES"
#define TOOLS                   @"TOOLS"
#define DESIGN                  @"DESIGN"


@implementation SVFetchServerInfoOperation

@synthesize rootNode;
@synthesize couchServer;

-(id) initWithCouchServer:(SBCouchServer *)server{
    self = [super init];
    if(self){
        [self setCouchServer:server];
    }
    return self;
}

- (void)main {
    SVDebug(@"Trying to fetch server information from localhot:5983");
    fetchReturnedData = NO;
    id <DPResourceFactory> factory = [(SVAppDelegate*) [NSApp delegate] mainWindowController];
    
    assert(couchServer);
    NSArray *databases = [couchServer listDatabases];
    
    if(databases == nil){
        SVDebug(@"No databases found.");
        return;
    }
    fetchReturnedData = YES;

    NSTreeNode *root = [[[NSTreeNode alloc] init] autorelease];        
    NSString *hostAndPort = [NSString stringWithFormat:@"%@:%i",self.couchServer.host, self.couchServer.port];
    NSTreeNode *couchServerNode = [root addCouchServerSection:hostAndPort];

    for(NSString *databaseName in databases){
        SBCouchDatabase *couchDatabase = [self.couchServer database:databaseName];
            
        SVBaseNavigationDescriptor *databaseDescriptor = [[[SVBaseNavigationDescriptor alloc] initWithLabel:databaseName
                                                                                              andIdentity:databaseName
                                                                                                     type:DPDescriptorCouchDatabase] autorelease];
        
        databaseDescriptor.couchDatabase = couchDatabase;
        databaseDescriptor.resourceFactory = factory;
        
        NSTreeNode *databaseTreeNode = [couchServerNode addChildNodeWithObject:databaseDescriptor];
                
        NSEnumerator *designDocs = [couchDatabase getDesignDocuments];        
        SBCouchDocument *couchDesignDocument;        
        while((couchDesignDocument = [designDocs nextObject])){                        
           NSString *label = [couchDesignDocument.identity lastPathComponent];
           SVBaseNavigationDescriptor *designDescriptor = [[[SVBaseNavigationDescriptor alloc] initWithLabel:label
                                                                                              andIdentity:couchDesignDocument.identity
                                                                                                     type:DPDescriptorCouchDesign] autorelease];
           designDescriptor.couchDatabase = couchDatabase;
           designDescriptor.resourceFactory = factory;
           [databaseTreeNode addChildNodeWithObject:designDescriptor];
        }
    }        
    [self setRootNode:root];
}

-(BOOL)fetchReturnedData{
    return fetchReturnedData;
}
@end
