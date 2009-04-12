//
//  SVQueryResultController.h
//  
//
//  Created by Robert Evans on 1/8/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>


@class DPSharedController;
@class DPContributionNavigationDescriptor;

@interface SVQueryResultController : NSViewController <DPSharedController>{
    NSString               *databaseName;
    SBCouchEnumerator      *queryResult;
    SBCouchDatabase        *couchDatabase;

    IBOutlet NSOutlineView *viewResultOutlineView;
    IBOutlet NSTextField   *resultCountSummaryTextField;
    IBOutlet NSButton      *nextBatch;
    IBOutlet NSButton      *previousBatch; 
    
}

@property (copy)              NSString          *databaseName;
@property (retain)            SBCouchEnumerator *queryResult;
@property (retain)            SBCouchDatabase   *couchDatabase;
@property (retain)            NSOutlineView     *viewResultOutlineView;
@property (nonatomic, retain) NSTextField       *resultCountSummaryTextField;
@property (nonatomic, retain) NSButton          *nextBatch;
@property (nonatomic, retain) NSButton          *previousBatch;

@end
