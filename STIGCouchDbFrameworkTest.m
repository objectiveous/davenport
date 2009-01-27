#import "GTMSenTestCase.h"
#import <CouchObjC/CouchObjC.h>
#import "STIG.h"

@interface STIGCouchDbFrameworkTest : SenTestCase{
    SBCouchServer *couchDb;
}
@end

@implementation STIGCouchDbFrameworkTest

- (void)testSupportedVersion {
    id v = [couchDb version];
    STAssertTrue([v isGreaterThanOrEqualTo:@"0.8.1"], @"Version not supported: %@", v);
}

- (void)testDefaultHost {
    STAssertEqualObjects(couchDb.host, @"localhost", nil);
}

- (void)testDefaultPort {
    STAssertEquals(couchDb.port, (NSUInteger) 5984, nil);
}

- (void)testBasics{
    NSString *testDatabaseName= [NSString stringWithFormat:@"tmp%u", random()];
    STAssertTrue([couchDb createDatabase:testDatabaseName], nil);
    NSArray *list = [couchDb listDatabases];
    [list containsObject:testDatabaseName];    
    list = [couchDb listDatabases];    
    STIGDebug(@"[Databases %@]", list);

}

#pragma mark -
- (void)setUp {
    // Better safe than sorry
    srandom(time(NULL));
    couchDb = [[SBCouchServer alloc] initWithHost:@"localhost" port:5984];
}

- (void)tearDown {
    [couchDb release];
}
@end
