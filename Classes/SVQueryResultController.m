//
//  SVQueryResultController.m
//  
//
//  Created by Robert Evans on 1/8/09.
//  Copyright 2009 South And Valley. All rights reserved.
//  


#import <CouchObjC/CouchObjC.h>
#import <JSON/JSON.h>
#import "DPResourceFactory.h"
#import "DPSharedController.h"
#import "DPContributionNavigationDescriptor.h"
#import "SVAppDelegate.h"
#import "SVQueryResultController.h"
#import "SVInspectorDocumentController.h"
#import "NSTreeNode+SVDavenport.h"




@interface  SVQueryResultController (Private)
- (NSString*)stripNewLines:(NSString*)string;
- (void) handleCouchDocumentSelected:(SBCouchDocument*)couchDocument;
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
#pragma mark -



#pragma mark -
#pragma mark NSOutlineViewDataSource delegate

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    // The number of children will always be either A] the limit placed on query OR 
    // the value of [couchEnumerator count];

    NSInteger count = self.queryResult.queryOptions.limit;
    if(count <= 0)
        count = [self.queryResult count];

    // FRACTIONAL PAGES 
    //% self.queryResult.queryOptions.limit;
    NSInteger fractionalPage = self.queryResult.totalRows - self.queryResult.offset;
    // If we have a partial page AND the index is increasing, then show a partial page of data. 
    // of the index is not increasing, we are scrolling backwards and should show a full page. 
    // && self.queryResult.currentIndex >= self.queryResult.offset
    if(fractionalPage < self.queryResult.queryOptions.limit && ! self.queryResult.currentIndex > [self.queryResult count]){
       count = fractionalPage;
    }
        
    
    NSString *label = [NSString stringWithFormat:@"Showing %i-%i of %i rows", 
                       [self.queryResult startIndexOfPage:self.pageNumber],
                       [self.queryResult endIndexOfPage:self.pageNumber], 
                       self.queryResult.totalRows];        
    
    [[self.resultCountSummaryTextField cell] setTitle:label];

    // -------------------------------
    if([self.queryResult hasNextBatch]){
        [self.nextBatch setEnabled:YES];
    } else{
        [self.nextBatch setEnabled:NO];
    }
        
    if(self.pageNumber > 1){
        [self.previousBatch setEnabled:YES];
    } else{
        [self.previousBatch setEnabled:NO];
    }
        // -------------------------------
            
    return count; 
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    // SBCouchEnumerator indexes start with 1. 
    id object = [[self queryResult] objectAtIndex:index+1 ofPage:self.pageNumber];
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

        if([value isKindOfClass:[NSString class]])
            return value;
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
    SVDebug(@"selected document [%@]", [couchDocument objectForKey:@"key"] );
    
    // TODO make notification name a define
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appendBreadCrumb" 
                                                        object:[couchDocument objectForKey:@"key"]];
    
    [self handleCouchDocumentSelected:couchDocument];
}


// XXX We need to be caching here. 
-(void) handleCouchDocumentSelected:(SBCouchDocument*)couchDocument{
    SVMainWindowController *mainWindowController = [(SVAppDelegate*)[NSApp delegate] mainWindowController];
    NSView *inspectorView = [mainWindowController inspectorView]; 

    SVDebug(@"inspectorView [%@]", inspectorView);
    
    // XXX Commenting this out as a test to see if we can keep views around and just 
    //     re-provision them. 
    /*
    for (id view in [inspectorView subviews]){
        [view removeFromSuperview];
    }
    */
    
    // This should probably check to see if the inspector is showing. If its not, there's really 
    // no need to show the view. I'd fix it now but I need to think about how to how to handle 
    // drawing the inspector views when the inspector becomes un-hidden and there's no inspector 
    // subview in existence. 
 
        
        SVInspectorDocumentController *documentController = [[SVInspectorDocumentController alloc]                                                                  
                                                                initWithNibName:@"CouchDocument" 
                                                                         bundle:nil
                                                                  couchDocument:couchDocument
                                                                  couchDatabase:[self couchDatabase]]; 
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
    
    NSView *couchViewResultView = [self view];
    // We don't have a parent view here because we were removed from. 
    NSView *parentView = [couchViewResultView superview];
    [parentView addSubview:couchViewResultView];
    NSArray *subviews = [parentView subviews];
    SVDebug(@"subview count : %i ", [subviews count]);
    
    if(! [configurationData isKindOfClass:[SBCouchEnumerator class]])
        return;

    self.queryResult = configurationData;

    // XXX This is a hack to force the fetching of the first page 
    //     and get things ready for reloadData. There should be a 
    //     better way. 
    [self.queryResult count];
    self.pageNumber = 1;
    [self.viewResultOutlineView reloadData];
}

-(IBAction)fetchNextPageAction:(id)sender{
    [self.queryResult fetchNextPage];
    self.pageNumber++;
    [self.viewResultOutlineView reloadData];
}
-(IBAction)fetchPreviousPageAction:(id)sender{
    self.pageNumber--;
    [self.viewResultOutlineView reloadData];
}

@end
