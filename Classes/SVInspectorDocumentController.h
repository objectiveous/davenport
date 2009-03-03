//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>
#import "SVControlBarView.h"

@interface SVInspectorDocumentController : NSViewController {
    IBOutlet SVControlBarView     *documentControlBar;
    IBOutlet NSOutlineView        *documentOutlineView;
    IBOutlet NSTextField          *versionTextField;
    IBOutlet NSButton             *nextRevisionButton;
    IBOutlet NSButton             *previousRevisionButton;
    IBOutlet NSButton             *saveButton;
    
    SBCouchDocument               *couchDocument;
    SBCouchDatabase               *couchDatabase;
    NSTreeNode                    *rootNode;    
    NSString                      *documentIdentity;
    
    // The number of revisions for the doc we are showing. Note, documents 
    // only know about past revisions, so the next revision of couchDocuemnt 
    // will have count+1
    NSInteger                     numberOfRevisions;
    NSInteger                     currentRevision;
    NSArray                      *revisions;
    
}

@property (retain) SVControlBarView     *documentControlBar;
@property (retain) NSOutlineView        *documentOutlineView;
@property (retain) SBCouchDocument      *couchDocument;
@property (retain) SBCouchDatabase      *couchDatabase;
@property (retain) NSTextField          *versionTextField;
@property (retain) NSButton             *nextRevisionButton;
@property (retain) NSButton             *previousRevisionButton;
@property (retain) NSButton             *saveButton;
@property (retain) NSArray              *revisions;
@property (retain) NSTreeNode           *rootNode;
@property (retain) NSString             *documentIdentity;
@property NSInteger numberOfRevisions;
@property NSInteger currentRevision;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil couchDocument:(SBCouchDocument *)couchDBDocument couchDatabase:(SBCouchDatabase*)couchDB;

-(IBAction)showPreviousRevisionAction:(id)sender;
-(IBAction)showNextRevisionAction:(id)sender;
-(IBAction)saveDocumentAction:(id)sender;
-(IBAction)refreshDocumentAction:(id)sender;

-(void)updateRevisionInformationLabelAndNavigation;
-(void)reloadDocument;
@end
