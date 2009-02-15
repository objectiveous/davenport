//
//  SVAbstractIntegrationTest.h
//  Davenport
//
//  Created by Robert Evans on 2/2/09.
//  Copyright 2009 South And Valley. All rights reserved.
//
#import "GTMSenTestCase.h"
#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>

@interface SVAbstractIntegrationTest : SenTestCase {
    SBCouchServer *couchServer;
    SBCouchDatabase *couchDatabase;
    BOOL leaveDatabase;    
}

@property (retain) SBCouchServer *couchServer;
@property (retain) SBCouchDatabase *couchDatabase;
@property BOOL leaveDatabase; 

-(SBCouchResponse*)provisionViews;
-(NSString*)designDocName;
@end
