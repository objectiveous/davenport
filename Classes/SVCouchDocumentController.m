//
//  SVCouchDocument.m
//  
//
//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVCouchDocumentController.h"
#import <JSON/JSON.h>
#import "NSTreeNode+SVDavenport.h"
#import "SVJSONDescriptor.h"
#import "NSTreeNode+SVDavenport.h"

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
@synthesize rootNode;
@synthesize currentRevision;
@synthesize numberOfRevisions;

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
        [self setRootNode:[self.couchDocument asNSTreeNode]];
        [self setCouchDatabase:couchDB];
    }
    return self;
}

#pragma mark -
#pragma mark Delegate 


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item{

    if(self.currentRevision == self.numberOfRevisions)
        return YES;
    return NO;
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
    SVDebug(@"So, like, why don't we try to update this record. ");    
    
    SVJSONDescriptor *descriptor = [(NSTreeNode*)item representedObject];
            
    if ([[[tableColumn headerCell] stringValue] compare:@"Field"] == NSOrderedSame) {   
        [descriptor setLabel:object];
    } else if([[[tableColumn headerCell] stringValue] compare:@"Value"] == NSOrderedSame)  {      
        [descriptor setValue:object];    
    }
    
    // XXX Mark this document as needing updates and don't let folks update past revisions. 
    SBCouchResponse *response = [self.couchDatabase putDocument:[rootNode asDictionary] named:[self.couchDocument identity]];
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{    
    if (item == nil)
        return  [[self.rootNode childNodes] count];
    
    if ([item isKindOfClass:[NSTreeNode class]]) 
        return [[item childNodes] count];
        
    return 0; 
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{    
    id parentObject = [outlineView parentForItem:item] ? : [self rootNode];
    if(item == nil)
        return @"missing item";

    NSTreeNode *treeNode = item;
    id label = @"xxx";
    
    // Column One
    if ([[[tableColumn headerCell] stringValue] compare:@"Field"] == NSOrderedSame) {   
        SVJSONDescriptor *descriptor = [treeNode representedObject];
        label = descriptor.label;
    // Column Two    
    } else if([[[tableColumn headerCell] stringValue] compare:@"Value"] == NSOrderedSame)  {      
        SVJSONDescriptor *descriptor = [treeNode representedObject];
        label = descriptor.value;        
    } else if([[[tableColumn headerCell] stringValue] compare:@"Type"] == NSOrderedSame)  {      
        SVJSONDescriptor *descriptor = [treeNode representedObject];
        //label = descriptor.jsonType;     
    }
    return label;
}


// Item is the parent. A nil item indicates that we are dealing with the root 
// of the hierarchy. 
- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item{
    if (item == nil){
        return [[self.rootNode childNodes] objectAtIndex:index];        
    }
    
    return [ [item childNodes] objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{    

     if ([[item childNodes] count]> 0)
         return YES;
    
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
