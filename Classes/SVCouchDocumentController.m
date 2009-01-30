//
//  SVCouchDocument.m
//  stigmergic
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


#pragma mark -

- (void)awakeFromNib{
    NSInteger count = [[self.couchDocument objectForKey:@"_revs"] count];
    
    [[[self versionTextField] cell] setTitle:[NSString stringWithFormat:@"Showing revision X of %i", count]];

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil couchDocument:(NSDictionary *)couchDBDocument couchDatabase:(SBCouchDatabase*)couchDB{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){                
        [self setCouchDocument:[couchDB getDocument:[couchDBDocument objectForKey:@"id"] withRevisionCount:YES andInfo:YES]];
    }
    SVDebug(@"---> %@", [self couchDocument]);
    return self;
}

#pragma mark -
- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{    
    if (item == nil)
        return [couchDocument count];
    
    if ([item isKindOfClass:[SBOrderedDictionary class]] || [item isKindOfClass:[NSArray class]]) 
        return [item count];
        
    return 0; 
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{    
    id parentObject = [outlineView parentForItem:item] ? : couchDocument;

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
        //SVDebug(@"index        [%i]", index);
        //SVDebug(@"key          [%@]", [couchDocument keyAtIndex:index]);
        //SVDebug(@"objectForKey [%@]", [couchDocument objectForKey:[couchDocument keyAtIndex:index]])
        return [couchDocument objectForKey:[couchDocument keyAtIndex:index]];        
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

@end
