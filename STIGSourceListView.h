//
//  STIGSourceListView.h
//  stigmergic
//
//  Created by Robert Evans on 12/28/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface STIGSourceListView : NSOutlineView {

}

@end

@interface NSObject(DisclosureTriangleAdditions)
-(BOOL)outlineView:(NSOutlineView*)outlineView shouldShowDisclosureTriangleForItem:(id)item;
@end