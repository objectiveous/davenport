//
//  SVSourceView.m
//  Davenport
//
//  Created by Robert Evans on 2/11/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVSourceView.h"


@implementation SVSourceView

- init{
    self = [super init];
    return self;
}


- (void)awakeFromNib{
   //[super awakeFromNib];
}

 
- (void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    if(self){
        
    }
    return self;
}


- (id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if(self){
        
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
