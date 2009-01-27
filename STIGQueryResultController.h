//
//  STIGQueryResultController.h
//  stigmergic
//
//  Created by Robert Evans on 1/8/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>


@interface STIGQueryResultController : NSViewController {
    NSString          *databaseName;
    SBCouchEnumerator *queryResult;
    SBCouchDatabase   *couchDatabase;
}

@property (copy) NSString            *databaseName;
@property (retain) SBCouchEnumerator *queryResult;
@property (retain) SBCouchDatabase   *couchDatabase;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil databaseName:(NSString *)dbName; 
@end
