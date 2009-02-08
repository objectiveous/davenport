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
    NSTreeNode     *designDocTreeNode;
    BOOL            fetchReturnedData;

    @protected
    SBCouchDatabase *couchDatabase;
}


@property (assign) NSTreeNode      *designDocTreeNode;  
@property (retain) SBCouchDatabase *couchDatabase;
@property          BOOL             fetchReturnedData;

-(id) initWithCouchDatabase:(SBCouchDatabase*)database designDocTreeNode:(NSTreeNode*)node;
-(BOOL)fetchReturnedData;

@end