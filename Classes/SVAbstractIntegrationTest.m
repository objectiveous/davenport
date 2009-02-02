//
//  SVAbstractIntegrationTest.m
//  Davenport
//
//  Created by Robert Evans on 2/2/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVAbstractIntegrationTest.h"

@implementation SVAbstractIntegrationTest

#pragma mark -
- (void)setUp {
    // Better safe than sorry
    srandom(time(NULL));
    couchServer = [[SBCouchServer alloc] initWithHost:@"localhost" port:5984];
}



- (void)tearDown {
    [couchServer release];
}

@end
