//
//  SVFunctionEditorController.h
//  
//
//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SVInspectorFunctionDocumentController.h"
#import <CouchObjC/CouchObjC.h>


@interface SVInspectorFunctionDocumentController : NSViewController {
    
    IBOutlet NSTextView            *mapTextView;
    IBOutlet NSTextView            *reduceTextView;
             NSTreeNode            *treeNode;
             SBCouchDesignDocument *designDocument;
}
@property (nonatomic, retain) NSTextView            *mapTextView;
@property (nonatomic, retain) NSTextView            *reduceTextView;
@property (nonatomic, retain) NSTreeNode            *treeNode;
@property (nonatomic, retain) SBCouchDesignDocument *designDocument;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil treeNode:(NSTreeNode *)node;
- (IBAction)runFunction:(id)sender;
@end
