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


@interface SVFetchServerInfoOperation (Private)
-(void)createNodesForDatabases:(NSArray*)couchDatabaseList serverNode:(NSTreeNode*)serverNode;
-(void)createNodesForDesignDocs:(SBCouchDatabase*)couchDatabase databaseNode:(NSTreeNode*)databaseTreeNode;
@end

@implementation SVFetchServerInfoOperation

//@synthesize rootNode;
@synthesize couchServer;
//@synthesize resourceFactory;

-(id) initWithCouchServer:(SBCouchServer *)server rootTreeNode:(NSTreeNode*)rootTreeNode{
    self = [super initWithCouchTreeNode:rootTreeNode indexPath:nil resourceFactory:[(SVAppDelegate*) [NSApp delegate] mainWindowController]];
    if(self){
        self.couchServer = server;
    }
    return self;
}

- (void)main {
    SVDebug(@"Trying to fetch server information from localhot:5983");
    assert(couchServer);
    NSArray *databases = [couchServer listDatabases];
    
    if(databases == nil){
        SVDebug(@"No databases found.");
        return;
    }
    
    NSTreeNode *couchServerNode = [self.rootNode addCouchServerNode:self.couchServer resourceFactory:self.resourceFactory];    
    [self createNodesForDatabases:databases serverNode:couchServerNode];        
}

-(void)createNodesForDatabases:(NSArray*)couchDatabaseList serverNode:(NSTreeNode*)serverNode{
 
    for(NSString *databaseName in couchDatabaseList){
        SBCouchDatabase *couchDatabase = [self.couchServer database:databaseName];                       
        NSTreeNode *databaseTreeNode = [serverNode addCouchDatabaseNode:couchDatabase resourceFactory:self.resourceFactory];            

        [self createNodesForDesignDocs:couchDatabase databaseNode:databaseTreeNode];            
    } 
}

-(void)createNodesForDesignDocs:(SBCouchDatabase*)couchDatabase databaseNode:(NSTreeNode*)databaseTreeNode{
    NSEnumerator *designDocs = [couchDatabase getDesignDocuments];        
    SBCouchDesignDocument *designDoc;
    NSTreeNode *designNode;
    
    while((designDoc = [designDocs nextObject])){
        
        designNode = [databaseTreeNode addCouchDesignNode:designDoc resourceFactory:self.resourceFactory];        
        NSDictionary *dictionaryOfViews =  [designDoc views];

        for(id viewName in dictionaryOfViews){
            SBCouchView *couchView = [dictionaryOfViews objectForKey:viewName];
            
            [designNode addCouchViewNode:couchView resourceFactory:self.resourceFactory];
        }                        
    }
}
@end
