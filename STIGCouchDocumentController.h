//
//  STIGCouchDocument.h
//  stigmergic
//
//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>
#import "STIGControlBarView.h"

@interface STIGCouchDocumentController : NSViewController {
    IBOutlet STIGControlBarView *documentControlBar;
    IBOutlet NSOutlineView      *documentOutlineView;
    IBOutlet NSTextField        *versionTextField;
    
    SBCouchDocument             *couchDocument;
    SBCouchDatabase             *couchDatabase;
    
}

@property (retain) STIGControlBarView *documentControlBar;
@property (retain) NSOutlineView      *documentOutlineView;
@property (retain) SBCouchDocument    *couchDocument;
@property (retain) SBCouchDatabase    *couchDatabase;
@property (retain) NSTextField        *versionTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil couchDocument:(NSDictionary *)couchDBDocument couchDatabase:(SBCouchDatabase*)couchDB;
@end
