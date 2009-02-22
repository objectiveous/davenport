//
//  TPDatabaseInstallerOperation.h
//  Davenport
//
//  Created by Robert Evans on 2/19/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>

@interface TPDatabaseInstallerOperation : NSOperation {
    SBCouchServer   *couchServer;
    SBCouchDatabase *cushionDatabase;
}

@property (retain) SBCouchServer   *couchServer;
@property (retain) SBCouchDatabase *cushionDatabase;

@end
