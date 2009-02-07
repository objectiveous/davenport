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

@implementation SVFetchQueryInfoOperation;
@synthesize viewTreeNodes;
@synthesize couchServer;
@synthesize couchDatabase;
@synthesize documentId;
@synthesize fetchReturnedData;
@synthesize parentDesignDocTreeNode;

-(id) initWithCouchServer:(SBCouchServer *)server database:(SBCouchDatabase*)database parentDesignDocTreeNode:(NSTreeNode*)node;
{
    self = [super init];
    if(self){
        //SVAbstractDescriptor *desc = [docId representedObject];
        self.parentDesignDocTreeNode = node;
        self.couchServer = server;
        //self.documentId = desc.label;
        self.couchDatabase = database;
        self.fetchReturnedData = NO;
        self.viewTreeNodes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc{
    [viewTreeNodes release];
    [super dealloc];
}

- (void)main {
    SVAbstractDescriptor *d = [parentDesignDocTreeNode representedObject];
    SBCouchDesignDocument *designDoc = [self.couchDatabase getDesignDocument:d.label];
    //NSLog(@"--->  designDoc [ %@ ]", designDoc);
  
    NSDictionary *views = [designDoc views];
    for(NSString *key in [views allKeys]){
        NSLog(@"    %@", key);
        
        SVViewDescriptor *desc = [[[SVViewDescriptor alloc] init] autorelease];    
        desc.label = key;
        NSTreeNode *viewNode = [NSTreeNode treeNodeWithRepresentedObject:desc];
        [self.viewTreeNodes addObject:viewNode];
        
        [[parentDesignDocTreeNode mutableChildNodes] addObject:viewNode];        
        
    }
    
    self.fetchReturnedData = YES;    
}

-(BOOL)fetchReturnedData{
    return fetchReturnedData;
}

@end
