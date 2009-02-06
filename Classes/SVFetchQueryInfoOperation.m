//
//  SVFetchQueryInfoOperation.m
//  Davenport
//
//  Created by Robert Evans on 2/6/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVFetchQueryInfoOperation.h"
#import <CouchObjC/CouchObjC.h>
#import "SVViewDescriptor.h"
#import "NSTreeNode+SVDavenport.h"

@implementation SVFetchQueryInfoOperation
@synthesize rootNode;
@synthesize couchServer;
@synthesize couchDatabase;
@synthesize documentId;
@synthesize fetchReturnedData;



-(id) initWithCouchServer:(SBCouchServer *)server database:(SBCouchDatabase*)database  forDesignDocument:(NSString*)docId{
    self = [super init];
    if(self){
        self.couchServer = server;
        self.documentId = docId;
        self.couchDatabase = database;
        self.fetchReturnedData = NO;
    }
    return self;
}



- (void)main {

    SBCouchDesignDocument *designDoc = [self.couchDatabase getDesignDocument:self.documentId];
    //SVDebug(@"doc ID [ %@ ]", self.documentId);
    SVDebug(@"--->  designDoc [ %@ ]", designDoc);
    //SVDebug(@"--->  database name  [ %@ ]", self.couchDatabase.name);
    
    //assert(designDoc);

    
    
    NSTreeNode *root = [[[NSTreeNode alloc] init] autorelease];
    
    NSDictionary *views = [designDoc views];
    
    
    for(NSString *key in [views allKeys]){
       SVViewDescriptor *desc = [[[SVViewDescriptor alloc] init] autorelease];
        desc.label = key;
        [root addChildNodeWithObject:desc];    
    }
    
    [self setRootNode:root];
    self.fetchReturnedData = YES;
    SVDebug(@"!!!!!!!! **************** Here is the root %@", self.rootNode);
}

-(BOOL)fetchReturnedData{
    return fetchReturnedData;
}

@end
