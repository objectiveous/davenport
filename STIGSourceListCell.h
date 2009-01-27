#import <Cocoa/Cocoa.h>

@interface STIGSourceListCell : NSTextFieldCell
{
@private
	NSImage *image;
}

- (void)setImage:(NSImage *)anImage;
- (NSImage*)image;

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView*)controlView;
- (NSSize)cellSize;

@end
