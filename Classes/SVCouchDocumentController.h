//
//  SVCouchDocument.h
//  
//
//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>
#import "SVControlBarView.h"

@interface SVCouchDocumentController : NSViewController {
    IBOutlet SVControlBarView   *documentControlBar;
    IBOutlet NSOutlineView      *documentOutlineView;
    IBOutlet NSTextField        *versionTextField;
    IBOutlet NSButton           *nextRevisionButton;
    IBOutlet NSButton           *previousRevisionButton;    
    
    SBCouchDocument             *couchDocument;
    SBCouchDatabase             *couchDatabase;
    
    // The number of revisions for the doc we are showing. Note, documents 
    // only know about past revisions, so the next revision of couchDocuemnt 
    // will have count+1
    NSInteger                   numberOfRevisions;
    NSInteger                   currentRevision;    
    NSArray                     *revisions;

}

@property (retain) SVControlBarView   *documentControlBar;
@property (retain) NSOutlineView      *documentOutlineView;
@property (retain) SBCouchDocument    *couchDocument;
@property (retain) SBCouchDatabase    *couchDatabase;
@property (retain) NSTextField        *versionTextField;
@property (retain) NSButton           *nextRevisionButton;
@property (retain) NSButton           *previousRevisionButton;
@property (retain) NSArray            *revisions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil couchDocument:(NSDictionary *)couchDBDocument couchDatabase:(SBCouchDatabase*)couchDB;

-(IBAction)showPreviousRevisionAction:(id)sender;
-(IBAction)showNextRevisionAction:(id)sender;

-(void)updateRevisionInformationLabelAndNavigation;
@end
