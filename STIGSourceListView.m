//
//  STIGSourceListView.m
//  stigmergic
//
//  Created by Robert Evans on 12/28/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "STIGSourceListView.h"


@implementation STIGSourceListView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionHighlightStyle = NSTableViewSelectionHighlightStyleSourceList;
    }
    return self;
}


- (NSRect)frameOfOutlineCellAtRow:(NSInteger)row{
    BOOL showTriangle = YES;
    
    if( [[self delegate] respondsToSelector:@selector(outlineView:shouldShowDisclosureTriangleForItem:)] ){
        showTriangle = [[self delegate] outlineView:self shouldShowDisclosureTriangleForItem:[self itemAtRow:row]];
    }
    
    if( !showTriangle ){
        // If not showing triangle, return empty rect
        return NSZeroRect;
    }else{
        return [super frameOfOutlineCellAtRow:row];
    }
}

@end




