//
//  SVQueryResultController.m
//  
//
//  Created by Robert Evans on 1/8/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVQueryResultController.h"
#import <CouchObjC/CouchObjC.h>
#import "SVAppDelegate.h"
#import <JSON/JSON.h>
#import "SVInspectorFunctionDocumentController.h"
#import "SVInspectorDocumentController.h"
#import "SVAbstractDescriptor.h"
#import "SVDatabaseDescriptor.h"
#import "SVViewDescriptor.h"
#import "SVDesignDocumentDescriptor.h"


@interface  SVQueryResultController (Private)

- (NSString*)stripNewLines:(NSString*)string;
- (void) handleCouchDocumentSelected:(NSDictionary*)couchDocument;
- (NSString*)theNodesDatabase:(NSTreeNode*)node;
- (NSString*)theNodesDocumentIdentity:(NSTreeNode*)node;
@end


@implementation SVQueryResultController

@synthesize databaseName;
@synthesize queryResult;
@synthesize couchDatabase;

#pragma mark -

// Since our treeNodes get stuffed w/ SVAbstractDescriptors, and because these descriptors have the identity 
// of the resource, we can build the URL that that any particular TreeNeds represents. 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil treeNode:(NSTreeNode *)node{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){        
        [self setDatabaseName:[self theNodesDatabase:node]];
        NSString *docId = [self theNodesDocumentIdentity:node];
        
        SBCouchServer *server = [[NSApp delegate] couchServer];  
        SBCouchDatabase *database = [server database:self.databaseName];
        
        [self setQueryResult:(SBCouchEnumerator*) [database getViewEnumerator:docId]];
        [self setCouchDatabase:database];
        
        //NSLog(@"queryResult [%@]", queryResult);
        //NSLog(@"totalRows [%i]", [queryResult totalRows]);
    } 
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil databaseName:(NSString *)dbName{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self setDatabaseName:dbName];
        
        SVDebug(@"*** dbName [%@]", [self databaseName]);
        
        
        // TODO don't hard code this. Look it up somehow
        //SBCouchServer *server = [[SBCouchServer alloc] initWithHost:@"localhost" port:LOCAL_PORT];
        
        // The delegate will know what database we are talking to. At least for now. 
        SBCouchServer *server = [[NSApp delegate] couchServer];  
        SBCouchDatabase *database = [server database:dbName];
        [self setQueryResult:(SBCouchEnumerator*) [database allDocsInBatchesOf:10]];
        [self setCouchDatabase:database];
        
        NSLog(@"queryResult [%@]", queryResult);
        NSLog(@"totalRows [%i]", [queryResult totalRows]);
    } 
    return self;
}


#pragma mark -

-(NSString*) theNodesDatabase:(NSTreeNode*)node{
    if([node parentNode] == nil)
        return nil;
            
    SVAbstractDescriptor *desc = [node representedObject];
    if([desc isKindOfClass:[SVDatabaseDescriptor class]]){
        return desc.identity;
    }else{
        return [self theNodesDatabase:[node parentNode]];
    }
}
-(NSString*) theNodesDocumentIdentity:(NSTreeNode*)node{
    if([node parentNode] == nil)
        return nil;
    
    SVAbstractDescriptor *desc = [node representedObject];
    if([desc isKindOfClass:[SVViewDescriptor class]]){ 
        NSMutableString *viewPathPart = [NSMutableString stringWithString:desc.identity];
        // The parent of a view is a esign doc. 
        SVDesignDocumentDescriptor *designDesc = [[node parentNode] representedObject];

        // sofa-blog/_view/datacenter/hardware
        // database/_view/domain/view
        NSMutableString *urlPath = [NSMutableString stringWithFormat:@"_view/%@/%@",designDesc.label,viewPathPart];
        
        return urlPath;
    }else if([desc isKindOfClass:[SVDatabaseDescriptor class]]){
        //NSMutableString *viewPathPart = [NSMutableString stringWithFormat:@"/%@/_all_docs",desc.identity];
        return @"_all_docs";
    }else{        
        return desc.identity;
        //[self theNodesDatabase:[node parentNode]];
    }
    
}

#pragma mark -
#pragma mark NSOutlineViewDataSource delegate

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return [queryResult totalRows];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    id object = [[self queryResult] itemAtIndex:index];
    return object;
}

// TODO - We need to return the value for the value column. 
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    //NSString *col = [tableColumn identifier];
    if(![item isKindOfClass:[SBCouchDocument class]])
        return @"ERROR";
    
    
    if([ [tableColumn identifier] isEqualToString:@"Key"])
        return [item valueForKey:@"key"];

    if([ [tableColumn identifier] isEqualToString:@"Value"]){
        return [[item valueForKey:@"value"] JSONRepresentation];
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

    NSDictionary *couchDocument = [object itemAtRow:[object selectedRow]];
    SVDebug(@"selected document [%@]", [couchDocument objectForKey:@"key"] );
    
    // TODO make notification name a define
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appendBreadCrumb" 
                                                        object:[couchDocument objectForKey:@"key"]];
    
    [self handleCouchDocumentSelected:couchDocument];
}


// XXX We need to be caching here. 
-(void) handleCouchDocumentSelected:(NSDictionary*)couchDocument{
    SVMainWindowController *mainWindowController = [(SVAppDelegate*)[NSApp delegate] mainWindowController];
    NSView *inspectorView = [mainWindowController inspectorView]; 

    SVDebug(@"inspectorView [%@]", inspectorView);
    
    for (id view in [inspectorView subviews]){
        [view removeFromSuperview];
    }
    
    // This should probably check to see if the inspector is showing. If its not, there's really 
    // no need to show the view. I'd fix it now but I need to think about how to how to handle 
    // drawing the inspector views when the inspector becomes un-hidden and there's no inspector 
    // subview in existence. 
    NSString *tmp = [couchDocument objectForKey:@"key"];   
    if([tmp hasPrefix:@"_design/"]){     
        SVInspectorFunctionDocumentController *functionController = [[SVInspectorFunctionDocumentController alloc] 
                                                            initWithNibName:@"FunctionEditor" bundle:nil];
        
        [inspectorView addSubview:[functionController view]];
        NSRect frame = [[functionController view] frame];
        NSRect superFrame = [inspectorView frame];
        frame.size.width = superFrame.size.width;
        frame.size.height = superFrame.size.height;
        [[functionController view] setFrame:frame];
        
    }else{
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
    
}


@end
