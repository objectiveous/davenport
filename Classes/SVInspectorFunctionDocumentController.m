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
#import "DPContributionNavigationDescriptor.h"

@implementation SVInspectorFunctionDocumentController

@synthesize mapTextView;
@synthesize reduceTextView;
@synthesize treeNode;
@synthesize designDocument;

#pragma mark -

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSLog(@"--> our bundle %@", nibNameOrNil);
    // _design/domain
    // 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.mapTextView 
    }
    
    return self;    
}
*/

/// We assume you are providing a node that represents a designDoc
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil treeNode:(NSTreeNode *)designDocNode{
 
    // _design/domain
    // 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.treeNode = designDocNode;
        SBCouchServer *server = [(SVAppDelegate*)[NSApp delegate] couchServer];  
        NSString *databaseName = [designDocNode deriveDatabaseName];
        SBCouchDatabase *database = [server database:databaseName];
                       
        //id <DPContributionNavigationDescriptor> designDesc = [[node parentNode] representedObject];
        id <DPContributionNavigationDescriptor> designDesc = [designDocNode representedObject];
        NSString *urlPath = [designDesc identity];                
        self.designDocument = [database getDesignDocument:urlPath];
    }
    
    return self;    
}
- (void)awakeFromNib{
    NSString *viewIdentity = [[self.treeNode representedObject] label];
    SBCouchView *view = [self.designDocument view:viewIdentity];
  
    if(view){
        [self.mapTextView setString:[view map]];
        NSString *reduceText = [view reduce];
        if(reduceText != nil)
            [self.reduceTextView setString:reduceText];           
    }
    
   
    
    //NSFont *font = [NSFont fontWithName:@"Monaco" size:18];
    [[self.mapTextView textStorage] setFont:[NSFont fontWithName:@"Monaco" size:18]];
    [[self.reduceTextView textStorage] setFont:[NSFont fontWithName:@"Monaco" size:18]];               
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

    // TODO Need much smarter parsing of function code. 
    NSString *reduceString = [[self.reduceTextView textStorage] string]; 
    if(reduceString != nil && [reduceString hasPrefix:@"function"])
        [view setReduce:reduceString];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SV_NOTIFICATION_RUN_SLOW_VIEW object:view];
}
@end
