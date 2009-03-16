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

@interface SVDesignDocumentEditorController : NSViewController <DPSharedController>{
    
    IBOutlet NSTextView                     *mapTextView;
    IBOutlet NSTextView                     *reduceTextView;
    IBOutlet NSComboBox                     *viewComboBox;
    IBOutlet NSButton                       *saveButton;
    IBOutlet NSButton                       *saveAsButton;
    
    SBCouchDesignDocument                   *designDocument;
    id <DPContributionNavigationDescriptor> navContribution;
    // Might want to make this a weak reference using the __weak type modifier.
    id delegate;
}
@property (nonatomic, retain) NSTextView                   *mapTextView;
@property (nonatomic, retain) NSTextView                   *reduceTextView;
@property (nonatomic, retain) NSComboBox                   *viewComboBox;
@property (nonatomic, retain) SBCouchDesignDocument        *designDocument;
@property (nonatomic, retain) NSButton                     *saveButton;
@property (nonatomic, retain) NSButton                     *saveAsButton;
@property (retain) id <DPContributionNavigationDescriptor> navContribution;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil navContribution:(id <DPContributionNavigationDescriptor>)aNavContribution;
- (IBAction)runCouchViewAction:(id)sender;
- (id)delegate;
- (void)setDelegate:(id)newDelegate;

@end
