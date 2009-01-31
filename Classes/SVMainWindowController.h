//
//  STIGMainWindowController.h
//  stigmergic
//
//  Created by Robert Evans on 12/29/08.
//  Copyright 2008 South And Valley. All rights reserved.
//
 
#import <Cocoa/Cocoa.h>
#import "SVControlBarView.h"
#import "SVPathControl.h"
#import <RBSplitView/RBSplitView.h>
#import <RBSplitView/RBSplitSubview.h>
#import <BWToolkitFramework/BWSplitView.h>

@class SVDatabaseCreateSheetController;

@interface SVMainWindowController : NSWindowController {
    IBOutlet NSOutlineView	         *sourceView;
    IBOutlet NSView                  *adminView;
    IBOutlet NSView                  *bodyView;
    IBOutlet NSView                  *logView;

    IBOutlet NSTextView              *outputView;
    IBOutlet SVControlBarView        *controlBar;
    IBOutlet SVPathControl           *pathControl;    
    IBOutlet NSToolbar               *toolBar;
    IBOutlet NSToolbarItem           *createDocumentToolBarItem;
    IBOutlet RBSplitSubview          *inspectorView;
    IBOutlet RBSplitView             *horizontalSplitView;

    IBOutlet NSMenu                  *outlineViewContextMenu;
    
    NSViewController                 *dataViewController;
    NSTreeNode                       *rootNode;
   	NSImage                          *urlImage;
    BOOL                              inspectorShowing;
    
    SVDatabaseCreateSheetController  *createDatabaseSheet;
}

@property (retain)  NSTreeNode                    *rootNode;
@property (retain)  NSImage                       *urlImage;
@property (nonatomic, retain) NSOutlineView       *sourceView;
@property (nonatomic, retain) NSViewController    *dataViewController;
@property (nonatomic, retain) NSView              *adminView;
@property (nonatomic, retain) NSTextView          *outputView;
@property (nonatomic, retain) NSView              *bodyView;
@property (nonatomic, retain) NSView              *logView;
@property (nonatomic, retain) SVControlBarView    *controlBar;
@property (nonatomic, retain) NSToolbar           *toolBar;
@property (nonatomic, retain) NSToolbarItem       *createDocumentToolBarItem;
@property (nonatomic, retain) SVPathControl       *pathControl;
@property (nonatomic, retain) RBSplitSubview      *inspectorView;
@property (nonatomic, retain) RBSplitView         *horizontalSplitView; 

// TOOLBAR HANDLERS
- (IBAction)showLogView:(id)sender;
- (IBAction)showAdminView:(id)sender;
- (IBAction)showCreateDocument:(id)sender;
- (IBAction)showInspector:(id)sender;

// CONTEXT MENU HANDLERS
- (IBAction)deleteDatabaseAction:(id)sender;
- (IBAction)createDatabaseAction:(id)sender;

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem;
- (void)appendData:(NSData *)data;

// Notification handlers
-(void) removeBreadCrumb:(NSNotification*)notification;
-(void) appendBreadCrumb:(NSNotification*)notification;

@end
