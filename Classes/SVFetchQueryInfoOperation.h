//
//  SVFetchQueryInfoOperation.h
//  Davenport
//
//  Created by Robert Evans on 2/6/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/SBCouchServer.h>

@interface SVFetchQueryInfoOperation : NSOperation {
    NSMutableArray *viewTreeNodes;
    NSTreeNode     *parentDesignDocTreeNode;
    BOOL            fetchReturnedData;

@protected
    SBCouchServer   *couchServer;
    SBCouchDatabase *couchDatabase;
    NSString        *documentId;
}

@property (assign) NSMutableArray  *viewTreeNodes;
@property (assign) NSTreeNode      *parentDesignDocTreeNode;  
@property (retain) SBCouchServer   *couchServer;
@property (retain) SBCouchDatabase *couchDatabase;
@property (retain) NSString        *documentId; 
@property          BOOL             fetchReturnedData;

-(id) initWithCouchServer:(SBCouchServer *)server database:(SBCouchDatabase*)database parentDesignDocTreeNode:(NSTreeNode*)node;
-(BOOL)fetchReturnedData;

@end