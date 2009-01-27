#import "STIGPathControl.h"
#import "STIGBreadCrumbCell.h"


@implementation STIGPathControl

#pragma mark - 
- (void)awakeFromNib{
    // Without this, the NSPathControl is displayed w/ the default look & feel 
    // There may be a better way to control this. 

    [self setPathComponentCells: [NSMutableArray arrayWithObjects:nil]];
}

#pragma mark -
-(void)removeLastElement{
    [(NSMutableArray*)[self pathComponentCells] removeLastObject];
}

-(void)addPathElementUsingString:(NSString*)pathLabel{
    [self addPathElement:[[STIGBreadCrumbCell alloc] initWithPathLabel:pathLabel]];
}

-(void)addPathElement:(STIGBreadCrumbCell*)pathCell{
    [(NSMutableArray*)[self pathComponentCells] addObject:pathCell];
}

- (void)setPathComponentCells:(NSArray *)cells {
	for (STIGBreadCrumbCell *cCell in cells)
		cCell.pathControl = self;

	[super setPathComponentCells: cells];
}

-(NSString*) description{
   
    NSMutableString *description = [NSMutableString stringWithString:@"STIGPathControl:"];

    
    NSArray *cells = [self pathComponentCells];
    [description appendString:@"["];
    for(STIGBreadCrumbCell *cell in cells){
        [description appendString:[cell title]]; 
        [description appendString:@">"]; 
    }
    [description appendString:@"]"];
    [description appendFormat:@" cell count [%i]", [cells count]];
    return description;
}

@end
