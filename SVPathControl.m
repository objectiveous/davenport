#import "SVPathControl.h"
#import "SVBreadCrumbCell.h"


@implementation SVPathControl

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
    [self addPathElement:[[SVBreadCrumbCell alloc] initWithPathLabel:pathLabel]];
}

-(void)addPathElement:(SVBreadCrumbCell*)pathCell{
    [(NSMutableArray*)[self pathComponentCells] addObject:pathCell];
}

- (void)setPathComponentCells:(NSArray *)cells {
	for (SVBreadCrumbCell *cCell in cells)
		cCell.pathControl = self;

	[super setPathComponentCells: cells];
}

-(NSString*) description{
   
    NSMutableString *description = [NSMutableString stringWithString:@"STIGPathControl:"];

    
    NSArray *cells = [self pathComponentCells];
    [description appendString:@"["];
    for(SVBreadCrumbCell *cell in cells){
        [description appendString:[cell title]]; 
        [description appendString:@">"]; 
    }
    [description appendString:@"]"];
    [description appendFormat:@" cell count [%i]", [cells count]];
    return description;
}

@end
