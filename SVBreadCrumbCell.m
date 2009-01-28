#import "SVBreadCrumbCell.h"

@interface SVBreadCrumbCell (Private)
- (void) drawPathLabel:(NSRect)cellFrame;

@end


@implementation SVBreadCrumbCell

@synthesize pathControl;

#pragma mark -
- (id) init{
	self = [super init];
	if (self != nil) {				
		pathSeparatorImage = [NSImage imageNamed:@"arrow-25.jpg"];
    }
	return self;
}

- (id) initWithPathLabel:(NSString *)label{
    self = [super init];
    if(self != nil){
        pathSeparatorImage = [NSImage imageNamed:@"arrow-25.jpg"];
        [self setTitle:label];
    }
    return self;
}

#pragma mark -
- (BOOL) isOnlyPathComponent{
    return ([self isFirstPathComponent] && [self isLastPathComponent]);
}
- (BOOL) isFirstPathComponent {
	return ([[pathControl pathComponentCells] indexOfObject: self] == 0);
}

- (BOOL) isLastPathComponent {
	return ([[pathControl pathComponentCells] lastObject] == self);
}

#pragma mark -

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {	    
    //NSLog(@"-> [%@]", [self pathControl]);
    [NSGraphicsContext saveGraphicsState];
    
    
    NSAffineTransform *transform = [NSAffineTransform transform];
     
    [transform translateXBy:0.0 yBy:[pathSeparatorImage size].height];
    [transform scaleXBy:1.0 yBy:-1.0];
    [transform concat];
    
    NSRect delimiterArrowRect = cellFrame;
    delimiterArrowRect.size.width = [pathSeparatorImage size].width;
    delimiterArrowRect.size.height = [pathSeparatorImage size].height;
    
    // delimiterArrowRects are drawn on all cells except for the first one. 
    if ([self isOnlyPathComponent]) {
		[pathSeparatorImage drawInRect:[self deriveFinalDividerRect: cellFrame]        
                              fromRect:NSZeroRect
                             operation:NSCompositeSourceOver 
                              fraction:1];

	}else  if (![self isFirstPathComponent] && ![self isLastPathComponent] ) {				        
		[pathSeparatorImage	drawInRect:delimiterArrowRect
                              fromRect:NSZeroRect
                             operation:NSCompositeSourceOver 
                              fraction:1];        

    }else if ([self isLastPathComponent] && ! [self isFirstPathComponent] ) {
		[pathSeparatorImage drawInRect:delimiterArrowRect
                              fromRect:NSZeroRect
							 operation:NSCompositeSourceOver 
                              fraction:1];
				
		[pathSeparatorImage drawInRect:[self deriveFinalDividerRect: cellFrame]        
                              fromRect:NSZeroRect
                             operation:NSCompositeSourceOver 
                              fraction:1];		
	}
    
    [transform invert];
    [transform concat];
    [NSGraphicsContext restoreGraphicsState];
    
    [self drawPathLabel: cellFrame];
}

- (void) drawPathLabel: (NSRect) cellFrame  {
    NSDictionary *attrs = [self attributesForTitle];
    [attrs setValue:[NSColor colorWithCalibratedWhite:255.0/255.0 
                                                alpha:0.6] 
             forKey:NSForegroundColorAttributeName];

	NSRect inset = [self derivePathLabelRect: cellFrame];
	[[self title] drawInRect:inset withAttributes:attrs];
    
	inset.origin.y -= 0.8;
        
    [attrs setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];    
	[[self title] drawInRect:inset withAttributes:attrs];
    
}

#pragma mark -

- (NSSize)cellSizeForBounds:(NSRect)aRect {
	NSDictionary *attrs = [self attributesForTitle];
	NSSize titleSize = [[self title] sizeWithAttributes:attrs];

    if([self isOnlyPathComponent])
        return NSMakeSize( titleSize.width+35, 20); //27
    
	if (![self isFirstPathComponent])
		return NSMakeSize( titleSize.width+35, 20); //27
	else
		return NSMakeSize( titleSize.width+19, 20);
     
}
/*
- (double) offsetStart {    
     if([self isOnlyPathComponent])
         return 0;
	if ([self isLastPathComponent])
		return -10;
	if ([self isFirstPathComponent])
		return 0;
	else
		return 13;     
}
*/
- (NSRect) derivePathLabelRect:(NSRect) cellFrame {
	NSSize titleSize = [[self title] sizeWithAttributes:[self attributesForTitle]];
	NSRect inset = cellFrame;
	inset.size.width = titleSize.width+14;				
	inset.size.height = titleSize.height;
	inset.origin.y = (NSMinY(cellFrame) + (NSHeight(cellFrame) - titleSize.height) / 2.0)-1.0;
	
	if ([self isLastPathComponent])
		inset.origin.x += 25;
	else if ([self isFirstPathComponent])
		inset.origin.x += 12; // Have to offset more to allow for the image
	else
		inset.origin.x += 25; // Nasy to hard-code this. Can we get it to draw its own content, or determine correct inset?
	inset.origin.y += 1;
	return inset;
}

- (NSRect) deriveFinalDividerRect:(NSRect) cellFrame {
	NSRect rightArrowFrame = cellFrame;
	rightArrowFrame.size.width = [pathSeparatorImage size].width;
	rightArrowFrame.size.height = [pathSeparatorImage size].height; // -1

	if ([self isLastPathComponent] & ! [self isOnlyPathComponent]){
        rightArrowFrame.origin.x += cellFrame.size.width-5;
    }else if([self isOnlyPathComponent]){
        rightArrowFrame.origin.x += cellFrame.size.width-10;
    }else
		rightArrowFrame.origin.x += cellFrame.size.width-10;

	return rightArrowFrame;
    
}

- (NSDictionary *) attributesForTitle {
	NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithDictionary:[[self attributedStringValue]
                                                                                attributesAtIndex:0                                                                                            effectiveRange:NULL]];
	return attrs;
}

- (NSFont *) usedFont {
	NSFont *font = [NSFont fontWithName: @"Lucida Grande" size:12];
	return font;
}


@end
