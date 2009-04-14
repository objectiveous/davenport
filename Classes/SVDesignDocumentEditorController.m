//
//  SVFunctionEditorController.m
// 
//
//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <CouchObjC/CouchObjC.h>;
#import "DPSharedController.h"
#import "DPContributionNavigationDescriptor.h"
#import "SVDesignDocumentEditorController.h"
#import "SVDesignDocumentEditorController.h"
#import "DPResourceFactory.h"
#import "NSTreeNode+SVDavenport.h";
#import "SVAppDelegate.h"
#import "DPContributionNavigationDescriptor.h"
#import "SVSaveViewAsSheetController.h"

static NSString *REDUCE_STRING = @"function (key, values, rereduce) {\n    return sum(values);\n}";

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
@synthesize navigationTreeNode;
@synthesize navContribution;
@synthesize reduceCheckBox;

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil navigationTreeNode:(NSTreeNode*)aTreeNode{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.navigationTreeNode = aTreeNode;
        navContribution = [aTreeNode representedObject];
        self.designDocument = [aTreeNode couchObject]; 
        self.saveViewAsController = [[SVSaveViewAsSheetController alloc] initWithWindowNibName:@"SaveViewAsPanel"];
    }    
    return self;
}
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

        //[self.viewComboBox insertItemWithObjectValue:@"---------------------" atIndex:0];     
        
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
    [self synchChangesOfView:view];
    if(view.queryOptions == nil){
        view.queryOptions = [ [SBCouchQueryOptions new] autorelease];
        view.queryOptions.limit = 10;
    }
        

    // XXX This does not really belong here. Seems like somethign else ought to be 
    // handeling this. 
    //view.queryOptions.limit = 10;
    
    NSLog(@"reduce %@: ", view.reduce);
    if(view.reduce && [view.reduce length] > 0 ){       
        view.queryOptions.group = YES;
        // You can't use the limit query option when reducing. 
        view.queryOptions.limit = 0;
    }else{
        view.queryOptions.group = NO;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:DPRefreshNotification object:self.navigationTreeNode];
	}
}
- (IBAction)reduceCheckBoxAction:(id)sender{
    if([self.reduceCheckBox state] == NSOnState){
        [[self.reduceTextView textStorage] setForegroundColor:[NSColor blackColor]];
        [self textDidChange:nil];
    }else{
        [[self.reduceTextView textStorage] setForegroundColor:[NSColor lightGrayColor]]; 
    }
}

#pragma mark -

-(void)synchChanges:(NSString*)couchViewName{
    SBCouchView *view  = [self.designDocument view:couchViewName];
    [self synchChangesOfView:view];
}
-(void)synchChangesOfView:(SBCouchView*)couchView{
    //[self.reduceTextView textStorage] 
    BOOL wantToRunWithReduce = [self.reduceCheckBox state] == NSOnState;
    NSLog([self.reduceCheckBox state] ? @"Checkbox is ON" : @"Checkbox is OFF");
    
    
    NSString *currentValueOfMapFunction = [self.mapTextView string];
    NSString *currentValueOfReduceFunction = [self.reduceTextView string];
    
    if(wantToRunWithReduce){
        couchView.reduce = currentValueOfReduceFunction;
    }else{
        [couchView removeObjectForKey:@"reduce"];
    }
        
    
    couchView.map = currentValueOfMapFunction;

    // If the user wants to run w/ a reduce AND we have a reduce function. 
    if(wantToRunWithReduce && couchView.reduce && [couchView.reduce length] != 0 && couchView.queryOptions){
        couchView.queryOptions.group = YES;
    }
    
}


- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    // Turn the reduce botton off. We'll turn it on later, if the view 
    // that was selected actually has a reduce function. 
    [self.reduceCheckBox setState:NSOffState];
    NSString *menueItemViewName = [self.viewComboBox objectValueOfSelectedItem];
    
    SBCouchView *view  = [self.designDocument view:menueItemViewName];
    NSString *map = @"";
    NSString *reduce = REDUCE_STRING;
    if(view){
        map = [view map];
        reduce = [view reduce];
        // Sorta cheesey
        if(!reduce)
            reduce = REDUCE_STRING;
    } else if([menueItemViewName isEqualToString:SV_MENU_ITEM_NAME_TEMPORARY_VIEW]){
        map = @"function(){\n   emit(doc._id, doc);\n}";
    } else{
        map = [NSString stringWithFormat:@"--> %@", menueItemViewName];
    }
    // XXX Only create this once, please. 
    NSFont *font = [NSFont fontWithName:@"Monaco" size:12];
    
    NSMutableDictionary *attrsDictionary = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    NSMutableDictionary *reduceAttrsDictionary = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [reduceAttrsDictionary setObject:[NSColor lightGrayColor] forKey:NSForegroundColorAttributeName];
    
    NSAttributedString *mapString = [[NSAttributedString alloc] initWithString:map attributes:attrsDictionary];
    NSAttributedString *reduceString = [[NSAttributedString alloc] initWithString:reduce attributes:reduceAttrsDictionary];
    
    [[self.mapTextView textStorage] setAttributedString:mapString];
    [[self.reduceTextView textStorage] setAttributedString:reduceString];
    [self.saveButton highlight:NO];
    
}

- (void)textDidChange:(NSNotification *)aNotification{
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
