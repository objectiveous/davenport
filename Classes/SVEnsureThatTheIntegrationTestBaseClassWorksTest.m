#import <SenTestingKit/SenTestingKit.h>
#import "SVFetchQueryInfoOperation.h"
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"


@interface SVEnsureThatTheIntegrationTestBaseClassWorksTest : SVAbstractIntegrationTest{
}
@end

@implementation SVEnsureThatTheIntegrationTestBaseClassWorksTest

-(void)testServerAndTestDatabaseWork{
    STAssertNotNULL(self.couchServer, @"Missing server");
    STAssertNotNULL(self.couchDatabase, @"Missing database");
}

-(void)testTestViewsAreProvisioned{
    SBCouchResponse *response = [self provisionViews];
    STAssertNotNULL(response, @"Missing response");
    STAssertTrue(response.ok, @"Response not okay");
    SVDebug(@"response ", response.name);
}


@end
