//
//  SVFetchServerInfoOperation.m
// 
//
//  Created by Robert Evans on 12/30/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <CouchObjC/CouchObjC.h>

#import "DPResourceFactory.h"
#import "DPContributionNavigationDescriptor.h"
#import "DPResourceFactory.h"

#import "SVAbstractCouchNodeOperation.h"
#import "SVFetchServerInfoOperation.h"
#import "SVBaseNavigationDescriptor.h"
#import "SVAbstractCouchNodeOperation.h"
#import "SVAppDelegate.h"

#import "NSTreeNode+SVDavenport.h"




#define QUERIES                 @"QUERIES"
#define DATABASES               @"DATABASES"
#define TOOLS                   @"TOOLS"
#define DESIGN                  @"DESIGN"


@implementation SVFetchServerInfoOperation

//@synthesize rootNode;
//@synthesize couchServer;
//@synthesize resourceFactory;

-(id) initWithCouchServer:(SBCouchServer *)server rootTreeNode:(NSTreeNode*)rootTreeNode{
    self = [super initWithCouchTreeNode:rootTreeNode indexPath:nil resourceFactory:[(SVAppDelegate*) [NSApp delegate] mainWindowController]];
    if(self){
        self.couchServer = server;
    }
    return self;
}

#pragma mark -

- (void)main {
    SVDebug(@"Trying to fetch server information from localhot:5984");
    assert(couchServer);
    NSArray *databases = [couchServer listDatabases];
    
    if(databases == nil){
        SVDebug(@"No databases found.");
        return;
    }
    
    NSTreeNode *couchServerNode = [self.rootNode addCouchServerNode:self.couchServer resourceFactory:self.resourceFactory];    
    [self createNodesForDatabases:databases serverNode:couchServerNode];        
}


@end
