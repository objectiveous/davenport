//
//  SVFunctionEditorController.m
// 
//
//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVDesignDocumentEditorController.h"
#import "NSTreeNode+SVDavenport.h";
#import <CouchObjC/CouchObjC.h>;
#import "SVAppDelegate.h"
#import "DPContributionNavigationDescriptor.h"
#import "SVSaveViewAsSheetController.h"


@interface SVDesignDocumentEditorController (Private)

-(void)synchChanges:(NSString*)couchViewName;
-(void)synchChangesOfView:(SBCouchView*)couchView;

@end


@implementation SVDesignDocumentEditorController

@synthesize mapTextView;
@synthesize reduceTextView;
@synthesize viewComboBox;
@synthesize designDocument;
@synthesize saveButton;
@synthesize saveAsButton;                       
@synthesize isDirty;
@synthesize saveViewAsController;

#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil navContribution:(id <DPContributionNavigationDescriptor>)aNavContribution{ 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        SBCouchDatabase *couchDatabase = [aNavContribution couchDatabase];
        assert(couchDatabase);
        id couchDesignDocument = [[aNavContribution userInfo] objectForKey:@"couchobject"];
        assert(couchDesignDocument);
        self.designDocument = couchDesignDocument;    
        self.saveViewAsController = [[SVSaveViewAsSheetController alloc] initWithWindowNibName:@"SaveViewAsPanel"];
    }    
    return self;
}

- (void)awakeFromNib{    
    NSDictionary *views = [self.designDocument views];
  
    if([views count] > 0){
        // If we have views, add a seperator and start adding menuitems in reverse order. 
        // Reversing the order is done to keep the interface consistant with 1] couch's 
        // structure of the data and 2] how futon displays data. 
        [self.viewComboBox insertItemWithObjectValue:@"---------------------" atIndex:0];        
        NSArray *keys = [views allKeys];
        for(id key in [keys reverseObjectEnumerator]){
            [self.viewComboBox insertItemWithObjectValue:key atIndex:0];
        }        
        [self.viewComboBox selectItemAtIndex:0];
    }

}
#pragma mark - Actions
- (IBAction)runCouchViewAction:(id)sender{
    
    NSString *menueItemViewName = [self.viewComboBox objectValueOfSelectedItem];
    SVDebug(@"selected menu item name: %@", menueItemViewName);
    
    SBCouchView *view  = [self.designDocument view:menueItemViewName];
    if(view.reduce){
        SBCouchQueryOptions *queryOptions = [[SBCouchQueryOptions new] autorelease];
        queryOptions.group = YES;        
        view.queryOptions = queryOptions;
    }

    // 404 /cushion-tickets/sprint?limit=30&group=true
    // 200 /cushion-tickets/_view/More%20Stuff/sprint
    NSEnumerator *viewResults;
    if(self.isDirty){
        SBCouchView *copyOfViewForSlowEnumerator = [view copy];
        [self synchChangesOfView:copyOfViewForSlowEnumerator];
        viewResults = [copyOfViewForSlowEnumerator slowViewEnumerator];
    }else{
        viewResults = [view viewEnumerator];
    }
        
    
    // XXX We now have a protocol for this but the semantics are still ill defined. For example,
    // does a call to provision always update a view? How can we be sure this will always work?
    if ( [[self delegate] respondsToSelector:@selector(provision:)] ) {
        [[self delegate] provision:viewResults]; 
    }    
}

- (IBAction)saveDesignDocumentAction:(id)sender{
    NSString *viewName = [self.viewComboBox objectValueOfSelectedItem];
    [self synchChanges:viewName];
    [self.designDocument put];
    self.isDirty = NO;
}

- (IBAction)saveAsDesignDocumentAction:(id)sender{
    NSString *viewName = [self.viewComboBox objectValueOfSelectedItem];
    [self synchChanges:viewName];
    SBCouchDesignDocument *designDocumentCopy = [self.designDocument copy];
    [designDocumentCopy put];
}

- (IBAction)saveViewAsAction:(id)sender{

    //edit should be a dictionary. 
    SVMainWindowController *mainWindowController = [(SVAppDelegate*)[NSApp delegate] mainWindowController];
    
    // Althought it might be possible to pass in a DesignDocument or a CouchView, I think 
    // it'll be easier to keep the model clean if we just use a dictionary. 
    NSString *viewName = [self.viewComboBox objectValueOfSelectedItem];
    NSString *designName = [self.designDocument designDocumentName];
    NSMutableDictionary *newViewDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
    [newViewDictionary setObject:viewName forKey:@"viewName"];
    [newViewDictionary setObject:designName forKey:@"designName"];
    
	[self.saveViewAsController edit:newViewDictionary from:mainWindowController];
	if (![saveViewAsController wasCancelled]){        
        SBCouchView *view  = [self.designDocument view:viewName];
        SBCouchView *newView = [view copy];
        
        NSLog(@"We are good to go and can create the new copy the view");
        NSString *newDesignName = [newViewDictionary objectForKey:@"designName"];
        NSString *newViewName = [newViewDictionary objectForKey:@"viewName"];
        newView.name = newViewName;
        
        SBCouchDesignDocument *designDocumentForSaveAs;
        if([designName isEqualToString:newDesignName]){
            designDocumentForSaveAs = self.designDocument;
        }else{
            designDocumentForSaveAs = [[SBCouchDesignDocument alloc] initWithName:newDesignName couchDatabase:self.designDocument.couchDatabase];            
        }
        
        [designDocumentForSaveAs addView:newView withName:newViewName];        
        [designDocumentForSaveAs put];
        [designDocumentForSaveAs release];
        
        //SBCouchServer *couchServer = [(SVAppDelegate*)[NSApp delegate] couchServer];
        //[couchServer createDatabase:newDatabaseName];
        // Now reaload all the datafrom the server. 
        //[(SVAppDelegate*)[NSApp delegate] performFetchServerInfoOperation];    
	}
}


#pragma mark -

-(void)synchChanges:(NSString*)couchViewName{
    SBCouchView *view  = [self.designDocument view:couchViewName];
    [self synchChangesOfView:view];
}
-(void)synchChangesOfView:(SBCouchView*)couchView{
    //[self.reduceTextView textStorage] 
    
    NSString *currentValueOfMapFunction = [self.mapTextView string];
    NSString *currentValueOfReduceFunction = [self.reduceTextView string];
    
    couchView.map = currentValueOfMapFunction;
    if(currentValueOfReduceFunction && ! [@"" isEqualToString:currentValueOfReduceFunction]){
        couchView.reduce = currentValueOfReduceFunction;
    }        
}


- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    
    NSString *menueItemViewName = [self.viewComboBox objectValueOfSelectedItem];
    
    SBCouchView *view  = [self.designDocument view:menueItemViewName];
    NSString *map = @"";
    NSString *reduce = @"";
    if(view){
        map = [view map];
        reduce = [view reduce];
        // Sorta cheesey
        if(!reduce)
            reduce = @"";
    } else if([menueItemViewName isEqualToString:SV_MENU_ITEM_NAME_TEMPORARY_VIEW]){
        map = @"function(){\n   emit(doc._id, doc);\n}";
    } else{
        map = [NSString stringWithFormat:@"--> %@", menueItemViewName];
    }
    // XXX Only create this once, please. 
    NSFont *font = [NSFont fontWithName:@"Monaco" size:18];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
    NSAttributedString *mapString = [[NSAttributedString alloc] initWithString:map attributes:attrsDictionary];
    NSAttributedString *reduceString = [[NSAttributedString alloc] initWithString:reduce attributes:attrsDictionary];
    
    [[self.mapTextView textStorage] setAttributedString:mapString];
    [[self.reduceTextView textStorage] setAttributedString:reduceString];
    [self.saveButton highlight:NO];
    
}

- (void)textDidChange:(NSNotification *)aNotification{
    NSTextView *object = [aNotification object];
    NSLog(@"%@", [object string]);
    NSLog(@"-------------------");
    NSLog(@"%@", [self.reduceTextView string]);
    
    id userInfo = [aNotification userInfo];
    [self.saveButton highlight:YES];
    self.isDirty = YES;
}


- (id)delegate {
    return delegate;
}

- (void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

#pragma mark -
#pragma mark DPSharedController Protocol Support
-(void)provision:(id)configurationData{
    self.designDocument = configurationData;
}

@end
