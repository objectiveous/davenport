//
//  SVQueryResultController.m
//  
//
//  Created by Robert Evans on 1/8/09.
//  Copyright 2009 South And Valley. All rights reserved.
//  


#import <CouchObjC/CouchObjC.h>
#import <JSON/JSON.h>
#import <RBSplitView/RBSplitView.h>
#import <RBSplitView/RBSplitSubview.h>
#import "DPResourceFactory.h"
#import "DPSharedController.h"
#import "DPContributionNavigationDescriptor.h"
#import "SVAppDelegate.h"
#import "SVQueryResultController.h"
#import "SVInspectorDocumentController.h"
#import "NSTreeNode+SVDavenport.h"
#import "SVMainWindowController.h"

@interface  SVQueryResultController (Private)
- (NSString*)stripNewLines:(NSString*)string;
- (void) handleCouchDocumentSelected:(SBCouchDocument*)couchDocument;
- (void) managePaginationButtonRight;
- (void) managePaginationButtonLeft;
- (void)logPopUp;
@end


@implementation SVQueryResultController

@synthesize databaseName;
@synthesize queryResult;
@synthesize couchDatabase;
@synthesize viewResultOutlineView;
@synthesize resultCountSummaryTextField;
@synthesize nextBatch;
@synthesize previousBatch;
@synthesize pageNumber;
@synthesize pageSizePopUp;
@synthesize pageSize;
@synthesize outlineDelegate;

#pragma mark -

/*
-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        self.viewResultOutlineView = [[NSOutlineView alloc] init];
    }
    return self;
}
*/

- (void)awakeFromNib{
    [self.pageSizePopUp removeAllItems];
    [self.pageSizePopUp addItemWithTitle:@"WTF"];
}

-(void)dealloc{
    self.databaseName = nil;
    self.queryResult = nil;
    self.couchDatabase = nil;
    self.viewResultOutlineView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark NSOutlineViewDataSource delegate
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    //[self logPopUp];
    
    NSInteger count = [self.queryResult numberOfRowsForPage:self.pageNumber];
           
    NSString *label = [NSString stringWithFormat:@"Showing %i-%i of %i rows", 
                       [self.queryResult startIndexOfPage:self.pageNumber],
                       [self.queryResult endIndexOfPage:self.pageNumber], 
                       self.queryResult.totalRows];        
    
    [[self.resultCountSummaryTextField cell] setTitle:label];    
    return count; 
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    id object = [[self queryResult] objectAtIndex:index ofPage:self.pageNumber];
    return object;
}

// TODO - We need to return the value for the value column. 
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    //NSString *col = [tableColumn identifier];
    if(![item isKindOfClass:[SBCouchDocument class]])
        return @"ERROR";
    
    
    if([ [tableColumn identifier] isEqualToString:@"Key"]){
        id key = [item valueForKey:@"key"];        

        if([key isKindOfClass:[NSArray class]])
            return [key JSONRepresentation];
        return key;
    }
        

    if([ [tableColumn identifier] isEqualToString:@"Value"]){
        
        id value = [item valueForKey:@"value"];

        if([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]] )
            return [value JSONRepresentation];
        else
            return value;

        
        //return [value JSONRepresentation];
        // this can cause problems if the reciever does no respond to JSONRepresentation. 
    }            
    return @"Error: Unknown";
    
}



#pragma mark -
#pragma mark - NSOutlineView delegate

-(BOOL)outlineView:(NSOutlineView*)outlineView isGroupItem:(id)item{
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item{
    return YES;
}

// Once opened it can't be closed. 
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(id)item{
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;{
    return YES;
}

// -------------------------------------------------------------------------------
//	outlineView:willDisplayCell
// -------------------------------------------------------------------------------
- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    
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
    NSOutlineView *object = [notification object];

    SBCouchDocument *couchDocument = [object itemAtRow:[object selectedRow]];
    [couchDocument retain];
    SVDebug(@"selected document [%@]", [couchDocument objectForKey:@"key"] );
    
    // TODO make notification name a define
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appendBreadCrumb" 
                                                        object:[couchDocument objectForKey:@"key"]];
    
    [self handleCouchDocumentSelected:couchDocument];
    [couchDocument release];
}


// XXX We need to be caching here. 
-(void) handleCouchDocumentSelected:(SBCouchDocument*)couchDocument{
    SVMainWindowController *mainWindowController = (SVMainWindowController*) [(SVAppDelegate*)[NSApp delegate] mainWindowController];

    RBSplitView *inspectorView = (RBSplitView*) mainWindowController.inspectorView; 
   
    SVInspectorDocumentController *documentController; 
    documentController = [[SVInspectorDocumentController alloc] initWithNibName:@"CouchDocument" 
                                                                         bundle:nil
                                                                  couchDocument:couchDocument
                                                                  couchDatabase:self.couchDatabase]; 

    NSView *documentView = [documentController view];
                        
    [inspectorView addSubview:documentView];
        
        // One would think that this would not be necissary... 
        NSRect frame = [documentView frame];
        NSRect superFrame = [inspectorView frame];
        frame.size.width = superFrame.size.width;
        frame.size.height = superFrame.size.height;
        [documentView setFrame:frame];
}

#pragma mark -
#pragma mark DPSharedController Protocol Support
-(void)provision:(id)configurationData{
    [self.pageSizePopUp addItemWithTitle:@"10"];
    [self.pageSizePopUp addItemWithTitle:@"100"];
    [self.pageSizePopUp addItemWithTitle:@"1000"];
    [self logPopUp];

    NSView *couchViewResultView = [self view];

    if(self.outlineDelegate)
        [self.viewResultOutlineView setDelegate:self.outlineDelegate];
    else
        [self.viewResultOutlineView setDelegate:self];
    
    // We don't have a parent view here because we were removed from. 
    NSView *parentView = [couchViewResultView superview];
    [parentView addSubview:couchViewResultView];
    
    if(! [configurationData isKindOfClass:[SBCouchEnumerator class]])
        return;
    
    self.queryResult = nil;
    self.queryResult = configurationData;

    // XXX This is a hack to force the fetching of the first page 
    //     and get things ready for reloadData. There should be a 
    //     better way. 
    NSInteger count = [self.queryResult count];
    self.pageNumber = 1;
    
    if(self.queryResult.queryOptions.limit == 0){
        [self.nextBatch setEnabled:NO];
        [self.pageSizePopUp removeAllItems];
    }
    
    if(count < self.queryResult.queryOptions.limit)
        [self.nextBatch setEnabled:NO];

    [self.pageSizePopUp selectItemWithTitle:@"10"];
    //[self logPopUp];
    [self.viewResultOutlineView reloadData];
}

#pragma mark -
-(IBAction)fetchNextPageAction:(id)sender{
    [self.queryResult fetchNextPage];
    self.pageNumber++;
        
    [self managePaginationButtonRight];    
    
    if(self.pageNumber > 1){
        [self.previousBatch setEnabled:YES];
    } else{
        [self.previousBatch setEnabled:NO];
    }

    
    [self.viewResultOutlineView reloadData];
}
-(IBAction)fetchPreviousPageAction:(id)sender{
    [self.nextBatch setEnabled:YES];
    self.pageNumber--;

    if(self.pageNumber > 1){
        [self.previousBatch setEnabled:YES];
    } else{
        [self.previousBatch setEnabled:NO];
    } 
    
    [self.viewResultOutlineView reloadData];
}

#pragma mark -
#pragma mark Action Handlers
// XXX Maybe we should be using bindings for this...
-(IBAction)adjustPageSizeAction:(id)sender{
    NSMenuItem *menuItem = [sender selectedItem];
    NSString *pageSizeString = [menuItem title];
    self.pageSize = [pageSizeString intValue];
    self.pageNumber = 1;
    [self.queryResult resetLimit:self.pageSize];    
    [self managePaginationButtonRight];    
    [self.viewResultOutlineView reloadData];
}
#pragma mark -
- (void) managePaginationButtonRight{
    if(![self.queryResult hasNextBatch]){
        [self.nextBatch setEnabled:NO];
    }else{
        [self.nextBatch setEnabled:YES];
    }    
}
- (void) managePaginationButtonLeft{
    
}
- (void)logPopUp{
    NSLog(@"LOG POPUP");
    for(id item in [self.pageSizePopUp itemArray]){
        NSLog(@" menu item : %@", item);
    }
}
@end
