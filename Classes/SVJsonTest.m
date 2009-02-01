//
//  JsonTest.m
//  
//
//  Created by Robert Evans on 1/19/09.
//  Copyright 2009 South And Valley. All rights reserved.
//



#import "GTMSenTestCase.h"
#import "SVDavenport.h"
#import <CouchObjC/CouchObjC.h>
#import <JSON/JSON.h>
@interface SVJsonTest : SenTestCase{
}
@end

@implementation SVJsonTest


-(void)testJsonParsingLocal{
    //
    SBCouchServer *server = [[[SBCouchServer alloc] initWithHost:@"localhost" port:5984] autorelease];
    SBCouchDatabase *database = [server database:@"database-for-test"];
    
    NSDictionary *doc = [database get:@"00f359337e7e16e6a2430df3cc7506b0"];
    STAssertNotNULL(doc, nil);
}


-(void)testJsonParsingRemote{
    //
    SBCouchServer *server = [[[SBCouchServer alloc] initWithHost:@"jchris.mfdz.com" port:5984] autorelease];
    SBCouchDatabase *database = [server database:@"twitter-client"];    
    NSDictionary *doc = [database get:@"000daeafe428da1df0f0e76056e84b16"];
    
    SVDebug(@"WTF [%@]", [doc JSONRepresentation] );
}

@end
