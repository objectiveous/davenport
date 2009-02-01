
#import "GTMSenTestCase.h"
#import <CouchObjC/CouchObjC.h>

@interface SVCreateAndLoadSampleDatabaseTest : SenTestCase{
    SBCouchServer *couchServer;
}
@end

@implementation SVCreateAndLoadSampleDatabaseTest


- (void)testCreateTestDatabase{

    NSString *name = @"database-for-test";

    SBCouchDatabase *db = [[couchServer database:name] retain];
    
    for (int i =0; i < 200; i++) {
        NSDictionary *doc = [NSDictionary dictionary];
        SBCouchResponse *meta = [db postDocument:doc];
        SVDebug(@"[%@]", meta);
        STAssertTrue(meta.ok, nil);
        STAssertNotNil(meta.name, nil);
        STAssertNotNil(meta.rev, nil);
    }
    

}

#pragma mark -
- (void)setUp {
    couchServer = [SBCouchServer new];
}

- (void)tearDown {
    [couchServer release];
}
@end
