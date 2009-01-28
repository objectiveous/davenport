//
//  STIGAbstractDescriptor.h
//  stigmergic
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SVAbstractDescriptor : NSObject {
    NSString *label;
    NSImage	 *nodeIcon;
}

@property (retain) NSString *label;
@property (retain) NSImage *nodeIcon;


@end
