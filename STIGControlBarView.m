//
//  STIGControlBar.m
//  stigmergic
//
//  Created by Robert Evans on 1/3/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "STIGControlBarView.h"
#import <Cocoa/Cocoa.h>


@implementation STIGControlBarView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        image = [NSImage imageNamed:@"segment.jpg"];
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
