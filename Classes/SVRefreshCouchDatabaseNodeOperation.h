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

/// Given the root navigation node update the database at indexPath
-(id) initWithCouchDatabaseTreeNode:(NSTreeNode*)databaseTreeNode indexPath:(NSIndexPath*)indexPath;

@end
