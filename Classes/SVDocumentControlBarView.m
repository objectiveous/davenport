//
//  SVDocumentControlBarView.m
//  Davenport
//
//  Created by Robert Evans on 2/3/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVDocumentControlBarView.h"


@implementation SVDocumentControlBarView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        image = [NSImage imageNamed:@"segment1.png"];
    }
    return self;
}

-(void) dealloc{
    [super dealloc];
}
- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
    
    [image drawInRect:rect
             fromRect:NSZeroRect 
            operation:NSCompositeSourceOver
             fraction:1];
     
}

-(BOOL)outlineView:(NSOutlineView*)outlineView shouldShowDisclosureTriangleForItem:(id)item{
    return YES;
}

@end
