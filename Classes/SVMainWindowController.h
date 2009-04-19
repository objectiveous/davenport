//
//  SVMainWindowController.h
//
//  Created by Robert Evans on 12/29/08.
//  Copyright 2008 South And Valley. All rights reserved.
//
 
#import <Cocoa/Cocoa.h>

#import <RBSplitView/RBSplitView.h>
#import <RBSplitView/RBSplitSubview.h>
#import <BWToolkitFramework/BWSplitView.h>

@class SVControlBarView;
@class SVPathControl;
@class SVEmptyInspectorView;
@class DPResourceFactory;
@class SVDatabaseCreateSheetController;


@interface SVMainWindowController : NSWindowController <DPResourceFactory>{
    IBOutlet NSOutlineView	         *sourceView;    
    IBOutlet SVEmptyInspectorView    *emptyInspectorView;
    IBOutlet SVEmptyInspectorView    *emptyBodyView;
    
    IBOutlet NSView                  *adminView;
    IBOutlet NSView                  *bodyView;
    IBOutlet RBSplitSubview          *inspectorView;
    IBOutlet RBSplitView             *horizontalSplitView;
    
    IBOutlet NSView                  *logView;
    IBOutlet NSTextView              *outputView;
    IBOutlet SVControlBarView        *controlBar;
    IBOutlet SVPathControl           *pathControl;    
    IBOutlet NSToolbar               *toolBar;
    IBOutlet NSToolbarItem           *createDocumentToolBarItem;

    IBOutlet NSMenu                  *outlineViewContextMenu;
    
    NSViewController                 *dataViewController;
    NSTreeNode                       *rootNode;
   	NSImage                          *urlImage;
    BOOL                              inspectorShowing;    
    SVDatabaseCreateSheetController  *createDatabaseSheet;

@private
    NSOperationQueue                 *operationQueue;
    NSLock                           *lock;
    NSBundle                         *bundle;
}

@property (retain)            NSTreeNode           *rootNode;
@property (retain)            NSImage              *urlImage;
@property (nonatomic, retain) NSOutlineView        *sourceView;
@property (nonatomic, retain) NSViewController     *dataViewController;
@property (nonatomic, retain) NSView               *adminView;
@property (nonatomic, retain) NSTextView           *outputView;
@property (nonatomic, retain) NSView               *bodyView;
@property (nonatomic, retain) NSView               *logView;
@property (nonatomic, retain) SVControlBarView     *controlBar;

@property (nonatomic, retain) NSToolbar            *toolBar;
@property (nonatomic, retain) NSToolbarItem        *createDocumentToolBarItem;
@property (nonatomic, retain) SVPathControl        *pathControl;
@property (nonatomic, retain) RBSplitSubview       *inspectorView;
@property (nonatomic, retain) RBSplitView          *horizontalSplitView; 
@property (nonatomic, retain) SVEmptyInspectorView *emptyInspectorView;
@property (nonatomic, retain) SVEmptyInspectorView *emptyBodyView;
@property (retain)            NSBundle             *bundle;
@property (retain)            SVDatabaseCreateSheetController *createDatabaseSheet;

- (void)appendNSTreeNodeToNavigationRootNode:(NSTreeNode *)treeToAppend;

#pragma mark -
#pragma mark Actions
// TOOLBAR HANDLERS
- (IBAction)showLogView:(id)sender;
- (IBAction)showAdminView:(id)sender;
- (IBAction)showCreateDocument:(id)sender;
- (IBAction)showInspector:(id)sender;
- (IBAction)refreshServerNodeAction:(id)sender;

// CONTEXT MENU HANDLERS
- (IBAction)deleteItemAction:(id)sender;
- (IBAction)createDatabaseAction:(id)sender;
- (IBAction)refreshDatabaseAction:(id)sender;

#pragma mark -
- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem;
- (void)appendData:(NSData *)data;
- (void)delagateSelectionDidChange:(NSTreeNode*)item;

#pragma mark -
#pragma mark Notification Handlers
// Notification handlers. 
// XXX This should be private methods, no? 
- (void) removeBreadCrumb:(NSNotification*)notification;
- (void) appendBreadCrumb:(NSNotification*)notification;
- (void) loadPluginsNavigationContributions:(NSNotification*)notification;
- (void) displayViewInBodyAction:(NSNotification*)notification;

- (void) testBinding;
@end
