//
//  SVFeetchDatabaseInfoOperation.h
//  Davenport
//
//  Created by Robert Evans on 3/20/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>
#import "SVAbstractCouchNodeOperation.h"

@interface SVRefreshCouchDatabaseNodeOperation : SVAbstractCouchNodeOperation {
   // NSTreeNode  *rootNode;
    //NSIndexPath *databaseIndexPath;
}
//@property (retain) NSTreeNode  *rootNode;
//@property (retain) NSIndexPath *databaseIndexPath; 

/// Given the root navigation node update the database at indexPath. 
/// databaseTreeNode MUST represent SBCouchDatabase or an object that is a subclass of SBCouchDocument. 
/// The idea here is that we often times want to trigger the refresh of a Database node when one of its 
/// children (think DesignDocument) has changed. 
-(id) initWithCouchDatabaseTreeNode:(NSTreeNode*)databaseTreeNode indexPath:(NSIndexPath*)indexPath;

@end
