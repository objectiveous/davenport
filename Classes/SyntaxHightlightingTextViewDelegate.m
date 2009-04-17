#import "SyntaxHightlightingTextViewDelegate.h"


@interface SyntaxHightlightingTextViewDelegate (Private)
- (NSColor*)colorWithHexColorString:(NSString*)inColorString;
@end

@implementation SyntaxHightlightingTextViewDelegate

extern int yylex();
extern int yyleng;
extern int token_begin_loc;
extern int token_end_loc;
typedef struct yy_buffer_state *YY_BUFFER_STATE;
void yy_switch_to_buffer(YY_BUFFER_STATE);
YY_BUFFER_STATE yy_scan_string (const char *);

int yywrap()
{
  return 1;
}
// This is a comment
- (void)textDidChange:(NSNotification *)notification{
    NSTextView *textView = [notification object];
    NSTextStorage *textStorage = [textView textStorage];
    
    NSString *javascriptString = [textStorage string];
    
    [textStorage removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, [textStorage length])];
    [textStorage setFont:[NSFont fontWithName:@"Helvetica" size:16]];
    
    
    NSColor *ifWhileColor = [self colorWithHexColorString:@"1400DA"]; 
    NSColor *commentColor = [self colorWithHexColorString:@"009697"]; 
    NSColor *stringColor =  [self colorWithHexColorString:@"802552"]; 


    token_end_loc = 0;
    NSFont *font = [NSFont fontWithName:@"Helvetica" size:16];
    NSFont *newFont = [[NSFontManager sharedFontManager] convertFont:font
                                                         toHaveTrait:NSBoldFontMask];
    
    //yy_switch_to_buffer(yy_scan_string([[[textView textStorage] string] cString]));
    yy_switch_to_buffer(yy_scan_string([javascriptString cString]));

  int type = yylex();
  while (type) {
    switch (type) {
        case 1: // if = - + == 
            [textStorage addAttribute:NSForegroundColorAttributeName value:ifWhileColor range:NSMakeRange(token_begin_loc, yyleng)];
        break;
        case 2: // Strings
            [textStorage addAttribute:NSForegroundColorAttributeName value:stringColor range:NSMakeRange(token_begin_loc, yyleng)];
        break;
        case 3: // function, emit
            [textStorage addAttribute:NSForegroundColorAttributeName value:ifWhileColor range:NSMakeRange(token_begin_loc, yyleng)];
            [textStorage addAttribute:NSFontAttributeName value:newFont range:NSMakeRange(token_begin_loc, yyleng)];

        break;
        case 4: // Comments
            [textStorage addAttribute:NSForegroundColorAttributeName value:commentColor range:NSMakeRange(token_begin_loc, yyleng)];
        break;    
    }
    type = yylex();
  }
}

- (NSColor*)colorWithHexColorString:(NSString*)inColorString{
	NSColor* result    = nil;
	unsigned colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
    
	if (nil != inColorString)
	{
		NSScanner* scanner = [NSScanner scannerWithString:inColorString];
		(void) [scanner scanHexInt:&colorCode]; // ignore error
	}
	redByte   = (unsigned char)(colorCode >> 16);
	greenByte = (unsigned char)(colorCode >> 8);
	blueByte  = (unsigned char)(colorCode);     // masks off high bits
    
	result = [NSColor
              colorWithCalibratedRed:(CGFloat)redByte    / 0xff
              green:(CGFloat)greenByte / 0xff
              blue:(CGFloat)blueByte   / 0xff
              alpha:1.0];
	return result;
}

@end
