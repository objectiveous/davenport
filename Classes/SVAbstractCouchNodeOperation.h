//
//  SVAbstractCouchNodeOperation.h
//  Davenport
//
//  Created by Robert Evans on 4/2/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DPResourceFactory.h"

@interface SVAbstractCouchNodeOperation : NSOperation {
    NSTreeNode  *rootNode;
    NSIndexPath *databaseIndexPath;
@protected    
    id <DPResourceFactory> resourceFactory;
}

@property (retain) NSTreeNode  *rootNode;
@property (retain) NSIndexPath *databaseIndexPath; 
@property (assign) id <DPResourceFactory> resourceFactory;

-(id) initWithCouchTreeNode:(NSTreeNode*)couchTreeNode indexPath:(NSIndexPath*)indexPath resourceFactory:(id <DPResourceFactory>)resourceFactory;


@end
