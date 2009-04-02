//
//  SVFetchServerInfoOperation.h
//  
//
//  Created by Robert Evans on 12/30/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/SBCouchServer.h>
#import "DPResourceFactory.h"
#import "SVAbstractCouchNodeOperation.h"
@interface SVFetchServerInfoOperation : SVAbstractCouchNodeOperation {
@protected
    SBCouchServer          *couchServer;
}

@property (retain) SBCouchServer          *couchServer;

-(id) initWithCouchServer:(SBCouchServer *)server rootTreeNode:(NSTreeNode*)rootTreeNode;

@end
