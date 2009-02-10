//
//  SVFunctionEditorController.m
// 
//
//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVInspectorFunctionDocumentController.h"
#import "NSTreeNode+SVDavenport.h";
#import <CouchObjC/CouchObjC.h>;
#import "SVAppDelegate.h"

@implementation SVInspectorFunctionDocumentController

@synthesize mapTextView;
@synthesize reduceTextView;
@synthesize treeNode;
@synthesize designDocument;

#pragma mark -



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil treeNode:(NSTreeNode *)node{
 
    // _design/domain
    // 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.treeNode = node;
        SBCouchServer *server = [(SVAppDelegate*)[NSApp delegate] couchServer];  
        NSString *databaseName = [node deriveDatabaseName];
        SBCouchDatabase *database = [server database:databaseName];
        
        NSString *url = [NSString stringWithFormat:@"%@", [node deriveDesignDocumentPath]];
        self.designDocument = [database getDesignDocument:url];
    }
    
    return self;    
}
- (void)awakeFromNib{
    NSFont *font = [NSFont fontWithName:@"Monaco" size:18];
    [[self.mapTextView textStorage] setFont:font];
    [[self.reduceTextView textStorage] setFont:font];    
    
    NSString *viewIdentity = [[self.treeNode representedObject] label];
    SBCouchView *view = [self.designDocument view:viewIdentity];
    NSString *reduceText = [view reduce];
    
    [self.mapTextView setString:[view map]];
    if(reduceText == nil)
        [self.reduceTextView setString:@""];
    else
        [self.reduceTextView setString:reduceText];
}
#pragma mark - Actions
- (IBAction)runFunction:(id)sender{
    // TODO might be a good idea just to use the TreeNode instead of 
    // creating the view here. 
    NSString *viewIdentity = [[self.treeNode representedObject] label];
    SBCouchView *view = [self.designDocument view:viewIdentity];
    
    NSString *databaseName = [self.treeNode deriveDatabaseName];
    view.couchDatabase = databaseName;
    
    [view setMap:[[self.mapTextView textStorage] string]];

    // Set the reduce function if it's not empty. 
    NSString *reduceString = [[self.reduceTextView textStorage] string]; 
    if(reduceString != nil && [reduceString hasPrefix:@"function"])
        [view setReduce:reduceString];
    /*
    else
        [self.reduceTextView setString:NULL];
    */
    [[NSNotificationCenter defaultCenter] postNotificationName:SV_NOTIFICATION_RUN_SLOW_VIEW object:view];
}
@end
