//
//  SVSourceView.h
//  Davenport
//
//  Created by Robert Evans on 2/11/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SVSourceView : NSOutlineView {

}

@end

@interface NSObject(DisclosureTriangleAdditions)
-(BOOL)outlineView:(NSOutlineView*)outlineView shouldShowDisclosureTriangleForItem:(id)item;
@end