//
//  SVAbstractDescriptor.h
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SVAbstractDescriptor : NSObject {
    // A label is the text show to the user. For example, in an outline view we might 
    // display a design document named _design/numberOfJazzBands as Number Of Jazz Bands
    NSString *label;
    // Identity is the actual resource name that a Descriptor represents. For example 
    //  _design/numberOfJazzBands
    NSString *identity; 
        
    NSImage	 *nodeIcon;
}

-(id)initWithLabel:(NSString*)nodeLabel andIdentity:(NSString*)identity;

@property (retain) NSString *label;
@property (retain) NSImage  *nodeIcon;
@property (retain) NSString *identity;

@end
