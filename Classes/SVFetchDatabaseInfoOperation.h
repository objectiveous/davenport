//
//  SVFeetchDatabaseInfoOperation.h
//  Davenport
//
//  Created by Robert Evans on 3/20/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>

@interface SVFetchDatabaseInfoOperation : NSOperation {
    NSTreeNode *couchDatabaseNode;
}
@property (retain) NSTreeNode *couchDatabaseNode;

/// XXX Given an existing database tree node, refresh its children with the current state from the server. 
-(id) initWithCouchDatabaseTreeNode:(NSTreeNode*)databaseTreeNode;

@end
