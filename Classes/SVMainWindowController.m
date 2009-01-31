//
//  STIGMainWindowController.m
//  stigmergic
//
//  Created by Robert Evans on 12/29/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "SVMainWindowController.h"
#import "SVAbstractDescriptor.h"
#import "SVSourceListCell.h"
#import "NSTreeNode+SVDavenport.h"
#import "SVBreadCrumbCell.h"
#import "SVQueryResultController.h"
#import "SVFunctionEditorController.h"
#import "SVCouchDocumentController.h"
#import <CouchObjC/CouchObjC.h>
#import "SVDatabaseDescriptor.h"
#import "SVAppDelegate.h"
#import "SVDatabaseCreateSheetController.h"

// XXX these thingies need to be defined in one place only. 
//     
#define QUERIES                 @"QUERIES"
#define DATABASES               @"DATABASES"
#define TOOLS                   @"TOOLS"

// Source List column names used in IB. 
#define COLUMNID_LABEL			@"LabelColumn"	
#define COLUMNID_INFO			@"InfoColumn"
@interface SVMainWindowController (Private)

-(void)updateBreadCrumbs:(NSTreeNode*)descriptor;

@end 

@implementation SVMainWindowController

@synthesize rootNode;
@synthesize urlImage;
@synthesize sourceView;
@synthesize dataViewController;
@synthesize adminView;
@synthesize bodyView;
@synthesize logView;
@synthesize inspectorView;
@synthesize controlBar;
@synthesize toolBar;
@synthesize outputView;
@synthesize pathControl;
@synthesize createDocumentToolBarItem;
@synthesize horizontalSplitView;

- (void)awakeFromNib{     
    
    
  	createDatabaseSheet = [[SVDatabaseCreateSheetController alloc] initWithWindowNibName:@"CreateDatabasePanel"];
    inspectorShowing = NO;
    [[self inspectorView] setHidden:YES];
   
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(removeBreadCrumb:)
                               name:@"removeBreadCrumb"
                             object:nil];    
            
    [notificationCenter addObserver:self
                           selector:@selector(appendBreadCrumb:)
                               name:@"appendBreadCrumb"
                             object:nil];    
    
    [self setUrlImage:[[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericURLIcon)] retain]];
    [[self urlImage] setSize:NSMakeSize(16,16)];
    
	[pathControl setFrameSize: NSMakeSize([pathControl bounds].size.width,27)];     
}

-(void) dealloc{
    [urlImage release];
    [rootNode release];
    [super dealloc];
}

- (void)performUpdateRoot:(NSTreeNode *)inObject{
    [self setRootNode:inObject];
}

#pragma mark -
#pragma mark NSOutlineViewDataSource delegate

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if(item == nil){
        return [[(NSTreeNode *)rootNode childNodes] count];
    }else{
        return  [[item childNodes] count];
    }        
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return (item == nil) ? YES : ([[item childNodes] count] >  0);
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return (item == nil) ? [[(NSTreeNode *)rootNode childNodes] objectAtIndex:index] : [[(NSTreeNode *)item childNodes] objectAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn 
           byItem:(id)item {

    if ([[tableColumn identifier] isEqualToString:COLUMNID_LABEL])
        return [[(NSTreeNode*) item representedObject] label];
    
    return nil;
}

- (BOOL)isSpecialGroup:(SVAbstractDescriptor *)groupNode{ 
	return ([groupNode nodeIcon] == nil &&
			[[groupNode label] isEqualToString:DATABASES] || [[groupNode label] isEqualToString:TOOLS] || [[groupNode label] isEqualToString:QUERIES]);
}

#pragma mark -
#pragma mark - NSOutlineView delegate

-(BOOL)outlineView:(NSOutlineView*)outlineView isGroupItem:(id)item{
    if ([self isSpecialGroup:[item representedObject]]){
        [outlineView expandItem:item];
		return YES;
	}else{
		return NO;
	}    
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item{
    return YES;
}

// Once opened it can't be closed. 
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(id)item{
    return NO;
}

// -------------------------------------------------------------------------------
//	shouldSelectItem:item
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;{
	// don't allow special group nodes (Devices and Places) to be selected
    SVAbstractDescriptor *node = [item representedObject];
	return (![self isSpecialGroup:node]);
}

// -------------------------------------------------------------------------------
//	outlineView:willDisplayCell
// -------------------------------------------------------------------------------
- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell 
     forTableColumn:(NSTableColumn *)tableColumn item:(id)item{
        
    if ([cell isKindOfClass:[SVSourceListCell class]]){
        if ([self isSpecialGroup:[item representedObject]]){
            [(SVSourceListCell*)cell setImage:nil];
        }else{
            [(SVSourceListCell*)cell setImage:urlImage];
        }        
    }        
    
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowCellExpansionForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    return NO;
}

#pragma mark -
#pragma mark SourceView Selection Handlers and Supporting Methods

- (void)outlineViewSelectionDidChange:(NSNotification *)notification{
    if([sourceView selectedRow] == -1)
        return;
            
    NSTreeNode *item = (NSTreeNode*)[sourceView itemAtRow: [sourceView selectedRow]];

    SVAbstractDescriptor *descriptor = [item representedObject];
    STIGDebug(@"Selection changed [%@]", [descriptor label]);
    [self updateBreadCrumbs:item];


    // TODO There ought to be some caching happening here.
    SVQueryResultController *queryResultController = [[SVQueryResultController alloc] initWithNibName:@"QueryResultView" 
                                                                                            bundle:nil 
                                                                                      databaseName:[descriptor label]
    ];
    
    
    // brutal
    for (NSView *view in [bodyView subviews]) {
        [view removeFromSuperview];
    }
    
    [bodyView addSubview:[queryResultController view]];
    
    NSRect frame = [[queryResultController view] frame];
    NSRect superFrame = [bodyView frame];
    frame.size.width = superFrame.size.width;
    frame.size.height = superFrame.size.height;
    [[queryResultController view] setFrame:frame];
    
}


#pragma mark -

// TODO This is only partially completed and will break when we add Tool 
// support. It's okay for now because we don't really understand where the 
// design is headed. 
-(void)updateBreadCrumbs:(NSTreeNode*)item{    
    //STIGAbstractDescriptor *parentDescriptor = [[item parentNode] representedObject];
    // Hard coding the root element name. Temporary. 
    SVBreadCrumbCell *rNode = [[[SVBreadCrumbCell alloc] initWithPathLabel:@"Database"] autorelease];
    SVBreadCrumbCell *dbNode   = [[[SVBreadCrumbCell alloc] initWithPathLabel:[[item representedObject] label]] autorelease];
    
    NSArray *cells = [NSArray arrayWithObjects:rNode, dbNode, nil];
    [pathControl setPathComponentCells:cells];
    [pathControl setNeedsDisplay];    
}

-(void) appendBreadCrumb:(NSNotification*)notification{
    id pathLabel = [notification object];
    
    NSArray *currentPath = [pathControl pathComponentCells];
    
    // The idea here is that there will always be a subject area path that consists of two 
    // elements. i.e. Database > dbName 
    // 
    STIGDebug(@"count of breadcrumb items [%i]", [currentPath count]);
    if([currentPath count] >= 3){
        [self removeBreadCrumb:nil];
    }
    
    
    NSMutableArray *newPath = [NSMutableArray arrayWithArray:currentPath];
    
    SVBreadCrumbCell *newNode = [[[SVBreadCrumbCell alloc] initWithPathLabel:[pathLabel description]] autorelease];
    [newPath addObject:newNode];
    [pathControl setPathComponentCells:newPath];
}

-(void) removeBreadCrumb:(NSNotification*)notification{
    NSArray *currentPath = [pathControl pathComponentCells];
    NSMutableArray *newPath = [NSMutableArray arrayWithArray:currentPath];
    [newPath removeLastObject];
    
    [pathControl setPathComponentCells:newPath];
}

#pragma mark -
#pragma mark ToolBar Delegate and Action Handlers
- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem{
    //if ([theItem tag] == 1001) // Save toolbar item
     //   return [self isDocumentEdited];
    return YES;
}

- (IBAction)showLogView:(id)sender{
    [[self window] setContentView:logView];    
}

- (IBAction)showAdminView:(id)sender{
    [[self window] setContentView:adminView];
}

- (IBAction)showCreateDocument:(id)sender{
    //[[self window] setContentView:logView];
    STIGDebug(@"Okay, so we got the message. ");
}

- (IBAction)showInspector:(id)sender{
    //[[self window] setContentView:logView];
    STIGDebug(@"Show the inspector to the user. ");
    if(inspectorShowing){  // Inspector is currently showing, so hide it. 
        [[self inspectorView] setHidden:YES];
        inspectorShowing = NO;
    }else{                 // Inspector is currently hidden, so show it. 
        [[self inspectorView] setHidden:NO];        
        inspectorShowing = YES;    
          }        
}

#pragma mark -

- (void)dataReady:(NSNotification *)notification{
    NSData *data = [[notification userInfo] valueForKey:NSFileHandleNotificationDataItem];
    if ([data length]) {
        [self appendData:data];
    }
    
    if([[notification object] isKindOfClass:[NSFileHandle class]])
        [[notification object] readInBackgroundAndNotify];
}

- (void)appendData:(NSData *)data{
    NSString *logMsg = [[NSString alloc] initWithData: data
                                             encoding: NSUTF8StringEncoding];
    NSTextStorage *textStorage = [[self outputView] textStorage];
    [textStorage replaceCharactersInRange:NSMakeRange([textStorage length], 0) withString:logMsg];
    [outputView scrollRangeToVisible:NSMakeRange([textStorage length], 0)];
        
    [logMsg release];
    
}

#pragma mark -
#pragma mark ContextMenu Handlers and Delegate Methods

/*
 Controls what menu items are shown for a given NSOutlineView selection. 
 */
- (void)menuNeedsUpdate:(NSMenu *)menu {
    NSInteger clickedRow = [sourceView clickedRow];
    
    if(clickedRow == -1)
        return;
        
    NSTreeNode *item = [sourceView itemAtRow:clickedRow];
    SVAbstractDescriptor *descriptor = [item representedObject];
            
    if(! [descriptor isKindOfClass:[SVDatabaseDescriptor class]]){
        // hide all the menu items. This will prevent any context menu from appearing. 
        for(NSMenuItem *i in [menu itemArray]){
            [i setHidden:TRUE];
        }
    }else{
        NSMenuItem *menuItem = [menu itemAtIndex:0];
        [menuItem setTitle:[NSString stringWithFormat:@"Delete '%@'", [descriptor label]]];    
        [menuItem setRepresentedObject:item];    
        // Ensure the menu items are visible. 
        for(NSMenuItem *i in [menu itemArray]){
            [i setHidden:FALSE];
        }
    }

}

- (IBAction)deleteDatabaseAction:(id)sender{
    if(![sender isKindOfClass:[NSMenuItem class]])
        return;

    NSTreeNode *item = (NSTreeNode*)[(NSMenuItem*)sender representedObject];        
    SVDatabaseDescriptor *descriptor = [item representedObject];
    
    SVDebug(@"Going to delete database [%@]", [descriptor label]);

    SBCouchServer *couchServer = [(SVAppDelegate*)[NSApp delegate] couchServer];
    BOOL didDelete = [couchServer deleteDatabase:[descriptor label]];
    
    if(didDelete){
        [[[item parentNode] mutableChildNodes] removeObject:item];
        [self.sourceView reloadData];
    }
}

- (IBAction)createDatabaseAction:(id)sender{
    SVDebug(@"Show a view for database");
    
	NSString  *newDatabaseName = [createDatabaseSheet edit:nil from:self];
	if (![createDatabaseSheet wasCancelled] && newDatabaseName){
        SBCouchServer *couchServer = [(SVAppDelegate*)[NSApp delegate] couchServer];
        [couchServer createDatabase:newDatabaseName];
        // Now reaload all the datafrom the server. 
        [(SVAppDelegate*)[NSApp delegate] performFetchServerInfoOperation];    
	}
}
@end

#pragma mark -
#pragma mark - DisclosureTriangleAdditions delegate

@implementation NSObject(DisclosureTriangleAdditions)
-(BOOL)outlineView:(NSOutlineView*)outlineView shouldShowDisclosureTriangleForItem:(id)item{
    return NO;
}


@end


