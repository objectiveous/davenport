//
//  SVCouchDocument.m
//  
//
//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVCouchDocumentController.h"
#import <JSON/JSON.h>


#define COLUMNID_FIELD @"Field"
#define COLUMNID_VALUE @"Value"

@implementation SVCouchDocumentController

@synthesize documentControlBar;
@synthesize documentOutlineView;
@synthesize versionTextField;
@synthesize couchDocument;
@synthesize couchDatabase;
@synthesize previousRevisionButton;
@synthesize nextRevisionButton;
@synthesize revisions;

#pragma mark -

- (void)awakeFromNib{

    // This would give use rev 16 or 16, for example
    numberOfRevisions = [[self.couchDocument objectForKey:@"_revs"] count]; 
    currentRevision = numberOfRevisions;
    [self setRevisions:[self.couchDocument objectForKey:@"_revs"]];
    
    [[[self versionTextField] cell] setTitle:[NSString stringWithFormat:@"Showing revision %i of %i", currentRevision , numberOfRevisions]];
        
    // Future revisions are unknown to this document view. If the number of revisions is 1, then there is only one version of 
    // this document and we have just been handed it. 
    if(numberOfRevisions == 1){
        [self.previousRevisionButton setEnabled:NO];
        [self.nextRevisionButton setEnabled:NO];
    }else{
        [previousRevisionButton setEnabled:YES];
    }    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil couchDocument:(NSDictionary *)couchDBDocument couchDatabase:(SBCouchDatabase*)couchDB{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){                
        [self setCouchDocument:[couchDB getDocument:[couchDBDocument objectForKey:@"id"] 
                                  withRevisionCount:YES 
                                            andInfo:YES 
                                           revision:nil]];
        [self setCouchDatabase:couchDB];
    }
    return self;
}

#pragma mark -
#pragma mark Delegate 

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
    SVDebug(@"So, like, why don't we try to update this record. ");    
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{    
    if (item == nil)
        return  [self.couchDocument count];
    
    if ([item isKindOfClass:[SBOrderedDictionary class]] || [item isKindOfClass:[NSArray class]]) 
        return [item count];
        
    return 0; 
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{    
    SVDebug(@"couchdocument %@", [self couchDocument])

    id parentObject = [outlineView parentForItem:item] ? : [self couchDocument];

    if(item == nil)
        return @"missing item";
    
    id label;
    
    // Column One
    if ([[[tableColumn headerCell] stringValue] compare:@"Field"] == NSOrderedSame) {        
        if(parentObject != nil){
            if([parentObject isKindOfClass:[SBOrderedDictionary class]]){                                        

                // TODO how are we gonna get around this? What we really need is the 
                // the index of item. 
                label = [[parentObject allKeysForObject:item] lastObject];
            }else if([parentObject isKindOfClass:[NSArray class]]){
                label = [NSString stringWithFormat:@"%d", [parentObject indexOfObject:item]];
            }else if([parentObject isKindOfClass:[SBCouchDocument class]]){
                label = [[parentObject allKeysForObject:item] lastObject];
            }
        }
        
    // Column Two    
    } else if([[[tableColumn headerCell] stringValue] compare:@"Value"] == NSOrderedSame)  {      
        if([item isKindOfClass:[SBOrderedDictionary class]]) {
            label = nil;
        }else if ( [item isKindOfClass:[NSArray class]] ){
            label = nil;
        }else{
            label = item;
        }
            
    } else if([[[tableColumn headerCell] stringValue] compare:@"Type"] == NSOrderedSame)  {      
        if([item isKindOfClass:[SBOrderedDictionary class]]) {
            label = [NSString stringWithFormat:@"%i key/value pairs", [item count]]; 
        }else if ( [item isKindOfClass:[NSArray class]] ){
            label = [NSString stringWithFormat:@"%i ordered objects", [item count]]; 
        }else{
            label = nil;
        }
    }
    return label;
}


// Item is the parent. A nil item indicates that we are dealing with the root 
// of the hierarchy. 
- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item{
    if (item == nil){
        return [self.couchDocument objectForKey:[self.couchDocument keyAtIndex:index]];        
    }
        
    if ([item isKindOfClass:[NSArray class]]) {
        return [item objectAtIndex:index];
    }else if ([item isKindOfClass:[SBOrderedDictionary class]]) {
        return [item objectForKey:[item keyAtIndex:index]];
    }    
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{    
    if ([item isKindOfClass:[NSArray class]] || [item isKindOfClass:[SBOrderedDictionary class]]){
        if ([item count] > 0)
            return YES;
    }        
    return NO;
}
#pragma mark -
#pragma mark Actions

-(IBAction)showPreviousRevisionAction:(id)sender{
    NSString *previousRevision = [self.couchDocument previousRevision];
    SVDebug(@"need to show revision %@", previousRevision);
    
    NSString *documentId = [self.couchDocument objectForKey:@"_id"];
    SBCouchDocument *document = [[self couchDatabase] getDocument:documentId 
                                                withRevisionCount:YES 
                                                          andInfo:YES
                                                         revision:previousRevision];
        
    [couchDocument release];    
    couchDocument = nil;
    
    [self setCouchDocument:document];    
       
    currentRevision--;
    [self updateRevisionInformationLabelAndNavigation];           

    [self.documentOutlineView reloadData];
    //[self.documentOutlineView setDataSource:self];
    //[[self view] setNeedsDisplay:YES]; 
    

}

-(IBAction)showNextRevisionAction:(id)sender{
        
    int realCurrentIndex = numberOfRevisions - currentRevision;    
    id nextRevision = [self.revisions objectAtIndex:realCurrentIndex-1];
    
    
    NSString *documentId = [self.couchDocument identity];
    SBCouchDocument *document = [[self couchDatabase] getDocument:documentId 
                                                withRevisionCount:YES 
                                                          andInfo:YES
                                                         revision:nextRevision];
    
    [couchDocument release];    
    couchDocument = nil;    
    [self setCouchDocument:document];        
    currentRevision++;
    [self updateRevisionInformationLabelAndNavigation];           

    [self.documentOutlineView reloadData];
    [self.documentOutlineView setDataSource:self];
    //[[self view] setNeedsDisplay:YES]; 
    
}

#pragma mark -
-(void)updateRevisionInformationLabelAndNavigation{    
    [[[self versionTextField] cell] setTitle:[NSString stringWithFormat:@"Showing revision %i of %i", currentRevision, numberOfRevisions]];
    
    if(currentRevision == 1)
        [self.previousRevisionButton setEnabled:FALSE];
    else
        [self.previousRevisionButton setEnabled:TRUE];

    if(currentRevision < numberOfRevisions)
        [self.nextRevisionButton setEnabled:TRUE];
    else
        [self.nextRevisionButton setEnabled:FALSE];
}

@end
