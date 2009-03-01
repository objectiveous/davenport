//
//  TPLoadNavigationOperationTest.m
//  Davenport
//
//  Created by Robert Evans on 2/23/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVAbstractIntegrationTest.h"
#import "TPLoadNavigationOperation.h"
#import "NSTreeNode+SVDavenport.h"

@interface TPLoadNavigationOperationTest : SVAbstractIntegrationTest <DPResourceFactory>{
    TPLoadNavigationOperation *loadNavOperation;
}

@end

@implementation TPLoadNavigationOperationTest

-(void)setUp{
    [super setUp];
    [self loadDavenportPlugins];
    NSBundle *bundle = [self.loadedPlugins objectForKey:@"TPPlugin"];
    Class operation = [bundle classNamed:@"TPLoadNavigationOperation"];
    loadNavOperation = [[operation alloc] initWithResourceFactory:self];
}

-(void)tearDown{
    [loadNavOperation release];
    [super tearDown];
}

#pragma mark -
#pragma mark Tests
-(void) testExecOperation{
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:loadNavOperation];
    [queue waitUntilAllOperationsAreFinished];
    
    STAssertNotNil([loadNavOperation rootContributionNode], @"Operation failed to return NSTreeNode ");

    [[loadNavOperation rootContributionNode] logTree];
    [queue release];
}

#pragma mark -
#pragma mark DPResourceFactory Protocol 
-(id)namedResource:(DPSharedResources)resourceName navContribution:(id <DPContributionNavigationDescriptor>)aNavContribution{
    return nil;
}

@end
