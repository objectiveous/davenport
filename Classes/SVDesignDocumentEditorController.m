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
//@synthesize delegate;

#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil navContribution:(id <DPContributionNavigationDescriptor>)aNavContribution{ 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        SBCouchDatabase *couchDatabase = [aNavContribution couchDatabase];
        assert(couchDatabase);
        NSString *urlPath = [aNavContribution identity];
        self.designDocument = [couchDatabase getDesignDocument:urlPath];
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
        
   
    //[[self.mapTextView textStorage] setFont:font];
    //[[self.reduceTextView textStorage] setFont:font];      
}
#pragma mark - Actions
- (IBAction)runCouchViewAction:(id)sender{
    
    NSString *menueItemViewName = [self.viewComboBox objectValueOfSelectedItem];
    NSLog(@"selected menu item name: %@", menueItemViewName);
    
    SBCouchView *view  = [self.designDocument view:menueItemViewName];

    // 404 /cushion-tickets/sprint?limit=30&group=true
    // 200 /cushion-tickets/_view/More%20Stuff/sprint
    
    NSEnumerator *viewResults = [view getEnumerator];
    
    if ( [[self delegate] respondsToSelector:@selector(showViewResults:)] ) {
        [[self delegate] showViewResults:viewResults]; 
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
        map = @"function(){XXXX from a template}";
    } else{
        map = [NSString stringWithFormat:@"--> %@", menueItemViewName];
    }
        
    NSFont *font = [NSFont fontWithName:@"Monaco" size:18];
    //NSFont *font = [NSFont fontWithName:@"Palatino-Roman" size:14.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
    NSAttributedString *mapString = [[NSAttributedString alloc] initWithString:map attributes:attrsDictionary];
    NSAttributedString *reduceString = [[NSAttributedString alloc] initWithString:reduce attributes:attrsDictionary];
    
    [[self.mapTextView textStorage] setAttributedString:mapString];
    [[self.reduceTextView textStorage] setAttributedString:reduceString];
    
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
