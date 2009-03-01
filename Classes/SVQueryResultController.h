//
//  SVQueryResultController.h
//  
//
//  Created by Robert Evans on 1/8/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>
#import "DPContributionNavigationDescriptor.h"

@interface SVQueryResultController : NSViewController {
    NSString               *databaseName;
    NSEnumerator           *queryResult;
    SBCouchDatabase        *couchDatabase;
    IBOutlet NSOutlineView *viewResultOutlineView;
}

@property (copy) NSString            *databaseName;
@property (retain) NSEnumerator      *queryResult;
@property (retain) SBCouchDatabase   *couchDatabase;
@property (retain) NSOutlineView     *viewResultOutlineView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil navContribution:(id <DPContributionNavigationDescriptor>)aNavContribution;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil couchEnumeration:(NSEnumerator*)anSBCouchEnumerator;
- (void)showViewResults:(SBCouchEnumerator*)viewResults;
@end
