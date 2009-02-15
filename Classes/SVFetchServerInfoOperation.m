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
#import "SVDesignDocumentDescriptor.h"

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

    assert(couchServer);
    NSArray *databases = [couchServer listDatabases];
    
    if(databases == nil){
        SVDebug(@"No databases found.");
        return;
    }
    fetchReturnedData = YES;

    NSTreeNode *root = [[[NSTreeNode alloc] init] autorelease];
    // EXPERIMENT
    /*

    [root addSection:@"section one"];
    [root addDatabase:@"fake"];
    
    NSTreeNode *hostSection = [root addCouchServerSection:@"hostsection"];
    [hostSection addDatabase:@"fakeDB 1"];
    [hostSection addDatabase:@"fakeDB 2"];
    [hostSection addDatabase:@"fakeDB 3"];
    */
    
    
    NSString *hostAndPort = [NSString stringWithFormat:@"%@:%i",self.couchServer.host, self.couchServer.port];
    NSTreeNode *couchServerNode = [root addCouchServerSection:hostAndPort];

    for(NSString *databaseName in databases){
        NSTreeNode *databaseInstance = [couchServerNode addDatabase:databaseName];
        SBCouchDatabase *database = [self.couchServer database:databaseName];

        
        NSEnumerator *designDocs = [database getDesignDocuments];
        // TODO Maybe this ought to return actual design documents. 
        SBCouchDocument *designDoc;
        while((designDoc = [designDocs nextObject])){
            
            
           SVDesignDocumentDescriptor *designDesc = [[[SVDesignDocumentDescriptor alloc] 
                                                      initWithLabel:[designDoc.identity lastPathComponent]
                                                        andIdentity:designDoc.identity] autorelease];

           //designDesc.label = @"asdf";
            
           [databaseInstance addChildNodeWithObject:designDesc];
        }
    }
        
    //[root addSection:QUERIES];
    //[root addSection:TOOLS];
    
     [self setRootNode:root];

}

-(BOOL)fetchReturnedData{
    return fetchReturnedData;
}
@end
