//
//  SVFetchQueryInfoOperation.m
//  Davenport
//
//  Created by Robert Evans on 2/6/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVFetchQueryInfoOperation.h"
#import <CouchObjC/CouchObjC.h>
#import "NSTreeNode+SVDavenport.h"
#import "DPContributionPlugin.h"
#import "SVBaseNavigationDescriptor.h"


@implementation SVFetchQueryInfoOperation;
@synthesize couchDatabase;
@synthesize fetchReturnedData;
@synthesize designDocTreeNode;

-(id) initWithCouchDatabase:(SBCouchDatabase*)database designDocTreeNode:(NSTreeNode*)node{
    self = [super init];
    if(self){
        self.designDocTreeNode = node;
        self.couchDatabase = database;
        self.fetchReturnedData = NO;
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
}

- (void)main {
    SVBaseNavigationDescriptor *desc = [designDocTreeNode representedObject];
    SBCouchDesignDocument *designDoc = [self.couchDatabase getDesignDocument:desc.identity];
  
    for(NSString *key in [[designDoc views] allKeys]){
        // TODO gets called more than once needlessly. 
        self.fetchReturnedData = YES;

        SVBaseNavigationDescriptor *desc = [[[SVBaseNavigationDescriptor alloc] initWithLabel:key andIdentity:key type:DPDescriptorCouchView] autorelease];    
        NSTreeNode *viewNode = [NSTreeNode treeNodeWithRepresentedObject:desc];

        @synchronized(self.designDocTreeNode){
            [[self.designDocTreeNode mutableChildNodes] addObject:viewNode];
        }
    }
}

-(BOOL)fetchReturnedData{
    return fetchReturnedData;
}

@end
