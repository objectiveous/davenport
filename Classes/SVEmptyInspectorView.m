//
//  SVEmptyInspectorView.m
//  Davenport
//
//  Created by Robert Evans on 2/4/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVEmptyInspectorView.h"


@implementation SVEmptyInspectorView


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        image = [NSImage imageNamed:@"background.pdf"];
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

@end
