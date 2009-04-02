//
//  SVAbstractCouchNodeOperation.m
//  Davenport
//
//  Created by Robert Evans on 4/2/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVAbstractCouchNodeOperation.h"



@implementation SVAbstractCouchNodeOperation
@synthesize rootNode;
@synthesize databaseIndexPath;
@synthesize resourceFactory;

-(id) initWithCouchTreeNode:(NSTreeNode*)couchTreeNode indexPath:(NSIndexPath*)indexPath resourceFactory:(id <DPResourceFactory>)resourceFactory{    
    self = [super init];
    if(self){
        self.rootNode = couchTreeNode;
        self.databaseIndexPath = indexPath;
        self.resourceFactory = resourceFactory;
    }
    return self;
}
-(void) dealloc{
    self.rootNode = nil;
    self.databaseIndexPath = nil;
    [super dealloc];
}

@end
