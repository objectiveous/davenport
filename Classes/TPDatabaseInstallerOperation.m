//
//  TPDatabaseInstallerOperation.m
//  Davenport
//
//  Created by Robert Evans on 2/19/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "TPDatabaseInstallerOperation.h"
#import <CouchObjC/CouchObjC.h>
#import "DPResourceFactory.h"
#import "DPContributionPlugin.h"
#import "TPPlugin.h"
#import "SVConstants.h"

@interface TPDatabaseInstallerOperation (Private)
- (BOOL)installViews;
@end

@implementation TPDatabaseInstallerOperation
@synthesize couchServer; 
@synthesize cushionDatabase; 

-(void)main{
    self.couchServer = [SBCouchServer new];
    NSArray *localDatabases = [couchServer listDatabases];
    if( [localDatabases containsObject:[TPPlugin databaseName]] )
        return;
    
    BOOL succeedded = [couchServer createDatabase:[TPPlugin databaseName]];
    if(succeedded){
        self.cushionDatabase = [self.couchServer database:[TPPlugin databaseName]];
        [self installViews];
        [[NSNotificationCenter defaultCenter] postNotificationName:DPLocalDatabaseNeedsRefreshNotification object:nil];
    }        
}

-(BOOL)installViews{
    //SBCouchDesignDocument *mileStoneDesignDoc = [[[SBCouchDesignDocument alloc] initWithDesignDomain:@"milestones"] autorelease];
    SBCouchResponse *response2 = [self.cushionDatabase putDocument:[[[SBCouchDesignDocument alloc] initWithName:@"Ticket Bins"] autorelease]];
    SBCouchResponse *response = [self.cushionDatabase putDocument:[[[SBCouchDesignDocument alloc] initWithName:@"Milestones"] autorelease]];
    
    if(response.ok && response2.ok)
        return TRUE;
    else
        return FALSE;
}
@end
