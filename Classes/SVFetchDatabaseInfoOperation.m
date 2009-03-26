//
//  SVFeetchDatabaseInfoOperation.m
//  Davenport
//
//  Created by Robert Evans on 3/20/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVFetchDatabaseInfoOperation.h"

@implementation SVFetchDatabaseInfoOperation
@synthesize couchDatabaseNode;

-(id) initWithCouchDatabaseTreeNode:(NSTreeNode*)databaseTreeNode{    
    self = [super init];
    if(self){
        self.couchDatabaseNode = databaseTreeNode;
    }
    return self;
    
}

-(void) dealloc{
    self.couchDatabaseNode = nil;
    [super dealloc];
}

#pragma mark -

- (void)main {
}
@end
