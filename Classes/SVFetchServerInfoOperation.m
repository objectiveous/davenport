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

#define QUERIES                 @"QUERIES"
#define DATABASES               @"DATABASES"
#define TOOLS                   @"TOOLS"

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

    assert(couchServer);
    NSArray *databases = [couchServer listDatabases];

    if(databases == nil){
        SVDebug(@"No databases found.");
        return;
    }
    fetchReturnedData = YES;
    
    NSTreeNode *root = [[[NSTreeNode alloc] init] autorelease];    
    NSTreeNode *databaseNode = [root addSection:DATABASES];

    for(NSString *databaseName in databases){
        [databaseNode addDatabase:databaseName];
    }
        
    [root addSection:QUERIES];
    [root addSection:TOOLS];
    [self setRootNode:root];

}

-(BOOL)fetchReturnedData{
    return fetchReturnedData;
}
@end
