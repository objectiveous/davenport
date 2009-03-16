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

@implementation SVDesignDocumentEditorController

@synthesize mapTextView;
@synthesize reduceTextView;
@synthesize viewComboBox;
@synthesize designDocument;
@synthesize saveButton;
@synthesize saveAsButton;                       

#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil navContribution:(id <DPContributionNavigationDescriptor>)aNavContribution{ 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        SBCouchDatabase *couchDatabase = [aNavContribution couchDatabase];
        assert(couchDatabase);
        self.designDocument = [[aNavContribution userInfo] objectForKey:@"couchobject"];        
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
    NSLog(@"selected menu item name: %@", menueItemViewName);
    
    SBCouchView *view  = [self.designDocument view:menueItemViewName];

    // 404 /cushion-tickets/sprint?limit=30&group=true
    // 200 /cushion-tickets/_view/More%20Stuff/sprint
    
    NSEnumerator *viewResults = [view viewEnumerator];
    
    // XXX We now have a protocol for this but the semantics are still ill defined. For example,
    // does a call to provision always update a view? How can we be sure this will always work?
    if ( [[self delegate] respondsToSelector:@selector(provision:)] ) {
        [[self delegate] provision:viewResults]; 
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
    id object = [aNotification object];
    id userInfo = [aNotification userInfo];
    [self.saveButton highlight:YES];
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
