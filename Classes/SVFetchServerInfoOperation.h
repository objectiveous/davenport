//
//  STIGFetchServerInfoOperation.h
//  stigmergic
//
//  Created by Robert Evans on 12/30/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/SBCouchServer.h>

@interface SVFetchServerInfoOperation : NSOperation {
    NSTreeNode *rootNode;
    BOOL fetchReturnedData;
@protected
    SBCouchServer *couchServer;
    
}

@property (assign) NSTreeNode    *rootNode;
@property (retain) SBCouchServer *couchServer;

-(id) initWithCouchServer:(SBCouchServer *)server;
-(BOOL)fetchReturnedData;

@end
