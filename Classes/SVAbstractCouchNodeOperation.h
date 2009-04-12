//
//  SVAbstractCouchNodeOperation.h
//  Davenport
//
//  Created by Robert Evans on 4/2/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>

@class DPResourceFactory;


@interface SVAbstractCouchNodeOperation : NSOperation {
    NSTreeNode    *rootNode;
    NSIndexPath   *databaseIndexPath;
    SBCouchServer *couchServer;
@protected    
    id <DPResourceFactory> resourceFactory;
}

@property (retain) NSTreeNode  *rootNode;
@property (retain) NSIndexPath *databaseIndexPath; 
@property (assign) id <DPResourceFactory> resourceFactory;
@property (retain) SBCouchServer          *couchServer;

-(id) initWithCouchTreeNode:(NSTreeNode*)couchTreeNode indexPath:(NSIndexPath*)indexPath resourceFactory:(id <DPResourceFactory>)resourceFactory;

#pragma mark - 
-(void)createNodesForDatabases:(NSArray*)couchDatabaseList serverNode:(NSTreeNode*)serverNode;
-(void)createNodesForDesignDocs:(SBCouchDatabase*)couchDatabase databaseNode:(NSTreeNode*)databaseTreeNode;
@end
