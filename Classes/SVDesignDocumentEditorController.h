//
//  SVFunctionEditorController.h
//  
//
//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SVDesignDocumentEditorController.h"
#import <CouchObjC/CouchObjC.h>
#import "DPContributionNavigationDescriptor.h"
#import "DPSharedController.h"

@class SVSaveViewAsSheetController;

@interface SVDesignDocumentEditorController : NSViewController <DPSharedController>{
    
    IBOutlet NSTextView                     *mapTextView;
    IBOutlet NSTextView                     *reduceTextView;
    IBOutlet NSComboBox                     *viewComboBox;
    IBOutlet NSButton                       *saveButton;
    IBOutlet NSButton                       *saveAsButton;
    
    SVSaveViewAsSheetController             *saveViewAsController;
    SBCouchDesignDocument                   *designDocument;
    id <DPContributionNavigationDescriptor> navContribution;
    // Might want to make this a weak reference using the __weak type modifier.
    id delegate;
    @private
    BOOL                                    isDirty;
}
@property (nonatomic, retain) NSTextView                   *mapTextView;
@property (nonatomic, retain) NSTextView                   *reduceTextView;
@property (nonatomic, retain) NSComboBox                   *viewComboBox;
@property (nonatomic, retain) SBCouchDesignDocument        *designDocument;
@property (nonatomic, retain) NSButton                     *saveButton;
@property (nonatomic, retain) NSButton                     *saveAsButton;
@property (retain) id <DPContributionNavigationDescriptor> navContribution;
@property                     BOOL                         isDirty;
@property (nonatomic, retain) SVSaveViewAsSheetController  *saveViewAsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil navContribution:(id <DPContributionNavigationDescriptor>)aNavContribution;
- (id)delegate;
- (void)setDelegate:(id)newDelegate;

#pragma mark - Action Handlers
- (IBAction)runCouchViewAction:(id)sender;
- (IBAction)saveDesignDocumentAction:(id)sender;
- (IBAction)saveAsDesignDocumentAction:(id)sender;
- (IBAction)saveViewAsAction:(id)sender;
@end
