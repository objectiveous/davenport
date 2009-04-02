//
//  SVMainWindowController.m
//  
//
//  Created by Robert Evans on 12/29/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "SVMainWindowController.h"
#import "SVBaseNavigationDescriptor.h"
#import "SVSourceListCell.h"
#import "NSTreeNode+SVDavenport.h"
#import "SVBreadCrumbCell.h"
#import "SVQueryResultController.h"
#import "SVDesignDocumentEditorController.h"
#import "SVInspectorDocumentController.h"
#import <CouchObjC/CouchObjC.h>
#import "SVAppDelegate.h"
#import "SVDatabaseCreateSheetController.h"

#import "SVFetchQueryInfoOperation.h"
#import "SVDavenport.h"
#import "DPContributionNavigationDescriptor.h"
#import "DPContributionPlugin.h"
#import "SVFetchServerInfoOperation.h"
#import "SVPluginContributionLoaderOperation.h"
#import "DPContributionNavigationDescriptor.h"
#import "SVRefreshCouchDatabaseNodeOperation.h"

// XXX these thingies need to be defined in one place only. 
//     
#define QUERIES                 @"QUERIES"
#define DATABASES               @"DATABASES"
#define TOOLS                   @"TOOLS"

// Source List column names used in IB. 
#define COLUMNID_LABEL			@"LabelColumn"	
#define COLUMNID_INFO			@"InfoColumn"
// XXX Where do people typically put the names of their nibs? 
static NSString *NIB_DesignDocumentEditor = @"DesignDocumentEditor";
static NSString *NIB_QueryResultView = @"QueryResultView";

// PRIVATE INTERFACE
@interface SVMainWindowController (Private)

- (void)updateBreadCrumbs:(NSTreeNode*)descriptor;
- (void)fetchViews:(NSTreeNode*)designNode;
- (NSTreeNode*)locateCouchServerDescriptionWithinTree:(NSTreeNode*)aRootNode;
- (void)registerNotificationListeners;
- (void)loadPlugins;
- (void)autoExpandGroupItems;
// Methods used for adding Views into the Body or Inspector areas of the Davenport host. 
- (void)showCouchViewInBody:(id<DPContributionNavigationDescriptor>)navDescriptor;
- (void)showDesignEditorInMainView:(id<DPContributionNavigationDescriptor>)navDescriptor;
- (void)showDesignView:(id<DPContributionNavigationDescriptor>)navDescriptor;
- (void)showEmptyInspectorView;
- (void)showEmptyBodyView;
- (void)loadViewNodes:(NSTreeNode*)treeNode;
- (void)sizeViewToBody:(NSView*)aView;
- (void)sizeViewToInspector:(NSView*)aView;

- (void)refreshDatabaseNode:(NSNotification*)notification;
- (void)refreshServerNode:(NSNotification*)notification;

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
@synthesize emptyInspectorView;
@synthesize emptyBodyView;
@synthesize bundle;

- (void)awakeFromNib{
    // XXX This should live in the init. 
    lock = [[NSLock alloc] init];
    
    // The root node gets created early and callers are only allowed to append child nodes to it. 
    // This helps to support concurrency, e.g. each loaded plugin can asynchronously load navigation 
    // items into the rootNode and never worry it the root node has been created yet. Seems sorta obvious
    // but this is not how things worked at first and it caused some problems. 
    rootNode = [[NSTreeNode alloc] init];
    
  	createDatabaseSheet = [[SVDatabaseCreateSheetController alloc] initWithWindowNibName:@"CreateDatabasePanel"];
    inspectorShowing = YES;
    [[self inspectorView] setHidden:NO];
   
    [self registerNotificationListeners];
           
    [self setUrlImage:[[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericURLIcon)] retain]];
    [[self urlImage] setSize:NSMakeSize(16,16)];
	[pathControl setFrameSize: NSMakeSize([pathControl bounds].size.width,27)];
    
    [self loadPlugins];
}

- (void)loadPlugins{
    SVPluginContributionLoaderOperation *contributionLoader = [[SVPluginContributionLoaderOperation alloc] init];
    [contributionLoader start];            
    SVDebug(@"Contribution loader %@", contributionLoader.instances );
    
    for( id <DPContributionPlugin> plugin in contributionLoader.instances){
        NSString *uid = [plugin pluginID];
      
        [[[NSApp delegate] pluginRegistry] setObject:plugin forKey:uid];
        // This is likely to kick of NSOperations.                                 
        [plugin start];
        // And the call to navigationContribution might not be ready or would have to block. 
        // In other words, we have no idea WTF a plugin author might be doing when it starts....
        // So that rational thing to do is have a call back (i.e. a NSNotification) that says, 
        // Hey! you can load my nav now....
        
        //NSTreeNode *contributionRootNode = [plugin navigationContribution];
        //[[sourceViewModelRootNode mutableChildNodes] addObjectsFromArray:[contributionRootNode childNodes]];
    }            
    [contributionLoader release];
}

-(void) registerNotificationListeners{    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
    [notificationCenter addObserver:self
                           selector:@selector(loadPluginsNavigationContributions:)
                               name:DPContributionPluginDidLoadNavigationItemsNotification
                             object:nil]; 
    
    [notificationCenter addObserver:self
                           selector:@selector(removeBreadCrumb:)
                               name:@"removeBreadCrumb"
                             object:nil];    
    
    [notificationCenter addObserver:self
                           selector:@selector(appendBreadCrumb:)
                               name:@"appendBreadCrumb"
                             object:nil];    
    
    [notificationCenter addObserver:self
                           selector:@selector(refreshLocalDatabaseList:)
                               name:DPRunSlowViewNotification
                             object:nil];    
    
    [notificationCenter addObserver:self
                           selector:@selector(refreshDatabaseNode:)
                               name:DPLocalDatabaseNeedsRefreshNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(refreshServerNode:)
                               name:DPServerNeedsRefreshNotification
                             object:nil];
    

    
}





-(void) dealloc{
    [urlImage release];
    [operationQueue release];
    [lock release];
    [rootNode release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSOutlineViewDataSource delegate ( Left Hand Nav. )

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {          
    if(item == nil){
        NSInteger count =  [[(NSTreeNode *)rootNode childNodes] count];
        return count;
    }else{        
        NSInteger childCount = [[item childNodes] count];            
        return  childCount;        
    }        
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if (item == nil)
        return NO;
    
    id <DPContributionNavigationDescriptor, NSObject> desc = [item representedObject];
    
    if([desc type] == DPDescriptorCouchView)
        return NO;

    return YES;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if(item == nil)
        return [[(NSTreeNode *)rootNode childNodes] objectAtIndex:index];
        
    NSTreeNode *childNode = [[(NSTreeNode *)item childNodes] objectAtIndex:index];

    return childNode;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    if ([[tableColumn identifier] isEqualToString:COLUMNID_LABEL]){
        id navDescriptor = [(NSTreeNode*) item representedObject];
        if([navDescriptor conformsToProtocol:@protocol(DPContributionNavigationDescriptor)]);        
            return [navDescriptor label];

        return @"WTF";
    }            
    return nil;
}

// groupNode will need be an object conforming to our Navigation Descriptor protocol. 
- (BOOL)isSpecialGroup:(id)groupNode{     
    if([groupNode conformsToProtocol:@protocol(DPContributionNavigationDescriptor)]){
        return [groupNode isGroupItem];
    }
    return NO;
}

#pragma mark -
#pragma mark KVO


- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
    
    if([keyPath isEqual:@"isFinished"] && [object isKindOfClass:[SVFetchQueryInfoOperation class]]){        
        // We've added view descriptors to a design document descriptor and its time to refresh 
        // the source list. 
        //[lock lock];
        //[self.sourceView reloadData];
        //[lock unlock];
    } 
    if([keyPath isEqual:@"isFinished"] && [object isKindOfClass:[SVFetchServerInfoOperation class]]){        
        NSTreeNode *root = (NSTreeNode*) [(SVFetchServerInfoOperation*)object rootNode];

        NSTreeNode *oldServerDesc = [self locateCouchServerDescriptionWithinTree:rootNode];
        NSTreeNode *newServerDesc = [self locateCouchServerDescriptionWithinTree:root];
        
        NSMutableArray *oldDatabaseList = [oldServerDesc mutableChildNodes];
        NSArray *newDatabaseList = [newServerDesc childNodes];
        [oldDatabaseList removeAllObjects];
        [oldDatabaseList addObjectsFromArray:newDatabaseList];
        NSLog(@"database list count %i", [oldDatabaseList count]);
        
        //XXX This works but I have to wonder if it's the proper way to be doing these sorts of things. 
        //NSLock *lock = [[NSLock alloc] init];
        [lock lock];
        [self.sourceView reloadData];
        [lock unlock];
        
        // Now that we've got the top level elements, populate the design doc nodes. 
        // This might even be a good thing to put into an operation.        
        //[self loadViewNodes:rootNode];
    } 
}


#pragma mark -

- (void)loadViewNodes:(NSTreeNode*)treeNode{
    if(treeNode == nil)
        return;
    
    for(NSTreeNode *node in [self.rootNode childNodes]){
       id <DPContributionNavigationDescriptor> descriptor = [node representedObject];
        if([descriptor type] == DPDescriptorCouchDesign){
            //[self fetchViews:node];
            //return;
        }else{
            //[self loadViewNodes:node];
        }
    }
    
    //[lock lock];
    //[self.sourceView reloadData];
    //[lock unlock];
}

/*
- (void)outlineViewItemWillExpand:(NSNotification *)notification{ 
    id treeNode = [[notification userInfo] objectForKey:@"NSObject"];
    if(treeNode && [treeNode isKindOfClass:[NSTreeNode class]]){
        SVBaseNavigationDescriptor *desc = [treeNode representedObject];
        // Hard coding this for now but it could possibly be supported in the protocol. Or we might just want to expand everything. 
        if([desc isKindOfClass:[SVBaseNavigationDescriptor class]]){
            //[desc.couchDatabase]

            id couchObject = [[desc userInfo] objectForKey:@"couchobject"];
            if(couchObject && desc.type == DPDescriptorCouchDatabase){
                for(NSTreeNode *child in [treeNode childNodes]){
                    id <DPContributionNavigationDescriptor, NSObject> childDesc = [child representedObject]; 
                    SBCouchDesignDocument *couchDesignDocument = [[childDesc userInfo] objectForKey:@"couchobject"];
                    NSLog(@"%@", couchDesignDocument);
                    NSLog(@"%@", [couchDesignDocument views]);
                    
                    NSDictionary *dictionaryOfViews =  [couchDesignDocument views];
                    for(SBCouchView *viewName in dictionaryOfViews){
                        SBCouchView *couchView = [dictionaryOfViews objectForKey:viewName];
                        SBCouchEnumerator *viewResults = (SBCouchEnumerator*) [couchView getEnumerator];
                        SVBaseNavigationDescriptor *slug = [[SVBaseNavigationDescriptor alloc] initWithLabel:@"AAAA" andIdentity:@"AAAA" type:DPDescriptorCouchView userInfo:nil];

                        [[treeNode mutableChildNodes] addObject:[NSTreeNode treeNodeWithRepresentedObject:slug]];
                    }
                }
            }
        }
        
    }
       
}
 
*/
 
/*
- (void)outlineViewItemDidExpand:(NSNotification *)notification{
    id sv = [notification object];
    NSDictionary *dict = [notification userInfo];
    id thing = [[notification userInfo] objectForKey:@"NSObject"];
    
    NSLog(@"selectedRow %i", [sv  selectedRow]);   
    if([sv selectedRow] == -1)
        return;
    
    // Here we could fetch the children... 
    NSTreeNode *item = (NSTreeNode*)[sourceView itemAtRow: [sourceView selectedRow]];
    id <DPContributionNavigationDescriptor, NSObject> descriptor = [item representedObject];
    
    NSLog(@"--> %@", descriptor);    
    
}
*/ 
 
-(void)fetchViews:(NSTreeNode*)designNode{
    if(operationQueue == nil){
        operationQueue = [[NSOperationQueue alloc] init];
    }
   
    //SVBaseNavigationDescriptor *parentDescriptor =  [[designNode parentNode] representedObject];
    
    id <DPContributionNavigationDescriptor> viewDesc = [designNode representedObject];
    
  
    // XXX If we had the actuall SBCouchDatabase, we could simplify this signature. 
    //SBCouchServer *server = [[NSApp delegate] couchServer];
    //SBCouchDatabase *couchDatabase = [server database:parentDescriptor.label];
    
    SBCouchDatabase *couchDatabase = [viewDesc couchDatabase];
    
    SVFetchQueryInfoOperation *fetchOperation = [[SVFetchQueryInfoOperation alloc] initWithCouchDatabase:couchDatabase                                            
                                                                                       designDocTreeNode:designNode];
    
    [fetchOperation addObserver:self
                     forKeyPath:@"isFinished" 
                        options:0
                        context:nil];
    
    [operationQueue addOperation:fetchOperation];
    [fetchOperation release];
    
}

-(NSTreeNode*)locateCouchServerDescriptionWithinTree:(NSTreeNode*)aRootNode{
    /*
    if([aRootNode isKindOfClass:[SVCouchServerDescriptor class]])
        return aRootNode;
    */
    
    for(NSTreeNode *node in [aRootNode mutableChildNodes]){        
        id <DPContributionNavigationDescriptor> descriptor = [node representedObject];
     
        if([descriptor type] == DPDescriptorCouchServer){
            return node;
        }
    }    
    return nil;
}

#pragma mark -
#pragma mark - NSOutlineView delegate  (Left Hand Nav)

-(BOOL)outlineView:(NSOutlineView*)outlineView isGroupItem:(id)item{      
    if(item == nil)
        return NO;
    
    if ([self isSpecialGroup:[item representedObject]]){
		return YES;
	}else{
		return NO;
	}    
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item{
    return YES;
    SVBaseNavigationDescriptor *desc = [item representedObject];
    if([desc type] == DPDescriptorCouchView){
        return NO;
    }
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(id)item{
    // I like being able to collapse the hosts. 
    /*
    SVAbstractDescriptor *desc = [item representedObject];    
    if([desc isKindOfClass:[SVCouchServerDescriptor class]])
        return NO;
    */
    return YES;
    
}

// -------------------------------------------------------------------------------
//	shouldSelectItem:item
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;{
	// don't allow special group nodes (Devices and Places) to be selected
    SVBaseNavigationDescriptor *node = [item representedObject];
	return (![self isSpecialGroup:node]);
}

// -------------------------------------------------------------------------------
//	outlineView:willDisplayCell
// -------------------------------------------------------------------------------
- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item{
            
        if ([self isSpecialGroup:[item representedObject]]){
            NSMutableAttributedString *newTitle = [[cell attributedStringValue] mutableCopy];
            [newTitle replaceCharactersInRange:NSMakeRange(0,[newTitle length]) withString:[[newTitle string] uppercaseString]];
            [cell setAttributedStringValue:newTitle];
            [newTitle release];
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

- (void)showDesignView:(id<DPContributionNavigationDescriptor>)navDescriptor{
    [self showEmptyInspectorView]; 
    [self showDesignEditorInMainView:navDescriptor];
    //[self showEmptyBodyView];     
}

-(void)showDesignEditorInMainView:(id<DPContributionNavigationDescriptor>)navDescriptor{
    for (NSView *view in [bodyView subviews]) {
        [view removeFromSuperview];
    }
    
    // SHOW FUNTION EDITOR IN THE MAIN VIEW
    SVDesignDocumentEditorController *functionController = [[SVDesignDocumentEditorController alloc]                                                                 
                                                                    initWithNibName:NIB_DesignDocumentEditor 
                                                                             bundle:nil
                                                                    navContribution:navDescriptor];    
    [self sizeViewToBody:[functionController view]];
    /*
    for (id view in [inspectorView subviews]){
        [view removeFromSuperview];
    }
    */
    
    [self.bodyView addSubview:[functionController view]];
    
    // SHOW THE VIEW RESULTS IN THE INSPECTOR VIEW
    SVQueryResultController *queryResultController = [[SVQueryResultController alloc] initWithNibName:NIB_QueryResultView
                                                                                               bundle:nil];

    [inspectorView addSubview:[queryResultController view]];
    [self sizeViewToInspector:[queryResultController view]];
    //XXX Not sure if this will work... and if it does, I'm not sure it will work 
    //    for plugins. 
    functionController.delegate = queryResultController;

}

- (void)sizeViewToBody:(NSView*)aView{
    NSRect frame = [aView frame];
    NSRect superFrame = [bodyView frame];
    frame.size.width = superFrame.size.width;
    frame.size.height = superFrame.size.height;
    [aView setFrame:frame];    
}

- (void)sizeViewToInspector:(NSView*)aView{
    NSRect frame = [aView frame];
    NSRect superFrame = [inspectorView frame];
    frame.size.width = superFrame.size.width;
    frame.size.height = superFrame.size.height;
    [aView setFrame:frame];    
}


-(void)showSlowViewInMainView:(id<DPContributionNavigationDescriptor>)navContribution{

    // SHOW THE VIEW RESULTS IN THE INSPECTOR VIEW
    SVQueryResultController *queryResultController = [[SVQueryResultController alloc] initWithNibName:NIB_QueryResultView
                                                                                               bundle:nil 
                                                                                              navContribution:navContribution];
    
    
    for (id view in [inspectorView subviews]){
        [view removeFromSuperview];
    }
    [inspectorView addSubview:[queryResultController view]];           
    [self sizeViewToInspector:[queryResultController view]];
    
}


-(void)showCouchViewInBody:(id<DPContributionNavigationDescriptor>)navDescriptor{    
    NSViewController *queryResultController = [navDescriptor contributionMainViewController];

    for (NSView *view in [bodyView subviews]) {
        [view removeFromSuperview];
    }
    
    [bodyView addSubview:[queryResultController view]];
    [self sizeViewToBody:[queryResultController view]];
        
    [self showEmptyInspectorView];
    
}

- (void)showEmptyInspectorView{
    
    // Only show the davenport logo/name once. This only needs to be preformed once. 
    // XXX This could be made faster. 
    for (NSView *view in [self.emptyInspectorView subviews]) {
        [view removeFromSuperview];
    }
    
    /*
    for (NSView *view in [self.inspectorView subviews]) {
        [view removeFromSuperview];
    }
    */
    
    [self.inspectorView addSubview:self.emptyInspectorView];
}

- (void)showEmptyBodyView{
    // Guard clause so we don't waste our time. 
    if([ [self.bodyView subviews] containsObject:self.emptyBodyView]){
        SVDebug(@"Already showing empty view");
        // We're already showing the emptybody view;
        return;
    }
        
    for (NSView *view in [self.bodyView subviews]) {
        if([view isKindOfClass:[SVEmptyInspectorView class]])
            continue;
        
        [view removeFromSuperview];
    }

    [self.bodyView addSubview:self.emptyBodyView];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification{
    if([sourceView selectedRow] == -1)
        return;
    
    NSTreeNode *item = (NSTreeNode*)[sourceView itemAtRow: [sourceView selectedRow]];
    id <DPContributionNavigationDescriptor, NSObject> descriptor = [item representedObject];
    
    if(! [descriptor conformsToProtocol:@protocol(DPContributionNavigationDescriptor)]){
        SVDebug(@"item does not conform to Contribution protocol");
        return;
    }
    
    [self updateBreadCrumbs:item];

    if([descriptor type] == DPDescriptorCouchDatabase){
        [self showCouchViewInBody:descriptor];
    }else if([descriptor type] == DPDescriptorCouchDesign){
        [self showDesignView:descriptor];
    }else if([descriptor type] == DPDescriptorCouchView){
        //[self showDesignEditorInMainView:descriptor];
        [self showCouchViewInBody:descriptor];
    }else if([descriptor type] == DPDescriptorPluginProvided){
        [self delagateSelectionDidChange:item];
    }else{
        [self delagateSelectionDidChange:item];
    }    
}


#pragma mark -
#pragma mark Plugin Delegate Invocations
- (void) delagateSelectionDidChange:(NSTreeNode*)item{
    if(item == NULL)
        return;
    
    // As per usual, the represented object ought to be a DPContributionNavigationDescriptor
    id descriptor = [item representedObject];    
    if(! [descriptor conformsToProtocol:@protocol(DPContributionNavigationDescriptor)]){
        SVDebug(@"item does not conform to Contribution protocol");
        return;
    }
    NSString *pluginID = [descriptor pluginID];
    id <DPContributionPlugin> plugin = [[NSApp delegate] lookupPlugin:pluginID];
    [plugin selectionDidChange:item];

    NSViewController *mainViewController = [plugin contributionMainViewController];
    NSViewController *inspectorViewController = [plugin contributionInspectorViewController];        
    for (NSView *view in [bodyView subviews]) {
        [view removeFromSuperview];
    }
        
    for (NSView *view in [inspectorView subviews]) {
        [view removeFromSuperview];
    }
    
    [self.bodyView addSubview:[mainViewController view]];
    [self sizeViewToBody:[mainViewController view]];
    
    [self.inspectorView addSubview:[inspectorViewController view]];
    [self sizeViewToInspector:[inspectorViewController view]];
}


#pragma mark -
#pragma mark Breadcrumb Management

// TODO This is only partially completed and will break when we add Tool 
// support. It's okay for now because we don't really understand where the 
// design is headed. 

// TODO I bet there's a naming convention for methods like these. 
-(void)updateBreadCrumbs:(NSTreeNode*)item{    
    // Hard coding the root element name. Temporary. 

    NSInteger elements = [[item indexPath] length];
    NSMutableArray *pathElementCells = [NSMutableArray arrayWithCapacity:elements+1];
    
    id currentNode = [[[SVBreadCrumbCell alloc] initWithPathLabel:[[item representedObject] label]] autorelease];
    [pathElementCells addObject:currentNode];
    
    // A typicall path might look like this:
    //   Couch DB > database > design_doc > view 
    
    NSTreeNode *parent;
    while((parent = [item parentNode]) != nil){
        // If the parent does not hold an SVAbstactDescriptor, then its the root 
        // of the hierarchy and we need to cease processing. 
        if([parent representedObject] == nil){
            item = nil;
            continue;
        }
        id descriptorLabel = [[parent representedObject] label];
        SVBreadCrumbCell *pathCell = [[[SVBreadCrumbCell alloc] initWithPathLabel:descriptorLabel] autorelease];
        [pathElementCells addObject:pathCell];
        // Setting item to the parent allows us to process the next item in the hierarchy. 
        item = parent; 
    }
    
    // Tac on the CouchDB breadcrumb at the end so we know what we are looking at. 
    id couch = [[[SVBreadCrumbCell alloc] initWithPathLabel:@"CouchDB"] autorelease];
    [pathElementCells addObject:couch];
    
    // Now we reverse the order of the collection
    NSArray *objectInReversOrder = [[pathElementCells reverseObjectEnumerator] allObjects];
    [pathControl setPathComponentCells:objectInReversOrder];
    [pathControl setNeedsDisplay];    
}

-(void) appendBreadCrumb:(NSNotification*)notification{
    id pathLabel = [notification object];
    
    NSArray *currentPath = [pathControl pathComponentCells];
        
    if ( [[currentPath lastObject] isContent] ){
        [self removeBreadCrumb:nil];
    }

    NSMutableArray *newPath = [NSMutableArray arrayWithArray:currentPath];
    
    SVBreadCrumbCell *newNode = [[[SVBreadCrumbCell alloc] initWithPathLabel:[pathLabel description]] autorelease];
    newNode.isContent = YES;
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
    SVDebug(@"Okay, so we got the message. ");
}

- (IBAction)showInspector:(id)sender{
    //[[self window] setContentView:logView];
    SVDebug(@"Show the inspector to the user. ");
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
 Controls what Conext Menu items are shown for a given NSOutlineView selection. 
 */
- (void)menuNeedsUpdate:(NSMenu *)menu {
    NSInteger clickedRow = [sourceView clickedRow];
    
    if(clickedRow == -1)
        return;
        
    NSTreeNode *item = [sourceView itemAtRow:clickedRow];
    SVBaseNavigationDescriptor *descriptor = [item representedObject];

    if(descriptor.type != DPDescriptorCouchDatabase){
        // hide all the menu items. This will prevent any context menu from appearing. 
        for(NSMenuItem *menuItem in [menu itemArray]){
            [menuItem setHidden:TRUE];
        }
    }else{
        //XXX Is there a better way to do this than by name?
        //NSMenuItem *deleteMenuItem = [menu itemWithTitle:@"Delete"];
        //assert(deleteMenuItem);        
        //[menuItem setTitle:[NSString stringWithFormat:@"Delete '%@'", [descriptor label]]];    
        //[deleteMenuItem setRepresentedObject:item];    
        // Ensure the menu items are visible. 
        for(NSMenuItem *menuItem in [menu itemArray]){
            [menuItem setHidden:FALSE];
            [menuItem setRepresentedObject:item];    
        }
    }
}

- (IBAction)deleteDatabaseAction:(id)sender{
    if(![sender isKindOfClass:[NSMenuItem class]])
        return;

    NSTreeNode *item = (NSTreeNode*)[(NSMenuItem*)sender representedObject];        
    SVBaseNavigationDescriptor *descriptor = [item representedObject];
    
    SVDebug(@"Going to delete database [%@]", [descriptor label]);

    SBCouchServer *couchServer = [(SVAppDelegate*)[NSApp delegate] couchServer];
    BOOL didDelete = [couchServer deleteDatabase:[descriptor label]];
    
    if(didDelete){
        [[[item parentNode] mutableChildNodes] removeObject:item];
        [lock lock];
        [self.sourceView reloadData];
        [lock unlock];
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

- (IBAction)refreshDatabaseAction:(id)sender{
    NSTreeNode *item = (NSTreeNode*)[(NSMenuItem*)sender representedObject];        
    NSNotification *notification = [NSNotification notificationWithName:DPLocalDatabaseNeedsRefreshNotification object:item];
    [self refreshDatabaseNode:notification];

}

- (IBAction)refreshServerNodeAction:(id)sender{
    //NSTreeNode *item = (NSTreeNode*)[(NSMenuItem*)sender representedObject];
    
    for(id node in [self.rootNode childNodes]){
        if(! [[node representedObject] isKindOfClass:[SVBaseNavigationDescriptor class]])
            continue;

        NSLog(@" %@", [node class]);
        NSNotification *notification = [NSNotification notificationWithName:DPServerNeedsRefreshNotification object:node];
        [self refreshServerNode:notification];
    }        
}

#pragma mark -
#pragma mark Notification Handlers
// XXX This really ought to call an operation that just gets a list of databases. 


- (void)refreshServerNode:(NSNotification*)notification{
    NSTreeNode *item = [notification object];
    
    if(operationQueue == nil){
        operationQueue = [[NSOperationQueue alloc] init];
    }
    
}


- (void)refreshDatabaseNode:(NSNotification*)notification{
    NSTreeNode *item = [notification object];
    
    if(operationQueue == nil){
        operationQueue = [[NSOperationQueue alloc] init];
    }
    
    SVRefreshCouchDatabaseNodeOperation *operation = [[SVRefreshCouchDatabaseNodeOperation alloc] initWithCouchDatabaseTreeNode:self.rootNode
                                                                                                        indexPath:[item indexPath]];
    
    [operationQueue addOperation:operation];        
    [operationQueue waitUntilAllOperationsAreFinished]; 
    
    [lock lock];        
    [self.sourceView reloadData];
    [lock unlock];
    
    
    [operation release];
    
    /*
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    SVFetchServerInfoOperation *fetchOperation = [[SVFetchServerInfoOperation alloc] initWithCouchServer:[[NSApp delegate] couchServer] rootTreeNode:self.rootNode];
    
    [fetchOperation addObserver:self
                     forKeyPath:@"isFinished" 
                        options:0
                        context:nil];
    [queue addOperation:fetchOperation];                
    [fetchOperation release];
    */
    
}

- (void) loadPluginsNavigationContributions:(NSNotification*)notification{
    NSString *pluginID = [notification object];
    id <DPContributionPlugin> plugin = [[[NSApp delegate] pluginRegistry] objectForKey:pluginID];

    NSTreeNode *contributionRootNode = [plugin navigationContribution];    
    NSMutableArray *contributionChildNodes = [contributionRootNode mutableChildNodes];
    
    [lock lock];
    [[rootNode mutableChildNodes] addObjectsFromArray:contributionChildNodes];    
    [self.sourceView reloadData];
    [lock unlock];    
    
    [self autoExpandGroupItems];
}

- (void)runAndDisplaySlowView:(NSNotification *)notification{
    /*
    SBCouchView *view = [notification object];
    [self showSlowViewInMainView:view];
     */ 
}

#pragma mark - 
- (void)autoExpandGroupItems{
    for(NSTreeNode *contributionNode in [self.rootNode childNodes]){
        id representedObject = [contributionNode representedObject];
        if([representedObject conformsToProtocol:@protocol(DPContributionNavigationDescriptor)]){
            if([representedObject isGroupItem])
                [self.sourceView expandItem:contributionNode];
        }            
    }    
}

#pragma mark -
#pragma marrk Property GET/SET Overrides

// We require a root node with no represented object. All children of this 
// tree node will be added to the navigation tree's root. 
- (void)appendNSTreeNodeToNavigationRootNode:(NSTreeNode *)treeToAppend{
    //[treeToAppend retain];
    //        [[rootNode mutableChildNodes] addObjectsFromArray:[treeToAppend childNodes]];
    [lock lock];
    [self.sourceView reloadData];
    [self autoExpandGroupItems];
    [lock unlock];

    [self loadViewNodes:rootNode];
    //[treeToAppend release];
}

#pragma mark -
#pragma mark DPResourceFactory Protocol 
-(id)namedResource:(DPSharedResources)resourceName{
    // XXX Switch statement....please. 
    if(resourceName == DPSharedViewContollerNamedFunctionEditor){
        return [[SVDesignDocumentEditorController alloc] initWithNibName:NIB_DesignDocumentEditor
                                                                       bundle:self.bundle];
        
    }else if(resourceName == DPSharedViewContollerNamedViewResults){
        return [[SVQueryResultController alloc] initWithNibName:NIB_QueryResultView
                                                         bundle:self.bundle];
    } 
    return nil;
}
@end

#pragma mark -
#pragma mark DisclosureTriangleAdditions delegate

@implementation NSObject(DisclosureTriangleAdditions)
-(BOOL)outlineView:(NSOutlineView*)outlineView shouldShowDisclosureTriangleForItem:(id)item{    
    // We'd like to hide the disclosure triangle but we need to ensure that 
    // the CouchServer node is expanded first. 
    
    // If the descriptor is a to be shown as a group item, then don't show the 
    // discolsure triangle. 
    id navigationDescriptor = [item representedObject];       
    
    if([navigationDescriptor conformsToProtocol:@protocol(DPContributionNavigationDescriptor)]){
        if( [navigationDescriptor isGroupItem])
            return NO;
    } 
    
    if( [[item childNodes] count] > 0)
        return YES;
    
    return NO;
}


@end


